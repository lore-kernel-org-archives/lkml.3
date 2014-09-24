Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaIXKSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:18:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52978 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIXKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:18:38 -0400
X-AuditID: cbfee61a-f79c06d000004e71-54-54229a7d2547
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 4/6 v2] f2fs: add key function to handle inline dir
Date: Wed, 24 Sep 2014 18:17:53 +0800
Message-id: <003f01cfd7e0$e7dcb100$b7961300$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X35qwFhFW4NPiR4+sYd9eUsCKtg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd3aWUohBh+nCFhc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49uk26wF
	84MrVvd9ZmtgPODSxcjJISFgIrFq3jlWCFtM4sK99WxdjFwcQgKLGCUu/m9khnB+MEos2rSC
	CaSKTUBFYnnHfzBbRMBLYtL+EywgNrOAh0Rjx3ewScICvhLT3u0HaubgYBFQlXjemw8S5hWw
	lFj8fgMThC0o8WPyPahWLYn1O48zQdjyEpvXvGWGOEhBYsfZ14wQq/Qklm1YwQZRIy6x8cgt
	lgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pJ9J7WBc
	2WBxiFGAg1GJh3eCuFKIEGtiWXFl7iFGCQ5mJRHeVz1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxH1xurHb4tdG5eF6N+hh270T/2uaEVpxf4bUtf
	usn69JKrazl+dPguS3i5bCbj/tsNE+WP7CiwYWWsWGXG63J8Ye9uu6aJWYz3Tpc6bxXirvy/
	XuNU7ebkf6wXs31n+L75Mifnjs5frbJv8rGSXT4nZzWbfOqdJLdVNVTyz3/z+n6GA7rdrauV
	WIozEg21mIuKEwHsZX2BZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Functions to implement inline dir init/lookup/insert/delete/convert ops.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h   |   9 ++
 fs/f2fs/inline.c | 347 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 356 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8e819b0..630c671 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1526,4 +1526,13 @@ int f2fs_convert_inline_data(struct inode *, pgoff_t, struct page *);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
 void truncate_inline_data(struct inode *, u64);
 bool recover_inline_data(struct inode *, struct page *);
+struct f2fs_dir_entry *find_in_inline_dir(struct inode *, struct qstr *,
+							struct page **);
+struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *, struct page **);
+int make_empty_inline_dir(struct inode *inode, struct inode *, struct page *);
+int f2fs_add_inline_entry(struct inode *, const struct qstr *, struct inode *);
+void f2fs_delete_inline_entry(struct f2fs_dir_entry *, struct page *,
+						struct inode *, struct inode *);
+bool f2fs_empty_inline_dir(struct inode *);
+int f2fs_read_inline_dir(struct file *, struct dir_context *);
 #endif
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 6aef11d..3c85def 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -254,3 +254,350 @@ process_inline:
 	}
 	return false;
 }
