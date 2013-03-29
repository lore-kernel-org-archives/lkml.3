Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3C2VpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:45:00 -0400
Received: from mail.ispras.ru ([83.149.199.45]:49210 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab3C2Vo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:44:59 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] hfs: add error checking for hfs_find_init()
Date: Sat, 30 Mar 2013 01:44:47 +0400
Message-Id: <1364593487-11034-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfs_find_init() may fail with ENOMEM, but there are places,
where the returned value is not checked. The consequences can be
very unpleasant, e.g. kfree uninitialized pointer and
inappropriate mutex unlocking.

The patch adds checks for errors in hfs_find_init().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfs/catalog.c |   12 +++++++++---
 fs/hfs/dir.c     |    8 ++++++--
 fs/hfs/extent.c  |   48 +++++++++++++++++++++++++++++++++---------------
 fs/hfs/hfs_fs.h  |    2 +-
 fs/hfs/inode.c   |   11 +++++++++--
 fs/hfs/super.c   |    4 +++-
 6 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index 424b033..9569b39 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -92,7 +92,9 @@ int hfs_cat_create(u32 cnid, struct inode *dir, struct qstr *str, struct inode *
 		return -ENOSPC;
 
 	sb = dir->i_sb;
-	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	if (err)
+		return err;
 
 	hfs_cat_build_key(sb, fd.search_key, cnid, NULL);
 	entry_size = hfs_cat_build_thread(sb, &entry, S_ISDIR(inode->i_mode) ?
@@ -214,7 +216,9 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, struct qstr *str)
 
 	dprint(DBG_CAT_MOD, "delete_cat: %s,%u\n", str ? str->name : NULL, cnid);
 	sb = dir->i_sb;
-	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	res = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	if (res)
+		return res;
 
 	hfs_cat_build_key(sb, fd.search_key, dir->i_ino, str);
 	res = hfs_brec_find(&fd);
@@ -281,7 +285,9 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
 	dprint(DBG_CAT_MOD, "rename_cat: %u - %lu,%s - %lu,%s\n", cnid, src_dir->i_ino, src_name->name,
 		dst_dir->i_ino, dst_name->name);
 	sb = src_dir->i_sb;
-	hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
+	err = hfs_find_init(HFS_SB(sb)->cat_tree, &src_fd);
+	if (err)
+		return err;
 	dst_fd = src_fd;
 
 	/* find the old dir entry and read the data */
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 5f7f1ab..e1c8048 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -25,7 +25,9 @@ static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	int res;
 
-	hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
+	res = hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
+	if (res)
+		return ERR_PTR(res);
 	hfs_cat_build_key(dir->i_sb, fd.search_key, dir->i_ino, &dentry->d_name);
 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
 	if (res) {
@@ -63,7 +65,9 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	if (filp->f_pos >= inode->i_size)
 		return 0;
 
-	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	err = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	if (err)
+		return err;
 	hfs_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
 	err = hfs_brec_find(&fd);
 	if (err)
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index a67955a..813447b 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -107,7 +107,7 @@ static u16 hfs_ext_lastblock(struct hfs_extent *ext)
 	return be16_to_cpu(ext->block) + be16_to_cpu(ext->count);
 }
 
-static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
+static int __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
 {
 	int res;
 
@@ -116,26 +116,31 @@ static void __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd
 	res = hfs_brec_find(fd);
 	if (HFS_I(inode)->flags & HFS_FLG_EXT_NEW) {
 		if (res != -ENOENT)
-			return;
+			return res;
 		hfs_brec_insert(fd, HFS_I(inode)->cached_extents, sizeof(hfs_extent_rec));
 		HFS_I(inode)->flags &= ~(HFS_FLG_EXT_DIRTY|HFS_FLG_EXT_NEW);
 	} else {
 		if (res)
-			return;
+			return res;
 		hfs_bnode_write(fd->bnode, HFS_I(inode)->cached_extents, fd->entryoffset, fd->entrylength);
 		HFS_I(inode)->flags &= ~HFS_FLG_EXT_DIRTY;
 	}
+	return 0;
 }
 
-void hfs_ext_write_extent(struct inode *inode)
+int hfs_ext_write_extent(struct inode *inode)
 {
 	struct hfs_find_data fd;
+	int res = 0;
 
 	if (HFS_I(inode)->flags & HFS_FLG_EXT_DIRTY) {
-		hfs_find_init(HFS_SB(inode->i_sb)->ext_tree, &fd);
-		__hfs_ext_write_extent(inode, &fd);
+		res = hfs_find_init(HFS_SB(inode->i_sb)->ext_tree, &fd);
+		if (res)
+			return res;
+		res = __hfs_ext_write_extent(inode, &fd);
 		hfs_find_exit(&fd);
 	}
+	return res;
 }
 
 static inline int __hfs_ext_read_extent(struct hfs_find_data *fd, struct hfs_extent *extent,
@@ -161,8 +166,11 @@ static inline int __hfs_ext_cache_extent(struct hfs_find_data *fd, struct inode
 {
 	int res;
 
-	if (HFS_I(inode)->flags & HFS_FLG_EXT_DIRTY)
-		__hfs_ext_write_extent(inode, fd);
+	if (HFS_I(inode)->flags & HFS_FLG_EXT_DIRTY) {
+		res = __hfs_ext_write_extent(inode, fd);
+		if (res)
+			return res;
+	}
 
 	res = __hfs_ext_read_extent(fd, HFS_I(inode)->cached_extents, inode->i_ino,
 				    block, HFS_IS_RSRC(inode) ? HFS_FK_RSRC : HFS_FK_DATA);
@@ -185,9 +193,11 @@ static int hfs_ext_read_extent(struct inode *inode, u16 block)
 	    block < HFS_I(inode)->cached_start + HFS_I(inode)->cached_blocks)
 		return 0;
 
-	hfs_find_init(HFS_SB(inode->i_sb)->ext_tree, &fd);
-	res = __hfs_ext_cache_extent(&fd, inode, block);
-	hfs_find_exit(&fd);
+	res = hfs_find_init(HFS_SB(inode->i_sb)->ext_tree, &fd);
+	if (!res) {
+		res = __hfs_ext_cache_extent(&fd, inode, block);
+		hfs_find_exit(&fd);
+	}
 	return res;
 }
 
@@ -298,7 +308,9 @@ int hfs_free_fork(struct super_block *sb, struct hfs_cat_file *file, int type)
 	if (total_blocks == blocks)
 		return 0;
 
-	hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
+	res = hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
+	if (res)
+		return res;
 	do {
 		res = __hfs_ext_read_extent(&fd, extent, cnid, total_blocks, type);
 		if (res)
@@ -438,7 +450,9 @@ out:
 
 insert_extent:
 	dprint(DBG_EXTENT, "insert new extent\n");
-	hfs_ext_write_extent(inode);
+	res = hfs_ext_write_extent(inode);
+	if (res)
+		goto out;
 
 	memset(HFS_I(inode)->cached_extents, 0, sizeof(hfs_extent_rec));
 	HFS_I(inode)->cached_extents[0].block = cpu_to_be16(start);
@@ -466,7 +480,6 @@ void hfs_file_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		void *fsdata;
 		struct page *page;
-		int res;
 
 		/* XXX: Can use generic_cont_expand? */
 		size = inode->i_size - 1;
@@ -488,7 +501,12 @@ void hfs_file_truncate(struct inode *inode)
 		goto out;
 
 	mutex_lock(&HFS_I(inode)->extents_lock);
-	hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
+	res = hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
+	if (res) {
+		mutex_unlock(&HFS_I(inode)->extents_lock);
+		/* XXX: We lack error handling of hfs_file_truncate() */
+		return;
+	}
 	while (1) {
 		if (alloc_cnt == HFS_I(inode)->first_blocks) {
 			hfs_free_extents(sb, HFS_I(inode)->first_extents,
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 693df9f..67817af 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -174,7 +174,7 @@ extern const struct inode_operations hfs_dir_inode_operations;
 /* extent.c */
 extern int hfs_ext_keycmp(const btree_key *, const btree_key *);
 extern int hfs_free_fork(struct super_block *, struct hfs_cat_file *, int);
-extern void hfs_ext_write_extent(struct inode *);
+extern int hfs_ext_write_extent(struct inode *);
 extern int hfs_extend_file(struct inode *);
 extern void hfs_file_truncate(struct inode *);
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 3031dfd..8ff4b5a 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -416,9 +416,12 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct inode *main_inode = inode;
 	struct hfs_find_data fd;
 	hfs_cat_rec rec;
+	int res;
 
 	dprint(DBG_INODE, "hfs_write_inode: %lu\n", inode->i_ino);
-	hfs_ext_write_extent(inode);
+	res = hfs_ext_write_extent(inode);
+	if (res)
+		return res;
 
 	if (inode->i_ino < HFS_FIRSTUSER_CNID) {
 		switch (inode->i_ino) {
@@ -515,7 +518,11 @@ static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
+	res = hfs_find_init(HFS_SB(dir->i_sb)->cat_tree, &fd);
+	if (res) {
+		iput(inode);
+		return ERR_PTR(res);
+	}
 	fd.search_key->cat = HFS_I(dir)->cat_key;
 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
 	if (!res) {
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index bbaaa8a..719760b 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -418,7 +418,9 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* try to get the root inode */
-	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	res = hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
+	if (res)
+		goto bail_no_root;
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
 	if (!res) {
 		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
-- 
1.7.9.5

