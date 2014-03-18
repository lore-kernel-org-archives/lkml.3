Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbaCRVxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:53:35 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47075 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbaCRVwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:52:37 -0400
Date: Tue, 18 Mar 2014 22:52:32 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/5] pwm: kona: Introduce Kona PWM controller support
Message-ID: <20140318215231.GH5917@mithrandir>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
 <1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Content-Disposition: inline
In-Reply-To: <1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 01:15:43PM -0700, Tim Kryger wrote:
[...]
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 22f2f28..1fd42af 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -62,6 +62,16 @@ config PWM_ATMEL_TCB
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-atmel-tcb.
> =20
> +config PWM_BCM_KONA
> +	tristate "Kona PWM support"
> +	depends on ARCH_BCM_MOBILE
> +	default y

No "default y", please.

> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
[...]
> +static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int =
chan)
> +{
> +	unsigned long value =3D readl(kp->base + PWM_CONTROL_OFFSET);
> +
> +	/*
> +	 * New duty and period settings are only reflected in the PWM output
> +	 * after a rising edge of the enable bit.  When smooth bit is set, the
> +	 * new settings are delayed until the prior PWM period has completed.
> +	 * Furthermore, if the smooth bit is set, the PWM continues to output a
> +	 * waveform based on the old settings during the time that the enable
> +	 * bit is low.  Otherwise the output is a constant high signal while
> +	 * the enable bit is low.
> +	 */
> +
> +	/* clear enable bit but set smooth bit to maintain old output */
> +	value |=3D (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));

There's no need for the parentheses here.

> +	value &=3D ~(1 << PWM_CONTROL_ENABLE_SHIFT(chan));
> +	writel(value, kp->base + PWM_CONTROL_OFFSET);
> +
> +	/* set enable bit and clear smooth bit to apply new settings */
> +	value &=3D ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
> +	value |=3D (1 << PWM_CONTROL_ENABLE_SHIFT(chan));

Nor here.

> +	writel(value, kp->base + PWM_CONTROL_OFFSET);

I'm curious about how this work. The above writes the control register
once with smooth set and enable cleared, then immediately rewrites it
again with smooth cleared and enable set. Are these writes somehow
queued in hardware, so that the subsequent write becomes active only
after the current period?

> +static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +				int duty_ns, int period_ns)

Please align arguments on subsequent lines with those on the first line.

> +{
> +	struct kona_pwmc *kp =3D dev_get_drvdata(chip->dev);

The proper way to do this would be upcasting using container_of().
Better yet, define a static inline function that wraps container_of(),
just like very other driver does.

> +	u64 val, div, clk_rate;
> +	unsigned long prescale =3D PRESCALE_MIN, pc, dc;
> +	unsigned int value, chan =3D pwm->hwpwm;
> +
> +	/*
> +	 * Find period count, duty count and prescale to suit duty_ns and
> +	 * period_ns. This is done according to formulas described below:
> +	 *
> +	 * period_ns =3D 10^9 * (PRESCALE + 1) * PC / PWM_CLK_RATE
> +	 * duty_ns =3D 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
> +	 *
> +	 * PC =3D (PWM_CLK_RATE * period_ns) / (10^9 * (PRESCALE + 1))
> +	 * DC =3D (PWM_CLK_RATE * duty_ns) / (10^9 * (PRESCALE + 1))
> +	 */
> +
> +	clk_rate =3D clk_get_rate(kp->clk);

"rate" is 50% shorter and would do equally well.

> +
> +	/* There is polarity support in HW but it is easier to manage in SW */
> +	if (pwm->polarity =3D=3D PWM_POLARITY_INVERSED)
> +		duty_ns =3D period_ns - duty_ns;

No, this is wrong. You're not actually changing the *polarity* here.

Also I think this is missing a pair of clk_prepare_enable() and
clk_disable_unprepare().

> +static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_devi=
ce *pwm,
> +				  enum pwm_polarity polarity)
> +{
> +	/*
> +	 * The framework only allows the polarity to be changed when a PWM is
> +	 * disabled so no immediate action is required here.  When a channel is
> +	 * enabled, the polarity gets handled as part of the re-config step.
> +	 */
> +
> +	return 0;
> +}

See above. If you don't want to implement the hardware support for
inversed polarity, then simply don't implement this.

> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pw=
m)
> +{
> +	struct kona_pwmc *kp =3D dev_get_drvdata(chip->dev);
> +	int ret;
> +
> +	/*
> +	 * The PWM framework does not clear the enable bit in the flags if an
> +	 * error is returned from a PWM driver's enable function so it must be
> +	 * cleared here if any trouble is encountered.
> +	 */
> +
> +	ret =3D clk_prepare_enable(kp->clk);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "failed to enable clock: %d\n", ret);
> +		clear_bit(PWMF_ENABLED, &pwm->flags);

