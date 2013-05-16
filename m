Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3EPBIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:25 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34834 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3EPBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:15 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 05/11] ipc,msg: shorten critical region in msgctl_down
Date: Wed, 15 May 2013 18:08:04 -0700
Message-Id: <1368666490-29055-6-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of holding the ipc lock for the entire function, use
the ipcctl_pre_down_nolock and only acquire the lock for
specific commands: RMID and SET.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 4eaeb08..264ebe0 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -412,11 +412,10 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 	down_write(&msg_ids(ns).rw_mutex);
 	rcu_read_lock();
 
-	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
-			       &msqid64.msg_perm, msqid64.msg_qbytes);
+	ipcp = ipcctl_pre_down_nolock(ns, &msg_ids(ns), msqid, cmd,
+				      &msqid64.msg_perm, msqid64.msg_qbytes);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
@@ -424,10 +423,11 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
-		goto out_unlock0;
+		goto out_unlock1;
 
 	switch (cmd) {
 	case IPC_RMID:
+		ipc_lock_object(&msq->q_perm);
 		/* freeque unlocks the ipc object and rcu */
 		freeque(ns, ipcp);
 		goto out_up;
@@ -435,9 +435,10 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
-			goto out_unlock0;
+			goto out_unlock1;
 		}
 
+		ipc_lock_object(&msq->q_perm);
 		err = ipc_update_perm(&msqid64.msg_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -456,6 +457,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		break;
 	default:
 		err = -EINVAL;
+		goto out_unlock1;
 	}
 
 out_unlock0:
-- 
1.7.11.7

