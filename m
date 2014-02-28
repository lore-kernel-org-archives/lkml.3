Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaB1R4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:56:45 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:53466 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaB1R4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:56:42 -0500
Message-ID: <1393609771.6784.83.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 07/22] Replace the XIP page fault handler with the
 DAX page fault handler
From: Toshi Kani <toshi.kani@hp.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Date: Fri, 28 Feb 2014 10:49:31 -0700
In-Reply-To: <1393337918-28265-8-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
	 <1393337918-28265-8-git-send-email-matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 09:18 -0500, Matthew Wilcox wrote:
> Instead of calling aops->get_xip_mem from the fault handler, the
> filesystem passes a get_block_t that is used to find the appropriate
> blocks.
 :
> +static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			get_block_t get_block)
> +{
> +	struct file *file = vma->vm_file;
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = file->f_mapping;
> +	struct buffer_head bh;
> +	unsigned long vaddr = (unsigned long)vmf->virtual_address;
> +	sector_t block;
> +	pgoff_t size;
> +	unsigned long pfn;
> +	int error;
> +
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (vmf->pgoff >= size)
> +		return VM_FAULT_SIGBUS;
> +
> +	memset(&bh, 0, sizeof(bh));
> +	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - inode->i_blkbits);
> +	bh.b_size = PAGE_SIZE;
> +	error = get_block(inode, block, &bh, 0);
> +	if (error || bh.b_size < PAGE_SIZE)
> +		return VM_FAULT_SIGBUS;

I am learning the code and have some questions.  The original code,
xip_file_fault(), jumps to found: and calls vm_insert_mixed() when
get_xip_mem(,,0,,) succeeded.  If get_xip_mem() returns -ENODATA, it
calls either get_xip_mem(,,1,,) or xip_sparse_page().  In this new
function, it looks to me that get_block(,,,0) returns 0 for both cases
(success and -ENODATA previously), which are dealt in the same way.  Is
that right?  If so, is there any reason for the change?  Also, isn't it
possible to call get_block(,,,1) even if get_block(,,,0) found a block?

Thanks,
-Toshi

> +
> +	if (!buffer_written(&bh) && !vmf->cow_page) {
> +		if (vmf->flags & FAULT_FLAG_WRITE) {
> +			error = get_block(inode, block, &bh, 1);
> +			if (error || bh.b_size < PAGE_SIZE)
> +				return VM_FAULT_SIGBUS;
> +		} else {
> +			return dax_load_hole(mapping, vmf);
> +		}
> +	}
> +


