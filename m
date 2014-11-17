Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaKQV53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:57:29 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54103 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKQV52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <2622492.TiaF5tO0a3@wuerfel>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <14461008.6cZzGdpat2@wuerfel> <CAJiQ=7CmFNhufdeoeH_6SuYOhf3Luwc2zwy_+8au1V8RW78rOw@mail.gmail.com>
 <2622492.TiaF5tO0a3@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 17 Nov 2014 13:57:07 -0800
Message-ID: <CAJiQ=7AhyAyN6Hnvtdowdh6oPknbPFMe-_PrPdzyCGe5H7eE1g@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Gorski <jogo@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> This mostly depends on the desired feature set, and the delta from one
>> board to the next.  Many of the reference board sections are largely
>> copied from a working design, but sometimes there are changes that
>> affect us.  Other times there are tweaks that can be autodetected,
>> like a different flash chip.
>>
>> The analog interfaces like SATA/USB/Ethernet don't tend to vary all
>> that much (although some may be missing ports on the board, or
>> disabled on the chip).
>>
>> The pin muxing situation leaves a lot of room for board differences,
>> and on these platforms it isn't really handled in a central place.
>> This gets even more challenging when combined with some of the power
>> management requirements.
>>
>> The peripherals that I added in my patch submission are among the
>> easiest / safest of the bunch.
>
> Right, that is exactly the danger: it's easy to get the basics working
> like this, but the differences between SoCs are not what we need DT
> for anyway, those are easily abstracted in kernel code if necessary,
> hardcoded by some soc version identifier.

That depends on how many SoC's we're talking about...

On MIPS we have literally dozens.  Most of the "building blocks" are
pretty similar, but the MMIO addresses, IRQ mappings, and
quantity/revision of each peripheral vary.  DT is ideal for
representing these differences and for rapidly bringing up a new
system.

> What you end up with in your approach is a kernel that can support
> multiple SoCs but only some boards per SoC, and otherwise you still
> depend on compile-time configuration.

Agreed, but for legacy platforms this is somewhat inevitable.  These
systems are already in production so there is no manpower available to
go back and test every single one-off board.  It is most likely that a
small subset of "interesting" boards will receive the best support.
For instance, I see an arch/arm/boot/dts/bcm2835-rpi-b.dts, but that's
hardly the only BCM2835-based platform found in the wild.

The limited board support doesn't negate the value of having a generic
BMIPS kernel available upstream; this build still eliminates
duplicated efforts on many of the basic items (CPU/SMP/caching, IRQ
controllers, UART).  It also allows easy reuse of DT-ready peripherals
that are common to the CM/DSL/STB MIPS and ARM chips, which was the
original goal of the BCM3384 port.

Going forward I would expect that with this build available in
mainline, it will open up new opportunities for modernizing the
bootloaders on each product line.

> Aside from pin configuration,
> you have to have a per-board dtb file if you have any i2c or spi
> connected components, PCI devices with custom interrupt lines,
> LEDs, GPIO buttons, or anything else on a nondiscoverable bus.

Correct.

For better or for worse, most of these don't use Linux kernel drivers on STB.
