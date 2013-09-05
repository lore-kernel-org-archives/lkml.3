Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab3IEJeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:34:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33278 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763569Ab3IEJeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:34:22 -0400
Message-ID: <52285006.3080303@pengutronix.de>
Date: Thu, 05 Sep 2013 11:33:58 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        "s.grosjean@peak-system.com" <s.grosjean@peak-system.com>
Subject: Re: [PATCH] can: pcan_usb_core: fix memory leak on failure paths
 in peak_usb_start()
References: <1378331169-26285-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1378331169-26285-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WXUl34DclNoQVdp7j29jCx9eeFBpUAvMI"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXUl34DclNoQVdp7j29jCx9eeFBpUAvMI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Added Stephane to Cc.

On 09/04/2013 11:46 PM, Alexey Khoroshilov wrote:
> Tx and rx urbs are not deallocated if something goes wrong in peak_usb_=
start().
> The patch fixes error handling to deallocate all the resources.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Stephane, can you have a look at the patch and give your Acked-by.

Looks good to me.

tnx,
Marc
> ---
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net=
/can/usb/peak_usb/pcan_usb_core.c
> index a0f647f..0b7a4c3 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -463,7 +463,7 @@ static int peak_usb_start(struct peak_usb_device *d=
ev)
>  	if (i < PCAN_USB_MAX_TX_URBS) {
>  		if (i =3D=3D 0) {
>  			netdev_err(netdev, "couldn't setup any tx URB\n");
> -			return err;
> +			goto err_tx;
>  		}
> =20
>  		netdev_warn(netdev, "tx performance may be slow\n");
> @@ -472,7 +472,7 @@ static int peak_usb_start(struct peak_usb_device *d=
ev)
>  	if (dev->adapter->dev_start) {
>  		err =3D dev->adapter->dev_start(dev);
>  		if (err)
> -			goto failed;
> +			goto err_adapter;
>  	}
> =20
>  	dev->state |=3D PCAN_USB_STATE_STARTED;
> @@ -481,19 +481,26 @@ static int peak_usb_start(struct peak_usb_device =
*dev)
>  	if (dev->adapter->dev_set_bus) {
>  		err =3D dev->adapter->dev_set_bus(dev, 1);
>  		if (err)
> -			goto failed;
> +			goto err_adapter;
>  	}
> =20
>  	dev->can.state =3D CAN_STATE_ERROR_ACTIVE;
> =20
>  	return 0;
> =20
> -failed:
> +err_adapter:
>  	if (err =3D=3D -ENODEV)
>  		netif_device_detach(dev->netdev);
> =20
>  	netdev_warn(netdev, "couldn't submit control: %d\n", err);
> =20
> +	for (i =3D 0; i < PCAN_USB_MAX_TX_URBS; i++) {
> +		usb_free_urb(dev->tx_contexts[i].urb);
> +		dev->tx_contexts[i].urb =3D NULL;
> +	}
> +err_tx:
> +	usb_kill_anchored_urbs(&dev->rx_submitted);
> +
>  	return err;
>  }
> =20
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--WXUl34DclNoQVdp7j29jCx9eeFBpUAvMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlIoUAYACgkQjTAFq1RaXHPNCQCfQtq3tJfXCkEB9ViuWDiTibpw
SZoAoIBOnhJ8MOMKEPHXq+N9+rhLNt5f
=BFF+
-----END PGP SIGNATURE-----

--WXUl34DclNoQVdp7j29jCx9eeFBpUAvMI--
