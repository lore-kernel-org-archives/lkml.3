Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbaDBTHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:07:38 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:33741 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbaDBTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:07:36 -0400
Date: Wed, 2 Apr 2014 22:07:09 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/2] mm: implement ->map_pages for page cache
Message-ID: <20140402190709.GA31799@node.dhcp.inet.fi>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1393530827-25450-3-git-send-email-kirill.shutemov@linux.intel.com>
 <CALYGNiNHBo9-XsZEvn+Oy5rKh7QyJtVm=vbmido7hmvuR++Vqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiNHBo9-XsZEvn+Oy5rKh7QyJtVm=vbmido7hmvuR++Vqg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:03:24PM +0400, Konstantin Khlebnikov wrote:
> > +void filemap_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf)
> > +{
> > +       struct radix_tree_iter iter;
> > +       void **slot;
> > +       struct file *file = vma->vm_file;
> > +       struct address_space *mapping = file->f_mapping;
> > +       loff_t size;
> > +       struct page *page;
> > +       unsigned long address = (unsigned long) vmf->virtual_address;
> > +       unsigned long addr;
> > +       pte_t *pte;
> > +
> > +       rcu_read_lock();
> > +       radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, vmf->pgoff) {
> > +               if (iter.index > vmf->max_pgoff)
> > +                       break;
> > +repeat:
> > +               page = radix_tree_deref_slot(slot);
> 
> Here is obvious race with memory reclaimer/truncate. Pointer to page
> might become NULL.

Thanks for noticing that. It has been fixed in -mm already.

-- 
 Kirill A. Shutemov
