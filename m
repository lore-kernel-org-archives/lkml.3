Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaHSIFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:05:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHSIFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:05:10 -0400
X-AuditID: cbfee61b-f79f86d00000144c-4a-53f305283063
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1408140229-54949-1-git-send-email-jaegeuk@kernel.org>
 <1408140229-54949-3-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1408140229-54949-3-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 3/4] f2fs: avoid double lock in truncate_blocks
Date: Tue, 19 Aug 2014 16:04:11 +0800
Message-id: <003401cfbb84$441c5b60$cc551220$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC+/WSTKaabHp5RCw8XejVnDbERIwIb0v+CnegYpIA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAV1N1s/BBncnsVk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAldF2pZetYJ9mxbGL
	+5kbGD8pdjFyckgImEisvnefBcIWk7hwbz1bFyMXh5DAIkYgZz8ThPODUeLtg59sIFVsAioS
	yzv+M4HYIgJqEr37poDZzAKZEhP6X7CD2EIC1RIdd1+D1XMKOEv8234eKM7BISzgJ7HrWA5I
	mEVAVWLBkW6wEl4BS4ndd+6zQtiCEj8m32OBGKklsXlbEyuELS+xec1bZohDFSR2nH3NCHGC
	lcS2zj5miBpxiY1HbrFMYBSahWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwYH/THoH46oGi0OMAhyMSjy8Cl8+BguxJpYVV+YeYpTgYFYS4XV88SlYiDclsbIq
	tSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2OU2NvIl8LMR17uniud
	N2XLOZ5716TeFxgedi40PiFRHdHC891SiUn8/cu3D65vr5bY++/4L56vEqV2sRM6xdIa3BRL
	PscGzDsmISV/2bbXeNGiIMU5m4qrrwr8WBG3qS1a+IK0fT4Ly2KnA6kx+g03O19U7FZ/+Mzq
	r0L3ohwHoyxZ5znhUkosxRmJhlrMRcWJAESBNyJ4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, August 16, 2014 6:04 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 3/4] f2fs: avoid double lock in truncate_blocks
> 
> The init_inode_metadata calls truncate_blocks when error is occurred.
> The callers holds f2fs_lock_op, so we should not call it again in
> truncate_blocks.

Nice catch! Your solution is a good way to fix this issue.

Previously, in create inode path, I found there are some redundant codes between
init_inode_metadata and evict_inode, including:
	truncate_inode_pages(&inode->i_data, 0);
	truncate_blocks(inode, 0);
	remove_dirty_dir_inode(inode);
	remove_inode_page(inode); 

So I think there is another way to fix this issue by removing error path handling
codes in init_inode_metadata, not making the inode bad to left garbage clean work in
evict_inode. In this way we can avoid adding additional argument for all different
callers.

How do you think?

Thanks,
Yu

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/data.c   |  2 +-
>  fs/f2fs/dir.c    |  2 +-
>  fs/f2fs/f2fs.h   |  2 +-
>  fs/f2fs/file.c   | 13 ++++++++-----
>  fs/f2fs/inline.c |  2 +-
>  5 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 68834e2..14cc3e8 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -935,7 +935,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
> 
>  	if (to > inode->i_size) {
>  		truncate_pagecache(inode, inode->i_size);
> -		truncate_blocks(inode, inode->i_size);
> +		truncate_blocks(inode, inode->i_size, true);
>  	}
>  }
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index a69bbfa..155fb05 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -391,7 +391,7 @@ put_error:
>  error:
>  	/* once the failed inode becomes a bad inode, i_mode is S_IFREG */
>  	truncate_inode_pages(&inode->i_data, 0);
> -	truncate_blocks(inode, 0);
> +	truncate_blocks(inode, 0, false);
>  	remove_dirty_dir_inode(inode);
>  	remove_inode_page(inode);
>  	return ERR_PTR(err);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2723b2d..7f976c1 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1122,7 +1122,7 @@ static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
>   */
>  int f2fs_sync_file(struct file *, loff_t, loff_t, int);
>  void truncate_data_blocks(struct dnode_of_data *);
> -int truncate_blocks(struct inode *, u64);
> +int truncate_blocks(struct inode *, u64, bool);
>  void f2fs_truncate(struct inode *);
>  int f2fs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  int f2fs_setattr(struct dentry *, struct iattr *);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index ecbdf6a..a8e97f8 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -422,7 +422,7 @@ out:
>  	f2fs_put_page(page, 1);
>  }
> 
> -int truncate_blocks(struct inode *inode, u64 from)
> +int truncate_blocks(struct inode *inode, u64 from, bool lock)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	unsigned int blocksize = inode->i_sb->s_blocksize;
> @@ -438,14 +438,16 @@ int truncate_blocks(struct inode *inode, u64 from)
>  	free_from = (pgoff_t)
>  			((from + blocksize - 1) >> (sbi->log_blocksize));
> 
> -	f2fs_lock_op(sbi);
> +	if (lock)
> +		f2fs_lock_op(sbi);
> 
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
>  	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
>  	if (err) {
>  		if (err == -ENOENT)
>  			goto free_next;
> -		f2fs_unlock_op(sbi);
> +		if (lock)
> +			f2fs_unlock_op(sbi);
>  		trace_f2fs_truncate_blocks_exit(inode, err);
>  		return err;
>  	}
> @@ -463,7 +465,8 @@ int truncate_blocks(struct inode *inode, u64 from)
>  	f2fs_put_dnode(&dn);
>  free_next:
>  	err = truncate_inode_blocks(inode, free_from);
> -	f2fs_unlock_op(sbi);
> +	if (lock)
> +		f2fs_unlock_op(sbi);
>  done:
>  	/* lastly zero out the first data page */
>  	truncate_partial_data_page(inode, from);
> @@ -480,7 +483,7 @@ void f2fs_truncate(struct inode *inode)
> 
>  	trace_f2fs_truncate(inode);
> 
> -	if (!truncate_blocks(inode, i_size_read(inode))) {
> +	if (!truncate_blocks(inode, i_size_read(inode), true)) {
>  		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  		mark_inode_dirty(inode);
>  	}
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index 520758b..4d1f39f 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -247,7 +247,7 @@ process_inline:
>  		update_inode(inode, ipage);
>  		f2fs_put_page(ipage, 1);
>  	} else if (ri && (ri->i_inline & F2FS_INLINE_DATA)) {
> -		truncate_blocks(inode, 0);
> +		truncate_blocks(inode, 0, false);
>  		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
>  		goto process_inline;
>  	}
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