+
+struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
+				struct qstr *name, struct page **res_page){
+	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct page *ipage;
+	struct f2fs_dir_entry *de;
+	f2fs_hash_t namehash;
+	unsigned long bit_pos = 0;
+	struct f2fs_inline_dentry *dentry_blk;
+	const void *dentry_bits;
+
+	ipage = get_node_page(sbi, dir->i_ino);
+	if (IS_ERR(ipage))
+		return NULL;
+
+	namehash = f2fs_dentry_hash(name);
+
+	dentry_blk = inline_data_addr(ipage);
+	dentry_bits = &dentry_blk->dentry_bitmap;
+
+	while (bit_pos < NR_INLINE_DENTRY) {
+		if (!test_bit_le(bit_pos, dentry_bits)) {
+			bit_pos++;
+			continue;
+		}
+		de = &dentry_blk->dentry[bit_pos];
+		if (early_match_name(name->len, namehash, de)) {
+			if (!memcmp(dentry_blk->filename[bit_pos],
+							name->name,
+							name->len)) {
+				*res_page = ipage;
+				goto found;
+			}
+		}
+
+		/*
+		 * For the most part, it should be a bug when name_len is zero.
+		 * We stop here for figuring out where the bugs are occurred.
+		 */
+		f2fs_bug_on(F2FS_P_SB(ipage), !de->name_len);
+
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+	}
+
+	de = NULL;
+found:
+	unlock_page(ipage);
+	return de;
+}
+
+struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *dir,
+							struct page **p)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
+	struct page *ipage;
+	struct f2fs_dir_entry *de;
+	struct f2fs_inline_dentry *dentry_blk;
+
+	ipage = get_node_page(sbi, dir->i_ino);
+	if (IS_ERR(ipage))
+		return NULL;
+
+	dentry_blk = inline_data_addr(ipage);
+	de = &dentry_blk->dentry[1];
+	*p = ipage;
+	unlock_page(ipage);
+	return de;
+}
+
+int make_empty_inline_dir(struct inode *inode, struct inode *parent,
+							struct page *ipage)
+{
+	struct f2fs_inline_dentry *dentry_blk;
+	struct f2fs_dir_entry *de;
+
+	dentry_blk = inline_data_addr(ipage);
+
+	de = &dentry_blk->dentry[0];
+	de->name_len = cpu_to_le16(1);
+	de->hash_code = 0;
+	de->ino = cpu_to_le32(inode->i_ino);
+	memcpy(dentry_blk->filename[0], ".", 1);
+	set_de_type(de, inode);
+
+	de = &dentry_blk->dentry[1];
+	de->hash_code = 0;
+	de->name_len = cpu_to_le16(2);
+	de->ino = cpu_to_le32(parent->i_ino);
+	memcpy(dentry_blk->filename[1], "..", 2);
+	set_de_type(de, inode);
+
+	test_and_set_bit_le(0, &dentry_blk->dentry_bitmap);
+	test_and_set_bit_le(1, &dentry_blk->dentry_bitmap);
+
+	set_page_dirty(ipage);
+
+	/* update i_size to MAX_INLINE_DATA */
+	if (i_size_read(inode) < MAX_INLINE_DATA) {
+		i_size_write(inode, MAX_INLINE_DATA);
+		set_inode_flag(F2FS_I(inode), FI_UPDATE_DIR);
+	}
+	return 0;
+}
+
+int room_in_inline_dir(struct f2fs_inline_dentry *dentry_blk, int slots)
+{
+	int bit_start = 0;
+	int zero_start, zero_end;
+next:
+	zero_start = find_next_zero_bit_le(&dentry_blk->dentry_bitmap,
+						NR_INLINE_DENTRY,
+						bit_start);
+	if (zero_start >= NR_INLINE_DENTRY)
+		return NR_INLINE_DENTRY;
+
+	zero_end = find_next_bit_le(&dentry_blk->dentry_bitmap,
+						NR_INLINE_DENTRY,
+						zero_start);
+	if (zero_end - zero_start >= slots)
+		return zero_start;
+
+	bit_start = zero_end + 1;
+
+	if (zero_end + 1 >= NR_INLINE_DENTRY)
+		return NR_INLINE_DENTRY;
+	goto next;
+}
+
+int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
+				struct f2fs_inline_dentry *inline_dentry)
+{
+	struct page *page;
+	struct dnode_of_data dn;
+	struct f2fs_dentry_block *dentry_blk;
+	int err;
+
+	page = grab_cache_page(dir->i_mapping, 0);
+	if (!page)
+		return -ENOMEM;
+
+	set_new_dnode(&dn, dir, ipage, NULL, 0);
+	err = f2fs_reserve_block(&dn, 0);
+	if (err)
+		goto out;
+
+	f2fs_wait_on_page_writeback(page, DATA);
+	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+
+	dentry_blk = kmap(page);
+
+	/* copy data from inline dentry block to new dentry block */
+	memcpy(dentry_blk->dentry_bitmap, inline_dentry->dentry_bitmap,
+					INLINE_DENTRY_BITMAP_SIZE);
+	memcpy(dentry_blk->reserved, inline_dentry->reserved,
+					INLINE_RESERVED_SIZE);
+	memcpy(dentry_blk->dentry, inline_dentry->dentry,
+			sizeof(struct f2fs_dir_entry) * NR_INLINE_DENTRY);
+	memcpy(dentry_blk->filename, inline_dentry->filename,
+					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
+
+	kunmap(page);
+	SetPageUptodate(page);
+	set_page_dirty(page);
+
+	/* clear inline dir and flag after data writeback */
+	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+
+	stat_dec_inline_inode(dir);
+
+	if (i_size_read(dir) < PAGE_CACHE_SIZE) {
+		i_size_write(dir, PAGE_CACHE_SIZE);
+		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
+	}
+
+	sync_inode_page(&dn);
+out:
+	f2fs_put_page(page, 1);
+	return err;
+}
+
+int f2fs_add_inline_entry(struct inode *dir, const struct qstr *name,
+						struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
+	struct page *ipage;
+	unsigned int bit_pos;
+	f2fs_hash_t name_hash;
+	struct f2fs_dir_entry *de;
+	size_t namelen = name->len;
+	struct f2fs_inline_dentry *dentry_blk = NULL;
+	int slots = GET_DENTRY_SLOTS(namelen);
+	struct page *page;
+	int err = 0;
+	int i;
+
+	name_hash = f2fs_dentry_hash(name);
+
+	ipage = get_node_page(sbi, dir->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	dentry_blk = inline_data_addr(ipage);
+	bit_pos = room_in_inline_dir(dentry_blk, slots);
+	if (bit_pos >= NR_INLINE_DENTRY) {
+		err = f2fs_convert_inline_dir(dir, ipage, dentry_blk);
+		if (!err)
+			err = -EAGAIN;
+		goto out;
+	}
+
+	f2fs_wait_on_page_writeback(ipage, DATA);
+
+	down_write(&F2FS_I(inode)->i_sem);
+	page = init_inode_metadata(inode, dir, name);
+	if (IS_ERR(page)) {
+		err = PTR_ERR(page);
+		goto fail;
+	}
+	de = &dentry_blk->dentry[bit_pos];
+	de->hash_code = name_hash;
+	de->name_len = cpu_to_le16(namelen);
+	memcpy(dentry_blk->filename[bit_pos], name->name, name->len);
+	de->ino = cpu_to_le32(inode->i_ino);
+	set_de_type(de, inode);
+	for (i = 0; i < slots; i++)
+		test_and_set_bit_le(bit_pos + i, &dentry_blk->dentry_bitmap);
+	set_page_dirty(ipage);
+
+	/* we don't need to mark_inode_dirty now */
+	F2FS_I(inode)->i_pino = dir->i_ino;
+	update_inode(inode, page);
+	f2fs_put_page(page, 1);
+
+	update_parent_metadata(dir, inode, 0);
+fail:
+	up_write(&F2FS_I(inode)->i_sem);
+
+	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR)) {
+		update_inode(dir, ipage);
+		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
+	}
+out:
+	f2fs_put_page(ipage, 1);
+	return err;
+}
+
+void f2fs_delete_inline_entry(struct f2fs_dir_entry *dentry, struct page *page,
+					struct inode *dir, struct inode *inode)
+{
+	struct f2fs_inline_dentry *inline_dentry;
+	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
+	unsigned int bit_pos;
+	int i;
+
+	lock_page(page);
+	f2fs_wait_on_page_writeback(page, DATA);
+
+	inline_dentry = inline_data_addr(page);
+	bit_pos = dentry - inline_dentry->dentry;
+	for (i = 0; i < slots; i++)
+		test_and_clear_bit_le(bit_pos + i,
+				&inline_dentry->dentry_bitmap);
+
+	set_page_dirty(page);
+
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+
+	if (inode)
+		f2fs_drop_nlink(dir, inode, page);
+
+	f2fs_put_page(page, 1);
+}
+
+bool f2fs_empty_inline_dir(struct inode *dir)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
+	struct page *ipage;
+	unsigned int bit_pos = 2;
+	struct f2fs_inline_dentry *dentry_blk;
+
+	ipage = get_node_page(sbi, dir->i_ino);
+	if (IS_ERR(ipage))
+		return false;
+
+	dentry_blk = inline_data_addr(ipage);
+	bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
+					NR_INLINE_DENTRY,
+					bit_pos);
+
+	f2fs_put_page(ipage, 1);
+
+	if (bit_pos < NR_INLINE_DENTRY)
+		return false;
+
+	return true;
+}
+
+int f2fs_read_inline_dir(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	unsigned int bit_pos = 0;
+	struct f2fs_inline_dentry *inline_dentry = NULL;
+	struct f2fs_dir_entry *de = NULL;
+	struct page *ipage = NULL;
+	unsigned char d_type = DT_UNKNOWN;
+
+	if (ctx->pos == NR_INLINE_DENTRY)
+		return 0;
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	bit_pos = ((unsigned long)ctx->pos % NR_INLINE_DENTRY);
+
+	inline_dentry = inline_data_addr(ipage);
+	while (bit_pos < NR_INLINE_DENTRY) {
+		bit_pos = find_next_bit_le(&inline_dentry->dentry_bitmap,
+						NR_INLINE_DENTRY,
+						bit_pos);
+		if (bit_pos >= NR_INLINE_DENTRY)
+			break;
+
+		de = &inline_dentry->dentry[bit_pos];
+		if (de->file_type < F2FS_FT_MAX)
+			d_type = f2fs_filetype_table[de->file_type];
+		else
+			d_type = DT_UNKNOWN;
+
+		if (!dir_emit(ctx,
+				inline_dentry->filename[bit_pos],
+				le16_to_cpu(de->name_len),
+				le32_to_cpu(de->ino), d_type))
+			goto out;
+
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+		ctx->pos = bit_pos;
+	}
+
+	ctx->pos = NR_INLINE_DENTRY;
+out:
+	f2fs_put_page(ipage, 1);
+
+	return 0;
+}
-- 
2.0.1.474.g72c7794


