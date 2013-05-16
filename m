Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3EPBIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9552 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3EPBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:17 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 10/11] ipc,msg: shorten critical region in msgrcv
Date: Wed, 15 May 2013 18:08:09 -0700
Message-Id: <1368666490-29055-11-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_msgrcv() is the last msg queue function that abuses the ipc lock
Take it only when needed when actually updating msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 57 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index e60f0e0..1654be4 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -887,21 +887,19 @@ static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
 	return ERR_PTR(-EAGAIN);
 }
 
-
-long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
-	       int msgflg,
+long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgflg,
 	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
 {
-	struct msg_queue *msq;
-	struct msg_msg *msg;
 	int mode;
+	struct msg_queue *msq;
 	struct ipc_namespace *ns;
-	struct msg_msg *copy = NULL;
+	struct msg_msg *msg, *copy = NULL;
 
 	ns = current->nsproxy->ipc_ns;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+
 	if (msgflg & MSG_COPY) {
 		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 		if (IS_ERR(copy))
@@ -909,8 +907,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	}
 	mode = convert_mode(&msgtyp, msgflg);
 
-	msq = msg_lock_check(ns, msqid);
+	rcu_read_lock();
+	msq = msq_obtain_object_check(ns, msqid);
 	if (IS_ERR(msq)) {
+		rcu_read_unlock();
 		free_copy(copy);
 		return PTR_ERR(msq);
 	}
@@ -920,10 +920,9 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-			goto out_unlock;
+			goto out_unlock1;
 
 		msg = find_msg(msq, &msgtyp, mode);
-
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
@@ -931,7 +930,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			 */
 			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
-				goto out_unlock;
+				goto out_unlock1;
 			}
 			/*
 			 * If we are copying, then do not unlink message and do
@@ -939,8 +938,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			 */
 			if (msgflg & MSG_COPY) {
 				msg = copy_msg(msg, copy);
-				goto out_unlock;
+				goto out_unlock1;
 			}
+
+			ipc_lock_object(&msq->q_perm);
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -949,14 +950,17 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
 			ss_wakeup(&msq->q_senders, 0);
-			msg_unlock(msq);
-			break;
+
+			goto out_unlock0;
 		}
+
 		/* No message waiting. Wait for a message */
 		if (msgflg & IPC_NOWAIT) {
 			msg = ERR_PTR(-ENOMSG);
-			goto out_unlock;
+			goto out_unlock1;
 		}
+
+		ipc_lock_object(&msq->q_perm);
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
@@ -967,8 +971,9 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
-		msg_unlock(msq);
 
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
 		/* Lockless receive, part 1:
@@ -998,32 +1003,34 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 		 * If there is a message or an error then accept it without
 		 * locking.
 		 */
-		if (msg != ERR_PTR(-EAGAIN)) {
-			rcu_read_unlock();
-			break;
-		}
+		if (msg != ERR_PTR(-EAGAIN))
+			goto out_unlock1;
 
 		/* Lockless receive, part 3:
 		 * Acquire the queue spinlock.
 		 */
-		ipc_lock_by_ptr(&msq->q_perm);
-		rcu_read_unlock();
+		ipc_lock_object(&msq->q_perm);
 
 		/* Lockless receive, part 4:
 		 * Repeat test after acquiring the spinlock.
 		 */
 		msg = (struct msg_msg*)msr_d.r_msg;
 		if (msg != ERR_PTR(-EAGAIN))
-			goto out_unlock;
+			goto out_unlock0;
 
 		list_del(&msr_d.r_list);
 		if (signal_pending(current)) {
 			msg = ERR_PTR(-ERESTARTNOHAND);
-out_unlock:
-			msg_unlock(msq);
-			break;
+			goto out_unlock0;
 		}
+
+		ipc_unlock_object(&msq->q_perm);
 	}
+
+out_unlock0:
+	ipc_unlock_object(&msq->q_perm);
+out_unlock1:
+	rcu_read_unlock();
 	if (IS_ERR(msg)) {
 		free_copy(copy);
 		return PTR_ERR(msg);
-- 
1.7.11.7

