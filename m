Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaHUUpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:45:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:56890 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbaHUUpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:45:18 -0400
Date: Thu, 21 Aug 2014 13:45:17 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 3/5] f2fs: add key function to handle inline dir
Message-ID: <20140821204517.GB85961@jaegeuk-mac02.mot-mobility.com>
References: <00c101cfb37c$79a58140$6cf083c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c101cfb37c$79a58140$6cf083c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Sat, Aug 09, 2014 at 10:48:20AM +0800, Chao Yu wrote:
> Adds Functions to implement inline dir init/lookup/insert/delete/convert ops.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/f2fs.h   |   9 ++
>  fs/f2fs/inline.c | 388 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 397 insertions(+)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 58c1a49..436a498 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1450,4 +1450,13 @@ int f2fs_convert_inline_data(struct inode *, pgoff_t);
>  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
>  void truncate_inline_data(struct inode *, u64);
>  int recover_inline_data(struct inode *, struct page *);
> +struct f2fs_dir_entry *find_in_inline_dir(struct inode *, struct qstr *,
> +							struct page **);
> +struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *, struct page **);
> +int make_empty_inline_dir(struct inode *inode, struct inode *, struct page *);
> +int f2fs_add_inline_entry(struct inode *, const struct qstr *, struct inode *);
> +void f2fs_delete_inline_entry(struct f2fs_dir_entry *, struct page *,
> +						struct inode *, struct inode *);
> +bool f2fs_empty_inline_dir(struct inode *);
> +int f2fs_read_inline_dir(struct file *, struct dir_context *);
>  #endif
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index 5beecce..58d2623 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -249,3 +249,391 @@ process_inline:
>  	}
>  	return 0;
>  }
> +
> +struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
> +				struct qstr *name, struct page **res_page)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +	struct page *ipage;
> +	struct f2fs_dir_entry *de;
> +	f2fs_hash_t namehash;
> +	unsigned long bit_pos = 0;
> +	struct f2fs_inline_dentry *dentry_blk;
> +	const void *dentry_bits;
> +
> +	ipage = get_node_page(sbi, dir->i_ino);
> +	if (IS_ERR(ipage))
> +		return NULL;
> +
> +	namehash = f2fs_dentry_hash(name);
> +
> +	kmap(ipage);

Don't need kmap for ipage.

> +	dentry_blk = inline_data_addr(ipage);
> +	dentry_bits = &dentry_blk->dentry_bitmap;
> +
> +	while (bit_pos < NR_INLINE_DENTRY) {
> +		if (!test_bit_le(bit_pos, dentry_bits)) {
> +			bit_pos++;
> +			continue;
> +		}
> +		de = &dentry_blk->dentry[bit_pos];
> +		if (early_match_name(name->len, namehash, de)) {
> +			if (!memcmp(dentry_blk->filename[bit_pos],
> +							name->name,
> +							name->len)) {
> +				*res_page = ipage;
> +				goto found;
> +			}
> +		}
> +
> +		/*
> +		 * For the most part, it should be a bug when name_len is zero.
> +		 * We stop here for figuring out where the bugs are occurred.
> +		 */
> +		f2fs_bug_on(!de->name_len);
> +
> +		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> +	}
> +
> +	de = NULL;
> +	kunmap(ipage);

Ditto.

> +found:
> +	unlock_page(ipage);
> +	return de;
> +}
> +
> +struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *dir,
> +							struct page **p)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +	struct page *ipage;
> +	struct f2fs_dir_entry *de;
> +	struct f2fs_inline_dentry *dentry_blk;
> +
> +	ipage = get_node_page(sbi, dir->i_ino);
> +	if (IS_ERR(ipage))
> +		return NULL;
> +
> +	kmap(ipage);

Ditto.

