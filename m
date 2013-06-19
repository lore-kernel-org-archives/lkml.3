Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab3FSBSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:18:54 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48274 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:18:52 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 04/11] ipc,shm: introduce shmctl_nolock
Date: Tue, 18 Jun 2013 18:18:29 -0700
Message-Id: <1371604716-3439-5-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
References: <1371604716-3439-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to semctl and msgctl, when calling msgctl, the *_INFO and *_STAT commands
can be performed without acquiring the ipc object.

Add a shmctl_nolock() function and move the logic of *_INFO and *_STAT out of
msgctl(). Since we are just moving functionality, this change still takes the
lock and it will be properly lockless in the next patch.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/shm.c | 57 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 22cffd7..3e12398 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -820,29 +820,24 @@ out_up:
 	return err;
 }
 
-SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
+static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
+			 int cmd, int version, void __user *buf)
 {
+	int err;
 	struct shmid_kernel *shp;
-	int err, version;
-	struct ipc_namespace *ns;
 
-	if (cmd < 0 || shmid < 0) {
-		err = -EINVAL;
-		goto out;
+	/* preliminary security checks for *_INFO */
+	if (cmd == IPC_INFO || cmd == SHM_INFO) {
+		err = security_shm_shmctl(NULL, cmd);
+		if (err)
+			return err;
 	}
 
-	version = ipc_parse_version(&cmd);
-	ns = current->nsproxy->ipc_ns;
-
-	switch (cmd) { /* replace with proc interface ? */
+	switch (cmd) {
 	case IPC_INFO:
 	{
 		struct shminfo64 shminfo;
 
-		err = security_shm_shmctl(NULL, cmd);
-		if (err)
-			return err;
-
 		memset(&shminfo, 0, sizeof(shminfo));
 		shminfo.shmmni = shminfo.shmseg = ns->shm_ctlmni;
 		shminfo.shmmax = ns->shm_ctlmax;
@@ -864,10 +859,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	{
 		struct shm_info shm_info;
 
-		err = security_shm_shmctl(NULL, cmd);
-		if (err)
-			return err;
-
 		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
@@ -928,6 +919,36 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			err = result;
 		goto out;
 	}
+	default:
+		return -EINVAL;
+	}
+
+out_unlock:
+	shm_unlock(shp);
+out:
+	return err;
+}
+
+SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
+{
+	struct shmid_kernel *shp;
+	int err, version;
+	struct ipc_namespace *ns;
+
+	if (cmd < 0 || shmid < 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	version = ipc_parse_version(&cmd);
+	ns = current->nsproxy->ipc_ns;
+
+	switch (cmd) {
+	case IPC_INFO:
+	case SHM_INFO:
+	case SHM_STAT:
+	case IPC_STAT:
+		return shmctl_nolock(ns, shmid, cmd, version, buf);
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
-- 
1.7.11.7

