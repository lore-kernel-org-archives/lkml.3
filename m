Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab3JPSTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:19:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761365Ab3JPRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 35/69] ipc,msg: introduce msgctl_nolock
Date: Wed, 16 Oct 2013 10:44:44 -0700
Message-Id: <20131016174317.179195818@linuxfoundation.org>
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

commit 2cafed30f150f7314f98717b372df8173516cae0 upstream.

Similar to semctl, when calling msgctl, the *_INFO and *_STAT commands
can be performed without acquiring the ipc object.

Add a msgctl_nolock() function and move the logic of *_INFO and *_STAT
out of msgctl().  This change still takes the lock and it will be
properly lockless in the next patch

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msg.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -467,17 +467,11 @@ out_up:
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
@@ -488,6 +482,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 
 		if (!buf)
 			return -EFAULT;
+
 		/*
 		 * We must not return kernel stack data.
 		 * due to padding, it's not enough
@@ -519,7 +514,8 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+
+	case MSG_STAT:
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -563,19 +559,42 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
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


