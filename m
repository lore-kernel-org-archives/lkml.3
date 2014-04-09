Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbaDIVML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:12:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965023AbaDIVMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:12:06 -0400
Date: Wed, 9 Apr 2014 23:12:03 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140409211203.GP32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140408220525.GC26019@quack.suse.cz>
 <20140409204806.GF5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409204806.GF5727@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-04-14 16:48:06, Matthew Wilcox wrote:
> On Wed, Apr 09, 2014 at 12:05:25AM +0200, Jan Kara wrote:
> > > +
> > > +	error = dax_get_pfn(inode, &bh, &pfn);
> > > +	if (error > 0)
> > > +		error = vm_insert_mixed(vma, vaddr, pfn);
> >   When there's a hole (thus page != NULL) and we are called from
> > dax_mkwrite(), this will always return EBUSY, correct?
> 
> Erm ... it will return -EBUSY if this was the task that previously
> faulted on it.  Drat.  See below.
> 
> > > +	mutex_unlock(&mapping->i_mmap_mutex);
> > > +
> > > +	if (page) {
> > > +		delete_from_page_cache(page);
> > > +		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
> > > +							PAGE_CACHE_SIZE, 0);
> >   Here we unmap the PTE pointing to the hole page but then we'll have to
> > retry the fault again to fill in the pfn we've got? This seems wrong. I'd
> > say we want to remap the PTE from the hole page to a pfn we've got while
> > holding i_mmap_mutex. remap_pfn_range() almost does what you need, except
> > that you also need that to work for normal pages. So you might need to
> > create a new helper in mm layer for that.
> 
> I think it's easier than that.  How does this look?
> 
> @@ -390,9 +389,8 @@ static int do_dax_fault(struct vm_area_struct *vma, struct v
>                 dax_clear_blocks(inode, bh.b_blocknr, bh.b_size);
>  
>         error = dax_get_pfn(&bh, &pfn, blkbits);
> -       if (error > 0)
> -               error = vm_insert_mixed(vma, vaddr, pfn);
> -       mutex_unlock(&mapping->i_mmap_mutex);
> +       if (error <= 0)
> +               goto unlock;
>  
>         if (page) {
>                 delete_from_page_cache(page);
> @@ -402,6 +400,9 @@ static int do_dax_fault(struct vm_area_struct *vma, struct v
>                 page_cache_release(page);
>         }
>  
> +       error = vm_insert_mixed(vma, vaddr, pfn);
> +       mutex_unlock(&mapping->i_mmap_mutex);
> +
  This would be fine except that unmap_mapping_range() grabs i_mmap_mutex
again :-|. But it might be easier to provide a version of that function
which assumes i_mmap_mutex is already locked than what I was suggesting.

>         if (error == -ENOMEM)
>                 return VM_FAULT_OOM;
>         /* -EBUSY is fine, somebody else faulted on the same PTE */
> @@ -409,6 +410,8 @@ static int do_dax_fault(struct vm_area_struct *vma, struct v
>                 BUG_ON(error);
>         return VM_FAULT_NOPAGE | major;
>  
> + unlock:
> +       mutex_unlock(&mapping->i_mmap_mutex);
>   sigbus:
>         if (page) {
>                 unlock_page(page);
> 
> 
> > > +int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> > > +			get_block_t get_block)
> > > +{
> > > +	int result;
> > > +	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> > > +
> > > +	sb_start_pagefault(sb);
> >   You don't need any filesystem freeze protection for the fault handler
> > since that's not going to modify the filesystem.
> 
> Err ... we might allocate a block as a result of doing a write to a hole.
> Or does that not count as 'modifying the filesystem' in this context?
  Ah, it does. But it would be nice to avoid doing sb_start_pagefault() if
it's not a write fault - because you don't want to block reading from a
frozen filesystem (imagine what would happen when you freeze your root
filesystem to do a snapshot...).

I have somewhat a mindset of standard pagecache mmap where filemap_fault()
only reads in data regardless of FAULT_FLAG_WRITE setting so I was confused
by your difference :).

> > > +	file_update_time(vma->vm_file);
> >   Why do you update m/ctime? We are only reading the file...
> 
> ... except that it might be a write fault.  I think we modify the file
> iff we return VM_FAULT_MAJOR from do_dax_fault().  So I'd be open to
> something like this:
> 
> 	sb_start_pagefault(sb);
> 	result = do_dax_fault(vma, vmf, get_block);
> 	if (result & VM_FAULT_MAJOR)
> 		file_update_time(vma->vm_file);
> 	sb_end_pagefault(sb);
> 
> Would that work better for you?
  Definitely. It's also a performance thing BTW - updating time stamps is
relatively expensive for journalling filesystems - you have to start a
transaction, add block with inode to the journal, stop a transaction - not
something you want to do unless you have to.

> > > @@ -70,7 +101,7 @@ const struct file_operations ext2_file_operations = {
> > >  #ifdef CONFIG_COMPAT
> > >  	.compat_ioctl	= ext2_compat_ioctl,
> > >  #endif
> > > -	.mmap		= generic_file_mmap,
> > > +	.mmap		= ext2_file_mmap,
> >   So what's the point of ext2_file_operations ever handling IS_DAX()
> > inodes? Actually ext2_file_operations and ext2_xip_file_operations seem to
> > be the same after this patch so either you drop ext2_xip_file_operations
> > (I'm for this) or you can leave generic_file_mmap here and assume
> > ext2_file_mmap is always called for IS_DAX() inodes.
> 
> The goal is to get them the same.  At this point, the only sticky point is:
> 
>         .splice_read    = generic_file_splice_read,
>         .splice_write   = generic_file_splice_write,
> 
> And splice is pretty damn sticky for DAX.
  Yes, I have figured that out later.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
