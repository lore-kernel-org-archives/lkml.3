Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbbAPQXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:23:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39751 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbAPQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:23:29 -0500
Date: Fri, 16 Jan 2015 16:23:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150116162314.GB3856@sirena.org.uk>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 2/3] regmap: Use the enhancement of i2c API to address
 circular dependency problem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2015 at 03:39:53PM +0100, Paul Osmialowski wrote:

> This uses the enhancement of i2c API in order to address following problem
> caused by circular lock dependency:

Please don't just dump enormous backtraces into commit messages as
explanations, explain in words what the problem you are trying to
address is.  If the backtrace is longer than the commit message things
probably aren't working well, and similarly if the first thing the
reader sees is several screenfuls of backtrace that's not really aiding
understanding.

This is all particularly important with something like locking where a
clear understanding of the rules and assumptions being made is very
important to ensuring correctness, it's easy to just paper over a
specific problem and miss a bigger problem or introduce new ones.

> Apparently regulator and clock try to acquire lock which is protecting the
> same regmap. Communication over i2c requires clock to be started. Both th=
ings
> require access to the same regmap in order to complete.
> To solve this, i2c clock should be started before attempting operation on
> regulator (which requires locked regmap).

It sounds awfully like something is not doing the right thing with
preparing clocks somewhere along the line but since there's no
analysis it's hard to tell (I don't propose to spend time trawling
backtraces for something I don't know).

Please also use blank lines between paragraphs like all the other commit
messages, it makes things easier to read.

> Exposing preparation and unpreparation stage of i2c transfer serves this
> purpose.

I don't know what this means, sorry.  I'm also very worried about the
fact that this is being discussed purely in terms of I2C - why would
this not affect other buses?

> Note that this change does not require modifications in other places.
>=20
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  drivers/base/regmap/internal.h   |   2 +
>  drivers/base/regmap/regmap-i2c.c |  18 +++++++
>  drivers/base/regmap/regmap.c     | 107 +++++++++++++++++++++++++++++++++=
+++++-
>  include/linux/regmap.h           |   7 +++
>  4 files changed, 133 insertions(+), 1 deletion(-)

Modification may not be required in other places but this is an
*enormous* change in the code which I can't really review.

> +	int (*reg_prepare_sync_io)(void *context);
> +	void (*reg_unprepare_sync_io)(void *context);

The first question here is why this only affects synchronous I/O or
alternatively why these operations have _sync in the name if they aren't
for synchronous I/O.

> +	if (bus) {
> +		map->reg_prepare_sync_io =3D regmap_bus_prepare_sync_io;
> +		map->reg_unprepare_sync_io =3D regmap_bus_unprepare_sync_io;
> +	}

Why are we using these indirections instead of assigning the operation
directly?  They...

> +static int regmap_bus_prepare_sync_io(void *context)
> +{
> +	struct regmap *map =3D context;
> +
> +	if (map->bus->prepare_sync_io)
> +		return map->bus->prepare_sync_io(map->bus_context);
> +
> +	return 0;
> +}

=2E..seem to simply check for the operation which appears redundant
especially given that the caller...

> +static void regmap_unprepare_sync_io(struct regmap *map)
> +{
> +	void *context =3D _regmap_map_get_context(map);
> +
> +	if (map->reg_unprepare_sync_io)
> +		map->reg_unprepare_sync_io(context);
> +}

=2E..does essentially the same check again on every call anyway.

> @@ -1491,12 +1536,18 @@ int regmap_write(struct regmap *map, unsigned int=
 reg, unsigned int val)
>  	if (reg % map->reg_stride)
>  		return -EINVAL;
> =20
> +	ret =3D regmap_prepare_sync_io(map);
> +	if (ret)
> +		return ret;
> +
>  	map->lock(map->lock_arg);

So what are the rules for calling this operation and how are they
different to those for locking the map?  It looks like they might be the
same in which case it seems better to combine them rather than having
to update every single caller and remember why they're always being
worked with in tandem.

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuTrxAAoJECTWi3JdVIfQuwQH/3UXclf6AUgBPQ81+A77ZOfV
0CUe4LS2qp1MaBvCiV9CtK6yFIj+M82XmDVRiPtPDQia7w3kqSOAAwRNv5RcLMZ7
IHQIlyrPx68Eecu4mf1pQW1wYof8PPksgITFoWpaZob86HD1dhwWpJ/qr0YnXlKa
Rg3YP6dsTGuBOmteAJnsA/zcQwanqBRIoIU+CtutB5bU8eBcBS+gedu5X4N/mTtv
qoxDbo52iw1ThM5Iez41sGhBDwnuV2aK3S6hkOSNlPUTiWsVnR6RtNbCbNp/5qJt
flaonzS14g3rWeH1lfdB6p3w0EbkvZO3kV8fPXVwMhwpt3VG9zXpDgIRGQfhEYc=
=q6Wg
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
