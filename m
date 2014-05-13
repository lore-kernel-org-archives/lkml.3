Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbaEMOEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:04:09 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61155 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaEMOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:04:07 -0400
Date: Tue, 13 May 2014 16:04:02 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH (Untested!)] cifs: support RENAME_NOREPLACE
Message-ID: <20140513140402.GD17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This flag gives CIFS the ability to support its native rename semantics.

Implementation is simple: just bail out before trying to hack around the
noreplace semantics.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cifs/cifsfs.c |    8 ++++++++
 fs/cifs/cifsfs.h |    4 ++--
 fs/cifs/inode.c  |   14 ++++++++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -827,6 +827,13 @@ static int cifs_setlease(struct file *fi
 		return -EAGAIN;
 }
 
+static int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
+		       struct inode *target_dir, struct dentry *target_dentry)
+{
+	return cifs_rename2(source_dir, source_dentry,
+			    target_dir, target_dentry, 0);
+}
+
 struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
@@ -845,6 +852,7 @@ const struct inode_operations cifs_dir_i
 	.mkdir = cifs_mkdir,
 	.rmdir = cifs_rmdir,
 	.rename = cifs_rename,
+	.rename2 = cifs_rename2,
 	.permission = cifs_permission,
 /*	revalidate:cifs_revalidate,   */
 	.setattr = cifs_setattr,
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -60,8 +60,8 @@ extern int cifs_hardlink(struct dentry *
 extern int cifs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 extern int cifs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int cifs_rmdir(struct inode *, struct dentry *);
-extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
-		       struct dentry *);
+extern int cifs_rename2(struct inode *, struct dentry *, struct inode *,
+			struct dentry *, unsigned int);
 extern int cifs_revalidate_file_attr(struct file *filp);
 extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1623,8 +1623,9 @@ cifs_do_rename(const unsigned int xid, s
 }
 
 int
-cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
-	    struct inode *target_dir, struct dentry *target_dentry)
+cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
+	     struct inode *target_dir, struct dentry *target_dentry,
+	     unsigned int flags)
 {
 	char *from_name = NULL;
 	char *to_name = NULL;
@@ -1636,6 +1637,9 @@ cifs_rename(struct inode *source_dir, st
 	unsigned int xid;
 	int rc, tmprc;
 
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
 	cifs_sb = CIFS_SB(source_dir->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -1663,6 +1667,12 @@ cifs_rename(struct inode *source_dir, st
 	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
 			    to_name);
 
+	/*
+	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
+	 */
+	if (flags & RENAME_NOREPLACE)
+		goto cifs_rename_exit;
+
 	if (rc == -EEXIST && tcon->unix_ext) {
 		/*
 		 * Are src and dst hardlinks of same inode? We can only tell
