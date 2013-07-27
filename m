Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3G0R6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:58:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab3G0R6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:58:36 -0400
Message-ID: <1374947906.13555.51.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 42/79] vlan: fix a race in egress prio management
From: Ben Hutchings <ben@decadent.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Jul 2013 18:58:26 +0100
In-Reply-To: <1374946729.3669.5.camel@edumazet-glaptop>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204726.846842461@linuxfoundation.org>
	 <1374944157.13555.43.camel@deadeye.wl.decadent.org.uk>
	 <1374946729.3669.5.camel@edumazet-glaptop>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8agL0+ieA6eftw/ApZZI"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8agL0+ieA6eftw/ApZZI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-07-27 at 10:38 -0700, Eric Dumazet wrote:
> On Sat, 2013-07-27 at 17:55 +0100, Ben Hutchings wrote:
> > On Fri, 2013-07-26 at 13:47 -0700, Greg Kroah-Hartman wrote:
> > > 3.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Eric Dumazet <edumazet@google.com>
> > >=20
> > > [ Upstream commit 3e3aac497513c669e1c62c71e1d552ea85c1d974 ]
> > >=20
> > > egress_priority_map[] hash table updates are protected by rtnl,
> > > and we never remove elements until device is dismantled.
> > >=20
> > > We have to make sure that before inserting an new element in hash tab=
le,
> > > all its fields are committed to memory or else another cpu could
> > > find corrupt values and crash.
> > >=20
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Patrick McHardy <kaber@trash.net>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  net/8021q/vlan_dev.c |    7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >=20
> > > --- a/net/8021q/vlan_dev.c
> > > +++ b/net/8021q/vlan_dev.c
> > > @@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_
> > >  {
> > >  	struct vlan_priority_tci_mapping *mp;
> > > =20
> > > +	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priorit=
y() */
> > > +
> > >  	mp =3D vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF=
)];
> >=20
> > This barrier is the wrong type in the wrong place; there should be a
> > smp_read_barrier_depends() *after* reading the pointer from
> > egress_priority_map, and after reading each next pointer.
> >=20
>=20
> Not sure its a problem anyway, as we insert new items at the beginning
> of the chain, and we never delete any item. What you describe would make
> sense if we were deleting an item.
>
> Once a reader gets a pointer, the whole chain is stable.

For every sane architecture, data-dependency is an automatic read
barrier.  But Alpha is weird: it can prefetch mp->foo using a speculated
value for mp before it sees mp.  If the speculation was correct it won't
get the correct value of mp->foo.  Hence smp_read_barrier_depends(). =20

> The important part of the patch was the smp_wmb(), to make sure np->next
> was committed before "vlan->egress_priority_map[skb_prio & 0xF] =3D np;"

Sure.  But the smp_rmb() you added doesn't synchronise with it (a
barrier is always between operations, but where is the 'before'
operation here?).

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-8agL0+ieA6eftw/ApZZI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfQKQ+e/yOyVhhEJAQqoCBAAzu9EpiW11dDK9ET57tK67s1fn+nLdPEC
+Gms6ocrH/MnmfrCJ+l//m3DSAxAmBRjbNahsIcYhfjlFhAU8i680zXWqIoTlDpX
Lj4QXNX3Uj+MV+n3Ca8GmNy219hnIJtLyeuJsMPCd0y5EPZYrInKriqiPHLS6C+0
3tnZEEw4unXq9zhxDksIkBZTvFh17sz4uNGNx2zBs34Wbs5NbGl1ddKxys3thCpz
ww0ZuzWa/RNJyldkKeduzgGdKhzl50PTVaz7Nt0axdTmlf/OL8Krkof0tKer+BEg
TVCzarQceNr/k6PDhFEOmaE2vPK+teg26Hv4wS/pQdzMXsk7rAWhZoMZW9WyXETX
oDj4Ju0edqlTu0qaeFJc6VWYgqBbPR0dmt5ypkmLvrl2wW7fRJP1avHmvJ2Jix7k
Hb3iO7DM2CPIjj5vewKMjJBelOYnSPwyTGbT3IRP3WOCc/ttNu3KYckn9b8Kqxid
/oRAgfcrqJb6LU7AWe36Iw6yVYq5+cLLHDSpZ0RTWUDRzrzVeui4Pvexvag3fBvO
G+EnZ6aoCIeaTu4EQwuVpTBIshrI+W57/LiakleL5aKhNE5JU33ncE6KqROHXaXs
C51ZGaYaPw6HVi5TQPiaznk07b3LjOP3wc4TgB7wbXeuNG+ZXTGLC0q443u4Gmc6
D5PO1VXQHFI=
=JNBk
-----END PGP SIGNATURE-----

--=-8agL0+ieA6eftw/ApZZI--
