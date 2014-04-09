Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaDIKPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:15:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712AbaDIKPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:15:15 -0400
Date: Wed, 9 Apr 2014 12:15:12 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com,
        Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v7 18/22] xip: Add xip_zero_page_range
Message-ID: <20140409101512.GL32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5a87acda8c3e4d2b7ea5dd1249fcbf8be23b9645.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a87acda8c3e4d2b7ea5dd1249fcbf8be23b9645.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:44, Matthew Wilcox wrote:
> This new function allows us to support hole-punch for XIP files by zeroing
> a partial page, as opposed to the xip_truncate_page() function which can
> only truncate to the end of the page.  Reimplement xip_truncate_page() as
> a macro that calls xip_zero_page_range().
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> [ported to 3.13-rc2]
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
  Two comments below...

...
> diff --git a/fs/dax.c b/fs/dax.c
> index 45a0a41..2d6b4bc 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
...
> @@ -491,11 +494,16 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
>  	if (buffer_written(&bh)) {
>  		void *addr;
>  		err = dax_get_addr(inode, &bh, &addr);
> -		if (err)
> +		if (err < 0)
>  			return err;
> +		/*
> +		 * ext4 sometimes asks to zero past the end of a block.  It
> +		 * really just wants to zero to the end of the block.
> +		 */
  Then we should really fix ext4 I believe...

> +		length = min_t(unsigned, length, PAGE_CACHE_SIZE - offset);
>  		memset(addr + offset, 0, length);
>  	}
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(dax_truncate_page);
> +EXPORT_SYMBOL_GPL(dax_zero_page_range);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bff394d..d0381ab 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2521,6 +2521,7 @@ extern int nonseekable_open(struct inode * inode, struct file * filp);
>  
>  #ifdef CONFIG_FS_DAX
>  int dax_clear_blocks(struct inode *, sector_t block, long size);
> +int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
>  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
>  ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, const struct iovec *,
>  		loff_t, unsigned segs, get_block_t, dio_iodone_t, int flags);
> @@ -2532,7 +2533,8 @@ static inline int dax_clear_blocks(struct inode *i, sector_t blk, long sz)
>  	return 0;
>  }
>  
> -static inline int dax_truncate_page(struct inode *i, loff_t frm, get_block_t gb)
> +static inline int dax_zero_page_range(struct inode *inode, loff_t from,
> +						unsigned len, get_block_t gb)
>  {
>  	return 0;
>  }
> @@ -2545,6 +2547,11 @@ static inline ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
>  }
>  #endif
>  
> +/* Can't be a function because PAGE_CACHE_SIZE is defined in pagemap.h */
> +#define dax_truncate_page(inode, from, get_block)	\
> +	dax_zero_page_range(inode, from, PAGE_CACHE_SIZE, get_block)
                                         ^^^^
This should be (PAGE_CACHE_SIZE - (from & (PAGE_CACHE_SIZE - 1))), shouldn't it?

> +
> +
>  #ifdef CONFIG_BLOCK
>  typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
