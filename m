Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab3FRL6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:58:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3FRLon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/93] hpfs: drop vmtruncate
Date: Tue, 18 Jun 2013 12:42:56 +0100
Message-Id: <1371555821-12820-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Stornelli <marco.stornelli@gmail.com>

commit 70b31c4c88e253f4c2066367401118edab957614 upstream.

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/hpfs/file.c    | 20 +++++++++++++-------
 fs/hpfs/hpfs_fn.h |  1 +
 fs/hpfs/inode.c   |  5 ++++-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 89d2a58..fbfe2df 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -50,7 +50,7 @@ static secno hpfs_bmap(struct inode *inode, unsigned file_secno)
 	return disk_secno;
 }
 
-static void hpfs_truncate(struct inode *i)
+void hpfs_truncate(struct inode *i)
 {
 	if (IS_IMMUTABLE(i)) return /*-EPERM*/;
 	hpfs_lock_assert(i->i_sb);
@@ -105,6 +105,16 @@ static int hpfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page,hpfs_get_block);
 }
 
+static void hpfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, to, inode->i_size);
+		hpfs_truncate(inode);
+	}
+}
+
 static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -115,11 +125,8 @@ static int hpfs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				hpfs_get_block,
 				&hpfs_i(mapping->host)->mmu_private);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		hpfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
@@ -166,6 +173,5 @@ const struct file_operations hpfs_file_ops =
 
 const struct inode_operations hpfs_file_iops =
 {
-	.truncate	= hpfs_truncate,
 	.setattr	= hpfs_setattr,
 };
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index c07ef1f..2623e7e 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -252,6 +252,7 @@ void hpfs_set_ea(struct inode *, struct fnode *, const char *,
 /* file.c */
 
 int hpfs_file_fsync(struct file *, loff_t, loff_t, int);
+void hpfs_truncate(struct inode *);
 extern const struct file_operations hpfs_file_ops;
 extern const struct inode_operations hpfs_file_iops;
 extern const struct address_space_operations hpfs_aops;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index ed671e0..4c57a50 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -274,9 +274,12 @@ int hpfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			goto out_unlock;
+
+		truncate_setsize(inode, attr->ia_size);
+		hpfs_truncate(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.8.1.2

