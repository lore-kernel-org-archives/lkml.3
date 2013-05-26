Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3EZJKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:10:19 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62027 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3EZJKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:10:17 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/4] ipc/sem.c: Fix missing wakeups in do_smart_update_queue()
Date: Sun, 26 May 2013 11:08:52 +0200
Message-Id: <1369559335-13491-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_smart_update_queue() is called when an operation
(semop, semctl(SETVAL), semctl(SETALL), ...) modified the array.
It must check which of the sleeping tasks can proceed.

do_smart_update_queue() missed a few wakeups:
- if a sleeping complex op was completed, then all per-semaphore queues
  must be scanned - not only those that were modified by *sops
- if a sleeping simple op proceeded, then the global queue
  must be scanned again

And:
- the test for "|sops == NULL) before scanning the global
  queue is not required: If the global queue is empty, then
  it doesn't need to be scanned - regardless of the reason
  for calling do_smart_update_queue()

The patch is not optimized, i.e. even completing a wait-for-zero
operation causes a rescan. This is done to keep the patch as simple as
possible.
Avoiding unnecessary scans is implemented in the following patches.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index a7e40ed..70480a3 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -752,19 +752,29 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 			int otime, struct list_head *pt)
 {
 	int i;
+	int progress;
 
-	if (sma->complex_count || sops == NULL) {
-		if (update_queue(sma, -1, pt))
+	progress = 1;
+retry_global:
+	if (sma->complex_count) {
+		if (update_queue(sma, -1, pt)) {
+			progress = 1;
 			otime = 1;
+			sops = NULL;
+		}
 	}
+	if (!progress)
+		goto done;
 
 	if (!sops) {
 		/* No semops; something special is going on. */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			if (update_queue(sma, i, pt))
+			if (update_queue(sma, i, pt)) {
 				otime = 1;
+				progress = 1;
+			}
 		}
-		goto done;
+		goto done_checkretry;
 	}
 
 	/* Check the semaphores that were modified. */
@@ -772,8 +782,15 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
 				sma->sem_base[sops[i].sem_num].semval == 0))
-			if (update_queue(sma, sops[i].sem_num, pt))
+			if (update_queue(sma, sops[i].sem_num, pt)) {
 				otime = 1;
+				progress = 1;
+			}
+	}
+done_checkretry:
+	if (progress) {
+		progress = 0;
+		goto retry_global;
 	}
 done:
 	if (otime)
-- 
1.8.1.4

