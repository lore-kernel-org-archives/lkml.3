Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaERH67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:58:59 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40715 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaERH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:58:56 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 3/6] ipc/sem.c: remove code duplication
Date: Sun, 18 May 2014 09:58:34 +0200
Message-Id: <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-2-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count_semzcnt and count_semncnt are more of less identical.
The patch creates a single function that either counts the number of tasks
waiting for zero or waiting due to a decrease operation.

Compared to the initial version, the BUG_ONs were removed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 107 ++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 51 insertions(+), 56 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index dc648f8..95d5bc5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -47,8 +47,7 @@
  *   Thus: Perfect SMP scaling between independent semaphore arrays.
  *         If multiple semaphores in one array are used, then cache line
  *         trashing on the semaphore array spinlock will limit the scaling.
- * - semncnt and semzcnt are calculated on demand in count_semncnt() and
- *   count_semzcnt()
+ * - semncnt and semzcnt are calculated on demand in count_semcnt()
  * - the task that performs a successful semop() scans the list of all
  *   sleeping tasks and completes any pending operations that can be fulfilled.
  *   Semaphores are actively given to waiting tasks (necessary for FIFO).
@@ -989,6 +988,31 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
 		set_semotime(sma, sops);
 }
 
+/*
+ * check_qop: Test how often a queued operation sleeps on the semaphore semnum
+ */
+static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
+			bool count_zero)
+{
+	struct sembuf *sops = q->sops;
+	int nsops = q->nsops;
+	int i, semcnt;
+
+	semcnt = 0;
+
+	for (i = 0; i < nsops; i++) {
+		if (sops[i].sem_num != semnum)
+			continue;
+		if (sops[i].sem_flg & IPC_NOWAIT)
+			continue;
+		if (count_zero && sops[i].sem_op == 0)
+			semcnt++;
+		if (!count_zero && sops[i].sem_op < 0)
+			semcnt++;
+	}
+	return semcnt;
+}
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -998,66 +1022,37 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
  * The counts we return here are a rough approximation, but still
  * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
  */
-static int count_semncnt(struct sem_array *sma, ushort semnum)
+static int count_semcnt(struct sem_array *sma, ushort semnum,
+			bool count_zero)
 {
-	int semncnt;
+	struct list_head *l;
 	struct sem_queue *q;
+	int semcnt;
 
-	semncnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		BUG_ON(sops->sem_num != semnum);
-		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
-			semncnt++;
-	}
-
-	list_for_each_entry(q, &sma->pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op < 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semncnt++;
-	}
-	return semncnt;
-}
-
-static int count_semzcnt(struct sem_array *sma, ushort semnum)
-{
-	int semzcnt;
-	struct sem_queue *q;
+	semcnt = 0;
+	/* First: check the simple operations. They are easy to evaluate */
+	if (count_zero)
+		l = &sma->sem_base[semnum].pending_const;
+	else
+		l = &sma->sem_base[semnum].pending_alter;
 
-	semzcnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].pending_const, list) {
-		struct sembuf *sops = q->sops;
-		BUG_ON(sops->sem_num != semnum);
-		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
-			semzcnt++;
+	list_for_each_entry(q, l, list) {
+		/* all task on a per-semaphore list sleep on exactly
+		 * that semaphore
+		 */
+		semcnt++;
 	}
 
-	list_for_each_entry(q, &sma->pending_const, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op == 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semzcnt++;
-	}
+	/* Then: check the complex operations. */
 	list_for_each_entry(q, &sma->pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op == 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semzcnt++;
+		semcnt += check_qop(sma, semnum, q, count_zero);
+	}
+	if (count_zero) {
+		list_for_each_entry(q, &sma->pending_const, list) {
+			semcnt += check_qop(sma, semnum, q, count_zero);
+		}
 	}
-	return semzcnt;
+	return semcnt;
 }
 
 /* Free a semaphore set. freeary() is called with sem_ids.rwsem locked
@@ -1459,10 +1454,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		err = curr->sempid;
 		goto out_unlock;
 	case GETNCNT:
-		err = count_semncnt(sma, semnum);
+		err = count_semcnt(sma, semnum, 0);
 		goto out_unlock;
 	case GETZCNT:
-		err = count_semzcnt(sma, semnum);
+		err = count_semcnt(sma, semnum, 1);
 		goto out_unlock;
 	}
 
-- 
1.9.0

