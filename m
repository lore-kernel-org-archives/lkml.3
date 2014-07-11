Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaGKNj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:39:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60259 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaGKNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:39:22 -0400
Date: Fri, 11 Jul 2014 14:38:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dwmw2@infradead.org,
        computersforpeace@gmail.com, marex@denx.de,
        artem.bityutskiy@linux.intel.com, geert+renesas@linux-m68k.org,
        s.hauer@pengutronix.de, jg1.han@samsung.com, sourav.poddar@ti.com,
        michals@xilinx.com, punnaia@xilinx.com, harinikatakamlinux@gmail.com
Message-ID: <20140711133841.GU30458@sirena.org.uk>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
 <1404982207-4707-2-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTzoGrkn2AhIv4sC"
Content-Disposition: inline
In-Reply-To: <1404982207-4707-2-git-send-email-harinik@xilinx.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.32
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wTzoGrkn2AhIv4sC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 10, 2014 at 02:20:06PM +0530, Harini Katakam wrote:

> This patch adds support for QSPI controller used by Zynq.

The driver looks pretty clean but there are a couple of issues below,
including a little bit more of the flash specifics.

> +static void zynq_qspi_chipselect(struct spi_device *qspi, bool is_high)
> +{
> +	struct zynq_qspi *xqspi = spi_master_get_devdata(qspi->master);
> +	u32 config_reg;
> +
> +	config_reg = zynq_qspi_read(xqspi, ZYNQ_QSPI_CONFIG_OFFSET);
> +
> +	/* Select upper/lower page before asserting CS */
> +	if (xqspi->is_stacked) {
> +		u32 lqspi_cfg_reg;

Like with the dual and quad mode stuff this looks very much like it's
specific to flash rather than something that applies to a generic SPI
driver.  However it does look like it's a generic SPI device which could
be used in other applications which makes things a bit tricky.  We don't
have a really good answer for this right now unfortunately, probably we
need some sort of special interface between the SPI and flash subsystems
to allow flash to use the flash specific stuff.

For use as a generic SPI device what I'd suggest is stripping out the
flash specifics, merging the rest of the support and then considering
the flash specifics separately.

> +/**
> + * zynq_prepare_transfer_hardware - Prepares hardware for transfer.
> + * @master:	Pointer to the spi_master structure which provides
> + *		information about the controller.
> + *
> + * This function enables SPI master controller.
> + *
> + * Return:	Always 0
> + */
> +static int zynq_prepare_transfer_hardware(struct spi_master *master)
> +{
> +	struct zynq_qspi *xqspi = spi_master_get_devdata(master);
> +
> +	zynq_qspi_config_clock_mode(master->cur_msg->spi);

The clock mode needs to be (and is) configured per transfer so I'd
expect it's possible to remove this call.

> +	ret = clk_prepare_enable(xqspi->refclk);
> +	if (ret) {
> +		dev_err(dev, "Cannot enable device clock.\n");

It's better to display the error code.

> +		clk_disable(xqspi->pclk);

This needs to be disable_unprepare().

> +static SIMPLE_DEV_PM_OPS(zynq_qspi_dev_pm_ops, zynq_qspi_suspend,
> +			 zynq_qspi_resume);

It would be better to also implement runtime PM support to disable the
clocks while the device is idle as well, that will save a small amount
of power while the device isn't doing anything.

--wTzoGrkn2AhIv4sC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTv+jeAAoJELSic+t+oim9c5YP/isvTt4YtOpSJueHnN+4yHG5
KJk8F4WFwUypcOlD1NvmBe7jijRijeJV49+EqWIfrWHC4uM3HLZY6I1f3yPF4a7S
rG77XcKkoRPuOdF5z+PwoUgeD7CwroVF2iiDzc9L4jFLhsTfqN43yjmqEfI6VgNJ
F6eMi4yfGyPtdMTQkHRJea76PL6Oc8sVe1+BSZf6nLLv3YhnZriaYgE55ZAug2Wk
iEiDHj9oc1QUU1MsUr43NpL4WwwHHsplSVPs3uQZYASQ9rnzgJMOS8Q+TD177rKb
Yo24rwMBTJiq3HInh6uHfZVUfg17EW5KAg3sKsZF/kY3dCQD0xTpKfriO74PGAXM
dGiBekjKN+V/+XJb1+4ePgbsL3QIS7m1Y447YhTQe2AG6aMKLW/pp64O7K1Tc16s
zF72dSVb0FAa7p8dixNkAMGJ53bL2in8qRtBolz5l/KJdqm8mBqUyPh9vrKi+fm2
woRyWDG0HJ2Pf3HV+BAjLpZep3Q/tbeWWg6fvbn3mFL3qME0WEF8IGIzM0LYUgXn
b1O7fri9Y15veNqh3QEZzK4pCnRa3OHerc8kTCklkERpzhlv0j44kZXVjKumAYT3
0r33ZYA4zKe8GiGITBfs73RuYH1WHt/idbYqiZl2CK0O7fWS4x8ISR1LH2nMKGyU
OoW4OW3CwDQQOP5p1G/D
=dITe
-----END PGP SIGNATURE-----

--wTzoGrkn2AhIv4sC--
