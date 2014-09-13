Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaIMWjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 18:39:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35481 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbaIMWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 18:39:11 -0400
Message-ID: <1410647931.3040.20.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 105/131] net: Correctly set segment mac_len in
 skb_segment().
From: Ben Hutchings <ben@decadent.org.uk>
To: vyasevic@redhat.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 13 Sep 2014 23:38:51 +0100
In-Reply-To: <54119A1C.4020501@redhat.com>
References: <lsq.1410438733.15448606@decadent.org.uk>
	 <54119A1C.4020501@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hsw3a2dtVMbMtPXwISqY"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9881:80b9:b90a:1609
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hsw3a2dtVMbMtPXwISqY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-09-11 at 08:48 -0400, Vlad Yasevich wrote:
> On 09/11/2014 08:32 AM, Ben Hutchings wrote:
> > 3.2.63-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Vlad Yasevich <vyasevic@redhat.com>
> >=20
> > [ Upstream commit fcdfe3a7fa4cb74391d42b6a26dc07c20dab1d82 ]
> >=20
> > When performing segmentation, the mac_len value is copied right
> > out of the original skb.  However, this value is not always set correct=
ly
> > (like when the packet is VLAN-tagged) and we'll end up copying a bad
> > value.
> >=20
> > One way to demonstrate this is to configure a VM which tags
> > packets internally and turn off VLAN acceleration on the forwarding
> > bridge port.  The packets show up corrupt like this:
> > 16:18:24.985548 52:54:00:ab:be:25 > 52:54:00:26:ce:a3, ethertype 802.1Q
> > (0x8100), length 1518: vlan 100, p 0, ethertype 0x05e0,
> >         0x0000:  8cdb 1c7c 8cdb 0064 4006 b59d 0a00 6402 ...|...d@.....=
d.
> >         0x0010:  0a00 6401 9e0d b441 0a5e 64ec 0330 14fa ..d....A.^d..0=
..
> >         0x0020:  29e3 01c9 f871 0000 0101 080a 000a e833)....q.........=
3
> >         0x0030:  000f 8c75 6e65 7470 6572 6600 6e65 7470 ...unetperf.ne=
tp
> >         0x0040:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.ne=
tp
> >         0x0050:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.ne=
tp
> >         0x0060:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.ne=
tp
> >         ...
> >=20
> > This also leads to awful throughput as GSO packets are dropped and
> > cause retransmissions.
> >=20
> > The solution is to set the mac_len using the values already available
> > in then new skb.  We've already adjusted all of the header offset, so w=
e
> > might as well correctly figure out the mac_len using skb_reset_mac_len(=
).
> > After this change, packets are segmented correctly and performance
> > is restored.
> >=20
> > CC: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  net/core/skbuff.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 7121d9b..0ccfb53 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -2669,7 +2669,6 @@ struct sk_buff *skb_segment(struct sk_buff *skb, =
u32 features)
> >  		tail =3D nskb;
> > =20
> >  		__copy_skb_header(nskb, skb);
> > -		nskb->mac_len =3D skb->mac_len;
> > =20
> >  		/* nskb and skb might have different headroom */
> >  		if (nskb->ip_summed =3D=3D CHECKSUM_PARTIAL)
> > @@ -2679,6 +2678,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, =
u32 features)
> >  		skb_set_network_header(nskb, skb->mac_len);
> >  		nskb->transport_header =3D (nskb->network_header +
> >  					  skb_network_header_len(skb));
> > +		skb_reset_mac_len(nskb);
>=20
> This will not fix the problem here because the network header above will
> already be set incorrectly based on the old mac_len.
>=20
> This patch depends on
> commit 030737bcc3c404e273e97dbe06fe9561699a411b
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Sat Oct 19 11:42:54 2013 -0700
>=20
>     net: generalize skb_segment()
>=20
> that correctly populates the header offsets in the new segment.

I can't apply that because 3.2 doesn't even have the
skb_headers_offset_update() function.  So I'm going to drop this patch
for now, but if you or David can provide a complete backport for this
fix I would very much appreciate it.

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-hsw3a2dtVMbMtPXwISqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBTHhee/yOyVhhEJAQosog/+KcHcIK2whlHjeuILrfDMSvElmK8RMJay
hTgxUDuzWXcQ2F2gvFZcW5KSPlcDbqcm3s/YYxupdcHr9bpc0BOGHR5SCwgl/1eA
AqPZpRF8P1Y1afwNPIny/BkNova1uhXoBDmvROqsPPu63/6ciVc6J0rjgeHYCsld
2tTx2hDRUPtcOc4FnhIBSaLsc5N0dv/LiEM72Q/E2Ld2B2WrxTO4wAy5zbR2Dw4q
Q1WKxG3wl8T3svOuAkPlDzwgkaLPpbUNRi51hCipmKKvALy0M9n+gazuyFz2TfAu
73g6lqHf4z+yJh4OLmH+9WCxiuZmrzPMslQjQn06lqRoj+3gQoGB1Yc48W4by3kW
3yHXxLJZ5Ms7W04jYzL1HS2GE5wfhfNJxozbwNnu1K76HvOk0pBrNW0TCg0TQ3Q3
fPds95IMnQAe41mzMNP8krIdTIXgxf3o+NiZm32kZJ2jA19oFj5/EBLUFQrjfrE6
s3EpetxBwqXtndYB0qlnKvuScHx4UAzN0AMQey+d6jl4LZZlJOvnNFA8uEF4+y+3
Tbkp/MaCZRp5Iep446HKXTzprU4PLtc9mbUXP/wKC1B5i7H5CG3aESwr8K+h0TJu
ijhPXahViTxGpRQZVaaHZiCDjs9rb0Uc8Lh8ynP9MK1jSr+d1zJWmKY26uhjHZGx
m3nPEv+tjcc=
=KojE
-----END PGP SIGNATURE-----

--=-hsw3a2dtVMbMtPXwISqY--
