Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaFSNsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:48:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48706 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbaFSNsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:48:13 -0400
Date: Thu, 19 Jun 2014 08:48:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Robert Baldyga'" <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: composite: unlock spinlock before
 usb_gadget_disconnect()
Message-ID: <20140619134805.GC23782@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402658893-4809-1-git-send-email-r.baldyga@samsung.com>
 <063D6719AE5E284EB5DD2968C1650D6D1725C37A@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1725C37A@AcuExch.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 11:36:24AM +0000, David Laight wrote:
> From: Robert Baldyga
> > usb_gadget_disconnect() shouldn't be called under spinlock to avoid
> > spinlock recursion. Function usb_gadget_disconnect() calls pullup(),
> > which is callback from UDC driver, usually calling composite_disconnect=
().
> > This function wants to lock spinlock used in usb_function_deactivate()
> > causing spinlock recursion.
> ...
> > +++ b/drivers/usb/gadget/composite.c
> > @@ -260,8 +260,11 @@ int usb_function_deactivate(struct usb_function *f=
unction)
> >=20
> >  	spin_lock_irqsave(&cdev->lock, flags);
> >=20
> > -	if (cdev->deactivations =3D=3D 0)
> > +	if (cdev->deactivations =3D=3D 0) {
> > +		spin_unlock_irqrestore(&cdev->lock, flags);
> >  		status =3D usb_gadget_disconnect(cdev->gadget);
> > +		spin_lock_irqsave(&cdev->lock, flags);
> > +	}
> >  	if (status =3D=3D 0)
> >  		cdev->deactivations++;
>=20
> That sort of change rings big alarm bells.
> You've effectively isolated the usb_gadget_disconnect() call
> from the check that cdev->deactivations =3D=3D 0.
> And then you increment cdev->deactivations below.
>=20
> Looks like it will be racy to me.

yes, it will. Fixing this requires a much more involved change.

--=20
balbi

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTouoVAAoJEIaOsuA1yqRE83wP/1W1PvC3jgA+vGSqicFXNa3O
XV3T9G/zb0hVuHW5vhZf3jZCTYhA4pHjdO9bWenBY6p4CELdBI0Czd7DesCwcQ99
c0VIqaQjFYRNM24zFvm4Bfze2LIkriTZoDstJYLzqUj1yMihdawN6Fi1kKtR81VR
W00ZmAUSAqxzfUkTNOC3eV5tAcRpKJQBPFqwlZDvolwdBpbn8vL1nBbcXkeBfUVV
3OvbfAaWr5a7my/FeDFbl1BDptl2wS4ymjR3VSk/FxgdQpSRqWsSos/Y4RZYdhru
pi+6VPuSljxLTTexej7Qo5Urqa8A396RbjJvD25mwRWibnRWXYFTCDkzXpxgOSYI
5t4MF8LVBKDAWDHUiU2f3bvHjUnfzF7kXeWfKHAOQeKXnlMbC2eJ8uVPJZa53tp/
4rO0RwFM835RYlYv1dLkRxXiowjgwG3y/0BXX6Ze+UZq6r6tUrHNDjD5zG/2s3/M
jP9gmK7EBOjWKeC3bjVNc7UESbWALzCnJ4L+Yo8SncvbsUvAdzhZxCnwWTx5bVXm
G3MeoB9KGUPc/Pa2qLbOaSzauHuoZBcJN0uKg8YDjkga+Bdda3J3OHGCmwtfNwqZ
0Ln1EbGGHPAEGikoHVeH4n3vr4Nd5LieZqbS9bwjwtr7Nk69Lzu+ZqZCMlIR6lTd
SBXTq3DzeBtlVfcZmtma
=1KSA
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
