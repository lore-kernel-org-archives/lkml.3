Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaBSP3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:29:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53659 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaBSP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:29:23 -0500
Date: Thu, 20 Feb 2014 00:28:49 +0900
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>, dsneddon@codeaurora.org
Message-ID: <20140219152849.GI2669@sirena.org.uk>
References: <1392308498-30209-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rStesqTWVLwTUuyd"
Content-Disposition: inline
In-Reply-To: <1392308498-30209-1-git-send-email-iivanov@mm-sol.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATH v2 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rStesqTWVLwTUuyd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 06:21:38PM +0200, Ivan T. Ivanov wrote:

> Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> provides a common data path (an output FIFO and an input FIFO)
> for serial peripheral interface (SPI) mini-core. SPI in master
> mode supports up to 50MHz, up to four chip selects, programmable
> data path from 4 bits to 32 bits and numerous protocol variants.

I've applied this since it mostly looks good but there's a few small
outstanding issues, please submit incremental patches fixing them.

> +#define SPI_CONFIG			0x0300
> +#define SPI_IO_CONTROL			0x0304
> +#define SPI_ERROR_FLAGS			0x0308
> +#define SPI_ERROR_FLAGS_EN		0x030c

You've got lots of defines that are just plain SPI_ which is looking for
namespace collisions - please prefix them.

> +	if (spi->chip_select >= spi->master->num_chipselect) {
> +		dev_err(controller->dev, "invalid chip_select %d\n",
> +			spi->chip_select);
> +		return -EINVAL;
> +	}

The core does this prior to allowing the slave to be registered at all.

> +
> +	if (spi->max_speed_hz > controller->max_speed_hz) {
> +		dev_err(controller->dev, "invalid max_speed_hz %d\n",
> +			spi->max_speed_hz);
> +		return -EINVAL;
> +	}

The core will check this for you if you set master->max_speed_hz.

> +#ifdef CONFIG_PM_RUNTIME
> +static int spi_qup_pm_suspend_runtime(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +	u32 config;
> +
> +	/* Enable clocks auto gaiting */
> +	config = readl(controller->base + QUP_CONFIG);
> +	config |= QUP_CLOCK_AUTO_GATE;
> +	writel_relaxed(config, controller->base + QUP_CONFIG);
> +	return 0;
> +}

Why not just enable this all the time?  I'd have expected some clock API
calls here similar to those in the main suspend and resume paths.

> +MODULE_VERSION("0.4");

Don't bother doing this, nobody will ever keep updating the version
number - the kernel version should be enough.

--rStesqTWVLwTUuyd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBM2uAAoJELSic+t+oim9qhcP/Rdo0N7EoF57G2cLQydpX6A2
1xJKoDBKry+n4asw95WNYmdilxHhFLhbEocJeq8w0y/IZW036nUyK/KIGcU6cc6E
XA8E2vc9df9zV6PK2E+KAgpSssDvchwtVx9f/sRPcT7EbO5si+XIJtESbK46RGnX
roULrwTRpWklaihOhxs215qEt9NRJ3UwuDn/7IzSF/U1zK8kJjDWAnBEpuGIKcHy
UCpBa2PA3+g9FhUXpxz7C8NaDJmFRtqPF+A6TjymV9VKvEbrU+vpFR0MohL+K4gO
Wp+FP1V6UA+4DzeiTMctx3AlODfJJukm0AwAathqz5USJkT8CjWI6WHl+HI89WfU
P/gUGV32+zj3otoOP9ohlWnhyI8sFH1HIyz+ctLtY2ZxKA3Tq4iKui/4F3WKTzzA
mDmP5Iixtog+OCbTuzl7KJjAfMzmgGRNlwO0GFl5GE4KOyMmM7NA5uB7avmnbQP0
vbODqhNO02LRLAoAUpl6KE7mNeMU7bJTiB7YQlXdQR8/4vXogjoQXlgMMQnSjL5n
uYdUhewbqjkjK86aaGMdVXBnujQ8hKfWJj3ngbNN7QsFeizmdFaQ+ltAUcouqh5/
q26jW5WzPO3cU8mtYyzBx86n/n/8VpTsKXchO0AS9Lc6IfsQWRm+gZpeB94LkiMA
UT3shcez0enjE169bqts
=626M
-----END PGP SIGNATURE-----

--rStesqTWVLwTUuyd--
