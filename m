Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbbA0AEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:04:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35282 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbbA0AEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:04:36 -0500
Date: Tue, 27 Jan 2015 00:04:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127000428.GK21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-9-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3w8x3zxtEJX8SUiO"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-9-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/18] spi/xilinx: Support cores with no interrupt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3w8x3zxtEJX8SUiO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:08:40PM +0100, Ricardo Ribalda Delgado wrote:

> The core can run in polling mode. In fact, the performance of the core
> is similar (or even better), due to the fact most of the spi
> transactions are just a couple of bytes and there is one irq per
> transactions.

> When an mtd device is connected via spi, reading 8MB of data produces
> more than 80K interrupts (with irq disabling, context swith....)

Right, for short transfers polling tends to win every time over
interrupts - if you look at other controller drivers you'll see a lot of
them use this technique.  The best practice here is generally to use a
copy break and do very short transfers in polling mode and go back to
interrupts for larger ones.  This break is typically done at the point
where we go over a FIFO in transfer size since normally if the device is
designed to be run with DMA the FIFO will be quite small.

Obviously this isn't quite the same case since not only is there no DMA
support (yet?) but the FIFO could be any size but similar things apply
especially if someone configured the device with a large FIFO.

> -	xspi_init_hw(xspi);
> -
>  	xspi->irq =3D platform_get_irq(pdev, 0);
> -	if (xspi->irq < 0) {
> -		ret =3D xspi->irq;
> -		goto put_master;
> +	if (xspi->irq >=3D 0) {
> +		/* Register for SPI Interrupt */
> +		ret =3D devm_request_irq(&pdev->dev, xspi->irq, xilinx_spi_irq, 0,
> +				dev_name(&pdev->dev), xspi);
> +		if (ret)
> +			goto put_master;
>  	}
> =20
> -	/* Register for SPI Interrupt */
> -	ret =3D devm_request_irq(&pdev->dev, xspi->irq, xilinx_spi_irq, 0,
> -			       dev_name(&pdev->dev), xspi);
> -	if (ret)
> -		goto put_master;
> +	/* SPI controller initializations */
> +	xspi_init_hw(xspi);

This appears to move the interrupt request before the hardware reset.
Are you sure the interrupt handler won't misbehave if it fires before we
finished initializing?  One thing the hardware reset should do is get
the device in a known good state.

--3w8x3zxtEJX8SUiO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxtYLAAoJECTWi3JdVIfQOwUH/1aYs5vxXqB1lWaVjS5o4GNq
pl9g+ATdXLxZScdsv1aquXZH/mjGQVKvVjQ47eUkB1eDPUdqhwR9pmEK3VDK24vc
D3bhYTsmkL1VtYWLBFRsY2EMWfQitXLE+B9/Cgpls5WLLalKeWL/5eGMSdat7Ysn
2JrU7OeVIZihJnua731RwDWuCu0VYHxDwpybdYp20xqru+T4KZJVGpDCVZRiRpuj
nuNTdWuJgzaMviPIDnKW8ena2sarnBDpYLF3EQZsGHWQvBneJXVC1Wv4wJzsXapv
/D5vAJBuApN6mqBeeG5qEPeePwIbm6HM2DtKQXW5CIFbyTLMZsE2FWoijoObE2M=
=ekUg
-----END PGP SIGNATURE-----

--3w8x3zxtEJX8SUiO--
