Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbaEJKDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:03:53 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53147 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbaEJKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:03:49 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant
Date: Sat, 10 May 2014 12:03:19 +0200
Message-Id: <1399716199-26776-7-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399716199-26776-6-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
 <1399716199-26776-6-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per definition, a task waits on exactly one semaphore:
The semaphore from the first operation in the sop array that cannot proceed.

The Linux implementation never followed the standard, it tried to count all
semaphores that might be the reason why a task sleeps.

This patch fixes that.

Note:
The implementation assumes that GETNCNT and GETZCNT are rare operations,
therefore the code counts them only on demand.
(If they wouldn't be rare, then the non-compliance would have
been found earlier)

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 22a4c12..5e8bcde 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -993,38 +993,33 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
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
+	BUG_ON(sop->sem_flg & IPC_NOWAIT);
+	BUG_ON(sop->sem_op > 0);
 
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
+	if (sop->sem_num != semnum)
+		return 0;
+
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

