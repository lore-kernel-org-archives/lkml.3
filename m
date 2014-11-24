Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaKXOgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:36:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34188 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbaKXOgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:40 -0500
Date: Mon, 24 Nov 2014 08:36:46 -0600
From: Felipe Balbi <balbi@ti.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Arjun Sreedharan <arjun024@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <kernel-build-reports@lists.linaro.org>
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141124143646.GA20705@saruman>
Reply-To: <balbi@ti.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
 <20141124131034.GB4061@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20141124131034.GB4061@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 24, 2014 at 02:10:41PM +0100, Thierry Reding wrote:
> On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> > When __of_usb_find_phy() fails, it returns -ENODEV - its
> > error code has to be returned by devm_usb_get_phy_by_phandle().
> > Only when the former function succeeds and try_module_get()
> > fails should -EPROBE_DEFER be returned.
> >=20
> > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > ---
> >  drivers/usb/phy/phy.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> This causes a boot regression on at least NVIDIA Dalmore (I boot over
> NFS using a USB network adapter).
>=20
> The commit message is somewhat insufficient because while it explains
> what the code does and asserts that it is the right thing to do, it
> fails to explain why.

you also fail to explain it causes a regressions with Dalmore. This is
really the correct patch, we shouldn't be overwritting the error passed
in by upper layers.

> > diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> > index 045cd30..0310112 100644
> > --- a/drivers/usb/phy/phy.c
> > +++ b/drivers/usb/phy/phy.c
> > @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct =
device *dev,
> > =20
> >  	phy =3D __of_usb_find_phy(node);
> >  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > -		phy =3D ERR_PTR(-EPROBE_DEFER);
> > +		if (!IS_ERR(phy))
> > +			phy =3D ERR_PTR(-EPROBE_DEFER);
>=20
> If we look at this closer, __of_usb_find_phy() return a valid pointer if
> a PHY was found or ERR_PTR(-ENODEV) otherwise. But since the phandle has
> already been validated, the only reason why __of_usb_find_phy() fails is
> because the PHY that the phandle refers to hasn't been registered yet.
>=20
> Returning -EPROBE_DEFER is the correct thing to do in this situation
> because it gives the PHY driver an opportunity to register and the USB
> host controller to try probing again. I suppose one could argue that
> __of_usb_find_phy() should return ERR_PTR(-EPROBE_DEFER) on failure
> instead of ERR_PTR(-ENODEV), since evidently the device does exist, it
> just hasn't been registered yet. On the other hand it could happen that
> the phandle refers to a device tree node that's status =3D "disabled", in
> which case ERR_PTR(-ENODEV) might be appropriate.
>=20
> Also, -EPROBE_DEFER isn't really the proper error for try_module_get()
> failure. Other functions (usb_get_phy() and usb_get_phy_dev()) return
> -ENODEV instead, so it'd be more consistent to stick with that. Hence I
> propose something like the below instead.

I don't mind patch below, but I want to know why Dalmore regressed with
$subject.

--=20
balbi

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc0J+AAoJEIaOsuA1yqREyOEP/2ilkTZC9Jmtuw8CS+fRxqLB
fforWtsEn/aooK8kARGh9s64I8UfPDTslUg4+Y8AW39Ltu2ZyILhHJ/GZNvTeGxz
+0hlA3VHT9qMW8SI6vl4pS81SPDn91YoAGk9Kx+pzNvRyU/2JRglrO+I+0RCo+2+
yosArAi5QLK61UVPXej1n8c2b1EHPYsT5HJWWfzVOTl1LOMrZAz0dxC0YXHpNxRz
zn8L8zoB64+Be1onzyXbjQR4jsIskwYv/PDsx8ASJZBTcSPfwoJHd++4zR/PiaHc
8+pnjzERJukBpX4YAhm7NLDuzXuUMBBrQs/S+e8Mbee93l+CNJt0YOxWtOBtPMH7
wdl2pExoY2BWUE3pKJ+OjaUlwZeETYFcIW7ae+WTp9uvUrV1SCGtdjNnBzeP2ezH
+3L0Ezz5IGfJd9+KxH5Mg7CievHqm8Muixq45aVGbtpRRoci+76ltKlSJ6rJo7FC
xrnJGhj66klhlHojlVW/DCD5QBCQvU/Bl+3/cOD2kwgWz9m6coMkU4Q04TtjA5po
nm7qlq6bUDGF6+UoWsq17deoGQp4uNONK4Hg8ej/kVkF02WzaVTsdWO/+9BNS4GX
JVXCO/4Ff8i3XcTMVG3lLEuquygxQVHv9w0a6GRODRj1pzeTWpIpco41ZdHWqizO
Y8LCk1G6W64XfywZpcjr
=775j
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
