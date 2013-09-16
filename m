Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3IPDE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:04:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:48355 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab3IPDEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:55 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>, stable@vger.kernel.org,
        #@domain.invalid, for@domain.invalid, 3.11@domain.invalid
Subject: [PATCH 3/4] ipc,msg: fix race with selinux
Date: Sun, 15 Sep 2013 20:04:36 -0700
Message-Id: <1379300677-24188-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we check msg security only under RCU. Since selinux
can free the security structure, through selinux_sem_free_security(),
we can run into a use-after-free condition. This bug only affects
msgctl syscalls, as msgsnd and msgrcv have already been updated.

The fix is obvious, make sure we hold the kern_ipc_perm.lock while
performing these security checks.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Cc: stable@vger.kernel.org # for 3.11
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index b0d541d4..06e8aae 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -414,13 +414,13 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 
 	msq = container_of(ipcp, struct msg_queue, q_perm);
 
+	ipc_lock_object(&msq->q_perm);
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
-		goto out_unlock1;
+		goto out_unlock0;
 
 	switch (cmd) {
 	case IPC_RMID:
-		ipc_lock_object(&msq->q_perm);
 		/* freeque unlocks the ipc object and rcu */
 		freeque(ns, ipcp);
 		goto out_up;
@@ -428,10 +428,9 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
-			goto out_unlock1;
+			goto out_unlock0;
 		}
 
-		ipc_lock_object(&msq->q_perm);
 		err = ipc_update_perm(&msqid64.msg_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -450,7 +449,6 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		break;
 	default:
 		err = -EINVAL;
-		goto out_unlock1;
 	}
 
 out_unlock0:
@@ -542,9 +540,12 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
 
+		ipc_lock_object(&msq->q_perm);
 		err = security_msg_queue_msgctl(msq, cmd);
-		if (err)
+		if (err) {
+			ipc_unlock_object(&msq->q_perm);
 			goto out_unlock;
+		}
 
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
@@ -556,6 +557,7 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
 		rcu_read_unlock();
+		ipc_unlock_object(&msq->q_perm);
 
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
-- 
1.7.11.7

