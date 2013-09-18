Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3IRVPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:15:52 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48822 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3IRVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:15:48 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] sysfs: introduce [__]sysfs_remove()
Date: Wed, 18 Sep 2013 17:15:38 -0400
Message-Id: <1379538938-5032-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379538938-5032-1-git-send-email-tj@kernel.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a sysfs_dirent, there is no reason to have multiple versions of
removal functions.  A function which removes the specified
sysfs_dirent and its descendants is enough.

This patch intorduces [__}sysfs_remove() which replaces all internal
variations of removal functions.  This will be the only removal
function in the planned new sysfs_dirent based interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c   | 47 ++++++++++++++++++++++++-----------------------
 fs/sysfs/group.c |  4 ++--
 fs/sysfs/inode.c |  2 +-
 fs/sysfs/sysfs.h |  4 ++--
 4 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0cdfd81..b518afd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -545,7 +545,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
  *	LOCKING:
  *	Determined by sysfs_addrm_start().
  */
-void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+static void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
+			     struct sysfs_dirent *sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 
@@ -775,20 +776,6 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setxattr	= sysfs_setxattr,
 };
 
-static void remove_dir(struct sysfs_dirent *sd)
-{
-	struct sysfs_addrm_cxt acxt;
-
-	sysfs_addrm_start(&acxt);
-	sysfs_remove_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
-}
-
-void sysfs_remove_subdir(struct sysfs_dirent *sd)
-{
-	remove_dir(sd);
-}
-
 static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
 {
 	struct sysfs_dirent *last;
@@ -844,25 +831,36 @@ static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
 	return pos->s_parent;
 }
 
-static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
+void __sysfs_remove(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *pos, *next;
 
-	if (!dir_sd)
+	if (!sd)
 		return;
 
-	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	sysfs_addrm_start(&acxt);
+	pr_debug("sysfs %s: removing\n", sd->s_name);
 
 	next = NULL;
 	do {
 		pos = next;
-		next = sysfs_next_descendant_post(pos, dir_sd);
+		next = sysfs_next_descendant_post(pos, sd);
 		if (pos)
-			sysfs_remove_one(&acxt, pos);
+			sysfs_remove_one(acxt, pos);
 	} while (next);
+}
 
+/**
+ * sysfs_remove - remove a sysfs_dirent recursively
+ * @sd: the sysfs_dirent to remove
+ *
+ * Remove @sd along with all its subdirectories and files.
+ */
+void sysfs_remove(struct sysfs_dirent *sd)
+{
+	struct sysfs_addrm_cxt acxt;
+
+	sysfs_addrm_start(&acxt);
+	__sysfs_remove(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 }
 
@@ -882,7 +880,10 @@ void sysfs_remove_dir(struct kobject *kobj)
 	kobj->sd = NULL;
 	spin_unlock(&sysfs_assoc_lock);
 
-	__sysfs_remove_dir(sd);
+	if (sd) {
+		WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
+		sysfs_remove(sd);
+	}
 }
 
 int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 2dae55c..1898a10 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -111,7 +111,7 @@ static int internal_create_group(struct kobject *kobj, int update,
 	error = create_files(sd, kobj, grp, update);
 	if (error) {
 		if (grp->name)
-			sysfs_remove_subdir(sd);
+			sysfs_remove(sd);
 	}
 	sysfs_put(sd);
 	return error;
@@ -219,7 +219,7 @@ void sysfs_remove_group(struct kobject *kobj,
 
 	remove_files(sd, kobj, grp);
 	if (grp->name)
-		sysfs_remove_subdir(sd);
+		sysfs_remove(sd);
 
 	sysfs_put(sd);
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 364c887..63f755e 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -330,7 +330,7 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
 
 	sd = sysfs_find_dirent(dir_sd, name, ns);
 	if (sd)
-		sysfs_remove_one(&acxt, sd);
+		__sysfs_remove(&acxt, sd);
 
 	sysfs_addrm_finish(&acxt);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4d11544..4b1d825 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -158,7 +158,8 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		    struct sysfs_dirent *parent_sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
-void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void __sysfs_remove(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void sysfs_remove(struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
@@ -170,7 +171,6 @@ void release_sysfs_dirent(struct sysfs_dirent *sd);
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
-void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
 int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent_sd,
 		 const char *new_name, const void *new_ns);
-- 
1.8.3.1

