Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3HNKld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:41:33 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33300 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3HNKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:41:29 -0400
Date: Wed, 14 Aug 2013 12:41:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pwm: add LP3943 PWM driver
Message-ID: <20130814104122.GG2084@ulmo>
References: <A874F61F95741C4A9BA573A70FE3998F82E849E6@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E849E6@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 12:42:26AM +0000, Kim, Milo wrote:
> This is the other of the LP3943 MFD driver.
> LP3943 can be used as a PWM generator, up to 2 channels.
>=20
> * Two PWM generators supported
>=20
> * Supported PWM operations
>   request, free, config, set_polarity, enable and disable
>=20
> * Manual polarity configuration
>   No register exists for setting polarity. However, the value of duty can=
 be
>   calculated as following.
>   PWM-inversed mode : duty =3D period - duty
>   PWM-normal mode   : input duty itself

That's not really what the polarity is meant to be used for. While it is
true that the effect can usually be emulated by reversing the duty-cycle
there is still a difference in the generated signal. See also the
comment above the enum pwm_polarity in include/linux/pwm.h.

> * LP3943 PWM port map
>   One PWM controller can be mapped to one or multiple output pins.
>=20
>   For example, PWM 0 is used for a backlight device.
>   PWM 1 is for RGB LEDs.
>=20
>   PWM controller    Output pins    PWM consumer
>   ______________    ___________    ____________
>   PWM 0             pin 1          backlight
>   PWM 1             pin 7, 8, 9    RGB LEDs
>=20
>   Then, PWM port map is as below.
>   PWM 0: num_outputs =3D 1, output =3D pin 1
>   PWM 1: num_outputs =3D 3, output =3D pin 7, 8, 9
>=20
>   The 'lp3943_pwm_map' structure is used for this feature.
>=20
> * Pin assignment
>   A driver data, 'pin_used' is checked when a PWM is requested.
>   If the output pin is already assigned, then returns as failure.
>   If the pin is available, 'pin_used' is set.
>   When the PWM is not used anymore, then it is cleared.
>   It is defined as unsigned long type for atomic bit operation APIs,
>   but only LSB 16bits are used because LP3943 has 16 outputs.

A better location for most of the above would be either a comment in the
driver or a file in the Documentation subdirectory.

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 75840b5..038de2b 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -81,6 +81,16 @@ config PWM_JZ4740
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-jz4740.
> =20
> +config PWM_LP3943
> +	tristate "TI/National Semiconductor LP3943 PWM support"
> +	depends on MFD_LP3943
> +	help
> +	  Generic PWM framework driver for LP3943 which supports two PWM
> +	  controllers.

The more typical term to use here would be "PWM channels" or "PWM
outputs". "controller" is what the LP3943 is as a whole.

> diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
> new file mode 100644
> index 0000000..217e30c
> --- /dev/null
> +++ b/drivers/pwm/pwm-lp3943.c
> @@ -0,0 +1,348 @@
> +/*
> + * TI/National Semiconductor LP3943 PWM driver
> + *
> + * Copyright 2013 Texas Instruments
> + *
> + * Author: Milo Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/lp3943.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +#define LP3943_MAX_DUTY			255
> +#define LP3943_MIN_PERIOD		6250
> +#define LP3943_MAX_PERIOD		1600000
> +#define LP3943_NUM_PWMS			2
> +
> +#define to_lp3943_pwm(_chip)	container_of(_chip, struct lp3943_pwm, chip)

I'd like for this to be a static inline function both for consistency
with other drivers and actual type-checking.

> +
> +struct lp3943_pwm {
> +	struct pwm_chip chip;
> +	struct lp3943 *lp3943;
> +	struct lp3943_pwm_map *map[LP3943_NUM_PWMS];

Have you looked at associating this data with each struct pwm_device via
the .chip_data field? That's exactly why that field exists. The way you
use it is that during the driver probe or PWM request time you allocate
memory and attach it to the struct pwm_device using pwm_set_chip_data().

There should be no need to keep these arrays of variables, one for each
PWM channel.

> +	bool inversed[LP3943_NUM_PWMS];

The struct pwm_device already contains a .polarity field which contains
this information, so no need to keep another copy of it here.

> +static int lp3943_pwm_request(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct lp3943_pwm *lp3943_pwm =3D to_lp3943_pwm(chip);
> +	struct lp3943 *lp3943 =3D lp3943_pwm->lp3943;
> +	int num_outputs =3D lp3943_pwm->map[pwm->hwpwm]->num_outputs;
> +	int offset;
> +	int i;
> +
> +	for (i =3D 0; i < num_outputs; i++) {
> +		offset =3D lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
> +
> +		/* Return an error if the pin is already assigned */
> +		if (test_and_set_bit(offset, &lp3943->pin_used))
> +			return -EBUSY;
> +	}
> +
> +	return 0;
> +}

