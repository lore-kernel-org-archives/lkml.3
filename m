Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3BAVNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:13:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60116 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3BAVNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:13:36 -0500
Message-ID: <510C2FEA.1080207@pengutronix.de>
Date: Fri, 01 Feb 2013 22:13:14 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: tony@atomide.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 1/6] usb: otg: Add an API to bind the USB controller
 and PHY
References: <1359081206-5602-1-git-send-email-kishon@ti.com> <1359081206-5602-2-git-send-email-kishon@ti.com>
In-Reply-To: <1359081206-5602-2-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BVEVKMMCTWNDJXBMUMWG"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BVEVKMMCTWNDJXBMUMWG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2013 03:33 AM, Kishon Vijay Abraham I wrote:
> In order to support platforms which has multiple PHY's (of same type) a=
nd
> which has multiple USB controllers, a new design is adopted wherin the =
binding
> information (between the PHY and the USB controller) should be passed t=
o the
> PHY library from platform specific file (board file).
> So added a new API to pass the binding information.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/otg/otg.c   |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/usb/phy.h |   22 ++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
>=20
> diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
> index a30c041..8e756d9 100644
> --- a/drivers/usb/otg/otg.c
> +++ b/drivers/usb/otg/otg.c
> @@ -18,6 +18,7 @@
>  #include <linux/usb/otg.h>
> =20
>  static LIST_HEAD(phy_list);
> +static LIST_HEAD(phy_bind_list);
>  static DEFINE_SPINLOCK(phy_lock);
> =20
>  static struct usb_phy *__usb_find_phy(struct list_head *list,
> @@ -201,6 +202,42 @@ void usb_remove_phy(struct usb_phy *x)
>  }
>  EXPORT_SYMBOL(usb_remove_phy);
> =20
> +/**
> + * usb_bind_phy - bind the phy and the controller that uses the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @index: index to specify the port number
> + * @phy_dev_name: the device name of the phy
> + *
> + * Fills the phy_bind structure with the dev_name and phy_dev_name. Th=
is will
> + * be used when the phy driver registers the phy and when the controll=
er
> + * requests this phy.
> + *
> + * To be used by platform specific initialization code.
> + */
> +int __init usb_bind_phy(const char *dev_name, u8 index,
> +				const char *phy_dev_name)
> +{
> +	struct usb_phy_bind *phy_bind;
> +	unsigned long flags;
> +
> +	phy_bind =3D kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> +	if (!phy_bind) {
> +		pr_err("phy_bind(): No memory for phy_bind");
> +		return -ENOMEM;
> +	}
> +
> +	phy_bind->dev_name =3D dev_name;
> +	phy_bind->phy_dev_name =3D phy_dev_name;
> +	phy_bind->index =3D index;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +	list_add_tail(&phy_bind->list, &phy_bind_list);
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_bind_phy);
> +
>  const char *otg_state_string(enum usb_otg_state state)
>  {
>  	switch (state) {
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index a29ae1e..e7eb429 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -106,6 +106,21 @@ struct usb_phy {
>  			enum usb_device_speed speed);
>  };
> =20
> +/**
> + * struct usb_phy_bind - represent the binding for the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @phy_dev_name: the device name of the phy
> + * @index: used if a single controller uses multiple phys
> + * @phy: reference to the phy
> + * @list: to maintain a linked list of the binding information
> + */
> +struct usb_phy_bind {
> +	const char	*dev_name;
> +	const char	*phy_dev_name;
> +	u8		index;
> +	struct usb_phy	*phy;
> +	struct list_head list;
> +};
> =20
>  /* for board-specific init logic */
>  extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
> @@ -151,6 +166,8 @@ extern struct usb_phy *devm_usb_get_phy(struct devi=
ce *dev,
>  	enum usb_phy_type type);
>  extern void usb_put_phy(struct usb_phy *);
>  extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
> +extern int usb_bind_phy(const char *dev_name, u8 index,
> +				const char *phy_dev_name);
>  #else
>  static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
>  {
> @@ -171,6 +188,11 @@ static inline void devm_usb_put_phy(struct device =
*dev, struct usb_phy *x)
>  {
>  }
> =20
> +static inline int usb_bind_phy(const char *dev_name, u8 index,
> +				const char *phy_dev_name)
> +{
> +	return NULL;

The return value looks bogus.

Marc

> +}
>  #endif
> =20
>  static inline int
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2BVEVKMMCTWNDJXBMUMWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEML+0ACgkQjTAFq1RaXHO+1QCglFci3RGwnkMNVEeshkmM00PT
k28An3mkyAEU10b/6VNmUZ2CtkkP/ocU
=oMdY
-----END PGP SIGNATURE-----

------enig2BVEVKMMCTWNDJXBMUMWG--
