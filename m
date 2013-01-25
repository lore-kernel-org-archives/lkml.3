Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3AYCbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:31:51 -0500
Received: from ozlabs.org ([203.10.76.45]:46266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab3AYCbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:31:43 -0500
Date: Fri, 25 Jan 2013 13:34:30 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 6/6] OF: Introduce DT overlay support.
Message-ID: <20130125023430.GB25924@truffula.fritz.box>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
 <1357327870-13615-7-git-send-email-panto@antoniou-consulting.com>
 <20130122035056.GF23500@truffula.fritz.box>
 <9768253B-92ED-4298-8BE4-6FAB091DF062@antoniou-consulting.com>
 <20130123051207.GA2228@truffula.fritz.box>
 <EAB57031-78DC-4150-B1A9-F6A19A60293F@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <EAB57031-78DC-4150-B1A9-F6A19A60293F@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 23, 2013 at 01:01:58PM +0200, Pantelis Antoniou wrote:
> On Jan 23, 2013, at 7:12 AM, David Gibson wrote:
> > On Tue, Jan 22, 2013 at 01:08:04PM +0200, Pantelis Antoniou wrote:
> >> Hi
> >>=20
> >> On Jan 22, 2013, at 5:50 AM, David Gibson wrote:
> >>=20
> >>> On Fri, Jan 04, 2013 at 09:31:10PM +0200, Pantelis Antoniou wrote:
> >>>> Introduce DT overlay support.
> >>>> Using this functionality it is possible to dynamically overlay a par=
t of
> >>>> the kernel's tree with another tree that's been dynamically loaded.
> >>>> It is also possible to remove node and properties.
> >>>>=20
> >>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >>>> ---
> >>>> Documentation/devicetree/overlay-notes.txt | 179 +++++++
> >>>> drivers/of/Kconfig                         |  10 +
> >>>> drivers/of/Makefile                        |   1 +
> >>>> drivers/of/overlay.c                       | 831 +++++++++++++++++++=
++++++++++
> >>>> include/linux/of.h                         | 107 ++++
> >>>> 5 files changed, 1128 insertions(+)
> >>>> create mode 100644 Documentation/devicetree/overlay-notes.txt
> >>>> create mode 100644 drivers/of/overlay.c
> >>>>=20
> >>>> diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentat=
ion/devicetree/overlay-notes.txt
> >>>> new file mode 100644
> >>>> index 0000000..5289cbb
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/overlay-notes.txt
> >>>> @@ -0,0 +1,179 @@
> >>>> +Device Tree Overlay Notes
> >>>> +-------------------------
> >>>> +
> >>>> +This document describes the implementation of the in-kernel
> >>>> +device tree overlay functionality residing in drivers/of/overlay.c =
and is a
> >>>> +companion document to Documentation/devicetree/dt-object-internal.t=
xt[1] &
> >>>> +Documentation/devicetree/dynamic-resolution-notes.txt[2]
> >>>> +
> >>>> +How overlays work
> >>>> +-----------------
> >>>> +
> >>>> +A Device Tree's overlay purpose is to modify the kernel's live tree=
, and
> >>>> +have the modification affecting the state of the the kernel in a wa=
y that
> >>>> +is reflecting the changes.
> >>>=20
> >>> Um.. I'm having a great deal of trouble parsing that sentence.
> >>>=20
> >>>> +Since the kernel mainly deals with devices, any new device node tha=
t result
> >>>> +in an active device should have it created while if the device node=
 is either
> >>>> +disabled or removed all together, the affected device should be der=
egistered.
> >>>> +
> >>>> +Lets take an example where we have a foo board with the following b=
ase tree
> >>>> +which is taken from [1].
> >>>> +
> >>>> +---- foo.dts ------------------------------------------------------=
-----------
> >>>> +	/* FOO platform */
> >>>> +	/ {
> >>>> +		compatible =3D "corp,foo";
> >>>> +
> >>>> +		/* shared resources */
> >>>> +		res: res {
> >>>> +		};
> >>>> +
> >>>> +		/* On chip peripherals */
> >>>> +		ocp: ocp {
> >>>> +			/* peripherals that are always instantiated */
> >>>> +			peripheral1 { ... };
> >>>> +		}
> >>>> +	};
> >>>> +---- foo.dts ------------------------------------------------------=
-----------
> >>>> +
> >>>> +The overlay bar.dts, when loaded (and resolved as described in [2])=
 should
