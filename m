Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967366Ab3DRPYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:24:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56198 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966917Ab3DRPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:24:19 -0400
Date: Thu, 18 Apr 2013 11:24:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [commit review] vm: add vm_iomap_memory() helper function
Message-ID: <20130418152414.GA26090@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Poking my nose into this new helper, 

> commit b4cbb197c7e7a68dbad0d491242e3ca67420c13e
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Apr 16 13:45:37 2013 -0700
> 
>     vm: add vm_iomap_memory() helper function
[...]     
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2393,6 +2393,53 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(remap_pfn_range);
>  
> +/**
> + * vm_iomap_memory - remap memory to userspace
> + * @vma: user vma to map to
> + * @start: start of area
> + * @len: size of area
> + *
> + * This is a simplified io_remap_pfn_range() for common driver use. The
> + * driver just needs to give us the physical memory range to be mapped,
> + * we'll figure out the rest from the vma information.
> + *
> + * NOTE! Some drivers might want to tweak vma->vm_page_prot first to get
> + * whatever write-combining details or similar.
> + */
> +int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
> +{
> +	unsigned long vm_len, pfn, pages;
> +
> +	/* Check that the physical memory area passed in looks valid */
> +	if (start + len < start)

is len == 0 accepted ?

> +		return -EINVAL;
> +	/*
> +	 * You *really* shouldn't map things that aren't page-aligned,
> +	 * but we've historically allowed it because IO memory might
> +	 * just have smaller alignment.
> +	 */
> +	len += start & ~PAGE_MASK;
> +	pfn = start >> PAGE_SHIFT;
> +	pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
> +	if (pfn + pages < pfn)
> +		return -EINVAL;
> +
> +	/* We start the mapping 'vm_pgoff' pages into the area */
> +	if (vma->vm_pgoff > pages)

This seems to accept vma->vm_pgoff == pages, which would leave exactly 0
backing pages. Is this expected ?

> +		return -EINVAL;
> +	pfn += vma->vm_pgoff;
> +	pages -= vma->vm_pgoff;
> +
> +	/* Can we fit all of the mapping? */
> +	vm_len = vma->vm_end - vma->vm_start;
> +	if (vm_len >> PAGE_SHIFT > pages)

Is it possible that we get a situation where vm_end and vm_start are not
aligned on page addresses ? If it's allowed, then this test may succeed
even though the range requires more than "pages" backing pages. This
might be an issue since the first thing remap_pfn_range() does with its
"size" argument is to PAGE_ALIGN() it.

Thoughts ?

Thanks,

Mathieu

> +		return -EINVAL;
> +
> +	/* Ok, let it rip */
> +	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
> +}
> +EXPORT_SYMBOL(vm_iomap_memory);
> +
>  static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				     unsigned long addr, unsigned long end,
>  				     pte_fn_t fn, void *data)


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
