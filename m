Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaAaWkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:40:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45488 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933116AbaAaWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:40:08 -0500
Date: Fri, 31 Jan 2014 14:31:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] spi: core: Introduce devm_spi_alloc_master
Message-ID: <20140131133111.GF2950@lukather>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140131121215.GB22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CqfQkoYPE/jGoa5Q"
Content-Disposition: inline
In-Reply-To: <20140131121215.GB22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CqfQkoYPE/jGoa5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 12:12:15PM +0000, Mark Brown wrote:
> On Fri, Jan 31, 2014 at 11:23:09AM +0100, Maxime Ripard wrote:
>=20
> > This patchset introduces a devm_spi_alloc_master to the spi core. While=
 most of
> > the drivers have a spi_master_put call in the probe, a lot of them usin=
g the
> > devm_spi_register_master function are missing it in the remove function,
> > leading to leaked resources.
>=20
> This seems confusing - the idea here is that if we've handed the device
> off to the managed function then the managed function deals with
> destroying it.  Note that spi_alloc_master() says that the put is only
> required after errors adding the device (which would be the expected
> behaviour if you look at other APIs).  Looking at the code I think there
> is an issue here but I'm not at all clear that this is the best fix.

Ah, right, spi_master_put doesn't free the memory either...

I guess we have a few choices here, either:
  - Add a devm_kzalloc to spi_alloc_master, since most of the drivers
    I've been looking at fail to free the memory, this would be the
    least intrusive solution. We'd still have to remove all the kfree
    calls in the driver that rightfully free the memory.
  - Make devm_unregister_master also call kfree on the master
  - Add a kfree to my devm_put_master so that the memory is reclaimed,
    which isn't the case for now.

I don't have a strong preference here, maybe for the third one, since
it makes obvious that it's managed and you don't have to do anything
about it, while the other do not.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CqfQkoYPE/jGoa5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS66WeAAoJEBx+YmzsjxAg/rsP/1tOd1n9C3jCj4d24s2I0afs
zN85L8zZVxtVChM0Oy/ATNitDYeQf/yOQ62oHT7kBRSbl9UUju3yKhgTOB6jR+Bx
zUxA6M1X4yf3zvCnKjUNWX9adwsQYaZEiBaEoNFE8I0Cix+YBT8KBv6Zynu5+Csp
Yxt7WttI0DuysodtKsWoypBvEsjMSi9Jksvx/MIRWb2NkiLzrh3bTOsVJyn6uvmW
D6OvuJ9NMhzXlcZ/TmzOjXH/HzMLvt7nhLg/xWdbsgKaBXdIYGMnyKscPc7rfugu
Ern7kaut/qtouxQWL+yAOS4HOK5WPQZbS1yr+1kGOAgKvg3tLWN1gPbaSySQsKbZ
OZ+hv7AZ3XaoL7URb/E5qaKfcMjKH8/3MQVWMrqj1Kv2UihVh5IFBK+BtpXNLOdO
7IpBTHbu454jEAQvztmghJ7jLoXfDzq8xKdjYmz+Vy8Gau+ApA7A1YTKqYLlOPmj
QIRvjfPTvYAJDT0psOEcF43iRaYoFidQ3FQJKZdM4djLR6dq2vYLDFDHrZSumDDk
epWkgEwnoAqCaUiqTsl6Fee3Z7YaGd9wjBuJUL2GtvfPMUGgBPMn4hDCVM9qrEUX
6htHvs4k2G8a7sgNFYTnExDnsGIU4SkuTVZjsWrRKbmW03o/syXbL3dG7IhjBeKz
LpbUijz84LaRMfX32Jfu
=y6XK
-----END PGP SIGNATURE-----

--CqfQkoYPE/jGoa5Q--
