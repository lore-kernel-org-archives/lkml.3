Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbaIRFkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:40:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46565 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbaIRFkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:40:14 -0400
Date: Wed, 17 Sep 2014 22:39:26 -0700
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
Message-ID: <20140918053926.GC8740@lee--X1>
References: <1410912715-25903-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410912715-25903-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410912715-25903-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Jacob Pan wrote:

> X-Powers AXP288 is a customized PMIC for Intel Baytrail-CR platforms. Similar
> to AXP202/209, AXP288 comes with USB charger, more LDO and BUCK channels, and
> AD converters. It also provides extended status and interrupt reporting
> capabilities than the devices currently supported in axp20x.c.
> 
> In addition to feature extension, this patch also adds ACPI binding for
> enumeration.
> 
> This consolidated driver should support more X-Powers' PMICs in both device
> tree and ACPI enumerated platforms.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/Kconfig        |   3 +-
>  drivers/mfd/axp20x.c       | 353 +++++++++++++++++++++++++++++++++++++--------
>  include/linux/mfd/axp20x.h |  58 ++++++++
>  3 files changed, 354 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..c183edb 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -74,7 +74,8 @@ config MFD_AXP20X
>  	select REGMAP_IRQ
>  	depends on I2C=y
>  	help
> -	  If you say Y here you get support for the X-Powers AXP202 and AXP209.
> +	  If you say Y here you get support for the X-Powers AXP202, AXP209 and
> +	  AXP288 power management IC (PMIC).
>  	  This driver include only the core APIs. You have to select individual
>  	  components like regulators or the PEK (Power Enable Key) under the
>  	  corresponding menus.

[...]

