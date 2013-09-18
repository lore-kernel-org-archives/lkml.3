Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3IRVPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:15:48 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:49629 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3IRVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:15:45 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] sysfs: remove sysfs_addrm_cxt->parent_sd
Date: Wed, 18 Sep 2013 17:15:35 -0400
Message-Id: <1379538938-5032-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379538938-5032-1-git-send-email-tj@kernel.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_addrm_start/finish() enclose sysfs_dirent additions and
deletions and sysfs_addrm_cxt is used to record information necessary
to finish the operations.  Currently, sysfs_addrm_start() takes
@parent_sd, records it in sysfs_addrm_cxt, and assumes that all
operations in the block are performed under that @parent_sd.

This assumption has been fine until now but we want to make some
operations behave recursively and, while having @parent_sd recorded in
sysfs_addrm_cxt doesn't necessarily prevents that, it becomes
confusing.

This patch removes sysfs_addrm_cxt->parent_sd and makes
sysfs_add_one() take an explicit @parent_sd parameter.  Note that
sysfs_remove_one() doesn't need the extra argument as its parent is
always known from the target @sd.

While at it, add __acquires/releases() notations to
sysfs_addrm_start/finish() respectively.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c     | 52 +++++++++++++++++++++++++++-------------------------
 fs/sysfs/file.c    |  4 ++--
 fs/sysfs/inode.c   |  2 +-
 fs/sysfs/symlink.c |  6 +++---
 fs/sysfs/sysfs.h   | 10 +++++-----
 5 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d23e66d..6718689 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -406,22 +406,19 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 /**
  *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
  *	@acxt: pointer to sysfs_addrm_cxt to be used
- *	@parent_sd: parent sysfs_dirent
  *
- *	This function is called when the caller is about to add or
- *	remove sysfs_dirent under @parent_sd.  This function acquires
- *	sysfs_mutex.  @acxt is used to keep and pass context to
- *	other addrm functions.
+ *	This function is called when the caller is about to add or remove
+ *	sysfs_dirent.  This function acquires sysfs_mutex.  @acxt is used
+ *	to keep and pass context to other addrm functions.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).  sysfs_mutex is locked on
  *	return.
  */
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd)
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
+	__acquires(sysfs_mutex)
 {
 	memset(acxt, 0, sizeof(*acxt));
-	acxt->parent_sd = parent_sd;
 
 	mutex_lock(&sysfs_mutex);
 }
@@ -430,10 +427,11 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	__sysfs_add_one - add sysfs_dirent to parent without warning
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
+ *	@parent_sd: the parent sysfs_dirent to add @sd to
  *
- *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory and link into the
- *	children list of the parent.
+ *	Get @parent_sd and set @sd->s_parent to it and increment nlink of
+ *	the parent inode if @sd is a directory and link into the children
+ *	list of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -446,20 +444,21 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		    struct sysfs_dirent *parent_sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
-	sd->s_parent = sysfs_get(acxt->parent_sd);
+	sd->s_parent = sysfs_get(parent_sd);
 
 	ret = sysfs_link_sibling(sd);
 	if (ret)
 		return ret;
 
 	/* Update timestamps on the parent */
-	ps_iattr = acxt->parent_sd->s_iattr;
+	ps_iattr = parent_sd->s_iattr;
 	if (ps_iattr) {
 		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
@@ -493,10 +492,11 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
  *	sysfs_add_one - add sysfs_dirent to parent
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
+ *	@parent_sd: the parent sysfs_dirent to add @sd to
  *
- *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory and link into the
- *	children list of the parent.
+ *	Get @parent_sd and set @sd->s_parent to it and increment nlink of
+ *	the parent inode if @sd is a directory and link into the children
+ *	list of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -509,17 +509,18 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		  struct sysfs_dirent *parent_sd)
 {
 	int ret;
 
-	ret = __sysfs_add_one(acxt, sd);
+	ret = __sysfs_add_one(acxt, sd, parent_sd);
 	if (ret == -EEXIST) {
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
 		     "sysfs: cannot create duplicate filename '%s'\n",
 		     (path == NULL) ? sd->s_name
-				    : (sysfs_pathname(acxt->parent_sd, path),
+				    : (sysfs_pathname(parent_sd, path),
 				       strlcat(path, "/", PATH_MAX),
 				       strlcat(path, sd->s_name, PATH_MAX),
 				       path));
@@ -553,7 +554,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	sysfs_unlink_sibling(sd);
 
 	/* Update timestamps on the parent */
-	ps_iattr = acxt->parent_sd->s_iattr;
+	ps_iattr = sd->s_parent->s_iattr;
 	if (ps_iattr) {
 		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
 		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
@@ -576,6 +577,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  *	sysfs_mutex is released.
  */
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
+	__releases(sysfs_mutex)
 {
 	/* release resources acquired by sysfs_addrm_start() */
 	mutex_unlock(&sysfs_mutex);
@@ -678,8 +680,8 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd->s_dir.kobj = kobj;
 
 	/* link in */
-	sysfs_addrm_start(&acxt, parent_sd);
-	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_start(&acxt);
+	rc = sysfs_add_one(&acxt, sd, parent_sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc == 0)
@@ -772,7 +774,7 @@ static void remove_dir(struct sysfs_dirent *sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
-	sysfs_addrm_start(&acxt, sd->s_parent);
+	sysfs_addrm_start(&acxt);
 	sysfs_remove_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 }
@@ -792,7 +794,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 		return;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	sysfs_addrm_start(&acxt, dir_sd);
+	sysfs_addrm_start(&acxt);
 	pos = rb_first(&dir_sd->s_dir.children);
 	while (pos) {
 		struct sysfs_dirent *sd = to_sysfs_dirent(pos);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4697019..1656a79 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -502,8 +502,8 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	sd->s_attr.attr = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
 
-	sysfs_addrm_start(&acxt, dir_sd);
-	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_start(&acxt);
+	rc = sysfs_add_one(&acxt, sd, dir_sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 07193d7..364c887 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -326,7 +326,7 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name,
 		return -ENOENT;
 	}
 
-	sysfs_addrm_start(&acxt, dir_sd);
+	sysfs_addrm_start(&acxt);
 
 	sd = sysfs_find_dirent(dir_sd, name, ns);
 	if (sd)
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 88c8bc5..22ea2f5 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -53,11 +53,11 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
-	sysfs_addrm_start(&acxt, parent_sd);
+	sysfs_addrm_start(&acxt);
 	if (warn)
-		error = sysfs_add_one(&acxt, sd);
+		error = sysfs_add_one(&acxt, sd, parent_sd);
 	else
-		error = __sysfs_add_one(&acxt, sd);
+		error = __sysfs_add_one(&acxt, sd, parent_sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ee44fde..4d11544 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -120,7 +120,6 @@ do {								\
  * Context structure to be used while adding/removing nodes.
  */
 struct sysfs_addrm_cxt {
-	struct sysfs_dirent	*parent_sd;
 	struct sysfs_dirent	*removed;
 };
 
@@ -154,10 +153,11 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 void sysfs_put_active(struct sysfs_dirent *sd);
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd);
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
+int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		    struct sysfs_dirent *parent_sd);
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		  struct sysfs_dirent *parent_sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
-- 
1.8.3.1

