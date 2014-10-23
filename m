Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJWIKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:10:18 -0400
Received: from down.free-electrons.com ([37.187.137.238]:58974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754090AbaJWIKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:10:05 -0400
Date: Thu, 23 Oct 2014 10:08:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 06/53] dmaengine: Create a generic dma_slave_caps
 callback
Message-ID: <20141023080851.GI7893@lukather>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
 <1496298.0f0GAuhKve@avalon>
 <20141016162453.GN19438@lukather>
 <2111765.kYORi97jNj@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Content-Disposition: inline
In-Reply-To: <2111765.kYORi97jNj@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Wed, Oct 22, 2014 at 11:16:03PM +0300, Laurent Pinchart wrote:
> Hi Maxime,
>=20
> On Thursday 16 October 2014 18:24:53 Maxime Ripard wrote:
> > On Thu, Oct 16, 2014 at 07:15:40PM +0300, Laurent Pinchart wrote:
> > > On Thursday 16 October 2014 12:17:05 Maxime Ripard wrote:
> > > > dma_slave_caps is very important to the generic layers that might
> > > > interact with dmaengine, such as ASoC. Unfortunately, it has been a=
dded
> > > > as yet another dma_device callback, and most of the existing drivers
> > > > haven't implemented it, reducing its reliability.
> > > >=20
> > > > Introduce a generic behaviour and a flag to trigger it. In case this
> > > > flag hasn't been set, fall back to the old mechanism.
> > > >=20
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > ---
> > > >=20
> > > >  include/linux/dmaengine.h | 25 +++++++++++++++++++++----
> > > >  1 file changed, 21 insertions(+), 4 deletions(-)
> > > >=20
> > > > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > > > index 4d0294ec3567..85afd71df2e7 100644
> > > > --- a/include/linux/dmaengine.h
> > > > +++ b/include/linux/dmaengine.h
> > > > @@ -643,6 +643,8 @@ struct dma_device {
> > > >=20
> > > >  	int dev_id;
> > > >  	struct device *dev;
> > > >=20
> > > > +	bool generic_slave_caps;
> > > > +
> > > >=20
> > > >  	int (*device_alloc_chan_resources)(struct dma_chan *chan);
> > > >  	void (*device_free_chan_resources)(struct dma_chan *chan);
> > > >=20
> > > > @@ -772,17 +774,32 @@ static inline struct dma_async_tx_descriptor
> > > > *dmaengine_prep_interleaved_dma(
> > > >=20
> > > >  static inline int dma_get_slave_caps(struct dma_chan *chan, struct
> > > >=20
> > > > dma_slave_caps *caps) {
> > >=20
> > > This is getting too big for an inline function, it should be moved to
> > > drivers/dma/dmaengine.c.
> >=20
> > I agree, but I wanted to do that in another patch set. This one is
> > just getting bigger and bigger, and this is not really the point of
> > this serie.
>=20
> If both get merged in the same kernel version I would be fine with this.

I'll do my best.

> > > > +	struct dma_device *device;
> > > > +
> > > >=20
> > > >  	if (!chan || !caps)
> > > >  		return -EINVAL;
> > > >=20
> > > > +	device =3D chan->device;
> > > > +
> > > >=20
> > > >  	/* check if the channel supports slave transactions */
> > > >=20
> > > > -	if (!test_bit(DMA_SLAVE, chan->device->cap_mask.bits))
> > > > +	if (!test_bit(DMA_SLAVE, device->cap_mask.bits))
> > > > +		return -ENXIO;
> > > > +
> > > > +	if (device->device_slave_caps)
> > > > +		return device->device_slave_caps(chan, caps);
> > > > +
> > > > +	/*
> > > > +	 * Check whether it reports it uses the generic slave
> > > > +	 * capabilities, if not, that means it doesn't support any
> > > > +	 * kind of slave capabilities reporting.
> > > > +	 */
> > > > +	if (device->generic_slave_caps)
> > > >  		return -ENXIO;
> > >=20
> > > Couldn't we replace that check with if (device->device_control) and g=
et
> > > rid of the generic_slave_caps field ? Drivers converted to the new API
> > > would then get slave caps support for free.
> >=20
> > Not really. Drivers might have converted to the splitted device_control=
 (and
> > actually all of them are), while they don't define the values needed to
> > implement properly the generic slave caps retrieval (and the vast major=
ity
> > of them doesn't).
>=20
> Indeed, my bad.
>=20
> How about testing those fields then ? You could consider that the driver =
wants=20
> the generic slave caps implementation if device->directions is set to a n=
on-
> zero value for instance.


Hmmm, why not. I guess I'm in for a v4 then :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSLeTAAoJEBx+YmzsjxAg45gQAKB8pxC3WNvPoRHOdUN2h7nA
zgOZL22crFXW5ScAhlTMfiQPfny+bWLI0bZ/guJGIzYjzSPwkya55/Z9tMvtlVOb
er7yCiZNdQd69B8OIqCXE5sQ4tAYCdyfAfCmwm+q7ImlKZTQ1daT//hswdehApyL
nAnYHxmBIxNHDGC5bRYSfI5AUJTdaSftkR5kNS1pVgVSMwcgsV7SfrZxGp/pxkZr
fh6mKUax8c5n2G+ohEjOQyM84VfTK9pPJppqD50cJkWxr3yyrGWn8tdz5aW6vugF
3SYZBsPF3iYMd7U0tNICF+87H4llfG+FqKAu/ivxI/HRiF111voPcmP9Xfn0qJ0x
iFZxUsC0IS0ot6L/IeYrRFFTVlEdkzjDMwEP5MRdM4QGDgskhyw3oBf16G8fhJ1Q
Su91lQnTE2AurPxHsBVL07Iknbzvu0/YcfGDzS1UlOUfvOLyfpx19UgomJaIsUva
Xv5ZrEUJxkUksfPuidimarGFUcNip6zKlBSgQSQmgM0QnMFKtuQleYBMsbznfGxk
g6Yr32fRy+48JF4VKdVnKU8u55e0egWFvS9fm9PZRfQYlPMhQqKEs+S93qJWFNLt
NQT7z+MMb3KwZ+5Ya6Nt6R8ieovoY0djCKmM9HFJGs7KNyZXZs0CU40F8rASL1Z7
ZenCGnJn3N5EKPLMEWYh
=txul
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
