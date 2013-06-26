Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3FZEAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:00:24 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36411 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3FZEAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:00:19 -0400
Date: Tue, 25 Jun 2013 21:00:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
Message-ID: <20130626040026.GA23621@quad.lixom.net>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 25, 2013 at 06:53:24PM -0700, Darren Hart wrote:
> The MinnowBoard (http://www.minnowboard.org) is an Intel Atom (E6xx) plus EG20T
> PCH development board. It uses a few GPIO lines for specific purposes and
> exposes the rest to the user.
> 
> Request the dedicated GPIO lines:
> 	HWID
> 	LVDS_DETECT
> 	PHY_RESET
> 	LED0
> 	LED1
> 
> Setup platform drivers for the MinnowBoard LEDs using the leds-gpio
> driver. Setup led0 and led1 with heartbeat and mmc0 default triggers
> respectively.
> 
> GPIO lines SUS[0-4] are dual purpose, either for LVDS signaling or as
> user GPIO. Determine which via the LVDS_DETECT signal and enable or
> disable them accordingly.
> 
> Provide a minimal public interface:
> 	minnow_detect()
> 	minnow_lvds_detect()
> 	minnow_hwid()
> 	minnow_phy_reset()
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: platform-driver-x86@vger.kernel.org
> ---
>  drivers/platform/x86/Kconfig            |  20 ++++
>  drivers/platform/x86/Makefile           |   1 +
>  drivers/platform/x86/minnowboard-gpio.h |  60 ++++++++++
>  drivers/platform/x86/minnowboard.c      | 193 ++++++++++++++++++++++++++++++++
>  include/linux/minnowboard.h             |  37 ++++++
>  5 files changed, 311 insertions(+)
>  create mode 100644 drivers/platform/x86/minnowboard-gpio.h
>  create mode 100644 drivers/platform/x86/minnowboard.c
>  create mode 100644 include/linux/minnowboard.h

Hmmmm. x86 boardfiles arriving under drivers/platform. 

The main concern is that this won't really scale if more vendors add
variations of this board -- needing code changes for each and every one
of them. Given that it's an open platform encouraging derivatives, that seems
like a slippery slope.

It's really unfortunate that this information couldn't be passed in from
firmware. We've been working so hard for so long on ARM now to move away
from board files, it's such a pity to add them on another major platform.

> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 8577261..154dbf6 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -15,6 +15,26 @@ menuconfig X86_PLATFORM_DEVICES
>  
>  if X86_PLATFORM_DEVICES
>  
> +config MINNOWBOARD
> +	tristate "MinnowBoard GPIO and LVDS support"
> +	depends on LPC_SCH
> +	depends on GPIO_SCH
> +	depends on GPIO_PCH
> +	depends on LEDS_GPIO
> +	default n

No need to default n. 'n' is the default default. :)

> +	---help---
> +	  This driver configures the MinnowBoard fixed functionality GPIO lines.
> +
> +	  It ensures that the E6XX SUS GPIOs muxed with LVDS signals (SUS[0:2])
> +	  are disabled if the LVDS_DETECT signal is asserted.
> +
> +	  If LED_TRIGGER* are enabled, LED0 will use the heartbeat trigger and
> +	  LED1 will use the mmc0 trigger.
> +
> +	  The Minnow Hardware ID is read from the GPIO HWID lines and logged.
> +
> +	  If you have a MinnowBoard, say Y or M here.
> +
>  config ACER_WMI
>  	tristate "Acer WMI Laptop Extras"
>  	depends on ACPI
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index ef0ec74..45ede1c 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for linux/drivers/platform/x86
>  # x86 Platform-Specific Drivers
>  #
> +obj-$(CONFIG_MINNOWBOARD)	+= minnowboard.o
>  obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
>  obj-$(CONFIG_ASUS_WMI)		+= asus-wmi.o
>  obj-$(CONFIG_ASUS_NB_WMI)	+= asus-nb-wmi.o
> diff --git a/drivers/platform/x86/minnowboard-gpio.h b/drivers/platform/x86/minnowboard-gpio.h
> new file mode 100644
> index 0000000..ccc8361
> --- /dev/null
> +++ b/drivers/platform/x86/minnowboard-gpio.h
> @@ -0,0 +1,60 @@
> +/*
> + * MinnowBoard Linux platform driver
> + * Copyright (c) 2013, Intel Corporation.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * Author: Darren Hart <dvhart@linux.intel.com>
> + */
> +
> +/* MinnowBoard GPIO definitions */
> +#define GPIO_BTN0 0
> +#define GPIO_BTN1 1
> +#define GPIO_BTN2 2
> +#define GPIO_BTN3 3
> +
> +#define GPIO_PROG_VOLTAGE 4
> +
> +/*
> + * If !LVDS_DETECT, the AUX lines are available as GPIO,
> + * otherwise they are used for LVDS signals.
> + */
> +#define GPIO_AUX0 5
> +#define GPIO_AUX1 6
> +#define GPIO_AUX2 7
> +#define GPIO_AUX3 8
> +#define GPIO_AUX4 9
> +
> +#define GPIO_LED0 10
> +#define GPIO_LED1 11
> +
> +#define GPIO_USB_VBUS_DETECT 12
> +
> +#define GPIO_PHY_RESET 13
> +
> +#define GPIO_PCH0 244
> +#define GPIO_PCH1 245
> +#define GPIO_PCH2 246
> +#define GPIO_PCH3 247
> +#define GPIO_PCH4 248
> +#define GPIO_PCH5 249
> +#define GPIO_PCH6 250
> +#define GPIO_PCH7 251
> +
> +#define GPIO_HWID0 252
> +#define GPIO_HWID1 253
> +#define GPIO_HWID2 254
> +
> +#define GPIO_LVDS_DETECT 255

