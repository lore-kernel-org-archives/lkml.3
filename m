Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaJGOPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:15:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46248 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaJGOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:15:15 -0400
Message-ID: <5433F551.7090507@pengutronix.de>
Date: Tue, 07 Oct 2014 16:14:41 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com
CC: matt.porter@linaro.org, linux-rpi-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v6]pwm: add BCM2835 PWM driver
References: <1412690665-15416-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1412690665-15416-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="adFDEmWTepV8xLaWN3g5sr3kvasevGw7I"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--adFDEmWTepV8xLaWN3g5sr3kvasevGw7I
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/07/2014 04:04 PM, Bart Tanghe wrote:
> Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)

> --- /dev/null
> +++ b/drivers/pwm/pwm-bcm2835.c
> @@ -0,0 +1,201 @@
> +/*
> + * Copyright 2014 Bart Tanghe <bart.tanghe@thomasmore.be>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; version 2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +#define DUTY		0x14
> +#define PERIOD		0x10
> +#define CHANNEL	0x10
> +
> +#define PWM_ENABLE	(1 << 0)
> +#define PWM_POLARITY	(1 << 4)
> +
> +#define PWM_CONTROL_MASK	0xff
> +#define PWM_MODE		0x80		/* set timer in pwm mode */
> +#define DEFAULT		0xff		/* set timer in default mode */
> +#define PWM_CONTROL_STRIDE	8
> +#define MIN_PERIOD		108		/* 9.2Mhz max pwm clock */
> +
> +struct bcm2835_pwm {
> +	struct pwm_chip chip;
> +	struct device *dev;
> +	int channel;
> +	unsigned long scaler;
> +	void __iomem *base;
> +	struct clk *clk;
> +};
> +
> +static inline struct bcm2835_pwm  *to_bcm2835_pwm(struct pwm_chip *chi=
p)
                                   ^^
nitpick: on space is enough

> +{
> +	return container_of(chip, struct bcm2835_pwm, chip);
> +}
> +

[...]

> +static int bcm2835_pwm_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_pwm *pwm;
> +	int ret;
> +	struct resource *r;
> +	struct clk *clk;
> +
> +	pwm =3D devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
> +	if (!pwm)
> +		return -ENOMEM;
> +
> +	pwm->dev =3D &pdev->dev;
> +
> +	clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "no clock found: %ld\n", PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
> +
> +	pwm->clk =3D clk;
> +	ret =3D clk_prepare_enable(pwm->clk);
> +	if (ret) {
> +		clk_disable_unprepare(pwm->clk);

If enabling of the clock fails, don't disable it.

> +		return ret;
> +	}
> +
> +	pwm->scaler =3D NSEC_PER_SEC / clk_get_rate(clk);
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pwm->base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(pwm->base))
> +		return PTR_ERR(pwm->base);

Here you should disable the clock instead.

> +
> +	pwm->chip.dev =3D &pdev->dev;
> +	pwm->chip.ops =3D &bcm2835_pwm_ops;
> +	pwm->chip.npwm =3D 2;
> +
> +	platform_set_drvdata(pdev, pwm);
> +
> +	ret =3D pwmchip_add(&pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		return ret;

and here....or better introduce a disable_clock jump-label at end of
this function.

> +	}
> +	return 0;
> +}

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--adFDEmWTepV8xLaWN3g5sr3kvasevGw7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlQz9VEACgkQjTAFq1RaXHPG/wCfcLq5erkfjuPprqLzpF9SwN7a
cEIAn2Ej4q531zvAv+Vj+b0qn6wrenqO
=PRMb
-----END PGP SIGNATURE-----

--adFDEmWTepV8xLaWN3g5sr3kvasevGw7I--
