Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3ISNWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:22:53 -0400
Received: from ozlabs.org ([203.10.76.45]:44413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab3ISNWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:50 -0400
Date: Thu, 19 Sep 2013 22:27:23 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Jon Loeliger <jdl@jdl.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
Message-ID: <20130919122723.GC3551@voom.redhat.com>
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
 <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 01:41:16PM -0700, Olof Johansson wrote:
> On Wed, Sep 18, 2013 at 1:23 PM, Stephen Warren <swarren@wwwdotorg.org> w=
rote:
> > From: Stephen Warren <swarren@nvidia.com>
> >
> > ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> > node that has a reg property must include a unit address in its name
> > with value matching the first entry in its reg property. Conversely, if
> > a node does not have a reg property, the node name must not include a
> > unit address.
> >
> > Implement a check for this. The code doesn't validate the format of the
> > unit address; ePAPR implies this may vary from binding to binding, so
> > I'm not sure that it's possible to validate the value itself.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > This depends on my previous patch "Ensure all tests have matching reg
> > and unit address".
> >
> > Note that this patch should not yet be applied; it will cause many real-
> > world *.dts files to fail to compile. Those need to be fixed first.
> > However, if/when that happens, this patch may be useful.
> > ---
> >  checks.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/checks.c b/checks.c
> > index ee96a25..c80a055 100644
> > --- a/checks.c
> > +++ b/checks.c
> > @@ -287,9 +287,25 @@ NODE_ERROR(node_name_chars, PROPNODECHARS "@");
> >  static void check_node_name_format(struct check *c, struct node *dt,
> >                                    struct node *node)
> >  {
> > -       if (strchr(get_unitname(node), '@'))
> > +       const char *unitname;
> > +       struct property *prop;
> > +
> > +       unitname =3D get_unitname(node);
> > +
> > +       if (strchr(unitname, '@'))
> >                 FAIL(c, "Node %s has multiple '@' characters in name",
> >                      node->fullpath);
> > +
> > +       prop =3D get_property(node, "reg");
> > +       if (prop) {
> > +               if (!unitname[0])
> > +                       FAIL(c, "Node %s has a reg property, but no uni=
t name",
> > +                           node->fullpath);
> > +       } else {
> > +               if (unitname[0])
> > +                       FAIL(c, "Node %s has a unit name, but no reg pr=
operty",
> > +                           node->fullpath);
>=20
> These checks are very useful, even though they might sort of cross
> over the domain to what a dtc linter would do instead of the compiler.

So, I think inside the compiler is the best place for a linter anyway
- that way people will actually run it.

The entire checks infrastructure was built specifically to allow
linting inside the compiler - I just never had time to implement many
checks beyond the basics.

> Anyway, I think it'd be better to produce warnings than errors for
> this. That way we could also merge it now while the trees are fixed
> up.

Yes, I agree.

> Also, maybe warn for @0x<foo>, which is another unpreferred syntax, it
> should just be @<foo> (with foo being in hex).

Well.. that comes to validating the contents of the unit address.  And
as Ben points out that needs per bus type information to know how
they're conventionally formatted.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSOu2rAAoJEGw4ysog2bOSTDkQAM4xAolQxe+p38i6R3ztw+UH
5qho1CKwoBaIb+77rmlgiurk5XG3rWwTD+eCSJ2zPFcLuPuQo7V+O6ipJXgslOUj
5ceMloJEmZiaVZ/SfJglJN5RxgbkvIlGd9vbKQL3pZWtp/0joky7/FjZTg+k+F/6
NMOyIvDduBoP3qhIV/xGQb0he9nxme9l9BF9IRT45MeBHYyWAOynC8OsHLDQnKrc
qAqsJeieq3avtXEFI7GPMNJjDoul7CeY+SRHIW5Fuk0OKyR/aJzoXECilKfcvXs6
SI56CVZFU9mMtkTVfrS/GRRxSH9eF3oCGrXYDRcRWq40krzIjZm4NHqkgucj/8Dq
4dSosSdxSHUqLQMgXwqypuj5TAjtGK6lxql6AOEAWn9FKm3gOaGk/DL4uHtKqNG9
kVcHwJhGRMTMsuJeDCJl7ZekjkfCZxUAbEj1ZLN56qPJ4oyN85p2FvOw1D9hKaii
We3xECv7ZvKq9UqsRk7gjvX614WjydsVAcaO7jUxPUExPEgsvGHvKLKiJ4xcxrj3
nCV3sds/NTqYD/GU8wnyEowr0TbpPIh5E1WuRC+t9Fg3VnT2nWNG+A5ar+O30VjT
Rw2wOw6KKKpQsNNaDTp/2AvsY1SqX5aPAslHYNE2146JmdJlZiHO+PyIXUz1DGNg
WfyjnLat/MqoDi+JzNGR
=l3W6
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
