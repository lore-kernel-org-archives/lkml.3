Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaERH7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:59:15 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60587 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaERH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:59:00 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant
Date: Sun, 18 May 2014 09:58:37 +0200
Message-Id: <1400399917-17583-7-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400399917-17583-6-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-2-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-5-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-6-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SUSv4 clearly defines how semncnt and semzcnt must be calculated:
A task waits on exactly one semaphore:
The semaphore from the first operation in the sop array that cannot proceed.

The Linux implementation never followed the standard, it tried to count all
semaphores that might be the reason why a task sleeps.

This patch fixes that.

Note:
a) The implementation assumes that GETNCNT and GETZCNT are rare operations,
   therefore the code counts them only on demand.
   (If they wouldn't be rare, then the non-compliance would have
   been found earlier)

b) compared to the initial version of the patch, the BUG_ONs were removed
   and it was clarified that the new behavior conforms to SUS.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 8b5e976..71a3caf 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -993,38 +993,30 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 }
 
 /*
- * check_qop: Test how often a queued operation sleeps on the semaphore semnum
+ * check_qop: Test if a queued operation sleeps on the semaphore semnum
  */
 static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
 			bool count_zero)
 {
-	struct sembuf *sops = q->sops;
-	int nsops = q->nsops;
-	int i, semcnt;
+	struct sembuf *sop = q->blocking;
 
-	semcnt = 0;
+	if (sop->sem_num != semnum)
+		return 0;
 
-	for (i = 0; i < nsops; i++) {
-		if (sops[i].sem_num != semnum)
-			continue;
-		if (sops[i].sem_flg & IPC_NOWAIT)
-			continue;
-		if (count_zero && sops[i].sem_op == 0)
-			semcnt++;
-		if (!count_zero && sops[i].sem_op < 0)
-			semcnt++;
-	}
-	return semcnt;
+	if (count_zero && sop->sem_op == 0)
+		return 1;
+	if (!count_zero && sop->sem_op < 0)
+		return 1;
+
+	return 0;
 }
 
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
- * This model assumes that a task waits on exactly one semaphore.
- * Since semaphore operations are to be performed atomically, tasks actually
- * wait on a whole sequence of semaphores simultaneously.
- * The counts we return here are a rough approximation, but still
- * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
+ *
+ * Per definition, a task waits only on the semaphore of the first semop
+ * that cannot proceed, even if additional operation would block, too.
  */
 static int count_semcnt(struct sem_array *sma, ushort semnum,
 			bool count_zero)
-- 
1.9.0

