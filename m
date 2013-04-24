Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab3DXHeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:34:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab3DXHeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:34:01 -0400
Date: Wed, 24 Apr 2013 09:33:50 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V3 3/3] pwm: pxa: add device tree support
Message-ID: <20130424073350.GG1429@avionic-0098.mockup.avionic-design.de>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
 <1366770234-5829-4-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <1366770234-5829-4-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:57l1TudADkHm04WRZdsn7ytvZnHXIb89hg0f+EnLD3t
 tKw9LkSVlRZiUmHYStvPUfFc0iprDU+kekEQ+czVhU8oVA9KwL
 /7R/hJdolpUSGcQsHXyIbfcfMkPgLf5XKUc89sO6GkmIEPMAwA
 RMgwOvNjHXuIwINLAw4Czcm3/8dhzZEwQdirHxoBJsQL0+kJHb
 UaLjRYrGoA61ntG/lGXYaa70wCglGBA8TgCpe9Mo7hYu6S+8Ro
 I01k2IAqAj6Gye6C+W77DsC4KYDb1zpa2crVbJxSZUASuDlLXi
 yzFnsoVHej2Qpb58VANcaowjD6Nx+w3R2uBJcTjUPMWceXjh1G
 s+TP/kGvcKNZlgA4Y97JUC1iggNlzPkq7ykVdzfqkyR6IPrtJ9
 8DwYOhg/CLg3wfk69AeWQSrcuizi61Wbz5LOURP+WKOA772anz
 /EcET
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 10:23:54PM -0400, Chao Xie wrote:
> Add the deice tree support for pwm-pxa.

Instead of repeating the patch subject here, maybe you could be more
verbose about the changes you make, like splitting off the parsing of OF
and platform data into separate functions.

> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index aa4bea7..45d9047 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -9,6 +9,8 @@
>   *
>   * 2008-02-13	initial version
>   * 		eric miao <eric.miao@marvell.com>
> + * 2013-04-24   add device tree support
> + * 		Chao Xie <chao.xie@marvell.com>
>   */
> =20
>  #include <linux/module.h>
> @@ -18,6 +20,8 @@
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/pwm.h>
> =20
>  #include <asm/div64.h>
> @@ -124,9 +128,52 @@ static struct pwm_ops pxa_pwm_ops =3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> -static int pwm_probe(struct platform_device *pdev)
> +static struct of_device_id pxa_pwm_of_match[] =3D {
> +	{
> +		.compatible =3D "marvell,pxa25x-pwm",
> +	}, {
> +		.compatible =3D "marvell,pxa27x-pwm",
> +		.data =3D (void *)HAS_SECONDARY_PWM
> +	}, {
> +		.compatible =3D "marvell,pxa168-pwm",
> +	}, {
> +		.compatible =3D "marvell,pxa910-pwm",
> +	},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(of, pxa_pwm_of_match);
> +
> +#ifdef CONFIG_OF
> +static int pxa_pwm_parse_data(struct platform_device *pdev,
> +				struct pxa_pwm_chip *pwm)
> +{
> +	const struct of_device_id *of_id =3D
> +			of_match_device(pxa_pwm_of_match, &pdev->dev);
> +	unsigned int npwm;
> +
> +	if (!of_id)
> +		return -ENODEV;
> +
> +	npwm =3D (unsigned int)(of_id->data);
> +	pwm->chip.npwm =3D (npwm & HAS_SECONDARY_PWM) ? 2 : 1;
> +
> +	return 0;
> +}
> +#else
> +static int pxa_pwm_parse_data(struct platform_device *pdev,
> +				struct pxa_pwm_chip *pwm)
>  {
>  	const struct platform_device_id *id =3D platform_get_device_id(pdev);
> +
> +	pwm->chip.npwm =3D (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
> +
> +	return 0;
> +}
> +#endif

One thing that occurred to me just now is that this might be a potential
problem. Suppose you want to build a kernel which has support for using
legacy board support (platform data) and DT. If you enable CONFIG_OF you
will no longer be able to support boards that use platform data.

A common solution to this problem is to prefer platform over DT data, so
typically you'd do something like this:

	if (!pdata) {
		if (IS_ENABLED(CONFIG_OF))
			err =3D parse_dt();
		else
			err =3D -ENODEV;
	} else {
		err =3D parse_pdata();
	}

	if (err < 0)
		return err;

Given that in your case you don't have platform data but rather the
platform device ID entry, the same scheme should work, since in the OF
case the id_entry of the platform device won't be set.

Thierry

--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4reAAoJEN0jrNd/PrOhgZAQAKx97WQwsq6vpV3NbBeVytf0
xaEsX/yabYq3GU7OucSK1nLvj9v0hHyxNkxQdJB4vgCKS4m7az0IP0/wqf4hMD3O
RpGdT34CPAN6I4DF95GaWh0F6XMui1fYzYFH8iBsgsHzHgOYzVPT6kPxviGAbpRM
nXOWnZppZafXVX0aHy8GMu1T3yqblbMBjM9jubaq9pqGxAFJD7g3gZ0poICA1/AP
YgYijrf7y+ydBa6h2wvLLKatPrsEjp0BxsdEq4+RrD6pH0bIH+Of/pGY1eB/+WiB
gRlCTslWskkzigDuywwQHnajyQZp74cBoDfyOnvYcXUvM9PlSy6QTxRBi4Cnp+qC
6ZWv8XTB52OSvDH9VDBNpVmH1GbShBTvqdUpCvuKWzjX3qzQUjvWTb2ZJA8pOheE
ph2D/s4HOwKc7xgETI5m+qOv5zKiRx5eKv0qWzSTyxbhj0TxJFioCP+Xv200kKbP
cWZVqjNBR4DKEusP9krssNd8hPjGHQx6EyIKOR2riWmH3XaJP5ZKLfaonA0I80me
Mqxfisg9/ffpF2D3aveh2W9da+U5lWEMBi2OdzYXMrKtcfUE52jztQKJQgDbehVp
AAGo/F8zv9IVmrlBKX1XDDqtOoXGruY57VG/rZ7j8cn4F8DR3NceSRNiOIgYch2Y
MqPLG1Hmts5WK5F6EKUh
=1U09
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
