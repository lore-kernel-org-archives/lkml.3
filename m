Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3AVPsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:48:23 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:34101 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3AVPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:48:22 -0500
Date: Wed, 23 Jan 2013 00:48:14 +0900
From: Minchan Kim <minchan.kernel.2@gmail.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
 ARM
Message-ID: <20130122154814.GB3757@blaptop>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk>
 <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
 <20130119044602.GC5391@phenom.dumpdata.com>
 <20130121055541.GD3666@blaptop>
 <CAKGA1bk3xdD5sTnn8DR9HQ4ae1sUsEnC1ENcwa3jfjDQgGp6QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bk3xdD5sTnn8DR9HQ4ae1sUsEnC1ENcwa3jfjDQgGp6QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Mon, Jan 21, 2013 at 10:00:17AM -0600, Matt Sealey wrote:
> Hi Minchan,
> 
> On Sun, Jan 20, 2013 at 11:55 PM, Minchan Kim <minchan@kernel.org> wrote:
> > On Fri, Jan 18, 2013 at 11:46:02PM -0500, Konrad Rzeszutek Wilk wrote:
> >> On Fri, Jan 18, 2013 at 07:11:32PM -0600, Matt Sealey wrote:
> >> >
> >> > diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> > b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> > index 09a9d35..ecf75fb 100644
> >>       > --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> > +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> > @@ -228,7 +228,7 @@ struct zs_pool {
> >> >   * mapping rather than copying
> >> >   * for object mapping.
> >> >  */
> >> > -#if defined(CONFIG_ARM)
> >> > +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)
> >> >  #define USE_PGTABLE_MAPPING
> >
> > I don't get it. How to prevent the problem Russel described?
> > The problem is that other CPU can prefetch _speculatively_ under us.
> 
> It prevents no problems, but if that isn't there, kernels build
> without SMP support (i.e. specifically uniprocessor kernels) will fail
> at the linker stage.
> 
> That's not desirable.
> 
> We have 3 problems here, this solves the first of them, and creates
> the third. The second is constant regardless..
> 
> 1) zsmalloc will not build on ARM without CONFIG_SMP because on UP
> local_tlb_flush_kern_range uses a function which uses an export which
> isn't required on SMP
> 
> Basically, with CONFIG_SMP (and CONFIG_UP_ON_SMP),
> local_tlb_flush_kern_range is calling functions by dereference from
> the per-cpu global cpu_tlb structure.
> 
> On UP (!CONFIG_SMP), it is calling functions directly (in my case,
> v7wbi_local_tlb_flush_kern_range or whatever, but on v6, v5, v4 ARM
> processor kernel builds it may be different) which need to be exported
> outside of the MM core.
> 
> If this difference is going to stick around - Russell is refusing here
> to export that/those direct functions - then the optimized vm mapping
> code simply should never be allowed to run on non-SMP systems to keep
> it building for everyone.
> 
> The patch above is simply a build fix for !CONFIG_SMP in this case to
> force it to use the slow path for systems where the above missing
> export problem will cause the linker failure.
> 
> 2) the optimized vm mapping isn't per-cpu aware as per Russell's
> arguments. I'll let you guys discuss that as I have no idea what the
> real implications are for SMP systems (and my current testing is only
> on a non-SMP CPU, I will have to go grab a couple boards from the lab
> for SMP)
> 
> 3) it somewhat defeats the purpose of the optimization if UP systems
> (which tend to have less memory and might benefit from things like
> zsmalloc/zram more) cannot use it, but SMP systems which tend to have
> more memory (unless we're talking about a frugal configuration of a
> virtual machine, perhaps). Given the myriad use cases of zram that is
> not a pervasive or persuasive argument, I know, but it does seem
> slightly backwards.
> 
> > If I don't miss something, we could have 2 choice.
> >
> > 1) use flush_tlb_kernel_range instead of local_flush_tlb_kernel_range
> > Or
> > 2) use only memory copy
> >
> > I guess everybody want 2 because it makes code very simple and maintainable.
> > Even, rencently Joonsoo sent optimize patch.
> > Look at https://lkml.org/lkml/2013/1/16/68 so zram/zcache effect caused by 2
> > would be minimized.
> >
> > But please give me the time and I will borrow quad-core embedded target board
> > and test 1 on the phone with Seth's benchmark.
> 
> In the meantime please take into account building a non-SMP kernel for
> this board and testing that; if there is a way to do the flush without
> using the particular function which uses the particular export that
> Russell will not export, then that would be better. Maybe for
> !CONFIG_SMP using flush_tlb_kernel_range is doing the exact same job
> and the real patch is not to disable the optimization with
> !CONFIG_SMP, but to additionally #if defined(CONFIG_SMP) around
> local_flush_tlb_kernel_range and alternatively for UP use
> flush_tlb_kernel_range which.. probably.. doesn't use that contentious
> export?
> 
> This is far beyond the level I want to be digging around in the Linux
> kernel so I am not comfortable even trying that to find out.
> 

How about this? Could you confirm it? If you confirm, I will send it
to stable, too.
Thanks!

>From 7e1f315bef3e1956a32665335c3f86321c069947 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 23 Jan 2013 00:28:02 +0900
Subject: [PATCH] Fix build error in !CONFIG_SMP and CONFIG_ARM

Matt Sealey reported he fail to build zsmalloc due to use of
local_flush_tlb_kernel_range which are architecture dependent
function so !CONFIG_SMP in ARM couldn't implement it so it ends up
build error.

  MODPOST 216 modules
  LZMA    arch/arm/boot/compressed/piggy.lzma
  AS      arch/arm/boot/compressed/lib1funcs.o
ERROR: "v7wbi_flush_kern_tlb_range"
[drivers/staging/zsmalloc/zsmalloc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

The reason we used that function is copy method by [1]
was really slow in ARM but at that time, we didn't check
local_flush_tlb_kernel_range and flush_tlb_kernel_range's
performance gap.

Today, my experiment in ARMv7 processor 4 core didn't make
any difference with zsmapbench[2] but still page-table based
is better than copy-based.

* bigger is better.

1. local_flush_tlb_kernel_range: 3918795 mappings
2. flush_tlb_kernel_range : 3989538 mappings
3. copy-based: 635158 mappings

This patch replace local_flush_tlb_kernel_range with
flush_tlb_kernel_range which are avaialbe in all architectures
because it is already used by vmalloc allocator which are generic one.
So build problem should go away and performane loss shoud be void.

[1] f553646, zsmalloc: add page table mapping method
[2] https://github.com/spartacus06/zsmapbench

Reported-by: Matt Sealey <matt@genesi-usa.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index eb00772..66aa4df 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -663,7 +663,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
 
 	flush_cache_vunmap(addr, end);
 	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
-	local_flush_tlb_kernel_range(addr, end);
+	flush_tlb_kernel_range(addr, end);
 }
 
 #else /* USE_PGTABLE_MAPPING */
-- 
1.7.9.5


-- 
Kind regards,
Minchan Kim
