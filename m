Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaHATxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbaHATxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:53:46 -0400
Date: Fri, 1 Aug 2014 15:53:38 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: softdirty: respect VM_SOFTDIRTY in PTE holes
Message-ID: <20140801195338.GA29508@nhori.bos.redhat.com>
References: <1406846605-12176-1-git-send-email-pfeiner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406846605-12176-1-git-send-email-pfeiner@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:43:25PM -0400, Peter Feiner wrote:
> After a VMA is created with the VM_SOFTDIRTY flag set,
> /proc/pid/pagemap should report that the VMA's virtual pages are
> soft-dirty until VM_SOFTDIRTY is cleared (i.e., by the next write of
> "4" to /proc/pid/clear_refs). However, pagemap ignores the
> VM_SOFTDIRTY flag for virtual addresses that fall in PTE holes (i.e.,
> virtual addresses that don't have a PMD, PUD, or PGD allocated yet).
> 
> To observe this bug, use mmap to create a VMA large enough such that
> there's a good chance that the VMA will occupy an unused PMD, then
> test the soft-dirty bit on its pages. In practice, I found that a VMA
> that covered a PMD's worth of address space was big enough.
> 
> This patch adds the necessary VMA lookup to the PTE hole callback in
> /proc/pid/pagemap's page walk and sets soft-dirty according to the
> VMAs' VM_SOFTDIRTY flag.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>

It's unfortunate that we have to do this kind of vma boundary calculation
inside pagemap_pte_hole, which comes from poor vma handling in mm/pagewalk.c.
Recently I'm trying to solve this (I posted ver.6 patchset today) and if
that's merged, your problem should be implicitly fixed.

But anyway if Andrew decided to merge your patch in first, it's OK for me.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi

> ---
>  fs/proc/task_mmu.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index cfa63ee..dfc791c 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -925,15 +925,30 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
>  				struct mm_walk *walk)
>  {
>  	struct pagemapread *pm = walk->private;
> -	unsigned long addr;
> +	unsigned long addr = start;
>  	int err = 0;
> -	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
>  
> -	for (addr = start; addr < end; addr += PAGE_SIZE) {
> -		err = add_to_pagemap(addr, &pme, pm);
> -		if (err)
> -			break;
> +	while (addr < end) {
> +		struct vm_area_struct *vma = find_vma(walk->mm, addr);
> +		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
> +		unsigned long vm_end;
> +
> +		if (!vma) {
> +			vm_end = end;
> +		} else {
> +			vm_end = min(end, vma->vm_end);
> +			if (vma->vm_flags & VM_SOFTDIRTY)
> +				pme.pme |= PM_STATUS2(pm->v2, __PM_SOFT_DIRTY);
> +		}
> +
> +		for (; addr < vm_end; addr += PAGE_SIZE) {
> +			err = add_to_pagemap(addr, &pme, pm);
> +			if (err)
> +				goto out;
> +		}
>  	}
> +
> +out:
>  	return err;
>  }
>  
> -- 
> 2.0.0.526.g5318336
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
