Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaKYOPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:15:53 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34350 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKYOPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:15:51 -0500
Message-ID: <54748F27.8020902@linaro.org>
Date: Tue, 25 Nov 2014 22:16:07 +0800
From: "zhichang.yuan" <zhichang.yuan@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1] arm64:mm: An optimization about kernel direct
 sapce mapping
References: <1416406915-10939-1-git-send-email-zhichang.yuan@linaro.org> <20141124171749.GA12895@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141124171749.GA12895@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月25日 01:17, Catalin Marinas wrote:
> Hi,
>
> I'm trying to make some sense of this patch, so questions below:
>
> On Wed, Nov 19, 2014 at 02:21:55PM +0000, zhichang.yuan@linaro.org wrote:
>> From: "zhichang.yuan" <zhichang.yuan@linaro.org>
>>
>> This patch make the processing of map_mem more common and support more
>> discrete memory layout cases.
>>
>> In current map_mem, the processing is based on two hypotheses:
>> 1) no any early page allocations occur before the first PMD or PUD regime
>> where the kernel image locate is successfully mapped;
> No because we use the kernel load offset to infer the start of RAM
> (PHYS_OFFSET). This would define which memory you can allocate.
I note that the current PHYS_OFFSET is 0x8000,0000 in JUNO, 0x4000,0000 in QEMU.  I think the current
processing like that:
the booloader load the kernel image at (PHYS_OFFSET + TEXT_OFFSET), and vmlinux.lds.S define the VMA of image
as (. = PAGE_OFFSET + TEXT_OFFSET). So, the starting RAM physical address, PHYS_OFFSET, correspond to
PAGE_OFFSET now.( this is my inference, have not investigate the UEFI)


But is it possible in the future the kernel image is loaded to a memory range that is not the first memblock,
such as :

block 0: 0x100000, 0x20100000
block 1: 0x40000000, 0x40000000

Supposed the block 1 is where the kernel image locate.


Actually, if bootloader put the kernel image at a configurable physical address named as PA, and VMA of text
section is defined as PAGE_OFFSET + 0x100000 + PA, then PAGE_OFFSET will correspond to 0x100000.

In x86, the VMA of text section is as below:

#ifdef CONFIG_X86_32
        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
#else
        . = __START_KERNEL;
#endif

LOAD_PHYSICAL_ADD is configurable. I think it can support different hardware design.


I am not sure whether this case will happen.

>> 2) there are sufficient available pages in the PMD or PUD regime to satisfy
>> the need of page tables from other memory ranges mapping.
> I don't fully understand this. Can you be more specific?
>
Supposed this memory layout:

block 0: 0x40000000, 0xc00000
block 1: 0x60000000, 0x1f000000
block 2: 0x80000000, 0x40000000

if the end of kernel image is near to 0xc00000, it is possible no available mapped pages for other blocks
mapping.

Of-course, this is a very special case, not practical, since the memblock where the kernel image locate should
be big enough.

>> The current SOC or hardware platform designs had not broken this constraint.
>> But we can make the software more versatile.
> We need to have code readability in mind ;).
>
>> In addition, for the 4K page system, to comply with the constraint No.1, the
>> start address of some memory ranges is forced to align at PMD boundary, it
>> will make some marginal pages of that ranges are skipped to build the PTE. It
>> is not reasonable.
> It is reasonable to ask for the start of RAM to be on a PMD (2MB)
> boundary.
I think the physical address where the kernel image locate can be limited on PMD boundary. But the start of
RAM is decided by Soc or hardware platform. For example, the start of RAM only align to MB boundary.
>> This patch will relieve the system from those constraints. You can load the
>> kernel image in any memory range, the memory range can be small, can start at
>> non-alignment boundary, and so on.
> I guess you still depend on the PAGE_OFFSET, TEXT_OFFSET, so it's not
> random.
>
> I'm not sure what the end goal is with this patch but my plan is to
> entirely decouple TEXT_OFFSET from PAGE_OFFSET (with a duplicate mapping
> for the memory covering the kernel text). This would allow us to load
> the kernel anywhere in RAM (well, with some sane alignment to benefit
> from section mapping) and the PHYS_OFFSET detected from DT at run-time.
> Once that's done, I don't think your patch is necessary.
>
> Thanks.


I am not so clear what is the coupling between TEXT_OFFSET and PAGE_OFFSET. It seems the VMA and LMA have some
coupling.

PHYS_OFFSET + TEXT_OFFSET <------------> PAGE_OFFSET + TEXT_OFFSET.

I am not sure what situation will be happened on the SOC design or application, that is the reason why i
submit as RFC.
If the cases i described do not need to think about or can not exist, this RFC can be skipped.


Thanks,
-Zhichang
