Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaKYPUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:20:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39002 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaKYPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:20:20 -0500
Date: Tue, 25 Nov 2014 15:20:09 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "zhichang.yuan" <zhichang.yuan@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1] arm64:mm: An optimization about kernel direct
 sapce mapping
Message-ID: <20141125152009.GE18858@e104818-lin.cambridge.arm.com>
References: <1416406915-10939-1-git-send-email-zhichang.yuan@linaro.org>
 <20141124171749.GA12895@e104818-lin.cambridge.arm.com>
 <54748F27.8020902@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54748F27.8020902@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 02:16:07PM +0000, zhichang.yuan wrote:
> On 2014年11月25日 01:17, Catalin Marinas wrote:
> > I'm trying to make some sense of this patch, so questions below:
> >
> > On Wed, Nov 19, 2014 at 02:21:55PM +0000, zhichang.yuan@linaro.org wrote:
> >> From: "zhichang.yuan" <zhichang.yuan@linaro.org>
> >>
> >> This patch make the processing of map_mem more common and support more
> >> discrete memory layout cases.
> >>
> >> In current map_mem, the processing is based on two hypotheses:
> >> 1) no any early page allocations occur before the first PMD or PUD regime
> >> where the kernel image locate is successfully mapped;
> > No because we use the kernel load offset to infer the start of RAM
> > (PHYS_OFFSET). This would define which memory you can allocate.
> 
> I note that the current PHYS_OFFSET is 0x8000,0000 in JUNO,
> 0x4000,0000 in QEMU.  I think the current processing like that: the
> booloader load the kernel image at (PHYS_OFFSET + TEXT_OFFSET), and
> vmlinux.lds.S define the VMA of image as (. = PAGE_OFFSET +
> TEXT_OFFSET). So, the starting RAM physical address, PHYS_OFFSET,
> correspond to PAGE_OFFSET now.( this is my inference, have not
> investigate the UEFI)

Yes, but the PAGE_OFFSET / PHYS_OFFSET relation is true on any
architecture. The linear kernel mapping translates virtual address at
PAGE_OFFSET to physical address PHYS_OFFSET.

Also note that PHYS_OFFSET is not known at build time. The kernel entry
code calculates it by subtracting TEXT_OFFSET from its load address.
TEXT_OFFSET is known at build time.

> But is it possible in the future the kernel image is loaded to a
> memory range that is not the first memblock, such as :
> 
> block 0: 0x100000, 0x20100000
> block 1: 0x40000000, 0x40000000
> 
> Supposed the block 1 is where the kernel image locate.
> 
> Actually, if bootloader put the kernel image at a configurable
> physical address named as PA, and VMA of text section is defined as
> PAGE_OFFSET + 0x100000 + PA, then PAGE_OFFSET will correspond to
> 0x100000.

Basically what you want is configurable TEXT_OFFSET based on your
configurable physical address PA. For single kernel Image running on
multiple platforms, we don't want this. PA in this case would be
platform specific.

> In x86, the VMA of text section is as below:
> 
> #ifdef CONFIG_X86_32
>         . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
> #else
>         . = __START_KERNEL;
> #endif
> 
> LOAD_PHYSICAL_ADD is configurable. I think it can support different
> hardware design.

One x86, this LOAD_PHYSICAL_ADDR is defined to CONFIG_PHYSICAL_START
which is only enabled if EXPERT || CRASH_DUMP. It's not a general user
config option for exactly the same reasons as stated above - single
kernel Image.

> >> 2) there are sufficient available pages in the PMD or PUD regime to satisfy
> >> the need of page tables from other memory ranges mapping.
> >
> > I don't fully understand this. Can you be more specific?
> 
> Supposed this memory layout:
> 
> block 0: 0x40000000, 0xc00000
> block 1: 0x60000000, 0x1f000000
> block 2: 0x80000000, 0x40000000
> 
> if the end of kernel image is near to 0xc00000, it is possible no
> available mapped pages for other blocks mapping.
> 
> Of-course, this is a very special case, not practical, since the
> memblock where the kernel image locate should be big enough.

So is this a real use-case?

> >> In addition, for the 4K page system, to comply with the constraint No.1, the
> >> start address of some memory ranges is forced to align at PMD boundary, it
> >> will make some marginal pages of that ranges are skipped to build the PTE. It
> >> is not reasonable.
> >
> > It is reasonable to ask for the start of RAM to be on a PMD (2MB)
> > boundary.
>
> I think the physical address where the kernel image locate can be
> limited on PMD boundary. But the start of RAM is decided by Soc or
> hardware platform. For example, the start of RAM only align to MB
> boundary.

But, again, do you have a real use-case in mind or just theoretical? For
arm64, we expect at least a bit of alignment with the SBSA where the
memory starts on a GB boundary.

> >> This patch will relieve the system from those constraints. You can load the
> >> kernel image in any memory range, the memory range can be small, can start at
> >> non-alignment boundary, and so on.
> >
> > I guess you still depend on the PAGE_OFFSET, TEXT_OFFSET, so it's not
> > random.
> >
> > I'm not sure what the end goal is with this patch but my plan is to
> > entirely decouple TEXT_OFFSET from PAGE_OFFSET (with a duplicate mapping
> > for the memory covering the kernel text). This would allow us to load
> > the kernel anywhere in RAM (well, with some sane alignment to benefit
> > from section mapping) and the PHYS_OFFSET detected from DT at run-time.
> > Once that's done, I don't think your patch is necessary.
> 
> I am not so clear what is the coupling between TEXT_OFFSET and
> PAGE_OFFSET. It seems the VMA and LMA have some coupling.

(I don't entirely follow the VMA and LMA acronyms, something to do with
virtual address and load address?)

> PHYS_OFFSET + TEXT_OFFSET <------------> PAGE_OFFSET + TEXT_OFFSET.

What I meant is that we should no longer mandate that the kernel Image
is loaded at PHYS_OFFSET + TEXT_OFFSET.

With additional kernel changes it could be loaded at (TEXT_OFFSET +
random-2MB-aligned-address) which gets mapped during boot to a
KERNEL_PAGE_OFFSET, different from PAGE_OFFSET. We still have the
PAGE_OFFSET -> PHYS_OFFSET correspondence but not with
KERNEL_PAGE_OFFSET. TEXT_OFFSET, PAGE_OFFSET and KERNEL_PAGE_OFFSET
would be build-time configurations while PHYS_OFFSET would be computed
at run-time based on the memory blocks described in DT (rather than
kernel-load-addr - TEXT_OFFSET).

-- 
Catalin
