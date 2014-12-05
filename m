Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaLEOfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:35:43 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54566 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbaLEOfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:35:42 -0500
Date: Fri, 5 Dec 2014 15:33:59 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 34/61] dmaengine: omap: Split device_control
Message-ID: <20141205143359.GV30256@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
 <20141205142702.GF3411@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hFEw+uh9kF5V6COn"
Content-Disposition: inline
In-Reply-To: <20141205142702.GF3411@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hFEw+uh9kF5V6COn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Fri, Dec 05, 2014 at 07:57:02PM +0530, Vinod Koul wrote:
> On Mon, Nov 17, 2014 at 02:42:28PM +0100, Maxime Ripard wrote:
> > Split the device_control callback of the TI OMAP DMA driver to make use
> > of the newly introduced callbacks, that will eventually be used to retr=
ieve
> > slave capabilities.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/dma/omap-dma.c | 51 +++++++++++++++---------------------------=
--------
> >  1 file changed, 15 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> > index a8aa5b6bb5e2..1cadf812f3b3 100644
> > --- a/drivers/dma/omap-dma.c
> > +++ b/drivers/dma/omap-dma.c
> > @@ -948,8 +948,10 @@ static struct dma_async_tx_descriptor *omap_dma_pr=
ep_dma_cyclic(
> >  	return vchan_tx_prep(&c->vc, &d->vd, flags);
> >  }
> > =20
> > -static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave=
_config *cfg)
> > +static int omap_dma_slave_config(struct dma_chan *chan, struct dma_sla=
ve_config *cfg)
> >  {
> > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > +
> >  	if (cfg->src_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES ||
> >  	    cfg->dst_addr_width =3D=3D DMA_SLAVE_BUSWIDTH_8_BYTES)
> >  		return -EINVAL;
> > @@ -959,8 +961,9 @@ static int omap_dma_slave_config(struct omap_chan *=
c, struct dma_slave_config *c
> >  	return 0;
> >  }
> > =20
> > -static int omap_dma_terminate_all(struct omap_chan *c)
> > +static int omap_dma_terminate_all(struct dma_chan *chan)
> >  {
> > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> >  	struct omap_dmadev *d =3D to_omap_dma_dev(c->vc.chan.device);
> >  	unsigned long flags;
> >  	LIST_HEAD(head);
> > @@ -996,8 +999,10 @@ static int omap_dma_terminate_all(struct omap_chan=
 *c)
> >  	return 0;
> >  }
> > =20
> > -static int omap_dma_pause(struct omap_chan *c)
> > +static int omap_dma_pause(struct dma_chan *chan)
> >  {
> > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > +
> >  	/* Pause/Resume only allowed with cyclic mode */
> >  	if (!c->cyclic)
> >  		return -EINVAL;
> > @@ -1010,8 +1015,10 @@ static int omap_dma_pause(struct omap_chan *c)
> >  	return 0;
> >  }
> > =20
> > -static int omap_dma_resume(struct omap_chan *c)
> > +static int omap_dma_resume(struct dma_chan *chan)
> >  {
> > +	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > +
> >  	/* Pause/Resume only allowed with cyclic mode */
> >  	if (!c->cyclic)
> >  		return -EINVAL;
> > @@ -1029,37 +1036,6 @@ static int omap_dma_resume(struct omap_chan *c)
> >  	return 0;
> >  }
> > =20
> > -static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd c=
md,
> > -	unsigned long arg)
> > -{
> > -	struct omap_chan *c =3D to_omap_dma_chan(chan);
> > -	int ret;
> > -
> > -	switch (cmd) {
> > -	case DMA_SLAVE_CONFIG:
> > -		ret =3D omap_dma_slave_config(c, (struct dma_slave_config *)arg);
> > -		break;
> > -
> > -	case DMA_TERMINATE_ALL:
> > -		ret =3D omap_dma_terminate_all(c);
> > -		break;
> > -
> > -	case DMA_PAUSE:
> > -		ret =3D omap_dma_pause(c);
> > -		break;
> > -
> > -	case DMA_RESUME:
> > -		ret =3D omap_dma_resume(c);
> > -		break;
> > -
> > -	default:
> > -		ret =3D -ENXIO;
> > -		break;
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> >  static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
> >  {
> >  	struct omap_chan *c;
> > @@ -1136,7 +1112,10 @@ static int omap_dma_probe(struct platform_device=
 *pdev)
> >  	od->ddev.device_issue_pending =3D omap_dma_issue_pending;
> >  	od->ddev.device_prep_slave_sg =3D omap_dma_prep_slave_sg;
> >  	od->ddev.device_prep_dma_cyclic =3D omap_dma_prep_dma_cyclic;
> > -	od->ddev.device_control =3D omap_dma_control;
> this should be assigned to omap_dma_slave_config. omap_dma_control is not
> here :(

I'm not sure what you mean here. I'm removing this line, together with
the whole omap_dma_control function.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hFEw+uh9kF5V6COn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgcJXAAoJEBx+YmzsjxAgqiMP/iwOQJlkQPgtsiweW/GwHgBj
eHWjI2pghNZFw7I3U6+UwRblq/XDzi/pARv5yTYu3iujAQfwmQ5B/34/iNJGUNT4
scZtO2iiW7IgVEFJ9Tr614wO8fo1WM4+cxi6nTID4eiyOO8GVTSmWwYoowE2BTjV
ZW3y9+dH0gmOa7lvXve29uBdd2l4Kh/kr1Z47PoyRUGk2TEAQ0KeSL1unyoG4hdY
oD1UF93Ligh2S6NATPhcTISaYe3JCSuAzta4YhLmLkaCLBuiU8fOPd09Of+qoUeO
Hw/oIOl8OhqaWXGTGRjtOVnHYHaa74T/wFpU2hn0zvm7UagQrByi326XZPBub3NZ
267wBsyZdiUUsTGduxhwvznouHZRPHJsPzTge2Q1nQscLxuJJuaZ/Hl9gMP6yohc
G4blVYjYmNp4NW0oAKbP9CSV+Uiu+RzUWuE1ja0SD5Q6sDIIBNbCCJrtrBth+gmi
H2IuSodLWP7ljTC1IOOeOYVemgidFScVsrnAW6mKYGbMVTAP2Gfth8PCAB9JbApj
UDPWdf7Yy/peLPk2pYs67WgFZEaUgIwD6+fXBH/nHlEKBlszZhOI2mQUqCIpGO8T
CWFDkA/9r5kLwhZWmDnQW9JFQUfGG+iWJnEg/lKJKo0XL+3PPkBjWqnKAdVN3rVr
0W3+pDmnCUYrJ0Nyo8P9
=e6SP
-----END PGP SIGNATURE-----

--hFEw+uh9kF5V6COn--
