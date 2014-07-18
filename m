Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbaGRL6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:58:34 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:51739 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaGRL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:58:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140718110718.GC19850@arm.com>
References: <1403499924-11214-1-git-send-email-msalter@redhat.com>
	<20140623110937.GB15907@arm.com>
	<1403529423.755.49.camel@deneb.redhat.com>
	<20140624141455.GE4489@arm.com>
	<1403620714.755.69.camel@deneb.redhat.com>
	<20140718110718.GC19850@arm.com>
Date: Fri, 18 Jul 2014 17:28:31 +0530
Message-ID: <CALrVBkvWejppnR2+Qwc__LT2d=0bQtEwF325kMSmQ=7BeUBrdw@mail.gmail.com>
Subject: Re: [PATCH] arm64: make CONFIG_ZONE_DMA user settable
From: Anup Patel <anup.patel@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>, Loc Ho <lho@apm.com>,
        Kumar Sankaran <ksankaran@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 18 July 2014 16:37, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Jun 24, 2014 at 03:38:34PM +0100, Mark Salter wrote:
>> On Tue, 2014-06-24 at 15:14 +0100, Catalin Marinas wrote:
>> > On Mon, Jun 23, 2014 at 02:17:03PM +0100, Mark Salter wrote:
>> > > On Mon, 2014-06-23 at 12:09 +0100, Catalin Marinas wrote:
>> > > > My proposal (in the absence of any kind of description) is to still
>> > > > create a ZONE_DMA if we have DMA memory below 32-bit, otherwise just add
>> > > > everything (>32-bit) to ZONE_DMA. Basically an extension from your CMA
>> > > > patch, make dma_phys_limit static in that file and set it to
>> > > > memblock_end_of_DRAM() if no 32-bit DMA. Re-use it in the
>> > > > zone_sizes_init() function for ZONE_DMA (maybe with a pr_info for no
>> > > > 32-bit only DMA zone).
>> > >
>> > > There's a performance issue with all memory being in ZONE_DMA. It means
>> > > all normal allocations will fail on ZONE_NORMAL and then have to fall
>> > > back to ZONE_DMA. It would be better to put some percentage of memory
>> > > in ZONE_DMA.
>> >
>> > Is the performance penalty real or just theoretical? I haven't run any
>> > benchmarks myself.
>>
>> It is real insofar as you must eat cycles eliminating ZONE_NORMAL from
>> consideration in the page allocation hot path. How much that really
>> costs, I don't know. But it seems like it could be easily avoided by
>> limiting ZONE_DMA size. Is there any reason it needs to be larger than
>> 4GiB?
>
> Basically ZONE_DMA should allow a 32-bit dma mask. When memory starts
> above 4G, in the absence of an IOMMU, it is likely that 32-bit devices
> get some offset for the top bits to be able to address the bottom of the
> memory. The problem is that dma_to_phys() that early in the kernel has
> no idea about DMA offsets until later (they can be specified in DT per
> device).
>
> The patch belows tries to guess a DMA offset and use the bottom 32-bit
> of the DRAM as ZONE_DMA.
>
> -------8<-----------------------
>
> From 133656f8378dbb838ad5f12ea29aa9303d7ca922 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Fri, 18 Jul 2014 11:54:37 +0100
> Subject: [PATCH] arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB
>
> ZONE_DMA is created to allow 32-bit only devices to access memory in the
> absence of an IOMMU. On systems where the memory starts above 4GB, it is
> expected that some devices have a DMA offset hardwired to be able to
> access the bottom of the memory. Linux currently supports DT bindings
> for the DMA offsets but they are not (easily) available early during
> boot.
>
> This patch tries to guess a DMA offset and assumes that ZONE_DMA
> corresponds to the 32-bit mask above the start of DRAM.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/mm/init.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 7f68804814a1..160bbaa4fc78 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -60,6 +60,17 @@ static int __init early_initrd(char *p)
>  early_param("initrd", early_initrd);
>  #endif
>
> +/*
> + * Return the maximum physical address for ZONE_DMA (DMA_BIT_MASK(32)). It
> + * currently assumes that for memory starting above 4G, 32-bit devices will
> + * use a DMA offset.
> + */
> +static phys_addr_t max_zone_dma_phys(void)
> +{
> +       phys_addr_t offset = memblock_start_of_DRAM() & GENMASK_ULL(63, 32);
> +       return min(offset + (1ULL << 32), memblock_end_of_DRAM());
> +}
> +
>  static void __init zone_sizes_init(unsigned long min, unsigned long max)
>  {
>         struct memblock_region *reg;
> @@ -70,9 +81,7 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
>
>         /* 4GB maximum for 32-bit only capable devices */
>         if (IS_ENABLED(CONFIG_ZONE_DMA)) {
> -               unsigned long max_dma_phys =
> -                       (unsigned long)(dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1);
> -               max_dma = max(min, min(max, max_dma_phys >> PAGE_SHIFT));
> +               max_dma = PFN_DOWN(max_zone_dma_phys());
>                 zone_size[ZONE_DMA] = max_dma - min;
>         }
>         zone_size[ZONE_NORMAL] = max - max_dma;
> @@ -142,7 +151,7 @@ void __init arm64_memblock_init(void)
>
>         /* 4GB maximum for 32-bit only capable devices */
>         if (IS_ENABLED(CONFIG_ZONE_DMA))
> -               dma_phys_limit = dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1;
> +               dma_phys_limit = max_zone_dma_phys();
>         dma_contiguous_reserve(dma_phys_limit);
>
>         memblock_allow_resize();
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Linux-3.16-rcX is broken on X-Gene Mustang because
on X-Gene Mustang the DRAM starts at 0x4000000000.

I have tested your patch and the original patch from
this thread. Both patches fixes the issue for X-Gene
Mustang and Linux-3.16-rc5 happily boots on X-Gene.

Can you to send your patch as Linux-3.16-rcX fix?

For your patch, you can have:
Tested-by: Anup Patel <anup.patel@linaro.org>

Thanks,
Anup
