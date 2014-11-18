Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaKRKPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:15:38 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51466 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaKRKPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:15:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Jonas Gorski <jogo@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Tue, 18 Nov 2014 11:15:24 +0100
Message-ID: <5313988.cGSDdqXOcS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7AhyAyN6Hnvtdowdh6oPknbPFMe-_PrPdzyCGe5H7eE1g@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <2622492.TiaF5tO0a3@wuerfel> <CAJiQ=7AhyAyN6Hnvtdowdh6oPknbPFMe-_PrPdzyCGe5H7eE1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1thIjnUvqVvAGrnD0PRGq0QkTdo+JMIbOCFjFz4PKi4
 erknqEejbnwaiYuAUFsNwzAM5PShP8oCqL5znf4HGpGMR2QUcq
 7Rj/eQWeGCTJ4I/mGUEpWETp4SaIfAJZRgTTpv1kZn4pdwppU/
 sXjHqUfBJI/3cQ/I1JtDac6Xf5xNnXKlkXD8R66452NxeqxTcp
 hw5Pc4RiYqbBL/xhYXYyuQveQZiFK4ND4PLpCd/poRR1oNWOuZ
 lbKgN23lGoNNIxwWvDQEsjG0q7RhisayGFxQGpYy4t2km2taog
 OPziJHJ/pyAGJKSi/gf5mOcU7pDftzCG1PnjLE2EAz8bJob/Tb
 kPhxJ56XvftbDyOH4SMo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 13:57:07 Kevin Cernekee wrote:
> On Mon, Nov 17, 2014 at 12:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> This mostly depends on the desired feature set, and the delta from one
> >> board to the next.  Many of the reference board sections are largely
> >> copied from a working design, but sometimes there are changes that
> >> affect us.  Other times there are tweaks that can be autodetected,
> >> like a different flash chip.
> >>
> >> The analog interfaces like SATA/USB/Ethernet don't tend to vary all
> >> that much (although some may be missing ports on the board, or
> >> disabled on the chip).
> >>
> >> The pin muxing situation leaves a lot of room for board differences,
> >> and on these platforms it isn't really handled in a central place.
> >> This gets even more challenging when combined with some of the power
> >> management requirements.
> >>
> >> The peripherals that I added in my patch submission are among the
> >> easiest / safest of the bunch.
> >
> > Right, that is exactly the danger: it's easy to get the basics working
> > like this, but the differences between SoCs are not what we need DT
> > for anyway, those are easily abstracted in kernel code if necessary,
> > hardcoded by some soc version identifier.
> 
> That depends on how many SoC's we're talking about...
> 
> On MIPS we have literally dozens.  Most of the "building blocks" are
> pretty similar, but the MMIO addresses, IRQ mappings, and
> quantity/revision of each peripheral vary.  DT is ideal for
> representing these differences and for rapidly bringing up a new
> system.

Of course you can abstract SoCs using DT, and we do that all the time
now on a lot of architectures. My point is that it's possible to abstract
a board using DT without also describing the SoC in detail, but you
cannot do the reverse.

> > What you end up with in your approach is a kernel that can support
> > multiple SoCs but only some boards per SoC, and otherwise you still
> > depend on compile-time configuration.
> 
> Agreed, but for legacy platforms this is somewhat inevitable.  These
> systems are already in production so there is no manpower available to
> go back and test every single one-off board.  It is most likely that a
> small subset of "interesting" boards will receive the best support.
> For instance, I see an arch/arm/boot/dts/bcm2835-rpi-b.dts, but that's
> hardly the only BCM2835-based platform found in the wild.

It's absolutely ok to not have the dts files for each board, and to
not test all combinations, those can always come later if anyone is
interested in it.

The one thing I believe you shouldn't do is hardwire a dtb file to
an SoC specific identifier, because that makes it impossible to
support other boards that need additional DT nodes using the same
boot method. Using a single appended dtb file instead of the built-in
lookup table would solve this well enough.

> The limited board support doesn't negate the value of having a generic
> BMIPS kernel available upstream; this build still eliminates
> duplicated efforts on many of the basic items (CPU/SMP/caching, IRQ
> controllers, UART).  It also allows easy reuse of DT-ready peripherals
> that are common to the CM/DSL/STB MIPS and ARM chips, which was the
> original goal of the BCM3384 port.
> 
> Going forward I would expect that with this build available in
> mainline, it will open up new opportunities for modernizing the
> bootloaders on each product line.

Yes, this is all good. 

	Arnd
