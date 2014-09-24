Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIXLDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:03:54 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52794 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaIXLCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:02:21 -0400
Date: Wed, 24 Sep 2014 12:02:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v4 1/3] mfd/axp20x: extend axp20x to support axp288 pmic
Message-ID: <20140924110212.GH19999@lee--X1>
References: <1410912715-25903-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410912715-25903-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20140918053926.GC8740@lee--X1>
 <20140918053252.34829684@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140918053252.34829684@ultegra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Jacob Pan wrote:
> Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, 16 Sep 2014, Jacob Pan wrote:
> > 
> > > X-Powers AXP288 is a customized PMIC for Intel Baytrail-CR
> > > platforms. Similar to AXP202/209, AXP288 comes with USB charger,
> > > more LDO and BUCK channels, and AD converters. It also provides
> > > extended status and interrupt reporting capabilities than the
> > > devices currently supported in axp20x.c.
> > > 
> > > In addition to feature extension, this patch also adds ACPI binding
> > > for enumeration.
> > > 
> > > This consolidated driver should support more X-Powers' PMICs in
> > > both device tree and ACPI enumerated platforms.
> > > 
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > >  drivers/mfd/Kconfig        |   3 +-
> > >  drivers/mfd/axp20x.c       | 353
> > > +++++++++++++++++++++++++++++++++++++--------
> > > include/linux/mfd/axp20x.h |  58 ++++++++ 3 files changed, 354
> > > insertions(+), 60 deletions(-)

[...]

> > > -static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> > > +static struct acpi_device_id axp20x_acpi_match[] = {
> > > +	{
> > > +		.id = "INT33F4",
> > > +		.driver_data = (kernel_ulong_t)AXP288_ID,
> > 
> > Why do you need to cast this?
> > 
> to make sure match driver_data which is different in acpi_device_id than
> of_device_id.

You don't need the cast.

[...]

> > > +static int axp20x_match_device(struct axp20x_dev *axp20x, struct
> > > device *dev) +{
> > > +	const struct acpi_device_id *acpi_id;
> > > +	const struct of_device_id *of_id;
> > > +
> > > +	of_id = of_match_device(axp20x_of_match, dev);
> > > +	if (of_id)
> > > +		axp20x->variant = (long) of_id->data;
> > > +	else {
> > > +		acpi_id =
> > > acpi_match_device(dev->driver->acpi_match_table, dev);
> > > +		if (!acpi_id || !acpi_id->driver_data) {
> > > +			dev_err(dev, "Unable to determine ID\n");
> > > +			return -ENODEV;
> > > +		}
> > > +		axp20x->variant = (long) acpi_id->driver_data;
> > > +	}
> > 
> > We can do better error handling here and give the user a better sense
> > of what happened if anything were to go wrong.  Do:
> > 
> > if (dev->of_node)
> >   of_id = of_match_device()
> >   if (!of_id)
> >     error()
> this will give false error on ACPI based platforms, right? in reality

Why would it?  dev->of_node should be NULL if running ACPI?

[...]

> > > +	switch (axp20x->variant) {
> > > +	case AXP202_ID:
> > > +	case AXP209_ID:
> > > +		axp20x->nr_cells = ARRAY_SIZE(axp20x_cells);
> > > +		axp20x->cells = axp20x_cells;
> > > +		axp20x->regmap_cfg = &axp20x_regmap_config;
> > > +		axp20x_regmap_irq_chip.num_regs	= 5;
> > > +		axp20x_regmap_irq_chip.irqs = axp20x_regmap_irqs;
> > > +		axp20x_regmap_irq_chip.num_irqs	=
> > > +			ARRAY_SIZE(axp20x_regmap_irqs);
> > > +		break;
> > > +	case AXP288_ID:
> > > +		axp20x->cells = axp288_cells;
> > > +		axp20x->nr_cells = ARRAY_SIZE(axp288_cells);
> > > +		axp20x->regmap_cfg = &axp288_regmap_config;
> > > +		axp20x_regmap_irq_chip.irqs = axp288_regmap_irqs;
> > > +		axp20x_regmap_irq_chip.num_irqs	=
> > > +			ARRAY_SIZE(axp288_regmap_irqs);
> > > +		axp20x_regmap_irq_chip.num_regs	= 6;
> > > +		break;
> > > +	default:
> > > +		dev_err(dev, "unsupported AXP20X ID %lu\n",
> > > axp20x->variant);
> > > +		return -ENODEV;
> > 
> > -EINVAL might be better here.
> I was considering the return value gets propagated to probe function
> which is used to query the existence of a device per driver model. But
> I have no strong preference.

I think -EINVAL would be better as the argument passed in
axp20x->variant is invalid.

define EINVAL          22      /* Invalid argument */

> > > +	}
> > > +	dev_info(dev, "AXP20x variant %s found\n",
> > > +		axp20x_model_names[axp20x->variant]);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  static int axp20x_i2c_probe(struct i2c_client *i2c,
> > > -			 const struct i2c_device_id *id)
> > > +			const struct i2c_device_id *id)
> > 
> > Sneaky. ;)
> I should not fix the extra white spaces here, unrelated to this patch.
> will remove.

It's okay.  I don't mind little things like this occasionally.  I find
them more amusing than harmful.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
