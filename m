Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3CKNGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:06:07 -0400
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:39114 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948Ab3CKNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:06:05 -0400
Date: Mon, 11 Mar 2013 12:06:37 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: rtc-linux@googlegroups.com
Cc: Johan Hovold <jhovold@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [rtc-linux] [PATCH 3/3] ARM: at91: fix hanged boot
Message-ID: <20130311110637.GG4590@game.jcrosoft.org>
References: <1362747103-21445-1-git-send-email-jhovold@gmail.com>
 <1362747103-21445-4-git-send-email-jhovold@gmail.com>
 <20130308160258.GD4590@game.jcrosoft.org>
 <20130311100243.GD8797@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311100243.GD8797@localhost>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13527968856921189297
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:02 Mon 11 Mar     , Johan Hovold wrote:
> On Fri, Mar 08, 2013 at 05:02:58PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 13:51 Fri 08 Mar     , Johan Hovold wrote:
> > > Make sure the RTC and RTT-interrupts are masked at boot by adding a new
> > > SOC-initialiser and helpers functions.
> > > 
> > > This fixes hanged boot on all AT91 SOCs but RM9200, for example, after a
> > > reset during an RTC-update or if an RTC or RTT-alarm goes off after a
> > > non-clean shutdown.
> > > 
> > > The RTC and RTT-peripherals are powered by backup power (VDDBU) (on all
> > > AT91 SOCs but RM9200) and are not reset on wake-up, user, watchdog or
> > > software reset. This means that their interrupts may be enabled during
> > > early boot if, for example, they where not disabled during a previous
> > > shutdown (e.g. due to a buggy driver or a non-clean shutdown such as a
> > > user reset). Furthermore, an RTC or RTT-alarm may also be active.
> > > 
> > > The RTC and RTT-interrupts use the shared system-interrupt line, and if
> > > an interrupt occurs before a handler (e.g. RTC-driver) has been
> > > installed this leads to the system interrupt being disabled and prevents
> > > the system from booting.
> > > 
> > > Note that when boot hangs due to an early RTC or RTT-interrupt, the only
> > > way to get the system to start again is to remove the backup power (e.g.
> > > battery) or to disable the interrupt manually from the bootloader. In
> > > particular, a user reset is not sufficient.
> > > 
> > > Tested on at91sam9263 and at91sam9g45.
> > > 
> > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > ---
> > >  arch/arm/mach-at91/at91rm9200.c               |  9 ++++++++
> > >  arch/arm/mach-at91/at91sam9260.c              |  6 ++++++
> > >  arch/arm/mach-at91/at91sam9261.c              |  6 ++++++
> > >  arch/arm/mach-at91/at91sam9263.c              |  7 ++++++
> > >  arch/arm/mach-at91/at91sam9g45.c              |  7 ++++++
> > >  arch/arm/mach-at91/at91sam9n12.c              |  6 ++++++
> > >  arch/arm/mach-at91/at91sam9rl.c               |  7 ++++++
> > >  arch/arm/mach-at91/at91sam9x5.c               |  6 ++++++
> > >  arch/arm/mach-at91/generic.h                  |  2 ++
> > >  arch/arm/mach-at91/include/mach/at91sam9n12.h |  5 +++++
> > >  arch/arm/mach-at91/include/mach/at91sam9x5.h  |  5 +++++
> > nack for DT probe te address via DT
> 
> Fair enough. I'll respin and add proper DT-support. 
> 
> > >  arch/arm/mach-at91/setup.c                    | 31 +++++++++++++++++++++++++++
> > >  arch/arm/mach-at91/soc.h                      |  1 +
> > >  13 files changed, 98 insertions(+)
> > 
> > at boot time we can disable all the irq as we need none of them
> 
> Yes, but all but the VDDBU-powered-peripheral ones will already have
> been disabled at reset. If a buggy bootloader enables something it
> should not, then the bootloader should be fixed.
so fix the bootloader NACK in the kernel
it's too much ugly

the kernel requirere the interrupt to be disabled

Best Regards,
J.
