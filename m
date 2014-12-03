Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaLCTia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:38:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33191 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLCTi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:38:29 -0500
Date: Wed, 3 Dec 2014 13:38:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about patch "i2c: omap: resize fifos before each
 message"
Message-ID: <20141203193826.GK16138@saruman>
Reply-To: <balbi@ti.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com>
 <20141203154936.GF16138@saruman>
 <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com>
 <20141203174938.GJ16138@saruman>
 <7602A84A-43B2-4C22-ACFA-FEA0640A6B7D@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIbT1ud6duwZIwNL"
Content-Disposition: inline
In-Reply-To: <7602A84A-43B2-4C22-ACFA-FEA0640A6B7D@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KIbT1ud6duwZIwNL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 03, 2014 at 10:01:33PM +0300, Alexander Kochetkov wrote:
> 03 =D0=B4=D0=B5=D0=BA. 2014 =D0=B3., =D0=B2 20:49, Felipe Balbi <balbi@ti=
=2Ecom> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
>=20
> >  It can also be a master receiver and a
> > slave transmitter.=20
> Agree, but this unrelated to races.
>=20
> >  Note also that MST bit does *not* auto clear.
>=20
> Yes, it *does* auto clear!
> MST bit automatically clear when IP receive AL.
> See TRM [1]. All other TRMs (omap3530, omap3430,=20
> omap4, omap5) has the same picture.
>=20
> From TRM:
> 2Ci.I2C_CON[10] MST bits are cleared by hardware
>=20
> And MST bit clear after IP send STP (success transfer).
>=20
> Did you see what value is in CON register after successful master
> transfer?  Apply my patch and see that.
> It doesn't have MST bit set. That mean IP is in slave mode (receiver
> or transmitter - doesn't matter) after *any* master transfer.
>=20
> And simple test show that. IP respond to GC address (address 0).
> And respond to SA address (if programmed).
>=20
> And TRM[1] figure has comment for 'end' state:
> "I2C controller goes into slave receiver mode."

had completely missed that comment. Right, IP will switch over into
slave mode. Still, as of today, this can't happen because Multimaster
isn't supported :-)

> And IP keeps into slave mode until 'suspend'.
>=20
> Then, after 'resume' IP initialized into slave receiver mode. There is
> short time after resume and master start initialize new transfer.
>=20
> So, then we start new transfer IP could start receiving slave command.

you'd first receive an interrupt which would let you figure out if the
interrupt was for Slave or Master modes. Then you can do anything you
want (set a flag that you're going into slave mode and return -EAGAIN on
any master transfer request for example).

> > Also,
> > the IP won't do anything (considering it's always in master mode) until
> > STT bit is set again
> Yes, it do slave reception or tranmittion with STT bit set to 0.
>=20
> You could set STT bit to 1, and then it got cleared to 0, you
> now, that IP received Start condition with slave transfer.
>=20
> You could leave STT bit set to 0, but IP still respond to slave transfer.
> (at least the IP on dm3730).
>=20
> And we can't set MST bit again after master transfer to leave IP in the
> master mode. We must disable IP (clear EN bit) before transfers to
> disable slave mode, or we must handle slave interrupts.

then handle slave interrupts :-) But handle them so that it won't race
with a master transfer request. Moving omap_i2c_xfer() inside the IRQ
handler isn't the best way to do it, however.

--=20
balbi

--KIbT1ud6duwZIwNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUf2ayAAoJEIaOsuA1yqREdGgP/2QrEGaKutdNngjuDJxCX2+N
4SbYe18cvBdNJ0/pzuCqJIk2VQkL7Aw4ExIHI96403GuFPjPbIU7jyDJHzs2DAWp
+j4pzDbMNZNQJzGmBHZNrXSmBq3kLJ3fPRVq57XcJJqW1AiSsnHLH1KIavWqXbKt
GhpV9ADfwqsidCeThewreCvtBFYj6kcVluFDdCyXQ+nl1JQ3RR+JkiVOr1y7HCjQ
z4jRUXQDq91eiX19jA/eoLDcl/tkXVsUbp2OHRpK1oyBIrK1mFY8CqAxZOGNSedc
onYwdO4uhIJzRrq7KiBeZuqWZrcqBlP1RdZqEEsyRpfikeIMoUyI+zR4fgHTnFGp
A7679ZsW5NGfWF4WVpdqn68r7m7IAiOi9QfWOYsrrm79fZ83/XACMfKtNpKKOeey
WXdGvgrqX7rAy/ktc5PIeu5XNpyz6WGNfOXkmXUIf25N6gpsjDb6u+rVEvGD1XSb
HzhOcUerh06VuJ0RyJ5FZrP9X+jT7G7Fj7GUeE2jmS+Mthqi0U7z73M+m4UIBDxO
UnIjNuqDZA4ZJJ2g7mdFLVZp/HuS2HNmh4rEWkWITkuts921yddNiqyOemhM011K
FgBdcHpatjphK7g6xM/yhcdt2JYmGLE9rtsyKJV6e/MdAlg9A3gtEVT9UvpeYllv
lloP6Fy4XAxlXitjhSFW
=W+3H
-----END PGP SIGNATURE-----

--KIbT1ud6duwZIwNL--
