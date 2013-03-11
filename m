Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3CKSHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:07:09 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:37472 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3CKSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:07:05 -0400
Date: Mon, 11 Mar 2013 19:06:11 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 3/3] ARM: at91: fix hanged boot
Message-ID: <20130311180611.GF8797@localhost>
References: <1362747103-21445-1-git-send-email-jhovold@gmail.com>
 <1362747103-21445-4-git-send-email-jhovold@gmail.com>
 <20130308160258.GD4590@game.jcrosoft.org>
 <20130311100243.GD8797@localhost>
 <20130311110637.GG4590@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311110637.GG4590@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:06:37PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:02 Mon 11 Mar     , Johan Hovold wrote:
> > On Fri, Mar 08, 2013 at 05:02:58PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > On 13:51 Fri 08 Mar     , Johan Hovold wrote:
> > > > Make sure the RTC and RTT-interrupts are masked at boot by adding a new
> > > > SOC-initialiser and helpers functions.
> > > > 
> > > > This fixes hanged boot on all AT91 SOCs but RM9200, for example, after a
> > > > reset during an RTC-update or if an RTC or RTT-alarm goes off after a
> > > > non-clean shutdown.
> > > > 
> > > > The RTC and RTT-peripherals are powered by backup power (VDDBU) (on all
> > > > AT91 SOCs but RM9200) and are not reset on wake-up, user, watchdog or
> > > > software reset. This means that their interrupts may be enabled during
> > > > early boot if, for example, they where not disabled during a previous
> > > > shutdown (e.g. due to a buggy driver or a non-clean shutdown such as a
> > > > user reset). Furthermore, an RTC or RTT-alarm may also be active.
> > > > 
> > > > The RTC and RTT-interrupts use the shared system-interrupt line, and if
> > > > an interrupt occurs before a handler (e.g. RTC-driver) has been
> > > > installed this leads to the system interrupt being disabled and prevents
> > > > the system from booting.
> > > > 
> > > > Note that when boot hangs due to an early RTC or RTT-interrupt, the only
> > > > way to get the system to start again is to remove the backup power (e.g.
> > > > battery) or to disable the interrupt manually from the bootloader. In
> > > > particular, a user reset is not sufficient.
> > > > 
> > > > Tested on at91sam9263 and at91sam9g45.
> > > > 
> > > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > > ---
> > > >  arch/arm/mach-at91/at91rm9200.c               |  9 ++++++++
> > > >  arch/arm/mach-at91/at91sam9260.c              |  6 ++++++
> > > >  arch/arm/mach-at91/at91sam9261.c              |  6 ++++++
> > > >  arch/arm/mach-at91/at91sam9263.c              |  7 ++++++
> > > >  arch/arm/mach-at91/at91sam9g45.c              |  7 ++++++
> > > >  arch/arm/mach-at91/at91sam9n12.c              |  6 ++++++
> > > >  arch/arm/mach-at91/at91sam9rl.c               |  7 ++++++
> > > >  arch/arm/mach-at91/at91sam9x5.c               |  6 ++++++
> > > >  arch/arm/mach-at91/generic.h                  |  2 ++
> > > >  arch/arm/mach-at91/include/mach/at91sam9n12.h |  5 +++++
> > > >  arch/arm/mach-at91/include/mach/at91sam9x5.h  |  5 +++++
> > > nack for DT probe te address via DT
> > 
> > Fair enough. I'll respin and add proper DT-support. 
> > 
> > > >  arch/arm/mach-at91/setup.c                    | 31 +++++++++++++++++++++++++++
> > > >  arch/arm/mach-at91/soc.h                      |  1 +
> > > >  13 files changed, 98 insertions(+)
> > > 
> > > at boot time we can disable all the irq as we need none of them
> > 
> > Yes, but all but the VDDBU-powered-peripheral ones will already have
> > been disabled at reset. If a buggy bootloader enables something it
> > should not, then the bootloader should be fixed.
> so fix the bootloader NACK in the kernel

If it had been enabled by the bootloader, it would no doubt be a
bootloader bug. The problem is that bootloader may not know anything
about RTT/RTC and it was Linux that enabled the interrupts in the first
place. The question is whether it should still be the bootloader's
responsibility to clean it up.

> it's too much ugly

Agreed, but this needs to be fixed somewhere.

> the kernel requirere the interrupt to be disabled

And this is the problem -- the interrupts _are_ disabled when the kernel
is executed. It is Linux that enables the system interrupt without
making sure it can handle the interrupts that could arrive.

But sure, I can see arguments in favor of either solution (fix in
bootloader or kernel).

It is a severe bug, which affects all AT91 systems (but RM9200). It's
fairly hard to track down, and this has apparently already been done
over and over again. In my opinion, fixing it once and for all in the
kernel has some appeal.

To give an idea of what it could look like, I'm responding to this mail
with with a v2 of my series with added DT-support (the DT-bits are
compile-only tested).

Thanks,
Johan
