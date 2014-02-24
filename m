Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBXT2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:28:32 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:9909 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330AbaBXT23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:28:29 -0500
Message-ID: <1393270107.27792.9.camel@ultrabook>
Subject: [PATCH 1/1] hfsplus: fix longname handling
From: Sougata Santra <sougata@tuxera.com>
Reply-To: <sougata@tuxera.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@lst.de>, Sougata Santra <sougata@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 21:28:27 +0200
Organization: Tuxera
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.166.4.239]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-ENAMETOOLONG returned from hfsplus_asc2uni was not propaged to iops. This
allowed hfsplus to create files/directories with HFSPLUS_MAX_STRLEN and
incorrect keys, leaving the FS in an inconsistent state. This patch fixes
this issue.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/hfsplus/catalog.c    | 89 ++++++++++++++++++++++++++++++++++++-------------
 fs/hfsplus/dir.c        | 11 ++++--
 fs/hfsplus/hfsplus_fs.h |  4 ++-
 fs/hfsplus/super.c      |  4 ++-
 4 files changed, 79 insertions(+), 29 deletions(-)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 968ce41..389c474 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -38,21 +38,30 @@ int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *k1,
 	return hfsplus_strcmp(&k1->cat.name, &k2->cat.name);
 }
 
-void hfsplus_cat_build_key(struct super_block *sb, hfsplus_btree_key *key,
-			   u32 parent, struct qstr *str)
+/* Generates key for catalog file/folders record. */
+int hfsplus_cat_build_key(struct super_block *sb,
+		hfsplus_btree_key *key, u32 parent, struct qstr *str)
 {
-	int len;
+	int len, err;
 
 	key->cat.parent = cpu_to_be32(parent);
-	if (str) {
-		hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
-					str->name, str->len);
-		len = be16_to_cpu(key->cat.name.length);
-	} else {
-		key->cat.name.length = 0;
-		len = 0;
-	}
+	err = hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
+			str->name, str->len);
+	if (unlikely(err < 0))
+		return err;
+
+	len = be16_to_cpu(key->cat.name.length);
 	key->key_len = cpu_to_be16(6 + 2 * len);
