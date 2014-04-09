Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbaDIJqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:46:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbaDIJqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:46:48 -0400
Date: Wed, 9 Apr 2014 11:46:44 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 11/22] Replace ext2_clear_xip_target with
 dax_clear_blocks
Message-ID: <20140409094644.GD32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <b94af75d7123feced8ea8ba42d1d0e7c740d5009.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b94af75d7123feced8ea8ba42d1d0e7c740d5009.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:37, Matthew Wilcox wrote:
> This is practically generic code; other filesystems will want to call
> it from other places, but there's nothing ext2-specific about it.
> 
> Make it a little more generic by allowing it to take a count of the number
> of bytes to zero rather than fixing it to a single page.  Thanks to Dave
> Hansen for suggesting that I need to call cond_resched() if zeroing more
> than one page.
  Another day, some more review ;) Comments below.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/dax.c           | 34 ++++++++++++++++++++++++++++++++++
>  fs/ext2/inode.c    |  8 +++++---
>  fs/ext2/xip.c      | 23 -----------------------
>  fs/ext2/xip.h      |  3 ---
>  include/linux/fs.h |  6 ++++++
>  5 files changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 7271be0..45a0a41 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -23,9 +23,43 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm.h>
>  #include <linux/mutex.h>
> +#include <linux/sched.h>
>  #include <linux/uio.h>
>  #include <linux/vmstat.h>
>  
> +int dax_clear_blocks(struct inode *inode, sector_t block, long size)
> +{
> +	struct block_device *bdev = inode->i_sb->s_bdev;
> +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> +	sector_t sector = block << (inode->i_blkbits - 9);
> +	unsigned long pfn;
> +
> +	might_sleep();
> +	do {
> +		void *addr;
> +		long count = ops->direct_access(bdev, sector, &addr, &pfn,
> +									size);
  So do you assume blocksize == PAGE_SIZE here? If not, addr could be in
the middle of the page AFAICT.

> +		if (count < 0)
> +			return count;
> +		while (count >= PAGE_SIZE) {
> +			clear_page(addr);
> +			addr += PAGE_SIZE;
> +			size -= PAGE_SIZE;
> +			count -= PAGE_SIZE;
> +			sector += PAGE_SIZE / 512;
> +			cond_resched();
> +		}
> +		if (count > 0) {
> +			memset(addr, 0, count);
> +			sector += count / 512;
> +			size -= count;
> +		}
> +	} while (size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_clear_blocks);
> +
>  static long dax_get_addr(struct inode *inode, struct buffer_head *bh,
>  								void **addr)
>  {
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index b156fe8..a9346a9 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -733,10 +733,12 @@ static int ext2_get_blocks(struct inode *inode,
>  
>  	if (IS_DAX(inode)) {
>  		/*
> -		 * we need to clear the block
> +		 * block must be initialised before we put it in the tree
> +		 * so that it's not found by another thread before it's
> +		 * initialised
>  		 */
> -		err = ext2_clear_xip_target (inode,
> -			le32_to_cpu(chain[depth-1].key));
> +		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
> +						count << inode->i_blkbits);
  Umm 'count' looks wrong here. You want to clear only one block, don't
you?

>  		if (err) {
>  			mutex_unlock(&ei->truncate_mutex);
>  			goto cleanup;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
