Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab3JPSNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:13:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761447Ab3JPRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 39/69] ipc,msg: shorten critical region in msgrcv
Date: Wed, 16 Oct 2013 10:44:48 -0700
Message-Id: <20131016174317.670343227@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 41a0d523d0f626e9da0dc01de47f1b89058033cf upstream.

do_msgrcv() is the last msg queue function that abuses the ipc lock Take
it only when needed when actually updating msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   58 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -886,21 +886,19 @@ static struct msg_msg *find_msg(struct m
 	return found ?: ERR_PTR(-EAGAIN);
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
@@ -908,8 +906,10 @@ long do_msgrcv(int msqid, void __user *b
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
@@ -919,10 +919,10 @@ long do_msgrcv(int msqid, void __user *b
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-			goto out_unlock;
+			goto out_unlock1;
 
+		ipc_lock_object(&msq->q_perm);
 		msg = find_msg(msq, &msgtyp, mode);
-
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
@@ -930,7 +930,7 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
-				goto out_unlock;
+				goto out_unlock0;
 			}
 			/*
 			 * If we are copying, then do not unlink message and do
@@ -938,8 +938,9 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if (msgflg & MSG_COPY) {
 				msg = copy_msg(msg, copy);
-				goto out_unlock;
+				goto out_unlock0;
 			}
+
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -948,14 +949,16 @@ long do_msgrcv(int msqid, void __user *b
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
+			goto out_unlock0;
 		}
+
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
@@ -966,8 +969,9 @@ long do_msgrcv(int msqid, void __user *b
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
-		msg_unlock(msq);
 
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
 		/* Lockless receive, part 1:
@@ -978,7 +982,7 @@ long do_msgrcv(int msqid, void __user *b
 		 * Prior to destruction, expunge_all(-EIRDM) changes r_msg.
 		 * Thus if r_msg is -EAGAIN, then the queue not yet destroyed.
 		 * rcu_read_lock() prevents preemption between reading r_msg
-		 * and the spin_lock() inside ipc_lock_by_ptr().
+		 * and acquiring the q_perm.lock in ipc_lock_object().
 		 */
 		rcu_read_lock();
 
@@ -997,32 +1001,34 @@ long do_msgrcv(int msqid, void __user *b
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


