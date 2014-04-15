Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaDORHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:07:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDORHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:07:20 -0400
Date: Tue, 15 Apr 2014 12:05:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Joachim Eastwood <manabian@gmail.com>,
        <balbi@ti.com>
Subject: Re: [PATCH V2] crypto: omap-des - handle error of pm_runtime_get_sync
Message-ID: <20140415170501.GA16002@saruman.home>
Reply-To: <balbi@ti.com>
References: <534D61DF.9090203@ti.com>
 <1397581111-21148-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1397581111-21148-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 11:58:31AM -0500, Nishanth Menon wrote:
> pm_runtime_get_sync may not always succeed depending on SoC involved.
> So handle the error appropriately ensuring usage_count is accurate in
> case of failure.
>=20
> Signed-off-by: Nishanth Menon <nm@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
> V2:
> 	- review fixes, print function names in error log as well.
>=20
> V1: https://patchwork.kernel.org/patch/3993861/
>  drivers/crypto/omap-des.c |   26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index ec5f131..1d570c4 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -223,12 +223,19 @@ static void omap_des_write_n(struct omap_des_dev *d=
d, u32 offset,
> =20
>  static int omap_des_hw_init(struct omap_des_dev *dd)
>  {
> +	int err;
> +
>  	/*
>  	 * clocks are enabled when request starts and disabled when finished.
>  	 * It may be long delays between requests.
>  	 * Device might go to off mode to save power.
>  	 */
> -	pm_runtime_get_sync(dd->dev);
> +	err =3D pm_runtime_get_sync(dd->dev);
> +	if (err < 0) {
> +		pm_runtime_put_noidle(dd->dev);
> +		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
> +		return err;
> +	}
> =20
>  	if (!(dd->flags & FLAGS_INIT)) {
>  		dd->flags |=3D FLAGS_INIT;
> @@ -1083,7 +1090,12 @@ static int omap_des_probe(struct platform_device *=
pdev)
>  	dd->phys_base =3D res->start;
> =20
>  	pm_runtime_enable(dev);
> -	pm_runtime_get_sync(dev);
> +	err =3D pm_runtime_get_sync(dev);
> +	if (err < 0) {
> +		pm_runtime_put_noidle(dev);
> +		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
> +		goto err_get;
> +	}
> =20
>  	omap_des_dma_stop(dd);
> =20
> @@ -1148,6 +1160,7 @@ err_algs:
>  err_irq:
>  	tasklet_kill(&dd->done_task);
>  	tasklet_kill(&dd->queue_task);
> +err_get:
>  	pm_runtime_disable(dev);
>  err_res:
>  	dd =3D NULL;
> @@ -1191,7 +1204,14 @@ static int omap_des_suspend(struct device *dev)
> =20
>  static int omap_des_resume(struct device *dev)
>  {
> -	pm_runtime_get_sync(dev);
> +	int err;
> +
> +	err =3D pm_runtime_get_sync(dev);
> +	if (err < 0) {
> +		pm_runtime_put_noidle(dev);
> +		dev_err(dev, "%s: failed to get_sync(%d)\n", __func__, err);
> +		return err;
> +	}
>  	return 0;
>  }
>  #endif
> --=20
> 1.7.9.5
>=20

--=20
balbi

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTWa9AAoJEIaOsuA1yqREZLsQAKSun815s/uQh98n9enbVo4D
+dvmZ6w7bqpLnOp7CRUpijAZVJCeJHMIVFWQQiLCuj0UHA+ZHw0DnHTO6TrXNQF/
Rwdg+4HBNYd8daXq0rWp7GC8SZuPNLtzEuE1eMXXjZAAutUIJELbQWnlXVbx6Vk8
voQglIggh+gREm+5O5DW8ZflBnEQS0kjXf5lfXQAjrjKw61pEEi/FF7yr7YgKpt7
FUCogXAr3Kuygt5q9hrpsOwwF01SDQYPqL0Pkmtri7mAbXCFIEah+HH8888KvWBk
YR2NUxvEzeRYtz/7lhLxsmf2frsI4WIsRIyqvwzoFrEKrTiuYOcT1IDgtYFCmKtl
VAkjP1zK+d5371nH5Zu/glo44N4lAr8B3IgnWuTZI43rWsffhK8lmMmKQVUD7yeS
nQvWiPyoyn57J2Gy7cE0N5jBVZd1Dfo3KDVVBXAEgdGNRgiHu256NOKtymxr8uop
eQtgFCKNZT4dNb81NT9rGslJxo/odLD2kGy7/mNTx/UGanHsQq21mVHYu6qYp2qt
Bom/pGAxpv36+zUh5GYIsQmRoajYK6cf9OV6Ao1lY+k8ztZNn9i2qpuX5F3tbC6F
QjcTmSZa63e8QHJQm7V56XxALTDI4jvxhoZgxqvZUy/xX+08GGAcHVF49LSYmXFO
Z+55hKuBAZ9pgof065ur
=rvAI
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