Instead of immediately accessing the lp3943 data structure within this
driver, I'd prefer to see a bit more encapsulation here. Something like
lp3943_request_pin() and lp3943_free_pin() perhaps?

> +static void lp3943_pwm_free(struct pwm_chip *chip, struct pwm_device *pw=
m)
> +{
> +	struct lp3943_pwm *lp3943_pwm =3D to_lp3943_pwm(chip);
> +	struct lp3943 *lp3943 =3D lp3943_pwm->lp3943;
> +	int num_outputs =3D lp3943_pwm->map[pwm->hwpwm]->num_outputs;
> +	int offset;
> +	int i;
> +
> +	for (i =3D 0; i < num_outputs; i++) {
> +		offset =3D lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
> +		clear_bit(offset, &lp3943->pin_used);
> +	}
> +}

Then this is where lp3943_free_pin() would be called to free up usage of
the specific pin.

> +
> +static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *p=
wm,
> +			int duty_ns, int period_ns)

Please indent properly. "int duty_ns" should be aligned with "struct
pwm_chip" using tabs and spaces. There are a few other instances of this
throughout the file, but I haven't mentioned them explicitly.

> +{
> +	struct lp3943_pwm *lp3943_pwm =3D to_lp3943_pwm(chip);
> +	struct lp3943 *lp3943 =3D lp3943_pwm->lp3943;
> +	u8 reg_prescale;
> +	u8 reg_duty;
> +	u8 val;

These three variables can all be declared on a single line.

> +	int err;
> +
> +	/*
> +	 * How to configure the LP3943 PWMs
> +	 *
> +	 * 1) Period =3D 6250 ~ 1600000
> +	 * 2) Prescale =3D period / 6250 -1
> +	 * 3) Duty =3D 'input duty'(normal) or 'period - duty'(inversed)
> +	 *
> +	 * Prescale and duty are register values
> +	 */
> +
> +	if (pwm->hwpwm =3D=3D 0) {
> +		reg_prescale =3D LP3943_REG_PRESCALE0;
> +		reg_duty     =3D LP3943_REG_PWM0;
> +	} else if (pwm->hwpwm =3D=3D 1) {
> +		reg_prescale =3D LP3943_REG_PRESCALE1;
> +		reg_duty     =3D LP3943_REG_PWM1;
> +	} else {
> +		return -EINVAL;
> +	}

I think you can drop this check. The core will not pass you a struct
pwm_device that has .hwpwm set to anything other than 0 or 1.

> +
> +	period_ns =3D clamp(period_ns, LP3943_MIN_PERIOD, LP3943_MAX_PERIOD);
> +	val       =3D (u8)(period_ns / LP3943_MIN_PERIOD - 1);
> +
> +	err =3D lp3943_write_byte(lp3943, reg_prescale, val);
> +	if (err)
> +		return err;
> +
> +	if (lp3943_pwm->inversed[pwm->hwpwm])
> +		val =3D (u8)((period_ns - duty_ns) * LP3943_MAX_DUTY / period_ns);
> +	else
> +		val =3D (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);

As I mentioned before, please don't do this.

> +
> +	return lp3943_write_byte(lp3943, reg_duty, val);
> +}
> +
> +static int lp3943_pwm_set_polarity(struct pwm_chip *chip,
> +			struct pwm_device *pwm, enum pwm_polarity polarity)
> +{
> +	struct lp3943_pwm *lp3943_pwm =3D to_lp3943_pwm(chip);
> +
> +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
> +		lp3943_pwm->inversed[pwm->hwpwm] =3D true;
> +	else
> +		lp3943_pwm->inversed[pwm->hwpwm] =3D false;
> +
> +	return 0;
> +}

And don't do this either. If the chip doesn't support inversing the
polarity, then don't implement this function.

