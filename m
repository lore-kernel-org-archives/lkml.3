Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbaDWRgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:36:09 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4505 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924AbaDWRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:36:05 -0400
Date: Wed, 23 Apr 2014 10:38:10 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140423173809.GJ17066@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <20140423105055.GI21613@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140423105055.GI21613@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:50:55PM +0200, Lee Jones wrote:
> > From: Josh Cartwright <joshc@codeaurora.org>
> > 
> > The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> > 800 series SoC family.  This driver exists largely as a glue mfd component,
> > it exists to be an owner of an SPMI regmap for children devices
> > described in device tree.
> > 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> > ---
> >  drivers/mfd/Kconfig  | 13 +++++++++++
> >  drivers/mfd/Makefile |  1 +
> >  drivers/mfd/pm8x41.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 77 insertions(+)
> >  create mode 100644 drivers/mfd/pm8x41.c
> > 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 3383412..f5ff799 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -502,6 +502,19 @@ config MFD_PM8921_CORE
> >  	  Say M here if you want to include support for PM8921 chip as a module.
> >  	  This will build a module called "pm8921-core".
> >  
> > +config MFD_PM8X41
> > +	bool "Qualcomm PM8x41 PMIC"

Hrm.  This should be tristate.

> > +	depends on ARCH_QCOM
> 
> depends on OF?

Yea, that's probably best.

> > +	select REGMAP_SPMI
> > +	help
> > +	  This enables basic support for the Qualcomm 8941 and 8841 PMICs.
> > +	  These PMICs are currently used with the Snapdragon 800 series of
> > +	  SoCs.  Note, that this will only be useful paired with descriptions
> > +	  of the independent functions as children nodes in the device tree.
> > +
> > +	  Say M here if you want to include support for the PM8x41 series as a
> > +	  module.  The module will be called "pm8x41".
> > +
> >  config MFD_RDC321X
> >  	tristate "RDC R-321x southbridge"
> >  	select MFD_CORE
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 2851275..f0df41d 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -151,6 +151,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
> >  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
> >  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
> >  obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
> > +obj-$(CONFIG_MFD_PM8X41)	+= pm8x41.o
> >  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
> >  obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
> >  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
> > diff --git a/drivers/mfd/pm8x41.c b/drivers/mfd/pm8x41.c
> > new file mode 100644
> > index 0000000..c85e0d6
> > --- /dev/null
> > +++ b/drivers/mfd/pm8x41.c
> > @@ -0,0 +1,63 @@
> > +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/spmi.h>
> > +#include <linux/regmap.h>
> > +#include <linux/of_platform.h>
> > +
> > +static const struct regmap_config pm8x41_regmap_config = {
> > +	.reg_bits	= 16,
> > +	.val_bits	= 8,
> > +	.max_register	= 0xFFFF,
> 
> I've never seen this many registers registered before.
> 
> Are you sure you want to regmap the entire bank?
> 

Quite sure.  The pm8941 has blocks at each 0x100, up to 0xE700.
Additionally, from what I've heard, there are some undocumented (for me
at least) blocks higher than that.

> > +};
> > +
> > +static int pm8x41_remove_child(struct device *dev, void *unused)
> > +{
> > +	platform_device_unregister(to_platform_device(dev));
> > +	return 0;
> > +}
> > +
> > +static void pm8x41_remove(struct spmi_device *sdev)
> > +{
> > +	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
> > +}
> 
> Nit: It's strange to see the .remove above the .probe.
> 

Really?  Alright, I can move it.

> > +static int pm8x41_probe(struct spmi_device *sdev)
> > +{
> > +	struct regmap *regmap;
> > +
> > +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> 
> This is not debug, it's an error.
> 

Indeed.

> > +		return PTR_ERR(regmap);
> > +	}
> > +
> > +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> > +}
> > +
> > +static const struct of_device_id pm8x41_id_table[] = {
> > +	{ .compatible = "qcom,pm8841", },
> > +	{ .compatible = "qcom,pm8941", },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
> > +
> > +static struct spmi_driver pm8x41_driver = {
> > +	.probe	= pm8x41_probe,
> > +	.remove	= pm8x41_remove,
> > +	.driver	= {
> > +		.name		= "pm8x41",
> > +		.of_match_table	= pm8x41_id_table,
> 
> of_match_ptr()
> 

Ok.

> > +	},
> > +};
> > +module_spmi_driver(pm8x41_driver);

Thanks for the review.

-Courtney
