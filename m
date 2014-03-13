Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaCMPBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:01:17 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:52014 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaCMPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:01:10 -0400
Date: Thu, 13 Mar 2014 11:01:08 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Liu hua <sdu.liu@huawei.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, msalter@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wang Nan <wangnan0@huawei.com>, peifeiyue@huawei.com,
        wangkefeng.wang@huawei.com, Li Zefan <lizefan@huawei.com>
Subject: Re: [ARM]Fixmap mapping region is not enough for system of 14+
 CPUs.
In-Reply-To: <53215F99.8060804@huawei.com>
Message-ID: <alpine.LFD.2.11.1403131049410.1217@knanqh.ubzr>
References: <53203F9C.8040500@huawei.com> <53204956.30703@huawei.com> <alpine.LFD.2.11.1403121306280.1217@knanqh.ubzr> <53215F99.8060804@huawei.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Liu hua wrote:

> On 2014/3/13 1:08, Nicolas Pitre wrote:
> > On Wed, 12 Mar 2014, Liu hua wrote:
> > 
> >> Hi Russell, Will or Nicolas,
> >>
> >> (In this mail, we only discuss ARM 32-bit linux.)
> >>
> >> As we know, the region (0xfff00000-0xfffdffff) is reserved as fixmap
> >> mapping region.
> >>
> >> The function "kmap_atomic" maps highmem pages to this region referring
> >> to CPUID and per-cpu variable "__kmap_atomic_idx" via
> >>
> >>   idx = type + KM_TYPE_NR * smp_processor_id();
> >>   vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> >>
> >> Size of region used by one cpu is 0x10000 (KM_TYPE_NR << PAGE_SHIFT).
> >> And the total size of the fixmap mapping region is 0xe0000.
> >> (only support 14 CPUs).
> >>
> >> So in a system of more than 14 CPUs, this region is not large enough.
> >> should we change the memory layout on ARM Linux to support 14+ cpu system ?
> >> Or can we do anything else to support that ?
> > 
> > How many CPUs do you have?
> > 
> > What about the following patch?  If this doesn't work for you then more 
> > intrusive changes will be needed.
> > 
> > diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> > index 68ea615c2a..254f2df08d 100644
> > --- a/arch/arm/include/asm/fixmap.h
> > +++ b/arch/arm/include/asm/fixmap.h
> > @@ -14,7 +14,17 @@
> >   */
> >  
> >  #define FIXADDR_START		0xfff00000UL
> > +
> > +#if !defined(CONFIG_HAVE_TCM) && !defined(CONFIG_CPU_XSCALE)
> > +/*
> > + * If no TCM nor on on a XScale then enlarge the fixmap area to
> > + * accommodate up to 30 CPUs.
> > + */
> > +#define FIXADDR_END		0xffff0000UL
> > +#else
> >  #define FIXADDR_END		0xfffe0000UL
> One cpu need 0x10000-size region; So this patch can only support
> uo to 15 CPUs
Hmmm... You're right of course.

> We have 16 CPUs in our system. And your patch cannot work if
> the CPU number exceeds 15.
> 
> In addition, we can configure NR_CPUS up to 32. So should we
> solve this problem completely?
> 
> There is an 1M-size hole between DMA mapping region and fixmap
> mapping region(0xffe00000-0xfff00000).if this region are belonged
> to fixmap mapping region, it can only support 30 CPUs.
> 
> Since we have alloced a second level page table to coverring
> 0xffe00000 - 0xffffffff(2M). And 0xffff0000 upwards used as
> vector pages. So if the left region is all used as fixmap mapping
> region(size : 0x1f0000). Up to 31 CPUs is supported.
> 
> 
> The following patch can solve our problem(up to 30 CPUs), But it
> reduce the DMA region. What do you think about it ?
> Is is necessory to solve this problem completely(up to 32 CPUs)
> ?
> 
> 
> Liu Hua
> 
> -----------------
> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> index 68ea615..8379891 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -13,7 +13,7 @@
>   * 0xfffe0000 and 0xfffeffff.
>   */
> 
> -#define FIXADDR_START              0xfff00000UL
> +#define FIXADDR_START                0xffe00000UL
>  #define FIXADDR_END            0xfffe0000UL
>  #define FIXADDR_TOP            (FIXADDR_END - PAGE_SIZE)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 4afb376..0c40674 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -83,7 +83,7 @@
>   */
>  #define IOREMAP_MAX_ORDER      24
> 
> -#define CONSISTENT_END             (0xffe00000UL)
> +#define CONSISTENT_END               (0xffd00000UL)

Some systems might possibly have issues with a smaller DMA region. 
I don't recall which though.

you should also update Documentation/arm/memory.txt in your patch.
Then I'd suggest you can repost it more formally for comments.


Nicolas
