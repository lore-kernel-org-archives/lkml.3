Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaAGKuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:50:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaAGKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:50:44 -0500
Date: Tue, 7 Jan 2014 10:50:36 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.2 056/185] mm: ensure get_unmapped_area() returns
 higher address than mmap_min_addr
Message-ID: <20140107105036.GB4383@hercules>
References: <20140106191910.7155.38390934@jp.panasonic.com>
 <20140106123207.GB2776@hercules>
 <20140107112530.BF48.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107112530.BF48.38390934@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:25:30AM +0900, Akira Takeuchi wrote:
> On Mon, 6 Jan 2014 12:32:07 +0000
> Luis Henriques <luis.henriques@canonical.com> wrote:
> 
> > On Mon, Jan 06, 2014 at 07:19:10PM +0900, Akira Takeuchi wrote:
> > > On Fri, 03 Jan 2014 04:26:43 +0000
> > > Ben Hutchings <ben@decadent.org.uk> wrote:
> > > 
> > > > On Sun, 2013-12-29 at 03:08 +0100, Ben Hutchings wrote:
> > > > > 3.2.54-rc1 review patch.  If anyone has any objections, please let me know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> > > > > 
> > > > > commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.
> > > > [...]
> > > > > [bwh: Backported to 3.2:
> > > > >  As we do not have vm_unmapped_area(), make arch_get_unmapped_area_topdown()
> > > > >  calculate the lower limit for the new area's end address and then compare
> > > > >  addresses with this instead of with len.  In the process, fix an off-by-one
> > > > >  error which could result in returning 0 if mm->mmap_base == len.]
> > > > 
> > > > I'm dropping this as I have no good way to test the backport (it's not
> > > > used on x86) and I didn't get any confirmation that it's right.
> > > 
> > > I'm sorry for delayed reply.
> > > 
> > > Your backport seems right.
> > > Additionally, I've confirmed the problem is resolved by your backport patch.
> > 
> > Sorry I'm also late for this review.
> > 
> > I guess this means the backport I made for the 3.5 kernel (and released on
> > 3.5.7.26) is incorrect:
> > 
> > http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=commitdiff;h=745545489d25d1b9ecf2d78a8f9a31a362806d2d
> > 
> > Akira, could you please confirm if this is the case so that I revert it in
> > next release?
> 
> The backport for the 3.5 kernel is insufficient to solve the problem,
> as you are concered about.
> 
> I've created the patch for 3.5 kernel based on Ben's patch.
> Please review and use it if there is no problem.
> 
> Regads,
> Akira Takeuchi
> 

Thank you Akira.  If there are no objections, I'll just revert the
previous backport from 3.5 and apply this one instead.

Cheers,
--
Luis

> 
> From 70b8066b5a8bdbfd9000eb886f864923450dce9c Mon Sep 17 00:00:00 2001
> From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> Date: Tue, 7 Jan 2014 11:02:16 +0900
> Subject: [PATCH] mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
> 
> commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.
> 
> This patch fixes the problem that get_unmapped_area() can return illegal
> address and result in failing mmap(2) etc.
> 
> In case that the address higher than PAGE_SIZE is set to
> /proc/sys/vm/mmap_min_addr, the address lower than mmap_min_addr can be
> returned by get_unmapped_area(), even if you do not pass any virtual
> address hint (i.e.  the second argument).
> 
> This is because the current get_unmapped_area() code does not take into
> account mmap_min_addr.
> 
> This leads to two actual problems as follows:
> 
> 1. mmap(2) can fail with EPERM on the process without CAP_SYS_RAWIO,
>    although any illegal parameter is not passed.
> 
> 2. The bottom-up search path after the top-down search might not work in
>    arch_get_unmapped_area_topdown().
> 
> Note: The first and third chunk of my patch, which changes "len" check,
> are for more precise check using mmap_min_addr, and not for solving the
> above problem.
> 
> [How to reproduce]
> 
> 	--- test.c -------------------------------------------------
> 	#include <stdio.h>
> 	#include <unistd.h>
> 	#include <sys/mman.h>
> 	#include <sys/errno.h>
> 
> 	int main(int argc, char *argv[])
> 	{
> 		void *ret = NULL, *last_map;
> 		size_t pagesize = sysconf(_SC_PAGESIZE);
> 
> 		do {
> 			last_map = ret;
> 			ret = mmap(0, pagesize, PROT_NONE,
> 				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
> 	//		printf("ret=%p\n", ret);
> 		} while (ret != MAP_FAILED);
> 
> 		if (errno != ENOMEM) {
> 			printf("ERR: unexpected errno: %d (last map=%p)\n",
> 			errno, last_map);
> 		}
> 
> 		return 0;
> 	}
> 	---------------------------------------------------------------
> 
> 	$ gcc -m32 -o test test.c
> 	$ sudo sysctl -w vm.mmap_min_addr=65536
> 	vm.mmap_min_addr = 65536
> 	$ ./test  (run as non-priviledge user)
> 	ERR: unexpected errno: 1 (last map=0x10000)
> 
> Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> [bwh: Backported to 3.2:
>  As we do not have vm_unmapped_area(), make arch_get_unmapped_area_topdown()
>  calculate the lower limit for the new area's end address and then compare
>  addresses with this instead of with len.  In the process, fix an off-by-one
>  error which could result in returning 0 if mm->mmap_base == len.]
> Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> [akira: Backported to 3.5:
>  Based on Ben's backport for 3.2-stable kernel. ]
> ---
>  mm/mmap.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7e24763..529f72c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1443,7 +1443,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>  	struct vm_area_struct *vma;
>  	unsigned long start_addr;
>  
> -	if (len > TASK_SIZE)
> +	if (len > TASK_SIZE - mmap_min_addr)
>  		return -ENOMEM;
>  
>  	if (flags & MAP_FIXED)
> @@ -1452,7 +1452,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>  	if (addr) {
>  		addr = PAGE_ALIGN(addr);
>  		vma = find_vma(mm, addr);
> -		if (TASK_SIZE - len >= addr &&
> +		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
>  		    (!vma || addr + len <= vma->vm_start))
>  			return addr;
>  	}
> @@ -1515,9 +1515,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm = current->mm;
>  	unsigned long addr = addr0, start_addr;
> +	unsigned long low_limit = max(PAGE_SIZE, mmap_min_addr);
>  
>  	/* requested length too big for entire address space */
> -	if (len > TASK_SIZE)
> +	if (len > TASK_SIZE - mmap_min_addr)
>  		return -ENOMEM;
>  
>  	if (flags & MAP_FIXED)
> @@ -1527,7 +1528,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
>  	if (addr) {
>  		addr = PAGE_ALIGN(addr);
>  		vma = find_vma(mm, addr);
> -		if (TASK_SIZE - len >= addr &&
> +		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
>  				(!vma || addr + len <= vma->vm_start))
>  			return addr;
>  	}
> @@ -1542,7 +1543,7 @@ try_again:
>  	/* either no address requested or can't fit in requested address hole */
>  	start_addr = addr = mm->free_area_cache;
>  
> -	if (addr < len)
> +	if (addr < low_limit + len)
>  		goto fail;
>  
>  	addr -= len;
> @@ -1563,7 +1564,7 @@ try_again:
>  
>  		/* try just below the current vma->vm_start */
>  		addr = vma->vm_start-len;
> -	} while (len < vma->vm_start);
> +	} while (vma->vm_start >= low_limit + len);
>  
>  fail:
>  	/*
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
