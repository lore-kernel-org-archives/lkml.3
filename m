Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaKQRBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:01:25 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58699 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaKQRBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:01:23 -0500
MIME-Version: 1.0
In-Reply-To: <3480616.V2TMJFc7uE@wuerfel>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <50587083.ieLlCR4VrM@wuerfel> <CAJiQ=7C-HniwXiVrqQg3cnFNNYGwoxHJf8JP-XYOqM1yWoyXaw@mail.gmail.com>
 <3480616.V2TMJFc7uE@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 17 Nov 2014 09:01:02 -0800
Message-ID: <CAJiQ=7A29-v5mo1ybvE2UodOZx-FoGeBTHYcTZuX-LaqRaF1Lw@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, dtor@chromium.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 4:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > It's probably not a wrong description here, but for anybody reading this
>> > who also works on ARM, it seems rather confusing because there,
>> > "multiplatform" implies that the particular SoC can be built into a
>> > generic kernel image that supports SoCs from any vendor whose platform
>> > is also marked as "multiplatform", as long as the CPU architecture level
>> > (v4/v5, or v6/v7, or v8) is the same.
>>
>> The BMIPS multiplatform kernel is intended to support any SoC based on
>> a 65nm/40nm/28nm BMIPS CPU.  Strictly speaking, "BMIPS" isn't an
>> architecture level defined by imgtec, nor is it something that other
>> silicon vendors can currently offer.  But the BMIPS CPUs do have their
>> own unique CP0 registers, DSP instruction set, errata, and ways of
>> handling SMP / cache maintenance / performance counters.
>
> Ok, I see. It looks like you can have a combined kernel that runs on
> BMIPS BCM47xx and MIPS32r2 74K BCM47xx already, right?

Under arch/mips/bcm47xx I see a single mach type, but different builds
for BMIPS3300 (R1/SSB) versus MIPS 74K (R2/BCMA).

> So it's not fundamentally incompatible with the other platforms?

Relative to BMIPS43xx/BMIPS5x00, the BMIPS3300 CPU found in the older
BCM47xx chips requires fewer quirks and can be treated more like a
standard R4K by the OS:

 - No SMP boot/IPI helpers are needed
 - Cache maintenance is pretty straightforward (but some chips do have the RAC)
 - No L2 or HW cache de-aliasing logic or weird instruction barriers
 - No XI/ROR support
 - Don't know about errata (BCM47xx uses the old 130nm/180nm cores)

OTOH, performance counters and DSP instructions are totally different
from the imgtec cores.  Older BMIPS3300 instances have system
registers squatting in the middle of the default FIXMAP region.

Many of the early BMIPS3300 Linux ports just selected
CONFIG_CPU_MIPS32_R1 and gradually hacked in support for
BMIPS-specific features.

But I haven't seen precedent for a kernel supporting
BMIPS43xx/BMIPS5000 + other non-BMIPS CPUs in the same build.  Maybe
it's possible; we would want to look at the current and future cases
where BMIPS gets special treatment.  grepping through the tree I see
hazard barriers, exception vectors (most of which are figured out at
runtime now), and performance events.  Also, things like FIXADDR_TOP
and <war.h> are compile-time options.

Historically, the "XKS01" kseg0/kseg1 remapping feature has also been
tricky, and might not be supportable at all in a multiplatform build.

>> Outside of the CPU, the BCM63xx/BCM33xx/BCM7xxx register maps and
>> peripherals look pretty different, and the arch/mips/bmips code makes
>> almost zero assumptions about the rest of the chip if a DTB is passed
>> in from the bootloader.  In this sense you can see the parallels to
>> CONFIG_ARCH_MULTI_Vx.
>>
>> Prior to this work, these product lines have never been able to share
>> a common kernel image.
>
> I still think this is different in the sense that ARM multiplatform
> support is about combining platforms from separate mach-* directories,
> while your approach was to rewrite multiple mach-* directories into
> a single new one that remains separate from the others.

There is at least one out-of-tree kernel for each of:

arch/mips/bcm9338x
arch/mips/bcm963xx (which predates arch/mips/bcm63xx)
arch/mips/brcmstb

each of which was implementing and maintaining the same
CPU/SMP/cache/IRQ support a little bit differently.

The femtocell chips (BCM61xxx) may or may not have their own tree as
well - need to check.  Plus, here in mainline, we currently have an
arch/mips/bcm63xx tree supporting a different (usually older) subset
of BCM63xx chipsets.

It would be nice if we could identify the BMIPS chips that are still
actively used, and support them all with one mach type instead of 4+.
There might still be a few special cases but I suspect that several of
the extra mach directories can be eliminated.

> While this is
> a great improvement, it doesn't get you any closer to having a
> combined BMIPS+RALINK+JZ4740+ATH79 kernel for instance. I don't know
> if such a kernel is something that anybody wants, or if it's even
> technically possible.

Correct, that isn't the goal for now.

Given the differences between BMIPS and imgtec MIPS, it is possible
that making such a multiplatform kernel would be the equivalent of
making a single image that runs on ARMv5 + ARMv7.  We may want to
assess the tradeoffs at some point.

It is possible that a multiplatform BMIPS kernel may run fine on
reasonably simple non-BMIPS hardware, but that other hardware (e.g.
supporting SMP, system PM states, or more complicated caches) would
require a dedicated build.

> If you wanted to do that however, starting with BMIPS you'd have
> to make it possible to define a new platform without the
> arch/mips/include/asm/mach-bmips/ directory (this should be possible
> already, so the hardest part is done), replace all global function
> calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
> platform-independent implementations or wrappers around per-platform
> callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
> outside of the "System type" choice statement.

Right.  The other question is how much support for legacy non-DT
bootloaders really belongs in a true multiplatform kernel, as this
stuff gets hairy fast.
