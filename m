Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaIONwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:52:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34773 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaIONwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:52:19 -0400
Date: Mon, 15 Sep 2014 15:52:04 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, nicoleotsuka@gmail.com, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140915135204.GF8844@pengutronix.de>
References: <894383e00876763f22988fc5f3f9f232f939f923.1410517971.git.shengjiu.wang@freescale.com>
 <20140915100541.GD8844@pengutronix.de>
 <20140915102224.GA23877@audiosh1>
 <20140915103213.GE8844@pengutronix.de>
 <20140915103714.GB23877@audiosh1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gneEPciiIl/aKvOT"
Content-Disposition: inline
In-Reply-To: <20140915103714.GB23877@audiosh1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:37:31 up 5 days,  6:24, 64 users,  load average: 0.28, 0.45, 0.24
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gneEPciiIl/aKvOT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2014 at 06:37:15PM +0800, Shengjiu Wang wrote:
> On Mon, Sep 15, 2014 at 12:32:13PM +0200, Markus Pargmann wrote:
> > On Mon, Sep 15, 2014 at 06:22:27PM +0800, Shengjiu Wang wrote:
> > > On Mon, Sep 15, 2014 at 12:05:41PM +0200, Markus Pargmann wrote:
> > > > On Fri, Sep 12, 2014 at 06:35:15PM +0800, Shengjiu Wang wrote:
> > > > > Check if ipg clock is in clock-names property, then we can move t=
he
> > > > > ipg clock enable and disable operation to startup and shutdown, t=
hat
> > > > > is only enable ipg clock when ssi is working and keep clock is di=
sabled
> > > > > when ssi is in idle.
> > > > > But when the checking is failed, remain the clock control as befo=
re.
> > > > >=20
> > > > > Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> > > > > ---
> > > > > V3 change log:
> > > > > update patch according Nicolin and markus's comments
> > > > >=20
> > > > >=20
> > > > >  sound/soc/fsl/fsl_ssi.c |   53 +++++++++++++++++++++++++++++++++=
+++++++-------
> > > > >  1 file changed, 45 insertions(+), 8 deletions(-)
> > > > >=20
> > > > > diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
> > > > > index 2fc3e66..6d1dfd5 100644
> > > > > --- a/sound/soc/fsl/fsl_ssi.c
> > > > > +++ b/sound/soc/fsl/fsl_ssi.c
> > > > > @@ -169,6 +169,7 @@ struct fsl_ssi_private {
> > > > >  	u8 i2s_mode;
> > > > >  	bool use_dma;
> > > > >  	bool use_dual_fifo;
> > > > > +	bool has_ipg_clk_name;
> > > > >  	unsigned int fifo_depth;
> > > > >  	struct fsl_ssi_rxtx_reg_val rxtx_reg_val;
> > > > > =20
> > > > > @@ -530,6 +531,11 @@ static int fsl_ssi_startup(struct snd_pcm_su=
bstream *substream,
> > > > >  	struct snd_soc_pcm_runtime *rtd =3D substream->private_data;
> > > > >  	struct fsl_ssi_private *ssi_private =3D
> > > > >  		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> > > > > +	int ret;
> > > > > +
> > > > > +	ret =3D clk_prepare_enable(ssi_private->clk);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > > =20
> > > > >  	/* When using dual fifo mode, it is safer to ensure an even per=
iod
> > > > >  	 * size. If appearing to an odd number while DMA always starts =
its
> > > > > @@ -544,6 +550,21 @@ static int fsl_ssi_startup(struct snd_pcm_su=
bstream *substream,
> > > > >  }
> > > > > =20
> > > > >  /**
> > > > > + * fsl_ssi_shutdown: shutdown the SSI
> > > > > + *
> > > > > + */
> > > > > +static void fsl_ssi_shutdown(struct snd_pcm_substream *substream,
> > > > > +                             struct snd_soc_dai *dai)
> > > > > +{
> > > > > +	struct snd_soc_pcm_runtime *rtd =3D substream->private_data;
> > > > > +	struct fsl_ssi_private *ssi_private =3D
> > > > > +		snd_soc_dai_get_drvdata(rtd->cpu_dai);
> > > > > +
> > > > > +	clk_disable_unprepare(ssi_private->clk);
> > > > > +
> > > > > +}
> > > > > +
> > > > > +/**
> > > > >   * fsl_ssi_set_bclk - configure Digital Audio Interface bit clock
> > > > >   *
> > > > >   * Note: This function can be only called when using SSI as DAI =
master
> > > > > @@ -1043,6 +1064,7 @@ static int fsl_ssi_dai_probe(struct snd_soc=
_dai *dai)
> > > > > =20
> > > > >  static const struct snd_soc_dai_ops fsl_ssi_dai_ops =3D {
> > > > >  	.startup	=3D fsl_ssi_startup,
> > > > > +	.shutdown       =3D fsl_ssi_shutdown,
> > > > >  	.hw_params	=3D fsl_ssi_hw_params,
> > > > >  	.hw_free	=3D fsl_ssi_hw_free,
> > > > >  	.set_fmt	=3D fsl_ssi_set_dai_fmt,
> > > > > @@ -1168,17 +1190,22 @@ static int fsl_ssi_imx_probe(struct platf=
orm_device *pdev,
> > > > >  	u32 dmas[4];
> > > > >  	int ret;
> > > > > =20
> > > > > -	ssi_private->clk =3D devm_clk_get(&pdev->dev, NULL);
> > > > > +	if (ssi_private->has_ipg_clk_name)
> > > > > +		ssi_private->clk =3D devm_clk_get(&pdev->dev, "ipg");
> > > > > +	else
> > > > > +		ssi_private->clk =3D devm_clk_get(&pdev->dev, NULL);
> > > > >  	if (IS_ERR(ssi_private->clk)) {
> > > > >  		ret =3D PTR_ERR(ssi_private->clk);
> > > > >  		dev_err(&pdev->dev, "could not get clock: %d\n", ret);
> > > > >  		return ret;
> > > > >  	}
> > > > > =20
> > > > > -	ret =3D clk_prepare_enable(ssi_private->clk);
> > > > > -	if (ret) {
> > > > > -		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> > > > > -		return ret;
> > > > > +	if (!ssi_private->has_ipg_clk_name) {
> > > > > +		ret =3D clk_prepare_enable(ssi_private->clk);
> > > > > +		if (ret) {
> > > > > +			dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> > > > > +			return ret;
> > > > > +		}
> > > > >  	}
> > > > > =20
> > > > >  	/* For those SLAVE implementations, we ingore non-baudclk cases
> > > > > @@ -1236,8 +1263,9 @@ static int fsl_ssi_imx_probe(struct platfor=
m_device *pdev,
> > > > >  	return 0;
> > > > > =20
> > > > >  error_pcm:
> > > > > -	clk_disable_unprepare(ssi_private->clk);
> > > > > =20
> > > > > +	if (!ssi_private->has_ipg_clk_name)
> > > > > +		clk_disable_unprepare(ssi_private->clk);
> > > > >  	return ret;
> > > > >  }
> > > > > =20
> > > > > @@ -1246,7 +1274,8 @@ static void fsl_ssi_imx_clean(struct platfo=
rm_device *pdev,
> > > > >  {
> > > > >  	if (!ssi_private->use_dma)
> > > > >  		imx_pcm_fiq_exit(pdev);
> > > > > -	clk_disable_unprepare(ssi_private->clk);
> > > > > +	if (!ssi_private->has_ipg_clk_name)
> > > > > +		clk_disable_unprepare(ssi_private->clk);
> > > > >  }
> > > > > =20
> > > > >  static int fsl_ssi_probe(struct platform_device *pdev)
> > > > > @@ -1321,8 +1350,16 @@ static int fsl_ssi_probe(struct platform_d=
evice *pdev)
> > > > >  		return -ENOMEM;
> > > > >  	}
> > > > > =20
> > > > > -	ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
> > > > > +	ret =3D of_property_match_string(np, "clock-names", "ipg");
> > > > > +	if (ret < 0) {
> > > > > +		ssi_private->has_ipg_clk_name =3D false;
> > > > > +		ssi_private->regs =3D devm_regmap_init_mmio(&pdev->dev, iomem,
> > > > >  			&fsl_ssi_regconfig);
> > > >=20
> > > > Sorry if I was unclear about that. My suggestion was to enable the =
clock
> > > > right here:
> > > > 		clk_prepare_enable(ssi_private->clk);
> > > >=20
> > > > Then you can remove ssi_private->has_ipg_clk_name and all
> > > > clk_prepare_enable() and clk_disable_unprepare() from above. Also y=
ou
> > > > can move the devm_clk_get() into this block.
> > > >
> > >=20
> > > ipg clock not only need to be enabled when accessing register, but al=
so=20
> > > need to be enabled when ssi is working. So I add clk_enable in startu=
p.
> > > =20
> > > > It seems you really want to implement this for devicetrees where the
> > > > "ipg" clock-name is missing, but I don't understand why? I really c=
an't
> > > > see any benefit of adding all these clk_prepare_enable() calls for =
all
> > > > cornercases that may occure. For example the clocks for AC97 are st=
ill
> > > > missing in this version.
> > >=20
> > > When ipg clock-name is missing, I just remain the code logic as befor=
e.
> > > So AC97 case is same as before too.=20
> > > When have ipg clock-name, register it to regmap for accessing registe=
r,
> > > and enabling ipg clock in startup also is useful for AC97.
> > >=20
> > > I don't understand why you think clock for AC97 is still missing?
> >=20
> > Sorry got it all wrong, monday morning tiredness perhaps ;-).
> >=20
> > The patch looks good for me at the second look. I will test it later
> > today and give you feedback.
> >=20
> > Best regards,
> >=20
> > Markus
>=20
> Thank you very much. Your comments help me a lot. and wait your feedback.

Okay, I tested this patch on imx53-qsb with and without the "ipg"
clock-name. Both worked, so:

Tested-by: Markus Pargmann <mpa@pengutronix.de>

I noticed that checkpatch shows two minor style issues. It would be good
if you could fix them.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--gneEPciiIl/aKvOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUFu8DAAoJEEpcgKtcEGQQIBQP/1NYOZgoJt4matvRdZnDZe7M
KRw+PCOdHhst5APhXlrKGBJ3rcXsFdPWaO2NUN1iUAH74hoRD9Q/G41O+hfMHJQk
bUGQrdvaXma86ZtoGUbsyQQi0KSFRSyiWcSaLpDGBGvr7pcYIRTcV/YygbZ+WOCW
E84+oW7sqlBWRyDxlor1BLSC2Aa0SWhTcM5dMzQyOaGrSmaPxMzzvMtc7/1/rQ8T
1Cb629GtHMciSw5UxW8GXeMYSPgZU/sKVfmzec0/uwysmf7BwzfpKt0zIgWnxHek
pIyYvC01g7TR9G4+z+EPRv90XMnWCHMbgPkgeWxJi0NDN8hIEFOiC+z1lHxHK2NG
yYnShMBozTNMrSi68wQnMQGBS05SZLl9CQO/6nQUPqs4F55l3HtRYuNFeqHraL8w
g3BQII1XM4KDMzEz8ADgfdiv6GVIKoy/dDbzK1eAtpCx9VnH7y9uRzFdqdx2ilD5
orKKTHR7cn5IpZ0AiMHyU553ofw8IZZU3JZYBFUOV1DfGK5Taa0VjFrnH0uvz5dS
CTMH3ec7WSoEM3l07+shoyCY2+1sobmmqUY2uBz++JG5SNH30iXsqpWz2g7kYb/k
QfFQjZP7UfATZg6eikLJNcYIlSLuvj59e6rXIVSWaFKXbVfUgWwN6C14zyXxjT9J
VHoJo9HmoAbcppG0FCGA
=hvTM
-----END PGP SIGNATURE-----

--gneEPciiIl/aKvOT--
