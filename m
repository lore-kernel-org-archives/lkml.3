Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3HSVVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:21:01 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45115 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3HSVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:20:59 -0400
Date: Mon, 19 Aug 2013 23:20:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] pwm: atmel-pwm: add pwm controller driver
Message-ID: <20130819212054.GA9885@mithrandir>
References: <1376881866-14214-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1376881866-14214-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 11:11:06AM +0800, Bo Shen wrote:
> add atmel pwm controller driver based on PWM framework
>=20
> this is basic function implementation of pwm controller
> it can work with pwm based led and backlight

Please use the proper spelling "PWM" in prose. Variable names and such
should be "pwm", though. Also sentences should start with a capital
letter and end with a full stop ('.').

> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>=20
> ---
> This patch is based on Linux v3.11 rc6

It's usually safer to work on top of the latest subsystem branch because
it may contain patches that influence your patch as well. For most
subsystems that branch is merged into linux-next, so that usually works
well as the basis when writing patches.

> diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Docume=
ntation/devicetree/bindings/pwm/atmel-pwm.txt
[...]
> +  - #pwm-cells: Should be 3.
> +    - The first cell specifies the per-chip index of the PWM to use
> +    - The second cell is the period in nanoseconds
> +    - The third cell is used to encode the polarity of PWM output

For instance, patches were recently added to make the description of
this property more consistent across the bindings documentation of PWM
drivers. The more canonical form now is:

 - #pwm-cells: Should be 3. See pwm.txt in this directory for a
   description of the cells format.

> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
[...]
> +#define PWM_MR		0x00

This doesn't seem to be used.

> +#define PWM_ENA		0x04
> +#define PWM_DIS		0x08
> +#define PWM_SR		0x0C

Perhaps it'd be useful to add a comment that the above are global
registers and the ones below are per-channel.

> +#define PWM_CMR		0x00
> +
> +/* The following register for PWM v1 */
> +#define PWMv1_CDTY	0x04
> +#define PWMv1_CPRD	0x08
> +#define PWMv1_CUPD	0x10
> +
> +/* The following register for PWM v2 */
> +#define PWMv2_CDTY	0x04
> +#define PWMv2_CDTYUPD	0x08
> +#define PWMv2_CPRD	0x0C
> +#define PWMv2_CPRDUPD	0x10
> +
> +#define PWM_NUM		4

The only place where this is used is in the .probe() function, so you
can just as well drop it.

> +struct atmel_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +
> +	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
> +			unsigned int dty, unsigned int prd);

Please use the same parameter names as the PWM core for consistency.

> +};
> +
> +#define to_atmel_pwm_chip(chip) container_of(chip, struct atmel_pwm_chip=
, chip)

This should be a static inline function so that types are properly
checked

> +
> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip, int offse=
t)

"offset" is usually unsigned long.

> +{
> +	return readl(chip->base + offset);
> +}
> +
> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip, int off=
set,
> +		u32 val)

And "value" is usually also unsigned long.

> +{
> +	writel(val, chip->base + offset);
> +}
> +
> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip, int ch,
> +		int offset)

"channel" can be unsigned int, and "offset" unsigned long again. Also
the alignment is wrong here. The arguments continued on a new line
should be aligned with the arguments on the previous line.

> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +		int duty_ns, int period_ns)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	unsigned long long val, prd, dty;
> +	unsigned long long div, clk_rate;

All of these unsigned long long can be declared on one line.

