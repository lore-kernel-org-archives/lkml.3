Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaIJQtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:49:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50280 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaIJQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:49:45 -0400
Message-ID: <54108124.9030707@gmail.com>
Date: Wed, 10 Sep 2014 19:49:40 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>, willy@linux.intel.com
Subject: Re: [PATCH v10 20/21] ext4: Add DAX functionality
References: <cover.1409110741.git.matthew.r.wilcox@intel.com> <5422062f87eb5606f4632fd06575254379f40ddc.1409110741.git.matthew.r.wilcox@intel.com> <20140903111302.GG20473@dastard>
In-Reply-To: <20140903111302.GG20473@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:13 PM, Dave Chinner wrote:
<>
> 
> When direct IO fails ext4 falls back to buffered IO, right? And
> dax_do_io() can return partial writes, yes?
> 

There is no buffered writes with DAX. .I.E buffered writes are always
direct as well. (No page cache)

> So that means if you get, say, ENOSPC part way through a DAX write,
> ext4 can start dirtying the page cache from
> __generic_file_write_iter() because the DAX write didn't wholly
> complete? And say this ENOSPC races with space being freed from
> another inode, then the buffered write will succeed and we'll end up
> with coherency issues, right?
> 
> This is not an idle question - XFS if firing asserts all over the
> place when doing ENOSPC testing because DAX is returning partial
> writes and the XFS direct IO code is expecting them to either wholly
> complete or wholly fail. I can make the DAX variant do allow partial
> writes, but I'm not going to add a useless fallback to buffered IO
> for XFS when the (fully featured) direct allocation fails.
> 

Right, no fall back. Because a fallback is just a retry, because in any
way DAX assumes there is never a page_cache_page for a written data

> Indeed, I note that in the dax_fault code, any page found in the
> page cache is explicitly removed and released, and the direct mapped
> block replaces that page in the vma. IOWs, this code expects pages
> to be clean as we're only supposed to have regions covered by holes
> using cached pages (dax_load_hole()). 

Exactly, page_cache_page are only/always "regions covered by holes"

Once there is a real block allocated for an offset it will be directly
mapped to the vm without a page_cache_page.

> So if we've done a buffered
> write, we're going to toss out dirty pages the moment there is a
> page fault on the range and map the unmodified backing store in
> instead.
> 

No! There is never "buffered write" with DAX. That is: there is never
a page_cache_page that holds data which will belong to the storage
later. DAX means zero-page-cache

> That just seems wrong. Maybe I've forgotten something, but this
> looks like a wart that we don't need and shouldn't bake into this
> interface as both ext4 and XFS can allocate into holes and extend
> files from from the direct IO interfaces. Of course, correct me if
> I'm wrong about ext4 capabilities...
> 

Yes you have misread the patchset, all writes are always done directly
to bdev->direct_access(..) memory *never* via a copy to page_cache.

Currently The only existence of radix-tree pages is for ZERO pages that
cover holes, which get thrown out as clean or COWed on mkwrite

BTW Matthew: It took me a while to figure out the VFS/VMA api but
I managed to map a single ZERO page to all holes and COW them to
real blocks on mkwrite. It needed a combination of flags but the
main trick is that at mkwrite I do:

	/* our zero page doesn't really hold the correct offset to the file in
	 * page->index so vmf->pgoff is incorrect, lets fix that */
	vmf->pgoff = vma->vm_pgoff + (((unsigned long)vmf->virtual_address -
			vma->vm_start) >> PAGE_SHIFT);
	/* call fault handler to get a real page for writing */
	ret = _xip_file_fault(vma, vmf);
	/* invalidate all other mappings to that location */
	unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT, PAGE_SIZE, 1);

	/* mkwrite must lock the original page and return VM_FAULT_LOCKED */
	if (ret == VM_FAULT_NOPAGE) {
		lock_page(m1fs_zero_page);
		ret = VM_FAULT_LOCKED;
	}
	return ret;

At _xip_file_fault() also called from .fault I do in the case of a hole:
	if (!(vmf->flags & FAULT_FLAG_WRITE)) {
		...
		block = _find_data_block(inode, vmf->pgoff);
		if (!block) {
			vmf->page = g_zero_page;
			err = vm_insert_page(vma,
					(unsigned long)vmf->virtual_address,
					vmf->page);
			goto after_insert;
		}
	} else {

Above g_zero_page is my own global zero page, PAGE_ZERO will not work.
_find_data_block() is like your get_buffer but only for the read case,
the write case uses a different _get_block_create().

Please tell me if it is interesting for you? I can try to patch your DAX
patchset to do the same. This can always be done later as an optimization.

> Cheers,
> Dave.
> 

Thanks
Boaz

