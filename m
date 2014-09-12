Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaILOnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:43:18 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48384 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaILOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:42:24 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 4/4] fuse: Add support for mounts from user namespaces
Date: Fri, 12 Sep 2014 09:41:45 -0500
Message-Id: <1410532905-114262-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update fuse to support mounts from within user namespaces. This
is mostly a matter of translating uids and gids into the
namespace of the process reading requests before handing the
requests off to userspace.

Due to security concerns the namespace used should be fixed,
otherwise a user might be able to pass the fuse fd to
init_user_ns and inject suid files owned by a user outside the
namespace in order to gain elevated privileges. For fuse we
stash current_user_ns() when a filesystem is first mounted and
abort the mount if this namespace is different than the one used
to open the fd passed in the mount options.

The allow_others options could also be a problem, as a userns
mount could bypass system policy for this option and thus open
the possiblity of DoS attacks. This is prevented by restricting
the scope of allow_other to apply only to that superblock's
userns and its children, giving the expected behavior within the
userns while preventing DoS attacks on more privileged contexts.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
---
 fs/fuse/dev.c    |  4 ++--
 fs/fuse/dir.c    | 46 +++++++++++++++++++++++++++++++++-------------
 fs/fuse/fuse_i.h |  4 ++++
 fs/fuse/inode.c  | 28 ++++++++++++++++++++--------
 4 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 839caebd34f1..03c8785ed731 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -127,8 +127,8 @@ static void __fuse_put_request(struct fuse_req *req)
 
 static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
-	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
-	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
+	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
+	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
 	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 }
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index de1d84af9f7c..c0b9968db6a1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -905,8 +905,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	stat->ino = attr->ino;
 	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	stat->nlink = attr->nlink;
-	stat->uid = make_kuid(&init_user_ns, attr->uid);
-	stat->gid = make_kgid(&init_user_ns, attr->gid);
+	stat->uid = make_kuid(fc->user_ns, attr->uid);
+	stat->gid = make_kgid(fc->user_ns, attr->gid);
 	stat->rdev = inode->i_rdev;
 	stat->atime.tv_sec = attr->atime;
 	stat->atime.tv_nsec = attr->atimensec;
@@ -1085,12 +1085,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
  */
 int fuse_allow_current_process(struct fuse_conn *fc)
 {
-	const struct cred *cred;
+	const struct cred *cred = current_cred();
 
-	if (fc->flags & FUSE_ALLOW_OTHER)
-		return 1;
+	if (fc->flags & FUSE_ALLOW_OTHER) {
+		if (kuid_has_mapping(fc->user_ns, cred->euid) &&
+		    kuid_has_mapping(fc->user_ns, cred->suid) &&
+		    kuid_has_mapping(fc->user_ns, cred->uid) &&
+		    kgid_has_mapping(fc->user_ns, cred->egid) &&
+		    kgid_has_mapping(fc->user_ns, cred->sgid) &&
+		    kgid_has_mapping(fc->user_ns, cred->gid))
+			return 1;
+
+		return 0;
+	}
 
-	cred = current_cred();
 	if (uid_eq(cred->euid, fc->user_id) &&
 	    uid_eq(cred->suid, fc->user_id) &&
 	    uid_eq(cred->uid,  fc->user_id) &&
@@ -1556,17 +1564,25 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
-			   bool trust_local_cmtime)
+static int iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
+			   struct fuse_setattr_in *arg, bool trust_local_cmtime)
 {
 	unsigned ivalid = iattr->ia_valid;
 
 	if (ivalid & ATTR_MODE)
 		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
-	if (ivalid & ATTR_UID)
-		arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
-	if (ivalid & ATTR_GID)
-		arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
+	if (ivalid & ATTR_UID) {
+		arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
+		if (arg->uid == (uid_t)-1)
+			return -EINVAL;
+		arg->valid |= FATTR_UID;
+	}
+	if (ivalid & ATTR_GID) {
+		arg->gid = from_kgid(fc->user_ns, iattr->ia_gid);
+		if (arg->gid == (gid_t)-1)
+			return -EINVAL;
+		arg->valid |= FATTR_GID;
+	}
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
 	if (ivalid & ATTR_ATIME) {
@@ -1588,6 +1604,8 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
 		arg->ctime = iattr->ia_ctime.tv_sec;
 		arg->ctimensec = iattr->ia_ctime.tv_nsec;
 	}
+
+	return 0;
 }
 
 /*
@@ -1741,7 +1759,9 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg, trust_local_cmtime);
+	err = iattr_to_fattr(fc, attr, &inarg, trust_local_cmtime);
+	if (err)
+		goto error;
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a3ded071e2c6..2cfd0ca3407a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -22,6 +22,7 @@
 #include <linux/rbtree.h>
 #include <linux/poll.h>
 #include <linux/workqueue.h>
+#include <linux/user_namespace.h>
 #include <linux/pid_namespace.h>
 
 /** Max number of pages that can be used in a single read request */
