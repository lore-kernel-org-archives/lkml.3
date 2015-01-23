Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbbAWOxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:53:00 -0500
Received: from sauhun.de ([89.238.76.85]:45289 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbbAWOw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:52:56 -0500
Date: Fri, 23 Jan 2015 15:52:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] i2c: s3c2410: fix ABBA deadlock by keeping clock prepared
Message-ID: <20150123145247.GD9592@katana>
References: <1421683413-27075-1-git-send-email-p.osmialowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <1421683413-27075-1-git-send-email-p.osmialowsk@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 05:03:33PM +0100, Paul Osmialowski wrote:
> This patch solves deadlock between clock prepare mutex and regmap mutex r=
eported
> by Tomasz Figa in [1] by implementing solution from [2]: "always leave th=
e clock
> of the i2c controller in a prepared state".
>=20
> [1] https://lkml.org/lkml/2014/7/2/171
> [2] https://lkml.org/lkml/2014/7/2/207
>=20
> On each i2c transfer handled by s3c24xx_i2c_xfer(), clk_prepare_enable() =
was
> called, which calls clk_prepare() then clk_enable(). clk_prepare() takes
> prepare_lock mutex before proceeding. Note that i2c transfer functions are
> invoked from many places in kernel, typically with some other additional =
lock
> held.
>=20
> It may happen that function on CPU1 (e.g. regmap_update_bits()) has taken=
 a
> mutex (i.e. regmap lock mutex) then it attempts i2c communication in orde=
r to
> proceed (so it needs to obtain clock related prepare_lock mutex during tr=
ansfer
> preparation stage due to clk_prepare() call). At the same time other task=
 on
> CPU0 wants to operate on clock (e.g. to (un)prepare clock for some other =
reason)
> so it has taken prepare_lock mutex.
>=20
> CPU0:                        CPU1:
> clk_disable_unused()         regulator_disable()
>   clk_prepare_lock()           map->lock(map->lock_arg)
>   regmap_read()                s3c24xx_i2c_xfer()
>     map->lock(map->lock_arg)     clk_prepare_lock()
>=20
> Implemented solution from [2] leaves i2c clock prepared. Preparation is d=
one in
> s3c24xx_i2c_probe() function. Without this patch, it is immediately unpre=
pared
> by clk_disable_unprepare() call. I've replaced this call with clk_disable=
() and
> I've added clk_unprepare() call in s3c24xx_i2c_remove().
>=20
> The s3c24xx_i2c_xfer() function now uses clk_enable() instead of
> clk_prepare_enable() (and clk_disable() instead of clk_unprepare_disable(=
)).
>=20
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>

Applied to for-current, thanks!


--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwmA/AAoJEBQN5MwUoCm2sEkP/iVEyjBUV7/BVkcOxy3+P66e
IrFKY6XQsfJTdrK8AOo1YqML5f8TbPCDPrc4EV/escY44IpbLUOyhZ4Ub/gcTCZU
UrdGtHrLFqnmTQKNoZslL117nCdoNLeYtAeH6HVxp1XXq+1PuqyTchoz3aqWYV6H
037T6SKl7zOsC2x78FJ1E2n0z9Lf/ksfNFS2IemVxu+VNBKkix6zdUB41yanGJdv
tQqIfyJAntq1EAkiAV11oz/4qjkV6QcdqOF6qbA5dLL/Lsgu3zy6363bIYRV8SAe
tJXaihe9L8r6ek5vgxKk8Nks0Nr2Rr1UarhEdQH7jKt5OekbOY916rBHscQxbQcU
mi+ExSAmxggo0e9CNphFa+vxVO5ZhJCHlo2/QFbpUMkYRPQFPG7EXD5M1u/S5BJl
ZXvxDDh7BAMXifE57cOACw1qJoikNY0b7l56QfFRMRufHVCowv2ECkRRxH39JljS
Zjx3bHIdVKTa+U67jy5VOhDP3C967GmBc2g/JzNSixEa5zEJ2ojlrU/Ok/nq+gvH
ODbApKnZjfKvXcOXxhyE4n4XxQRPkkjazH8hahbg4PT+E/VB9b7SRLwD2L05ieDj
gUdpw1ZbLORd74OzUT5VhIfFahHd9sBPrv+AGscTlXH9iNgVCV5JCodvvj2BHjI3
wVzFTc7xU3PRgs1P/RJF
=RjYp
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
