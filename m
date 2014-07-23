Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaGWNQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:16:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60009 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbaGWNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:16:03 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Steve French <smfrench@gmail.com>
Subject: [PATCH 7/7] cifs: support RENAME_NOREPLACE
Date: Wed, 23 Jul 2014 15:15:36 +0200
Message-Id: <1406121336-1379-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This flag gives CIFS the ability to support its native rename semantics.

Implementation is simple: just bail out before trying to hack around the
noreplace semantics.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steve French <smfrench@gmail.com>
---
 fs/cifs/cifsfs.c |  2 +-
 fs/cifs/cifsfs.h |  4 ++--
 fs/cifs/inode.c  | 14 ++++++++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 888398067420..ac4f260155c8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -848,7 +848,7 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.link = cifs_hardlink,
 	.mkdir = cifs_mkdir,
 	.rmdir = cifs_rmdir,
-	.rename = cifs_rename,
+	.rename2 = cifs_rename2,
 	.permission = cifs_permission,
 /*	revalidate:cifs_revalidate,   */
 	.setattr = cifs_setattr,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 70f178a7c759..ed58c88f5f5d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -68,8 +68,8 @@ extern int cifs_hardlink(struct dentry *, struct inode *, struct dentry *);
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
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a174605f6afa..bec0a0831be6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1627,8 +1627,9 @@ do_rename_exit:
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
@@ -1640,6 +1641,9 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	unsigned int xid;
 	int rc, tmprc;
 
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
 	cifs_sb = CIFS_SB(source_dir->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -1667,6 +1671,12 @@ cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
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
-- 
1.8.1.4

