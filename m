Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaJTFWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:22:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:59945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaJTFTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:47 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 02/11] f2fs: reuse find_in_block code for find_in_inline_dir
Date: Sun, 19 Oct 2014 22:19:30 -0700
Message-Id: <1413782379-11758-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant copied code in find_in_inline_dir.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 72 +++++++++++++++++++++++++++++++++++---------------------
 fs/f2fs/f2fs.h   |  3 ++-
 fs/f2fs/inline.c | 52 +++++++++++++---------------------------
 3 files changed, 64 insertions(+), 63 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 164c6c9..c60b93f 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -77,7 +77,7 @@ static unsigned long dir_block_index(unsigned int level,
 	return bidx;
 }
 
-bool early_match_name(size_t namelen, f2fs_hash_t namehash,
+static bool early_match_name(size_t namelen, f2fs_hash_t namehash,
 				struct f2fs_dir_entry *de)
 {
 	if (le16_to_cpu(de->name_len) != namelen)
@@ -90,49 +90,68 @@ bool early_match_name(size_t namelen, f2fs_hash_t namehash,
 }
 
 static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
-			struct qstr *name, int *max_slots,
-			f2fs_hash_t namehash, struct page **res_page)
+				struct qstr *name, int *max_slots,
+				struct page **res_page)
+{
+	struct f2fs_dentry_block *dentry_blk;
+	struct f2fs_dir_entry *de;
+
+	*max_slots = NR_DENTRY_IN_BLOCK;
+
+	dentry_blk = (struct f2fs_dentry_block *)kmap(dentry_page);
+	de = find_target_dentry(name, max_slots, &dentry_blk->dentry_bitmap,
+						dentry_blk->dentry,
+						dentry_blk->filename);
+	kunmap(dentry_page);
+	if (de)
+		*res_page = dentry_page;
+
+	/*
+	 * For the most part, it should be a bug when name_len is zero.
+	 * We stop here for figuring out where the bugs has occurred.
+	 */
+	f2fs_bug_on(F2FS_P_SB(dentry_page), *max_slots < 0);
+	return de;
+}
+
+struct f2fs_dir_entry *find_target_dentry(struct qstr *name, int *max_slots,
+			const void *bitmap, struct f2fs_dir_entry *dentry,
+			__u8 (*filenames)[F2FS_SLOT_LEN])
 {
 	struct f2fs_dir_entry *de;
 	unsigned long bit_pos = 0;
-	struct f2fs_dentry_block *dentry_blk = kmap(dentry_page);
-	const void *dentry_bits = &dentry_blk->dentry_bitmap;
+	f2fs_hash_t namehash = f2fs_dentry_hash(name);
+	int max_bits = *max_slots;
 	int max_len = 0;
 
-	while (bit_pos < NR_DENTRY_IN_BLOCK) {
-		if (!test_bit_le(bit_pos, dentry_bits)) {
+	*max_slots = 0;
+	while (bit_pos < max_bits) {
+		if (!test_bit_le(bit_pos, bitmap)) {
 			if (bit_pos == 0)
 				max_len = 1;
-			else if (!test_bit_le(bit_pos - 1, dentry_bits))
+			else if (!test_bit_le(bit_pos - 1, bitmap))
 				max_len++;
 			bit_pos++;
 			continue;
 		}
-		de = &dentry_blk->dentry[bit_pos];
-		if (early_match_name(name->len, namehash, de)) {
-			if (!memcmp(dentry_blk->filename[bit_pos],
-							name->name,
-							name->len)) {
-				*res_page = dentry_page;
-				goto found;
-			}
-		}
-		if (max_len > *max_slots) {
+		de = &dentry[bit_pos];
+		if (early_match_name(name->len, namehash, de) &&
+			!memcmp(filenames[bit_pos], name->name, name->len))
+			goto found;
+
+		if (*max_slots >= 0 && max_len > *max_slots) {
 			*max_slots = max_len;
 			max_len = 0;
 		}
 
-		/*
-		 * For the most part, it should be a bug when name_len is zero.
-		 * We stop here for figuring out where the bugs has occurred.
-		 */
-		f2fs_bug_on(F2FS_P_SB(dentry_page), !de->name_len);
+		/* remain bug on condition */
+		if (unlikely(!de->name_len))
+			*max_slots = -1;
 
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 
 	de = NULL;
-	kunmap(dentry_page);
 found:
 	if (max_len > *max_slots)
 		*max_slots = max_len;
@@ -149,7 +168,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 	struct page *dentry_page;
 	struct f2fs_dir_entry *de = NULL;
 	bool room = false;
-	int max_slots = 0;
+	int max_slots;
 
 	f2fs_bug_on(F2FS_I_SB(dir), level > MAX_DIR_HASH_DEPTH);
 
@@ -168,8 +187,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 			continue;
 		}
 
-		de = find_in_block(dentry_page, name, &max_slots,
-					namehash, res_page);
+		de = find_in_block(dentry_page, name, &max_slots, res_page);
 		if (de)
 			break;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index aa055e3..6aad6e0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1243,8 +1243,9 @@ struct dentry *f2fs_get_parent(struct dentry *child);
  * dir.c
  */
 extern unsigned char f2fs_filetype_table[F2FS_FT_MAX];
-bool early_match_name(size_t, f2fs_hash_t, struct f2fs_dir_entry *);
 void set_de_type(struct f2fs_dir_entry *, struct inode *);
+struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *, const void *,
+			struct f2fs_dir_entry *, __u8 (*)[F2FS_SLOT_LEN]);
 struct page *init_inode_metadata(struct inode *, struct inode *,
 							const struct qstr *);
 void update_parent_metadata(struct inode *, struct inode *, unsigned int);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 5d9dabb..6f9ba80 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -263,49 +263,31 @@ struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
 				struct qstr *name, struct page **res_page)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
-	struct page *ipage;
+	struct f2fs_inline_dentry *inline_dentry;
 	struct f2fs_dir_entry *de;
-	f2fs_hash_t namehash;
-	unsigned long bit_pos = 0;
-	struct f2fs_inline_dentry *dentry_blk;
-	const void *dentry_bits;
+	struct page *ipage;
+	int max_slots = NR_INLINE_DENTRY;
 
 	ipage = get_node_page(sbi, dir->i_ino);
 	if (IS_ERR(ipage))
 		return NULL;
 
-	namehash = f2fs_dentry_hash(name);
-
-	dentry_blk = inline_data_addr(ipage);
-	dentry_bits = &dentry_blk->dentry_bitmap;
-
-	while (bit_pos < NR_INLINE_DENTRY) {
-		if (!test_bit_le(bit_pos, dentry_bits)) {
-			bit_pos++;
-			continue;
-		}
-		de = &dentry_blk->dentry[bit_pos];
-		if (early_match_name(name->len, namehash, de)) {
-			if (!memcmp(dentry_blk->filename[bit_pos],
-							name->name,
-							name->len)) {
-				*res_page = ipage;
-				goto found;
-			}
-		}
-
-		/*
-		 * For the most part, it should be a bug when name_len is zero.
-		 * We stop here for figuring out where the bugs are occurred.
-		 */
-		f2fs_bug_on(F2FS_P_SB(ipage), !de->name_len);
-
-		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-	}
+	inline_dentry = inline_data_addr(ipage);
 
-	de = NULL;
-found:
+	de = find_target_dentry(name, &max_slots, &inline_dentry->dentry_bitmap,
+						inline_dentry->dentry,
+						inline_dentry->filename);
 	unlock_page(ipage);
+	if (de)
+		*res_page = ipage;
+	else
+		f2fs_put_page(ipage, 0);
+
+	/*
+	 * For the most part, it should be a bug when name_len is zero.
+	 * We stop here for figuring out where the bugs has occurred.
+	 */
+	f2fs_bug_on(sbi, max_slots < 0);
 	return de;
 }
 
-- 
2.1.1