> +	int ret, pres =3D 0;
> +
> +	clk_rate =3D clk_get_rate(atmel_pwm->clk);
> +
> +	while (1) {
> +		div =3D 1000000000;
> +		div *=3D 1 << pres;
> +		val =3D clk_rate * period_ns;
> +		prd =3D div_u64(val, div);
> +		val =3D clk_rate * duty_ns;
> +		dty =3D div_u64(val, div);
> +
> +		if (prd < 0x0001 || dty < 0x0)
> +			return -EINVAL;

I find the usage of hexadecimal literals a bit strange here. Perhaps
just change this to:

		if (prd < 1 || dty < 0)

> +		if (prd > 0xffff || dty > 0xffff) {

This makes some sense, because I would assume that these are restricted
by register fields. Might be good to add a comment to that effect,
though.

> +			if (++pres > 0x10)
> +				return -EINVAL;

But here again, I think writing:

			if (++pres > 16)

would be clearer.

> +	/* Enable clock */
> +	ret =3D clk_prepare_enable(atmel_pwm->clk);

You should probably call clk_prepare() in .probe() already and only call
clk_enable() here. The reason is that clk_get_rate() might actually fail
if you haven't called clk_prepare() on it. Furthermore clk_prepare()
potentially involves a lot more than clk_enable() so it makes sense to
call it earlier, where the delay doesn't matter.

> +	if (ret) {
> +		pr_err("failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	atmel_pwm->config(atmel_pwm, pwm, dty, prd);
> +
> +	/* Check whether need to disable clock */
> +	val =3D atmel_pwm_readl(atmel_pwm, PWM_SR);
> +	if ((val & 0xf) =3D=3D 0)

Can we have a symbolic name for the 0xf constant here?

> +		clk_disable_unprepare(atmel_pwm->clk);

Similarly this should just call clk_disable() and .remove() should call
clk_unprepare().

> +static void atmel_pwm_config_v1(struct atmel_pwm_chip *atmel_pwm,
> +		struct pwm_device *pwm, unsigned int dty, unsigned int prd)

Parameter alignment again.

> +{
> +	unsigned int val;
> +
> +	/*
> +	 * if the pwm channel is enabled, using update register to update
> +	 * related register value, or else write it directly
> +	 */

This comment is somewhat confusing, can you rewrite it to make it more
clear what is meant?

> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CUPD, dty);
> +
> +		val =3D atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
> +		val &=3D ~(1 << 10);

Symbolic constant for 1 << 10, please.

> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CPRD, prd);
> +	}
> +}
> +
> +static void atmel_pwm_config_v2(struct atmel_pwm_chip *atmel_pwm,
> +		struct pwm_device *pwm, unsigned int dty, unsigned int prd)
> +{
> +	/*
> +	 * if the pwm channel is enabled, using update register to update
> +	 * related register value, or else write it directly
> +	 */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTYUPD, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRDUPD, prd);
> +	} else {
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTY, dty);
> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRD, prd);
> +	}
> +}

Same comments as for atmel_pwm_config_v1().

> +
> +static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_devi=
ce *pwm,
> +		enum pwm_polarity polarity)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	u32 val =3D 0;
> +	int ret;
> +
> +	/* Enable clock */
> +	ret =3D clk_prepare_enable(atmel_pwm->clk);

That comment doesn't add anything valuable. Also split clk_prepare() and
clk_enable() again.

> +	if (ret) {
> +		pr_err("failed to enable pwm clock\n");
> +		return ret;
> +	}
> +
> +	if (polarity =3D=3D PWM_POLARITY_NORMAL)
> +		val &=3D ~(1 << 9);
> +	else
> +		val |=3D 1 << 9;

1 << 9 should be a symbolic constant.

> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
> +
> +	/* Disable clock */
> +	clk_disable_unprepare(atmel_pwm->clk);

That comment isn't useful either.

> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> +	u32 val;
> +
> +	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
> +
> +	/* Disable clock */
> +	val =3D atmel_pwm_readl(atmel_pwm, PWM_SR);
> +	if ((val & 0xf) =3D=3D 0)
> +		clk_disable_unprepare(atmel_pwm->clk);

The intent of this would be much clearer if 0xf was a symbolic constant.

> +}
> +struct atmel_pwm_data {
> +	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
> +			unsigned int dty, unsigned int prd);
> +};

I think it would be nicer to use the same parameter names as the PWM
core uses.

> +static struct atmel_pwm_data atmel_pwm_data_v1 =3D {
> +	.config =3D atmel_pwm_config_v1,
> +};
> +
> +static struct atmel_pwm_data atmel_pwm_data_v2 =3D {
> +	.config =3D atmel_pwm_config_v2,
> +};

