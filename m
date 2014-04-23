Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaDWQF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:05:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaDWQFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:05:55 -0400
Date: Wed, 23 Apr 2014 11:03:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] usb: phy: tahvo: Use devm_extcon_dev_* function for
 resource management of extcon
Message-ID: <20140423160319.GM9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398226363-19536-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kkcDP0v44wDpNmbp"
Content-Disposition: inline
In-Reply-To: <1398226363-19536-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kkcDP0v44wDpNmbp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 01:12:43PM +0900, Chanwoo Choi wrote:
> This patch uses devm_extcon_dev_{allocate, register} function for automat=
ically
> resource management of extcon device instead of legacy method and simplif=
ies
> the behavior of register/unregister for extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Aaro, if you can give me your Tested-by and/or Acked-by, I'll take this
to v3.16

> ---
> This patch has dependency about following patches[1-2]:
> [1] https://lkml.org/lkml/2014/4/21/140
> [2] https://lkml.org/lkml/2014/4/21/164
>=20
>  drivers/usb/phy/phy-tahvo.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
> index cc61ee4..8cde928 100644
> --- a/drivers/usb/phy/phy-tahvo.c
> +++ b/drivers/usb/phy/phy-tahvo.c
> @@ -57,7 +57,7 @@ struct tahvo_usb {
>  	struct clk		*ick;
>  	int			irq;
>  	int			tahvo_mode;
> -	struct extcon_dev	extcon;
> +	struct extcon_dev	*extcon;
>  };
> =20
>  static const char *tahvo_cable[] =3D {
> @@ -118,7 +118,7 @@ static void check_vbus_state(struct tahvo_usb *tu)
>  	prev_state =3D tu->vbus_state;
>  	tu->vbus_state =3D reg & TAHVO_STAT_VBUS;
>  	if (prev_state !=3D tu->vbus_state) {
> -		extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
> +		extcon_set_cable_state(tu->extcon, "USB", tu->vbus_state);
>  		sysfs_notify(&tu->pt_dev->dev.kobj, NULL, "vbus_state");
>  	}
>  }
> @@ -127,7 +127,7 @@ static void tahvo_usb_become_host(struct tahvo_usb *t=
u)
>  {
>  	struct retu_dev *rdev =3D dev_get_drvdata(tu->pt_dev->dev.parent);
> =20
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST", true);
> +	extcon_set_cable_state(tu->extcon, "USB-HOST", true);
> =20
>  	/* Power up the transceiver in USB host mode */
>  	retu_write(rdev, TAHVO_REG_USBR, USBR_REGOUT | USBR_NSUSPEND |
> @@ -146,7 +146,7 @@ static void tahvo_usb_become_peripheral(struct tahvo_=
usb *tu)
>  {
>  	struct retu_dev *rdev =3D dev_get_drvdata(tu->pt_dev->dev.parent);
> =20
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST", false);
> +	extcon_set_cable_state(tu->extcon, "USB-HOST", false);
> =20
>  	/* Power up transceiver and set it in USB peripheral mode */
>  	retu_write(rdev, TAHVO_REG_USBR, USBR_SLAVE_CONTROL | USBR_REGOUT |
> @@ -360,11 +360,15 @@ static int tahvo_usb_probe(struct platform_device *=
pdev)
>  	 */
>  	tu->vbus_state =3D retu_read(rdev, TAHVO_REG_IDSR) & TAHVO_STAT_VBUS;
> =20
> -	tu->extcon.name =3D DRIVER_NAME;
> -	tu->extcon.supported_cable =3D tahvo_cable;
> -	tu->extcon.dev.parent =3D &pdev->dev;
> +	tu->extcon =3D devm_extcon_dev_allocate(&pdev->dev, tahvo_cable);
> +	if (!tu->extcon) {
> +		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
> +		return -ENOMEM;
> +	}
> +	tu->extcon->name =3D DRIVER_NAME;
> +	tu->extcon->dev.parent =3D &pdev->dev;
> =20
> -	ret =3D extcon_dev_register(&tu->extcon);
> +	ret =3D devm_extcon_dev_register(&pdev->dev, tu->extcon);
>  	if (ret) {
>  		dev_err(&pdev->dev, "could not register extcon device: %d\n",
>  			ret);
> @@ -372,9 +376,9 @@ static int tahvo_usb_probe(struct platform_device *pd=
ev)
>  	}
> =20
>  	/* Set the initial cable state. */
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST",
> +	extcon_set_cable_state(tu->extcon, "USB-HOST",
>  			       tu->tahvo_mode =3D=3D TAHVO_MODE_HOST);
> -	extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
> +	extcon_set_cable_state(tu->extcon, "USB", tu->vbus_state);
> =20
>  	/* Create OTG interface */
>  	tahvo_usb_power_off(tu);
> @@ -391,7 +395,7 @@ static int tahvo_usb_probe(struct platform_device *pd=
ev)
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "cannot register USB transceiver: %d\n",
>  			ret);
> -		goto err_extcon_unreg;
> +		goto err_disable_clk;
>  	}
> =20
>  	dev_set_drvdata(&pdev->dev, tu);
> @@ -418,8 +422,6 @@ err_free_irq:
>  	free_irq(tu->irq, tu);
>  err_remove_phy:
>  	usb_remove_phy(&tu->phy);
> -err_extcon_unreg:
> -	extcon_dev_unregister(&tu->extcon);
>  err_disable_clk:
>  	if (!IS_ERR(tu->ick))
>  		clk_disable(tu->ick);
> @@ -434,7 +436,6 @@ static int tahvo_usb_remove(struct platform_device *p=
dev)
>  	sysfs_remove_group(&pdev->dev.kobj, &tahvo_attr_group);
>  	free_irq(tu->irq, tu);
>  	usb_remove_phy(&tu->phy);
> -	extcon_dev_unregister(&tu->extcon);
>  	if (!IS_ERR(tu->ick))
>  		clk_disable(tu->ick);
> =20
> --=20
> 1.8.0
>=20

--=20
balbi

--kkcDP0v44wDpNmbp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV+RHAAoJEIaOsuA1yqREnA0P/18tBaVPjnuJhTuKddmoBWty
P8DQSdtnjXixvqfsIR9aOJZ6DgnryYEsozWzgOKroxNda4beOYBeXHAihlacbbyE
ETq6XB5mYthi3zWKRlNzdvrfYPTtL180vGMtGZfJQIf6+M6wo1Va4CU5k7ATEUKB
Kb1tGe1lFN7lNlKEWGDRw1vY7SaWqcgvtg3O7OTqwfGDiJ6WQIwW0R9Zz509ygWg
EJyKSqeBYhrVblDaet7ZFzXr62J4mm/m7EQC+tnfFnVl7kXhvg63G+G52a1kB6zS
/hNZ7eKRvrDUiRffnTkuLDWIdpbbO/RexvLYk3OVCUikGD0smwHOnIcn1/MCYsp5
zAA7zRa4CFdmMitCvA34lhkfdYfzqTrkvlqbzfpTP7kptbajKaRAsOJCnO6GHyoU
mxY5tVNLiJ+ZtwSULhbYtiNpnwSGq3AuC/HhatU34Yk9Zsa1r8Tu5Zyf4cHspvMr
9haZLEcC7AoMOpCHMXRogr15jV3HaLVio5l4DCHW9C3nqfr4BdazofDXO7pLI8j+
ZY09VQLHMNSms20f94mqCLovLy3lNvVlA3PV6lYd/4eZNHWNGZyipt7DyHIDFpO9
AQrqclPHn8KBV+8U8vcFeMq8aI/9IcaX5W7LyvpXd35cWt2pKWrc2RVBEZYRpIKh
PxiqGHDbzMWdLaE7sDCq
=8edR
-----END PGP SIGNATURE-----

--kkcDP0v44wDpNmbp--
