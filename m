Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3FGFBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:01:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab3FGFBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:01:30 -0400
Message-ID: <1370581277.4021.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 111/184] USB: cdc-wdm: fix buffer overflow
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Jun 2013 06:01:17 +0100
In-Reply-To: <20130604172134.911364563@1wt.eu>
References: <20130604172134.911364563@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NK8gE6bvLB5AwkMKdv9e"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NK8gE6bvLB5AwkMKdv9e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Oliver Neukum <oneukum@suse.de>
>=20
> commit c0f5ecee4e741667b2493c742b60b6218d40b3aa upstream.
>=20
> The buffer for responses must not overflow.
> If this would happen, set a flag, drop the data and return
> an error after user space has read all remaining data.
>=20
> Signed-off-by: Oliver Neukum <oliver@neukum.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [bwh: Backported to 2.6.32: adjust context]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  drivers/usb/class/cdc-wdm.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> index 37f2899..01ae519 100644
> --- a/drivers/usb/class/cdc-wdm.c
> +++ b/drivers/usb/class/cdc-wdm.c
> @@ -52,6 +52,7 @@ MODULE_DEVICE_TABLE (usb, wdm_ids);
>  #define WDM_READ		4
>  #define WDM_INT_STALL		5
>  #define WDM_POLL_RUNNING	6
> +#define WDM_OVERFLOW		10
> =20
>=20
>  #define WDM_MAX			16
> @@ -115,6 +116,7 @@ static void wdm_in_callback(struct urb *urb)
>  {
>  	struct wdm_device *desc =3D urb->context;
>  	int status =3D urb->status;
> +	int length =3D urb->actual_length;
> =20
>  	spin_lock(&desc->iuspin);
> =20
> @@ -144,9 +146,17 @@ static void wdm_in_callback(struct urb *urb)
>  	}
> =20
>  	desc->rerr =3D status;
> -	desc->reslength =3D urb->actual_length;
> -	memmove(desc->ubuf + desc->length, desc->inbuf, desc->reslength);
> -	desc->length +=3D desc->reslength;
> +	if (length + desc->length > desc->wMaxCommand) {
> +		/* The buffer would overflow */
> +		set_bit(WDM_OVERFLOW, &desc->flags);
> +	} else {
> +		/* we may already be in overflow */
> +		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
> +			memmove(desc->ubuf + desc->length, desc->inbuf, length);
> +			desc->length +=3D length;
> +			desc->reslength =3D length;
> +		}
> +	}
>  	wake_up(&desc->wait);
> =20
>  	set_bit(WDM_READ, &desc->flags);
> @@ -398,6 +408,11 @@ retry:
>  			rv =3D -ENODEV;
>  			goto err;
>  		}
> +		if (test_bit(WDM_OVERFLOW, &desc->flags)) {
> +			clear_bit(WDM_OVERFLOW, &desc->flags);
> +			rv =3D -ENOBUFS;
> +			goto err;
> +		}
>  		i++;
>  		if (file->f_flags & O_NONBLOCK) {
>  			if (!test_bit(WDM_READ, &desc->flags)) {
> @@ -440,6 +455,7 @@ retry:
>  			spin_unlock_irq(&desc->iuspin);
>  			goto retry;
>  		}
> +
>  		if (!desc->reslength) { /* zero length read */
>  			dev_dbg(&desc->intf->dev, "%s: zero length - clearing WDM_READ\n", __=
func__);
>  			clear_bit(WDM_READ, &desc->flags);
> @@ -844,6 +860,7 @@ static int wdm_post_reset(struct usb_interface *intf)
>  	struct wdm_device *desc =3D usb_get_intfdata(intf);
>  	int rv;
> =20
> +	clear_bit(WDM_OVERFLOW, &desc->flags);
>  	rv =3D recover_from_urb_loss(desc);
>  	mutex_unlock(&desc->plock);
>  	return 0;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-NK8gE6bvLB5AwkMKdv9e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFpHee/yOyVhhEJAQqm5RAAxTlD7+fc1FABBKWiePQjbWKK4Aib+tl3
6LvNkZOhEtMFa/X2v3iQnhfQiDuvc2OwuIyQBNx2Lm+zVGJ0cW5AtfuZr/3k+YKT
9OZslwMfGQLFeCln429s+3eMFet6QUNoq8fCMMA0ZT2Hcc4np91EKhZJtKCUb6gB
yRME+NmjG2Q/mrjQWPDfxNvlgQrXdks8QqtqvQesmG3uHsTz0IoWuJuzNpOvqw56
2OsG3S/v0/Hzj/cdg1UYQjOGbjIQvo0xoII6gm/wXqbSizbwwGbJ2CpZymrCg20f
9Va8nfIZ2DE7poc4t66Ccab23y/+7+xSqOfwNtV1Ds8mhj9qt9lDatCDpCIkfIhK
3fn5N5kJno1dK1wiAo/2FUQWoqJfxGGPgRVFP618xnGOfc2QQ/lc9ziuG0Oyl752
wcbJX0D1Tttw1JZ/L+3B6Kky2kee1GFBfavh9eKn/Rm9y0eCYT5+5eTS6+4/RIUV
mH0dQgGmJuOFEgMOr6j2CI93ndHgx04NTYCfhTmGb5yzsHJaHHZlwt3rA2Q0iX4j
prTsnwXZphWHlB/Vs4NFr35ldeaSEpUfl9LTmgf6dSq5blr94ZNDe2sh1Fvx4umo
yKtqh1UdtnyRgw9gZYcGkwx40aGO8Fwj1wSXXPL3R+UsoMcXBTDQg4b5kVscqlCg
KRHP2nbpVBc=
=afzU
-----END PGP SIGNATURE-----

--=-NK8gE6bvLB5AwkMKdv9e--
