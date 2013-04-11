Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765117Ab3DKW5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:57:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3DKW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:57:36 -0400
Date: Thu, 11 Apr 2013 15:57:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: Check for RLIMIT_AS before unmapping
Message-Id: <20130411155734.911dc8bf8e555b169191be5a@linux-foundation.org>
In-Reply-To: <20130402095402.GA6568@rei>
References: <20130402095402.GA6568@rei>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013 11:54:03 +0200 Cyril Hrubis <chrubis@suse.cz> wrote:

> This patch fixes corner case for MAP_FIXED when requested mapping length
> is larger than rlimit for virtual memory. In such case any overlapping
> mappings are unmapped before we check for the limit and return ENOMEM.
> 
> The check is moved before the loop that unmaps overlapping parts of
> existing mappings. When we are about to hit the limit (currently mapped
> pages + len > limit) we scan for overlapping pages and check again
> accounting for them.
> 
> This fixes situation when userspace program expects that the previous
> mappings are preserved after the mmap() syscall has returned with error.
> (POSIX clearly states that successfull mapping shall replace any
> previous mappings.)
> 
> This corner case was found and can be tested with LTP testcase:
> 
> testcases/open_posix_testsuite/conformance/interfaces/mmap/24-2.c
> 
> In this case the mmap, which is clearly over current limit, unmaps
> dynamic libraries and the testcase segfaults right after returning into
> userspace.
> 
> I've also looked at the second instance of the unmapping loop in the
> do_brk(). The do_brk() is called from brk() syscall and from vm_brk().
> The brk() syscall checks for overlapping mappings and bails out when
> there are any (so it can't be triggered from the brk syscall). The
> vm_brk() is called only from binmft handlers so it shouldn't be
> triggered unless binmft handler created overlapping mappings.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -33,6 +33,7 @@
>  #include <linux/uprobes.h>
>  #include <linux/rbtree_augmented.h>
>  #include <linux/sched/sysctl.h>
> +#include <linux/kernel.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> @@ -543,6 +544,34 @@ static int find_vma_links(struct mm_struct *mm, unsigned long addr,
>  	return 0;
>  }
>  
> +static unsigned long count_vma_pages_range(struct mm_struct *mm,
> +		unsigned long addr, unsigned long end)
> +{
> +	unsigned long nr_pages = 0;
> +	struct vm_area_struct *vma;
> +
> +	/* Find first overlaping mapping */
> +	vma = find_vma_intersection(mm, addr, end);
> +	if (!vma)
> +		return 0;
> +
> +	nr_pages = (min(end, vma->vm_end) -
> +		max(addr, vma->vm_start)) >> PAGE_SHIFT;

urgh, these things always make my head spin.  Is it guaranteed that
end, vm_end, addr and vm_start are all multiples of PAGE_SIZE?  If not,
we have a problem don't we?


