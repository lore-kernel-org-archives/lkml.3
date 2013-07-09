Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3GIJov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:44:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51929 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:44:49 -0400
Date: Tue, 9 Jul 2013 10:44:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, lgirdwood@gmail.com
Message-ID: <20130709094424.GQ27646@sirena.org.uk>
References: <1373351880-26982-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pgnSWnQFSBiBiPK6"
Content-Disposition: inline
In-Reply-To: <1373351880-26982-1-git-send-email-b38343@freescale.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pgnSWnQFSBiBiPK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 02:38:00PM +0800, Robin Gong wrote:

I've not fully reviewed this, the major thing here is that the driver is
not making use of the regmap helpers for anything - most of the code in
this driver looks like it duplicates standard code available in the
core.

> @@ -45,6 +45,7 @@ obj-$(CONFIG_REGULATOR_MAX77693) += max77693.o
>  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
> +obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
>  obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
>  obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
>  obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
> @@ -72,6 +73,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
>  obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
> +obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o

This looks broken...

> +++ b/drivers/regulator/pfuze-regulator.h
> @@ -0,0 +1,110 @@

Why is this a separate file?

> +struct pfuze_regulator {
> +	struct regulator_desc desc;
> +	unsigned int reg;
> +	unsigned int stby_reg;
> +	unsigned char enable_bit;
> +	unsigned char stby_bit;
> +	unsigned char vsel_shift;
> +	unsigned char vsel_mask;
> +	unsigned char stby_vsel_shift;
> +	unsigned char stby_vsel_mask;
> +	int const *voltages;

This pretty much all looks like you are duplicating standard framework
features - things like the vsels for example.

> +static const int pfuze100_sw1[] = {
> +	300000, 325000, 350000, 375000, 400000, 425000, 450000, 475000,
> +	500000, 525000, 550000, 575000, 600000, 625000, 650000, 675000,
> +	700000, 725000, 750000, 775000, 800000, 825000, 850000, 875000,
> +	900000, 925000, 950000, 975000, 1000000, 1025000, 1050000, 1075000,
> +	1100000, 1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000,
> +	1300000, 1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000,
> +	1500000, 1525000, 1550000, 1575000, 1600000, 1625000, 1650000, 1675000,
> +	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
> +};

This looks like a linear map, use one if you can.  Similarly for a bunch
of the other tables (possibly all of them).

> +#if defined(CONFIG_OF)
> +static const struct of_device_id pfuze_dt_ids[] = {
> +	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE_ID_PFUZE100},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
> +#endif

No need for ifdefs.

> +static int pfuze100_regulator_enable(struct regulator_dev *rdev)

You should be using the standard regmap helpers for this.

> +int pfuze100_regulator_list_voltage(struct regulator_dev *rdev,
> +				    unsigned selector)

This too (even if you need to use the tables there are helpers for that
too).

> +static int pfuze100_regulator_sw_standby_enable(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}
> +static int pfuze100_regulator_sw_standby_disable(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}
> +static struct regulator_ops pfuze100_sw_regulator_ops = {

Coding style and you shouldn't have any empty functions.

> +#ifdef CONFIG_OF
> +
> +static int  pfuze_get_num_regulators_dt(struct device *dev)
> +{

You need to document any new device tree bindings.

> +static struct regmap_config pfuze_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = PFUZE_NUMREGS,
> +
> +	.cache_type = REGCACHE_NONE,

This is the defualt, though you should consider caching for performance
reasons.

> +subsys_initcall(pfuze100_regulator_init);

Use module_i2c_driver() (and watch out for coding style).

--pgnSWnQFSBiBiPK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR29t1AAoJELSic+t+oim92zYP/i8I64IIHJXYWv+a/U6Pt840
Wpvy49P0x32Oj96avmP11J+x5basVaYNBCHV7d67R9qH96ZGfhav76ZhhDln+tlm
INqeTxyae5Wpfdbk8KSacfuFfmRek4ucwgLc546HxMgtZlDLlSGU4auAD6CR5lvk
QbcS60l+iFxrT49QjlnAT6J+UwA84dYIYQHsKTUKfCDIzs888pvkRuIn3uSm/T0P
EbLMlrK02UHudsSCWmEVaHdVe8Hq/eBQA4ri8xRZjVf1+94Hh6U1ywmVRdfEOEcw
pEumSymuwEbnkHtErwbulZpv7mBDyvqge9QZxn8BXsBIvPFfd689jzVPqMmgsxex
NaFYrDybfqbrLRImluQpceMCEJb07DRnX6URKbx0QcY3VyWB3sGt7aHS+fsl3IzJ
oBg34JcuEesxlIIJmeofs8947tbH7j9D+63P8UL6lZWvaB7vdAXun8JigI0zk739
pvLBW3g6RYvlydfaY3sV1rVsL3tGyEpwBM6mNVPecWrlnI6zNLI8Kw5UBhhYVgxz
80aNKOlbHUbpPISvgUUcNZ5Q0Z+xBQxPjzOxXnVxT8cJl68OuH+s+PwV2tcdpiSg
3kXuTq7NAUxhQInsZuYxnoZeJ6aiirSfZaSSb+5BzQzNjxsp4rRvBbtMn+PnrdCN
HYm2efTD3D/t8IwQmJ7F
=D0iV
-----END PGP SIGNATURE-----

--pgnSWnQFSBiBiPK6--
