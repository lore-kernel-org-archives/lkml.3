Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaHTKg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:36:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14628 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHTKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:36:20 -0400
X-AuditID: cbfee61a-f79e46d00000134f-4e-53f47a15ca1c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-13-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-13-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 13/13] f2fs: handle EIO not to break fs
	consistency
Date: Wed, 20 Aug 2014 18:35:18 +0800
Message-id: <007f01cfbc62$8aeb3140$a0c193c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwHOJEfvm/jA0KA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQV3Rqi/BBveX6Fo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXF7QRNjwRXriivr
	DBsY/+h3MXJySAiYSGz/9pwZwhaTuHBvPVsXIxeHkMB0RonNt2YxQTg/GCX2zzwGVsUmoCKx
	vOM/E4gtIqAm0btvCpjNLJApMaH/BTuILSRQI/Flz0pGEJtTwEVi/gyIXmGBEIkTiz+wgdgs
	AqoSJ57/YO1i5ODgFbCU2HuoBiTMKyAo8WPyPRaIkVoSm7c1sULY8hKb17yFOlRBYsfZ14wQ
	J1hJbNo+lRmiRlxi45FbLBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZw2D+T2sG4ssHiEKMAB6MSD69C9udgIdbEsuLK3EOMEhzMSiK8PrlfgoV4UxIr
	q1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwxhR86HC7/bDoie6a
	8lVe5w+n2pY/4q1qlvst2/aRO5l1qs+NeQKnNxQVvTQx6Z7dOpsxOrxYLnamiphvt22+YReH
	6A75v2sLNTP47274UOVsJM0pnR77XbzU+8n7u01HXgbYWeiJncg6qNM14UnklzrP3QmrVqiL
	c3U+LF99Zukv0dqLBbuUWIozEg21mIuKEwGXZfIhdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 13/13] f2fs: handle EIO not to break fs consistency
> 
> There are two rules when EIO is occurred.
> 1. don't write any checkpoint data to preserve the previous checkpoint
> 2. don't lose the cached data/node/meta pages
> 
> So, at first, this patch adds set_page_dirty in f2fs_write_end_io's failure.
> Then, writing checkpoint/dentry/node blocks is not allowed.

do_checkpoint()
	/* wait for previous submitted node/meta pages writeback */
	wait_on_all_pages_writeback(sbi);

	if (unlikely(f2fs_cp_error(sbi)))
		return;
