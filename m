Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaGRJ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:56:01 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:30509 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761348AbaGRJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:55:59 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-2.tower-193.messagelabs.com!1405677355!17179373!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 18 Jul 2014 11:55:56 +0200
Date: Fri, 18 Jul 2014 12:48:04 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Bryan Wu <cooloney@gmail.com>
CC: Andreas Werner <andreas.werner@men.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH v2 3/3] drivers/leds/leds-menf21bmc: introduce MEN
 14F021P00 BMC LED driver
Message-ID: <20140718104804.GA6152@awelinux>
References: <cover.1401181010.git.andreas.werner@men.de>
 <d06aca002784396a95beac921f296d812e1eeb4b.1401181010.git.andreas.werner@men.de>
 <CAK5ve-LaiqT8xy_LN7O6FeUSvCcJj3kGu1u5AQz2OH2Q4gGMyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK5ve-LaiqT8xy_LN7O6FeUSvCcJj3kGu1u5AQz2OH2Q4gGMyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:10:55PM -0700, Bryan Wu wrote:
> On Tue, May 27, 2014 at 2:08 AM, Andreas Werner <andreas.werner@men.de> wrote:
> > Added driver to support the 14F021P00 BMC LEDs.
> > The BMC is a Board Management Controll include four LEDs which
> > can be switched on and off.
> >
> > This driver use the I2C interface to the BMC using the menf21bmc MFD Core driver.
> >
> 
> Will you submit v2 patch based on Lee and others' review? I prefer to
> review the new one.
> 

Patch v3 is submitted so you can start review it :-)

Thanks
Andy

