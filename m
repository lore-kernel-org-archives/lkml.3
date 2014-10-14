Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaJNO0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:26:20 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:37294 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbaJNO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:26:16 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: [PATCH v4 4/5] fuse: Support privileged xattrs only with a mount option
Date: Tue, 14 Oct 2014 16:25:55 +0200
Message-Id: <1413296756-25071-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing unprivileged users to provide arbitrary xattrs via fuse
mounts bypasses the normal restrictions on setting xattrs. Such
mounts should be restricted to reading and writing xattrs in the
user.* namespace.

It's difficult though to tell whether a mount is being performed
on behalf of an unprivileged user since fuse mounts are ususally
done via a suid root helper. Thus a new mount option,
privileged_xattrs, is added to indicated that xattrs from other
namespaces are allowed. This option can only be supplied by
system-wide root; supplying the option as an unprivileged user
will cause the mount to fail.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/dir.c    |  9 +++++++++
 fs/fuse/fuse_i.h |  5 +++++
 fs/fuse/inode.c  | 37 ++++++++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index e3123bfbc711..1bb378aa9175 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 
 static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
 {
@@ -1882,6 +1883,10 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 	if (fc->no_setxattr)
 		return -EOPNOTSUPP;
 
+	if (!(fc->flags & FUSE_PRIVILEGED_XATTRS) &&
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1925,6 +1930,10 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
 	if (fc->no_getxattr)
 		return -EOPNOTSUPP;
 
+	if (!(fc->flags & FUSE_PRIVILEGED_XATTRS) &&
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
+		return -EOPNOTSUPP;
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 81187ba04e4a..3ea4b4db9a79 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -46,6 +46,11 @@
     doing the mount will be allowed to access the filesystem */
 #define FUSE_ALLOW_OTHER         (1 << 1)
 
+/** If the FUSE_PRIV_XATTRS flag is given, then xattrs outside the
+    user.* namespace are allowed. This option is only allowed for
+    system root. */
+#define FUSE_PRIVILEGED_XATTRS   (1 << 2)
+
 /** Number of page pointers embedded in fuse_req */
 #define FUSE_REQ_INLINE_PAGES 1
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b88b5a780228..5e00a6a76049 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -493,6 +493,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_PRIVILEGED_XATTRS,
 	OPT_ERR
 };
 
@@ -505,6 +506,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_PRIVILEGED_XATTRS,		"privileged_xattrs"},
 	{OPT_ERR,			NULL}
 };
 
@@ -540,35 +542,35 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 		switch (token) {
 		case OPT_FD:
 			if (match_int(&args[0], &value))
-				return 0;
+				return -EINVAL;
 			d->fd = value;
 			d->fd_present = 1;
 			break;
 
 		case OPT_ROOTMODE:
 			if (match_octal(&args[0], &value))
-				return 0;
+				return -EINVAL;
 			if (!fuse_valid_type(value))
-				return 0;
+				return -EINVAL;
 			d->rootmode = value;
 			d->rootmode_present = 1;
 			break;
 
 		case OPT_USER_ID:
 			if (fuse_match_uint(&args[0], &uv))
-				return 0;
+				return -EINVAL;
 			d->user_id = make_kuid(current_user_ns(), uv);
 			if (!uid_valid(d->user_id))
-				return 0;
+				return -EINVAL;
 			d->user_id_present = 1;
 			break;
 
 		case OPT_GROUP_ID:
 			if (fuse_match_uint(&args[0], &uv))
-				return 0;
+				return -EINVAL;
 			d->group_id = make_kgid(current_user_ns(), uv);
 			if (!gid_valid(d->group_id))
-				return 0;
+				return -EINVAL;
 			d->group_id_present = 1;
 			break;
 
@@ -582,26 +584,32 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 
 		case OPT_MAX_READ:
 			if (match_int(&args[0], &value))
-				return 0;
+				return -EINVAL;
 			d->max_read = value;
 			break;
 
 		case OPT_BLKSIZE:
 			if (!is_bdev || match_int(&args[0], &value))
-				return 0;
+				return -EINVAL;
 			d->blksize = value;
 			break;
 
+		case OPT_PRIVILEGED_XATTRS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			d->flags |= FUSE_PRIVILEGED_XATTRS;
+			break;
+
 		default:
-			return 0;
+			return -EINVAL;
 		}
 	}
 
 	if (!d->fd_present || !d->rootmode_present ||
 	    !d->user_id_present || !d->group_id_present)
-		return 0;
+		return -EINVAL;
 
-	return 1;
+	return 0;
 }
 
 static int fuse_show_options(struct seq_file *m, struct dentry *root)
@@ -617,6 +625,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_puts(m, ",default_permissions");
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		seq_puts(m, ",allow_other");
+	if (fc->flags & FUSE_PRIVILEGED_XATTRS)
+		seq_puts(m, ",privileged_xattrs");
 	if (fc->max_read != ~0)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
@@ -1058,7 +1068,8 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_flags &= ~(MS_NOSEC | MS_I_VERSION);
 
-	if (!parse_fuse_opt(data, &d, is_bdev))
+	err = parse_fuse_opt(data, &d, is_bdev);
+	if (err)
 		goto err;
 
 	if (is_bdev) {
-- 
2.1.0

