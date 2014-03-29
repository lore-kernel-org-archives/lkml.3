Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaCaK2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:28:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbaCaK2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:28:13 -0400
Date: Sat, 29 Mar 2014 17:30:28 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 04/22] Change direct_access calling convention
Message-ID: <20140329163028.GD1211@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <214af2a38d840d0b8e983d39d03711d1292bc2d6.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214af2a38d840d0b8e983d39d03711d1292bc2d6.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:30, Matthew Wilcox wrote:
> In order to support accesses to larger chunks of memory, pass in a
> 'size' parameter (counted in bytes), and return the amount available at
> that address.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
  Two minor nits below. Other than that you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

> ---
>  Documentation/filesystems/xip.txt | 15 +++++++++------
>  arch/powerpc/sysdev/axonram.c     |  6 +++---
>  drivers/block/brd.c               |  8 +++++---
>  drivers/s390/block/dcssblk.c      | 19 ++++++++++---------
>  fs/ext2/xip.c                     | 30 +++++++++++++-----------------
>  include/linux/blkdev.h            |  4 ++--
>  6 files changed, 42 insertions(+), 40 deletions(-)
> 
...
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index e73b85c..00da60d 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -361,8 +361,8 @@ out:
>  }
>  
>  #ifdef CONFIG_BLK_DEV_XIP
> -static int brd_direct_access(struct block_device *bdev, sector_t sector,
> -			void **kaddr, unsigned long *pfn)
> +static long brd_direct_access(struct block_device *bdev, sector_t sector,
> +			void **kaddr, unsigned long *pfn, long size)
>  {
>  	struct brd_device *brd = bdev->bd_disk->private_data;
>  	struct page *page;
> @@ -379,7 +379,9 @@ static int brd_direct_access(struct block_device *bdev, sector_t sector,
>  	*kaddr = page_address(page);
>  	*pfn = page_to_pfn(page);
>  
> -	return 0;
> +	/* Could optimistically check to see if the next page in the
> +	 * file is mapped to the next page of physical RAM */
> +	return PAGE_SIZE;
  This should be min_t(long, PAGE_SIZE, size), shouldn't it?

>  }
>  #endif
>  
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index ebf41e2..da914b2 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -28,8 +28,8 @@
>  static int dcssblk_open(struct block_device *bdev, fmode_t mode);
>  static void dcssblk_release(struct gendisk *disk, fmode_t mode);
>  static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
> -static int dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
> -				 void **kaddr, unsigned long *pfn);
> +static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
> +				 void **kaddr, unsigned long *pfn, long size);
>  
>  static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
>  
> @@ -866,25 +866,26 @@ fail:
>  	bio_io_error(bio);
>  }
>  
> -static int
> +static long
>  dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
> -			void **kaddr, unsigned long *pfn)
> +			void **kaddr, unsigned long *pfn, long size)
>  {
>  	struct dcssblk_dev_info *dev_info;
> -	unsigned long pgoff;
> +	unsigned long offset, dev_sz;
>  
>  	dev_info = bdev->bd_disk->private_data;
>  	if (!dev_info)
>  		return -ENODEV;
> +	dev_sz = dev_info->end - dev_info->start;
>  	if (secnum % (PAGE_SIZE/512))
>  		return -EINVAL;
> -	pgoff = secnum / (PAGE_SIZE / 512);
> -	if ((pgoff+1)*PAGE_SIZE-1 > dev_info->end - dev_info->start)
> +	offset = secnum * 512;
> +	if (offset > dev_sz)
>  		return -ERANGE;
> -	*kaddr = (void *) (dev_info->start+pgoff*PAGE_SIZE);
> +	*kaddr = (void *) (dev_info->start + offset);
>  	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
>  
> -	return 0;
> +	return min_t(unsigned long, size, dev_sz - offset);
                     ^^^ Why unsigned? Everything seems to be long...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
