Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbaGNTTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:19:54 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:45530 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbaGNTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:19:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 3/3] fuse: Allow mounts from user namespaces
Date: Mon, 14 Jul 2014 14:18:16 -0500
Message-Id: <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update fuse to allow mounts from user namespaces. During mount
current_user_ns() is stashed away, and this is used for all uid
and gid mappings. The restriction on mounting from only
init_user_ns is lifted, and the FS_USERNS_MOUNT flag is added to
the flags for the fuse fs type (but not for fuseblk).

The allow_others option becomes a problem when allowing mounts
from user namespaces as it could allow users to override system
policy for this option, however prohibiting this option in
namespaces may limit the utility of fuse in containers. Here we
compromise by permitting allow_other in user namespaces but
restricting filesystem access to users in that namespace and its
children. This gives the expected behavior in containers without
allowing DoS attacks on more priveleged contexts.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/dev.c    |  4 ++--
 fs/fuse/dir.c    | 30 +++++++++++++++++++-----------
 fs/fuse/fuse_i.h |  4 ++++
 fs/fuse/inode.c  | 19 ++++++++++++-------
 4 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index db781ff6392b..18f2d9a0eb30 100644
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
index 42198359fa1b..9895b342b7c0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -904,8 +904,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
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
@@ -1084,12 +1084,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
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
@@ -1555,17 +1563,17 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
-			   bool trust_local_cmtime)
+static void iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
+			   struct fuse_setattr_in *arg, bool trust_local_cmtime)
 {
 	unsigned ivalid = iattr->ia_valid;
 
 	if (ivalid & ATTR_MODE)
 		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
 	if (ivalid & ATTR_UID)
-		arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
+		arg->valid |= FATTR_UID,    arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
 	if (ivalid & ATTR_GID)
-		arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
+		arg->valid |= FATTR_GID,    arg->gid = from_kgid(fc->user_ns, iattr->ia_gid);
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
 	if (ivalid & ATTR_ATIME) {
@@ -1740,7 +1748,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg, trust_local_cmtime);
+	iattr_to_fattr(fc, attr, &inarg, trust_local_cmtime);
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
index 3655152f770d..14fc96e0b408 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -166,8 +166,8 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
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
@@ -484,6 +484,8 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
 	d->blksize = FUSE_DEFAULT_BLKSIZE;
+	d->user_id = make_kuid(current_user_ns(), 0);
+	d->group_id = make_kgid(current_user_ns(), 0);
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -565,8 +567,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
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
@@ -604,6 +608,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->initialized = 0;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	fc->user_ns = get_user_ns(current_user_ns());
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
@@ -945,6 +950,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 
 static void fuse_free_conn(struct fuse_conn *fc)
 {
+	put_user_ns(fc->user_ns);
 	put_pid_ns(fc->pid_ns);
 	kfree_rcu(fc, rcu);
 }
@@ -1032,8 +1038,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (!file)
 		goto err;
 
-	if ((file->f_op != &fuse_dev_operations) ||
-	    (file->f_cred->user_ns != &init_user_ns))
+	if (file->f_op != &fuse_dev_operations)
 		goto err_fput;
 
 	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
@@ -1147,7 +1152,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
-- 
1.9.1

