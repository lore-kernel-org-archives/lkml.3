Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaGIXmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:42:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbaGIXmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:42:10 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Thu, 10 Jul 2014 09:41:14 +1000
Subject: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140709234114.4525.46882.stgit@notabene.brown>
In-Reply-To: <20140709233541.4525.25151.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any attempt to look up a pathname that passes though an
autofs4 mount is currently forced out of RCU-walk into
REF-walk.

This can significantly hurt performance of many-thread work
loads on many-core systems, especially if the automounted
filesystem supports RCU-walk but doesn't get to benefit from
it.

So if autofs4_d_manage is called with rcu_walk set, only
fail with -ECHILD if it is necessary to wait longer than
a spinlock, and avoid even the spinlock in one trivial case.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/autofs_i.h  |    2 +-
 fs/autofs4/dev-ioctl.c |    2 +-
 fs/autofs4/expire.c    |    4 +++-
 fs/autofs4/root.c      |   44 +++++++++++++++++++++++++++++---------------
 4 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 22a280151e45..99dbb05d6148 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -148,7 +148,7 @@ void autofs4_free_ino(struct autofs_info *);
 
 /* Expiration */
 int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry);
+int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 5b570b6efa28..aaf96cb25452 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -450,7 +450,7 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 	ino = autofs4_dentry_ino(path.dentry);
 	if (ino) {
 		err = 0;
-		autofs4_expire_wait(path.dentry);
+		autofs4_expire_wait(path.dentry, 0);
 		spin_lock(&sbi->fs_lock);
 		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
 		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index a7be57e39be7..7e2f22ce6954 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -467,7 +467,7 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct dentry *dentry)
+int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -477,6 +477,8 @@ int autofs4_expire_wait(struct dentry *dentry)
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
+		if (rcu_walk)
+			return -ECHILD;
 
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cc87c1abac97..1ad119407e2f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -208,7 +208,8 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
+static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
+					      bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
@@ -225,6 +226,11 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 		struct dentry *expiring;
 		struct qstr *qstr;
 
+		if (rcu_walk) {
+			spin_unlock(&sbi->lookup_lock);
+			return ERR_PTR(-ECHILD);
+		}
+
 		ino = list_entry(p, struct autofs_info, expiring);
 		expiring = ino->dentry;
 
@@ -260,13 +266,15 @@ next:
 	return NULL;
 }
 
-static int autofs4_mount_wait(struct dentry *dentry)
+static int autofs4_mount_wait(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status = 0;
 
 	if (ino->flags & AUTOFS_INF_PENDING) {
+		if (rcu_walk)
+			return -ECHILD;
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
@@ -276,20 +284,22 @@ static int autofs4_mount_wait(struct dentry *dentry)
 	return status;
 }
 
-static int do_expire_wait(struct dentry *dentry)
+static int do_expire_wait(struct dentry *dentry, bool rcu_walk)
 {
 	struct dentry *expiring;
 
-	expiring = autofs4_lookup_expiring(dentry);
+	expiring = autofs4_lookup_expiring(dentry, rcu_walk);
+	if (IS_ERR(expiring))
+		return PTR_ERR(expiring);
 	if (!expiring)
-		return autofs4_expire_wait(dentry);
+		return autofs4_expire_wait(dentry, rcu_walk);
 	else {
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete, but the directory has been removed
 		 * so it must have been successful, just wait for it.
 		 */
-		autofs4_expire_wait(expiring);
+		autofs4_expire_wait(expiring, 0);
 		autofs4_del_expiring(expiring);
 		dput(expiring);
 	}
@@ -341,7 +351,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	 * and the directory was removed, so just go ahead and try
 	 * the mount.
 	 */
-	status = do_expire_wait(dentry);
+	status = do_expire_wait(dentry, 0);
 	if (status && status != -EAGAIN)
 		return NULL;
 
@@ -349,7 +359,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs4_mount_wait(dentry, 0);
 		if (status)
 			return ERR_PTR(status);
 		goto done;
@@ -390,7 +400,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs4_mount_wait(dentry, 0);
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_PENDING;
 		if (status) {
@@ -426,21 +436,25 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 		return 0;
 	}
 
-	/* We need to sleep, so we need pathwalk to be in ref-mode */
-	if (rcu_walk)
-		return -ECHILD;
-
 	/* Wait for pending expires */
-	do_expire_wait(dentry);
+	if (do_expire_wait(dentry, rcu_walk) == -ECHILD)
+		return -ECHILD;
 
 	/*
 	 * This dentry may be under construction so wait on mount
 	 * completion.
 	 */
-	status = autofs4_mount_wait(dentry);
+	status = autofs4_mount_wait(dentry, rcu_walk);
 	if (status)
 		return status;
 
+	if (rcu_walk)
+		/* No need to consider returning -EISDIR as
+		 * there is no risk that ->d_automount will
+		 * be called
+		 */
+		return status;
+
 	spin_lock(&sbi->fs_lock);
 	/*
 	 * If the dentry has been selected for expire while we slept


