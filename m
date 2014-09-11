Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaIKGhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:37:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36500 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaIKGhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:37:08 -0400
Date: Thu, 11 Sep 2014 08:36:51 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140911063651.GD16489@pengutronix.de>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <20140910081251.GA14662@audiosh1>
 <20140910174204.GA4628@Asurada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <20140910174204.GA4628@Asurada>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:20:09 up 23:07, 39 users,  load average: 0.05, 0.12, 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 10:42:04AM -0700, Nicolin Chen wrote:
> On Wed, Sep 10, 2014 at 04:12:53PM +0800, Shengjiu Wang wrote:
> > > Then we can get a patch like:
> > > open() {
> > > +	clk_prepare_enable();
> > > 	....
> > > }
> > >=20
> > > close() {
> > > 	....
> > > +	clk_disable_unprepare()
> > > }
>=20
> > what is the open() and close()? do you mean the fsl_ssi_startup()
> > and fsl_ssi_shutdown()?
>=20
> Yea.
>=20
> > > probe() {
> > > 	clk_get();
> > > 	clk_prepare_enable();
> > > 	....
> > > 	if (xxx)
> > > -		goto err_xx;
> > > +		return ret;
> > > 	....
> > > +	clk_disable_unprepare();
> > > 	return 0;
> > > -err_xx:
> > > -	clk_disable_unprepare()
> > > }
>=20
> > If this probe() is fsl_ssi_imx_probe(), I think no need to add
> > clk_prepare_enable() or clk_disable_unprepare(), seems there is no=20
> > registers accessing in this probe.
>=20
> This is trying to be safe, especially for such a driver being used
> by multiple platforms. You can omit this as long as the patch can
> pass the test on old imx, PowerPC, and AC97 platforms.
>=20
> >
>=20
> And another risk just came to my mind is that there would be a
> possibility that a machine driver would call set_dai_fmt() early,
> after SSI's probe() and before SSI's startup(), if the machine
> driver contains dai_fmt assignment in its probe(). Then, without
> regmap_mmio_clk(), it'll be tough for us over here because we may
> also need to add clock enable/disable for set_dai_fmt/set_sysclk(),
> even if there might be still tiny risk that we missed something.

Thanks, didn't thought about that. As there are no restrictions on when
these functions may be called, it has to be handled.

>=20
> Then there could be a selfish approach to circumvent it is to use
> regmap_mmio_clk() with "ipg" at the beginning and call regmap_mmio()
> without "ipg" if getting a failed return value from regmap_mmio_clk,
> and meanwhile to keep the clock always enabled for the regmap_mmio()
> case just like what the current driver is doing. This may result
> those non-ipg-clk platforms can't benefit from this refinement
> unless they update their DT bindings -- use "ipg" for core clock
> This might be the safest and simplest way for us, I'm not sure
> everyone would be comfortable with this idea though.

I like the "selfish" approach. It would save a lot of clock
enabling/disabling and error handling and at the same time it doesn't break
the DT compatibility. The platforms with an old DT would have the old
behaviour, but that could be changed by updating the devicetrees which
should be easy to do for all the imx SoCs.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEUMDAAoJEEpcgKtcEGQQ1RIP+wd4IRjhvx2YWqVobh+NQuor
VwnuuI0u6whpi+X7WaSzvbsKJTOkZop1qO+zxTLkkTwSi96oTuQyvcEXCth+tTfp
JRVAGJGeZ2/QlbKregLCb5Yh9XRQcE0w0F1TkxwXnEez3MxHOIrGqh+UJwnInO3k
pyZhjwKqNehUbPfRp93T6QzdI1H479cvctRBk4NC7lSqMb1XxO0yyl6VQvAryHLH
6QhWTP+lTRUnS4RyoUwfoKycGpi19/l4JqcDUVKKbpZSKygdjOJsyzMmvjd/u6EK
cwGC/n3D0e0HdbjRPsumiJQ1GG5vMzE7JU6vpueGPYGE8NqX+E/BF3D2ewHtxZUr
jaY6LH0K5kmtrRjMpKl8KR1BQba/aW2qN+b2vsdfqR15zqlw1UkvnJbNNgeNTxRh
onVh+DBs4A/mY1r7kugtCDnOmGjuCoJp+ChyvKC0MEgvpsk2t7Oeq1ujRrrwGwXo
py4ABKjXY8Td/3UyHVDG6Bll1YmFQZpEGwG7oVtiE5M6G5LNzsB2U+Fb2oSFOfYT
NxXrr1FWcVRHiNxM6DsqIl8Oreo+TBV7YmBFR6uxY1g2R1GTozTaRBbFPdJy8UYu
z/8a8e4BZ/6NauP5x2W+a9eg8XEbLfSSgakB3/98jOkWA3pyNc5HRz5MY5p/6cCI
5cXbFRIiq9/S2avbfXzg
=I04H
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
