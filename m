Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaBDRyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:54:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35364 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaBDRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:54:18 -0500
Date: Tue, 4 Feb 2014 17:54:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204175410.GL22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr>
 <20140204133014.GA22609@sirena.org.uk>
 <20140204181605.5b837a70@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BrzBj8PzWVa+9geT"
Content-Disposition: inline
In-Reply-To: <20140204181605.5b837a70@armhf>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] ASoC: tda998x: add a codec driver for the TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BrzBj8PzWVa+9geT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 06:16:05PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > > +	/* load the optional CODEC */
> > > +	of_platform_populate(np, NULL, NULL, &client->dev);

> > Why is this using of_platform_populate()?  That's a very odd way of
> > doing things.

> The i2c does not populate the subnodes in the DT. I did not find why,
> but, what is sure is that if of_platform_populate() is not called, the
> tda CODEC module is not loaded.

You shouldn't be representing this as a separate node in the DT unless
there really is a distinct and reusable IP, otherwise you're putting
Linux implementation details in there.  Describe the hardware, not the
implemementation.

> You may find an other example in drivers/mfd/twl-core.c.

The TWL drivers aren't always a shining example of how to do things -
they were one of the earliest MFDs so there's warts in there.

> > > +config SND_SOC_TDA998X
> > > +	tristate
> > > +	depends on OF
> > > +	default y if DRM_I2C_NXP_TDA998X=y
> > > +	default m if DRM_I2C_NXP_TDA998X=m

> > Make this visible if it can be selected from DT so it can be used with
> > generic cards.

> I don't understand. The tda CODEC can only be used with the TDA998x I2C
> driver. It might have been included in the tda998x source as well.

You shouldn't have the default settings there at all, that's not the
normal idiom for MFDs.  I'd also not expect to have to build the CODEC
driver just because I built the DRM component.

> Now, the CODEC is declared inside the tda998x as a node child. But, in
> a bad DT, the tda CODEC could be declared anywhere, even inside a other
> DRM I2C slave encoder, in which case, bad things would happen...

So, part of the problem here is that this is being explicitly declared
in the DT leading to more sources for error.

> > What does this actually do?  No information is being passed in to the
> > core function here, not even any information on if it's starting or
> > stopping.  Looking at the rest of the code I can't help thinking it
> > might be clearer to inline this possibly with a lookup helper, the code
> > is very small and the lack of parameters makes it hard to follow.

> I thought it was simple enough. The function tda_start_stop() is called
> from 2 places:

It's not at all obvious - _audio_update() isn't a terribly descriptive
name, just looking at that function by itself I had no idea what it was
supposed to be doing.

> - on audio start in tda_startup with the audio type (DAI id)
> 	priv->dai_id = dai->id;

> - on audio stop with a null audio type
> 	priv->dai_id = 0;		/* streaming stop */

> On stream start, the DAI id is never null, as explained in the patch 1:

> 	The audio format values in the encoder configuration interface  are
> 	changed to non null values so that the value 0 is used in the audio
> 	function to indicate that audio streaming is stopped.

> and on streaming stop the port is not meaningful.

> I will add a null item in the enum (AFMT_NO_AUDIO).

So we can't use both streams simultaneously then?  That's a bit sad.

--BrzBj8PzWVa+9geT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8Sk+AAoJELSic+t+oim9JqcP/R5L4TJjwGwhKVSKd9egxV/V
+/URsfGxMcjXxoU0N98m/UILQofBiybrINbaLoTCTEnISeLtXeezrzUdnx/fEJSP
QDGOT8TNeqY0WYo6lre42pTAaV2YJKOxEmvcLAWS81FsOxkOJohHOVDRjYIlVHBd
w5jB44Y89xINGjHKEzeacTSlOLY6ywZb+M5PiRGdVNw6LwwC7gRdUT7KYIXlhKRT
mRch3P7DLe8RKXqAqBddtmZD3gRtCXdMmBYwsfSx5sefH6qC2YcnXc7wcxtKYs6k
OMYPc3lQaRIFo5g83SXAH9fmiP+zVgaG3VQFBlBUywbox2u+ZD8bIttXb1rbM2V3
x6A9TJ9ql17VmUle+g3Rxg1BIbLU3X5Tyxv+u9qTw4pz6SdOYG4MwgkfwxMGqb+6
3eZKzfraXhPXf7Be4dsyNMGSU7DDXz3EAF1sRQJ5M1Au3SOUJIdnFI+fq6GV1Fo9
65J3gpx4A4Hfu5hKbQslBMy1YrQDCbNrXReJY1Z0hKP6VN7IA7Ee45OdUWWSAp+8
3ED5jcLMfrIDauFb0NngllCBo/n/UvQ/BI3clqAxS+SojGvMr9xq6xhBu1DhFjAx
i5Cf4EraxUG42UDkvz+CuzPJOvY/Ya4/RxZQfqtSVEPPSKhqMOve/aNlR8dCxts1
3sDzqUj1CV0vKzZOAME/
=65Yr
-----END PGP SIGNATURE-----

--BrzBj8PzWVa+9geT--
