Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab3JPRqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761309Ab3JPRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 38/69] ipc,msg: shorten critical region in msgsnd
Date: Wed, 16 Oct 2013 10:44:47 -0700
Message-Id: <20131016174317.539988452@linuxfoundation.org>
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

commit 3dd1f784ed6603d7ab1043e51e6371235edf2313 upstream.

do_msgsnd() is another function that does too many things with the ipc
object lock acquired.  Take it only when needed when actually updating
msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -698,10 +698,11 @@ long do_msgsnd(int msqid, long mtype, vo
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
@@ -709,11 +710,11 @@ long do_msgsnd(int msqid, long mtype, vo
 
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
@@ -723,32 +724,41 @@ long do_msgsnd(int msqid, long mtype, vo
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
 
@@ -764,9 +774,10 @@ long do_msgsnd(int msqid, long mtype, vo
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


