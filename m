Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3EPBJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:09:39 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34842 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3EPBIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:16 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 08/11] ipc,msg: make msgctl_nolock lockless
Date: Wed, 15 May 2013 18:08:07 -0700
Message-Id: <1368666490-29055-9-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the INFO cmd doesn't take the ipc lock, the STAT
commands do acquire it unnecessarily. We can do the
permissions and security checks only holding the
rcu lock.

This function now mimics semctl_nolock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 9ff295b..2d89b00 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -547,17 +547,25 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		if (!buf)
 			return -EFAULT;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
+		rcu_read_lock();
 		if (cmd == MSG_STAT) {
-			msq = msg_lock(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = msq->q_perm.id;
 		} else {
-			msq = msg_lock_check(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object_check(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = 0;
 		}
+
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
@@ -566,8 +574,6 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -577,7 +583,8 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		tbuf.msg_qbytes = msq->q_qbytes;
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
-		msg_unlock(msq);
+		rcu_read_unlock();
+
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
 		return success_return;
@@ -589,7 +596,7 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 
 	return err;
 out_unlock:
-	msg_unlock(msq);
+	rcu_read_unlock();
 	return err;
 }
 
-- 
1.7.11.7

