Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaHGGSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:18:50 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:45257 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaHGGSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:18:47 -0400
Date: Thu, 7 Aug 2014 08:18:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, b.galvani@gmail.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
        galak@codeaurora.org, cf@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        hj@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
Message-ID: <20140807061842.GB17340@ulmo>
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>
 <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 06:21:35PM +0800, Caesar Wang wrote:
> This patch added to support the PWM controller found on
> RK3288 SoC.
>=20
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  drivers/pwm/pwm-rockchip.c | 124 ++++++++++++++++++++++++++++++++++++++-=
------
>  1 file changed, 105 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
> index eec2145..59c2513 100644
> --- a/drivers/pwm/pwm-rockchip.c
> +++ b/drivers/pwm/pwm-rockchip.c
> @@ -2,6 +2,7 @@
>   * PWM driver for Rockchip SoCs
>   *
>   * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
> + * Copyright (C) 2014 ROCKCHIP, Inc.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -12,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/pwm.h>
>  #include <linux/time.h>
> @@ -25,17 +27,72 @@
> =20
>  #define PRESCALER		2
> =20
> +#define PWM_ENABLE		(1 << 0)
> +#define PWM_CONTINUOUS		(1 << 1)
> +#define PWM_DUTY_POSITIVE	(1 << 3)
> +#define PWM_INACTIVE_NEGATIVE	(0 << 4)
> +#define PWM_OUTPUT_LEFT		(0 << 5)
> +#define PWM_LP_DISABLE		(0 << 8)
> +
>  struct rockchip_pwm_chip {
>  	struct pwm_chip chip;
>  	struct clk *clk;
> +	const struct rockchip_pwm_data *data;
>  	void __iomem *base;
>  };
> =20
> +struct rockchip_pwm_regs {
> +	unsigned long duty;
> +	unsigned long period;
> +	unsigned long cntr;
> +	unsigned long ctrl;
> +};
> +
> +struct rockchip_pwm_data {
> +	struct rockchip_pwm_regs regs;
> +	unsigned int prescaler;
> +
> +	void (*set_enable)(struct pwm_chip *chip, bool enable);
> +};
> +
>  static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_=
chip *c)
>  {
>  	return container_of(c, struct rockchip_pwm_chip, chip);
>  }
> =20
> +static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enabl=
e)
> +{
> +	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> +	u32 val =3D 0;
> +	u32 enable_conf =3D PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
> +
> +	val =3D readl_relaxed(pc->base + pc->data->regs.ctrl);
> +
> +	if (enable)
> +		val |=3D enable_conf;
> +	else
> +		val &=3D ~enable_conf;
> +
> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
> +}
> +
> +static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enabl=
e)
> +{
> +	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> +	u32 val =3D 0;
> +	u32 enable_conf =3D PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
> +		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
> +
> +	val =3D readl_relaxed(pc->base + pc->data->regs.ctrl);
> +
> +	if (enable)
> +		val |=3D enable_conf;
> +	else
> +		val &=3D ~enable_conf;
> +
> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
> +}
> +
>  static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device =
*pwm,
>  			       int duty_ns, int period_ns)
>  {
> @@ -52,20 +109,20 @@ static int rockchip_pwm_config(struct pwm_chip *chip=
, struct pwm_device *pwm,
>  	 * default prescaler value for all practical clock rate values.
>  	 */
>  	div =3D clk_rate * period_ns;
> -	do_div(div, PRESCALER * NSEC_PER_SEC);
> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>  	period =3D div;
> =20
>  	div =3D clk_rate * duty_ns;
> -	do_div(div, PRESCALER * NSEC_PER_SEC);
> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>  	duty =3D div;
> =20
>  	ret =3D clk_enable(pc->clk);
>  	if (ret)
>  		return ret;
> =20
> -	writel(period, pc->base + PWM_LRC);
> -	writel(duty, pc->base + PWM_HRC);
> -	writel(0, pc->base + PWM_CNTR);
> +	writel(period, pc->base + pc->data->regs.period);
> +	writel(duty, pc->base + pc->data->regs.duty);
> +	writel(0, pc->base + pc->data->regs.cntr);
> =20
>  	clk_disable(pc->clk);
> =20
> @@ -76,15 +133,12 @@ static int rockchip_pwm_enable(struct pwm_chip *chip=
, struct pwm_device *pwm)
>  {
>  	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
>  	int ret;
> -	u32 val;
> =20
>  	ret =3D clk_enable(pc->clk);
>  	if (ret)
>  		return ret;
> =20
> -	val =3D readl_relaxed(pc->base + PWM_CTRL);
> -	val |=3D PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
> -	writel_relaxed(val, pc->base + PWM_CTRL);
> +	pc->data->set_enable(chip, true);
> =20
>  	return 0;
>  }
> @@ -92,11 +146,8 @@ static int rockchip_pwm_enable(struct pwm_chip *chip,=
 struct pwm_device *pwm)
>  static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_devic=
e *pwm)
>  {
>  	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> -	u32 val;
> =20
> -	val =3D readl_relaxed(pc->base + PWM_CTRL);
> -	val &=3D ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
> -	writel_relaxed(val, pc->base + PWM_CTRL);
> +	pc->data->set_enable(chip, false);
> =20
>  	clk_disable(pc->clk);
>  }
> @@ -108,12 +159,52 @@ static const struct pwm_ops rockchip_pwm_ops =3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> +static const struct rockchip_pwm_data pwm_data_v1 =3D {
> +	.regs.duty =3D PWM_HRC,
> +	.regs.period =3D PWM_LRC,
> +	.regs.cntr =3D PWM_CNTR,
> +	.regs.ctrl =3D PWM_CTRL,

Perhaps a slightly more idiomatic way to write this would be:

	static const struct rockchip_pwm_data pwm_data_v1 =3D {
		.regs =3D {
			.duty =3D PWM_HRC,
			.period =3D PWM_LRC,
			.cntr =3D PWM_CNTR,
			.ctrl =3D PWM_CTRL,
		},
		...
	};

And similar for the v2 and vop structures. And like I said in another
reply, since the defines are now only used in this structure it's a
little redundant to give them symbolic names, so the above could equally
well be:

	static const struct rockchip_pwm_data pwm_data_v1 =3D {
		.regs =3D {
			.duty =3D 0x04,
			.period =3D 0x08,
			.cntr =3D 0x00,
			.ctrl =3D 0x0c,
		},
		...
	};

> +	.prescaler =3D PRESCALER,

Similarly for the prescaler value, it can now simply be 2 here.

> +	.set_enable =3D rockchip_pwm_set_enable_v1,
> +};
> +
> +static const struct rockchip_pwm_data pwm_data_v2 =3D {
> +	.regs.duty =3D PWM_LRC,
> +	.regs.period =3D PWM_HRC,
> +	.regs.cntr =3D PWM_CNTR,
> +	.regs.ctrl =3D PWM_CTRL,
> +	.prescaler =3D PRESCALER-1,

And 1 here.

> +	.set_enable =3D rockchip_pwm_set_enable_v2,
> +};
> +
> +static const struct rockchip_pwm_data pwm_data_vop =3D {
> +	.regs.duty =3D PWM_LRC,
> +	.regs.period =3D PWM_HRC,
> +	.regs.cntr =3D PWM_CTRL,
> +	.regs.ctrl =3D PWM_CNTR,
> +	.prescaler =3D PRESCALER-1,

And 1 here.

> +	.set_enable =3D rockchip_pwm_set_enable_v2,
> +};

No need for the double indirection.

Thierry

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4xpCAAoJEN0jrNd/PrOh1osP/0XeppGhztOMMbHaqkuH87ig
/vxqdFA6YE7MQ7FaPoJHB9jP8g3/isx+9WtVKldljSgBuIvj7JmRK2wAACWuISWk
jPrINVDCJlcE2RrPTus49SZq/RNifBYG1SwtJWubbH+S+EoDGvpLR86Hh0+mvkxk
LrD4T77x2fCaY1PhCiNFzxBZilGVktJYmeRCF1c0t32wn/2GFaCPr5hXasjZH/Kz
4StNthRqGiYHvUxOdLuJQnJrVWBNt8D7bejD1IDP7jcnF5ftCng44mRHm6BfDMyw
u/GjbHmlP9XT6BqVqXoS+Qf3R2MGN7G50jl8WL7PqG8WwD27oiqnu2aiR+3ZF08I
WyPdeIvu8QNFMpr/i7ACPbPmGi0lMJwXP5o5NIZxR+yQxdjGu0+6ZnDgCFM6IWdw
yBpa1c+j0dx75igrfpDcwkige6EUAXZcQx4PvX/TfhSHzzwyj0Kf6xpjz47c8ckG
B10r1efmToLSGV2XuywLi0tpbW9hazAzWYShnHBUVKXOyTO7lWUjEL9J5Rt5NEzZ
tvfilhj4eVS2/ADRzFQ5pKtiLXfvrtwR9OV/Uvv8R10eTHQ3Z6Zic+JF7xhItsFw
mBJPuVVVvlFUWCsrgXZiw2rTcONiaZADxA/2VFzjuLhe948if7iVcBJf7Z0g7zrW
aMziaTNnqqBqm93hv60X
=SH2a
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
