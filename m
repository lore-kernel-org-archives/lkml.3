Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaFCPzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:55:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:6455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbaFCPzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,966,1392192000"; 
   d="scan'208";a="550924238"
Message-ID: <538DEFD8.4050506@intel.com>
Date: Tue, 03 Jun 2014 08:55:04 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH -mm] mincore: apply page table walker on do_mincore()
 (Re: [PATCH 00/10] mm: pagewalk: huge page cleanups and VMA passing)
References: <20140602213644.925A26D0@viggo.jf.intel.com> <1401745925-l651h3s9@n-horiguchi@ah.jp.nec.com> <538CF25E.8070905@sr71.net> <1401776292-dn0fof8e@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401776292-dn0fof8e@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 11:18 PM, Naoya Horiguchi wrote:
> And for patch 8, 9, and 10, I don't think it's good idea to add a new callback
> which can handle both pmd and pte (because they are essentially differnt thing).
> But the underneath idea of doing pmd_trans_huge_lock() in the common code in
> walk_single_entry_locked() looks nice to me. So it would be great if we can do
> the same thing in walk_pmd_range() (of linux-mm) to reduce code in callbacks.

You think they are different, I think they're the same. :)

What the walkers *really* care about is getting a leaf node in the page
tables.  They generally don't *care* whether it is a pmd or pte, they
just want to know what its value is and how large it is.

I'd argue that they don't really ever need to actually know at which
level they are in the page tables, just if they are at the bottom or
not.  Note that *NOBODY* sets a pud or pgd entry.  That's because the
walkers are 100% concerned about leaf nodes (pte's) at this point.

Take a look at my version of gather_stats_locked():

>  static int gather_stats_locked(pte_t *pte, unsigned long addr,
>                 unsigned long size, struct mm_walk *walk)
>  {
>         struct numa_maps *md = walk->private;
>         struct page *page = can_gather_numa_stats(*pte, walk->vma, addr);
>  
>         if (page)
>                 gather_stats(page, md, pte_dirty(*pte), size/PAGE_SIZE);
>  
>         return 0;
>  }

The mmotm version looks _very_ similar to that, *BUT* the mmotm version
needs to have an entire *EXTRA* 22-line gather_pmd_stats() dealing with
THP locking, while mine doesn't.
