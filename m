Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaBARi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:38:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33892 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbaBARiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:38:55 -0500
Date: Sat, 1 Feb 2014 17:38:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Message-ID: <20140201173841.GU22609@sirena.org.uk>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140131121215.GB22609@sirena.org.uk>
 <20140131133111.GF2950@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSdtjhIkTRrb1Xsv"
Content-Disposition: inline
In-Reply-To: <20140131133111.GF2950@lukather>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/3] spi: core: Introduce devm_spi_alloc_master
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KSdtjhIkTRrb1Xsv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2014 at 02:31:11PM +0100, Maxime Ripard wrote:
> On Fri, Jan 31, 2014 at 12:12:15PM +0000, Mark Brown wrote:

> > This seems confusing - the idea here is that if we've handed the device
> > off to the managed function then the managed function deals with
> > destroying it.  Note that spi_alloc_master() says that the put is only
> > required after errors adding the device (which would be the expected
> > behaviour if you look at other APIs).  Looking at the code I think there
> > is an issue here but I'm not at all clear that this is the best fix.

> Ah, right, spi_master_put doesn't free the memory either...

The memory is freed by the driver core calling the spi_master_release()
callback when it's safe to do so (after the last reference to the device
has gone away).

> I guess we have a few choices here, either:
>   - Add a devm_kzalloc to spi_alloc_master, since most of the drivers
>     I've been looking at fail to free the memory, this would be the
>     least intrusive solution. We'd still have to remove all the kfree
>     calls in the driver that rightfully free the memory.
>   - Make devm_unregister_master also call kfree on the master
>   - Add a kfree to my devm_put_master so that the memory is reclaimed,
>     which isn't the case for now.

> I don't have a strong preference here, maybe for the third one, since
> it makes obvious that it's managed and you don't have to do anything
> about it, while the other do not.

None of the above, definitely nothing to do with calling kfree() once
the device is registered.  We already have that free, it's not the
issue.  The issue is making sure that we hold references when we need
them and drop them when we don't.  I (or someone) needs to sit down and
think it through since things are a bit confused in the code.

--KSdtjhIkTRrb1Xsv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS7TEdAAoJELSic+t+oim9QtsP/A8w/rEqIDTUPKxY0crkW3Rj
UjyrafsfxV9OULkJR1G+Ikz+G6WauiKrYcy8YNOo5pQ2WMZPG/aXpk3jBHzMxtvW
4G4TEwIdyA7YUUCYzc6K5YVsJHU44MBBnQRyp6yBOD6ydoLlncUN7xrRiAWgOA5p
54tGY2r4mZSmVn0YBI3N95R8GSyaPR2ddST1dDDRdat23PkjpsQE4FKfvlOXqAXM
is8Any/3A3gj5S782S0raY1d8ae4Dr7EnH3NkM0kxJp798A4f/ZFcMkHDjLoLKcl
UOHEnmG/qVRJecN8wYOnbpEjmfBQZDUzXzlHIVl5T1O7by+ORP2DWdpJTv0NAwQy
LeRm/ANpY2icLSmvEs0YPkUlpYXh2KATPVEjYm3Sr2YedD7ij11g02SCt/ClmzAE
MKNKmJv3UhIx2rCnXbVyOdxzHxmHKOWjjeSk93Vya0YS7oEGRxZjIU+iHsw/EOnO
933R5hzAj8THfgJSngjweoDdRD6jLGzI358oXfPKaFVIF6/ZXECmcF66CK9zopSw
Zr05pNQ68I+rVhINnUqX8XCa/5UgxudOEwt0tstL9lieV9NS0GY3gi6Kt8hhoneE
rPdJiijBpNf1/PCTJDg1HNcbCtodJdGLs/QAM0OKuGh/1UcSUE3Qm+aIVsYrPhW5
7JZYNI8SLfA3G0GHzqrU
=IAOw
-----END PGP SIGNATURE-----

--KSdtjhIkTRrb1Xsv--
