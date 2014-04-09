Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbaDIK2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:28:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbaDIK2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:28:03 -0400
Date: Wed, 9 Apr 2014 12:27:58 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140409102758.GM32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  One more comment:

On Sun 23-03-14 15:08:33, Matthew Wilcox wrote:
> +static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			get_block_t get_block)
> +{
> +	struct file *file = vma->vm_file;
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = file->f_mapping;
> +	struct page *page;
> +	struct buffer_head bh;
> +	unsigned long vaddr = (unsigned long)vmf->virtual_address;
> +	sector_t block;
> +	pgoff_t size;
> +	unsigned long pfn;
> +	int error;
> +	int major = 0;
> +
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (vmf->pgoff >= size)
> +		return VM_FAULT_SIGBUS;
> +
> +	memset(&bh, 0, sizeof(bh));
> +	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - inode->i_blkbits);
> +	bh.b_size = PAGE_SIZE;
> +
> + repeat:
> +	page = find_get_page(mapping, vmf->pgoff);
> +	if (page) {
> +		if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
> +			page_cache_release(page);
> +			return VM_FAULT_RETRY;
> +		}
> +		if (unlikely(page->mapping != mapping)) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			goto repeat;
> +		}
> +	}
> +
> +	error = get_block(inode, block, &bh, 0);
> +	if (error || bh.b_size < PAGE_SIZE)
> +		goto sigbus;
> +
> +	if (!buffer_written(&bh) && !vmf->cow_page) {
> +		if (vmf->flags & FAULT_FLAG_WRITE) {
> +			error = get_block(inode, block, &bh, 1);
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			major = VM_FAULT_MAJOR;
> +			if (error || bh.b_size < PAGE_SIZE)
> +				goto sigbus;
> +		} else {
> +			return dax_load_hole(mapping, page, vmf);
> +		}
> +	}
> +
> +	/* Recheck i_size under i_mmap_mutex */
> +	mutex_lock(&mapping->i_mmap_mutex);
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (unlikely(vmf->pgoff >= size)) {
> +		mutex_unlock(&mapping->i_mmap_mutex);
> +		goto sigbus;
  You need to release the block you've got from the filesystem in case of
error here an below.

								Honza

> +	}
> +	if (vmf->cow_page) {
> +		if (buffer_written(&bh))
> +			copy_user_bh(vmf->cow_page, inode, &bh, vaddr);
> +		else
> +			clear_user_highpage(vmf->cow_page, vaddr);
> +		if (page) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +		}
> +		/* do_cow_fault() will release the i_mmap_mutex */
> +		return VM_FAULT_COWED;
> +	}
> +
> +	if (buffer_unwritten(&bh) || buffer_new(&bh))
> +		dax_clear_blocks(inode, bh.b_blocknr, bh.b_size);
> +
> +	error = dax_get_pfn(inode, &bh, &pfn);
> +	if (error > 0)
> +		error = vm_insert_mixed(vma, vaddr, pfn);
> +	mutex_unlock(&mapping->i_mmap_mutex);
> +
> +	if (page) {
> +		delete_from_page_cache(page);
> +		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
> +							PAGE_CACHE_SIZE, 0);
> +		unlock_page(page);
> +		page_cache_release(page);
> +	}
> +
> +	if (error == -ENOMEM)
> +		return VM_FAULT_OOM;
> +	/* -EBUSY is fine, somebody else faulted on the same PTE */
> +	if (error != -EBUSY)
> +		BUG_ON(error);
> +	return VM_FAULT_NOPAGE | major;
> +
> + sigbus:
> +	if (page) {
> +		unlock_page(page);
> +		page_cache_release(page);
> +	}
> +	return VM_FAULT_SIGBUS;
> +}
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
