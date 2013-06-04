Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3FDRPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:15:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32847 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3FDRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:15:11 -0400
Date: Tue, 4 Jun 2013 18:15:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: sameo@linux.intel.com, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@linaro.org
Message-ID: <20130604171507.GG31367@sirena.org.uk>
References: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
 <1370356123-22357-3-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mBuDz+cd8w/hvK2v"
Content-Disposition: inline
In-Reply-To: <1370356123-22357-3-git-send-email-guodong.xu@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: add driver for hi6421 voltage regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mBuDz+cd8w/hvK2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 10:28:42PM +0800, Guodong Xu wrote:

> +Required properties:
> +- compatible: three types of regulator are defined,
> +	- "hisilicon,hi6421-ldo"
> +	- "hisilicon,hi6421-buck012"
> +	- "hisilicon,hi6421-buck345"

What do these mean?

> +- hisilicon,hi6421-ctrl: <ctrl_reg enable_mask eco_mode_mask>
> +- hisilicon,hi6421-vset: <vset_reg vset_mask>
> +- hisilicon,hi6421-n-voltages: <n>
> +- hisilicon,hi6421-vset-table: array of voltages selectable in this regu=
lator
> +- hisilicon,hi6421-uv-step: <uV_step>
> +- hisilicon,hi6421-off-on-delay-us: <off_on_delay>
> +- hisilicon,hi6421-enable-time-us: <enable_time>

This lot are really not at all driver specific, they would apply to any
regulator which is able to use helpers like the regmap ones.  I have to
say I'm not a fan of dumping this much stuff into device tree (since it
means that the driver isn't able to figure out much of the hardware by
itself) but if we are going to do this then we should just define this
as a generic binding which any regulator can reuse rather than as one
that is specific to a particular driver.

> +Properties defined by the standard binding for regulators: (See regulato=
r.txt)
> +- regulator-name:
> +- regulator-min-microvolt:
> +- regulator-max-microvolt:
> +- regulator-boot-on:
> +- regulator-always-on:

No need to list the properties, any new ones added in the core ought to
be supported.

> +Optional properties:
> +- hisilicon,hi6421-eco-microamp: maximum current allowed in ECO mode (in=
 uA)

It's *possible* that whatever "ECO mode" is might be device specific but
I rather suspect it's just a low power mode in which case it's fairly
generic (the code certainly looks that way).

> +++ b/drivers/regulator/Kconfig
> @@ -514,5 +514,11 @@ config REGULATOR_AS3711
>  	  This driver provides support for the voltage regulators on the
>  	  AS3711 PMIC
> =20
> -endif
> +config REGULATOR_HI6421
> +	tristate "HiSilicon Hi6421 PMIC voltage regulator support"
> +	depends on MFD_HI6421_PMIC && OF
> +	help
> +	  This driver provides support for the voltage regulators on the
> +	  HiSilicon Hi6421 PMU / Codec IC.

Keep these files sorted as much as possible.

> +static DEFINE_MUTEX(enable_mutex);
> +struct timeval last_enabled;

No globals.  Coordinate through the MFD if you have to.

> +/* helper function to ensure when it returns it is at least 'delay_us'
> + * microseconds after 'since'.
> + */
> +static void ensured_time_after(struct timeval since, u32 delay_us)
> +{

This should obviously be in generic code if it's needed.  Should also be
"ensure" not "ensured".

> +	}
> +	return;
> +}

The return is pointless.

