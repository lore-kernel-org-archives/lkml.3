Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaIYKFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:05:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57195 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985AbaIYKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:05:04 -0400
Date: Thu, 25 Sep 2014 12:02:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
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
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v5 1/2] mfd/axp20x: extend axp20x to support axp288 pmic
Message-ID: <20140925100220.GA15315@lukather>
References: <1411518027-19907-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1411518027-19907-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="va9XEZk9/dJ5GUjX"
Content-Disposition: inline
In-Reply-To: <1411518027-19907-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--va9XEZk9/dJ5GUjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jacob,

On Tue, Sep 23, 2014 at 05:20:26PM -0700, Jacob Pan wrote:
> X-Powers AXP288 is a customized PMIC for Intel Baytrail-CR platforms. Sim=
ilar
> to AXP202/209, AXP288 comes with USB charger, more LDO and BUCK channels,=
 and
> AD converters. It also provides extended status and interrupt reporting
> capabilities than the devices currently supported in axp20x.c.
>=20
> In addition to feature extension, this patch also adds ACPI binding for
> enumeration.
>=20
> This consolidated driver should support more X-Powers' PMICs in both devi=
ce
> tree and ACPI enumerated platforms.
>=20
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/Kconfig        |   3 +-
>  drivers/mfd/axp20x.c       | 355 ++++++++++++++++++++++++++++++++++++++-=
------
>  include/linux/mfd/axp20x.h |  59 ++++++++
>  3 files changed, 361 insertions(+), 56 deletions(-)
>=20
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..c183edb 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -74,7 +74,8 @@ config MFD_AXP20X
>  	select REGMAP_IRQ
>  	depends on I2C=3Dy
>  	help
> -	  If you say Y here you get support for the X-Powers AXP202 and AXP209.
> +	  If you say Y here you get support for the X-Powers AXP202, AXP209 and
> +	  AXP288 power management IC (PMIC).
>  	  This driver include only the core APIs. You have to select individual
>  	  components like regulators or the PEK (Power Enable Key) under the
>  	  corresponding menus.
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index dee6539..c3252e1 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -1,9 +1,9 @@
>  /*
> - * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
> + * axp20x.c - MFD core driver for the X-Powers' Power Management ICs
>   *
> - * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
> - * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current and temp=
erature
> - * as well as 4 configurable GPIOs.
> + * AXP20x typically comprises an adaptive USB-Compatible PWM charger, BU=
CK DC-DC
> + * converters, LDOs, multiple 12-bit ADCs of voltage, current and temper=
ature
> + * as well as configurable GPIOs.
>   *
>   * Author: Carlo Caione <carlo@caione.org>
>   *
> @@ -25,9 +25,16 @@
>  #include <linux/mfd/core.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
> +#include <linux/acpi.h>
> =20
>  #define AXP20X_OFF	0x80
> =20
> +static const char const *axp20x_model_names[] =3D {
> +	"AXP202",
> +	"AXP209",
> +	"AXP288",
> +};
> +
>  static const struct regmap_range axp20x_writeable_ranges[] =3D {
>  	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ5_STATE),
>  	regmap_reg_range(AXP20X_DCDC_MODE, AXP20X_FG_RES),
> @@ -47,6 +54,25 @@ static const struct regmap_access_table axp20x_volatil=
e_table =3D {
>  	.n_yes_ranges	=3D ARRAY_SIZE(axp20x_volatile_ranges),
>  };
> =20
> +static const struct regmap_range axp288_writeable_ranges[] =3D {
> +	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ6_STATE),
> +	regmap_reg_range(AXP20X_DCDC_MODE, AXP288_FG_TUNE5),
> +};
> +
> +static const struct regmap_range axp288_volatile_ranges[] =3D {
> +	regmap_reg_range(AXP20X_IRQ1_EN,  AXP20X_IPSOUT_V_HIGH_L),
> +};
> +
> +static const struct regmap_access_table axp288_writeable_table =3D {
> +	.yes_ranges	=3D axp288_writeable_ranges,
> +	.n_yes_ranges	=3D ARRAY_SIZE(axp288_writeable_ranges),
> +};
> +
> +static const struct regmap_access_table axp288_volatile_table =3D {
> +	.yes_ranges	=3D axp288_volatile_ranges,
> +	.n_yes_ranges	=3D ARRAY_SIZE(axp288_volatile_ranges),
> +};
> +
>  static struct resource axp20x_pek_resources[] =3D {
>  	{
>  		.name	=3D "PEK_DBR",
> @@ -61,6 +87,39 @@ static struct resource axp20x_pek_resources[] =3D {
>  	},
>  };
> =20
> +static struct resource axp288_battery_resources[] =3D {
> +	{
> +		.start =3D AXP288_IRQ_QWBTU,
> +		.end   =3D AXP288_IRQ_QWBTU,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_WBTU,
> +		.end   =3D AXP288_IRQ_WBTU,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_QWBTO,
> +		.end   =3D AXP288_IRQ_QWBTO,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_WBTO,
> +		.end   =3D AXP288_IRQ_WBTO,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_WL2,
> +		.end   =3D AXP288_IRQ_WL2,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_WL1,
> +		.end   =3D AXP288_IRQ_WL1,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
>  static const struct regmap_config axp20x_regmap_config =3D {
>  	.reg_bits	=3D 8,
>  	.val_bits	=3D 8,
> @@ -70,47 +129,96 @@ static const struct regmap_config axp20x_regmap_conf=
ig =3D {
>  	.cache_type	=3D REGCACHE_RBTREE,
>  };
> =20
> -#define AXP20X_IRQ(_irq, _off, _mask) \
> -	[AXP20X_IRQ_##_irq] =3D { .reg_offset =3D (_off), .mask =3D BIT(_mask) }
> +static const struct regmap_config axp288_regmap_config =3D {
> +	.reg_bits	=3D 8,
> +	.val_bits	=3D 8,
> +	.wr_table	=3D &axp288_writeable_table,
> +	.volatile_table	=3D &axp288_volatile_table,
> +	.max_register	=3D AXP288_FG_TUNE5,
> +	.cache_type	=3D REGCACHE_RBTREE,
> +};
> +
> +#define INIT_REGMAP_IRQ(_variant, _irq, _off, _mask)			\
> +	[_variant##_IRQ_##_irq] =3D { .reg_offset =3D (_off), .mask =3D BIT(_ma=
sk) }
> =20
>  static const struct regmap_irq axp20x_regmap_irqs[] =3D {
> -	AXP20X_IRQ(ACIN_OVER_V,		0, 7),
> -	AXP20X_IRQ(ACIN_PLUGIN,		0, 6),
> -	AXP20X_IRQ(ACIN_REMOVAL,	0, 5),
> -	AXP20X_IRQ(VBUS_OVER_V,		0, 4),
> -	AXP20X_IRQ(VBUS_PLUGIN,		0, 3),
> -	AXP20X_IRQ(VBUS_REMOVAL,	0, 2),
> -	AXP20X_IRQ(VBUS_V_LOW,		0, 1),
> -	AXP20X_IRQ(BATT_PLUGIN,		1, 7),
> -	AXP20X_IRQ(BATT_REMOVAL,	1, 6),
> -	AXP20X_IRQ(BATT_ENT_ACT_MODE,	1, 5),
> -	AXP20X_IRQ(BATT_EXIT_ACT_MODE,	1, 4),
> -	AXP20X_IRQ(CHARG,		1, 3),
> -	AXP20X_IRQ(CHARG_DONE,		1, 2),
> -	AXP20X_IRQ(BATT_TEMP_HIGH,	1, 1),
> -	AXP20X_IRQ(BATT_TEMP_LOW,	1, 0),
> -	AXP20X_IRQ(DIE_TEMP_HIGH,	2, 7),
> -	AXP20X_IRQ(CHARG_I_LOW,		2, 6),
> -	AXP20X_IRQ(DCDC1_V_LONG,	2, 5),
> -	AXP20X_IRQ(DCDC2_V_LONG,	2, 4),
> -	AXP20X_IRQ(DCDC3_V_LONG,	2, 3),
> -	AXP20X_IRQ(PEK_SHORT,		2, 1),
> -	AXP20X_IRQ(PEK_LONG,		2, 0),
> -	AXP20X_IRQ(N_OE_PWR_ON,		3, 7),
> -	AXP20X_IRQ(N_OE_PWR_OFF,	3, 6),
> -	AXP20X_IRQ(VBUS_VALID,		3, 5),
> -	AXP20X_IRQ(VBUS_NOT_VALID,	3, 4),
> -	AXP20X_IRQ(VBUS_SESS_VALID,	3, 3),
> -	AXP20X_IRQ(VBUS_SESS_END,	3, 2),
> -	AXP20X_IRQ(LOW_PWR_LVL1,	3, 1),
> -	AXP20X_IRQ(LOW_PWR_LVL2,	3, 0),
> -	AXP20X_IRQ(TIMER,		4, 7),
> -	AXP20X_IRQ(PEK_RIS_EDGE,	4, 6),
> -	AXP20X_IRQ(PEK_FAL_EDGE,	4, 5),
> -	AXP20X_IRQ(GPIO3_INPUT,		4, 3),
> -	AXP20X_IRQ(GPIO2_INPUT,		4, 2),
> -	AXP20X_IRQ(GPIO1_INPUT,		4, 1),
> -	AXP20X_IRQ(GPIO0_INPUT,		4, 0),
> +	INIT_REGMAP_IRQ(AXP20X, ACIN_OVER_V,		0, 7),
> +	INIT_REGMAP_IRQ(AXP20X, ACIN_PLUGIN,		0, 6),
> +	INIT_REGMAP_IRQ(AXP20X, ACIN_REMOVAL,	        0, 5),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_OVER_V,		0, 4),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_PLUGIN,		0, 3),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_REMOVAL,	        0, 2),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_V_LOW,		0, 1),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_PLUGIN,		1, 7),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_REMOVAL,	        1, 6),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_ENT_ACT_MODE,	1, 5),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_EXIT_ACT_MODE,	1, 4),
> +	INIT_REGMAP_IRQ(AXP20X, CHARG,		        1, 3),
> +	INIT_REGMAP_IRQ(AXP20X, CHARG_DONE,		1, 2),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_TEMP_HIGH,	        1, 1),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_TEMP_LOW,	        1, 0),
> +	INIT_REGMAP_IRQ(AXP20X, DIE_TEMP_HIGH,	        2, 7),
> +	INIT_REGMAP_IRQ(AXP20X, CHARG_I_LOW,		2, 6),
> +	INIT_REGMAP_IRQ(AXP20X, DCDC1_V_LONG,	        2, 5),
> +	INIT_REGMAP_IRQ(AXP20X, DCDC2_V_LONG,	        2, 4),
> +	INIT_REGMAP_IRQ(AXP20X, DCDC3_V_LONG,	        2, 3),
> +	INIT_REGMAP_IRQ(AXP20X, PEK_SHORT,		2, 1),
> +	INIT_REGMAP_IRQ(AXP20X, PEK_LONG,		2, 0),
> +	INIT_REGMAP_IRQ(AXP20X, N_OE_PWR_ON,		3, 7),
> +	INIT_REGMAP_IRQ(AXP20X, N_OE_PWR_OFF,	        3, 6),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_VALID,		3, 5),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_NOT_VALID,	        3, 4),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_SESS_VALID,	3, 3),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_SESS_END,	        3, 2),
> +	INIT_REGMAP_IRQ(AXP20X, LOW_PWR_LVL1,	        3, 1),
> +	INIT_REGMAP_IRQ(AXP20X, LOW_PWR_LVL2,	        3, 0),
> +	INIT_REGMAP_IRQ(AXP20X, TIMER,		        4, 7),
> +	INIT_REGMAP_IRQ(AXP20X, PEK_RIS_EDGE,	        4, 6),
> +	INIT_REGMAP_IRQ(AXP20X, PEK_FAL_EDGE,	        4, 5),
> +	INIT_REGMAP_IRQ(AXP20X, GPIO3_INPUT,		4, 3),
> +	INIT_REGMAP_IRQ(AXP20X, GPIO2_INPUT,		4, 2),
> +	INIT_REGMAP_IRQ(AXP20X, GPIO1_INPUT,		4, 1),
> +	INIT_REGMAP_IRQ(AXP20X, GPIO0_INPUT,		4, 0),
> +};
> +
> +/* some IRQs are compatible with axp20x models */
> +static const struct regmap_irq axp288_regmap_irqs[] =3D {
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_REMOVAL,           0, 2),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_PLUGIN,            0, 3),
> +	INIT_REGMAP_IRQ(AXP20X, VBUS_OVER_V,            0, 4),
> +
> +	INIT_REGMAP_IRQ(AXP20X, CHARG_DONE,             1, 2),
> +	INIT_REGMAP_IRQ(AXP20X, CHARG,                  1, 3),
> +	INIT_REGMAP_IRQ(AXP288, SAFE_QUIT,              1, 4),
> +	INIT_REGMAP_IRQ(AXP288, SAFE_ENTER,             1, 5),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_REMOVAL,           1, 6),
> +	INIT_REGMAP_IRQ(AXP20X, BATT_PLUGIN,            1, 7),
> +
> +	INIT_REGMAP_IRQ(AXP288, QWBTU,                  2, 0),
> +	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 1),
> +	INIT_REGMAP_IRQ(AXP288, QWBTO,                  2, 2),
> +	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 3),
> +	INIT_REGMAP_IRQ(AXP288, QCBTU,                  2, 4),
> +	INIT_REGMAP_IRQ(AXP288, CBTU,                   2, 5),
> +	INIT_REGMAP_IRQ(AXP288, QCBTO,                  2, 6),
> +	INIT_REGMAP_IRQ(AXP288, CBTO,                   2, 7),
> +
> +	INIT_REGMAP_IRQ(AXP288, WL2,                    3, 0),
> +	INIT_REGMAP_IRQ(AXP288, WL1,                    3, 1),
> +	INIT_REGMAP_IRQ(AXP288, GPADC,                  3, 2),
> +	INIT_REGMAP_IRQ(AXP288, OT,                     3, 7),
> +
> +	INIT_REGMAP_IRQ(AXP288, GPIO0,                  4, 0),
> +	INIT_REGMAP_IRQ(AXP288, GPIO1,                  4, 1),
> +	INIT_REGMAP_IRQ(AXP288, POKO,                   4, 2),
> +	INIT_REGMAP_IRQ(AXP288, POKL,                   4, 3),
> +	INIT_REGMAP_IRQ(AXP288, POKS,                   4, 4),
> +	INIT_REGMAP_IRQ(AXP288, POKN,                   4, 5),
> +	INIT_REGMAP_IRQ(AXP288, POKP,                   4, 6),
> +	INIT_REGMAP_IRQ(AXP20X, TIMER,                  4, 7),
> +
> +	INIT_REGMAP_IRQ(AXP288, MV_CHNG,                5, 0),
> +	INIT_REGMAP_IRQ(AXP288, BC_USB_CHNG,            5, 1),
>  };
> =20
>  static const struct of_device_id axp20x_of_match[] =3D {
> @@ -128,16 +236,39 @@ static const struct i2c_device_id axp20x_i2c_id[] =
=3D {
>  };
>  MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
> =20
> +static struct acpi_device_id axp20x_acpi_match[] =3D {
> +	{
> +		.id =3D "INT33F4",
> +		.driver_data =3D (kernel_ulong_t)AXP288_ID,
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, axp20x_acpi_match);
> +
>  static const struct regmap_irq_chip axp20x_regmap_irq_chip =3D {
>  	.name			=3D "axp20x_irq_chip",
>  	.status_base		=3D AXP20X_IRQ1_STATE,
>  	.ack_base		=3D AXP20X_IRQ1_STATE,
>  	.mask_base		=3D AXP20X_IRQ1_EN,
> -	.num_regs		=3D 5,
> +	.mask_invert		=3D true,
> +	.init_ack_masked	=3D true,
>  	.irqs			=3D axp20x_regmap_irqs,
>  	.num_irqs		=3D ARRAY_SIZE(axp20x_regmap_irqs),
> +	.num_regs		=3D 5,
> +
> +};
> +
> +static const struct regmap_irq_chip axp288_regmap_irq_chip =3D {
> +	.name			=3D "axp288_irq_chip",
> +	.status_base		=3D AXP20X_IRQ1_STATE,
> +	.ack_base		=3D AXP20X_IRQ1_STATE,
> +	.mask_base		=3D AXP20X_IRQ1_EN,
>  	.mask_invert		=3D true,
>  	.init_ack_masked	=3D true,
> +	.irqs			=3D axp288_regmap_irqs,
> +	.num_irqs		=3D ARRAY_SIZE(axp288_regmap_irqs),
> +	.num_regs		=3D 6,
> +
>  };
> =20
>  static const char * const axp20x_supplies[] =3D {
> @@ -161,36 +292,149 @@ static struct mfd_cell axp20x_cells[] =3D {
>  	},
>  };
> =20
> +static struct resource axp288_adc_resources[] =3D {
> +	{
> +		.name	=3D "GPADC",
> +		.start =3D AXP288_IRQ_GPADC,
> +		.end   =3D AXP288_IRQ_GPADC,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct resource axp288_charger_resources[] =3D {
> +	{
> +		.start =3D AXP288_IRQ_OV,
> +		.end   =3D AXP288_IRQ_OV,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_DONE,
> +		.end   =3D AXP288_IRQ_DONE,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_CHARGING,
> +		.end   =3D AXP288_IRQ_CHARGING,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_SAFE_QUIT,
> +		.end   =3D AXP288_IRQ_SAFE_QUIT,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_SAFE_ENTER,
> +		.end   =3D AXP288_IRQ_SAFE_ENTER,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_QCBTU,
> +		.end   =3D AXP288_IRQ_QCBTU,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_CBTU,
> +		.end   =3D AXP288_IRQ_CBTU,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_QCBTO,
> +		.end   =3D AXP288_IRQ_QCBTO,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +	{
> +		.start =3D AXP288_IRQ_CBTO,
> +		.end   =3D AXP288_IRQ_CBTO,
> +		.flags =3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell axp288_cells[] =3D {
> +	{
> +		.name =3D "axp288_adc",
> +		.num_resources =3D ARRAY_SIZE(axp288_adc_resources),
> +		.resources =3D axp288_adc_resources,
> +	},
> +	{
> +		.name =3D "axp288_charger",
> +		.num_resources =3D ARRAY_SIZE(axp288_charger_resources),
> +		.resources =3D axp288_charger_resources,
> +	},
> +	{
> +		.name =3D "axp288_battery",
> +		.num_resources =3D ARRAY_SIZE(axp288_battery_resources),
> +		.resources =3D axp288_battery_resources,
> +	},
> +};
> +
>  static struct axp20x_dev *axp20x_pm_power_off;
>  static void axp20x_power_off(void)
>  {
> +	if (axp20x_pm_power_off->variant =3D=3D AXP288_ID)
> +		return;

A newline would be nice here.

>  	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
>  		     AXP20X_OFF);
>  }
> =20
> +static int axp20x_match_device(struct axp20x_dev *axp20x, struct device =
*dev)
> +{
> +	const struct acpi_device_id *acpi_id;
> +	const struct of_device_id *of_id;
> +
> +	of_id =3D of_match_device(axp20x_of_match, dev);
> +	if (of_id)
> +		axp20x->variant =3D (long) of_id->data;
> +	else {

You need brackets around your if case

> +		acpi_id =3D acpi_match_device(dev->driver->acpi_match_table, dev);
> +		if (!acpi_id || !acpi_id->driver_data) {
> +			dev_err(dev, "Unable to determine ID\n");
> +			return -ENODEV;
> +		}
> +		axp20x->variant =3D (long) acpi_id->driver_data;
> +	}

Newline.

> +	switch (axp20x->variant) {
> +	case AXP202_ID:
> +	case AXP209_ID:
> +		axp20x->nr_cells =3D ARRAY_SIZE(axp20x_cells);
> +		axp20x->cells =3D axp20x_cells;
> +		axp20x->regmap_cfg =3D &axp20x_regmap_config;
> +		axp20x->regmap_irq_chip =3D &axp20x_regmap_irq_chip;
> +		break;
> +	case AXP288_ID:
> +		axp20x->cells =3D axp288_cells;
> +		axp20x->nr_cells =3D ARRAY_SIZE(axp288_cells);
> +		axp20x->regmap_cfg =3D &axp288_regmap_config;
> +		axp20x->regmap_irq_chip =3D &axp288_regmap_irq_chip;
> +		break;
> +	default:
> +		dev_err(dev, "unsupported AXP20X ID %lu\n", axp20x->variant);
> +		return -EINVAL;
> +	}
> +	dev_info(dev, "AXP20x variant %s found\n",
> +		axp20x_model_names[axp20x->variant]);
> +
> +	return 0;
> +}
> +
>  static int axp20x_i2c_probe(struct i2c_client *i2c,
>  			 const struct i2c_device_id *id)
>  {
>  	struct axp20x_dev *axp20x;
> -	const struct of_device_id *of_id;
>  	int ret;
> =20
>  	axp20x =3D devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
>  	if (!axp20x)
>  		return -ENOMEM;
> =20
> -	of_id =3D of_match_device(axp20x_of_match, &i2c->dev);
> -	if (!of_id) {
> -		dev_err(&i2c->dev, "Unable to setup AXP20X data\n");
> -		return -ENODEV;
> -	}
> -	axp20x->variant =3D (long) of_id->data;
> +	ret =3D axp20x_match_device(axp20x, &i2c->dev);
> +	if (ret)
> +		return ret;
> =20
>  	axp20x->i2c_client =3D i2c;
>  	axp20x->dev =3D &i2c->dev;
>  	dev_set_drvdata(axp20x->dev, axp20x);
> =20
> -	axp20x->regmap =3D devm_regmap_init_i2c(i2c, &axp20x_regmap_config);
> +	axp20x->regmap =3D devm_regmap_init_i2c(i2c, axp20x->regmap_cfg);
>  	if (IS_ERR(axp20x->regmap)) {
>  		ret =3D PTR_ERR(axp20x->regmap);
>  		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
> @@ -199,15 +443,15 @@ static int axp20x_i2c_probe(struct i2c_client *i2c,
> =20
>  	ret =3D regmap_add_irq_chip(axp20x->regmap, i2c->irq,
>  				  IRQF_ONESHOT | IRQF_SHARED, -1,
> -				  &axp20x_regmap_irq_chip,
> +				  axp20x->regmap_irq_chip,
>  				  &axp20x->regmap_irqc);
>  	if (ret) {
>  		dev_err(&i2c->dev, "failed to add irq chip: %d\n", ret);
>  		return ret;
>  	}
> =20
> -	ret =3D mfd_add_devices(axp20x->dev, -1, axp20x_cells,
> -			      ARRAY_SIZE(axp20x_cells), NULL, 0, NULL);
> +	ret =3D mfd_add_devices(axp20x->dev, -1, axp20x->cells,
> +			axp20x->nr_cells, NULL, 0, NULL);
> =20
>  	if (ret) {
>  		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
> @@ -245,6 +489,7 @@ static struct i2c_driver axp20x_i2c_driver =3D {
>  		.name	=3D "axp20x",
>  		.owner	=3D THIS_MODULE,
>  		.of_match_table	=3D of_match_ptr(axp20x_of_match),
> +		.acpi_match_table =3D ACPI_PTR(axp20x_acpi_match),
>  	},
>  	.probe		=3D axp20x_i2c_probe,
>  	.remove		=3D axp20x_i2c_remove,
> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
> index d0e31a2..81589d1 100644
> --- a/include/linux/mfd/axp20x.h
> +++ b/include/linux/mfd/axp20x.h
> @@ -14,6 +14,8 @@
>  enum {
>  	AXP202_ID =3D 0,
>  	AXP209_ID,
> +	AXP288_ID,
> +	NR_AXP20X_VARIANTS,
>  };
> =20
>  #define AXP20X_DATACACHE(m)		(0x04 + (m))
> @@ -49,11 +51,13 @@ enum {
>  #define AXP20X_IRQ3_EN			0x42
>  #define AXP20X_IRQ4_EN			0x43
>  #define AXP20X_IRQ5_EN			0x44
> +#define AXP20X_IRQ6_EN			0x45
>  #define AXP20X_IRQ1_STATE		0x48
>  #define AXP20X_IRQ2_STATE		0x49
>  #define AXP20X_IRQ3_STATE		0x4a
>  #define AXP20X_IRQ4_STATE		0x4b
>  #define AXP20X_IRQ5_STATE		0x4c
> +#define AXP20X_IRQ6_STATE		0x4d
> =20
>  /* ADC */
>  #define AXP20X_ACIN_V_ADC_H		0x56
> @@ -116,6 +120,15 @@ enum {
>  #define AXP20X_CC_CTRL			0xb8
>  #define AXP20X_FG_RES			0xb9
> =20
> +/* AXP288 specific registers */
> +#define AXP288_PMIC_ADC_H               0x56
> +#define AXP288_PMIC_ADC_L               0x57
> +#define AXP288_ADC_TS_PIN_CTRL          0x84
> +
> +#define AXP288_PMIC_ADC_EN              0x84
> +#define AXP288_FG_TUNE5			0xed
> +
> +
>  /* Regulators IDs */
>  enum {
>  	AXP20X_LDO1 =3D 0,
> @@ -169,12 +182,58 @@ enum {
>  	AXP20X_IRQ_GPIO0_INPUT,
>  };
> =20
> +enum axp288_irqs {
> +	AXP288_IRQ_VBUS_FALL     =3D 2,
> +	AXP288_IRQ_VBUS_RISE,
> +	AXP288_IRQ_OV,
> +	AXP288_IRQ_FALLING_ALT,
> +	AXP288_IRQ_RISING_ALT,
> +	AXP288_IRQ_OV_ALT,
> +	AXP288_IRQ_DONE          =3D 10,
> +	AXP288_IRQ_CHARGING,
> +	AXP288_IRQ_SAFE_QUIT,
> +	AXP288_IRQ_SAFE_ENTER,
> +	AXP288_IRQ_ABSENT,
> +	AXP288_IRQ_APPEND,
> +	AXP288_IRQ_QWBTU,
> +	AXP288_IRQ_WBTU,
> +	AXP288_IRQ_QWBTO,
> +	AXP288_IRQ_WBTO,
> +	AXP288_IRQ_QCBTU,
> +	AXP288_IRQ_CBTU,
> +	AXP288_IRQ_QCBTO,
> +	AXP288_IRQ_CBTO,
> +	AXP288_IRQ_WL2,
> +	AXP288_IRQ_WL1,
> +	AXP288_IRQ_GPADC,
> +	AXP288_IRQ_OT            =3D 31,
> +	AXP288_IRQ_GPIO0,
> +	AXP288_IRQ_GPIO1,
> +	AXP288_IRQ_POKO,
> +	AXP288_IRQ_POKL,
> +	AXP288_IRQ_POKS,
> +	AXP288_IRQ_POKN,
> +	AXP288_IRQ_POKP,
> +	AXP288_IRQ_TIMER,
> +	AXP288_IRQ_MV_CHNG,
> +	AXP288_IRQ_BC_USB_CHNG,
> +};
> +
> +#define AXP288_TS_ADC_H		0x58
> +#define AXP288_TS_ADC_L		0x59
> +#define AXP288_GP_ADC_H		0x5a
> +#define AXP288_GP_ADC_L		0x5b
> +
>  struct axp20x_dev {
>  	struct device			*dev;
>  	struct i2c_client		*i2c_client;
>  	struct regmap			*regmap;
>  	struct regmap_irq_chip_data	*regmap_irqc;
>  	long				variant;
> +	int                             nr_cells;
> +	struct mfd_cell                 *cells;
> +	const struct regmap_config	*regmap_cfg;
> +	const struct regmap_irq_chip	*regmap_irq_chip;
>  };
> =20
>  #endif /* __LINUX_MFD_AXP20X_H */

It's fine otherwise. Once fixed, you can add my

Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--va9XEZk9/dJ5GUjX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUI+gsAAoJEBx+YmzsjxAgf9wQAI+TQCgPnZ1Xlg70PrUX51Iw
haJ0e64I8ZZU2Kv/OkPswI707OJlQP7KnpKHNoQ/VnBPdfy/eCq6nj7BIPhI6Rpk
21NWm784Pm0c6pRA6kglSIAU2tCQKqXMzMxU2UXICEMg1KsZMlUyQmZj87wVtqo/
NP1dh+mgFPO+VC01BW01mEiXEywMCk9j2Gtjpq8+46Oq9q9cY+WAfZ/ZGvpaIuos
gSczifg6ETjm4uRSkmO1RiU41MVjJl0Eia2H7Bae7R5/KraohndEnklYCazkpLr9
bv51wv/T+rNOKXPJICG27c1PJrtP9ls1dePmzv+BZm1/hXFBqUxlGJNJYhGt39AL
hsp/cOI258TX8wLdRrQWI8Q7UE4ce0h+78V7O5jDbH8WeoVfJiQPi29njE4rV0gA
2ZGpJs3QGUdiZ2RkTvZsfpgDT0lVJSls9Luhip2E8cPZIGn0glYT3q+S1ehRyC2T
pliXkj1kQ2XK16abBl3odwKhb3mRS81j+O0c/YOxeT/nX3g0foy9ec3gobuyX5zu
OF8a7s026S/9LckswhodQSz1Y+CfxnmE2v003y3oNaeQcqACXmu1fEoT4vINSeDp
oD8JicPQAO+lOFTu6JDMk30JHui//rJR/P6OyraR8VqOauEyXN/z9xJWNjftgr2f
/RMCiARWLuFOOUSx46Fg
=jhFm
-----END PGP SIGNATURE-----

--va9XEZk9/dJ5GUjX--
