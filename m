Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaGWMKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:10:42 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:58221 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaGWMKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:10:38 -0400
Date: Wed, 23 Jul 2014 15:10:25 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v8 10/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140723121025.GE10317@node.dhcp.inet.fi>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <00ad731b459e32ce965af8530bcd611a141e41b6.1406058387.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ad731b459e32ce965af8530bcd611a141e41b6.1406058387.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:47:58PM -0400, Matthew Wilcox wrote:
> Instead of calling aops->get_xip_mem from the fault handler, the
> filesystem passes a get_block_t that is used to find the appropriate
> blocks.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c           | 221 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext2/file.c     |  35 ++++++++-
>  include/linux/fs.h |   4 +-
>  mm/filemap_xip.c   | 206 -------------------------------------------------
>  4 files changed, 257 insertions(+), 209 deletions(-)
> 
...

> +/**
> + * dax_fault - handle a page fault on a DAX file
> + * @vma: The virtual memory area where the fault occurred
> + * @vmf: The description of the fault
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + *
> + * When a page fault occurs, filesystems may call this helper in their
> + * fault handler for DAX files.
> + */
> +int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			get_block_t get_block)
> +{
> +	int result;
> +	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> +
> +	if (vmf->flags & FAULT_FLAG_WRITE) {

Nobody seems calls sb_start_pagefault() in fault handler.
Do you mean FAULT_FLAG_MKWRITE?

> +		sb_start_pagefault(sb);
> +		file_update_time(vma->vm_file);
> +	}
> +	result = do_dax_fault(vma, vmf, get_block);
> +	if (vmf->flags & FAULT_FLAG_WRITE)
> +		sb_end_pagefault(sb);
> +
> +	return result;
> +}
> +EXPORT_SYMBOL_GPL(dax_fault);
> +
> +/**
> + * dax_mkwrite - convert a read-only page to read-write in a DAX file
> + * @vma: The virtual memory area where the fault occurred
> + * @vmf: The description of the fault
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + *
> + * DAX handles reads of holes by adding pages full of zeroes into the
> + * mapping.  If the page is subsequenty written to, we have to allocate
> + * the page on media and free the page that was in the cache.
> + */
> +int dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			get_block_t get_block)
> +{
> +	return dax_fault(vma, vmf, get_block);
> +}
> +EXPORT_SYMBOL_GPL(dax_mkwrite);

I don't think we want to introduce new exported symbol just for dummy
wrapper. Just use ".page_mkwrite = foo_fault,". perf and selinux do
this.
Or add #define into header file if you want better readability.

-- 
 Kirill A. Shutemov
