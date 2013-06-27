Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3F0Lzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:55:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3F0Lzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:55:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Date: Thu, 27 Jun 2013 13:55:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        patches@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@linaro.org
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org> <3503040.vhYAL5xGgS@wuerfel> <20130627092934.GD18151@rocoto.smurfnet.nu>
In-Reply-To: <20130627092934.GD18151@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306271355.08379.arnd@arndb.de>
X-Provags-ID: V02:K0:buj0ulKfZ15Fy5udB+iG15vnj6Kmj8ymks9uI6oAri1
 nIitm2gekL7w29oTDSbw52GpYAKmdatj7sX0Vk6gpyf3XVT07w
 8ptgU9oUtcJEOYZ7ng3DP6gRZpqQowwN+hTsHaiRCfrj9b0+xY
 QfKhF6B34PcQZ2spc0f+0LBsvl1TgqLse3kQnraXCt2sX1AzOf
 zafFTkMg4oNL+HHaSdNNaRR72DYR0zv3z0dcNvk/UFo/bEzS6r
 cHj6DUIsmebXE/IL8Hd4lkCNw9Dp/i+3+YVLu5ndtvkYBoGzY6
 zmex0eD0gyTw+rP7q6DCeXrnT+hyzh11XXdtR2PYeWCJFvgrGw
 Hc+c4QKn29BarJ2M/08c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 June 2013, Leif Lindholm wrote:
> On Thu, Jun 27, 2013 at 10:47:21AM +0200, Arnd Bergmann wrote:
> > > No, the purpose is just like for x86 - do early parsing of things like
> > > the UEFI system and configuration tables, DMI and ACPI, in order to
> > > populate global structs and stuff.
> > 
> > But are those tables actually in MMIO registers? I thought they
> > are just memory, and in that case using any form of ioremap is
> > wrong on ARM. Why do you even have to map them? Can't the boot
> > loader pass those tables in regular addressable memory?
>  
> Don't get too stuck on the name - x86 frequently uses *ioremap() in
> many places when just accessing memory, and that has carried into EFI,
> ACPI and DMI subsystems, which we now want to use on ARM. In fact, they
> have early_memremap(), but don't use it for either EFI or ACPI.

The difference of course is that x86 doesn't use page table flags
to tell the difference between MMIO and memory. It is not harmful
on x86 to access memory through ioremap, but it is on most
other architectures. You get either unspecified behavior due to
conflicting cache flags or you get a hard checkstop based on how
the CPU treats this. If you want to make the EFI code architecture
independent, I think you should change the EFI code.

> The ia64 implementation actually performs a lookup in the EFI memmap
> to decide whether early_ioremap() returns cacheable memory or not
> (and falls back to noncacheable before memory map is available).
> 
> That said, I had somehow managed to get into my mind that the kernel
> used -fno-unaligned-access, so thought MT_DEV_NONSHARED was safe.
> Clearly it isn't, so that will need to change, making the semantic
> match even worse...
> 
> As for the need of mapping - some of these descriptors are needed very
> early in the boot process. Also, depending on platform, they may reside
> at any offset from start of RAM (<2^32 physical address), rendering
> __va()/__phys_to_virt()/... unusable.

Can you explain why they are needed this early?

Also, can't we define the boot protocol to require these tables
within the first GB of RAM?

> > > Well, I did have a crazy idea that much/most of the early_ioremap code
> > > could be made generic and shared between x86 and arm (and any other
> > > 32-bit architecture). Using the fixmap macros would make that possible
> > > with a minimum of ifdefs.
> > > 
> > > If we ever wanted early_ioremap() to work like on x86, beyond kmap_init()
> > > (but not beyond the "booting" system state), using the same macros would
> > > help there too. I had no need for that for my EFI patches.
> > 
> > I guess I need to look at the EFI patches first. It sounds to me
> > like you shouldn't actually be using early_ioremap here or on another
> > architecture.
> 
> No, but I had been kind of hoping not having to rework the early memory
> initialisation for three subsystems on two other platforms in order to
> be able to merge common code between them. And it would have felt silly
> to invent a new mechanism just for ARM, preventing that option.

Well, if you can get around the "early" requirement, things can become
much easier, you can basically 

#define early_ioremap(addr, size) ioremap(addr, size)
#define early_memremap(addr, size) ioremap_cached(addr, size)

and just need to fix the places where the common code mistakenly calls
early_ioremap instead of early_memremap.

Chances are that even if you can't avoid the requirement for early
maps entirely that you only really have to worry about a small number
of callers, for which you can then introduce architecture specific
functions that do one thing in an appropriate way. On ARM, this may
end up being __va(), kmap_atomic() or iotable_init() depending on
the requirements.

	Arnd
