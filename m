Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab3BAVzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:55:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51432 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab3BAVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:55:02 -0500
Message-ID: <510C39A9.70202@pengutronix.de>
Date: Fri, 01 Feb 2013 22:54:49 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: tony@atomide.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 2/6] usb: otg: utils: add facilities in phy lib to
 support multiple PHYs of same type
References: <1359081206-5602-1-git-send-email-kishon@ti.com> <1359081206-5602-3-git-send-email-kishon@ti.com>
In-Reply-To: <1359081206-5602-3-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2SLKDIUCRXOLHVIHGQKBU"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SLKDIUCRXOLHVIHGQKBU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2013 03:33 AM, Kishon Vijay Abraham I wrote:
> In order to add support for multipe PHY's of the same type, new API's
> for adding PHY and getting PHY has been added. Now the binding
> information for the PHY and controller should be done in platform file
> using usb_bind_phy API. And for getting a PHY, the device pointer of th=
e
> USB controller and an index should be passed. Based on the binding
> information that is added in the platform file, usb_get_phy_dev will re=
turn the
> appropriate PHY.
> Already existing API's to add and get phy by type is not removed. These=

> API's are deprecated and will be removed once all the platforms start t=
o
> use the new API.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/otg/otg.c   |  118 +++++++++++++++++++++++++++++++++++++++=
+++++++-
>  include/linux/usb/phy.h |   13 ++++++
>  2 files changed, 130 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
> index 8e756d9..4bb4333 100644
> --- a/drivers/usb/otg/otg.c
> +++ b/drivers/usb/otg/otg.c
> @@ -36,6 +36,24 @@ static struct usb_phy *__usb_find_phy(struct list_he=
ad *list,
>  	return ERR_PTR(-ENODEV);
>  }
> =20
> +static struct usb_phy *__usb_find_phy_dev(struct device *dev,
> +	struct list_head *list, u8 index)
> +{
> +	struct usb_phy_bind *phy_bind =3D NULL;
> +
> +	list_for_each_entry(phy_bind, list, list) {
> +		if (!(strcmp(phy_bind->dev_name, dev_name(dev))) &&
> +				phy_bind->index =3D=3D index) {
> +			if (phy_bind->phy)
> +				return phy_bind->phy;
> +			else
> +				return ERR_PTR(-EPROBE_DEFER);
> +		}
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
>  static void devm_usb_phy_release(struct device *dev, void *res)
>  {
>  	struct usb_phy *phy =3D *(struct usb_phy **)res;
> @@ -112,6 +130,69 @@ err0:
>  EXPORT_SYMBOL(usb_get_phy);
> =20
>  /**
> + * usb_get_phy_dev - find the USB PHY
> + * @dev - device that requests this phy
> + * @index - the index of the phy
> + *
> + * Returns the phy driver, after getting a refcount to it; or
> + * -ENODEV if there is no such phy.  The caller is responsible for
> + * calling usb_put_phy() to release that count.
> + *
> + * For use by USB host and peripheral drivers.
> + */
> +struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
> +{
> +	struct usb_phy	*phy =3D NULL;
> +	unsigned long	flags;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	phy =3D __usb_find_phy_dev(dev, &phy_bind_list, index);
> +	if (IS_ERR(phy)) {

You should probably lock the phy module in memory. See my patch "usb:
otg: use try_module_get in all usb_get_phy functions and add missing
module_put".

Marc



--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2SLKDIUCRXOLHVIHGQKBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEMOakACgkQjTAFq1RaXHOKowCfcq9DjJoX+cyD3QMX4TMCqrY8
SjIAn3zdUZrd7noqE+1/t8twNL37IRLG
=pmYn
-----END PGP SIGNATURE-----

------enig2SLKDIUCRXOLHVIHGQKBU--