add here to prevent unneeded syncing for meta/node pages.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/checkpoint.c | 47 +++++++++++++++++++++++++++++++++--------------
>  fs/f2fs/data.c       | 10 +++++++++-
>  fs/f2fs/f2fs.h       |  1 +
>  fs/f2fs/node.c       |  2 ++
>  fs/f2fs/super.c      |  3 +++
>  5 files changed, 48 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index d074e27..b365c64 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -160,14 +160,11 @@ static int f2fs_write_meta_page(struct page *page,
>  		goto redirty_out;
>  	if (wbc->for_reclaim)
>  		goto redirty_out;
> -
> -	/* Should not write any meta pages, if any IO error was occurred */
>  	if (unlikely(f2fs_cp_error(sbi)))
> -		goto no_write;
> +		goto redirty_out;
> 
>  	f2fs_wait_on_page_writeback(page, META);
>  	write_meta_page(sbi, page);
> -no_write:
>  	dec_page_count(sbi, F2FS_DIRTY_META);
>  	unlock_page(page);
>  	return 0;
> @@ -348,7 +345,7 @@ bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
>  	return e ? true : false;
>  }
> 
> -static void release_dirty_inode(struct f2fs_sb_info *sbi)
> +void release_dirty_inode(struct f2fs_sb_info *sbi)
>  {
>  	struct ino_entry *e, *tmp;
>  	int i;
> @@ -737,7 +734,7 @@ retry:
>  /*
>   * Freeze all the FS-operations for checkpoint.
>   */
> -static void block_operations(struct f2fs_sb_info *sbi)
> +static int block_operations(struct f2fs_sb_info *sbi)
>  {
>  	struct writeback_control wbc = {
>  		.sync_mode = WB_SYNC_ALL,
> @@ -745,6 +742,7 @@ static void block_operations(struct f2fs_sb_info *sbi)
>  		.for_reclaim = 0,
>  	};
>  	struct blk_plug plug;
> +	int err = 0;
> 
>  	blk_start_plug(&plug);
> 
> @@ -754,6 +752,10 @@ retry_flush_dents:
>  	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
>  		f2fs_unlock_all(sbi);
>  		sync_dirty_dir_inodes(sbi);
> +		if (unlikely(f2fs_cp_error(sbi))) {
> +			err = -EIO;
> +			goto out;
> +		}
>  		goto retry_flush_dents;
>  	}
> 
> @@ -767,9 +769,16 @@ retry_flush_nodes:
>  	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
>  		up_write(&sbi->node_write);
>  		sync_node_pages(sbi, 0, &wbc);
> +		if (unlikely(f2fs_cp_error(sbi))) {
> +			f2fs_unlock_all(sbi);
> +			err = -EIO;
> +			goto out;
> +		}
>  		goto retry_flush_nodes;
>  	}
> +out:
>  	blk_finish_plug(&plug);
> +	return err;
>  }
> 
>  static void unblock_operations(struct f2fs_sb_info *sbi)
> @@ -813,8 +822,11 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>  	discard_next_dnode(sbi, NEXT_FREE_BLKADDR(sbi, curseg));
> 
>  	/* Flush all the NAT/SIT pages */
> -	while (get_pages(sbi, F2FS_DIRTY_META))
> +	while (get_pages(sbi, F2FS_DIRTY_META)) {
>  		sync_meta_pages(sbi, META, LONG_MAX);
> +		if (unlikely(f2fs_cp_error(sbi)))
> +			return;
> +	}
> 
>  	next_free_nid(sbi, &last_nid);
> 
> @@ -931,14 +943,19 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>  	sbi->last_valid_block_count = sbi->total_valid_block_count;
>  	sbi->alloc_valid_block_count = 0;
> 
> +	if (unlikely(f2fs_cp_error(sbi)))
> +		return;
> +
>  	/* Here, we only have one bio having CP pack */
>  	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
> 
> -	if (!f2fs_cp_error(sbi)) {
> -		clear_prefree_segments(sbi);
> -		release_dirty_inode(sbi);
> -		F2FS_RESET_SB_DIRT(sbi);
> -	}
> +	release_dirty_inode(sbi);
> +
> +	if (unlikely(f2fs_cp_error(sbi)))
> +		return;
> +
> +	clear_prefree_segments(sbi);
> +	F2FS_RESET_SB_DIRT(sbi);
>  }
> 
>  /*
> @@ -955,8 +972,10 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> 
>  	if (!sbi->s_dirty)
>  		goto out;
> -
> -	block_operations(sbi);
> +	if (unlikely(f2fs_cp_error(sbi)))
> +		goto out;
> +	if (block_operations(sbi))
> +		goto out;
> 
>  	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index ac3ccc2..68834e2 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -53,7 +53,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
>  		struct page *page = bvec->bv_page;
> 
>  		if (unlikely(err)) {
> -			SetPageError(page);
> +			set_page_dirty(page);
>  			set_bit(AS_EIO, &page->mapping->flags);
>  			f2fs_stop_checkpoint(sbi);
>  		}
> @@ -836,10 +836,18 @@ write:
> 
>  	/* Dentry blocks are controlled by checkpoint */
>  	if (S_ISDIR(inode->i_mode)) {
> +		if (unlikely(f2fs_cp_error(sbi)))
> +			goto redirty_out;
>  		err = do_write_data_page(page, &fio);
>  		goto done;
>  	}
> 
> +	if (unlikely(f2fs_cp_error(sbi))) {
> +		SetPageError(page);
> +		unlock_page(page);
> +		return 0;

Without redirtying it, we may lose cached page here which against the
second rule.

Thanks,
Yu


> +	}
> +
>  	if (!wbc->for_reclaim)
>  		need_balance_fs = true;
>  	else if (has_not_enough_free_secs(sbi, 0))
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 46ceb88..2d009ae 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1267,6 +1267,7 @@ int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
>  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
>  void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
>  void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> +void release_dirty_inode(struct f2fs_sb_info *);
>  bool exist_written_data(struct f2fs_sb_info *, nid_t, int);
>  int acquire_orphan_inode(struct f2fs_sb_info *);
>  void release_orphan_inode(struct f2fs_sb_info *);
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 9f126f8..d2f7842 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1215,6 +1215,8 @@ static int f2fs_write_node_page(struct page *page,
> 
>  	if (unlikely(sbi->por_doing))
>  		goto redirty_out;
> +	if (unlikely(f2fs_cp_error(sbi)))
> +		goto redirty_out;
> 
>  	f2fs_wait_on_page_writeback(page, NODE);
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index c4f90cd..c999d67 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -435,6 +435,9 @@ static void f2fs_put_super(struct super_block *sb)
>  	if (sbi->s_dirty)
>  		write_checkpoint(sbi, true);
> 
> +	/* EIO will skip do checkpoint, so here we need to release this */
> +	release_dirty_inode(sbi);
> +
>  	iput(sbi->node_inode);
>  	iput(sbi->meta_inode);
> 
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

