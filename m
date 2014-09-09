Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaIIMp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:45:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:47831 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaIIMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:45:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="596803563"
Date: Tue, 9 Sep 2014 05:45:17 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
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
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/4] mfd/axp2xx: extend axp20x to support axp288 pmic
Message-ID: <20140909054517.5bd4e8b6@ultegra>
In-Reply-To: <20140909073747.GI3804@lukather>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1410215046-31751-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<20140909073747.GI3804@lukather>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 09:37:47 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi Jacob,
> 
> I think it would have been nice to have CC'd Carlo Caione, the
> original writer of the driver on this.
> 
yes, i realized that after sending them out, so i sent him an email
instead. run get_maintainers.pl gave me a long list but missing carlo.
will be on the next rev.
> On Mon, Sep 08, 2014 at 03:24:04PM -0700, Jacob Pan wrote:
> > XPower AXP288 is a customized PMIC for Intel Baytrail-CR platforms.
> > Similar to AXP202/209, AXP288 comes with USB charger, more LDO and
> > BUCK channels, and AD converter. It also provides extended status
> > and interrupt reporting capabilities than the devices supported in
> > axp20x.c.
> > 
> > In addition to feature extension, this patch also adds ACPI binding
> > for enumeration and hooks for ACPI custom operational region
> > handlers.
> > 
> > Files and common data structures have been renamed from axp20x to
> > axp2xx in order to suit the extended scope of devices.
> > 
> > This consolidated driver should support more Xpower PMICs in both
> > device tree and ACPI based platforms.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/mfd/axp2xx.c       | 424
> > +++++++++++++++++++++++++++++++++++----------
> > include/linux/mfd/axp2xx.h |  57 +++++- 2 files changed, 389
> > insertions(+), 92 deletions(-)
> > 
> > diff --git a/drivers/mfd/axp2xx.c b/drivers/mfd/axp2xx.c
> > index c534443..cf7ed16 100644
> > --- a/drivers/mfd/axp2xx.c
> > +++ b/drivers/mfd/axp2xx.c
> > @@ -1,10 +1,14 @@
> >  /*
> > - * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
> > + * axp2xx.c - MFD core driver for the X-Powers AXP202, AXP209, and
> > AXP288
> 
> Could you do the s/axp20x/axp2xx/ in the first patch? It would make
> more sense to have it there, and reduce the "noise" in this patch.
> 
> >   *
> >   * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK
> > DC-DC
> >   * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current
> > and temperature
> >   * as well as 4 configurable GPIOs.
> >   *
> > + * AXP288 is a customized PMIC for Intel Baytrail CR platform.
> > Similar to AXP20x
> > + * it comes with USB charger, more LDO, BUCK channels, and status
> > reporting
> > + * capabilities.
> > + *
> 
> Also, I'm not very convinced that maintaining the list of the
> supported AXP chips is very future proof. We have at least 3 other
> variants that we know of to support (AXP221, AXP223 and
> AXP806/809). This would end up in a huge list :)
> 
agreed. perhaps just a generic description of functionalities here.
> >   * Author: Carlo Caione <carlo@caione.org>
> >   *
> >   * This program is free software; you can redistribute it and/or
> > modify @@ -25,9 +29,14 @@
> >  #include <linux/mfd/core.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> > +#include <linux/acpi.h>
> >  
> >  #define AXP20X_OFF	0x80
> >  
> > +static struct mfd_cell *axp2xx_cells;
> > +static int axp2xx_nr_cells;
> > +static struct regmap_config *regmap_cfg;
> > +
> >  static const struct regmap_range axp20x_writeable_ranges[] = {
> >  	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ5_STATE),
> >  	regmap_reg_range(AXP20X_DCDC_MODE, AXP20X_FG_RES),
> > @@ -47,6 +56,25 @@ static const struct regmap_access_table
> > axp20x_volatile_table = { .n_yes_ranges	=
> > ARRAY_SIZE(axp20x_volatile_ranges), };
> >  
> > +static const struct regmap_range axp288_writeable_ranges[] = {
> > +	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ6_STATE),
> > +	regmap_reg_range(AXP20X_DCDC_MODE, AXP288_FG_TUNE5),
> > +};
> > +
> > +static const struct regmap_range axp288_volatile_ranges[] = {
> > +	regmap_reg_range(AXP20X_IRQ1_EN,  AXP20X_IPSOUT_V_HIGH_L),
> > +};
> > +
> > +static const struct regmap_access_table axp288_writeable_table = {
> > +	.yes_ranges	= axp288_writeable_ranges,
> > +	.n_yes_ranges	= ARRAY_SIZE(axp288_writeable_ranges),
> > +};
> > +
> > +static const struct regmap_access_table axp288_volatile_table = {
> > +	.yes_ranges	= axp288_volatile_ranges,
> > +	.n_yes_ranges	= ARRAY_SIZE(axp288_volatile_ranges),
> > +};
> > +
> >  static struct resource axp20x_pek_resources[] = {
> >  	{
> >  		.name	= "PEK_DBR",
> > @@ -61,7 +89,40 @@ static struct resource axp20x_pek_resources[] = {
> >  	},
> >  };
> >  
> > -static const struct regmap_config axp20x_regmap_config = {
> > +static struct resource axp288_battery_resources[] = {
> > +	{
> > +		.start = AXP288_IRQ_QWBTU,
> > +		.end   = AXP288_IRQ_QWBTU,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_WBTU,
> > +		.end   = AXP288_IRQ_WBTU,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_QWBTO,
> > +		.end   = AXP288_IRQ_QWBTO,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_WBTO,
> > +		.end   = AXP288_IRQ_WBTO,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_WL2,
> > +		.end   = AXP288_IRQ_WL2,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_WL1,
> > +		.end   = AXP288_IRQ_WL1,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct regmap_config axp20x_regmap_config = {
> >  	.reg_bits	= 8,
> >  	.val_bits	= 8,
> >  	.wr_table	= &axp20x_writeable_table,
> > @@ -70,47 +131,96 @@ static const struct regmap_config
> > axp20x_regmap_config = { .cache_type	= REGCACHE_RBTREE,
> >  };
> >  
> > -#define AXP20X_IRQ(_irq, _off, _mask) \
> > -	[AXP20X_IRQ_##_irq] = { .reg_offset = (_off), .mask =
> > BIT(_mask) } +static struct regmap_config axp288_regmap_config = {
> > +	.reg_bits	= 8,
> > +	.val_bits	= 8,
> > +	.wr_table	= &axp288_writeable_table,
> > +	.volatile_table	= &axp288_volatile_table,
> > +	.max_register	= AXP288_FG_TUNE5,
> > +	.cache_type	= REGCACHE_RBTREE,
> > +};
> > +
> > +#define INIT_REGMAP_IRQ(_variant, _irq, _off,
> > _mask)			\
> > +	[_variant##_IRQ_##_irq] = { .reg_offset = (_off), .mask =
> > BIT(_mask) } 
> >  static const struct regmap_irq axp20x_regmap_irqs[] = {
> > -	AXP20X_IRQ(ACIN_OVER_V,		0, 7),
> > -	AXP20X_IRQ(ACIN_PLUGIN,		0, 6),
> > -	AXP20X_IRQ(ACIN_REMOVAL,	0, 5),
> > -	AXP20X_IRQ(VBUS_OVER_V,		0, 4),
> > -	AXP20X_IRQ(VBUS_PLUGIN,		0, 3),
> > -	AXP20X_IRQ(VBUS_REMOVAL,	0, 2),
> > -	AXP20X_IRQ(VBUS_V_LOW,		0, 1),
> > -	AXP20X_IRQ(BATT_PLUGIN,		1, 7),
> > -	AXP20X_IRQ(BATT_REMOVAL,	1, 6),
> > -	AXP20X_IRQ(BATT_ENT_ACT_MODE,	1, 5),
> > -	AXP20X_IRQ(BATT_EXIT_ACT_MODE,	1, 4),
> > -	AXP20X_IRQ(CHARG,		1, 3),
> > -	AXP20X_IRQ(CHARG_DONE,		1, 2),
> > -	AXP20X_IRQ(BATT_TEMP_HIGH,	1, 1),
> > -	AXP20X_IRQ(BATT_TEMP_LOW,	1, 0),
> > -	AXP20X_IRQ(DIE_TEMP_HIGH,	2, 7),
> > -	AXP20X_IRQ(CHARG_I_LOW,		2, 6),
> > -	AXP20X_IRQ(DCDC1_V_LONG,	2, 5),
> > -	AXP20X_IRQ(DCDC2_V_LONG,	2, 4),
> > -	AXP20X_IRQ(DCDC3_V_LONG,	2, 3),
> > -	AXP20X_IRQ(PEK_SHORT,		2, 1),
> > -	AXP20X_IRQ(PEK_LONG,		2, 0),
> > -	AXP20X_IRQ(N_OE_PWR_ON,		3, 7),
> > -	AXP20X_IRQ(N_OE_PWR_OFF,	3, 6),
> > -	AXP20X_IRQ(VBUS_VALID,		3, 5),
> > -	AXP20X_IRQ(VBUS_NOT_VALID,	3, 4),
> > -	AXP20X_IRQ(VBUS_SESS_VALID,	3, 3),
> > -	AXP20X_IRQ(VBUS_SESS_END,	3, 2),
> > -	AXP20X_IRQ(LOW_PWR_LVL1,	3, 1),
> > -	AXP20X_IRQ(LOW_PWR_LVL2,	3, 0),
> > -	AXP20X_IRQ(TIMER,		4, 7),
> > -	AXP20X_IRQ(PEK_RIS_EDGE,	4, 6),
> > -	AXP20X_IRQ(PEK_FAL_EDGE,	4, 5),
> > -	AXP20X_IRQ(GPIO3_INPUT,		4, 3),
> > -	AXP20X_IRQ(GPIO2_INPUT,		4, 2),
> > -	AXP20X_IRQ(GPIO1_INPUT,		4, 1),
> > -	AXP20X_IRQ(GPIO0_INPUT,		4, 0),
> > +	INIT_REGMAP_IRQ(AXP20X, ACIN_OVER_V,		0, 7),
> > +	INIT_REGMAP_IRQ(AXP20X, ACIN_PLUGIN,		0, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, ACIN_REMOVAL,	        0, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_OVER_V,		0, 4),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_PLUGIN,		0, 3),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_REMOVAL,	        0, 2),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_V_LOW,		0, 1),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_PLUGIN,		1, 7),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_REMOVAL,	        1, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_ENT_ACT_MODE,	1, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_EXIT_ACT_MODE,	1, 4),
> > +	INIT_REGMAP_IRQ(AXP20X, CHARG,		        1,
> > 3),
> > +	INIT_REGMAP_IRQ(AXP20X, CHARG_DONE,		1, 2),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_TEMP_HIGH,	        1,
> > 1),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_TEMP_LOW,	        1,
> > 0),
> > +	INIT_REGMAP_IRQ(AXP20X, DIE_TEMP_HIGH,	        2,
> > 7),
> > +	INIT_REGMAP_IRQ(AXP20X, CHARG_I_LOW,		2, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, DCDC1_V_LONG,	        2, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, DCDC2_V_LONG,	        2, 4),
> > +	INIT_REGMAP_IRQ(AXP20X, DCDC3_V_LONG,	        2, 3),
> > +	INIT_REGMAP_IRQ(AXP20X, PEK_SHORT,		2, 1),
> > +	INIT_REGMAP_IRQ(AXP20X, PEK_LONG,		2, 0),
> > +	INIT_REGMAP_IRQ(AXP20X, N_OE_PWR_ON,		3, 7),
> > +	INIT_REGMAP_IRQ(AXP20X, N_OE_PWR_OFF,	        3, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_VALID,		3, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_NOT_VALID,	        3,
> > 4),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_SESS_VALID,	3, 3),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_SESS_END,	        3,
> > 2),
> > +	INIT_REGMAP_IRQ(AXP20X, LOW_PWR_LVL1,	        3, 1),
> > +	INIT_REGMAP_IRQ(AXP20X, LOW_PWR_LVL2,	        3, 0),
> > +	INIT_REGMAP_IRQ(AXP20X, TIMER,		        4,
> > 7),
> > +	INIT_REGMAP_IRQ(AXP20X, PEK_RIS_EDGE,	        4, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, PEK_FAL_EDGE,	        4, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, GPIO3_INPUT,		4, 3),
> > +	INIT_REGMAP_IRQ(AXP20X, GPIO2_INPUT,		4, 2),
> > +	INIT_REGMAP_IRQ(AXP20X, GPIO1_INPUT,		4, 1),
> > +	INIT_REGMAP_IRQ(AXP20X, GPIO0_INPUT,		4, 0),
> > +};
> > +
> > +/* some IRQs are compatible with axp20x models */
> > +static const struct regmap_irq axp288_regmap_irqs[] = {
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_REMOVAL,           0, 2),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_PLUGIN,            0, 3),
> > +	INIT_REGMAP_IRQ(AXP20X, VBUS_OVER_V,            0, 4),
> > +
> > +	INIT_REGMAP_IRQ(AXP20X, CHARG_DONE,             1, 2),
> > +	INIT_REGMAP_IRQ(AXP20X, CHARG,                  1, 3),
> > +	INIT_REGMAP_IRQ(AXP288, SAFE_QUIT,              1, 4),
> > +	INIT_REGMAP_IRQ(AXP288, SAFE_ENTER,             1, 5),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_REMOVAL,           1, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, BATT_PLUGIN,            1, 7),
> > +
> > +	INIT_REGMAP_IRQ(AXP288, QWBTU,                  2, 0),
> > +	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 1),
> > +	INIT_REGMAP_IRQ(AXP288, QWBTO,                  2, 2),
> > +	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 3),
> > +	INIT_REGMAP_IRQ(AXP288, QCBTU,                  2, 4),
> > +	INIT_REGMAP_IRQ(AXP288, CBTU,                   2, 5),
> > +	INIT_REGMAP_IRQ(AXP288, QCBTO,                  2, 6),
> > +	INIT_REGMAP_IRQ(AXP288, CBTO,                   2, 7),
> > +
> > +	INIT_REGMAP_IRQ(AXP288, WL2,                    3, 0),
> > +	INIT_REGMAP_IRQ(AXP288, WL1,                    3, 1),
> > +	INIT_REGMAP_IRQ(AXP288, GPADC,                  3, 2),
> > +	INIT_REGMAP_IRQ(AXP288, OT,                     3, 7),
> > +
> > +	INIT_REGMAP_IRQ(AXP288, GPIO0,                  4, 0),
> > +	INIT_REGMAP_IRQ(AXP288, GPIO1,                  4, 1),
> > +	INIT_REGMAP_IRQ(AXP288, POKO,                   4, 2),
> > +	INIT_REGMAP_IRQ(AXP288, POKL,                   4, 3),
> > +	INIT_REGMAP_IRQ(AXP288, POKS,                   4, 4),
> > +	INIT_REGMAP_IRQ(AXP288, POKN,                   4, 5),
> > +	INIT_REGMAP_IRQ(AXP288, POKP,                   4, 6),
> > +	INIT_REGMAP_IRQ(AXP20X, TIMER,                  4, 7),
> > +
> > +	INIT_REGMAP_IRQ(AXP288, MV_CHNG,                5, 0),
> > +	INIT_REGMAP_IRQ(AXP288, BC_USB_CHNG,            5, 1),
> >  };
> >  
> >  static const struct of_device_id axp20x_of_match[] = {
> > @@ -123,19 +233,26 @@ MODULE_DEVICE_TABLE(of, axp20x_of_match);
> >  /*
> >   * This is useless for OF-enabled devices, but it is needed by I2C
> > subsystem */
> > -static const struct i2c_device_id axp20x_i2c_id[] = {
> > +static const struct i2c_device_id axp2xx_i2c_id[] = {
> >  	{ },
> >  };
> > -MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
> > +MODULE_DEVICE_TABLE(i2c, axp2xx_i2c_id);
> >  
> > -static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> > -	.name			= "axp20x_irq_chip",
> > +static struct acpi_device_id axp2xx_acpi_match[] = {
> > +	{
> > +		.id = "INT33F4",
> > +		.driver_data = (kernel_ulong_t)AXP288_ID,
> > +	},
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(acpi, axp2xx_acpi_match);
> > +
> > +/* common irq chip attributes only */
> > +static struct regmap_irq_chip axp2xx_regmap_irq_chip = {
> > +	.name			= "axp2xx_irq_chip",
> >  	.status_base		= AXP20X_IRQ1_STATE,
> >  	.ack_base		= AXP20X_IRQ1_STATE,
> >  	.mask_base		= AXP20X_IRQ1_EN,
> > -	.num_regs		= 5,
> > -	.irqs			= axp20x_regmap_irqs,
> > -	.num_irqs		= ARRAY_SIZE(axp20x_regmap_irqs),
> >  	.mask_invert		= true,
> >  	.init_ack_masked	= true,
> >  };
> > @@ -161,98 +278,223 @@ static struct mfd_cell axp20x_cells[] = {
> >  	},
> >  };
> >  
> > -static struct axp20x_dev *axp20x_pm_power_off;
> > -static void axp20x_power_off(void)
> > +static struct resource axp288_adc_resources[] = {
> > +	{
> > +		.name	= "GPADC",
> > +		.start = AXP288_IRQ_GPADC,
> > +		.end   = AXP288_IRQ_GPADC,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct resource axp288_charger_resources[] = {
> > +	{
> > +		.start = AXP288_IRQ_OV,
> > +		.end   = AXP288_IRQ_OV,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_DONE,
> > +		.end   = AXP288_IRQ_DONE,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_CHARGING,
> > +		.end   = AXP288_IRQ_CHARGING,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_SAFE_QUIT,
> > +		.end   = AXP288_IRQ_SAFE_QUIT,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_SAFE_ENTER,
> > +		.end   = AXP288_IRQ_SAFE_ENTER,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_QCBTU,
> > +		.end   = AXP288_IRQ_QCBTU,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_CBTU,
> > +		.end   = AXP288_IRQ_CBTU,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_QCBTO,
> > +		.end   = AXP288_IRQ_QCBTO,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start = AXP288_IRQ_CBTO,
> > +		.end   = AXP288_IRQ_CBTO,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct mfd_cell axp288_cells[] = {
> > +	{
> > +		.name = "axp288_adc",
> > +		.num_resources = ARRAY_SIZE(axp288_adc_resources),
> > +		.resources = axp288_adc_resources,
> > +	},
> > +	{
> > +		.name = "axp288_charger",
> > +		.num_resources =
> > ARRAY_SIZE(axp288_charger_resources),
> > +		.resources = axp288_charger_resources,
> > +	},
> > +	{
> > +		.name = "axp288_battery",
> > +		.num_resources =
> > ARRAY_SIZE(axp288_battery_resources),
> > +		.resources = axp288_battery_resources,
> > +	},
> > +	{
> > +		.name = "axp288_acpi_opregion",
> > +	},
> > +};
> > +
> > +static struct axp2xx_dev *axp2xx_pm_power_off;
> > +static void axp2xx_power_off(void)
> >  {
> > -	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
> > +	if (axp2xx_pm_power_off->variant == AXP288_ID)
> > +		return;
> > +	regmap_write(axp2xx_pm_power_off->regmap, AXP20X_OFF_CTRL,
> >  		     AXP20X_OFF);
> >  }
> >  
> > -static int axp20x_i2c_probe(struct i2c_client *i2c,
> > -			 const struct i2c_device_id *id)
> > +static int axp2xx_match_device(struct axp2xx_dev *axp2xx, struct
> > device *dev) {
> > -	struct axp20x_dev *axp20x;
> > +	const struct acpi_device_id *acpi_id;
> >  	const struct of_device_id *of_id;
> > -	int ret;
> >  
> > -	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x),
> > GFP_KERNEL);
> > -	if (!axp20x)
> > -		return -ENOMEM;
> > +	of_id = of_match_device(axp2xx_of_match, dev);
> > +	if (of_id) {
> > +		axp2xx->variant = (long) of_id->data;
> > +		goto found_match;
> > +	}
> >  
> > -	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> > -	if (!of_id) {
> > -		dev_err(&i2c->dev, "Unable to setup AXP20X
> > data\n");
> > +	acpi_id = acpi_match_device(dev->driver->acpi_match_table,
> > dev);
> > +	if (!acpi_id || !acpi_id->driver_data) {
> > +		dev_err(dev, "Unable to setup AXP2XX ACPI data\n");
> >  		return -ENODEV;
> >  	}
> > -	axp20x->variant = (long) of_id->data;
> > +	axp2xx->variant = (long) acpi_id->driver_data;
> 
> Shouldn't that be in the if statement above? I guess acpi_id will be
> null on a DT-based system.
> 
I am not sure what you mean. if acpi_id == NULL, then it will return
-ENODEV since of_match_device() already found no match. If acpi_id !=
NULL, then id must contain variant info.
> > +
> > +found_match:
> > +	switch (axp2xx->variant) {
> > +	case AXP202_ID:
> > +	case AXP209_ID:
> > +		dev_dbg(dev, "AXP2xx variant AXP202/209 found\n");
> > +		axp2xx_nr_cells = ARRAY_SIZE(axp20x_cells);
> > +		axp2xx_cells = axp20x_cells;
> > +		regmap_cfg = &axp20x_regmap_config;
> > +		axp2xx_regmap_irq_chip.num_regs	= 5;
> > +		axp2xx_regmap_irq_chip.irqs = axp20x_regmap_irqs;
> > +		axp2xx_regmap_irq_chip.num_irqs	=
> > +			ARRAY_SIZE(axp20x_regmap_irqs);
> > +		break;
> > +	case AXP288_ID:
> > +		dev_dbg(dev, "AXP2xx variant AXP288 found\n");
> > +		axp2xx_cells = axp288_cells;
> > +		axp2xx_nr_cells = ARRAY_SIZE(axp288_cells);
> > +		axp2xx_regmap_irq_chip.irqs = axp288_regmap_irqs;
> > +		axp2xx_regmap_irq_chip.num_irqs	=
> > +			ARRAY_SIZE(axp288_regmap_irqs);
> > +		axp2xx_regmap_irq_chip.num_regs	= 6;
> > +		regmap_cfg = &axp288_regmap_config;
> > +		break;
> > +	default:
> > +		dev_err(dev, "unsupported AXP2XX ID %lu\n",
> > axp2xx->variant);
> > +		return -ENODEV;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int axp2xx_i2c_probe(struct i2c_client *i2c,
> > +			const struct i2c_device_id *id)
> > +{
> > +	struct axp2xx_dev *axp2xx;
> > +	int ret;
> >  
> > -	axp20x->i2c_client = i2c;
> > -	axp20x->dev = &i2c->dev;
> > -	dev_set_drvdata(axp20x->dev, axp20x);
> > +	axp2xx = devm_kzalloc(&i2c->dev, sizeof(*axp2xx),
> > GFP_KERNEL);
> > +	if (!axp2xx)
> > +		return -ENOMEM;
> > +
> > +	ret = axp2xx_match_device(axp2xx, &i2c->dev);
> > +	if (ret)
> > +		return ret;
> > +	axp2xx->i2c_client = i2c;
> > +	axp2xx->dev = &i2c->dev;
> > +	dev_set_drvdata(axp2xx->dev, axp2xx);
> >  
> > -	axp20x->regmap = devm_regmap_init_i2c(i2c,
> > &axp20x_regmap_config);
> > -	if (IS_ERR(axp20x->regmap)) {
> > -		ret = PTR_ERR(axp20x->regmap);
> > +	axp2xx->regmap = devm_regmap_init_i2c(i2c, regmap_cfg);
> > +	if (IS_ERR(axp2xx->regmap)) {
> > +		ret = PTR_ERR(axp2xx->regmap);
> >  		dev_err(&i2c->dev, "regmap init failed: %d\n",
> > ret); return ret;
> >  	}
> >  
> > -	ret = regmap_add_irq_chip(axp20x->regmap, i2c->irq,
> > +	ret = regmap_add_irq_chip(axp2xx->regmap, i2c->irq,
> >  				  IRQF_ONESHOT | IRQF_SHARED, -1,
> > -				  &axp20x_regmap_irq_chip,
> > -				  &axp20x->regmap_irqc);
> > +				  &axp2xx_regmap_irq_chip,
> > +				  &axp2xx->regmap_irqc);
> >  	if (ret) {
> >  		dev_err(&i2c->dev, "failed to add irq chip: %d\n",
> > ret); return ret;
> >  	}
> >  
> > -	ret = mfd_add_devices(axp20x->dev, -1, axp20x_cells,
> > -			      ARRAY_SIZE(axp20x_cells), NULL, 0,
> > NULL);
> > +	ret = mfd_add_devices(axp2xx->dev, -1, axp2xx_cells,
> > +			axp2xx_nr_cells, NULL, 0, NULL);
> >  
> >  	if (ret) {
> >  		dev_err(&i2c->dev, "failed to add MFD devices:
> > %d\n", ret);
> > -		regmap_del_irq_chip(i2c->irq, axp20x->regmap_irqc);
> > +		regmap_del_irq_chip(i2c->irq, axp2xx->regmap_irqc);
> >  		return ret;
> >  	}
> >  
> >  	if (!pm_power_off) {
> > -		axp20x_pm_power_off = axp20x;
> > -		pm_power_off = axp20x_power_off;
> > +		axp2xx_pm_power_off = axp2xx;
> > +		pm_power_off = axp2xx_power_off;
> >  	}
> >  
> > -	dev_info(&i2c->dev, "AXP20X driver loaded\n");
> > +	dev_info(&i2c->dev, "AXP2XX driver loaded\n");
> >  
> >  	return 0;
> >  }
> >  
> > -static int axp20x_i2c_remove(struct i2c_client *i2c)
> > +static int axp2xx_i2c_remove(struct i2c_client *i2c)
> >  {
> > -	struct axp20x_dev *axp20x = i2c_get_clientdata(i2c);
> > +	struct axp2xx_dev *axp2xx = i2c_get_clientdata(i2c);
> >  
> > -	if (axp20x == axp20x_pm_power_off) {
> > -		axp20x_pm_power_off = NULL;
> > +	if (axp2xx == axp2xx_pm_power_off) {
> > +		axp2xx_pm_power_off = NULL;
> >  		pm_power_off = NULL;
> >  	}
> >  
> > -	mfd_remove_devices(axp20x->dev);
> > -	regmap_del_irq_chip(axp20x->i2c_client->irq,
> > axp20x->regmap_irqc);
> > +	mfd_remove_devices(axp2xx->dev);
> > +	regmap_del_irq_chip(axp2xx->i2c_client->irq,
> > axp2xx->regmap_irqc); 
> >  	return 0;
> >  }
> >  
> > -static struct i2c_driver axp20x_i2c_driver = {
> > +static struct i2c_driver axp2xx_i2c_driver = {
> >  	.driver = {
> > -		.name	= "axp20x",
> > +		.name	= "axp2xx",
> >  		.owner	= THIS_MODULE,
> > -		.of_match_table	=
> > of_match_ptr(axp20x_of_match),
> > +		.of_match_table	=
> > of_match_ptr(axp2xx_of_match),
> > +		.acpi_match_table = ACPI_PTR(axp2xx_acpi_match),
> >  	},
> > -	.probe		= axp20x_i2c_probe,
> > -	.remove		= axp20x_i2c_remove,
> > -	.id_table	= axp20x_i2c_id,
> > +	.probe		= axp2xx_i2c_probe,
> > +	.remove		= axp2xx_i2c_remove,
> > +	.id_table	= axp2xx_i2c_id,
> >  };
> >  
> > -module_i2c_driver(axp20x_i2c_driver);
> > +module_i2c_driver(axp2xx_i2c_driver);
> >  
> > -MODULE_DESCRIPTION("PMIC MFD core driver for AXP20X");
> > +MODULE_DESCRIPTION("PMIC MFD core driver for AXP2XX");
> >  MODULE_AUTHOR("Carlo Caione <carlo@caione.org>");
> >  MODULE_LICENSE("GPL");
> > diff --git a/include/linux/mfd/axp2xx.h b/include/linux/mfd/axp2xx.h
> > index d0e31a2..672f048 100644
> > --- a/include/linux/mfd/axp2xx.h
> > +++ b/include/linux/mfd/axp2xx.h
> > @@ -14,6 +14,8 @@
> >  enum {
> >  	AXP202_ID = 0,
> >  	AXP209_ID,
> > +	AXP288_ID,
> > +	NR_AXP288_VARIANTS,
> 
> Can't that be a more generic name? Something like NR_AXP2XX instead?
> 
> Also, could you put me in CC in the later iterations of the patches?
> 
Yes, agreed.

Thanks for the review.
> Thanks!
> Maxime
> 

[Jacob Pan]