> +static int hi6421_regulator_is_enabled(struct regulator_dev *dev)
> +{

If you convert the core to regmap almost all of the code in this driver
can be replaced with regmap helpers.

> +static int hi6421_regulator_enable(struct regulator_dev *dev)
> +{
> +	struct hi6421_regulator *sreg =3D rdev_get_drvdata(dev);
> +	struct hi6421_pmic *pmic =3D rdev_to_pmic(dev);
> +
> +	/* keep a distance of off_on_delay from last time disabled */
> +	ensured_time_after(sreg->last_off_time, sreg->off_on_delay);
> +
> +	/* cannot enable more than one regulator at one time */
> +	mutex_lock(&enable_mutex);
> +	ensured_time_after(last_enabled, HI6421_REGS_ENA_PROTECT_TIME);
> +
> +	/* set enable register */
> +	hi6421_pmic_rmw(pmic, sreg->register_info.ctrl_reg,
> +				sreg->register_info.enable_mask,
> +				sreg->register_info.enable_mask);
> +
> +	do_gettimeofday(&last_enabled);
> +	mutex_unlock(&enable_mutex);

What exactly is the constraint here?  It's very unusual for a regulator
to have a constraint requiring a delay between power off and power on,
or for there to be restrictions on powering up multiple regulators
simulataneously.  If there are such constraints why don't they also
affect voltage changes?

> +static int hi6421_regulator_ldo_set_voltage(struct regulator_dev *dev,
> +				int min_uV, int max_uV, unsigned *selector)
> +{

Implement map_voltage() and set_voltage_sel().

> +unsigned int hi6421_regulator_get_optimum_mode(struct regulator_dev *dev,
> +			int input_uV, int output_uV, int load_uA)
> +{
> +	struct hi6421_regulator *sreg =3D rdev_get_drvdata(dev);
> +
> +	if ((load_uA =3D=3D 0) || (load_uA > sreg->eco_uA))
> +		return REGULATOR_MODE_NORMAL;
> +	else
> +		return REGULATOR_MODE_IDLE;

Why normal mode if the load is zero?

> +static const struct hi6421_regulator hi6421_regulator_ldo =3D {
> +	.rdesc =3D {
> +	.ops =3D &hi6421_ldo_rops,
> +		.type =3D REGULATOR_VOLTAGE,
> +		.owner =3D THIS_MODULE,
> +		},

Coding style.

> +	sreg->name =3D initdata->constraints.name;
> +	rdesc =3D &sreg->rdesc;
> +	rdesc->name =3D sreg->name;

You're abusing the name property here.  The descriptor name should
reflect the name the device has in silicon but you're using the
constraints name which should reflect the name of the supply on the
board.

> +	rdesc->min_uV =3D initdata->constraints.min_uV;

Similarly this should reflect the silicon not the board.

> +hi6421_probe_end:
> +	if (ret)
> +		kfree(sreg);

Use devm.

--mBuDz+cd8w/hvK2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRriCXAAoJELSic+t+oim97vcP+gJO21z1GLmAjHoaKNscciEF
JLxk82efhIQZEnUxmyHtRJdzIMDTfpfSFC8gsszsLCXvHlmDS6Y1TejY0K2BnBMn
/uORTj5QnO6eLb1IhFu5UP/bfukaLkgxQqPpAclDdhAkZKwtpTdqUUNXkFdVre/L
vUclXGbWc3KswRiA4KNUU85Rts6t5plkGL1sORvLfp+G+oHF8uhdZrAYqMSEiAjG
sAYFwsLYa6paGLhBLQNVAEI4Y9LmFNCbt3vOkxRplKiVPqpjOiC08dzSYj3e33nP
Bh6KnPdzRhjfOn9BNieJB/T1ZB9C1BfgDuUhjABF+jxH2NEYrfCtMccCaaHMFvvD
DBZXJyq9h0eazYlOq+NjfjQNrxh+pLQoSgZU6QrMecLBWsWCIKsP7DKwEYLOi7PM
HB73ODsCo2Mbo5lerm5jEb7QYaDvmG80+zzweSRQCOixKvntw2J+OtK/AX1/YopC
apCjUfgpiBkOudl1QlJI4d12f1BgdjbEtwTRSz5uuQPo5HaBx6nLbRof7hw7x7LP
oRGgFNjKwzIU3yg1RaM0zPgtf60jasMGSluweuY/x+ZwDY2n+2Npm44Q1x4uk8JM
j5zeZc96VpnO+lHQBTBJEYov6Df14SUwMuOf3EBUrld6llOgVN0mqPW+VK9CZWos
xUST2ZY/ljgUq3am8r76
=IbO/
-----END PGP SIGNATURE-----

--mBuDz+cd8w/hvK2v--
