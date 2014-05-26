Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaEZLf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:35:26 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:55102 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaEZLfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:35:22 -0400
Date: Mon, 26 May 2014 14:33:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: n-horiguchi@ah.jp.nec.co, linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com,
        mpm@selenic.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com,
        kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        hannes@cmpxchg.org, cpw@sgi.com, benh@kernel.crashing.org,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com
Subject: Re: + pagewalk-update-page-table-walker-core.patch added to -mm tree
Message-ID: <20140526113351.GA7762@node.dhcp.inet.fi>
References: <52f955c0.7BhMyAjSaddn+QeR%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52f955c0.7BhMyAjSaddn+QeR%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:42:08PM -0800, akpm@linux-foundation.org wrote:
> diff -puN include/linux/mm.h~pagewalk-update-page-table-walker-core include/linux/mm.h
> --- a/include/linux/mm.h~pagewalk-update-page-table-walker-core
> +++ a/include/linux/mm.h
> @@ -1075,10 +1075,18 @@ void unmap_vmas(struct mmu_gather *tlb,
>   * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
>   * @pte_hole: if set, called for each hole at all levels
>   * @hugetlb_entry: if set, called for each hugetlb entry
> - *		   *Caution*: The caller must hold mmap_sem() if @hugetlb_entry
> - * 			      is used.
> + * @test_walk: caller specific callback function to determine whether
> + *             we walk over the current vma or not. A positive returned
> + *             value means "do page table walk over the current vma,"
> + *             and a negative one means "abort current page table walk
> + *             right now." 0 means "skip the current vma."

This comment conflicts with comment for walk_page_test() and code itself:

> +/*
> + * Decide whether we really walk over the current vma on [@start, @end)
> + * or skip it. When we skip it, we set @walk->skip to 1.
> + * The return value is used to control the page table walking to
> + * continue (for zero) or not (for non-zero).
> + *
> + * Default check (only VM_PFNMAP check for now) is used when the caller
> + * doesn't define test_walk() callback.
> + */
> +static int walk_page_test(unsigned long start, unsigned long end,
> +			struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +
> +	if (walk->test_walk)
> +		return walk->test_walk(start, end, walk);

...

> +		} else { /* inside the found vma */
> +			walk->vma = vma;
> +			next = vma->vm_end;
> +			err = walk_page_test(start, end, walk);
> +			if (skip_lower_level_walking(walk))
>  				continue;
> -			}
> -		}
> -
> -		if (pgd_none_or_clear_bad(pgd)) {
> -			if (walk->pte_hole)
> -				err = walk->pte_hole(addr, next, walk);
>  			if (err)
>  				break;
> -			pgd++;
> -			continue;

-- 
 Kirill A. Shutemov
