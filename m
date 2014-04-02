Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaDBQyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:54:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50361 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbaDBQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:54:10 -0400
Date: Wed, 2 Apr 2014 17:53:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140402165354.GG2269@sirena.org.uk>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140402142356.GE2269@sirena.org.uk>
 <20140402160438.GO1665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="suyaDfHbCMIDpItJ"
Content-Disposition: inline
In-Reply-To: <20140402160438.GO1665@opensource.wolfsonmicro.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--suyaDfHbCMIDpItJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 02, 2014 at 05:04:38PM +0100, Charles Keepax wrote:
> On Wed, Apr 02, 2014 at 03:23:56PM +0100, Mark Brown wrote:
> > On Wed, Apr 02, 2014 at 03:06:54PM +0100, Charles Keepax wrote:

> > > We should be incrementing the reference count of the of_node for the
> > > regulator when we take a copy of it. This patch does so.

> > Why?

> Apologies I must be missing something, take for example the fixed

The immediate thing you're missing is this explanation - it's not
sufficiently obvious why the reference needs to be held.

> regulator driver (fixed.c). We get an of_node from
> pdev->dev->of_node, pull the init_data from it, then copy the
> of_node into the regulator_config and call regulator_register.
> regulator_register will copy the of_node from the regulator_config
> and put it into the new device, but as far as I can see no one ever
> incremented the reference count?

> 	of_node =3D pdev->dev.of_node;

> 	drvdata->dev =3D regulator_register(&drvdata->desc, &cfg);

> Looks like there are a couple of other regulator drivers in the
> same boat. Just seems easier to let the core do the reference
> stuff rather than needing to do it in the drivers.

Two things here.  One is that we're not copying the node, we're copying
a pointer to it (duplicating the node would be a problem since we need
to look for a phandle to the original node to do consumer lookups).  The
other is that if there is an issue with things never getting referenced
at all here then taking a reference within the regulator code is too
late - if a reference isn't already held at the point where we pass the
node into the regulator core then the pointer that's getting passed
about is already potentially invalid. =20

To make this correct we need to at least ensure that the node passed
into the regulator API is valid and referenced at that time so there
should only be an issue for the core if the reference is dropped after
that.  In the above case the device model is holding a reference since
this is the of_node for the device itself so taking the reference won't
hurt but is redundant.  In cases where we have more than one regulator
and are using of_regulator_match() then things are more tricky.
Something needs to drop the references it returns (which isn't happening
at all at the minute).  Doing it while doing the match and register
seems simple and neat from an error handling point of view so having the
core take an additional reference during the registration would join up
with that.

--suyaDfHbCMIDpItJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPECfAAoJELSic+t+oim9DiQP/Rubn4699OUX+LAPterW7T9L
ZWkjVOWYrCSo68X7v4QKIw5Zc6iU+VMSvh7cJv7ftYTWH20rrUf4GoDqbg1NQcN8
gNURwXNNRwL7dhTzEoRQhqEd/bYELDZ2P8G5t3xjvD3l7oxdixWP7RnjCehT+X5Z
06jD7jngHNfaNmgj6ivl8Oluq4c80WRdMmS3d7wvVxXsXlrMDFAemoJpjKa2bVGT
M0n5EMheh2RNwEBy/plhNfxXL1aTmVsZMdj4COxFzAmc2GQZCKZVGec7xVc8ljum
IiIf4QI4yyoJXX7xjpmmvL67qeitHDYVL6Gh4e/Nuj7OrziPnMhJNY7UXOHwjnoQ
1kRasWl8FCfMsuJp2B5oufqqC1VJHN7KwfNyEWj+bqtg0Ufu2uVrx9nAlrXW5GQo
H9z9SgR9rtgaqGfxODVuTAAawdoKpDJSRcQrpZIS3aXKApR0hh44o0LZj8EgoSYk
AWPy6oX/skJafHn65MPrzfwDcPXFZNIewQFAUyVfFTKZDSkRv5kKV+rpUBMeV93A
L8gFW+DxhTLsu5mkEgpDMRY94mkyYPPbuilLBBNbP03h81gVzFbq1xxsLsMn4pFq
ExObjuKI7Gr1SmKw5ZthKI37RgJZC/kiDzx24Obw9AwyOXHjM/T2UK0bXx49a2ak
9LRvkQm+5KCJYm26qAGu
=qcAA
-----END PGP SIGNATURE-----

--suyaDfHbCMIDpItJ--