It looks like at least gpio-pch.c uses dynamic gpio numbers, which makes it
hard to define these as static numbers since they might move around depending
on module load order, etc.

Looks like gpio-sch has hardcoded base 0, so the low-numbered ones might be OK
for now.

> diff --git a/drivers/platform/x86/minnowboard.c b/drivers/platform/x86/minnowboard.c
> new file mode 100644
> index 0000000..73d59c1
> --- /dev/null
> +++ b/drivers/platform/x86/minnowboard.c
> @@ -0,0 +1,193 @@
> +/*
> + * MinnowBoard Linux platform driver
> + * Copyright (c) 2013, Intel Corporation.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * Author: Darren Hart <dvhart@linux.intel.com>
> + */
> +
> +#define pr_fmt(fmt) "MinnowBoard: " fmt
> +
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/dmi.h>
> +#include <linux/input.h>
> +#include <linux/gpio.h>
> +#include <linux/leds.h>
> +#include <linux/gpio-sch.h>
> +#include <linux/delay.h>
> +#include <linux/minnowboard.h>
> +#include "minnowboard-gpio.h"
> +
> +static int minnow_hwid_val = -1;
> +
> +/* leds-gpio platform device structures */
> +static const struct gpio_led minnow_leds[] = {
> +	{ .name = "minnow_led0", .gpio = GPIO_LED0, .active_low = 0,
> +	  .retain_state_suspended = 1, .default_state = LEDS_GPIO_DEFSTATE_ON,
> +	  .default_trigger = "heartbeat"},
> +	{ .name = "minnow_led1", .gpio = GPIO_LED1, .active_low = 0,
> +	  .retain_state_suspended = 1, .default_state = LEDS_GPIO_DEFSTATE_ON,
> +	  .default_trigger = "mmc0"},
> +};
> +
> +static struct gpio_led_platform_data minnow_leds_platform_data = {
> +	.num_leds = ARRAY_SIZE(minnow_leds),
> +	.leds = (void *) minnow_leds,
> +};
> +
> +static struct platform_device minnow_gpio_leds = {
> +	.name =	"leds-gpio",
> +	.id = -1,
> +	.dev = {
> +		.platform_data = &minnow_leds_platform_data,
> +	},
> +};
> +
> +static struct gpio hwid_gpios[] = {
> +	{ GPIO_HWID0, GPIOF_DIR_IN | GPIOF_EXPORT, "minnow_gpio_hwid0" },
> +	{ GPIO_HWID1, GPIOF_DIR_IN | GPIOF_EXPORT, "minnow_gpio_hwid1" },
> +	{ GPIO_HWID2, GPIOF_DIR_IN | GPIOF_EXPORT, "minnow_gpio_hwid2" },
> +};
> +
> +int minnow_hwid(void)
> +{
> +	/* This should never be called prior to minnow_init_module() */
> +	WARN_ON_ONCE(minnow_hwid_val == -1);
> +	return minnow_hwid_val;
> +}
> +EXPORT_SYMBOL_GPL(minnow_hwid);

I don't see this used anywhere, so it's hard to tell what the expected use is.
I'd just remove it until first user comes along.

