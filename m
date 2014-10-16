Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaJPQZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:25:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39962 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbaJPQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:25:03 -0400
Date: Thu, 16 Oct 2014 18:24:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 06/53] dmaengine: Create a generic dma_slave_caps
 callback
Message-ID: <20141016162453.GN19438@lukather>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
 <1413454672-27400-7-git-send-email-maxime.ripard@free-electrons.com>
 <1496298.0f0GAuhKve@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OWK2L5TNMedLh6HD"
Content-Disposition: inline
In-Reply-To: <1496298.0f0GAuhKve@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OWK2L5TNMedLh6HD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2014 at 07:15:40PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> Thank you for the patch.
>=20
> On Thursday 16 October 2014 12:17:05 Maxime Ripard wrote:
> > dma_slave_caps is very important to the generic layers that might inter=
act
> > with dmaengine, such as ASoC. Unfortunately, it has been added as yet
> > another dma_device callback, and most of the existing drivers haven't
> > implemented it, reducing its reliability.
> >=20
> > Introduce a generic behaviour and a flag to trigger it. In case this fl=
ag
> > hasn't been set, fall back to the old mechanism.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  include/linux/dmaengine.h | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index 4d0294ec3567..85afd71df2e7 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -643,6 +643,8 @@ struct dma_device {
> >  	int dev_id;
> >  	struct device *dev;
> >=20
> > +	bool generic_slave_caps;
> > +
> >  	int (*device_alloc_chan_resources)(struct dma_chan *chan);
> >  	void (*device_free_chan_resources)(struct dma_chan *chan);
> >=20
> > @@ -772,17 +774,32 @@ static inline struct dma_async_tx_descriptor
> > *dmaengine_prep_interleaved_dma(
> >=20
> >  static inline int dma_get_slave_caps(struct dma_chan *chan, struct
> > dma_slave_caps *caps) {
>=20
> This is getting too big for an inline function, it should be moved to=20
> drivers/dma/dmaengine.c.

I agree, but I wanted to do that in another patch set. This one is
just getting bigger and bigger, and this is not really the point of
this serie.

> > +	struct dma_device *device;
> > +
> >  	if (!chan || !caps)
> >  		return -EINVAL;
> >=20
> > +	device =3D chan->device;
> > +
> >  	/* check if the channel supports slave transactions */
> > -	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
> > +	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
> > +		return -ENXIO;
> > +
> > +	if (device->device_slave_caps)
> > +		return device->device_slave_caps(chan, caps);
> > +
> > +	/*
> > +	 * Check whether it reports it uses the generic slave
> > +	 * capabilities, if not, that means it doesn't support any
> > +	 * kind of slave capabilities reporting.
> > +	 */
> > +	if (device->generic_slave_caps)
> >  		return -ENXIO;
>=20
> Couldn't we replace that check with if (device->device_control) and get r=
id of=20
> the generic_slave_caps field ? Drivers converted to the new API would the=
n get=20
> slave caps support for free.

Not really. Drivers might have converted to the splitted
device_control (and actually all of them are), while they don't define
the values needed to implement properly the generic slave caps
retrieval (and the vast majority of them doesn't).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OWK2L5TNMedLh6HD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP/FVAAoJEBx+YmzsjxAgGSYP/0gLIVRn5L2z8aMpA4pJ/Ca5
TRrSxC+HM4RNHZn48spWwalvUrdDWU5FnXWJpbS8DiFq/ItvK9y92HGF/JcBeTrs
m1xTawNlDpRJ/KpuvlnfrCuMzqFEyb4YVo6D68xJjwsUrverw+3Ef7+EY9Tak5Jf
TOV+1GkeGJgjj0MtvF5VfI3qMXL/z41NI43GzFlpw94lCea79KogTgo/StIWQwtk
aygUT5VSgx+L5Wo5xp7gz2/NfDxzgKWBDkhjENLXJoQUvvCLqX8AFzRGTQy4aDdB
3BACj+P0XfhBuZOLrOS3g6SOXaUjYyOroM26NP3qHxkBBTJkhRXSlE32rUCcw+V0
/bHa79fGlg7N5d+95NmpjKgiqULp6K8m7Pm1VZpUvCcnqRMYSVS4cOTr/2P6Txa+
cPLUQV8duRSUJxijOaq3MsExkgSUwnyP8GEtTd7FS07p2hBNGhY8dVY8f3okfhCq
VYcCxoEglPk63fV/Z9fccbrn2g5QrSN1GyKpVbIK+9jwGE94HVzBxc87vvuMK4wD
UwLmAAhg+fNH4EWV2pUUZ5hCygnqB5BO5RJ7og7vv3OQmS6bRCcbdfzUfqLLS0Og
SvBxV00M3V2av6t5+7SbsaomOjXVOUIcPi/y72tQd3t4SOMX7MAfiMuJkmbb13Sa
6btm4wwaBKkKpK9xhjUY
=3iVh
-----END PGP SIGNATURE-----

--OWK2L5TNMedLh6HD--
