Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3EPBIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:32 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41936 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3EPBIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:16 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 09/11] ipc,msg: shorten critical region in msgsnd
Date: Wed, 15 May 2013 18:08:08 -0700
Message-Id: <1368666490-29055-10-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_msgsnd() is another function that does too many things
with the ipc object acquired. Take it only when needed when
actually updating msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 2d89b00..e60f0e0 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -700,10 +700,11 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	msg->m_type = mtype;
 	msg->m_ts = msgsz;
 
-	msq = msg_lock_check(ns, msqid);
+	rcu_read_lock();
+	msq = msq_obtain_object_check(ns, msqid);
 	if (IS_ERR(msq)) {
 		err = PTR_ERR(msq);
-		goto out_free;
+		goto out_unlock1;
 	}
 
 	for (;;) {
@@ -711,11 +712,11 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
-			goto out_unlock_free;
+			goto out_unlock1;
 
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
-			goto out_unlock_free;
+			goto out_unlock1;
 
 		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
 				1 + msq->q_qnum <= msq->q_qbytes) {
@@ -725,32 +726,41 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
 			err = -EAGAIN;
-			goto out_unlock_free;
+			goto out_unlock1;
 		}
+
+		ipc_lock_object(&msq->q_perm);
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
 			err = -EIDRM;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
 
-		msg_unlock(msq);
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
-		ipc_lock_by_ptr(&msq->q_perm);
+		rcu_read_lock();
+		ipc_lock_object(&msq->q_perm);
+
 		ipc_rcu_putref(msq);
 		if (msq->q_perm.deleted) {
 			err = -EIDRM;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
+
 		ss_del(&s);
 
 		if (signal_pending(current)) {
 			err = -ERESTARTNOHAND;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
+
+		ipc_unlock_object(&msq->q_perm);
 	}
 
+	ipc_lock_object(&msq->q_perm);
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 
@@ -766,9 +776,10 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 	err = 0;
 	msg = NULL;
 
-out_unlock_free:
-	msg_unlock(msq);
-out_free:
+out_unlock0:
+	ipc_unlock_object(&msq->q_perm);
+out_unlock1:
+	rcu_read_unlock();
 	if (msg != NULL)
 		free_msg(msg);
 	return err;
-- 
1.7.11.7

