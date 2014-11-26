Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaKZS10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:27:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39656 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaKZS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:27:25 -0500
Date: Wed, 26 Nov 2014 18:25:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141126182521.GP7712@sirena.org.uk>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1416996549-29328-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hmCh0Pbpbj9gavR3"
Content-Disposition: inline
In-Reply-To: <1416996549-29328-1-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hmCh0Pbpbj9gavR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 26, 2014 at 12:09:09PM +0200, Laurentiu Palcu wrote:

> +static int dln2_spi_transfer_one_message(struct spi_master *master,
> +					 struct spi_message *msg)
> +{
> +	struct dln2_spi *dln2 = spi_master_get_devdata(master);
> +	struct spi_device *spi = msg->spi;
> +	struct spi_transfer *xfer;
> +	int status;
> +
> +	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
> +		u8 attr = 0;
> +
> +		status = dln2_spi_transfer_setup(dln2, xfer->speed_hz,
> +						 xfer->bits_per_word,
> +						 spi->mode);
> +		if (status < 0) {
> +			dev_err(&dln2->pdev->dev, "Cannot setup transfer\n");
> +			break;
> +		}
> +
> +		if (!xfer->cs_change &&
> +		    !list_is_last(&xfer->transfer_list, &msg->transfers))
> +			attr = xfer->cs_change ? 0 : DLN2_SPI_ATTR_LEAVE_SS_LOW;
> +
> +		status = dln2_spi_rdwr(dln2, xfer->tx_buf, xfer->rx_buf,
> +				       xfer->len, attr);

We recently added a spi_transfer_is_last() operation which should allow
you to move this to using transfer_one() which is a bit nicer.

> +	/* enable SPI module, we're good to go */
> +	ret = dln2_spi_enable(dln2, true);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to enable SPI module\n");
> +		goto exit_free_master;
> +	}

It would be nice to have runtime PM operations which keep the device
disabled when idle, presumably that'd save a bit of power and it's
generally better practice.

--hmCh0Pbpbj9gavR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdhsRAAoJECTWi3JdVIfQmEEH/2pq0NLfdONDQ+OO7HRCzIAr
GkwryK8mxrNN+TgxraugM3gd7m9aWI9wwjib+pvF3jLiqja8q+Y/6dPdZ1wAUZeZ
IKm/oyO+xkcUuNdyGnU3WbRdbtylBmcO9tNdyxMFckU4KJHW6RoJ3SHWpxJFXhqk
lJLqTaNJqOztWMwjbNFTWzw1Ok1cc4dftc2OLNsXxCbxjVtvOQnXaNHjcsPmNFog
CO1X47IJ2X2ISssiOaYmaJsc3WFdoqCMoDk6ta2FQaVvNRz5cXAQm/u/L6I6u2LW
AqlhQGJ4LhHAS/cZuInb/jM3UWG5lq9HBYkMACQfRL+Ip7xgkqjRIR7h469YzuU=
=3gg5
-----END PGP SIGNATURE-----

--hmCh0Pbpbj9gavR3--