+	return 0;
+}
+
+/* Generates key for catalog thread record. */
+void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
+			hfsplus_btree_key *key, u32 parent)
+{
+	key->cat.parent = cpu_to_be32(parent);
+	key->cat.name.length = 0;
+	key->key_len = cpu_to_be16(6);
 }
 
 static void hfsplus_cat_build_key_uni(hfsplus_btree_key *key, u32 parent,
@@ -165,11 +174,16 @@ static int hfsplus_fill_cat_thread(struct super_block *sb,
 				   hfsplus_cat_entry *entry, int type,
 				   u32 parentid, struct qstr *str)
 {
+	int err;
+
 	entry->type = cpu_to_be16(type);
 	entry->thread.reserved = 0;
 	entry->thread.parentID = cpu_to_be32(parentid);
-	hfsplus_asc2uni(sb, &entry->thread.nodeName, HFSPLUS_MAX_STRLEN,
+	err = hfsplus_asc2uni(sb, &entry->thread.nodeName, HFSPLUS_MAX_STRLEN,
 				str->name, str->len);
+	if (unlikely(err < 0))
+		return err;
+
 	return 10 + be16_to_cpu(entry->thread.nodeName.length) * 2;
 }
 
@@ -181,7 +195,7 @@ int hfsplus_find_cat(struct super_block *sb, u32 cnid,
 	int err;
 	u16 type;
 
-	hfsplus_cat_build_key(sb, fd->search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd->search_key, cnid);
 	err = hfs_brec_read(fd, &tmp, sizeof(hfsplus_cat_entry));
 	if (err)
 		return err;
@@ -218,11 +232,16 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 	if (err)
 		return err;
 
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry,
 		S_ISDIR(inode->i_mode) ?
 			HFSPLUS_FOLDER_THREAD : HFSPLUS_FILE_THREAD,
 		dir->i_ino, str);
+	if (unlikely(entry_size < 0)) {
+		err = entry_size;
+		goto err2;
+	}
+
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
@@ -233,7 +252,10 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 	if (err)
 		goto err2;
 
-	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+	err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+	if (unlikely(err))
+		goto err1;
+
 	entry_size = hfsplus_cat_build_record(&entry, cnid, inode);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
@@ -254,7 +276,7 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 	return 0;
 
 err1:
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	if (!hfs_brec_find(&fd, hfs_find_rec_by_key))
 		hfs_brec_remove(&fd);
 err2:
@@ -279,7 +301,7 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 	if (!str) {
 		int len;
 
-		hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+		hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 		if (err)
 			goto out;
@@ -295,7 +317,9 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 			off + 2, len);
 		fd.search_key->key_len = cpu_to_be16(6 + len);
 	} else
-		hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+		err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+		if (unlikely(err))
+			goto out;
 
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
@@ -326,7 +350,7 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, struct qstr *str)
 	if (err)
 		goto out;
 
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -369,7 +393,11 @@ int hfsplus_rename_cat(u32 cnid,
 	dst_fd = src_fd;
 
 	/* find the old dir entry and read the data */
-	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
+	err = hfsplus_cat_build_key(sb, src_fd.search_key,
+			src_dir->i_ino, src_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -382,7 +410,11 @@ int hfsplus_rename_cat(u32 cnid,
 				src_fd.entrylength);
 
 	/* create new dir entry with the data from the old entry */
-	hfsplus_cat_build_key(sb, dst_fd.search_key, dst_dir->i_ino, dst_name);
+	err = hfsplus_cat_build_key(sb, dst_fd.search_key,
+			dst_dir->i_ino, dst_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
@@ -397,7 +429,11 @@ int hfsplus_rename_cat(u32 cnid,
 	dst_dir->i_mtime = dst_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* finally remove the old entry */
-	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
+	err = hfsplus_cat_build_key(sb, src_fd.search_key,
+			src_dir->i_ino, src_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -408,7 +444,7 @@ int hfsplus_rename_cat(u32 cnid,
 	src_dir->i_mtime = src_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* remove old thread entry */
-	hfsplus_cat_build_key(sb, src_fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, src_fd.search_key, cnid);
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -418,9 +454,14 @@ int hfsplus_rename_cat(u32 cnid,
 		goto out;
 
 	/* create new thread entry */
-	hfsplus_cat_build_key(sb, dst_fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, dst_fd.search_key, cnid);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry, type,
 		dst_dir->i_ino, dst_name);
+	if (unlikely(entry_size < 0)) {
+		err = entry_size;
+		goto out;
+	}
+
 	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index bdec665..b306b66 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -43,7 +43,10 @@ static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry,
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	if (err)
 		return ERR_PTR(err);
-	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
+	err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino,
+			&dentry->d_name);
+	if (unlikely(err < 0))
+		goto fail;
 again:
 	err = hfs_brec_read(&fd, &entry, sizeof(entry));
 	if (err) {
@@ -96,9 +99,11 @@ again:
 					be32_to_cpu(entry.file.permissions.dev);
 				str.len = sprintf(name, "iNode%d", linkid);
 				str.name = name;
-				hfsplus_cat_build_key(sb, fd.search_key,
+				err = hfsplus_cat_build_key(sb, fd.search_key,
 					HFSPLUS_SB(sb)->hidden_dir->i_ino,
 					&str);
+				if (unlikely(err < 0))
+					goto fail;
 				goto again;
 			}
 		} else if (!dentry->d_fsdata)
@@ -139,7 +144,7 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	if (err)
 		return err;
-	hfsplus_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, inode->i_ino);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 08846425b..66671c4 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -443,8 +443,10 @@ int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *,
 		const hfsplus_btree_key *);
 int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
 		const hfsplus_btree_key *);
-void hfsplus_cat_build_key(struct super_block *sb,
+int hfsplus_cat_build_key(struct super_block *sb,
 		hfsplus_btree_key *, u32, struct qstr *);
+void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
+		hfsplus_btree_key *, u32);
 int hfsplus_find_cat(struct super_block *, u32, struct hfs_find_data *);
 int hfsplus_create_cat(u32, struct inode *, struct qstr *, struct inode *);
 int hfsplus_delete_cat(u32, struct inode *, struct qstr *);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 80875aa..4fdf0ca 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -513,7 +513,9 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	err = hfs_find_init(sbi->cat_tree, &fd);
 	if (err)
 		goto out_put_root;
-	hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
+	err = hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
+	if (unlikely(err < 0))
+		goto out_put_root;
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER))
-- 
1.8.5.3



