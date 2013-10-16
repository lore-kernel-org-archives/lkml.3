Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680Ab3JPRxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:53:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934641Ab3JPRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 35/50] ipc,shm: introduce shmctl_nolock
Date: Wed, 16 Oct 2013 10:45:21 -0700
Message-Id: <20131016174402.618737988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 68eccc1dc345539d589ae78ee43b835c1a06a134 upstream.

Similar to semctl and msgctl, when calling msgctl, the *_INFO and *_STAT
commands can be performed without acquiring the ipc object.

Add a shmctl_nolock() function and move the logic of *_INFO and *_STAT out
of msgctl().  Since we are just moving functionality, this change still
takes the lock and it will be properly lockless in the next patch.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |   57 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 18 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -827,29 +827,24 @@ out_up:
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
@@ -871,10 +866,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 	{
 		struct shm_info shm_info;
 
-		err = security_shm_shmctl(NULL, cmd);
-		if (err)
-			return err;
-
 		memset(&shm_info, 0, sizeof(shm_info));
 		down_read(&shm_ids(ns).rw_mutex);
 		shm_info.used_ids = shm_ids(ns).in_use;
@@ -935,6 +926,36 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
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


