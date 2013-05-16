Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3EPBKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:10:01 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41926 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3EPBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:15 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 06/11] ipc,msg: introduce msgctl_nolock
Date: Wed, 15 May 2013 18:08:05 -0700
Message-Id: <1368666490-29055-7-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to semctl, when calling msgctl, the *_INFO and *_STAT
commands can be performed without acquiring the ipc object.

Add a msgctl_nolock() function and move the logic of *_INFO
and *_STAT out of msgctl(). This change still takes the lock
and it will be properly lockless in the next patch

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 264ebe0..20361b5 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -469,17 +469,11 @@ out_up:
 	return err;
 }
 
-SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
+static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
+			 int cmd, int version, void __user *buf)
 {
+	int err;
 	struct msg_queue *msq;
-	int err, version;
-	struct ipc_namespace *ns;
-
-	if (msqid < 0 || cmd < 0)
-		return -EINVAL;
-
-	version = ipc_parse_version(&cmd);
-	ns = current->nsproxy->ipc_ns;
 
 	switch (cmd) {
 	case IPC_INFO:
@@ -490,6 +484,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 
 		if (!buf)
 			return -EFAULT;
+
 		/*
 		 * We must not return kernel stack data.
 		 * due to padding, it's not enough
@@ -521,7 +516,8 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+
+	case MSG_STAT:
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -565,19 +561,42 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 			return -EFAULT;
 		return success_return;
 	}
-	case IPC_SET:
-	case IPC_RMID:
-		err = msgctl_down(ns, msqid, cmd, buf, version);
-		return err;
+
 	default:
-		return  -EINVAL;
+		return -EINVAL;
 	}
 
+	return err;
 out_unlock:
 	msg_unlock(msq);
 	return err;
 }
 
+SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
+{
+	int version;
+	struct ipc_namespace *ns;
+
+	if (msqid < 0 || cmd < 0)
+		return -EINVAL;
+
+	version = ipc_parse_version(&cmd);
+	ns = current->nsproxy->ipc_ns;
+
+	switch (cmd) {
+	case IPC_INFO:
+	case MSG_INFO:
+	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+	case IPC_STAT:
+		return msgctl_nolock(ns, msqid, cmd, version, buf);
+	case IPC_SET:
+	case IPC_RMID:
+		return msgctl_down(ns, msqid, cmd, buf, version);
+	default:
+		return  -EINVAL;
+	}
+}
+
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
 	switch(mode)
-- 
1.7.11.7

