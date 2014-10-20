Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJTFUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:20:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:60032 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaJTFT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:58 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 09/11] f2fs: introduce f2fs_dentry_ptr structure for code clean-up
Date: Sun, 19 Oct 2014 22:19:37 -0700
Message-Id: <1413782379-11758-9-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces f2fs_dentry_ptr structure for the use of a function
parameter in inline_dentry operations.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 61 +++++++++++++++++++++++++++-----------------------------
 fs/f2fs/f2fs.h   | 34 ++++++++++++++++++++++++++-----
 fs/f2fs/inline.c | 18 ++++++++---------
 3 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 721d061..80665ce 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -95,13 +95,13 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 {
 	struct f2fs_dentry_block *dentry_blk;
 	struct f2fs_dir_entry *de;
-
-	*max_slots = NR_DENTRY_IN_BLOCK;
+	struct f2fs_dentry_ptr d;
 
 	dentry_blk = (struct f2fs_dentry_block *)kmap(dentry_page);
-	de = find_target_dentry(name, max_slots, &dentry_blk->dentry_bitmap,
-						dentry_blk->dentry,
-						dentry_blk->filename);
+
+	make_dentry_ptr(&d, dentry_blk, NULL, 1);
+	de = find_target_dentry(name, max_slots, &d);
+
 	kunmap(dentry_page);
 	if (de)
 		*res_page = dentry_page;
@@ -110,50 +110,49 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 	 * For the most part, it should be a bug when name_len is zero.
 	 * We stop here for figuring out where the bugs has occurred.
 	 */
-	f2fs_bug_on(F2FS_P_SB(dentry_page), *max_slots < 0);
+	f2fs_bug_on(F2FS_P_SB(dentry_page), d.max < 0);
 	return de;
 }
 
 struct f2fs_dir_entry *find_target_dentry(struct qstr *name, int *max_slots,
-			const void *bitmap, struct f2fs_dir_entry *dentry,
-			__u8 (*filenames)[F2FS_SLOT_LEN])
+						struct f2fs_dentry_ptr *d)
 {
 	struct f2fs_dir_entry *de;
 	unsigned long bit_pos = 0;
 	f2fs_hash_t namehash = f2fs_dentry_hash(name);
-	int max_bits = *max_slots;
 	int max_len = 0;
 
-	*max_slots = 0;
-	while (bit_pos < max_bits) {
-		if (!test_bit_le(bit_pos, bitmap)) {
+	if (max_slots)
+		*max_slots = 0;
+	while (bit_pos < d->max) {
+		if (!test_bit_le(bit_pos, d->bitmap)) {
 			if (bit_pos == 0)
 				max_len = 1;
-			else if (!test_bit_le(bit_pos - 1, bitmap))
+			else if (!test_bit_le(bit_pos - 1, d->bitmap))
 				max_len++;
 			bit_pos++;
 			continue;
 		}
-		de = &dentry[bit_pos];
+		de = &d->dentry[bit_pos];
 		if (early_match_name(name->len, namehash, de) &&
-			!memcmp(filenames[bit_pos], name->name, name->len))
+			!memcmp(d->filename[bit_pos], name->name, name->len))
 			goto found;
 
-		if (*max_slots >= 0 && max_len > *max_slots) {
+		if (max_slots && *max_slots >= 0 && max_len > *max_slots) {
 			*max_slots = max_len;
 			max_len = 0;
 		}
 
 		/* remain bug on condition */
 		if (unlikely(!de->name_len))
-			*max_slots = -1;
+			d->max = -1;
 
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
 
 	de = NULL;
 found:
-	if (max_len > *max_slots)
+	if (max_slots && max_len > *max_slots)
 		*max_slots = max_len;
 	return de;
 }
@@ -705,28 +704,26 @@ bool f2fs_empty_dir(struct inode *dir)
 	return true;
 }
 
-bool f2fs_fill_dentries(struct dir_context *ctx,
-			const void *bitmap, struct f2fs_dir_entry *dentry,
-			__u8 (*filenames)[F2FS_SLOT_LEN], int max,
-			unsigned int start_pos)
+bool f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
+						unsigned int start_pos)
 {
 	unsigned char d_type = DT_UNKNOWN;
 	unsigned int bit_pos;
 	struct f2fs_dir_entry *de = NULL;
 
-	bit_pos = ((unsigned long)ctx->pos % max);
+	bit_pos = ((unsigned long)ctx->pos % d->max);
 
-	while (bit_pos < max) {
-		bit_pos = find_next_bit_le(bitmap, max, bit_pos);
-		if (bit_pos >= max)
+	while (bit_pos < d->max) {
+		bit_pos = find_next_bit_le(d->bitmap, d->max, bit_pos);
+		if (bit_pos >= d->max)
 			break;
 
-		de = &dentry[bit_pos];
+		de = &d->dentry[bit_pos];
 		if (de->file_type < F2FS_FT_MAX)
 			d_type = f2fs_filetype_table[de->file_type];
 		else
 			d_type = DT_UNKNOWN;
-		if (!dir_emit(ctx, filenames[bit_pos],
+		if (!dir_emit(ctx, d->filename[bit_pos],
 					le16_to_cpu(de->name_len),
 					le32_to_cpu(de->ino), d_type))
 			return true;
@@ -745,6 +742,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	struct page *dentry_page = NULL;
 	struct file_ra_state *ra = &file->f_ra;
 	unsigned int n = ((unsigned long)ctx->pos / NR_DENTRY_IN_BLOCK);
+	struct f2fs_dentry_ptr d;
 
 	if (f2fs_has_inline_dentry(inode))
 		return f2fs_read_inline_dir(file, ctx);
@@ -761,10 +759,9 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 
 		dentry_blk = kmap(dentry_page);
 
-		if (f2fs_fill_dentries(ctx,
-				&dentry_blk->dentry_bitmap, dentry_blk->dentry,
-				dentry_blk->filename,
-				NR_DENTRY_IN_BLOCK, n * NR_DENTRY_IN_BLOCK))
+		make_dentry_ptr(&d, dentry_blk, NULL, 1);
+
+		if (f2fs_fill_dentries(ctx, &d, n * NR_DENTRY_IN_BLOCK))
 			goto stop;
 
 		ctx->pos = (n + 1) * NR_DENTRY_IN_BLOCK;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3b0f490..0856a38 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -212,6 +212,31 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
 /*
  * For INODE and NODE manager
  */
+/* for directory operations */
+struct f2fs_dentry_ptr {
+	const void *bitmap;
+	struct f2fs_dir_entry *dentry;
+	__u8 (*filename)[F2FS_SLOT_LEN];
+	int max;
+};
+
+static inline void make_dentry_ptr(struct f2fs_dentry_ptr *d,
+			struct f2fs_dentry_block *d1,
+			struct f2fs_inline_dentry *d2, int type)
+{
+	if (type == 1) {
+		d->max = NR_DENTRY_IN_BLOCK;
+		d->bitmap = &d1->dentry_bitmap;
+		d->dentry = d1->dentry;
+		d->filename = d1->filename;
+	} else {
+		d->max = NR_INLINE_DENTRY;
+		d->bitmap = &d2->dentry_bitmap;
+		d->dentry = d2->dentry;
+		d->filename = d2->filename;
+	}
+}
+
 /*
  * XATTR_NODE_OFFSET stores xattrs to one node block per file keeping -1
  * as its node offset to distinguish from index node blocks.
@@ -1245,11 +1270,10 @@ struct dentry *f2fs_get_parent(struct dentry *child);
  */
 extern unsigned char f2fs_filetype_table[F2FS_FT_MAX];
 void set_de_type(struct f2fs_dir_entry *, struct inode *);
-struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *, const void *,
-			struct f2fs_dir_entry *, __u8 (*)[F2FS_SLOT_LEN]);
-bool f2fs_fill_dentries(struct dir_context *,
-			const void *, struct f2fs_dir_entry *,
-			__u8 (*)[F2FS_SLOT_LEN], int, unsigned int);
+struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *,
+			struct f2fs_dentry_ptr *);
+bool f2fs_fill_dentries(struct dir_context *, struct f2fs_dentry_ptr *,
+			unsigned int);
 struct page *init_inode_metadata(struct inode *, struct inode *,
 			const struct qstr *, struct page *);
 void update_parent_metadata(struct inode *, struct inode *, unsigned int);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 403c8f7..edacfa1 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -265,8 +265,8 @@ struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	struct f2fs_inline_dentry *inline_dentry;
 	struct f2fs_dir_entry *de;
+	struct f2fs_dentry_ptr d;
 	struct page *ipage;
-	int max_slots = NR_INLINE_DENTRY;
 
 	ipage = get_node_page(sbi, dir->i_ino);
 	if (IS_ERR(ipage))
@@ -274,9 +274,9 @@ struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
 
 	inline_dentry = inline_data_addr(ipage);
 
-	de = find_target_dentry(name, &max_slots, &inline_dentry->dentry_bitmap,
-						inline_dentry->dentry,
-						inline_dentry->filename);
+	make_dentry_ptr(&d, NULL, inline_dentry, 2);
+	de = find_target_dentry(name, NULL, &d);
+
 	unlock_page(ipage);
 	if (de)
 		*res_page = ipage;
@@ -287,7 +287,7 @@ struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
 	 * For the most part, it should be a bug when name_len is zero.
 	 * We stop here for figuring out where the bugs has occurred.
 	 */
-	f2fs_bug_on(sbi, max_slots < 0);
+	f2fs_bug_on(sbi, d.max < 0);
 	return de;
 }
 
@@ -521,6 +521,7 @@ int f2fs_read_inline_dir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	struct f2fs_inline_dentry *inline_dentry = NULL;
 	struct page *ipage = NULL;
+	struct f2fs_dentry_ptr d;
 
 	if (ctx->pos == NR_INLINE_DENTRY)
 		return 0;
@@ -531,10 +532,9 @@ int f2fs_read_inline_dir(struct file *file, struct dir_context *ctx)
 
 	inline_dentry = inline_data_addr(ipage);
 
-	if (!f2fs_fill_dentries(ctx, &inline_dentry->dentry_bitmap,
-				inline_dentry->dentry,
-				inline_dentry->filename,
-				NR_INLINE_DENTRY, 0))
+	make_dentry_ptr(&d, NULL, inline_dentry, 2);
+
+	if (!f2fs_fill_dentries(ctx, &d, 0))
 		ctx->pos = NR_INLINE_DENTRY;
 
 	f2fs_put_page(ipage, 1);
-- 
2.1.1

