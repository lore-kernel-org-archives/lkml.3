Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaI2PWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:22:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaI2PWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:22:01 -0400
Message-ID: <542978F7.5030405@pengutronix.de>
Date: Mon, 29 Sep 2014 17:21:27 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com
CC: matt.porter@linaro.org, linux-rpi-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [resend rfc v4]pwm: add BCM2835 PWM driver
References: <1412001619-30001-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1412001619-30001-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iF6iCCHuSwDQrkSjUVBaut6ROGfWMCiOg"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iF6iCCHuSwDQrkSjUVBaut6ROGfWMCiOg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/29/2014 04:40 PM, Bart Tanghe wrote:
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
> +	clk =3D clk_get(&pdev->dev, NULL);

Better use devm_, as you don't free the clock in case of an error and
during remove()

> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "no clock found: %ld\n", PTR_ERR(clk));
> +		return PTR_ERR(clk);
> +	}
> +
> +	pwm->clk =3D clk;
> +	clk_prepare_enable(pwm->clk);

Please check the return value of clk_prepare_enable()

> +	pwm->scaler =3D NSEC_PER_SEC / clk_get_rate(clk);
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pwm->base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(pwm->base))
> +		return PTR_ERR(pwm->base);
> +
> +	pwm->chip.dev =3D &pdev->dev;
> +	pwm->chip.ops =3D &bcm2835_pwm_ops;
> +	pwm->chip.npwm =3D 2;
> +
> +	ret =3D pwmchip_add(&pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		return -1;

Please propagate the error vlaue:

    return ret;

> +	}
> +	platform_set_drvdata(pdev, pwm);

Better do this before pwmchip_add()

> +	return 0;
> +}
> +
> +static int bcm2835_pwm_remove(struct platform_device *pdev)
> +{
> +	struct bcm2835_pwm *pc =3D platform_get_drvdata(pdev);
> +	clk_disable_unprepare(pc->clk);
> +	return pwmchip_remove(&pc->chip);
> +}
> +
> +static const struct of_device_id bcm2835_pwm_of_match[] =3D {
> +	{ .compatible =3D "brcm,bcm2835-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, bcm2835_pwm_of_match);
> +
> +static struct platform_driver bcm2835_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "bcm2835-pwm",
> +		.of_match_table =3D bcm2835_pwm_of_match,
> +	},
> +	.probe =3D bcm2835_pwm_probe,
> +	.remove =3D bcm2835_pwm_remove,
> +};
> +module_platform_driver(bcm2835_pwm_driver);
> +
> +MODULE_AUTHOR("Bart Tanghe <bart.tanghe@thomasmore.be");
> +MODULE_DESCRIPTION("Broadcom BCM2835 PWM driver");
> +MODULE_LICENSE("GPL v2");

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--iF6iCCHuSwDQrkSjUVBaut6ROGfWMCiOg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlQpePcACgkQjTAFq1RaXHNQnwCfQEUOMCnhCfn0IolMHzvmoCBw
EKIAniPg3OwYZnTyKgZ8FhA2JA9QYAho
=HeOA
-----END PGP SIGNATURE-----

--iF6iCCHuSwDQrkSjUVBaut6ROGfWMCiOg--
