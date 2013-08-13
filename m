Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab3HMUS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:18:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35848 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3HMUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:18:26 -0400
Date: Tue, 13 Aug 2013 21:18:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130813201816.GG6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
 <20130812233641.GL6427@sirena.org.uk>
 <2472314.6b8DcBdcjO@flatron>
 <20130813185547.GD6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sszduGT9fQUHJP/+"
Content-Disposition: inline
In-Reply-To: <20130813185547.GD6427@sirena.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in
 case of S3C64XX
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sszduGT9fQUHJP/+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 07:55:47PM +0100, Mark Brown wrote:

> I'm still debugging what's going on here - the basic refcounting all
> looks OK in the SPI driver, I can see it requesting and releasing with
> the refcounts all going back to zero in the DMA driver as expected but
> when we come back to the device later on dmaengine is deciding the
> device is unavailable quite early on in the process.

The failure is happening because this check is failing:

	/* devices with multiple channels need special handling as we need to
	 * ensure that all channels are either private or public.
	 */
	if (dev->chancnt > 1 && !dma_has_cap(DMA_PRIVATE, dev->cap_mask))
		list_for_each_entry(chan, &dev->channels, device_node) {
			/* some channels are already publicly allocated */
			if (chan->client_count) {

which is happening because dma1chan0 (which is on the same DMA
controller as the SPI controller) and in fact every other DMA channel
had references grabbed by the network stack dmaengine helpers which I'd
enabled in config.  The fact that they do that is unhelpful, it renders
the API mostly useless, but is nothing to do with this series.

Having tweaked the config everything appears to work so:

Tested-by: Mark Brown <broonie@linaro.org>

though the whole thing with the filter function is as I say a bit fun
=66rom a code review point of view.

--sszduGT9fQUHJP/+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCpSEAAoJELSic+t+oim93gMP/RmqEk398uDLUWt8Spob1X0S
bHZxV5jrbcp5oxaJDEWJm4ucIs53slqxyhN2f2JznbWbTewGbDF41qGETcRG5fAC
tnC3JY+xZme+3gHn69YgY2+iNDMgGGWYOVMDo/+V1ywd6ddVcmeuA/WhKpLxZp1S
PHV2xkfvxBtJEq4NOUA6Zmxz+egZf2mqENg6iCXzmo22qlUR2n+bidbJ/zhy20AM
8T4EN3y3MhXpbTBikCmKcXeywdr8jTUL7zHdcLAR9+fiSAbj8Z4gVS3IGlqpQySs
4UGUXiUZC+jXlXfuawNDqQUKv/iThCKuZhQCXmYqzKVlPV1RQ95Saus6+5uXMKOm
HxvZK9wK+vIOCr4EtkvCXkHGxL3+C5Edr3vAl/vjtBeNEpWfrRkWZLcvc25APzSx
ckopq9TDWKP/HB5Akpsvjm11UaI0ZXIGtyO071aTZuYBE6SZyV5OY+8a6IaLOw0A
2g+KO3VjmyHSnlf34RyX5UGJY5kaxSgMbmkNDjHgVZO70vFgi79o7Tx7nxC6Vr1x
Fx4tqWynBAPATDUClmmMBp1XsCNF5GiM7tfGBJ5GTIdL4vdFtR8UP2SJ/gEfYEmX
Oan0xinp8F4cUJx/HQoACGqKKEC3nE9OSXsjuDM1btye9d4qPFzP/KeeBA+Kc2II
sv1ECC8fPyQ/iC19MKaD
=UYZA
-----END PGP SIGNATURE-----

--sszduGT9fQUHJP/+--
