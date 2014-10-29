Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaJ2Iqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:46:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59946 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaJ2Iqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:46:40 -0400
Date: Wed, 29 Oct 2014 09:46:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Nokia n900 problems in 3.18-rc1 (was Re: USB Ethernet gadget on
 Nokia n900)
Message-ID: <20141029084637.GA30662@amd>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
 <20141027223114.GU2560@atomide.com>
 <20141028220450.GA27667@amd>
 <20141028221124.GT2542@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028221124.GT2542@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Here's a patch that should fix the issues for built-in USB
> > > gadgets.
> > > 
> > > Pavel, care to see if this gets NFSroot over USB working again
> > > for you?
> > 
> > It seems to have did the trick for me. (Plus I needed to add
> > 
> > +CONFIG_ARM_ATAG_DTB_COMPAT=y
> > +CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
> > +# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is not set
> > 
> > to be able to control the command line, that's why testing took me a
> > while.)
> 
> Hmm I think I have a patch somewhere here to enable the standard
> bootz command for n900 mainline u-boot.. That way you can just do
> 
> # bootz ${loadaddr} - ${fdtaddr}

Actually, I guess booting directly from ROM using 0xffff is easier for
testing for now.

Speaking of testing:

I'm not sure what is omap_l3_smx neccessary for, but it does not work.

[    0.223297] omap_l3_smx omap_l3_smx.0: couldn't request debug irq
[    0.223419] omap_l3_smx: probe of omap_l3_smx.0 failed with error
-22

There is some fun in pinmuxing:

[    0.247131] irq: no irq domain found for /ocp/pinmux@48002030 !
[    0.248291] irq: no irq domain found for /ocp/pinmux@48002030 !
...
[    0.384826] omap_i2c 48070000.i2c: could not find pctldev for node
/ocp/pinmux@48002030/pinmux_i\
2c1_pins, deferring probe
[    0.384918] platform 48070000.i2c: Driver omap_i2c requests probe
deferral
[    0.385070] omap_i2c 48072000.i2c: could not find pctldev for node
/ocp/pinmux@48002030/pinmux_i\
2c2_pins, deferring probe
[    0.385162] platform 48072000.i2c: Driver omap_i2c requests probe
deferral
[    0.385284] omap_i2c 48060000.i2c: could not find pctldev for node
/ocp/pinmux@48002030/pinmux_i\
2c3_pins, deferring probe
[    0.385375] platform 48060000.i2c: Driver omap_i2c requests probe
deferral

And serial has some problems:

[    0.482208] of_get_named_gpiod_flags: can't parse 'rts-gpio'
property of node '/ocp/serial@4806c\
000[0]'
[    0.482513] omap_uart 4806c000.serial: ttyO1 at MMIO 0x4806c000
(irq = 223, base_baud = 3000000)\
 is a OMAP UART1
[    0.484588] of_get_named_gpiod_flags: can't parse 'rts-gpio'
property of node '/ocp/serial@49020\
000[0]'
[    0.484771] omap_uart 49020000.serial: ttyO2 at MMIO 0x49020000
(irq = 224, base_baud = 3000000)\
 is a OMAP UART2

There's a lot of noise from probe defferal :-(. And it looks like mmc
properties have some problems:

[    0.739349] of_get_named_gpiod_flags: can't parse 'wp-gpios'
property of node '/ocp/mmc@4809c000\
[0]'
[    0.740142] omap_hsmmc 4809c000.mmc: unable to get vmmc regulator
-517
[    0.740386] platform 4809c000.mmc: Driver omap_hsmmc requests probe
deferral
[    0.740661] of_get_named_gpiod_flags: can't parse 'cd-gpios'
property of node '/ocp/mmc@480b4000\
[0]'
[    0.740692] of_get_named_gpiod_flags: can't parse 'wp-gpios'
property of node '/ocp/mmc@480b4000\
[0]'

omapfb reports problems, but seems to work ok:

[    0.990386] omapfb omapfb: cannot parse default modes
[    1.004791] Console: switching to colour frame buffer device 100x30
[    1.073150] omapfb omapfb: using display 'lcd' mode 800x480

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
