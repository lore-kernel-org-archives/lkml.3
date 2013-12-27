Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3L0TKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:10:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51578 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab3L0TKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:10:37 -0500
Message-ID: <1388171427.26981.77.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Date: Fri, 27 Dec 2013 20:10:27 +0100
In-Reply-To: <20131227184740.GA5180@kroah.com>
References: <1388164698.26981.73.camel@deadeye.wl.decadent.org.uk>
	 <20131227184740.GA5180@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MJACTThp1t0uFUz9PKOs"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.127.160
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MJACTThp1t0uFUz9PKOs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-12-27 at 10:47 -0800, Greg Kroah-Hartman wrote:
> On Fri, Dec 27, 2013 at 06:18:18PM +0100, Ben Hutchings wrote:
> > snprintf() returns the number of bytes that could have been written
> > (excluding the null), not the actual number of bytes written.  Given a
> > long enough subsystem or device name, these functions will advance
> > beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> > in an information leak or stack corruption.  I don't know whether such
> > a long name is currently possible.
> >=20
> > In case snprintf() returns a value >=3D the buffer size, do not add
> > structured logging information.  Also WARN the first time this
> > happens, so we can fix the driver or increase the buffer size.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/base/core.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >=20
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 67b180d..989a93c 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -2022,6 +2022,8 @@ create_syslog_header(const struct device *dev, ch=
ar *hdr, size_t hdrlen)
> >  		return 0;
> > =20
> >  	pos +=3D snprintf(hdr + pos, hdrlen - pos, "SUBSYSTEM=3D%s", subsys);
> > +	if (pos >=3D hdrlen)
> > +		goto overflow;
> > =20
> >  	/*
> >  	 * Add device identifier DEVICE=3D:
> > @@ -2053,7 +2055,14 @@ create_syslog_header(const struct device *dev, c=
har *hdr, size_t hdrlen)
> >  				"DEVICE=3D+%s:%s", subsys, dev_name(dev));
> >  	}
> > =20
> > +	if (pos >=3D hdrlen)
> > +		goto overflow;
> > +
> >  	return pos;
> > +
> > +overflow:
> > +	dev_WARN_ONCE(dev, 1, "device/subsystem name too long");
>=20
> Why only warn once?  Any device/subsystem mix should be complained
> about, if for only that we should be really annoying about it to get it
> resolved.

This would expand the volume of logging for the problem device by a
factor of ~50 so it doesn't seem like a good failure mode.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-MJACTThp1t0uFUz9PKOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUr3Qo+e/yOyVhhEJAQpPExAAj+M35J+lfy9w7SqJD2BNietH2hTK0pN1
S+QbMH8OCanjCyqUyVoF/ljHQ1i7PPLcGjtmPE9K7KtCt+NZxe3WT8W/BC5BKOv8
NoxBmzBX1UsUh9xmUIwnrJfKfZvieS5tZGqHCK2Vdn7RaX71DPkp7YAYnBPEvfo6
AL9J2cypOJCfaD57udKO/MGPUK4DBF8O8OBiIGLC+QG+wljqrMGZ4J3Oj8d57ca8
6Ri8sxRDuyWQP0u3yy9/bl/FNfnvKwRCDkspf3IKCp1HvyC5pmqZiwIpmGo4jP1o
wckxOTpa/6HIV7y/HUsRvIqEncY64qXRpuvxttUKTv1HC6eWi89x9nXID8D6AuWK
W6WIYHcet8F1Wm6eEPLgfE/Vf4gmQllq1qisATlDbhXeaELMbQuMpzZYVOEisG/M
u+fixESucu4RNcwM2Oo2i+N+EKVLKE8JJov45l8T31YMY1lJCk1rRhV9Unmu3Fmk
LJRCONlnLfCoAIgTmVUujmfBfjjRoGuRiAf2ITiLm2Dh0MIwyFRvy7ZxIvALfCVK
8kEavrd/xqI7yuiz/r8dHz02zQlmY463FpDotWBa4ERKdB/ZSxBy6m9lpkQZoIhw
vjXYpY49MySgvua/i8sn0cmcbv/iExaH3Bo3Rmsy5Ed1+J4Elq9Ehsv4W+TilfPj
wxnSePifraQ=
=Rl5p
-----END PGP SIGNATURE-----

--=-MJACTThp1t0uFUz9PKOs--
