Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaJGIXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:23:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50001 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaJGIXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:23:31 -0400
Date: Tue, 7 Oct 2014 17:23:23 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        jack.yoo@skyworksinc.com
Subject: Re: [RESUBMIT PATCH v3 1/8] mfd: Add support for Skyworks SKY81452
 driver
Message-ID: <20141007082323.GA10544@jack-ThinkPad-T520>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1412657901-7865-1-git-send-email-jack.yoo@skyworksinc.com>
 <20141007081200.GC25331@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141007081200.GC25331@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:12:00AM +0100, Lee Jones wrote:
> You say that this is v3, but there is no change log (usually placed
> between the '---' and the diffstat).  Also you have 8 patches in this
> set with no 0/8 patch explaining what you're trying to achieve.  For
> this size patch you also require a patch commit log.  What does this
> driver provide?  How does it provide it?  Once you've addressed these
> issues, I'll review your patches.

I sent 0/8 patch, and it has the change log and what this patch is
trying to do.
Can I ask you to review the patches?
Thank you.

> 
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > ---
> >  drivers/mfd/Kconfig          |  12 +++++
> >  drivers/mfd/Makefile         |   1 +
> >  drivers/mfd/sky81452.c       | 111 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/sky81452.h |  32 +++++++++++++
> >  4 files changed, 156 insertions(+)
> >  create mode 100644 drivers/mfd/sky81452.c
> >  create mode 100644 include/linux/mfd/sky81452.h
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index de5abf2..6962b4e 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -626,6 +626,18 @@ config MFD_SM501_GPIO
> >  	 lines on the SM501. The platform data is used to supply the
> >  	 base number for the first GPIO line to register.
> >  
> > +config MFD_SKY81452
> > +	tristate "Skyworks Solutions SKY81452"
> > +	select MFD_CORE
> > +	select REGMAP_I2C
> > +	depends on I2C
> > +	help
> > +	  This is the core driver for the Skyworks SKY81452 backlight and
> > +	  voltage regulator device.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called sky81452.
> > +
> >  config MFD_SMSC
> >         bool "SMSC ECE1099 series chips"
> >         depends on I2C=y
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index f001487..6c2f317 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
> >  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
> >  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
> >  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
> > +obj-$(CONFIG_MFD_SKY81452)		+= sky81452.o
> >  
> >  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
> >  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> > diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
> > new file mode 100644
> > index 0000000..9130112
> > --- /dev/null
> > +++ b/drivers/mfd/sky81452.c
> > @@ -0,0 +1,111 @@
> > +/*
> > + * sky81452.c	SKY81452 MFD driver
> > + *
> > + * Copyright 2014 Skyworks Solutions Inc.
> > + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the
> > + * Free Software Foundation; either version 2, or (at your option) any
> > + * later version.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/err.h>
> > +#include <linux/slab.h>
> > +#include <linux/i2c.h>
> > +#include <linux/regmap.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/mfd/sky81452.h>
> > +
> > +static const struct regmap_config sky81452_config = {
> > +	.reg_bits = 8,
> > +	.val_bits = 8,
> > +};
> > +
> > +static int sky81452_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *id)
> > +{
> > +	struct device *dev = &client->dev;
> > +	const struct sky81452_platform_data *pdata = dev_get_platdata(dev);
> > +	struct mfd_cell cells[2];
> > +	struct regmap *regmap;
> > +	int ret;
> > +
> > +	if (!pdata) {
> > +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +		if (!pdata)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	regmap = devm_regmap_init_i2c(client, &sky81452_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_err(dev, "failed to initialize. err=%ld", PTR_ERR(regmap));
> > +		return PTR_ERR(regmap);
> > +	}
> > +
> > +	i2c_set_clientdata(client, regmap);
> > +
> > +	memset(cells, 0, sizeof(cells));
> > +	cells[0].name = "sky81452-backlight";
> > +	cells[0].of_compatible = "skyworks,sky81452-backlight";
> > +	cells[0].platform_data = pdata->bl_pdata;
> > +	cells[0].pdata_size = sizeof(*pdata->bl_pdata);
> > +	cells[1].name = "sky81452-regulator";
> > +	cells[1].of_compatible = "skyworks,sky81452-regulator";
> > +	cells[1].platform_data = pdata->regulator_init_data;
> > +	cells[1].pdata_size = sizeof(*pdata->regulator_init_data);
> > +
> > +	ret = mfd_add_devices(dev, -1, cells, ARRAY_SIZE(cells), NULL, 0, NULL);
> > +	if (ret)
> > +		dev_err(dev, "failed to add child devices. err=%d", ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int sky81452_remove(struct i2c_client *client)
> > +{
> > +	mfd_remove_devices(&client->dev);
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id sky81452_ids[] = {
> > +	{ "sky81452" },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, sky81452_ids);
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id sky81452_of_match[] = {
> > +	{ .compatible = "skyworks,sky81452", },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, sky81452_of_match);
> > +#endif
> > +
> > +static struct i2c_driver sky81452_driver = {
> > +	.driver = {
> > +		.name = "sky81452",
> > +		.of_match_table = of_match_ptr(sky81452_of_match),
> > +	},
> > +	.probe = sky81452_probe,
> > +	.remove = sky81452_remove,
> > +	.id_table = sky81452_ids,
> > +};
> > +
> > +module_i2c_driver(sky81452_driver);
> > +
> > +MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
> > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("1.2");
> > diff --git a/include/linux/mfd/sky81452.h b/include/linux/mfd/sky81452.h
> > new file mode 100644
> > index 0000000..142f762
> > --- /dev/null
> > +++ b/include/linux/mfd/sky81452.h
> > @@ -0,0 +1,32 @@
> > +/*
> > + * sky81452.h	SKY81452 MFD driver
> > + *
> > + * Copyright 2014 Skyworks Solutions Inc.
> > + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the
> > + * Free Software Foundation; either version 2, or (at your option) any
> > + * later version.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef _SKY81452_H
> > +#define _SKY81452_H
> > +
> > +#include <linux/sky81452-backlight.h>
> > +#include <linux/regulator/machine.h>
> > +
> > +struct sky81452_platform_data {
> > +	struct sky81452_bl_platform_data *bl_pdata;
> > +	struct regulator_init_data *regulator_init_data;
> > +};
> > +
> > +#endif
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
