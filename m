Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaDYPRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:17:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38526 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaDYPRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:17:37 -0400
Date: Fri, 25 Apr 2014 10:17:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 7/9] extcon: adc-jack: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151719.GK29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-8-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLauP2uySp+9cKYP"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-8-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SLauP2uySp+9cKYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:22AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-adc-jack.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc=
-jack.c
> index 549d820..e18f95b 100644
> --- a/drivers/extcon/extcon-adc-jack.c
> +++ b/drivers/extcon/extcon-adc-jack.c
> @@ -39,7 +39,7 @@
>   * @chan:		iio channel being queried.
>   */
>  struct adc_jack_data {
> -	struct extcon_dev edev;
> +	struct extcon_dev *edev;
> =20
>  	const char **cable_names;
>  	int num_cables;
> @@ -64,7 +64,7 @@ static void adc_jack_handler(struct work_struct *work)
> =20
>  	ret =3D iio_read_channel_raw(data->chan, &adc_val);
>  	if (ret < 0) {
> -		dev_err(&data->edev.dev, "read channel() error: %d\n", ret);
> +		dev_err(&data->edev->dev, "read channel() error: %d\n", ret);
>  		return;
>  	}
> =20
> @@ -80,7 +80,7 @@ static void adc_jack_handler(struct work_struct *work)
>  	}
>  	/* if no def has met, it means state =3D 0 (no cables attached) */
> =20
> -	extcon_set_state(&data->edev, state);
> +	extcon_set_state(data->edev, state);
>  }
> =20
>  static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
> @@ -102,18 +102,21 @@ static int adc_jack_probe(struct platform_device *p=
dev)
>  	if (!data)
>  		return -ENOMEM;
> =20
> -	data->edev.name =3D pdata->name;
> -
>  	if (!pdata->cable_names) {
>  		dev_err(&pdev->dev, "error: cable_names not defined.\n");
>  		return -EINVAL;
>  	}
> =20
> -	data->edev.dev.parent =3D &pdev->dev;
> -	data->edev.supported_cable =3D pdata->cable_names;
> +	data->edev =3D devm_extcon_dev_allocate(&pdev->dev, pdata->cable_names);
> +	if (IS_ERR(data->edev)) {
> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
> +		return -ENOMEM;
> +	}
> +	data->edev->dev.parent =3D &pdev->dev;
> +	data->edev->name =3D pdata->name;
> =20
>  	/* Check the length of array and set num_cables */
> -	for (i =3D 0; data->edev.supported_cable[i]; i++)
> +	for (i =3D 0; data->edev->supported_cable[i]; i++)
>  		;
>  	if (i =3D=3D 0 || i > SUPPORTED_CABLE_MAX) {
>  		dev_err(&pdev->dev, "error: pdata->cable_names size =3D %d\n",
> @@ -144,7 +147,7 @@ static int adc_jack_probe(struct platform_device *pde=
v)
> =20
>  	platform_set_drvdata(pdev, data);
> =20
> -	err =3D devm_extcon_dev_register(&pdev->dev, &data->edev);
> +	err =3D devm_extcon_dev_register(&pdev->dev, data->edev);
>  	if (err)
>  		return err;
> =20
> --=20
> 1.8.0
>=20

--=20
balbi

--SLauP2uySp+9cKYP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnx/AAoJEIaOsuA1yqRE0RwP/1/C51L8tNK5oUlIyRKvb54r
tOVqTO1zt2y18L6xuaYjrFSv0KfEh7wn/SMngmpLdcvDdrppuReBNQAhPFvsRc/v
BNjeFJdeGfXOp24gbzmZJEQT65wW3FfGrwjIs4mkJIHkJaBjq3ZK54v8goLiGGaK
3jar+BwiIPXYQJDanZQ3WmMsh8ufT2ftZKYpATayLqSgvpuprW+0f+U+nrge2ovg
M1B9px8jEyI/0RU4HYz02/DEkluy8aBFW8B62skbcy31lVyompQ1bRIl322CakkJ
/qnVbpVkxZn7Ll8h9huAGVnifn0UWTmG+nxiiQCcqdw1vCc701kdJMweLa2jtMwB
sOZp96Om0HvOCnUpbK2oHSUhgXQ5v30xL9JMH7rnd++9EyI7qoYuS9NpWu1BRvuv
vO1TwCtraQvoR54AVYuDRZRZhojWG8L97epuVAYgRcRoAYCybzraucxgi6ct0bF/
1PeOzV9HhzLJt6w5zYUSZkp4dQoL/eq0Us3buSKOb0xi2Ib5XQl5mEBxzGLzuSAD
T9G6mOUlVIgTvc/WiUcTcCS1s6smzXusLlwDyHVCvcKcrQGt30mgKxkHh8S1qFA6
1XE83RzzJEpjRAy3MFSXeOW6RDboC1bLWk/Y0W3Alf+CZCWWwQCpLygacVsbAEZO
wvyVy1N2F2MaPYTVpkDJ
=2buI
-----END PGP SIGNATURE-----

--SLauP2uySp+9cKYP--