Can both of these not be "static const"?

> +static const struct of_device_id atmel_pwm_dt_ids[] =3D {
> +	{
> +		.compatible =3D "atmel,at91sam9rl-pwm",
> +		.data =3D &atmel_pwm_data_v1,
> +	}, {
> +		.compatible =3D "atmel,sama5-pwm",
> +		.data =3D &atmel_pwm_data_v2,
> +	}, {
> +		/* sentinel */
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);

Given that you use of_match_ptr() in the driver structure, you should
probably protect this using #ifdef CONFIG_OF, otherwise non-OF builds
will warn about this table being unused.

> +	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl)) {
> +		dev_err(&pdev->dev, "failed get pinctrl\n");
> +		return PTR_ERR(pinctrl);
> +	}

That should be taken care of by the core and therefore not needed to be
done by the driver explicitly. When you remove this, make sure to remove
the linux/pinctrl/consumer.h include along with it.

> +	atmel_pwm =3D devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
> +	if (!atmel_pwm) {
> +		dev_err(&pdev->dev, "out of memory\n");
> +		return -ENOMEM;
> +	}

I don't think that error message provides a lot of useful information.
If the probe() function fails then the core will output an error message
that includes the error code, so the reason for the failure can easily
be reconstructed from that already.

> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		return -ENODEV;
> +	}

devm_ioremap_resource() checks for the validity of the res parameter, so
you can drop the checks here.

> +	atmel_pwm->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(atmel_pwm->base)) {
> +		dev_err(&pdev->dev, "ioremap failed\n");

devm_ioremap_resource() provides it's own error messages, so you don't
have to duplicate it here.

> +	atmel_pwm->clk =3D devm_clk_get(&pdev->dev, "pwm_clk");

If this is the only clock that the driver uses, why do you need to
specify the consumer ID at all? Doesn't a simple:

	atmel_pwm->clk =3D devm_clk_get(&pdev->dev, NULL);

work?

> +	dev_info(&pdev->dev, "successfully register pwm\n");

That's not necessary. You should provide an error message if probing
failed. If everything went as expected there's no need to be verbose.

> +MODULE_LICENSE("GPL v2");

I think that "GPL v2" means "GPL v2", not "GPL v2 (and later)" and
therefore is in conflict with the license note in the file header.

Thierry

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEow1AAoJEN0jrNd/PrOhc44QAK0xjBlz7Ma+fvScGaYBa7VN
sEN0yYMg/aPIvwFQdMqyAZ/2pibBWWTFIPAR8fV/b5mPKEMChCXT9NT2C7RE1My8
2gm6mFpiwuKAr9UqAUgqSC1m7wYOe3xS2NlLxhoaQrCPopQJF7rNnsFAHBPfYhZa
N5vTDAlDNT1CT+bjAl5c1F5kbiD/t+IzEnhmSQ+wxOTBfPEztEK9E8NYKeOP3HJm
ncjfYIApWf1xQWp5YoTq6Ghh6LZf/CkKnvrWN3+QKNwv/avZtrdlUEGT9rh5/472
FCFf5VGHiYqLH/xlRQoe3j8HlPtRaG+g3/bVdrWfbhxwU4GqK6SQ6cm2ur50ltEw
usw7KjRVykmMruCgGiMpZrqAk3433YQ6aii7KF8Wd7UA4OPVu0dgG18g7jzVQmze
6Hj1R8Kuz2NAs4McpW04DApDwUYc3G9Lt24F1cUeqowPoIVl1xkBAKpVRfsVrf7y
kK4Bd1StxvE2gc3rVxCf+9A6IcrbBUebKx4SoxJEDQwuYmulEcD49UQDbZJ3Q0aA
uB+xD4TkC9QiZAFZF1jVb+NVflu6Zsz7xk8Ru8RGmXZVpCE2PXPht+A9MaKCrjip
Vx2GClsDw0wdknhh7l76jZpRSn7yhM+zs/L+du245EDWi5/pC56uS2TF5W+8AhOq
Gf+aWVW3belR5PhMPJJe
=tnmj
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
