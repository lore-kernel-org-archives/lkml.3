Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaG2LjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:39:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36250 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaG2LjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:39:13 -0400
X-AuditID: cbfee61b-f79f86d00000144c-de-53d787dfb46c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-5-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-5-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 05/11] f2fs: add info of appended or updated
 data	writes
Date: Tue, 29 Jul 2014 19:38:21 +0800
Message-id: <008101cfab21$b661b1c0$23251540$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgE/8GXam2JGDDA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd377deDDZ4s5rN4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK6O9o4m5YKdexYHD
	D1gbGCeodTFyckgImEjs+fuaHcIWk7hwbz1bFyMXh5DAIkaJa+9OsEA4Pxglti1ZxAxSxSag
	IrG84z8TiC0ioCbRu28KmM0skCkxof8F2CQhgWqJ+4f/s4HYnALOEieX3GYEsYUFIiX+XLrA
	CmKzCKhK3DmzkgXE5hWwlHjYOp8NwhaU+DH5HgvETC2J9TuPQ82Xl9i85i0zxKUKEjvOvmaE
	iItLbDxyiwXiHiuJZzuPsE9gFJqFZNQsJKNmIRk1C0n7AkaWVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBof9MegfjqgaLQ4wCHIxKPLwb5l4LFmJNLCuuzD3EKMHBrCTC+6L8erAQb0pi
	ZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxg7H2gdmBS6yOQ0M
	pyYXPpEOnPPrWc7xYK/ZGw1mvD2/Iv3UK7b704UsTqXbTFJ6debptrrleYr+RbPXJi/1WCuX
	2P5yy9Gayt3NGyemuLG99qu/UXb3zH6fxDVLN+/2q734wnHuV805+tpJXjXvL726ov7ehPfb
	bAYbbZEH2hMUEzJ3SlR/0FJiKc5INNRiLipOBADyGAf+eQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 05/11] f2fs: add info of appended or updated data writes
> 
> This patch introduces a inode number list in which represents inodes having
> appended data writes or updated data writes after last checkpoint.
> This will be used at fsync to determine whether the recovery information
> should be written or not.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/checkpoint.c | 39 +++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/data.c       |  2 ++
>  fs/f2fs/f2fs.h       |  7 +++++++
>  fs/f2fs/inode.c      |  4 ++++
>  4 files changed, 52 insertions(+)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index d35094a..42a16c1 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -325,6 +325,44 @@ static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int
> type)
>  	spin_unlock(&sbi->ino_lock[type]);
>  }
> 
> +void add_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
> +{
> +	/* add new dirty ino entry into list */
> +	__add_ino_entry(sbi, ino, type);
> +}
> +
> +void remove_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
> +{
> +	/* remove dirty ino entry from list */
> +	__remove_ino_entry(sbi, ino, type);
> +}
> +
> +/* mode should be APPEND_INO or UPDATE_INO */
> +bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
> +{
> +	struct ino_entry *e;
> +	spin_lock(&sbi->ino_lock[mode]);
> +	e = radix_tree_lookup(&sbi->ino_root[mode], ino);
> +	spin_unlock(&sbi->ino_lock[mode]);
> +	return e ? true : false;
> +}
> +
> +static void release_dirty_inode(struct f2fs_sb_info *sbi)
> +{
> +	struct ino_entry *e, *tmp;
> +	int i;
> +
> +	for (i = APPEND_INO; i <= UPDATE_INO; i++) {
> +		spin_lock(&sbi->ino_lock[i]);
> +		list_for_each_entry_safe(e, tmp, &sbi->ino_list[i], list) {
> +			list_del(&e->list);
> +			radix_tree_delete(&sbi->ino_root[i], e->ino);
> +			kmem_cache_free(ino_entry_slab, e);
> +		}
> +		spin_unlock(&sbi->ino_lock[i]);
> +	}
> +}
> +
>  int acquire_orphan_inode(struct f2fs_sb_info *sbi)
>  {
>  	int err = 0;
> @@ -896,6 +934,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> 
>  	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
>  		clear_prefree_segments(sbi);
> +		release_dirty_inode(sbi);
>  		F2FS_RESET_SB_DIRT(sbi);
>  	}
>  }
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 482313d..ec3c886 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -789,9 +789,11 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
>  			!is_cold_data(page) &&
>  			need_inplace_update(inode))) {
>  		rewrite_data_page(page, old_blkaddr, fio);
> +		set_inode_flag(F2FS_I(inode), FI_UPDATE_WRITE);
>  	} else {
>  		write_data_page(page, &dn, &new_blkaddr, fio);
>  		update_extent_cache(new_blkaddr, &dn);
> +		set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
>  	}
>  out_writepage:
>  	f2fs_put_dnode(&dn);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 4454caa..ab36025 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -103,6 +103,8 @@ enum {
>  /* for the list of ino */
>  enum {
>  	ORPHAN_INO,		/* for orphan ino list */
> +	APPEND_INO,		/* for append ino list */
> +	UPDATE_INO,		/* for update ino list */
>  	MAX_INO_ENTRY,		/* max. list */
>  };
> 
> @@ -994,6 +996,8 @@ enum {
>  	FI_NO_EXTENT,		/* not to use the extent cache */
>  	FI_INLINE_XATTR,	/* used for inline xattr */
>  	FI_INLINE_DATA,		/* used for inline data*/
> +	FI_APPEND_WRITE,	/* inode has appended data */
> +	FI_UPDATE_WRITE,	/* inode has in-place-update data */
>  };
> 
>  static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
> @@ -1252,6 +1256,9 @@ struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
>  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
>  int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
>  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
> +void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> +void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> +bool exist_written_data(struct f2fs_sb_info *, nid_t, int);
>  int acquire_orphan_inode(struct f2fs_sb_info *);
>  void release_orphan_inode(struct f2fs_sb_info *);
>  void add_orphan_inode(struct f2fs_sb_info *, nid_t);
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index cafba3c..0e69aa9 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -296,6 +296,10 @@ void f2fs_evict_inode(struct inode *inode)
>  	sb_end_intwrite(inode->i_sb);
>  no_delete:
>  	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
> +	if (is_inode_flag_set(F2FS_I(inode), FI_APPEND_WRITE))
> +		add_dirty_inode(sbi, inode->i_ino, APPEND_INO);
> +	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_WRITE))
> +		add_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
>  out_clear:
>  	clear_inode(inode);
>  }
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

