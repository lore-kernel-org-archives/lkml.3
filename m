Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3JJMVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:21:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40960 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JJMVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:21:16 -0400
Date: Thu, 10 Oct 2013 13:20:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20131010122048.GI21581@sirena.org.uk>
References: <201310101053.r9AArpal039552@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y60yCYmOwNKOOCF1"
Content-Disposition: inline
In-Reply-To: <201310101053.r9AArpal039552@swsrvapps-02.lan>
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


--Y60yCYmOwNKOOCF1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2013 at 11:50:23AM +0100, Anthony Olech wrote:

> +/*
> + * regmap_multi_write(): Write multiple non sequential registers to the device
> + *
> + * @map: Register map to write to
> + * @reg: Array of registers to be written, all on the same page

Why all on the same page?  That doesn't seem helpful for things trying
to build on top of this.  We currently manage to split even block writes
up over page boundaries.

> + * @val: Block of data to be written, in native register size for device
> + * @reg_count: Number of registers to write

I'm not seeing anything here which says how the registers and values are
related to each other.  I assume that the idea is that the same number
of registers are provided as values...

This really doesn't feel like an idiomatic abstraction - it's a bit
cumbersome to have the pair of arrays and try to line them up especially
in native register format, normally we do this with an array
reg_default.  This would also mean that generic code like patches and
cache syncing could pick up on the same functionality.

> +	/*
> +	 * Some devices do not support multi write, for
> +	 * them we have a series of single write operations.
> +	 */
> +	if (map->use_single_rw) {

single_rw is somewhat relevant but this needs a separate flag since...

> +	} else {
> +		ret = _regmap_raw_multi_write(map,
> +					      reg_count,
> +					      reg,
> +					      wval);
> +	}

...this will try to use the new functionality even if the device doesn't
support it.  Indeed what this looks like is support for devices that can
only do single register writes but in the I2C case allow it to be done
without releasing the bus (it looks a lot like someone optimised things
to look like a bunch of SPI register writes, with SPI bouncing /CS is
much quicker than starting a new I2C transfer is).

I can see it being nice to have something like this but it needs more
thought on the API and implementation.  I'd suggest splitting the API
addition from the underlying implementation to make things easier to
review (the API should work for any user even if it just ends up as a
series of separate register writes).  Something like DAPM in ASoC could
use it for example, as well as the patch and cache sync code.

--Y60yCYmOwNKOOCF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVpudAAoJELSic+t+oim9FO8P/0CUF58GaReFgbF0QTkl311l
thjX/RWYbOBl0gF8/r+yJtUEjjesSgIvewOsdvwSfE3biaZ2kj5kKxgLFfZlMXjy
Byn3t6Rpq78S7Z3Mf0GazHPoWbZaYHXgPY+5BPKRFKLLjk1E0on4G8hCB7DaAZ1Q
F0YDM1HVbH79SsWg74sZXJ31rCAQLncYg1fIH+Kl6KWuMBwkA+CPTVVNb/uucFua
4NsCor9gDJuP+AmN8c8ceEVKFghmrJ3JvXQ7Z1zwe0Y9wOMKXSnlFLihyTYxLQ5g
71OsxYefE7ZTRCoNIsaRhHGeZcBP1sdj9wADYT/pnSm2CQeyoZ2k9tFh3s5b+EXk
kUL8dmX4wO6TH2FP2MtoMj0SCppDTd3Kf4l1xbq7ejsY9brFzb4AISUxu4tgzAI1
GBhh7LPsn4HKKL6ZFT9HvHFk/C+RTD5BH7LowwAbQ2QS6lvQMepOMZITVQH+muVM
Yg/DNCwDm+CNsEFj4cCEMJvNR37GSaIxS0htN1vd2IW5Eq+MTj+16gBMuj6azb4R
a3KoGNmkcmP4njGxpTK51XkMstJL9zpXF9rTwE9L4Vpz2AfujPRscF4G/JI2HGHg
vDyToasK4qucaD2QbeqYbsg+8gpvOol7bCAMf7lIdhwlXFGyfd9zYMVClwSmhPJ4
K4GX5x0jrKsWMASYIOm7
=RugR
-----END PGP SIGNATURE-----

--Y60yCYmOwNKOOCF1--
