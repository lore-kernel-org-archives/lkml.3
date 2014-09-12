Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaILIzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:55:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38654 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaILIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:54:59 -0400
Date: Fri, 12 Sep 2014 10:54:46 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140912085446.GA8844@pengutronix.de>
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
 <20140911225737.GA13926@Alpha>
 <20140912020110.GA414@audiosh1>
 <20140912061706.GA10680@pengutronix.de>
 <20140912071426.GA30261@audiosh1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20140912071426.GA30261@audiosh1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:25:26 up 2 days,  1:12, 58 users,  load average: 0.04, 0.12, 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2014 at 03:14:28PM +0800, Shengjiu Wang wrote:
> On Fri, Sep 12, 2014 at 08:17:06AM +0200, Markus Pargmann wrote:
> > Hi,
> >=20
> > On Fri, Sep 12, 2014 at 10:01:12AM +0800, Shengjiu Wang wrote:
> > > On Thu, Sep 11, 2014 at 03:57:37PM -0700, Nicolin Chen wrote:
> > > > On Thu, Sep 11, 2014 at 01:38:29PM +0800, Shengjiu Wang wrote:
> > > > > Move the ipg clock enable and disable operation to startup and sh=
utdown,
> > > > > that is only enable ipg clock when ssi is working. Keep clock is =
disabled
> > > > > when ssi is in idle.
> > > > > otherwise, _fsl_ssi_set_dai_fmt function need to be called in pro=
be,
> > > > > so add ipg clock control for it.
> > > >=20
> > > > It seems to be no objection so far against my last suggestion to
> > > > use regmap's mmio_clk() for named ipg clk only. So you may still
> > > > consider about that.
> > > >
> > > I think mmio_clk() can be put to another patch. and this patch only f=
or clk_enable()
> > > and clk_disable() operation.
> >=20
> > I would also prefer Nicolin's suggestion using regmap's mmio clk. I
> > think it may be better to not add this particular patch at all and just
> > go with the mmio_clk patch. It should be easy enough to just add the
> > clock names to the devicetrees. That way we can avoid all those clock
> > enable/disable function calls.
> >
> I considered if use Nicolin's suggestion, I still need ot add those
> enable/disable function calls, because I want to remove the enable/disable
> function call in fsl_ssi_imx_probe, then I need to add enable/disable=20
> function call in _fsl_ssi_set_dai_fmt(), which is called in fsl_ssi_probe=
().
> _fsl_ssi_set_dai_fmt() need to access the registers.

I think Nicolin's suggestion was to check for a clock named "ipg". If it
exists, you can simply use devm_regmap_init_mmio_clk(). Otherwise you
could fallback to the old behaviour and get the first clock and enable
it without disabling it after the probe function.

After that, you could add the clock-names property to the devicetrees
and have the same result.

>=20
> > > =20
> > > > Anyway, I'd like to do thing in parallel. So I just simply tested
> > > > it on my side and its works fine, it may still need to be tested
> > > > by others though.
> > > >=20
> > > > Nicolina
> > >=20
> > > Hi Markus
> > >=20
> > > could you please review it, and share your comments?
> >=20
> > I think the clock enabling for AC97 is missing in your patch.
> >=20
> I add clock enable in fsl_ssi_startup(), I think it is enough for AC97, d=
oes it?

No. We export ac97 read/write ops for the whole AC97 stuff. These may be
used outside of the usual startup/shutdown which is done for substreams.
It may work to have the ipg clock enabled in
fsl_ssi_ac97_read/fsl_ssi_ac97_write.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUErTVAAoJEEpcgKtcEGQQ6aUP/3GSn5/tAw3ARNYKf/56uDKh
s/AXf1c1SPUey2pJ9faODh3y1Q2PUmyvzok35sxaPNuLQhtMhMR0fonCBe/MZRjr
IdjnrTOlmQc6aVT9aSWz7FGQ2ICl2tN5rD7NV7J9XESGlIAisV8lop2DVJSjSY2G
e+VCWGWyAT8DVDC/F0M9yfho8orRlM+vDX5dRGXUv7sU+3IqKm/B9VlfbARNyGuR
j8rJqqsu1uPYsvaDN6e5hnVCBW+VHpyQFI0WDzGfoPNOfFVZQP0QGsIN5gL3aZHQ
w2unf7Dtq755Cw3IucswlX7uob8hInOBjssyL59W97O/fSNOdQrZl5FxiJGdx5Vj
lOxcXGtb0N53HgTjA5je7N2Sh8Vi7T8KgUzl1Py/Wr6LGZtZO4e0GfKbo6q9S/Wv
JUtQJfOhxeY93xqmFegREXiO6bKNlPfc55braby7V1mYRXE6d4M8XRyxR1aEKUcu
wD8eeX67D9BLrFfvv8Y7j1TtB7oW1M2BrpeKiQTet9EXQFzTwRis8v0XkO5x1MMX
ZmX5wLUhhCt63aCI8r/0ltKiE82lWztKGBRzYl9mqlhrtCsZBD5W+5VrFemG5C/7
2khOWizpjOoF52RaTLLmbHyp+/uIue8N+RAFKxjqSMD+8lnVI4q4TiEy7sdQwbrz
bAravHewusqplz1XkukA
=qmHV
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