> +	dentry_blk = inline_data_addr(ipage);
> +	de = &dentry_blk->dentry[1];
> +	*p = ipage;
> +	unlock_page(ipage);
> +	return de;
> +}
> +
> +int make_empty_inline_dir(struct inode *inode, struct inode *parent,
> +							struct page *ipage)
> +{
> +	struct f2fs_inline_dentry *dentry_blk;
> +	struct f2fs_dir_entry *de;
> +
> +	dentry_blk = inline_data_addr(ipage);
> +
> +	de = &dentry_blk->dentry[0];
> +	de->name_len = cpu_to_le16(1);
> +	de->hash_code = 0;
> +	de->ino = cpu_to_le32(inode->i_ino);
> +	memcpy(dentry_blk->filename[0], ".", 1);
> +	set_de_type(de, inode);
> +
> +	de = &dentry_blk->dentry[1];
> +	de->hash_code = 0;
> +	de->name_len = cpu_to_le16(2);
> +	de->ino = cpu_to_le32(parent->i_ino);
> +	memcpy(dentry_blk->filename[1], "..", 2);
> +	set_de_type(de, inode);
> +
> +	test_and_set_bit_le(0, &dentry_blk->dentry_bitmap);
> +	test_and_set_bit_le(1, &dentry_blk->dentry_bitmap);
> +
> +	set_page_dirty(ipage);
> +
> +	/* update i_size to MAX_INLINE_DATA */
> +	if (i_size_read(inode) < MAX_INLINE_DATA) {
> +		i_size_write(inode, MAX_INLINE_DATA);
> +		set_inode_flag(F2FS_I(inode), FI_UPDATE_DIR);
> +	}
> +	return 0;
> +}
> +
> +int room_in_inline_dir(struct f2fs_inline_dentry *dentry_blk, int slots)
> +{
> +	int bit_start = 0;
> +	int zero_start, zero_end;
> +next:
> +	zero_start = find_next_zero_bit_le(&dentry_blk->dentry_bitmap,
> +						NR_INLINE_DENTRY,
> +						bit_start);
> +	if (zero_start >= NR_INLINE_DENTRY)
> +		return NR_INLINE_DENTRY;
> +
> +	zero_end = find_next_bit_le(&dentry_blk->dentry_bitmap,
> +						NR_INLINE_DENTRY,
> +						zero_start);
> +	if (zero_end - zero_start >= slots)
> +		return zero_start;
> +
> +	bit_start = zero_end + 1;
> +
> +	if (zero_end + 1 >= NR_INLINE_DENTRY)
> +		return NR_INLINE_DENTRY;
> +	goto next;
> +}
> +
> +int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
> +				struct f2fs_inline_dentry *inline_dentry)
> +{
> +	struct page *page;
> +	struct dnode_of_data dn;
> +	block_t new_blk_addr;
> +	struct f2fs_dentry_block *dentry_blk;
> +	struct f2fs_io_info fio = {
> +		.type = DATA,
> +		.rw = WRITE_SYNC | REQ_PRIO,
> +	};
> +	int err;
> +
> +	page = grab_cache_page(dir->i_mapping, 0);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	set_new_dnode(&dn, dir, ipage, NULL, 0);
> +	err = f2fs_reserve_block(&dn, 0);
> +	if (err)
> +		goto out;

At a glance, we don't need to care about dentry blocks to sync, since checkpoint
handles that.
It needs to consider about checkpoint and f2fs_sync_file.

The addition and deletion stuffs are almost same as the existing codes.
Can we reuse those to avoid potential bugs?

And it'd be better to add inline_dentry mount option separately for now.

Thanks,

> +
> +	f2fs_wait_on_page_writeback(page, DATA);
> +	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
> +
> +	dentry_blk = kmap(page);
> +
> +	/* copy data from inline dentry block to new dentry block */
> +	memcpy(dentry_blk->dentry_bitmap, inline_dentry->dentry_bitmap,
> +					INLINE_DENTRY_BITMAP_SIZE);
> +	memcpy(dentry_blk->reserved, inline_dentry->reserved,
> +					INLINE_RESERVED_SIZE);
> +	memcpy(dentry_blk->dentry, inline_dentry->dentry,
> +			sizeof(struct f2fs_dir_entry) * NR_INLINE_DENTRY);
> +	memcpy(dentry_blk->filename, inline_dentry->filename,
> +					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
> +
> +	kunmap(page);
> +	SetPageUptodate(page);
> +
> +	/* writeback dentry page to make data consistent */
> +	set_page_writeback(page);
> +	write_data_page(page, &dn, &new_blk_addr, &fio);
> +	update_extent_cache(new_blk_addr, &dn);
> +	f2fs_wait_on_page_writeback(page, DATA);
> +
> +	/* clear inline dir and flag after data writeback */
> +	zero_user_segment(ipage, INLINE_DATA_OFFSET,
> +				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> +	clear_inode_flag(F2FS_I(dir), FI_INLINE_DATA);
> +	stat_dec_inline_inode(dir);
> +
> +	if (i_size_read(dir) < PAGE_CACHE_SIZE) {
> +		i_size_write(dir, PAGE_CACHE_SIZE);
> +		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
> +	}
> +
> +	sync_inode_page(&dn);
> +out:
> +
> +	f2fs_put_page(page, 1);
> +	return err;
> +}
> +
> +int f2fs_add_inline_entry(struct inode *dir, const struct qstr *name,
> +						struct inode *inode)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +	struct page *ipage;
> +	unsigned int bit_pos;
> +	f2fs_hash_t name_hash;
> +	struct f2fs_dir_entry *de;
> +	size_t namelen = name->len;
> +	struct f2fs_inline_dentry *dentry_blk = NULL;
> +	int slots = GET_DENTRY_SLOTS(namelen);
> +	struct page *page;
> +	int err = 0;
> +	int i;
> +
> +	name_hash = f2fs_dentry_hash(name);
> +
> +	ipage = get_node_page(sbi, dir->i_ino);
> +	if (IS_ERR(ipage))
> +		return PTR_ERR(ipage);
> +
> +	kmap(ipage);
> +	dentry_blk = inline_data_addr(ipage);
> +	bit_pos = room_in_inline_dir(dentry_blk, slots);
> +	if (bit_pos >= NR_INLINE_DENTRY) {
> +		err = f2fs_convert_inline_dir(dir, ipage, dentry_blk);
> +		if (!err)
> +			err = -EAGAIN;
> +		goto out;
> +	}
> +
> +	f2fs_wait_on_page_writeback(ipage, DATA);
> +
> +	down_write(&F2FS_I(inode)->i_sem);
> +	page = init_inode_metadata(inode, dir, name);
> +	if (IS_ERR(page)) {
> +		err = PTR_ERR(page);
> +		goto fail;
> +	}
> +	de = &dentry_blk->dentry[bit_pos];
> +	de->hash_code = name_hash;
> +	de->name_len = cpu_to_le16(namelen);
> +	memcpy(dentry_blk->filename[bit_pos], name->name, name->len);
> +	de->ino = cpu_to_le32(inode->i_ino);
> +	set_de_type(de, inode);
> +	for (i = 0; i < slots; i++)
> +		test_and_set_bit_le(bit_pos + i, &dentry_blk->dentry_bitmap);
> +	set_page_dirty(ipage);
> +
> +	/* we don't need to mark_inode_dirty now */
> +	F2FS_I(inode)->i_pino = dir->i_ino;
> +	update_inode(inode, page);
> +	f2fs_put_page(page, 1);
> +
> +	update_parent_metadata(dir, inode, 0);
> +fail:
> +	up_write(&F2FS_I(inode)->i_sem);
> +
> +	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR)) {
> +		update_inode(dir, ipage);
> +		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
> +	}
> +out:
> +	kunmap(ipage);
> +	f2fs_put_page(ipage, 1);
> +	return err;
> +}
> +
> +void f2fs_delete_inline_entry(struct f2fs_dir_entry *dentry, struct page *page,
> +					struct inode *dir, struct inode *inode)
> +{
> +	struct f2fs_inline_dentry *inline_dentry;
> +	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
> +	unsigned int bit_pos;
> +	int i;
> +
> +	lock_page(page);
> +	f2fs_wait_on_page_writeback(page, DATA);
> +
> +	inline_dentry = inline_data_addr(page);
> +	bit_pos = dentry - inline_dentry->dentry;
> +	for (i = 0; i < slots; i++)
> +		test_and_clear_bit_le(bit_pos + i,
> +				&inline_dentry->dentry_bitmap);
> +	kunmap(page);
> +	set_page_dirty(page);
> +
> +	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +
> +	if (inode) {
> +		struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +
> +		down_write(&F2FS_I(inode)->i_sem);
> +
> +		if (S_ISDIR(inode->i_mode)) {
> +			drop_nlink(dir);
> +			update_inode(dir, page);
> +		}
> +		inode->i_ctime = CURRENT_TIME;
> +
> +		drop_nlink(inode);
> +		if (S_ISDIR(inode->i_mode)) {
> +			drop_nlink(inode);
> +			i_size_write(inode, 0);
> +		}
> +		up_write(&F2FS_I(inode)->i_sem);
> +		update_inode_page(inode);
> +
> +		if (inode->i_nlink == 0)
> +			add_orphan_inode(sbi, inode->i_ino);
> +		else
> +			release_orphan_inode(sbi);
> +	}
> +
> +	f2fs_put_page(page, 1);
> +}
> +
> +bool f2fs_empty_inline_dir(struct inode *dir)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +	struct page *ipage;
> +	unsigned int bit_pos = 2;
> +	struct f2fs_inline_dentry *dentry_blk;
> +
> +	ipage = get_node_page(sbi, dir->i_ino);
> +	if (IS_ERR(ipage))
> +		return false;
> +
> +	dentry_blk = inline_data_addr(ipage);
> +	bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
> +					NR_INLINE_DENTRY,
> +					bit_pos);
> +
> +	f2fs_put_page(ipage, 1);
> +
> +	if (bit_pos < NR_INLINE_DENTRY)
> +		return false;
> +
> +	return true;
> +}
> +
> +int f2fs_read_inline_dir(struct file *file, struct dir_context *ctx)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +	unsigned int bit_pos = 0;
> +	struct f2fs_inline_dentry *inline_dentry = NULL;
> +	struct f2fs_dir_entry *de = NULL;
> +	struct page *ipage = NULL;
> +	unsigned char d_type = DT_UNKNOWN;
> +
> +	if (ctx->pos == NR_INLINE_DENTRY)
> +		return 0;
> +
> +	ipage = get_node_page(sbi, inode->i_ino);
> +	if (IS_ERR(ipage))
> +		return PTR_ERR(ipage);
> +
> +	bit_pos = ((unsigned long)ctx->pos % NR_INLINE_DENTRY);
> +
> +	inline_dentry = inline_data_addr(ipage);
> +	while (bit_pos < NR_INLINE_DENTRY) {
> +		bit_pos = find_next_bit_le(&inline_dentry->dentry_bitmap,
> +						NR_INLINE_DENTRY,
> +						bit_pos);
> +		if (bit_pos >= NR_INLINE_DENTRY)
> +			break;
> +
> +		de = &inline_dentry->dentry[bit_pos];
> +		if (de->file_type < F2FS_FT_MAX)
> +			d_type = f2fs_filetype_table[de->file_type];
> +		else
> +			d_type = DT_UNKNOWN;
> +
> +		if (!dir_emit(ctx,
> +				inline_dentry->filename[bit_pos],
> +				le16_to_cpu(de->name_len),
> +				le32_to_cpu(de->ino), d_type))
> +			goto out;
> +
> +		f2fs_bug_on(!de->name_len);
> +
> +		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> +		ctx->pos = bit_pos;
> +	}
> +
> +	ctx->pos = NR_INLINE_DENTRY;
> +out:
> +	f2fs_put_page(ipage, 1);
> +
> +	return 0;
> +}
> -- 
> 2.0.1.474.g72c7794
