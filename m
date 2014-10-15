Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaJOJFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:05:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:36598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaJOJFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:05:21 -0400
Date: Wed, 15 Oct 2014 11:05:12 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFT PATCH] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
Message-ID: <20141015090512.GA26651@earth.universe>
References: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Tue, Oct 14, 2014 at 10:32:53AM +0200, Krzysztof Kozlowski wrote:
> The power_supply_get_by_phandle() on error returns ENODEV or NULL.
> The driver later expects obtained pointer to power supply to be
> valid or NULL. If it is not NULL then it dereferences it in
> bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
> pointer.
>=20
> Properly handle the power_supply_get_by_phandle() error case and abort pr=
obe.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
> Cc: <stable@vger.kernel.org>

That looks valid, but I guess this should change one more thing:

> ---
>  drivers/power/bq2415x_charger.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_char=
ger.c
> index e384844a1ae1..d9c457217b6a 100644
> --- a/drivers/power/bq2415x_charger.c
> +++ b/drivers/power/bq2415x_charger.c
> @@ -1579,8 +1579,13 @@ static int bq2415x_probe(struct i2c_client *client,
>  	if (np) {
>  		bq->notify_psy =3D power_supply_get_by_phandle(np, "ti,usb-charger-det=
ection");
> =20
> -		if (!bq->notify_psy)
> +		if (!bq->notify_psy) {
>  			return -EPROBE_DEFER;

this also needs to goto error_2. I guess something as the following
is needed:

if (IS_ERR_OR_NULL(bq->notify_psy)) {
    if (bq->notify_psy)
        dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
    ret =3D PTR_ERR(bq->notify_psy);
    goto error_2;
}

> +		} else if (IS_ERR(bq->notify_psy)) {
> +			dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
> +			ret =3D PTR_ERR(bq->notify_psy);
> +			goto error_2;
> +		}
>  	}
>  	else if (pdata->notify_device)
>  		bq->notify_psy =3D power_supply_get_by_name(pdata->notify_device);

-- Sebastian

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUPjjIAAoJENju1/PIO/qawOQP/1CLSkz8hSvXboGRTrSka8/p
qP/CxLpk4Eym5if7krKduqJcSIJxom2SU6uClCuccSZCZr/ea1ngrPfceC1zMun/
K4XJsy+pIZFCgDBzN7QlZRosYv0C7s5iq3Of22IRNSCSncUMz10bbh1xOly3ic7a
gBsxpmzymWF7snSnxaWDay5uGoVAXVcYkFJ9Jx6XObIPSzZA8TsjvJrblZBtOlYy
6xb0eWOXm/zPzwcLTYu0caUA8jImxePnMNdWbPpu3H8Omup2Kwj76cAOQ9kviik9
xJYhrAC3Fpmf3u1xaLecjj8+EZ8FFtJpwTa9L4KjC+P5Xxu2ckSfO5b70j65VChf
l0HceNUjR8YF2ljyan74X3RibA8SlC7YfdgqJ8w8z+vdNtmmVwZyRDf0rx6f+Ahi
jDkk7nH6dfTNeRqJxadlV28Qf1IOtpA4GAgscVbSZ+71Is35KAiTGMJz20iEVwjk
aSLovT7LCG2lqjFHZJta12xJHHIKT71811Y+qHX+SP4DcAMxNNqYGjCNJBSnpaDN
QrIde3lKra7Rj6n+3JIgaKlxswRcIsVy0uZnjGpArYSGT7h70zwPVOHpUMYIQ8q6
aG9At2Tv/KYRXx0+O6DQtqJq31Hf0WheQkK/ljgo2oLoO4vzBrDIe0j7zEJrETpI
o2ezf+HhVV+B+IQza7Fv
=oQ2G
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
