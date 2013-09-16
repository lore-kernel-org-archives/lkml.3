Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3IPDEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:04:54 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:48331 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3IPDEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:52 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 1/4] ipc,shm: fix race with selinux
Date: Sun, 15 Sep 2013 20:04:34 -0700
Message-Id: <1379300677-24188-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we check shm security only under RCU. Since selinux
can free the security structure, through selinux_sem_free_security(),
we can run into a use-after-free condition. This bug affects both
shmctl and shmat syscalls.

The fix is obvious, make sure we hold the kern_ipc_perm.lock while
performing these security checks.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/shm.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 2821cdf..bc3e897 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -781,18 +781,17 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
+	ipc_lock_object(&shp->shm_perm);
 	err = security_shm_shmctl(shp, cmd);
 	if (err)
-		goto out_unlock1;
+		goto out_unlock0;
 
 	switch (cmd) {
 	case IPC_RMID:
-		ipc_lock_object(&shp->shm_perm);
 		/* do_shm_rmid unlocks the ipc object and rcu */
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipc_lock_object(&shp->shm_perm);
 		err = ipc_update_perm(&shmid64.shm_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -800,7 +799,6 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 		break;
 	default:
 		err = -EINVAL;
-		goto out_unlock1;
 	}
 
 out_unlock0:
@@ -895,9 +893,12 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
 			goto out_unlock;
 
+		ipc_lock_object(&shp->shm_perm);
 		err = security_shm_shmctl(shp, cmd);
-		if (err)
+		if (err) {
+			ipc_unlock_object(&shp->shm_perm);
 			goto out_unlock;
+		}
 
 		memset(&tbuf, 0, sizeof(tbuf));
 		kernel_to_ipc64_perm(&shp->shm_perm, &tbuf.shm_perm);
@@ -909,6 +910,7 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
 		rcu_read_unlock();
+		ipc_unlock_object(&shp->shm_perm);
 
 		if (copy_shmid_to_user(buf, &tbuf, version))
 			err = -EFAULT;
@@ -960,11 +962,12 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		}
 
 		audit_ipc_obj(&(shp->shm_perm));
+
+		ipc_lock_object(&shp->shm_perm);
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
-			goto out_unlock1;
+			goto out_unlock0;
 
-		ipc_lock_object(&shp->shm_perm);
 		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			err = -EPERM;
@@ -1089,11 +1092,13 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	if (ipcperms(ns, &shp->shm_perm, acc_mode))
 		goto out_unlock;
 
+	ipc_lock_object(&shp->shm_perm);
 	err = security_shm_shmat(shp, shmaddr, shmflg);
-	if (err)
+	if (err) {
+		ipc_unlock_object(&shp->shm_perm);
 		goto out_unlock;
+	}
 
-	ipc_lock_object(&shp->shm_perm);
 	path = shp->shm_file->f_path;
 	path_get(&path);
 	shp->shm_nattch++;
-- 
1.7.11.7