> +static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *p=
wm)
> +{
> +	struct lp3943_pwm *lp3943_pwm =3D to_lp3943_pwm(chip);
> +	struct lp3943 *lp3943 =3D lp3943_pwm->lp3943;
> +	const struct lp3943_reg_cfg *mux =3D lp3943->mux_cfg;
> +	int num_outputs =3D lp3943_pwm->map[pwm->hwpwm]->num_outputs;
> +	int index;
> +	int err;
> +	int i;
> +	u8 val;
> +
> +	if (pwm->hwpwm =3D=3D 0)
> +		val =3D LP3943_DIM_PWM0;
> +	else if (pwm->hwpwm =3D=3D 1)
> +		val =3D LP3943_DIM_PWM1;
> +	else
> +		return -EINVAL;
> +
> +	/*
> +	 * Each PWM generator is set to control any of outputs of LP3943.
> +	 * To enable/disable the PWM, these output pins should be configured.
> +	 */
> +
> +	for (i =3D 0; i < num_outputs; i++) {
> +		index =3D lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
> +
> +		err =3D lp3943_update_bits(lp3943, mux[index].reg,
> +					mux[index].mask,
> +					val << mux[index].shift);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}

Does this really have to be done at enable time? The outputs are
statically configured at compile-time (or encoded in the DT), aren't
they? If so they can't be subsequently changed and therefore this could
be done earlier (in .probe() for instance).

Also this moves a lot of LP3943 internals into the PWM driver. I'd much
rather see this encapsulated in a function, such as lp3943_set_mode().

> +#ifdef CONFIG_OF
> +static int lp3943_pwm_parse_dt(struct device *dev, struct device_node *n=
ode,
> +			struct lp3943 *lp3943)

There's little use in passing the struct device_node explicitly since it
can easily be obtained from dev->of_node. Similarly you can obtain the
lp3943 pointer from dev_get_drvdata(dev->parent).

> +{
> +	const char *name[] =3D { "ti,pwm0", "ti,pwm1", };

static const?

> +	struct lp3943_platform_data *pdata;
> +	enum lp3943_pwm_output *output;
> +	struct lp3943_pwm_map *pwm_map;
> +	u32 num_outputs;
> +	int count =3D 0;
> +	int proplen;
> +	int err;
> +	int i;

These four variable can again be declared on a single line.

> +
> +	if (!node)
> +		return -EINVAL;
> +
> +	pdata =3D devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Configure the PWM output map from the device tree.
> +	 * Each PWM generator is connected to output channel(s).
> +	 */

This comment doesn't make much sense to me. Let me rephrase to see if I
understand correctly:

	/*
	 * Read the output map configuration from the device tree. Each
	 * of the two PWM generators can drive zero or more outputs.
	 */

> +
> +	for (i =3D 0; i < LP3943_NUM_PWMS; i++) {
> +		if (!of_get_property(node, name[i], &proplen))
> +			continue;
> +
> +		num_outputs =3D proplen / sizeof(u32);
> +		if (num_outputs =3D=3D 0)
> +			continue;
> +
> +		output =3D devm_kzalloc(dev, sizeof(*output) * num_outputs,
> +				GFP_KERNEL);
> +		if (!output)
> +			return -ENOMEM;
> +
> +		err =3D of_property_read_u32_array(node, name[i], output,
> +						num_outputs);
> +		if (err)
> +			return err;
> +
> +		pwm_map =3D devm_kzalloc(dev, sizeof(*pwm_map), GFP_KERNEL);
> +		if (!pwm_map)
> +			return -ENOMEM;
> +
> +		pwm_map->output =3D output;
> +		pwm_map->num_outputs =3D num_outputs;
> +
> +		if (i =3D=3D 0)
> +			pdata->pwm0 =3D pwm_map;
> +		else
> +			pdata->pwm1 =3D pwm_map;

Perhaps pwm0 and pwm1 should actually be turned into an array to make
the code more generic?

> +
> +		count++;
> +	}
> +
> +	if (count =3D=3D 0)
> +		return -ENODATA;
> +
> +	lp3943->pdata =3D pdata;

You're overwriting the pdata variable of the parent here. Is that really
what you want? I think it would be safer to either move that pdata to
the PWM driver and access it only from there, or parse the information
in the MFD driver and only read it in the PWM driver. Messing with the
fields of some other driver isn't generally a good thing.

> +	return 0;
> +}
> +#else
> +static int lp3943_pwm_parse_dt(struct device *dev, struct device_node *n=
ode)

This doesn't match the prototype from the OF case above.

> +{
> +	return -EINVAL;
> +}
> +#endif
> +
> +static int lp3943_pwm_probe(struct platform_device *pdev)
> +{
> +	struct lp3943 *lp3943 =3D dev_get_drvdata(pdev->dev.parent);
> +	struct lp3943_platform_data *pdata;
> +	struct lp3943_pwm *lp3943_pwm;
> +	int ret;
> +
> +	if (!lp3943->pdata) {
> +		ret =3D lp3943_pwm_parse_dt(&pdev->dev, pdev->dev.of_node,
> +					lp3943);

How about you turn this into something like:

	if (!lp3943->pdata) {
		if (IS_ENABLED(CONFIG_OF))
			ret =3D lp3943_pwm_parse_dt(&pdev->dev);
		else
			ret =3D -ENODEV;

Then you don't have to implement a dummy lp3943_pwm_parse_dt() above and
can drop the #ifdef CONFIG_OF as well. The compiler will notice that
IS_ENABLED(CONFIG_OF) is always false if OF is not selected and throw
away the whole lp3943_pwm_parse_dt() function. As a bonus, you get
complete compile coverage whether you enable OF or not.

> +		if (ret)
> +			return ret;
> +	}
> +
> +	pdata =3D lp3943->pdata;
> +
> +	lp3943_pwm =3D devm_kzalloc(&pdev->dev, sizeof(*lp3943_pwm), GFP_KERNEL=
);
> +	if (!lp3943_pwm)
> +		return -ENOMEM;
> +
> +	if (pdata->pwm0 && (pdata->pwm0->num_outputs > 0))
> +		lp3943_pwm->map[0] =3D pdata->pwm0;
> +
> +	if (pdata->pwm1 && (pdata->pwm1->num_outputs > 0))
> +		lp3943_pwm->map[1] =3D pdata->pwm1;

You seem to be copying all of the platform data to a PWM driver data
structure here, so there's no need to store it in lp3943->pdata. If you
only need that for compatibility with non-OF configurations, perhaps it
should be solved differently (using a local variable perhaps).

> +static int lp3943_pwm_remove(struct platform_device *pdev)
> +{
> +	struct lp3943_pwm *lp3943_pwm =3D platform_get_drvdata(pdev);
> +	return pwmchip_remove(&lp3943_pwm->chip);
> +}
> +
> +static const struct of_device_id lp3943_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "ti,lp3943-pwm", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, lp3943_pwm_dt_ids);

I think this requires #ifdef CONFIG_OF protection since you use
of_match_ptr() below.

> +static struct platform_driver lp3943_pwm_driver =3D {
> +	.probe =3D lp3943_pwm_probe,
> +	.remove =3D lp3943_pwm_remove,
> +	.driver =3D {
> +		.name =3D "lp3943-pwm",
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(lp3943_pwm_dt_ids),
> +	},
> +};
> +module_platform_driver(lp3943_pwm_driver);

Thierry

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC17SAAoJEN0jrNd/PrOhy04P/3OzTJhBbPetdimBKic4Dzxg
TdzJSDH2rsycRQjz1MGMb9Embg841NYjbCqTHvnKmJjDj33hWLdLTv7JzJ9BXMMO
YmmNd3/mTJ4dZZaxS8crUZoBchw2cP2EWPGbkiTzdScQeugj6rrCfM4M1aRZSvrU
qUtW1++I/m76hRbDb+s4YivFpJjdya96D+Np7bVWTJTOMhd9u+oKgUZ2A4mWU4Kt
cd9BTjOIj01daH+QovNJ3PJbFXxxsoDvnk7fAw8H88mNRLitfiG+Q2EUt7cKQNVD
CQmIiVd8gEAtm34oCCDwtVbU1ZlZFqQShb6thw/hYkwDkWLrrNU65XPe5KeOR1c0
cDfr8T2xZnsod2vA3njbJ6LF6leZlQBC7877HSHPzNlUgWqRDZrMCjZFan2Rq0+C
rN1iMiiAmCr9/KL/fc+k15Fx5hjC74ivrwOQyskHUGMEF/FLv6++HD15T1M2eudM
KrOiIw7e41SRZ0r628mGu/bO07FjvCh6ln9/+usHZchI32vjjzQQDIFeyW5Jwv6j
/SWT+W2R32fNauBgVLrS2RF/WkKFXya1VeUHfJ8bvNcDOOPijYWT/JkRIbL3tAz6
gV46J+rIynNKa5P7ocLlXCsNsU6loq0QS62nu4r5MnI/srk4cgWQ+mrb80yPY5+7
cur3QXL21mCEuGocrDIK
=Cge9
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
