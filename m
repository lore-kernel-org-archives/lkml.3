Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFENqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:46:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbaFENqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:46:14 -0400
Message-ID: <1401976224.2412.110.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4 022/214] filter: prevent nla extensions to peek
 beyond the end of the message
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 05 Jun 2014 14:50:24 +0100
In-Reply-To: <20140605133331.GB6020@hercules>
References: <20140605041639.638675216@linuxfoundation.org>
	 <20140605041642.768058331@linuxfoundation.org>
	 <20140605133331.GB6020@hercules>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xJFEj+ECafvSm9GXrXfS"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xJFEj+ECafvSm9GXrXfS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-06-05 at 14:33 +0100, Luis Henriques wrote:
> On Wed, Jun 04, 2014 at 09:16:25PM -0700, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Mathias Krause <minipli@googlemail.com>
> >=20
> > [ Upstream commit 05ab8f2647e4221cbdb3856dd7d32bd5407316b3 ]
> >=20
> > The BPF_S_ANC_NLATTR and BPF_S_ANC_NLATTR_NEST extensions fail to check
> > for a minimal message length before testing the supplied offset to be
> > within the bounds of the message. This allows the subtraction of the nl=
a
> > header to underflow and therefore -- as the data type is unsigned --
> > allowing far to big offset and length values for the search of the
> > netlink attribute.
> >=20
> > The remainder calculation for the BPF_S_ANC_NLATTR_NEST extension is
> > also wrong. It has the minuend and subtrahend mixed up, therefore
> > calculates a huge length value, allowing to overrun the end of the
> > message while looking for the netlink attribute.
> >=20
> > The following three BPF snippets will trigger the bugs when attached to
> > a UNIX datagram socket and parsing a message with length 1, 2 or 3.
> >=20
> >  ,-[ PoC for missing size check in BPF_S_ANC_NLATTR ]--
> >  | ld	#0x87654321
> >  | ldx	#42
> >  | ld	#nla
> >  | ret	a
> >  `---
> >=20
> >  ,-[ PoC for the same bug in BPF_S_ANC_NLATTR_NEST ]--
> >  | ld	#0x87654321
> >  | ldx	#42
> >  | ld	#nlan
> >  | ret	a
> >  `---
> >=20
> >  ,-[ PoC for wrong remainder calculation in BPF_S_ANC_NLATTR_NEST ]--
> >  | ; (needs a fake netlink header at offset 0)
> >  | ld	#0
> >  | ldx	#42
> >  | ld	#nlan
> >  | ret	a
> >  `---
> >=20
> > Fix the first issue by ensuring the message length fulfills the minimal
> > size constrains of a nla header. Fix the second bug by getting the math
> > for the remainder calculation right.
> >=20
> > Fixes: 4738c1db15 ("[SKFILTER]: Add SKF_ADF_NLATTR instruction")
> > Fixes: d214c7537b ("filter: add SKF_AD_NLATTR_NEST to look for nested..=
")
> > Cc: Patrick McHardy <kaber@trash.net>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Mathias Krause <minipli@googlemail.com>
> > Acked-by: Daniel Borkmann <dborkman@redhat.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/core/filter.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -338,11 +338,15 @@ load_b:
> > =20
> >  			if (skb_is_nonlinear(skb))
> >  				return 0;
> > +			if (skb->len < sizeof(struct nlattr))
> > +				return 0;
> > +			if (skb->len < sizeof(struct nlattr))
> > +				return 0;
>=20
> There above code is duplicated this backport.  The same comment
> applies to the 3.2.y backport (I've added Ben to the CC list).

This seems to be due to a bug in patch <https://bugs.debian.org/717782>.
I had the same problem when initially trying to fix this in 3.14.  The
first two inserted lines should be 16 lines further up.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-xJFEj+ECafvSm9GXrXfS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5B1qee/yOyVhhEJAQqhxg//RMRwSPLIRZ6sumlpQ59OSw3PCeA82EyX
8r92aRSvCVPzR+FmhDgwlTRnhObTELvvLjJs/L+u4i8ALYS679MbSn3ox7Itapz7
9oGLFjKPtLu3zPe4EFyGmECQTvK/WIHIwszaB5uxLjasE5W66pE8VHtnrUBOSDe8
3oU88hwB2p12D8hrlDkB+gGSEmgrJYvUFwPuSP0xmW90BCK5ojK4vN3VhrRkmard
Bc5wRc4G8T8nHiXFgyCC12Y1ZJgS8P3EPyYSk8VGYA5Y3Wql/ltH8+wnjYFHWT0S
xi/CXzGlE+Mirm2K7NFQFsh6h0ro9lQ/TvTanVYHCuMB5QsmODAE2NCMn1PiA3B6
jTFosv+TCxyFUVG2UNWyqCDmToJ95u7Eb6f1C3MYb0c2feQoVsMO2ULT11tK5ngy
vOdpfbaorXjpSHPZ/gmlrjFga8laxWyOsiuGJWaqWqyTo8wD57AV1pgShPd/a+5E
oRXzkEpgXbW0TzPaGFVNpaFU8SlWstXrxhQl9dGZ8uEyUeWrIHNhgd6DSVgvyS00
pRmzNaBdglWrhercEDd10K1S6w2UHoMq5gJLmhjshWb8n2Ntf40z49WNJZqYFoYO
EP4FTY/9QU9c5vurqUMymYFRsjuo4dbRpTJ5gao4FL3kIu5xdf2BGaXGMvQ/dZT9
Ykuw5Ir0KIA=
=+MM7
-----END PGP SIGNATURE-----

--=-xJFEj+ECafvSm9GXrXfS--
