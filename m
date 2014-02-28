Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaB1DhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:37:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53406 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB1DhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:37:18 -0500
Date: Fri, 28 Feb 2014 12:37:15 +0900
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140228033715.GE9383@sirena.org.uk>
References: <201402271146.s1RBkCGg004925@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HFNNDGBA8bk+zEXz"
Content-Disposition: inline
In-Reply-To: <201402271146.s1RBkCGg004925@swsrvapps-02.lan>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HFNNDGBA8bk+zEXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 11:28:56AM +0000, Opensource [Anthony Olech] wrote:
> This is the implementation of regmap_multi_reg_write()
>=20
> It replaces the first definition, which just defined the API.

Aside from any review comments this won't apply with the recent patches
that Charles did to provide a bypassed version of the API, it needs to
be rebased.

> a) should an async operation be allowed? easy in the case where
>    all the changes are in the same page - but if the operation
>    is broken due to changes over several pages not so easy.

It's fine to support only the simple cases, async operation is just an
optimisation so we can always just serialise in cases where it gets
complicated and someone can optimise later if they care.  It'd be fine
to just decay to a series of regmap_reg_write()s if there's paging
involved.

> b) the user supplied set (array of struct reg_default) of changes
>    has the register address modified when the target page alters.
>    Would it be better not to do an in-situ change, but rather to
>    alloc a new array of struct reg_default?

Yes, the user should be able to pass in a const pointer (indeed Charles
changed the API to do that).

> +++ b/drivers/base/regmap/regmap.c
> @@ -1442,6 +1442,7 @@ int regmap_field_write(struct regmap_field *field, =
unsigned int val)
>  }
>  EXPORT_SYMBOL_GPL(regmap_field_write);
> =20
> +
>  /**
>   * regmap_field_update_bits():	Perform a read/modify/write cycle

Random whitespace change here.

> +static int _switch_register_page(struct regmap *map, unsigned int  win_p=
age,
> +					struct regmap_range_node *range)
> +{
> +	int ret;
> +	bool page_chg;
> +	void *orig_work_buf =3D map->work_buf;
> +	unsigned int swp;
> +
> +	map->work_buf =3D map->selector_work_buf;
> +
> +	swp =3D win_page << range->selector_shift;
> +	ret =3D _regmap_update_bits(map,
> +				range->selector_reg,
> +				range->selector_mask,
> +				swp, &page_chg);
> +
> +	map->work_buf =3D orig_work_buf;
> +

I'd expect this to be using _regmap_select_page()?  In general there
seems like quite a bit of duplication to handle paging.

> +	return ret;
> +}
> +/*

You need a blank here.

> +	buf =3D kzalloc(len , GFP_KERNEL);
> +
> +	if (!buf)
> +		return -ENOMEM;

Coding style - extra blank between the kzalloc and the check and an
extra space before the comma.

> +	/*
> +	 * the set of registers are not neccessarily in order, but
> +	 * since the order of write must be preserved this algorithm
> +	 * chops the set each time the page changes
> +	 */
> +	for (i =3D 0, n =3D 0, switched =3D false, base =3D regs; i < num_regs;
> +								i++, n++) {

Don't put all this stuff in the for (), just put the iteration in the
for ().

> +	/*
> +	 * Some devices do not support multi write, for
> +	 * them we have a series of single write operations.
> +	 */
> +	if (map->use_single_rw) {
> +		for (i =3D 0; i < num_regs; i++) {
> +			ret =3D _regmap_write(map, regs[i].reg, regs[i].def);
> +			if (ret !=3D 0)
> +				goto out;
> +		}
> +	} else {
> +		ret =3D _regmap_multi_reg_write(map, regs, num_regs);

I'd expect to see something that devices do to specifically advertise
this capability, it doesn't follow that a device that a device that only
supports single writes will support the multi write operation and
frameworks may try to use the multi write API to help optimise things.

--HFNNDGBA8bk+zEXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEARoAAoJELSic+t+oim90MIP/Ro25k2VioI1OnEARmkAH4Eb
wBsjVAPzWJKTSETuGV9FrMBe/lc67CsKJOouL7gNWE7pDejVztdl1TD5rJrEImmz
nHu+02Llic60ywa2tZc9JDP0G8baY8pMNM0AUEWSPKT/nGBNq4P9IE3J5YshXxFf
ehNARXnrXUnWQrJ0C+Wh8bH0dYSklxx053tHV297IC/05v0e1azW/jQjDosFkNHl
VICYHJs6O6dAay3U0QY3g4uXRrfFUn7Npt0cBaHbPGpv9pFYrzHIhg5u7bSQYG15
XVd4QnVmiB278rTJZH2EWVo4G9XQpZE08jXPF8YYFHgTuRp5awg8QurvikhHzhP+
RHujBUACdzkntDcrjv0Mh2pPsNJcy2IqBawu8xzMZOJPuEamG8TiXxcEmkh9oh6E
e5OL39r4qqXa6T0fGqWCl++z+xAYxtMgvyUytgIuoLLc/v9txKP7T0b7vnT9UIt3
2cuDMS7h1HUnBfm3uyL7lngyDy7vP4Txr7deebnFItFObh6wBCeONrvusNXj7L1w
ZIooctcIea54VI0vFj7kH3eCfO9hnCHy/wQvImzW/EFrAFxVJLUL01d2bB0ad7Hg
k3i/kWPEFg8YEy3jTZdeiLsynLmByFi+tCpgSTAJlPOfuQXHmQcTe36UHa1R3A/L
9y9LiLIPaQWhQMq8fAHp
=oNo2
-----END PGP SIGNATURE-----

--HFNNDGBA8bk+zEXz--
