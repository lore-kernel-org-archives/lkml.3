Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKQQNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:13:40 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:63405 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaKQQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:13:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, dtor@chromium.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Mon, 17 Nov 2014 17:13:27 +0100
Message-ID: <2018325.yOrLZndTTm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAOiHx=ky5T7z3T3gX382d=3sw+gGUEfnwXwpcLGa_Oi5YyBwgw@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <3480616.V2TMJFc7uE@wuerfel> <CAOiHx=ky5T7z3T3gX382d=3sw+gGUEfnwXwpcLGa_Oi5YyBwgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NYlqbZSnf5RW/jAy3d4f56sKxXhB/UM28+EjWDxy7hA
 yn/lLTlwn+1H6yhS2Ivs6nKk1n7aWBOaD2DiVFHuaq0wd3fkdp
 mvfjY5UaK41D9aeXrK/UTSjSd4FC/RELcMtJOcO5wcVMCjA4oA
 N2QSuZBqp61CKnkkysUn++PnJYQzyy61pEeuaATF6mg6RC+WWb
 I99HNp587MdmgbgPZtlvEOlWgz2k+dlhRl1oxXIqjilda13owm
 wwz20dzmQNQ/MWdJn+VDWKxmZGUd4baZ83ST1iKlJxoG0FG5vm
 zUt/EwISy9Zdj+QVcs/N6hh23q8hB+10bFPSd+fhc0fBwVg9HV
 EtoUFDTpm5T63v29JarM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 15:52:15 Jonas Gorski wrote:
> On Mon, Nov 17, 2014 at 1:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I still think this is different in the sense that ARM multiplatform
> > support is about combining platforms from separate mach-* directories,
> > while your approach was to rewrite multiple mach-* directories into
> > a single new one that remains separate from the others. While this is
> > a great improvement, it doesn't get you any closer to having a
> > combined BMIPS+RALINK+JZ4740+ATH79 kernel for instance. I don't know
> > if such a kernel is something that anybody wants, or if it's even
> > technically possible.
> >
> > If you wanted to do that however, starting with BMIPS you'd have
> > to make it possible to define a new platform without the
> > arch/mips/include/asm/mach-bmips/ directory (this should be possible
> > already, so the hardest part is done), replace all global function
> > calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
> > platform-independent implementations or wrappers around per-platform
> > callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
> > outside of the "System type" choice statement.
> > Until you do that, your platform isn't "more multipliplatform" than
> > the others really, it just abstracts the differences between some
> > SoCs nicer than most.
> 
> I guess a big blocker for such a real mips multiplatform kernel is
> that there is still no defined (standard) interface for passing a
> device tree to the kernel from the bootlader on mips, unlike on arm
> (at least I'm not aware of any).

There are a few things to be worked out, I don't think this one is
particularly hard. Looking through the list of public symbols:

* arch/mips/bmips/dma.c, 
  arch/mips/include/asm/mach-bmips/dma-coherence.h:
plat_map_dma_mem
plat_map_dma_mem_page
plat_dma_addr_to_phys
plat_unmap_dma_mem

This should really be done in a generic way: What Kevin's patch
does here is to hardcode a mapping of DMA addresses. We have a way
to express this in DT in a generic manner, using the dma-ranges
property (currently not parsed completely on ARM yet, working on
it, but we don't have that many special cases on modern platforms).
Once you have the correct dma-ranges set and the code parses them
properly, the bmips specific code could just go away, and someone
has to do this already to support the ARM based bcm platforms I
suspect.

*arch/mips/bmips/irq.c:
get_c0_compare_int
arch_init_irq

I don't completely understand this code, but I think once the irqchips
all use irqdomains correctly and the code is moved to drivers/irqchip,
this can also go away. There is already code to override
get_c0_compare_int().


* arch/mips/include/asm/mach-bmips/war.h

Very few platforms actually set any of the workarounds, so I guess the
file setting them all to zero could just be moved to
arch/mips/include/asm/mach-generic/.

prom_init
prom_free_prom_memory
get_system_type
plat_time_init
find_dtb
plat_mem_setup
device_tree_init
plat_of_setup
plat_dev_init

This is not just DT, it's actually an implementation of a boot
interface. The situation here seems much more to what we had on
PowerPC a long time ago than what we had on ARM before the DT
conversion. I think the best approach here would be to move the
platform specific bits into the decompressor code, and allow
multiple implementations of that. This way you can have the
generic vmlinux file that has a common DT parser, and you wrap
that into one decompressor per platform, some of which can have
their own board detection logic or pre-boot setup where necessary.

To be honest, I think having multiple DT files linked into the
kernel is a really bad idea, because it doesn't solve the
scalability problem at all. What we did on ARM was to force those
hacks out into external projects such as the PXA impedence
matcher [https://github.com/zonque/pxa-impedance-matcher]. This
can handle all weird boot protocol and adapt them to the normal
well-defined interfaces we have in the kernel.

> And unless there is one, having a
> multiplatform kernel does not make much sense, as there is no sane way
> to tell apart different platforms on boot.

How do you normally tell boards apart on MIPS when you don't use DT?

	Arnd
