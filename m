Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3FZEng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:43:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:25910 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3FZEnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="360588299"
Message-ID: <1372221808.8177.52.camel@envy.home>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Olof Johansson <olof@lixom.net>, "David S. Miller" <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>
Date: Tue, 25 Jun 2013 21:43:28 -0700
In-Reply-To: <20130626040026.GA23621@quad.lixom.net>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <20130626040026.GA23621@quad.lixom.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 21:00 -0700, Olof Johansson wrote:
> Hi,

Hey Olof, thanks for the review!

David M, search for "minnow_phy_reset" for your bit :-)

> 
> On Tue, Jun 25, 2013 at 06:53:24PM -0700, Darren Hart wrote:
> > The MinnowBoard (http://www.minnowboard.org) is an Intel Atom (E6xx) plus EG20T
> > PCH development board. It uses a few GPIO lines for specific purposes and
> > exposes the rest to the user.
> > 
> > Request the dedicated GPIO lines:
> > 	HWID
> > 	LVDS_DETECT
> > 	PHY_RESET
> > 	LED0
> > 	LED1
> > 
> > Setup platform drivers for the MinnowBoard LEDs using the leds-gpio
> > driver. Setup led0 and led1 with heartbeat and mmc0 default triggers
> > respectively.
> > 
> > GPIO lines SUS[0-4] are dual purpose, either for LVDS signaling or as
> > user GPIO. Determine which via the LVDS_DETECT signal and enable or
> > disable them accordingly.
> > 
> > Provide a minimal public interface:
> > 	minnow_detect()
> > 	minnow_lvds_detect()
> > 	minnow_hwid()
> > 	minnow_phy_reset()
> > 
> > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> > Cc: Matthew Garrett <matthew.garrett@nebula.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: platform-driver-x86@vger.kernel.org
> > ---
> >  drivers/platform/x86/Kconfig            |  20 ++++
> >  drivers/platform/x86/Makefile           |   1 +
> >  drivers/platform/x86/minnowboard-gpio.h |  60 ++++++++++
> >  drivers/platform/x86/minnowboard.c      | 193 ++++++++++++++++++++++++++++++++
> >  include/linux/minnowboard.h             |  37 ++++++
> >  5 files changed, 311 insertions(+)
> >  create mode 100644 drivers/platform/x86/minnowboard-gpio.h
> >  create mode 100644 drivers/platform/x86/minnowboard.c
> >  create mode 100644 include/linux/minnowboard.h
> 
> Hmmmm. x86 boardfiles arriving under drivers/platform. 


Indeed, I hate myself for this :-)

Here was my rationale, feel free to pick it apart:

1) I need time, possibly a couple of months, to get proper ACPI support
for these drivers into the firmware. Then I can rewrite these as ACPI
drivers as is proper for an x86 board. I've already started down this
path.

2) I felt the value of getting something upstream, even if it isn't
perfect, before the board ships was preferable to only having it in
what is effectively a vendor tree (linux-yocto_3.8 standard/minnow) and
risking various other implementations popping up and confusing the
situation.

3) I at least wanted to fix the pch_gbe support which is currently tied
up with these platform drivers. I considered pushing the
minnow_phy_reset into pch_gbe, but I previously was scolded for putting
too much board-specific knowledge into that driver.


> The main concern is that this won't really scale if more vendors add
> variations of this board -- needing code changes for each and every one
> of them. Given that it's an open platform encouraging derivatives, that seems
> like a slippery slope.


+100000


> It's really unfortunate that this information couldn't be passed in from
> firmware. We've been working so hard for so long on ARM now to move away
> from board files, it's such a pity to add them on another major platform.


Nod, see above. If this trumps the rationale above, it might just make
sense to push the phy reset into the pch_gbe driver and hold off on
these. Alternatively, we can choose to accept that this is transitional
with the understanding that drivers/platform/x86/minnow* *will* go
away.


> > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > index 8577261..154dbf6 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -15,6 +15,26 @@ menuconfig X86_PLATFORM_DEVICES
> >  
> >  if X86_PLATFORM_DEVICES
> >  
> > +config MINNOWBOARD
> > +	tristate "MinnowBoard GPIO and LVDS support"
> > +	depends on LPC_SCH
> > +	depends on GPIO_SCH
> > +	depends on GPIO_PCH
> > +	depends on LEDS_GPIO
> > +	default n
> 
> No need to default n. 'n' is the default default. :)


Check. Thanks.

...

> > +#define GPIO_PCH0 244
> > +#define GPIO_PCH1 245
> > +#define GPIO_PCH2 246
> > +#define GPIO_PCH3 247
> > +#define GPIO_PCH4 248
> > +#define GPIO_PCH5 249
> > +#define GPIO_PCH6 250
> > +#define GPIO_PCH7 251
> > +
> > +#define GPIO_HWID0 252
> > +#define GPIO_HWID1 253
> > +#define GPIO_HWID2 254
> > +
> > +#define GPIO_LVDS_DETECT 255
> 
> It looks like at least gpio-pch.c uses dynamic gpio numbers, which makes it
> hard to define these as static numbers since they might move around depending
> on module load order, etc.


Oh dear, not something I've experienced. OK, I'll go look into how to
properly handle that case. Any pointers?

...

