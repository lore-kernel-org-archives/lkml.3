Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaKZV3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:29:00 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:49168 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaKZV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:28:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jonas Gorski <jogo@openwrt.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
Date: Wed, 26 Nov 2014 22:28:45 +0100
Message-ID: <6239602.L0sNsMk5KV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7DwhSySAa19OxfUDkvT4DLWaZ3uhPU2QJzQ6Gc7YCvDgg@mail.gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com> <3146555.WCj2bhBSnP@wuerfel> <CAJiQ=7DwhSySAa19OxfUDkvT4DLWaZ3uhPU2QJzQ6Gc7YCvDgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PL6tCWJuecBrxUbaEe4Ll1kfgqDUqU5q5ivxHBgCeiL
 qyEyOceQWXLDqFK+eP1hCiPNe21ntTO4PEKCy+WTrSdrtAlerG
 7JADVkMwqYZhFxqRoqvk6QjMRtZzglKFxV2zxuCrRkDpiAeWQz
 78d7Vjx7oSZbfiUYQSWxU6nkR081LTkVceKavToTT90ETpilRb
 qZgfvvOF7w56wb/jTtqbI0xAdYTXb6hbG+UzaNFE4adCuLJJNt
 TwiUbZMnt8pvjQl/wFsLavlnI8mW7V0JCTTw3yuhNjqpEblPpE
 DxJTjQN3OtvP80dRCWkB5Nn1rmly2I0n1kc2iycKI05eqpSC9p
 u9XFtAAW+5HVzwA2qxWs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014 12:45:47 Kevin Cernekee wrote:
> On Mon, Nov 24, 2014 at 1:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> +OF_DECLARE_2(irqchip, mips_cpu_intc, "mti,cpu-interrupt-controller",
> >> >> +          mips_cpu_irq_of_init);
> >> >
> >> > OF_DECLARE_2 really wasn't meant to be used directly. Can you move this
> >> > code into drivers/irqchip and make it use IRQCHIP_DECLARE()?
> >>
> >> Perhaps arch/mips/kernel/irq_cpu.c could be moved under
> >> drivers/irqchip in a future commit?  We'll probably have to change the
> >> way arch/mips/ralink invokes it too.
> >
> > Possibly, but that seems unrelated. Moving this file is required
> > in order to use IRQCHIP_DECLARE, which is defined in
> > drivers/irqchip/irqchip.h.
> 
> arch/mips/kernel/irq_cpu.c is the actual irqchip driver containing
> mips_cpu_irq_of_init().  It probably would not make sense to move
> arch/mips/bmips/irq.c (platform IRQ stubs, not an irqchip driver)
> under drivers/irqchip.

I see. Makes sense.

> >> > Is this intended to become a generic MIPS boot interface? Better
> >> > document it in Documentation/mips/
> >>
> >> Not sure yet.  It's currently limited to BCM3384.
> >>
> >> For V4 I can add an "Entry point for arch/mips/bmips" or even an
> >> "Entry point for arch/mips" section to
> >> Documentation/devicetree/booting-without-of.txt.  Any preferences?
> >
> > If the goal is being able to have a multiplatform kernel
> > that can cover more than just BMIPS, I think this would have
> > to be documented as the only way for MIPS multiplatform.
> >
> > If that isn't possible, most of my other comments here are
> > moot, but then you shouldn't call it "multiplatform" but just
> > "generic BMIPS" or something like that.
> 
> Currently my goal is to cover BMIPS only.  Although it's possible that
> someday somebody develops a more hardware-independent implementation
> that runs on other MIPS processor variants.
> 
> So, I can go ahead and rename it to "Generic BMIPS" if that clarifies
> the intent.

Ok. One more thought: With the powerpc-approach of having platform
specific boot wrappers (with or without uncompress code), the boot
protocol would no longer matter to the common multiplatform
implementation, and the specific BMIPS interface would become
part of arch/mips/boot/bmips.c or something like that. Looking at
the Makefile in there, MIPS already supports six different binary
formats that can all be generated from the same vmlinux, so at the
point when someone implements a full multiplatform implementation,
the bmips specifics can become another binary format that encapsulates
the vmlinux file and an optional dtb file and passes the dtb
into the common kernel entry point when calling the actual vmlinux
head.S.

> >> >> diff --git a/arch/mips/include/asm/mach-bmips/dma-coherence.h b/arch/mips/include/asm/mach-bmips/dma-coherence.h
> >> >> new file mode 100644
> >> >> index 000000000000..5481a4d1bbbf
> >> >> --- /dev/null
> >> >> +++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
> >> >> @@ -0,0 +1,45 @@
> >> >> +#ifndef __ASM_MACH_BMIPS_DMA_COHERENCE_H
> >> >> +#define __ASM_MACH_BMIPS_DMA_COHERENCE_H
> >> >> +
> >> >> +struct device;
> >> >> +
> >> >> +extern dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size);
> >> >> +extern dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page);
> >> >> +extern unsigned long plat_dma_addr_to_phys(struct device *dev,
> >> >> +     dma_addr_t dma_addr);
> >> >> +extern void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
> >> >> +     size_t size, enum dma_data_direction direction);
> >> >
> >> > I think you could just add these to
> >> > arch/mips/include/asm/mach-generic/dma-coherence.h and get rid of the
> >> > header file, after adding a Kconfig symbol.
> >>
> >> Some platforms mix and match inline definitions versus externs in this file.
> >>
> >> Maybe Ralf can comment on whether we should move to an "all or nothing" model?
> >
> > To clarify where I was getting to here: In a generic multiplatform kernel,
> > you would probably want to always look at the dma-ranges properties here,
> > at least if there are one or more platforms built into the kernel that
> > don't just have a flat mapping that the current mach-generic header
> > provides.
> 
> For the BMIPS case:
> 
> plat_map_dma_mem* and plat_dma_addr_to_phys are just performing
> remapping, so dma-ranges would work.
> 
> plat_unmap_dma_mem is used to perform an extra BMIPS-specific
> cacheflush operation.

Yes, the cacheflush again would have to be abstracted. This is normally
done using either a platform-specific dma_map_ops struct, or using
a further abstraction with another function pointer.

I'm surprised that you need the special flush operation only
for 'unmap' and not for 'dma_sync_*_for_cpu'. Can you check that
you are actually doing the right thing for drivers that reuse
a DMA buffer with the streaming API?

> Not sure about something like this - I guess it would work with 4
> ranges as long as bits 63:39 of daddr are 0:
> 
> phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
> {
>     long nid;
> #ifdef CONFIG_PHYS48_TO_HT40
>     /* We extract 2bit node id (bit 44~47, only bit 44~45 used now) from
>      * Loongson-3's 48bit address space and embed it into 40bit */
>     nid = (daddr >> 37) & 0x3;
>     daddr = ((nid << 37) ^ daddr) | (nid << 44);
> #endif
>     return daddr;
> }
> 
> dma-octeon.c also has a few different cases to handle, but it looks
> like they are range remappings selected based on the machine type;
> that might still be suitable for DT.
> 
> The other tests in that file (coherency, per-device DMA masks) might
> be better off as DT properties.

I guess a platform that doesn't fit the simple model could always
have its own dma_map_ops and not use the the dma-coherence.h interfaces.

	Arnd
