Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3CRXbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:31:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40368 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3CRXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:31:01 -0400
Message-ID: <1363649447.3937.348.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/21] target/pscsi: Fix page increment
From: Ben Hutchings <ben@decadent.org.uk>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Mon, 18 Mar 2013 23:30:47 +0000
In-Reply-To: <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223245.664885170@linuxfoundation.org>
	 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
	 <20130318053519.GE6232@hj.localdomain>
	 <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pME1zL/a/4W3ATUBxwb4"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pME1zL/a/4W3ATUBxwb4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-18 at 14:00 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2013-03-18 at 13:35 +0800, Asias He wrote:
> > On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> > > On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > > > 3.0-stable review patch.  If anyone has any objections, please let =
me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Asias He <asias@redhat.com>
> > > >=20
> > > > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > > >=20
> > > > The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong=
 page
> > > > address if the 'while (len > 0 && data_len > 0) { ... }' loop is
> > > > executed more than one once.
> > > >=20
> > > > Signed-off-by: Asias He <asias@redhat.com>
> > > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >=20
> > > > ---
> > > >  drivers/target/target_core_pscsi.c |    1 -
> > > >  1 file changed, 1 deletion(-)
> > > >=20
> > > > --- a/drivers/target/target_core_pscsi.c
> > > > +++ b/drivers/target/target_core_pscsi.c
> > > > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> > > >  				bio =3D NULL;
> > > >  			}
> > > > =20
> > > > -			page++;
> > > >  			len -=3D bytes;
> > > >  			data_len -=3D bytes;
> > > >  			off =3D 0;
> > >=20
> > > So in case a fragment crosses a page boundary, we wrap around to the
> > > beginning of the same page?  That doesn't look right.
> >=20
> > If the fragment crosses a page boundary, what is the correct page
> > for it?
> >=20
> > Nicholas, can we assume sg->length + sg->offset should be less than PAG=
E_SIZE here?
> >=20
>=20
> sg->length + sg->offset can be less than or equal to PAGE_SIZE here.
>
> For everything other than tcm_loop + tcm_vhost using externally
> allocated SGLs, we can expect fragments to never cross the page
> boundary.
>=20
> For tcm_loop + tcm_vhost, there are a few special cases with control CDB
> paylaods (usually going through scsi-generic) where we can have a non
> zero sg->offset, but at least in the cases I've seen this is still not
> using SGL elements that exceed PAGE_SIZE.
>
> So, I think this logic is OK for SGLs that cross page boundries, given
> that it's done outside of the inner loop where *page is set during each
> for_each_sg().

The page is set using sg_page() in the outer loop and was then
incremented in the inner loop.

	for_each_sg(sgl, sg, sgl_nents, i) {
		page =3D sg_page(sg);
		off =3D sg->offset;
		len =3D sg->length;

		while (len > 0 && data_len > 0) {
			bytes =3D min_t(unsigned int, len, PAGE_SIZE - off);
			bytes =3D min(bytes, data_len);
			...
			/* page++; */
			len -=3D bytes;
			data_len -=3D bytes;
			off =3D 0;
		}
	}

The inner loop is apparently meant to iterate over pages of a segment,
but is now just wrapping around a single page.

> The case where this logic is broken, and that the 'page
> ++' was addressing is when sg->length > PAGE_SIZE.

That is a sufficient but not a necessary condition for the increment.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-pME1zL/a/4W3ATUBxwb4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUejp+e/yOyVhhEJAQrHZxAAsKstV3fImZ8Dohj6H+UlntJZubM4xQQV
2TQWA2DI1KMG4Bh3lHeQ+Sad6JPiwtcZWLCDhuwNMUL67PYcE8KNNaIijdn0Fx+c
WYjiXUdIdP5a0I6vvfewyNF6zIcrcwjNAP+VpwIibIYCwSQusrjJv84hkdkMTzk4
KYH9mPrbncaavTkT9HeTy6R2yGCGhBNB/ibyB7ZtDZVZOgPV+R52gRuFGZO6BxHh
bAwfBNyDJ5hRWLXSFWz4+gGo/Oa/kF+qQu/OkbMS0kZ8jg3bYgFlKiluWsZW9JUU
4n0V0ZoNwqLINICTomNHsZ4/WmoE+EyeSJ3/0oNnnH4QXuzR7lzIELxlNrVBSAxF
JdojbeD3igv4nNkRad0KZNOaPqZRH2DptS7ytpFuDWwFgFSC4B1RN0jD3YvC6XbM
HZJPVaNwv6wccPbBrZ6qXkZMqcDMcorKLRAthME9ONIdpgirUYPg/kAtjDTOprWX
RVi8Gx0pK/GIRMq7/n+GZ7jBG+glZoeQ5oVg+hQHnF4DtzZ5D4A1Uhz71r/o25HP
0cvJBq9AtxogdqnigUPDAcO7+5xDLgyWcgRF94xkOZ7qhogd/t4klwFN7ebU8rGU
vB3v80maaIikSwx/flqRmvQaCCQPHQjSmDbLlgjM49ecpaOAXmNISsS6ANVH/0en
eI6cQfuLDcE=
=bKZ6
-----END PGP SIGNATURE-----

--=-pME1zL/a/4W3ATUBxwb4--
