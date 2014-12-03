Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLCJwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:52:40 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:60344 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbaLCJwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:52:35 -0500
Message-ID: <547EDD61.5080907@free.fr>
Date: Wed, 03 Dec 2014 10:52:33 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Creating 16 MB super-sections for MMIO
References: <547D97A5.4090302@free.fr>
In-Reply-To: <547D97A5.4090302@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Top-posting to address topicality]

Is LKML more appropriate a list to discuss MMU setup?
(I've been studying arch-specific code in arch/arm/mm)

Regards.

On 02/12/2014 11:42, Mason wrote:

> [Branched from "Code generation involving __raw_readl and __raw_writel" thread]
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/376055
>
> On 27/11/2014 14:12, Arnd Bergmann wrote:
>
>> On Thursday 27 November 2014 14:01:41 Mason wrote:
>>
>>> I'm asking because I have an idea in mind: on the bus, the first
>>> 16 MB contains only memory-mapped registers, so I've been thinking
>>> I can map this region at init, and keep it for the lifetime of the
>>> system. It would use only one entry in the TLB, since the CPU
>>> supports 16 MB super-sections.
>>>
>>> I could even lock that entry in the TLB so that these accesses
>>> are guaranteed to never TLB-miss, right?
>>
>> The map_io callback will set up a mapping like that, and when
>> a driver calls ioremap on the same physical address, you will
>> get the correct pointer using that TLB, you just don't communicate
>> the address through a pointer any more.
>
> [NOTE: Initially, the focus of this message was on TLB lockdown,
> but then it changed to creating super-sections]
>
> According to the ARM architecture manual:
>
>     The architecture has a concept of an entry locked down in the TLB.
>     The method by which lockdown is achieved is IMPLEMENTATION DEFINED,
>     and an implementation might not support lockdown.
>
> Does Linux support locking down an entry in the TLB?
> Where are CPU-specific implementations stored in the source tree?
> (I'm using a Cortex A9.)
>
> I glanced at
>
>    arch/arm/mm/tlb-v7.S
>    arch/arm/include/asm/tlbflush.h
>
> but nothing jumped out at me.
>
> arch/arm/mach-tegra/cortex-a9.S (an obsolete file?) did mention
> lockdown (albeit in a comment only).
>
> https://chromium.googlesource.com/chromiumos/third_party/kernel-next/+/0.11.257.B/arch/arm/mach-tegra/cortex-a9.S
>
> [some time passes]
>
> After giving the issue more thought, I think trying to lock the TLB entry
> might be a case of premature optimization. However, it seems worthwhile to
> make sure that Linux correctly sets up the 16 MB mapping, using a single
> TLB entry (instead of 16 section entries).
>
> I traced create_mapping -> alloc_init_pud -> alloc_init_pmd -> __map_init_section
>
> (I think I'm in the right place...)
> However, I was expecting PMD_SECT_SUPER somewhere in there, yet I don't
> see any, so I'm not confident about a super-section being created.
>
> The only two relevant functions appear to be
>
>    create_36bit_mapping()
>    remap_area_supersections()
>
> The first is only called in this case:
> #ifndef CONFIG_ARM_LPAE
>      /*
>       * Catch 36-bit addresses
>       */
>      if (md->pfn >= 0x100000) {
>          create_36bit_mapping(md, type);
>          return;
>      }
> #endif
>
> Since I want to map PA 0, I could lie and pretend it is PA 2^32,
> pray for a wrap-around back to 0, and get the super-section mapping.
> That sounds like an ugly hack...
>
> The other function is only called in this case:
> #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
>      if (DOMAIN_IO == 0 &&
>          (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
>             cpu_is_xsc3()) && pfn >= 0x100000 &&
>             !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
>          area->flags |= VM_ARM_SECTION_MAPPING;
>          err = remap_area_supersections(addr, pfn, size, type);
>      } else if (!((paddr | size | addr) & ~PMD_MASK)) {
>          area->flags |= VM_ARM_SECTION_MAPPING;
>          err = remap_area_sections(addr, pfn, size, type);
>      } else
> #endif
>
> But we do define CONFIG_SMP (dual core CPU).
> So no super-sections for me, IIUC?
>
> Regards.

