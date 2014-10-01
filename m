Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaJAIZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:25:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60983 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbaJAIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:25:05 -0400
Date: Wed, 1 Oct 2014 10:21:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH 6/9] dmaengine: Create a generic dma_slave_caps callback
Message-ID: <20141001082157.GE6884@lukather>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411808085-27792-7-git-send-email-maxime.ripard@free-electrons.com>
 <20140927092536.GZ5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <20140927092536.GZ5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Sat, Sep 27, 2014 at 10:25:36AM +0100, Russell King - ARM Linux wrote:
> On Sat, Sep 27, 2014 at 10:54:42AM +0200, Maxime Ripard wrote:
> > dma_slave_caps is very important to the generic layers that might inter=
act with
> > dmaengine, such as ASoC. Unfortunately, it has been added as yet another
> > dma_device callback, and most of the existing drivers haven't implement=
ed it,
> > reducing its reliability.
>=20
> Many haven't implemented it probably because either (a) they don't get us=
ed
> with ASoC, or (b) they aren't aware of the new interface, or (c) can't be
> bothered with the churn.

For a), I really see this as a chicken-egg issue. ASoC is the only
user of it because it's the only framework that has a generic layer on
top, and it's the only framework that has a generic layer because most
drivers don't implement it.

Now, there seems to be a trend to actually use a generic DMA layer in
other frameworks. SPI gained one recently, I think I saw something
about some discussions for IIO and I2C too. And in order for this to
work, we have to make it reliable, and as such, implemented on most
drivers.

> However, trying to return something introduces a bug:
>=20
> >  static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma=
_slave_caps *caps)
> >  {
> > +	struct dma_device *device;
> > +
> >  	if (!chan || !caps)
> >  		return -EINVAL;
> > =20
> > +	device =3D chan->device;
> > +
> >  	/* check if the channel supports slave transactions */
> > -	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
> > +	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
> >  		return -ENXIO;
> > =20
> > -	if (chan->device->device_slave_caps)
> > -		return chan->device->device_slave_caps(chan, caps);
> > +	caps->cmd_pause =3D !!device->device_pause;
> > +	caps->cmd_terminate =3D !!device->device_terminate_all;
> > +
> > +	if (device->device_slave_caps)
> > +		return device->device_slave_caps(chan, caps);
> > =20
> > -	return -ENXIO;
> > +	return 0;
>=20
> So this now returns success if the driver doesn't implement device_slave_=
caps(),
> but with most of the structure zero.
>=20
> Now, consider what effect this has with:
>=20
>=20
>         ret =3D dma_get_slave_caps(chan, &dma_caps);
>         if (ret =3D=3D 0) {
>                 if (dma_caps.cmd_pause)
>                         hw.info |=3D SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INF=
O_RESUME;
>                 if (dma_caps.residue_granularity <=3D DMA_RESIDUE_GRANULA=
RITY_SEGMENT)
>                         hw.info |=3D SNDRV_PCM_INFO_BATCH;
>=20
>                 if (substream->stream =3D=3D SNDRV_PCM_STREAM_PLAYBACK)
>                         addr_widths =3D dma_caps.dstn_addr_widths;
>                 else
>                         addr_widths =3D dma_caps.src_addr_widths;
>         }
>=20
> addr_widths becomes zero, and we also get SNDRV_PCM_INFO_BATCH turned
> on for _all_ DMA engine drivers.  The first renders ASoC useless with
> DMA engine.
>=20
> It may be a good way to get people to implement it, but this will cause
> regressions.

Hmmm, nasty indeed. Maybe we could add a test to see if any of the
field we're going to use are filled, and if not, return an error?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUK7mlAAoJEBx+YmzsjxAgquMP/R4V3vCKSO7E0cKbaj0TTVIf
IKypHAKyq4KIdH9ieu0OTD6TDJ/9Ax+BB7Ml4Jz+gMA6OM1F1jeEvOL4lDxMXPek
nkCvKBet6ookwEVJIECxfBVHrTD/Ka+plk+PkiVIDcA5A6SwNOIk7cL2geLMPS8q
+vPw2++3x+UdEjZVK5LaRaKl9sTC2t1fMCk8Pwlc+cAMcid0mD6mT2xTZdrp/Lp2
X3LZWu1dh99II4RuJrvDIjuEP7dAWhcv59pHQ9mDU92NawtB6sq8SaqmyT0AeifV
kWwiUnKfZ3v9Lx+Br+eaE40hTnchRBQsmKzkv01Zu2ZQZg90p/U/FhDLptkIm397
puv59R03ZkAMt7CZ6D1tkuOrsoyb9bUecszoktfBiHCkWgvcD1nKpFkVV1VDfMQL
q2HNonSVQqUEjmCUTixxx4z6v1PDoRK6t/J7Q07EBStiPDFTszDRNzaSXxgfmU2G
MzhWKt5TKlLz+2E5nM66+UZkO5huAPCe/2yI2NgKbNCq5NG+27N0ToFPWX+grcwP
rsi7jvugUigFE8mTOix1UP07gVdWUCwSDysjkfIr5itH5bYBOTuh57eTSVQ9YYHx
BLaN4lk4bYb+Sy8Y8BV+qWTkJ46mtjqQdizaD5te90bW1NGD9yA15mcgl1sEmm0j
8QcX9BHM0G4Je/830RQu
=ZuFl
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
