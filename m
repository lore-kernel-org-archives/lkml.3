Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbbAZXzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:55:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35272 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbbAZXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:54:55 -0500
Date: Mon, 26 Jan 2015 23:54:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150126235438.GJ21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-5-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="W/y7qBwfEQL/2otS"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-5-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/18] spi-xilinx: Simplify spi_fill_tx_fifo
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/y7qBwfEQL/2otS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:08:36PM +0100, Ricardo Ribalda Delgado wrote:
> Instead of checking the TX_FULL flag for every transaction, find out the
> size of the buffer at probe time and use it.

So, I see what's going on here and the potential performance benefit
=66rom avoiding the MMIO access.  However I can't help but worry that this
makes things more fragile - the current code will transparently handle
any races or anything which result in a misfilling of the FIFO for some
reason either now or in the future as performance is improved and the
driver gets more fancy.

As things stand if I look at the code it's fairly clear it should be
safe and unfortunately we only have an underrun interrupt which will be
triggered normally (no overflow interrupt) so we can't really use that
to add a bit of robustness.  I'm tempted to suggest checking that we did
trigger the FIFO full flag when we fill the FIFO but that feels like
overengineering.

Let me think about this, I'll probably apply it but if you can think
about ways of making this more robust that'd be good.

> @@ -413,6 +424,8 @@ static int xilinx_spi_probe(struct platform_device *p=
dev)
>  		goto put_master;
>  	}
> =20
> +	xspi->buffer_size =3D xilinx_spi_find_buffer_size(xspi);
> +
>  	/* SPI controller initializations */
>  	xspi_init_hw(xspi);

It seems safer to reset the hardware, probe the FIFO size and then reset
the hardware again in case something decided to leave some data in the
FIFO (perhaps some bootloader wasn't as well programmed as one might
desire for example).  Not cricial now but it could again become
important with future optimizations.

--W/y7qBwfEQL/2otS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxtO9AAoJECTWi3JdVIfQKSsH/Ah9V6F++jpOAxUkVw9fUE8A
pCqrFInxUDHKY/+I03IuaBd2lgaRY+cYPqYnBXPKJEvJSvarwFJMZOCNnLGgjdYC
wXdpXtXIyu3hzJErddzLxTcYTG6z1XEJT0xo42brxloLUbmjezwnjESqy/UA28AG
l3/2FwA2Q0lx7OVmT5YKUF3/URIi1C4vWnbr25hQrT6RxXMqlJDEae9vSJ2GqxIm
9Iiqr8ZLHflcttfPPG2Q+Mz3bIT01ZhpCiR65fy6NctkzRAp+aDwhCdhNXcfQ7H0
XJpvSX8puTx6LnOPm8tTb+79yCo7sTzfaW8KEQdeoX0O1cuYklXJ21c/f2gr4nc=
=Cdfu
-----END PGP SIGNATURE-----

--W/y7qBwfEQL/2otS--
