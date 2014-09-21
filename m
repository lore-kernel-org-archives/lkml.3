Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaIUNBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:01:23 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49208 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaIUNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:01:21 -0400
Message-ID: <541ECC1D.50604@kernel.org>
Date: Sun, 21 Sep 2014 14:01:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, IIO <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
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
References: <1410912715-25903-1-git-send-email-jacob.jun.pan@linux.intel.com> <1410912715-25903-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1410912715-25903-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 01:11, Jacob Pan wrote:
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
One suggested improvement inline.  When you a driver moves from supporting
one part to a couple with different configurations, a good pattern is
to pick between const configuration structures rather than having one
that is modified (or copied and then modified).

Jonathan
> ---
>  drivers/mfd/Kconfig        |   3 +-
>  drivers/mfd/axp20x.c       | 353 +++++++++++++++++++++++++++++++++++++--------
>  include/linux/mfd/axp20x.h |  58 ++++++++
>  3 files changed, 354 insertions(+), 60 deletions(-)
>
...

> -static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> +static struct acpi_device_id axp20x_acpi_match[] = {
> +	{
> +		.id = "INT33F4",
> +		.driver_data = (kernel_ulong_t)AXP288_ID,
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
>
> +static struct resource axp288_adc_resources[] = {
> +	{
> +		.name	= "GPADC",
> +		.start = AXP288_IRQ_GPADC,
> +		.end   = AXP288_IRQ_GPADC,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource axp288_charger_resources[] = {
> +	{
> +		.start = AXP288_IRQ_OV,
> +		.end   = AXP288_IRQ_OV,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_DONE,
> +		.end   = AXP288_IRQ_DONE,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_CHARGING,
> +		.end   = AXP288_IRQ_CHARGING,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_SAFE_QUIT,
> +		.end   = AXP288_IRQ_SAFE_QUIT,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_SAFE_ENTER,
> +		.end   = AXP288_IRQ_SAFE_ENTER,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_QCBTU,
> +		.end   = AXP288_IRQ_QCBTU,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_CBTU,
> +		.end   = AXP288_IRQ_CBTU,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_QCBTO,
> +		.end   = AXP288_IRQ_QCBTO,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start = AXP288_IRQ_CBTO,
> +		.end   = AXP288_IRQ_CBTO,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell axp288_cells[] = {
> +	{
> +		.name = "axp288_adc",
> +		.num_resources = ARRAY_SIZE(axp288_adc_resources),
> +		.resources = axp288_adc_resources,
> +	},
> +	{
> +		.name = "axp288_charger",
> +		.num_resources = ARRAY_SIZE(axp288_charger_resources),
> +		.resources = axp288_charger_resources,
> +	},
> +	{
> +		.name = "axp288_battery",
> +		.num_resources = ARRAY_SIZE(axp288_battery_resources),
> +		.resources = axp288_battery_resources,
> +	},
> +};
> +
>  static struct axp20x_dev *axp20x_pm_power_off;
>  static void axp20x_power_off(void)
>  {
> +	if (axp20x_pm_power_off->variant == AXP288_ID)
> +		return;
>  	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
>  		     AXP20X_OFF);
>  }
>
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
You would be better off having two regmap_irq_chip structures and
just picking the relevant one here.  Then they can remain const.

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
> +	}
> +	dev_info(dev, "AXP20x variant %s found\n",
> +		axp20x_model_names[axp20x->variant]);
> +
> +	return 0;
> +}
> +
...
