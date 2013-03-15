Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3CON3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:29:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:59240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab3CON3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:29:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="302739426"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBBPdKfc7i5bkMAzOTtyfUX2FrbYgRAc2c45D04AhZv+eg@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-26-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBBPdKfc7i5bkMAzOTtyfUX2FrbYgRAc2c45D04AhZv+eg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 25/30] thp, mm: basic huge_fault implementation for
 generic_file_vm_ops
Content-Transfer-Encoding: 7bit
Message-Id: <20130315133042.E6B31E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:30:42 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +static int filemap_huge_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > +{
> > +       struct file *file = vma->vm_file;
> > +       struct address_space *mapping = file->f_mapping;
> > +       struct inode *inode = mapping->host;
> > +       pgoff_t size, offset = vmf->pgoff;
> > +       unsigned long address = (unsigned long) vmf->virtual_address;
> > +       struct page *page;
> > +       int ret = 0;
> > +
> > +       BUG_ON(((address >> PAGE_SHIFT) & HPAGE_CACHE_INDEX_MASK) !=
> > +                       (offset & HPAGE_CACHE_INDEX_MASK));
> > +
> > +retry:
> > +       page = find_get_page(mapping, offset);
> > +       if (!page) {
> > +               gfp_t gfp_mask = mapping_gfp_mask(mapping) | __GFP_COLD;
> > +               page = alloc_pages(gfp_mask, HPAGE_PMD_ORDER);
> s/pages/pages_vma/ ?

Fixed. Thanks.

> > +               if (!page) {
> > +                       count_vm_event(THP_FAULT_FALLBACK);
> > +                       return VM_FAULT_OOM;
> > +               }

-- 
 Kirill A. Shutemov