> -static const struct regmap_config axp20x_regmap_config = {

[...]

> +static struct regmap_config axp20x_regmap_config = {

Why have you removed const status?

>  	.reg_bits	= 8,
>  	.val_bits	= 8,
>  	.wr_table	= &axp20x_writeable_table,
> @@ -70,47 +129,96 @@ static const struct regmap_config axp20x_regmap_config = {
>  	.cache_type	= REGCACHE_RBTREE,
>  };
>  
> -#define AXP20X_IRQ(_irq, _off, _mask) \
> -	[AXP20X_IRQ_##_irq] = { .reg_offset = (_off), .mask = BIT(_mask) }
> +static struct regmap_config axp288_regmap_config = {

const?

> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.wr_table	= &axp288_writeable_table,
> +	.volatile_table	= &axp288_volatile_table,
> +	.max_register	= AXP288_FG_TUNE5,
> +	.cache_type	= REGCACHE_RBTREE,
> +};

[...]

> -static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> +static struct acpi_device_id axp20x_acpi_match[] = {
> +	{
> +		.id = "INT33F4",
> +		.driver_data = (kernel_ulong_t)AXP288_ID,

Why do you need to cast this?

> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, axp20x_acpi_match);
> +
> +/* common irq chip attributes only */
> +static struct regmap_irq_chip axp20x_regmap_irq_chip = {
>  	.name			= "axp20x_irq_chip",
>  	.status_base		= AXP20X_IRQ1_STATE,
>  	.ack_base		= AXP20X_IRQ1_STATE,
>  	.mask_base		= AXP20X_IRQ1_EN,
> -	.num_regs		= 5,
> -	.irqs			= axp20x_regmap_irqs,
> -	.num_irqs		= ARRAY_SIZE(axp20x_regmap_irqs),
>  	.mask_invert		= true,
>  	.init_ack_masked	= true,
>  };
> @@ -161,36 +276,155 @@ static struct mfd_cell axp20x_cells[] = {
>  	},
>  };

[...]

> +static int axp20x_match_device(struct axp20x_dev *axp20x, struct device *dev)
> +{
> +	const struct acpi_device_id *acpi_id;
> +	const struct of_device_id *of_id;
> +
> +	of_id = of_match_device(axp20x_of_match, dev);
> +	if (of_id)
> +		axp20x->variant = (long) of_id->data;
> +	else {
> +		acpi_id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +		if (!acpi_id || !acpi_id->driver_data) {
> +			dev_err(dev, "Unable to determine ID\n");
> +			return -ENODEV;
> +		}
> +		axp20x->variant = (long) acpi_id->driver_data;
> +	}

We can do better error handling here and give the user a better sense
of what happened if anything were to go wrong.  Do:

if (dev->of_node)
  of_id = of_match_device()
  if (!of_id)
    error()
  variant = of_id->data;
else
  acpi_id = acpi_match_device()
  if (!acpi_id)
    error()
  variant = acpi_id->driver_data;

> +	switch (axp20x->variant) {
> +	case AXP202_ID:
> +	case AXP209_ID:
> +		axp20x->nr_cells = ARRAY_SIZE(axp20x_cells);
> +		axp20x->cells = axp20x_cells;
> +		axp20x->regmap_cfg = &axp20x_regmap_config;
> +		axp20x_regmap_irq_chip.num_regs	= 5;
> +		axp20x_regmap_irq_chip.irqs = axp20x_regmap_irqs;
> +		axp20x_regmap_irq_chip.num_irqs	=
> +			ARRAY_SIZE(axp20x_regmap_irqs);
> +		break;
> +	case AXP288_ID:
> +		axp20x->cells = axp288_cells;
> +		axp20x->nr_cells = ARRAY_SIZE(axp288_cells);
> +		axp20x->regmap_cfg = &axp288_regmap_config;
> +		axp20x_regmap_irq_chip.irqs = axp288_regmap_irqs;
> +		axp20x_regmap_irq_chip.num_irqs	=
> +			ARRAY_SIZE(axp288_regmap_irqs);
> +		axp20x_regmap_irq_chip.num_regs	= 6;
> +		break;
> +	default:
> +		dev_err(dev, "unsupported AXP20X ID %lu\n", axp20x->variant);
> +		return -ENODEV;

-EINVAL might be better here.

> +	}
> +	dev_info(dev, "AXP20x variant %s found\n",
> +		axp20x_model_names[axp20x->variant]);
> +
> +	return 0;
> +}
> +
>  static int axp20x_i2c_probe(struct i2c_client *i2c,
> -			 const struct i2c_device_id *id)
> +			const struct i2c_device_id *id)

Sneaky. ;)

>  {
>  	struct axp20x_dev *axp20x;
> -	const struct of_device_id *of_id;
>  	int ret;
>  
>  	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
>  	if (!axp20x)
>  		return -ENOMEM;
>  
> -	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> -	if (!of_id) {
> -		dev_err(&i2c->dev, "Unable to setup AXP20X data\n");
> -		return -ENODEV;
> -	}
> -	axp20x->variant = (long) of_id->data;
> +	ret = axp20x_match_device(axp20x, &i2c->dev);
> +	if (ret)
> +		return ret;
>  
>  	axp20x->i2c_client = i2c;
>  	axp20x->dev = &i2c->dev;
>  	dev_set_drvdata(axp20x->dev, axp20x);
>  
> -	axp20x->regmap = devm_regmap_init_i2c(i2c, &axp20x_regmap_config);
> +	axp20x->regmap = devm_regmap_init_i2c(i2c, axp20x->regmap_cfg);
>  	if (IS_ERR(axp20x->regmap)) {
>  		ret = PTR_ERR(axp20x->regmap);
>  		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
> @@ -206,8 +440,8 @@ static int axp20x_i2c_probe(struct i2c_client *i2c,
>  		return ret;
>  	}
>  
> -	ret = mfd_add_devices(axp20x->dev, -1, axp20x_cells,
> -			      ARRAY_SIZE(axp20x_cells), NULL, 0, NULL);
> +	ret = mfd_add_devices(axp20x->dev, -1, axp20x->cells,
> +			axp20x->nr_cells, NULL, 0, NULL);
>  
>  	if (ret) {
>  		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);

[...]

> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
> index d0e31a2..ffc69e2 100644
> --- a/include/linux/mfd/axp20x.h
> +++ b/include/linux/mfd/axp20x.h

[...]

>  struct axp20x_dev {
>  	struct device			*dev;
>  	struct i2c_client		*i2c_client;
>  	struct regmap			*regmap;
>  	struct regmap_irq_chip_data	*regmap_irqc;
>  	long				variant;
> +	int                             nr_cells;
> +	struct mfd_cell                 *cells;
> +	struct regmap_config            *regmap_cfg;

const?

>  };
>  
>  #endif /* __LINUX_MFD_AXP20X_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