@@ -387,6 +388,9 @@ struct fuse_conn {
 	/** The group id for this mount */
 	kgid_t group_id;
 
+	/** The user namespace for this mount */
+	struct user_namespace *user_ns;
+
 	/** The pid namespace for this mount */
 	struct pid_namespace *pid_ns;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index c6d8473b1a80..f3a3ded82f85 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -167,8 +167,8 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	inode->i_ino     = fuse_squash_ino(attr->ino);
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	set_nlink(inode, attr->nlink);
-	inode->i_uid     = make_kuid(&init_user_ns, attr->uid);
-	inode->i_gid     = make_kgid(&init_user_ns, attr->gid);
+	inode->i_uid     = make_kuid(fc->user_ns, attr->uid);
+	inode->i_gid     = make_kgid(fc->user_ns, attr->gid);
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
@@ -496,6 +496,8 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
 	d->blksize = FUSE_DEFAULT_BLKSIZE;
+	d->user_id = make_kuid(current_user_ns(), 0);
+	d->group_id = make_kgid(current_user_ns(), 0);
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -578,8 +580,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 	struct super_block *sb = root->d_sb;
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 
-	seq_printf(m, ",user_id=%u", from_kuid_munged(&init_user_ns, fc->user_id));
-	seq_printf(m, ",group_id=%u", from_kgid_munged(&init_user_ns, fc->group_id));
+	seq_printf(m, ",user_id=%u",
+		   from_kuid_munged(fc->user_ns, fc->user_id));
+	seq_printf(m, ",group_id=%u",
+		   from_kgid_munged(fc->user_ns, fc->group_id));
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
 		seq_puts(m, ",default_permissions");
 	if (fc->flags & FUSE_ALLOW_OTHER)
@@ -618,6 +622,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
+	fc->user_ns = get_user_ns(current_user_ns());
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -956,6 +961,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 static void fuse_free_conn(struct fuse_conn *fc)
 {
 	put_pid_ns(fc->pid_ns);
+	put_user_ns(fc->user_ns);
 	kfree_rcu(fc, rcu);
 }
 
@@ -1042,8 +1048,14 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (!file)
 		goto err;
 
-	if ((file->f_op != &fuse_dev_operations) ||
-	    (file->f_cred->user_ns != &init_user_ns))
+	/*
+	 * Require mount to happen from the same user namespace which
+	 * opened /dev/fuse, otherwise users might be able to
+	 * elevate privileges by opening in init_user_ns then
+	 * mounting from a different namespace without MNT_NOSUID.
+	 */
+	if (file->f_op != &fuse_dev_operations ||
+	    file->f_cred->user_ns != current_user_ns())
 		goto err_fput;
 
 	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
@@ -1157,7 +1169,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
@@ -1189,7 +1201,7 @@ static struct file_system_type fuseblk_fs_type = {
 	.name		= "fuseblk",
 	.mount		= fuse_mount_blk,
 	.kill_sb	= fuse_kill_sb_blk,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fuseblk");
 
-- 
1.9.1

