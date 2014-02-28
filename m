Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaB1OaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:30:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52073 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbaB1OaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:30:08 -0500
Date: Fri, 28 Feb 2014 15:27:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/5] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140228142753.GQ607@lukather>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393258967-4843-5-git-send-email-maxime.ripard@free-electrons.com>
 <1393327695.28803.25.camel@smile.fi.intel.com>
 <20140228103614.GM607@lukather>
 <1393594391.28803.79.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hEarWVD7htqb1VxP"
Content-Disposition: inline
In-Reply-To: <1393594391.28803.79.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hEarWVD7htqb1VxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 03:33:11PM +0200, Andy Shevchenko wrote:
> On Fri, 2014-02-28 at 11:36 +0100, Maxime Ripard wrote:
> > Hi Andy,
> >=20
> > On Tue, Feb 25, 2014 at 01:28:15PM +0200, Andy Shevchenko wrote:
> > > > +static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
> > > > +{
> > > > +	struct sun6i_dma_dev *sdev =3D (struct sun6i_dma_dev *)dev_id;
> > > > +	struct sun6i_vchan *vchan;
> > > > +	struct sun6i_pchan *pchan;
> > > > +	int i, j, ret =3D 0;
> > > > +	u32 status;
> > > > +
> > > > +	for (i =3D 0; i < 2; i++) {
> > > > +		status =3D readl(sdev->base + DMA_IRQ_STAT(i));
> > > > +		if (!status) {
> > > > +			ret |=3D IRQ_NONE;
> > >=20
> > > Maybe move this to definition block.
> > >=20
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		dev_dbg(sdev->slave.dev, "DMA irq status %s: 0x%x\n",
> > > > +			i ? "high" : "low", status);
> > > > +
> > > > +		writel(status, sdev->base + DMA_IRQ_STAT(i));
> > > > +
> > > > +		for (j =3D 0; (j < 8) && status; j++) {
> > > > +			if (status & DMA_IRQ_QUEUE) {
> > > > +				pchan =3D sdev->pchans + j;
> > > > +				vchan =3D pchan->vchan;
> > > > +
> > > > +				if (vchan) {
> > > > +					unsigned long flags;
> > > > +
> > > > +					spin_lock_irqsave(&vchan->vc.lock,
> > > > +							  flags);
> > > > +					vchan_cookie_complete(&pchan->desc->vd);
> > > > +					pchan->done =3D pchan->desc;
> > > > +					spin_unlock_irqrestore(&vchan->vc.lock,
> > > > +							       flags);
> > > > +				}
> > > > +			}
> > > > +
> > > > +			status =3D status >> 4;
> > > > +		}
> > > > +
> > > > +		ret |=3D IRQ_HANDLED;
> > >=20
> > > In case one is handled, another is not, what you have to do?
> >=20
> > The interrupt status is split across two registers. In the case where
> > one of the two register reports an interrupt, we still have to handle
> > our interrupt, we actually did, so we have to return IRQ_HANDLED.
>=20
> You removed the code below this assignment, but if I remember correctly
> you check for exact value there.
>=20
> In case of one is not handled and the other is handled you will have ret
> =3D IRQ_HANDLED | IRQ_NONE. Thus, your following code will not be
> executed. Is it by design?

The code that got removed was

if (ret =3D=3D IRQ_HANDLED)
   tasklet_schedule()

return ret;

The only thing that wouldn't have been executed if we had no
interrupts to report was the tasklet_schedule.

This has lightly changed though in the v2, thanks to your comments.

I don't have the | anymore, and call tasklet_schedule directly in the
loop.

I'll send the v2 in a short while.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hEarWVD7htqb1VxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTEJzpAAoJEBx+YmzsjxAgcT4P/1Sd3ex0WJavxclx7l99pNXu
FZzNlgMbo4aSAopX+l8asYmk3vIem0kl02IDOa8hW5cs8rH1Nr4gKYhVQprGj17n
525tEjrKdAv96yPqhROByPdbPGcT64B9OrPrSnhEx/kLg0EOtK95gUwYeuVc2D3u
Ifi1pZwwivjDSkisTfswFoQ48kaH6nDSTIE81j8fLotgxMAwU6zzSvL2Jd1UG9eY
Oxy/UHNsnEcY5lXvOZh9qu4vi9r+q6bN+zgc3uEUjccx0x5h7QTTbLr/kLm9h5dM
GPqYT6WPy8geHuV4eVxH9oUoffaeOP0ZUUJMeR/ai9oCSCacud6Obpg8orP0WuOl
Nnk5hh0hdoi0AORPr5240tnHA+Dz0+JKCvYU/i7EIj9Bz9wnWBESpGWVeuciUHmp
hZe9mESm6AbIVDeONVvxmrd1UM5hYbdlv/QUmwPaD4qTdXoumvApbS261qLEo3Zo
qBFyu5Y0+mFtvCP7sF/teoVeeT2PtiTZ8/8i9sMgxCeN46je3N2UodP8D4+wRgzy
aFZJ4tMWjABODCiJFJWUOuNoNR1zMUSeHen3Wbd+WcUIk1mlS5ZtrbwlLYRc1MLD
RH/N6qXxzu0jTP7nPkEZi6ldAP3j32Qn3lvLM6ghe8f8yUl3y7B4P96f3Bs6P4U0
3fPl1EwfaOMqFzWMcrXa
=g5Fm
-----END PGP SIGNATURE-----

--hEarWVD7htqb1VxP--