You're not supposed to touch these. This is a bug in the core, and it
should be fixed in the core.

> +		return ret;
> +	}
> +
> +	ret =3D kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
> +	if (ret < 0) {
> +		clk_disable_unprepare(kp->clk);
> +		clear_bit(PWMF_ENABLED, &pwm->flags);
> +		return ret;
> +	}

Why are you doing this? .config() should be setting everything up
according to the given duty cycle and period and .enable() should only
be enabling a specific channel. Please don't conflate the two.

> +static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct kona_pwmc *kp =3D dev_get_drvdata(chip->dev);
> +	unsigned int chan =3D pwm->hwpwm;
> +
> +	/*
> +	 * The "enable" bits in the control register only affect when settings
> +	 * start to take effect so the only real way to disable the PWM output
> +	 * is to program a zero duty cycle.
> +	 */

What's wrong about waiting for the settings to take effect? There's
nothing about disable that says it should happen *immediately*.

> +
> +	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
> +	kona_pwmc_apply_settings(kp, chan);
> +
> +	/*
> +	 * When the PWM clock is disabled, the output is pegged high or low
> +	 * depending on its state at that instant.  To guarantee that the new
> +	 * settings have taken effect and the output is low a delay of 400ns is
> +	 * required.
> +	 */
> +
> +	ndelay(400);

Where does this number come from?

> +static int kona_pwmc_probe(struct platform_device *pdev)
> +{
> +	struct kona_pwmc *kp;
> +	struct resource *res;
> +	unsigned int chan, value;
[...]
> +	/* Set smooth mode, push/pull, and normal polarity for all channels */
> +	for (value =3D 0, chan =3D 0; chan < kp->chip.npwm; chan++) {

Can't you initialize value to 0 when you declare it? That way the for
loop becomes much more idiomatic.

> +		value |=3D (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
> +		value |=3D (1 << PWM_CONTROL_TYPE_SHIFT(chan));
> +		value |=3D (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
> +	}
> +	writel(value, kp->base + PWM_CONTROL_OFFSET);

I'd prefer a blank line between the above two for readability.

> +static struct platform_driver kona_pwmc_driver =3D {
> +

Gratuitous blank line.

> +	.driver =3D {
> +		.name =3D "bcm-kona-pwm",
> +		.of_match_table =3D bcm_kona_pwmc_dt,
> +	},
> +	.probe =3D kona_pwmc_probe,
> +	.remove =3D kona_pwmc_remove,
> +};
> +

And here.

> +module_platform_driver(kona_pwmc_driver);
> +
> +MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.c=
om>");
> +MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");
> +MODULE_DESCRIPTION("Driver for Kona PWM controller");

Perhaps "Broadcom Kona PWM"?

Thierry

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKMAfAAoJEN0jrNd/PrOh4jQP/2odnLmSg16B3QgPA/DZkZGl
7/j0LSH26gNzBuI4Yc8+gubY+f7CWO8CMS74JNIaBsir9YalVM38evnPAnAD8Xmz
fd8sXlAIakjlNtgmYulUYt5b1BX2SQBeDruLSydmbpD9Dq7Z5XjQyRCl/h2nBDTO
Qsnz7OEywCrn/mOP2l0g6L6JDI5jywVGV560NNQECXjYjRjjI8ueHn97IvtO3PVD
Ej7vwK6ApDHtmCPS9u++AwkyuMATsEBNjXElQYi5X4nnTnKht3WzZHBqL2PXWAoU
aKNsMCzBKhG2Usit6kjYlagCaYTQkkY6lbRv+8Eoa69tM5wbtU8rp/CGTcEqmJwH
t0jJ/yMsm5e7Hn8fJvSVWyzMrA7bqxoS2fN48XMZAyXM8pUx3zr1GoyVp7gpkTGZ
uYBdRP2aDL7RxwSK3ry5HPq5xr5gsQXMj7ZoSQW+knQsWzBrD3xgzrP020q4eciS
b1xQFFpIzgPUnqK8lgGUx/hRM+ewbqTiD/+NnbBdpH7hoecBHbyLW5cuDElyWXsX
+xj5HP7+pW+sIcLsMTC95cNRbvpz9hhVhLY3iocART5SodG+YBSzVAFAMyfoOwC5
DKiHkIxsaOq6Ty+GO5W0Kz9Qhy0F6vnNYirVV973AGN1D5S/cjeriZ7mqR/EtHeb
210zuKWZKrxn/9yVk7da
=EcSh
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--
