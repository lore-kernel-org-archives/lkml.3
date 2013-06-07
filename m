Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FGGHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:07:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab3FGGHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:07:52 -0400
Message-ID: <1370585253.4021.93.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 150/184] ipv4: check rt_genid in dst_check
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>, Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Timo =?ISO-8859-1?Q?Ter=E4s?= <timo.teras@iki.fi>
Date: Fri, 07 Jun 2013 07:07:33 +0100
In-Reply-To: <20130604172136.519104713@1wt.eu>
References: <20130604172136.519104713@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Xw9QddyPQSlILLk1z/SG"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xw9QddyPQSlILLk1z/SG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Benjamin LaHaise <bcrl@kvack.org>
>=20
> commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92
> Author: Timo Ters <timo.teras@iki.fi>
> Date:   Thu Mar 18 23:20:20 2010 +0000
>=20
>     ipv4: check rt_genid in dst_check
>=20
>     Xfrm_dst keeps a reference to ipv4 rtable entries on each
>     cached bundle. The only way to renew xfrm_dst when the underlying
>     route has changed, is to implement dst_check for this. This is
>     what ipv6 side does too.
>=20
>     The problems started after 87c1e12b5eeb7b30b4b41291bef8e0b41fc3dde9
>     ("ipsec: Fix bogus bundle flowi") which fixed a bug causing xfrm_dst
>     to not get reused, until that all lookups always generated new
>     xfrm_dst with new route reference and path mtu worked. But after the
>     fix, the old routes started to get reused even after they were expire=
d
>     causing pmtu to break (well it would occationally work if the rtable
>     gc had run recently and marked the route obsolete causing dst_check t=
o
>     get called).
>=20
>     Signed-off-by: Timo Teras <timo.teras@iki.fi>
>     Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> This commit is based on the above, with the addition of verifying blackho=
le
> routes in the same manner.

That addition doesn't seem to correspond to anything in mainline.  Why
should 2.6.32 differ?

Ben.

> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/ipv4/route.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 58f141b..f16d19b 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1412,7 +1412,7 @@ void ip_rt_redirect(__be32 old_gw, __be32 daddr, __=
be32 new_gw,
>  					dev_hold(rt->u.dst.dev);
>  				if (rt->idev)
>  					in_dev_hold(rt->idev);
> -				rt->u.dst.obsolete	=3D 0;
> +				rt->u.dst.obsolete	=3D -1;
>  				rt->u.dst.lastuse	=3D jiffies;
>  				rt->u.dst.path		=3D &rt->u.dst;
>  				rt->u.dst.neighbour	=3D NULL;
> @@ -1477,7 +1477,7 @@ static struct dst_entry *ipv4_negative_advice(struc=
t dst_entry *dst)
>  	struct dst_entry *ret =3D dst;
> =20
>  	if (rt) {
> -		if (dst->obsolete) {
> +		if (dst->obsolete > 0) {
>  			ip_rt_put(rt);
>  			ret =3D NULL;
>  		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
> @@ -1700,7 +1700,9 @@ static void ip_rt_update_pmtu(struct dst_entry *dst=
, u32 mtu)
> =20
>  static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cooki=
e)
>  {
> -	return NULL;
> +	if (rt_is_expired((struct rtable *)dst))
> +		return NULL;
> +	return dst;
>  }
> =20
>  static void ipv4_dst_destroy(struct dst_entry *dst)
> @@ -1862,7 +1864,8 @@ static int ip_route_input_mc(struct sk_buff *skb, _=
_be32 daddr, __be32 saddr,
>  	if (!rth)
>  		goto e_nobufs;
> =20
> -	rth->u.dst.output=3D ip_rt_bug;
> +	rth->u.dst.output =3D ip_rt_bug;
> +	rth->u.dst.obsolete =3D -1;
> =20
>  	atomic_set(&rth->u.dst.__refcnt, 1);
>  	rth->u.dst.flags=3D DST_HOST;
> @@ -2023,6 +2026,7 @@ static int __mkroute_input(struct sk_buff *skb,
>  	rth->fl.oif 	=3D 0;
>  	rth->rt_spec_dst=3D spec_dst;
> =20
> +	rth->u.dst.obsolete =3D -1;
>  	rth->u.dst.input =3D ip_forward;
>  	rth->u.dst.output =3D ip_output;
>  	rth->rt_genid =3D rt_genid(dev_net(rth->u.dst.dev));
> @@ -2187,6 +2191,7 @@ local_input:
>  		goto e_nobufs;
> =20
>  	rth->u.dst.output=3D ip_rt_bug;
> +	rth->u.dst.obsolete =3D -1;
>  	rth->rt_genid =3D rt_genid(net);
> =20
>  	atomic_set(&rth->u.dst.__refcnt, 1);
> @@ -2411,7 +2416,8 @@ static int __mkroute_output(struct rtable **result,
>  	rth->rt_gateway =3D fl->fl4_dst;
>  	rth->rt_spec_dst=3D fl->fl4_src;
> =20
> -	rth->u.dst.output=3Dip_output;
> +	rth->u.dst.output =3D ip_output;
> +	rth->u.dst.obsolete =3D -1;
>  	rth->rt_genid =3D rt_genid(dev_net(dev_out));
> =20
>  	RT_CACHE_STAT_INC(out_slow_tot);
> @@ -2741,6 +2747,7 @@ static int ipv4_dst_blackhole(struct net *net, stru=
ct rtable **rp, struct flowi
>  	if (rt) {
>  		struct dst_entry *new =3D &rt->u.dst;
> =20
> +		new->obsolete =3D -1;
>  		atomic_set(&new->__refcnt, 1);
>  		new->__use =3D 1;
>  		new->input =3D dst_discard;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-Xw9QddyPQSlILLk1z/SG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF4pee/yOyVhhEJAQoFdA/+JtXwyPof4bdKTUc+oq3uLptLBVAyd4iX
JQPbmjYpvaDLnYXnamwhF6g78rqgY2+/tGlIjbIZVOgZ0/Q5KhlMegaWPdCnCKru
ycmmaj0e+R2RpV2YIPPDbnSJ8nl4cgQBpsOn60ZnXqPCGQSjq+mcHNsExPkIrpfR
pTceS0wbqLvAd972V0srhmVglWA3nnHmH9RhQhKo9oEyt4cGxEzBiVsL3i6Ktkpt
J7f+11S9034iS2n6Y3Tz39GEvJkAxATDzxhMckKJcbt4JGIadFI0Vdt2MHrmPsWe
t5TkR4bx+WwgwBLJ5qMxcxhQ+1hHkUks4bgeq2ePFczw97JzOWpxTaq+mLPVQuEb
6hlGhF7iOBrx/URICVLmIC/GvP31B5Q4j8fA5ZvtK43cILCyqtmpZBv0YKz32kRM
soZ2cdp+85Y2ein6FomrgrvQrKDE4R7l/J2GOuZ0yMgnh8+XjWP1c+4cyl+8TcPy
5DROJqtrQ5sKXcpwZhdjZRMbXNtQZVB9M/ug63rmqJeaobvpshMqRvLIRg0uiNvn
feti3lrRPF4KL6zPiGOEB5tojipRSwZQ1Gk8OGvg5tk7i432VPdMaVfSRpE2hNvS
+0XtWV0DEDXLWp6KGkKetZLb9ugPZF7EDjZYlRy+fvVNDpnN1ABfpd6MKnKos7XR
Zi4kphwh5+I=
=PmQR
-----END PGP SIGNATURE-----

--=-Xw9QddyPQSlILLk1z/SG--
