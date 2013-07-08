Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3GHQGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:06:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3GHQGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:06:06 -0400
Date: Mon, 8 Jul 2013 18:06:02 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] writeback: Do not sort b_io list only because of block
 device inode
Message-ID: <20130708160602.GA14739@quack.suse.cz>
References: <1372061269-16663-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372061269-16663-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24-06-13 10:07:49, Jan Kara wrote:
> It is very likely that block device inode will be part of BDI dirty list
> as well. However it doesn't make sence to sort inodes on the b_io list
> just because of this inode (as it contains buffers all over the device
> anyway). So save some CPU cycles which is valuable since we hold relatively
> contented wb->list_lock.
  Ping? Fengguang, can you merge the patch please?

								Honza

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/block_dev.c     | 2 +-
>  fs/fs-writeback.c  | 8 +++++---
>  include/linux/fs.h | 6 ++++++
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 2091db8..2562330 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -606,7 +606,7 @@ static struct block_device *bd_acquire(struct inode *inode)
>  	return bdev;
>  }
>  
> -static inline int sb_is_blkdev_sb(struct super_block *sb)
> +int sb_is_blkdev_sb(struct super_block *sb)
>  {
>  	return sb == blockdev_superblock;
>  }
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3be5718..cabdece 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -68,7 +68,7 @@ static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
>  
> -	if (strcmp(sb->s_type->name, "bdev") == 0)
> +	if (sb_is_blkdev_sb(sb))
>  		return inode->i_mapping->backing_dev_info;
>  
>  	return sb->s_bdi;
> @@ -250,11 +250,13 @@ static int move_expired_inodes(struct list_head *delaying_queue,
>  		if (work->older_than_this &&
>  		    inode_dirtied_after(inode, *work->older_than_this))
>  			break;
> +		list_move(&inode->i_wb_list, &tmp);
> +		moved++;
> +		if (sb_is_blkdev_sb(inode->i_sb))
> +			continue;
>  		if (sb && sb != inode->i_sb)
>  			do_sb_sort = 1;
>  		sb = inode->i_sb;
> -		list_move(&inode->i_wb_list, &tmp);
> -		moved++;
>  	}
>  
>  	/* just one sb in list, splice to dispatch_queue and we're done */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 43db02e..8f897d0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2058,6 +2058,7 @@ extern struct super_block *freeze_bdev(struct block_device *);
>  extern void emergency_thaw_all(void);
>  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
>  extern int fsync_bdev(struct block_device *);
> +extern int sb_is_blkdev_sb(struct super_block *sb);
>  #else
>  static inline void bd_forget(struct inode *inode) {}
>  static inline int sync_blockdev(struct block_device *bdev) { return 0; }
> @@ -2077,6 +2078,11 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  static inline void iterate_bdevs(void (*f)(struct block_device *, void *), void *arg)
>  {
>  }
> +
> +static inline int sb_is_blkdev_sb(struct super_block *sb)
> +{
> +	return 0;
> +}
>  #endif
>  extern int sync_filesystem(struct super_block *);
>  extern const struct file_operations def_blk_fops;
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
