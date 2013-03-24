Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3CXOMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:12:10 -0400
Received: from norkia.v3.sk ([91.210.183.14]:58426 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab3CXOMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:12:08 -0400
Subject: Re: [PATCH] watchdog: Add Broadcom BCM2708 watchdog timer driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
In-Reply-To: <514D1273.8070902@wwwdotorg.org>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
	 <514D1273.8070902@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Mar 2013 15:12:04 +0100
Message-ID: <1364134324.2906.8.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 20:24 -0600, Stephen Warren wrote:

Thank you for your response!

> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
> > Signed-off-by: Lubomir Rintel <lkundrak at v3.sk>
> 
> A commit description would be useful.

I'll add a more descriptive one in next patch revision.

> >  arch/arm/configs/bcm2835_defconfig |    4 +
> >  drivers/watchdog/Kconfig           |   11 +++
> >  drivers/watchdog/Makefile          |    1 +
> >  drivers/watchdog/bcm2835_wdt.c     |  158 ++++++++++++++++++++++++++++++++++++
> 
> The changes to bcm2835_defconfig should be a separate patch, since they
> would be applied in the BCM2835 ARM sub-arch tree, whereas the driver
> patch would be applied to the watchdog driver tree.

Okay, makes sense to me.

> > diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
> 
> > +CONFIG_BCM2835_WDT=y
> > +
> >  CONFIG_MMC=y
> 
> That blank line is a little odd; was this defconfig change created using
> "make savedefconfig"?

No, I did not notice that the savedefconfig exists and modified the defconfig 
by hand. I'll use it for next patch revision.

> > diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
> 
> > +static int heartbeat = -1;
> > +static bool nowayout = WATCHDOG_NOWAYOUT;
> > +static void __iomem *wdt_regs;
> > +static DEFINE_SPINLOCK(wdog_lock);
> 
> Can these be stored in a dynamically-allocated structure, stored in the
> device's drvdata?

Well, not hearbeat and nowayout, those are module parameters.

The other ones make perfect sense, I've attempted to use a per-device 
dynamically-allocated structure for those.

> > +static struct platform_driver bcm2835_wdt_driver = {
> ...
> > +};
> > +
> > +module_platform_driver(bcm2835_wdt_driver);
> 
> I believe it's typical not to leave a blank line before
> module_platform_driver();

Okay.

> A couple of general comments:
> 
> 1)
> 
> This driver touches the same registers that
> arch/arm/mach-bcm2835/bcm2835.c uses to implement reboot and "power
> off". Some co-ordination might be necessary.
> 
> The implementation of bcm2835_power_off() could easily be moved into
> this driver, to avoid some of the need for co-ordination.
> 
> Moving bcm2835_restart() would be more tricky, since the ARM machine
> descriptor needs a pointer to that function. I guess the kernel probably
> ensures that none of the code in this watchdog driver is running by the
> time bcm2835_restart() is called, although perhaps it'd be better to
> have mach-bcm2835/bcm2835.c and this driver share a lock?

I need help here, I'm not sure what's the proper way to address this
(whether to include the actual reboot code in the wdt driver or the
platform driver).

Is it okay to have the platform driver depend on watchdog timer?
Is it okay for the platform driver not to reboot properly if the kernel
is running without the wdt driver loaded?

(For now, I'll send a revised patch addressing the other issues so that
it can be reviewed without addressing this yet.)

> 2)
> 
> I'm curious where you got the documentation to write this driver; this
> HW module isn't described in BCM2835-ARM-Peripherals.pdf. I assume this
> is based on the downstream kernel driver? If so, at least some credit in
> the commit description might be appropriate. At least the relevant
> commit downstream already has an appropriate Signed-off-by line:-)

Your guess is right, used bcm2708_wdog driver from rpi-3.6.y as a reference. 
I'll add that information to the commit message.

The Signed-off-by line is indeed present, but unfortunately does not seem to be 
particularly appropriate:

Signed-off-by: popcornmix <popcornmix@gmail.com>

I'm wondering if it's actually relevant, since the useful bits of the 
downstream driver boil down to macro defines.

Have a nice day!

-- 
Lubomir Rintel <lkundrak@v3.sk>

