Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaDHWSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:18:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaDHWSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:18:02 -0400
Date: Wed, 9 Apr 2014 00:17:59 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 08/22] Replace xip_truncate_page with dax_truncate_page
Message-ID: <20140408221759.GD26019@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <fd328c564ddc79b41a3a8d754080e6e6e77bbf4f.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd328c564ddc79b41a3a8d754080e6e6e77bbf4f.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:34, Matthew Wilcox wrote:
> It takes a get_block parameter just like nobh_truncate_page() and
> block_truncate_page()
  The patch looks mostly OK. Some minor comments below.

> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/dax.c           | 52 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/ext2/inode.c    |  2 +-
>  include/linux/fs.h |  4 ++--
>  mm/filemap_xip.c   | 40 ----------------------------------------
>  4 files changed, 51 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 863749c..7271be0 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -374,13 +374,13 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  }
>  
>  /**
> - * dax_fault - handle a page fault on an XIP file
> + * dax_fault - handle a page fault on a DAX file
>   * @vma: The virtual memory area where the fault occurred
>   * @vmf: The description of the fault
>   * @get_block: The filesystem method used to translate file offsets to blocks
>   *
>   * When a page fault occurs, filesystems may call this helper in their
> - * fault handler for XIP files.
> + * fault handler for DAX files.
>   */
>  int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			get_block_t get_block)
> @@ -398,12 +398,12 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  EXPORT_SYMBOL_GPL(dax_fault);
>  
>  /**
> - * dax_mkwrite - convert a read-only page to read-write in an XIP file
> + * dax_mkwrite - convert a read-only page to read-write in a DAX file
>   * @vma: The virtual memory area where the fault occurred
>   * @vmf: The description of the fault
>   * @get_block: The filesystem method used to translate file offsets to blocks
>   *
> - * XIP handles reads of holes by adding pages full of zeroes into the
> + * DAX handles reads of holes by adding pages full of zeroes into the
>   * mapping.  If the page is subsequenty written to, we have to allocate
>   * the page on media and free the page that was in the cache.
>   */
  Above two hunks belong to the previous patch...

> @@ -421,3 +421,47 @@ int dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	return result;
>  }
>  EXPORT_SYMBOL_GPL(dax_mkwrite);
> +
> +/**
> + * dax_truncate_page - handle a partial page being truncated in a DAX file
> + * @inode: The file being truncated
> + * @from: The file offset that is being truncated to
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + *
> + * Similar to block_truncate_page(), this function can be called by a
> + * filesystem when it is truncating an DAX file to handle the partial page.
> + *
> + * We work in terms of PAGE_CACHE_SIZE here for commonality with
> + * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
> + * took care of disposing of the unnecessary blocks.  Even if the filesystem
> + * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
> + * since the file might be mmaped.
  Well, DAX mmap support pretty much relies on PAGE_CACHE_SIZE == block
size (we cannot really map only a part of a physical page directly...). So
the comment seems somewhat misleading.

> + */
> +int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
> +{
> +	struct buffer_head bh;
> +	pgoff_t index = from >> PAGE_CACHE_SHIFT;
> +	unsigned offset = from & (PAGE_CACHE_SIZE-1);
> +	unsigned length = PAGE_CACHE_ALIGN(from) - from;
> +	int err;
> +
  Can we WARN_ON_ONCE here if PAGE_CACHE_SHIFT != inode->i_blkbits? Just to
catch bugs early.

> +	/* Block boundary? Nothing to do */
> +	if (!length)
> +		return 0;
> +
> +	memset(&bh, 0, sizeof(bh));
> +	bh.b_size = PAGE_CACHE_SIZE;
> +	err = get_block(inode, index, &bh, 0);
> +	if (err < 0)
> +		return err;
> +	if (buffer_written(&bh)) {
> +		void *addr;
> +		err = dax_get_addr(inode, &bh, &addr);
> +		if (err)
> +			return err;
> +		memset(addr + offset, 0, length);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_truncate_page);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