> >>>> +
> >>>> +---- bar.dts ------------------------------------------------------=
-----------
> >>>> +/plugin/;	/* allow undefined label references and record them */
> >>>> +/ {
> >>>> +	....	/* various properties for loader use; i.e. part id etc. */
> >>>> +	fragment@0 {
> >>>> +		target =3D <&ocp>;
> >>>> +		__overlay__ {
> >>>> +			/* bar peripheral */
> >>>> +			bar {
> >>>> +				compatible =3D "corp,bar";
> >>>> +				... /* various properties and child nodes */
> >>>> +			}
> >>>> +		};
> >>>> +	};
> >>>> +};
> >>>> +---- bar.dts ------------------------------------------------------=
-----------
> >>>> +
> >>>> +result in foo+bar.dts
> >>>> +
> >>>> +---- foo+bar.dts --------------------------------------------------=
-----------
> >>>> +	/* FOO platform + bar peripheral */
> >>>> +	/ {
> >>>> +		compatible =3D "corp,foo";
> >>>> +
> >>>> +		/* shared resources */
> >>>> +		res: res {
> >>>> +		};
> >>>> +
> >>>> +		/* On chip peripherals */
> >>>> +		ocp: ocp {
> >>>> +			/* peripherals that are always instantiated */
> >>>> +			peripheral1 { ... };
> >>>> +
> >>>> +			/* bar peripheral */
> >>>> +			bar {
> >>>> +				compatible =3D "corp,bar";
> >>>> +				... /* various properties and child nodes */
> >>>> +			}
> >>>> +		}
> >>>> +	};
> >>>> +---- foo+bar.dts --------------------------------------------------=
-----------
> >>>> +
> >>>> +As a result of the the overlay, a new device node (bar) has been cr=
eated
> >>>> +so a bar platform device will be registered and if a matching devic=
e driver
> >>>> +is loaded the device will be created as expected.
> >>>=20
> >>> Hrm.  This all seems rather complicated.  Maybe it needs to be, but
> >>> I'm not entirely convinced yet.
> >>>=20
> >>> One other point - both of these patches are assuming that the overlay
> >>> is in the "live tree" format, but it still needs a bunch of extra
> >>> mangling.  Would it simplify things to just go straight from the
> >>> overlay in flat tree form to modifications to the system-wide live
> >>> tree.
> >>=20
> >> Sorry, I can't parse this. You mean apply the overlay without converti=
ng
> >> to live tree format?
> >=20
> > Yes.
> >=20
>=20
> The gymnastics required when operating on the flat tree will make grown, =
tough as nails
> s/w developers cry.

It's really not that bad.  In particular it's only tricky if you want
to make alterations to the flat tree, which you shouldn't need to
here.

> In essence you will have to replicate the unflattening functionality agai=
n, create a
> similar tree structure as the live tree, do your work, and then
> discard it.
>=20
> A bit excessive don't you think?

It would be, if you actually needed to do that.  But what you can
actually do is:
	1. parse the information you need out of the base tree
	2. use the flat tree functions to retrieve the
__local_fixups__ and __fixups__ information from the overlay, parsing
just those into a temporary data structure
	3. Perform a single pass over the flat tree overlay, inserting
each node and and property into the live tree, applying fixups as you
go.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEB7zYACgkQaILKxv3ab8ZDLQCdEOHSntFXELbK89ZYNYifaTY7
ErAAoI+h3EzYDZdoFFeiuU03Riya2Gms
=ClkM
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