> +bool minnow_detect(void)
> +{
> +	const char *cmp;
> +
> +	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> +	if (cmp && strstr(cmp, "MinnowBoard"))
> +		return true;
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(minnow_detect);
>
> +bool minnow_lvds_detect(void)
> +{
> +	return !!gpio_get_value(GPIO_LVDS_DETECT);
> +}
> +EXPORT_SYMBOL_GPL(minnow_lvds_detect);

These two are only used in the other subfiles.

The scope of those files are really narrow, and you end up exporting a set of
global functions for it. I suggest you just bake them all together -- there's
a small amount of flexibility lost w.r.t. keeping some as modules and others
built-in, but the code isn't very large.

> +void minnow_phy_reset(void)
> +{
> +	/*
> +	 * Hold reset for a little over 1ms and allow some time after to ensure
> +	 * the PHY has fully woken up.
> +	 */
> +	gpio_set_value(GPIO_PHY_RESET, 0);
> +	usleep_range(1250, 1500);
> +	gpio_set_value(GPIO_PHY_RESET, 1);
> +	usleep_range(1250, 1500);
> +}
> +EXPORT_SYMBOL_GPL(minnow_phy_reset);

What phy? USB? SATA? Ethernet?

I wonder if you'd be better off just putting the GPIO line in the table in the
driver instead of the reset function pointer, and have this done from there
instead of exporting function pointers from board code to drivers.

> +static int __init minnow_module_init(void)
> +{
> +	int err, val, i;
> +
> +	err = -ENODEV;
> +	if (!minnow_detect())
> +		goto out;
> +
> +#ifdef MODULE
> +/* Load any implicit dependencies that are not built-in */
> +#ifdef CONFIG_LPC_SCH_MODULE
> +	if (request_module("lpc_sch"))

Less ifdefs with:

if (IS_MODULE(....) && request_module(..))

> +	/* HWID GPIOs */
> +	err = gpio_request_array(hwid_gpios, ARRAY_SIZE(hwid_gpios));
> +	if (err) {
> +		pr_err("Failed to request hwid GPIO lines\n");
> +		goto out;
> +	}
> +	minnow_hwid_val = (!!gpio_get_value(GPIO_HWID0)) |
> +			  (!!gpio_get_value(GPIO_HWID1) << 1) |
> +			  (!!gpio_get_value(GPIO_HWID2) << 2);
> +
> +	pr_info("Hardware ID: %d\n", minnow_hwid_val);
> +
> +	err = gpio_request_one(GPIO_LVDS_DETECT, GPIOF_DIR_IN | GPIOF_EXPORT,
> +			       "minnow_lvds_detect");
> +	if (err) {
> +		pr_err("Failed to request LVDS_DETECT GPIO line (%d)\n",
> +		       GPIO_LVDS_DETECT);
> +		goto out;
> +	}
> +
> +	/* Disable the GPIO lines if LVDS is detected */
> +	val = minnow_lvds_detect() ? 1 : 0;
> +	pr_info("Aux GPIO lines %s\n", val ? "Disabled" : "Enabled");
> +	for (i = 0; i < 5; i++)
> +		sch_gpio_resume_set_enable(i, !val);
> +
> +	/* Reserve the AR8031 PHY's ETH_RESET GPIO line */
> +	err = gpio_request_one(GPIO_PHY_RESET,
> +			       GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT,
> +			       "minnow_phy_reset");
> +	if (err) {
> +		pr_err("Failed to request PHY_RESET GPIO line (%d)\n",
> +		       GPIO_PHY_RESET);
> +		goto out_lvds;
> +	}
> +
> +	/* GPIO LEDs */
> +	err = platform_device_register(&minnow_gpio_leds);
> +	if (err) {
> +		pr_err("Failed to register leds-gpio platform device\n");
> +		goto out_phy;
> +	}
> +	goto out;
> +
> + out_phy:
> +	gpio_free(GPIO_PHY_RESET);
> +
> + out_lvds:
> +	gpio_free(GPIO_LVDS_DETECT);
> +
> + out:
> +	return err;
> +}
> +
> +static void __exit minnow_module_exit(void)
> +{
> +	gpio_free(GPIO_LVDS_DETECT);
> +	gpio_free(GPIO_PHY_RESET);
> +	platform_device_unregister(&minnow_gpio_leds);
> +}
> +
> +module_init(minnow_module_init);
> +module_exit(minnow_module_exit);
> +
> +MODULE_LICENSE("GPL");

You probably want a MODULE_DEVICE_TABLE(dmi, ...) here?

> diff --git a/include/linux/minnowboard.h b/include/linux/minnowboard.h
> new file mode 100644
> index 0000000..d3608b8
> --- /dev/null
> +++ b/include/linux/minnowboard.h
> @@ -0,0 +1,37 @@
> +/*
> + * MinnowBoard Linux platform driver
> + * Copyright (c) 2013, Intel Corporation.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * Author: Darren Hart <dvhart@linux.intel.com>
> + */
> +
> +#ifndef _LINUX_MINNOWBOARD_H
> +#define _LINUX_MINNOWBOARD_H
> +
> +#if defined(CONFIG_MINNOWBOARD) || defined(CONFIG_MINNOWBOARD_MODULE)
> +bool minnow_detect(void);
> +bool minnow_lvds_detect(void);
> +int minnow_hwid(void);
> +void minnow_phy_reset(void);
> +#else
> +#define minnow_detect() (false)
> +#define minnow_lvds_detect() (false)
> +#define minnow_hwid() (-1)
> +#define minnow_phy_reset() do { } while (0)
> +#endif /* MINNOWBOARD */

Besides the phy_reset() export, the rest of these don't leave this
subdirectory. It'd be nice not to expose this very board-specific stuff to the
rest of the kernel -- temptation tends to be too great to resist adding more
and more things over time.


-Olof
