Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3JJOJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:09:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44998 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3JJOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:09:11 -0400
Date: Thu, 10 Oct 2013 15:08:43 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20131010140843.GM21581@sirena.org.uk>
References: <201310101053.r9AArpal039552@swsrvapps-02.lan>
 <20131010122048.GI21581@sirena.org.uk>
 <24DF37198A1E704D9811D8F72B87EB516FC70765@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRQinjjZUyRAa7p8"
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB516FC70765@NB-EX-MBX02.diasemi.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] new API regmap_multi_write()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRQinjjZUyRAa7p8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 12:45:03PM +0000, Opensource [Anthony Olech] wrote:

> > Why all on the same page?  That doesn't seem helpful for things trying =
to
> > build on top of this.  We currently manage to split even block writes u=
p over
> > page boundaries.

> As far as I could see, the splitting of a block write that spans a page b=
oundary
> requires a read-modify-write of a "page" register. That therefore breaks =
the
> primary raison d'etre for the new API, namely that it is atomic on the I2=
C bus
> with respect to multiple I2C bus masters.

I would expect this to be handled by inserting a page update into the
sequence (it could presumably go into the block write unless the
hardware were being a bit perverse) or by just splitting the transfers
at each page change.

> Cutting the transfer at a page boundary and inserting a write to a "page"
> register would work very well for most of our PM MFDs because there is
> no requirement to do a read modify write. Indeed I had thought that it sh=
ould
> be the responsibility of the device driver to insert any necessary "page"=
 register
> writes into a transfer that spans page boundaries. The driver knows where=
 the
> boundaries are so it should be easy.

This only works if it is chip specific code that is doing the update.
If there is generic code doing an update (either core Linux framework
code or something for an IP that appears on multiple chips) then it's
not going to know that without jumping through hoops which are going to
apply to all users that trigger this so may as well just be handled in
the core.

Of course a driver is free to not issue updates which cross page
boundaries (or to group the writes so that they get split up into the
minimum set of page boundary changes) but it doesn't seem helpful to
require that the caller understands any paging the device has.

> > This really doesn't feel like an idiomatic abstraction - it's a bit cum=
bersome to
> > have the pair of arrays and try to line them up especially in native re=
gister
> > format, normally we do this with an array reg_default.  This would also=
 mean
> > that generic code like patches and cache syncing could pick up on the s=
ame
> > functionality.

> You seem to be suggesting that the API could be used by drivers of device=
s that
> do not support in hardware the MULTIWRITE capability. If that is the case=
 then

Yes, and for example all SPI devices have essentially this functionality
as standard since it's possible to issue an uninterrupted batch of
transfers to a device with no special hardware support.

> driver need an config "multi_write_supported" field for initialization.

It's I2C specific too.

> What should the next step in progressing this be?

Like I say I'd suggest getting an API that allows drivers to send a
batch of writes to the framework done first (which should be fairly
simple - a first pass should probably be something like

	int regmap_multi_reg_write(struct regmap *map,
				   struct reg_default *regs,=20
				   int num_regs)
	{
		for (i =3D 0; i < num_regs; i++)
			regmap_reg_write(map, regs[i].reg, regs[i].val);
	}

with error handling and stuff) and then loop round on how to implement
the actual functionality to get I2C and SPI to do the right thing on the
wire if the device supports it.  It's slightly different for each,
obviously you only care about I2C which is fine - I'm not saying you'd
need to actually do SPI yourself.

For I2C type stuff a flag to say if the device can do this and then
something to render the data appropriately and send it ought to do the
trick, it should be fairly straightforward.  I'm more concerned about
the external API than the implementation, it's much easier to refactor
the implementation if there's a problem than it is to change the
external API.

--QRQinjjZUyRAa7p8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVrToAAoJELSic+t+oim9XYMP/2jNd+VgdfaNwe+z3d5OL9FX
UFvH3Q2ILkzqxM2rivKw4/AqgpAH/aweuNuGoojTuYYvnahk6e3Flidu7puAck2D
KsnniMmTH2JREZtv7zYytZwIGumkL6ozQZ5bdomjJ+P7L1ahR6Yc4b3f8szpDYqT
GGjwZ8GFkniI4ySAHBdNg+mxEhchnj5Rq3AcnffxAwZ5GO+Xhl58jkEFaPuwYLcT
JL2sU26anbXy6CcPH5Sw4ARgc7yOUtQQG8aN9ciDNoXVqkvCOkcGrhuJAyzadUEz
lBqXOkyzAlc453AMNOqdoPVsgse+NioQHMg9BX5Comry3cQA5zZ4MluoP+gluJ/M
qozvfpdvo0hrS2nkELTkO/+BhVB0rFT8atMfFBbZv4N5cQbygSG76iX9mM5jsBPY
PsiF6AZTWRTridN0M8YtgAwFmaOdGX4vIMnJHi6m0gGSUnLmevhBvFhCJQ8ml8ET
F0XjyAKMVrR0541Uc22AGy8wniDKcnaUFNVBASVmxzrAZOMvLyBGz+ecbYK6z8/7
U6Zz2xWAkgYa7M6OfuGMGsSeMfyKsiHuQnTyhtIpp46v2B2JlNtC9FeKmheI0Dz8
yrMt6Z7vYLIReHoEuvGBTQGUZqOHlXp7MYzMcF22ErwrgUFEp2N7abOxa3B6cNTu
c8UQttpy2cYUJZi3qNFM
=/Bah
-----END PGP SIGNATURE-----

--QRQinjjZUyRAa7p8--