> Thanks,
> -Bryan
> 
> > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > ---
> >  drivers/leds/Kconfig          |   6 ++
> >  drivers/leds/Makefile         |   2 +-
> >  drivers/leds/leds-menf21bmc.c | 136 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 143 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/leds/leds-menf21bmc.c
> >
> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > index 1e81d7a..8f98e0f 100644
> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -466,6 +466,12 @@ config LEDS_OT200
> >           This option enables support for the LEDs on the Bachmann OT200.
> >           Say Y to enable LEDs on the Bachmann OT200.
> >
> > +config LEDS_MENF21BMC
> > +       tristate "LED support for the MEN 14F021P00 BMC"
> > +       depends on LEDS_CLASS && MFD_MENF21BMC
> > +       help
> > +         Say Y here to include support for the MEN 14F021P00 BMC LEDs.
> > +
> >  comment "LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)"
> >
> >  config LEDS_BLINKM
> > diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> > index 79c5155..1c465fe 100644
> > --- a/drivers/leds/Makefile
> > +++ b/drivers/leds/Makefile
> > @@ -54,7 +54,7 @@ obj-$(CONFIG_LEDS_MAX8997)            += leds-max8997.o
> >  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
> >  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
> >  obj-$(CONFIG_LEDS_VERSATILE)           += leds-versatile.o
> > -
> > +obj-$(CONFIG_LEDS_MENF21BMC)           += leds-menf21bmc.o
> >  # LED SPI Drivers
> >  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> >
> > diff --git a/drivers/leds/leds-menf21bmc.c b/drivers/leds/leds-menf21bmc.c
> > new file mode 100644
> > index 0000000..6099524
> > --- /dev/null
> > +++ b/drivers/leds/leds-menf21bmc.c
> > @@ -0,0 +1,136 @@
> > +/*
> > + *  MEN 14F021P00 Board Management Controller (BMC) LEDs Driver.
> > + *
> > + *  This is the core LED driver of the MEN 14F021P00 BMC.
> > + *  There are four LEDs available which can be switched on and off.
> > + *  STATUS LED, HOT SWAP LED, USER LED 1, USER LED 2
> > + *
> > + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> > + *  Author: Andreas Werner <andreas.werner@men.de>
> > + *  All rights reserved.
> > + *
> > + *  This program is free software; you can redistribute  it and/or modify it
> > + *  under  the terms of  the GNU General  Public License as published by the
> > + *  Free Software Foundation;  either version 2 of the  License, or (at your
> > + *  option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/leds.h>
> > +#include <linux/mfd/menf21bmc.h>
> > +
> > +#define BMC_CMD_LED_GET_SET    0xA0
> > +#define BMC_BIT_LED_STATUS     BIT(0)
> > +#define BMC_BIT_LED_HOTSWAP    BIT(1)
> > +#define BMC_BIT_LED_USER1      BIT(2)
> > +#define BMC_BIT_LED_USER2      BIT(3)
> > +
> > +struct menf21bmc_led_data {
> > +       struct led_classdev cdev;
> > +       struct menf21bmc *menf21bmc;
> > +       u8 led_bit;
> > +       const char *name;
> > +};
> > +
> > +static struct menf21bmc_led_data leds[] = {
> > +       {
> > +               .name = "menf21bmc:led_status",
> > +               .led_bit = BMC_BIT_LED_STATUS,
> > +       },
> > +       {
> > +               .name = "menf21bmc:led_hotswap",
> > +               .led_bit = BMC_BIT_LED_HOTSWAP,
> > +       },
> > +       {
> > +               .name = "menf21bmc:led_user1",
> > +               .led_bit = BMC_BIT_LED_USER1,
> > +       },
> > +       {
> > +               .name = "menf21bmc:led_user2",
> > +               .led_bit = BMC_BIT_LED_USER2,
> > +       }
> > +};
> > +
> > +static DEFINE_MUTEX(led_lock);
> > +
> > +static void
> > +menf21bmc_led_set(struct led_classdev *led_cdev, enum led_brightness value)
> > +{
> > +       int led_val;
> > +       struct menf21bmc_led_data *led = container_of(led_cdev,
> > +                                       struct menf21bmc_led_data, cdev);
> > +       struct menf21bmc *menf21bmc = led->menf21bmc;
> > +
> > +       mutex_lock(&led_lock);
> > +       led_val = menf21bmc->read_byte_data(menf21bmc->client,
> > +                                               BMC_CMD_LED_GET_SET);
> > +       if (led_val < 0)
> > +               goto err_out;
> > +
> > +       if (value == LED_OFF)
> > +               led_val &= ~led->led_bit;
> > +       else
> > +               led_val |= led->led_bit;
> > +
> > +       menf21bmc->write_byte_data(menf21bmc->client,
> > +                                       BMC_CMD_LED_GET_SET, led_val);
> > +err_out:
> > +       mutex_unlock(&led_lock);
> > +}
> > +
> > +static int menf21bmc_led_probe(struct platform_device *pdev)
> > +{
> > +       int i;
> > +       int ret;
> > +       struct menf21bmc *menf21bmc = dev_get_drvdata(pdev->dev.parent);
> > +
> > +       for (i = 0; i < ARRAY_SIZE(leds); i++) {
> > +               leds[i].cdev.name = leds[i].name;
> > +               leds[i].cdev.brightness_set = menf21bmc_led_set;
> > +               leds[i].menf21bmc = menf21bmc;
> > +
> > +               ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
> > +               if (ret < 0)
> > +                       goto err_free_leds;
> > +       }
> > +       dev_info(&pdev->dev, "MEN 140F21P00 BMC LED device enabled\n");
> > +
> > +       return 0;
> > +
> > +err_free_leds:
> > +       dev_err(&pdev->dev, "failed to register LED devicei\n");
> > +
> > +       for (i = i - 1; i >= 0; i--)
> > +               led_classdev_unregister(&leds[i].cdev);
> > +
> > +       return ret;
> > +}
> > +
> > +static int menf21bmc_led_remove(struct platform_device *pdev)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(leds); i++)
> > +               led_classdev_unregister(&leds[i].cdev);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct platform_driver menf21bmc_led = {
> > +       .probe          = menf21bmc_led_probe,
> > +       .remove         = menf21bmc_led_remove,
> > +       .driver         = {
> > +               .name           = "menf21bmc_led",
> > +               .owner          = THIS_MODULE,
> > +       },
> > +};
> > +
> > +module_platform_driver(menf21bmc_led);
> > +
> > +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> > +MODULE_DESCRIPTION("MEN 14F021P00 BMC led driver");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS("platform:menf21bmc_led");
> > --
> > 1.9.3
> >
