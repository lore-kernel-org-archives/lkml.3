Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaEMU21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:28:27 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49093 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaEMU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ipc,msg: always respect MSG_NOERROR
Date: Tue, 13 May 2014 13:27:35 -0700
Message-Id: <1400012857-11733-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When specifying the MSG_NOERROR flag, receivers can avoid returning
error (E2BIG) and just truncate the message text, if it is too large.

Currently, this logic is only respected when there are already pending
messages in the queue. Fix this for the case when there are only
receivers waiting for a msg to be sent. In order for this to work, save
the flags in the msg_receiver struct as it must be used later when
doing the pipeline send.

Also do some pipeline_send() cleanups while at it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 65 +++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 6d33e30..c2cdb5b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -50,6 +50,7 @@ struct msg_receiver {
 	struct task_struct	*r_tsk;
 
 	int			r_mode;
+	int                     r_msgflg;
 	long			r_msgtype;
 	long			r_maxsize;
 
@@ -562,42 +563,47 @@ static int testmsg(struct msg_msg *msg, long type, int mode)
 	return 0;
 }
 
-static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
+static inline bool pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 {
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		if (testmsg(msg, msr->r_msgtype, msr->r_mode) &&
-		    !security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
-					       msr->r_msgtype, msr->r_mode)) {
-
-			list_del(&msr->r_list);
-			if (msr->r_maxsize < msg->m_ts) {
-				/* initialize pipelined send ordering */
-				msr->r_msg = NULL;
-				wake_up_process(msr->r_tsk);
-				smp_mb(); /* see barrier comment below */
-				msr->r_msg = ERR_PTR(-E2BIG);
-			} else {
-				msr->r_msg = NULL;
-				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
-				msq->q_rtime = get_seconds();
-				wake_up_process(msr->r_tsk);
-				/*
-				 * Ensure that the wakeup is visible before
-				 * setting r_msg, as the receiving end depends
-				 * on it. See lockless receive part 1 and 2 in
-				 * do_msgrcv().
-				 */
-				smp_mb();
-				msr->r_msg = msg;
-
-				return 1;
-			}
+		if (!testmsg(msg, msr->r_msgtype, msr->r_mode))
+			continue;
+		if (security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
+					      msr->r_msgtype, msr->r_mode))
+			continue;
+
+		/* found a suitable receiver, time to dequeue and wake */
+		list_del(&msr->r_list);
+
+		/* initialize pipelined send ordering */
+		msr->r_msg = NULL;
+
+		if (msr->r_maxsize < msg->m_ts &&
+		    !(msr->r_msgflg & MSG_NOERROR)) {
+			wake_up_process(msr->r_tsk);
+			smp_mb(); /* see barrier comment below */
+			msr->r_msg = ERR_PTR(-E2BIG);
+		} else {
+			msq->q_lrpid = task_pid_vnr(msr->r_tsk);
+			msq->q_rtime = get_seconds();
+			wake_up_process(msr->r_tsk);
+
+			/*
+			 * Ensure that the wakeup is visible before
+			 * setting r_msg, as the receiving end depends
+			 * on it. See lockless receive part 1 and 2 in
+			 * do_msgrcv().
+			 */
+			smp_mb();
+			msr->r_msg = msg;
+
+			return true;
 		}
 	}
 
-	return 0;
+	return false; /* no receivers on the other side */
 }
 
 long do_msgsnd(int msqid, long mtype, void __user *mtext,
@@ -901,6 +907,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
+		msr_d.r_msgflg = msgflg;
 		msr_d.r_mode = mode;
 		if (msgflg & MSG_NOERROR)
 			msr_d.r_maxsize = INT_MAX;
-- 
1.8.1.4