> > +int minnow_hwid(void)
> > +{
> > +	/* This should never be called prior to minnow_init_module() */
> > +	WARN_ON_ONCE(minnow_hwid_val == -1);
> > +	return minnow_hwid_val;
> > +}
> > +EXPORT_SYMBOL_GPL(minnow_hwid);
> 
> I don't see this used anywhere, so it's hard to tell what the expected use is.
> I'd just remove it until first user comes along.


OK, can do.


> > +bool minnow_detect(void)
> > +{
> > +	const char *cmp;
> > +
> > +	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> > +	if (cmp && strstr(cmp, "MinnowBoard"))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +EXPORT_SYMBOL_GPL(minnow_detect);
> >
> > +bool minnow_lvds_detect(void)
> > +{
> > +	return !!gpio_get_value(GPIO_LVDS_DETECT);
> > +}
> > +EXPORT_SYMBOL_GPL(minnow_lvds_detect);
> 
> These two are only used in the other subfiles.
> 
> The scope of those files are really narrow, and you end up exporting a set of
> global functions for it. I suggest you just bake them all together -- there's
> a small amount of flexibility lost w.r.t. keeping some as modules and others
> built-in, but the code isn't very large.


I had them together initially. The reason I broke them up was to
separate fixed functionality from example code. minnowboard.c sets up
the API and any fixed things, like the GPIO LEDs. Those can be easily
configured through LED triggers, so no need to allow for a different
kind of driver.

minnowboard-gpio.c provides easy user access to the GPIO, but would
conflict with a properly written driver for a device driven with the
GPIO. This one is for prototyping and experimentation, but shouldn't be
considered as a "permanent" driver like minnowboard.c is.

minnowboard-keys.c is example code and could possibly be considered a
"permanent" driver once the ACPI version makes it a bit more
configurable by specifying the key codes and such outside the kernel
driver.

minnow_detect() can be replaced with DMI_MATCH() anywhere, so perhaps
this should just go away once the drivers are ACPI'ified.

minnow_lvds_detect().... that's a long story. I only really need it in
minnowboard-gpio.c to make sure I only export the GPIO if they are not
being used for LVDS. I could move it to that driver and remove the
export altogether.


> 
> > +void minnow_phy_reset(void)
> > +{
> > +	/*
> > +	 * Hold reset for a little over 1ms and allow some time after to ensure
> > +	 * the PHY has fully woken up.
> > +	 */
> > +	gpio_set_value(GPIO_PHY_RESET, 0);
> > +	usleep_range(1250, 1500);
> > +	gpio_set_value(GPIO_PHY_RESET, 1);
> > +	usleep_range(1250, 1500);
> > +}
> > +EXPORT_SYMBOL_GPL(minnow_phy_reset);
> 
> What phy? USB? SATA? Ethernet?

Ethernet, yes.

> 
> I wonder if you'd be better off just putting the GPIO line in the table in the
> driver instead of the reset function pointer, and have this done from there
> instead of exporting function pointers from board code to drivers.


I bike-shed'ed this until I was blue and decided I should leave it up
to David Miller as he was likely to have an opinion on consolidation of
functionality versus board-agnostic code.

David, would you prefer I set the GPIO from the PCI Subsystem ID and
move the reset function into the pch_gbe driver?


> 
> > +static int __init minnow_module_init(void)
> > +{
> > +	int err, val, i;
> > +
> > +	err = -ENODEV;
> > +	if (!minnow_detect())
> > +		goto out;
> > +
> > +#ifdef MODULE
> > +/* Load any implicit dependencies that are not built-in */
> > +#ifdef CONFIG_LPC_SCH_MODULE
> > +	if (request_module("lpc_sch"))
> 
> Less ifdefs with:
> 
> if (IS_MODULE(....) && request_module(..))


Shiny. Can do. Thanks.


> > +
> > +module_init(minnow_module_init);
> > +module_exit(minnow_module_exit);
> > +
> > +MODULE_LICENSE("GPL");
> 
> You probably want a MODULE_DEVICE_TABLE(dmi, ...) here?


See what happens when core kernel people are allowed to write driver
code? How does this relate to converting this over to an ACPI device
driver? I guess I would replace the above with
MODULE_DEVICE_TABLE(acpi, ...) ? If I do the above.... is this still an
evil board-file? What makes the acpi method of discover superior to
setting up linux-hotplug via dmi?

I think there is precious piece of learning to be had here (for me I
mean)...


> > diff --git a/include/linux/minnowboard.h b/include/linux/minnowboard.h
...
> > +#ifndef _LINUX_MINNOWBOARD_H
> > +#define _LINUX_MINNOWBOARD_H
> > +
> > +#if defined(CONFIG_MINNOWBOARD) || defined(CONFIG_MINNOWBOARD_MODULE)
> > +bool minnow_detect(void);
> > +bool minnow_lvds_detect(void);
> > +int minnow_hwid(void);
> > +void minnow_phy_reset(void);
> > +#else
> > +#define minnow_detect() (false)
> > +#define minnow_lvds_detect() (false)
> > +#define minnow_hwid() (-1)
> > +#define minnow_phy_reset() do { } while (0)
> > +#endif /* MINNOWBOARD */
> 
> Besides the phy_reset() export, the rest of these don't leave this
> subdirectory. It'd be nice not to expose this very board-specific stuff to the
> rest of the kernel -- temptation tends to be too great to resist adding more
> and more things over time.

Good point. I'll address in V2 after we bat around some of the above a
bit.

Thank you for taking the time Olof!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

