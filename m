Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaCOAGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 20:06:09 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:1027 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaCOAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 20:06:07 -0400
Message-ID: <1394841524.6784.213.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH] Support map_pages() for DAX
From: Toshi Kani <toshi.kani@hp.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: willy@linux.intel.com, kirill.shutemov@linux.intel.com,
        david@fromorbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 14 Mar 2014 17:58:44 -0600
In-Reply-To: <20140314233233.GA8310@node.dhcp.inet.fi>
References: <1394838199-29102-1-git-send-email-toshi.kani@hp.com>
	 <20140314233233.GA8310@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-15 at 01:32 +0200, Kirill A. Shutemov wrote:
> On Fri, Mar 14, 2014 at 05:03:19PM -0600, Toshi Kani wrote:
> > +void dax_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf,
> > +		get_block_t get_block)
> > +{
> > +	struct file *file = vma->vm_file;
> > +	struct inode *inode = file_inode(file);
> > +	struct buffer_head bh;
> > +	struct address_space *mapping = file->f_mapping;
> > +	unsigned long vaddr = (unsigned long)vmf->virtual_address;
> > +	pgoff_t pgoff = vmf->pgoff;
> > +	sector_t block;
> > +	pgoff_t size;
> > +	unsigned long pfn;
> > +	pte_t *pte = vmf->pte;
> > +	int error;
> > +
> > +	while (pgoff < vmf->max_pgoff) {
> > +		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +		if (pgoff >= size)
> > +			return;
> > +
> > +		memset(&bh, 0, sizeof(bh));
> > +		block = (sector_t)pgoff << (PAGE_SHIFT - inode->i_blkbits);
> > +		bh.b_size = PAGE_SIZE;
> > +		error = get_block(inode, block, &bh, 0);
> > +		if (error || bh.b_size < PAGE_SIZE)
> > +			goto next;
> > +
> > +		if (!buffer_mapped(&bh) || buffer_unwritten(&bh) ||
> > +		    buffer_new(&bh))
> > +			goto next;
> > +
> > +		/* Recheck i_size under i_mmap_mutex */
> > +		mutex_lock(&mapping->i_mmap_mutex);
> 
> NAK. Have you tested this with lockdep enabled?
>
> ->map_pages() called with page table lock taken and ->i_mmap_mutex
> should be taken before it. It seems we need to take ->i_mmap_mutex in
> do_read_fault() before calling ->map_pages().

Thanks for pointing this out! I will make sure to test with lockdep next
time.

> Side note: I'm sceptical about whole idea to use i_mmap_mutux to protect
> against truncate. It will not scale good enough comparing lock_page()
> with its granularity.

I see.  I will think about it as well.  

Thanks,
-Toshi



