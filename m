Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaDCVaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:30:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50933 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaDCVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:30:06 -0400
Date: Thu, 3 Apr 2014 22:29:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, michal.simek@xilinx.com, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, harinik@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Message-ID: <20140403212940.GY14763@sirena.org.uk>
References: <1396544587-10876-1-git-send-email-punnaia@xilinx.com>
 <203181a5-626f-437e-8efe-983a9d78ec5d@AM1EHSMHS017.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2MC+DK0smzICZJ/6"
Content-Disposition: inline
In-Reply-To: <203181a5-626f-437e-8efe-983a9d78ec5d@AM1EHSMHS017.ehs.local>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] SPI: Add support for Zynq Quad SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2MC+DK0smzICZJ/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 10:33:07PM +0530, Punnaiah Choudary Kalluri wrote:

Overall this looks fairly good, there are a few issues that need to be
looked at but they're not too invasive.  Please also check for coding
style issues, quite a few spaces before commas for example.

> +/*
> + * The modebits configurable by the driver to make the SPI support different
> + * data formats
> + */
> +#define MODEBITS			(SPI_CPOL | SPI_CPHA)

This should be namespaced and seems generally useful - please add it to
the header if there's no suitable definition already.

> +/**
> + * zynq_qspi_copy_read_data - Copy data to RX buffer
> + * @xqspi:	Pointer to the zynq_qspi structure
> + * @data:	The 32 bit variable where data is stored
> + * @size:	Number of bytes to be copied from data to RX buffer
> + */
> +static void zynq_qspi_copy_read_data(struct zynq_qspi *xqspi, u32 data, u8 size)
> +{
> +	if (xqspi->rxbuf) {
> +		memcpy(xqspi->rxbuf, ((u8 *) &data) + 4 - size, size);
> +		xqspi->rxbuf += size;
> +	}
> +	xqspi->bytes_to_receive -= size;
> +}

Does this and the write function really need to be a separate function -
it's trivial and used once?  It's probably more beneficial to split out
some of the more complex logic later on that's causing the indentation
to get too deep.

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
> +	clk_enable(xqspi->devclk);
> +	clk_enable(xqspi->aperclk);

Not clk_prepare_enable()?  You need to check for errors too.

> +static int zynq_qspi_setup_transfer(struct spi_device *qspi,
> +				    struct spi_transfer *transfer)
> +{
> +	struct zynq_qspi *xqspi = spi_master_get_devdata(qspi->master);
> +	u32 config_reg, req_hz, baud_rate_val = 0;
> +
> +	if (transfer)
> +		req_hz = transfer->speed_hz;
> +	else
> +		req_hz = qspi->max_speed_hz;

Why would a transfer be being set up without a transfer being provided?

> +/**
> + * zynq_qspi_setup - Configure the QSPI controller
> + * @qspi:	Pointer to the spi_device structure
> + *
> + * Sets the operational mode of QSPI controller for the next QSPI transfer, baud
> + * rate and divisor value to setup the requested qspi clock.
> + *
> + * Return:	0 on success and error value on failure
> + */
> +static int zynq_qspi_setup(struct spi_device *qspi)
> +{
> +	if (qspi->master->busy)
> +		return -EBUSY;
> +
> +	return zynq_qspi_setup_transfer(qspi, NULL);
> +}

No, this is broken - you have to support setup() while the hardware is
active.  Just remove this if there's nothing to do and set up on the
transfer.

> +	intr_status = zynq_qspi_read(xqspi, ZYNQ_QSPI_STATUS_OFFSET);
> +	zynq_qspi_write(xqspi, ZYNQ_QSPI_STATUS_OFFSET , intr_status);

Coding style.

> +				if (xqspi->rxbuf) {
> +					(*(u32 *)xqspi->rxbuf) =
> +					zynq_qspi_read(xqspi,
> +						       ZYNQ_QSPI_RXD_OFFSET);
> +					xqspi->rxbuf += 4;

This only works in 4 byte words?  That seems a bit limited.
Alternatively, if it works with smaller sizes (as it appears to) then
isn't this at risk of overflowing buffers?

> +static int __maybe_unused zynq_qspi_suspend(struct device *_dev)
> +{
> +	struct platform_device *pdev = container_of(_dev,
> +			struct platform_device, dev);
> +	struct spi_master *master = platform_get_drvdata(pdev);
> +
> +	spi_master_suspend(master);
> +
> +	zynq_unprepare_transfer_hardware(master);

Why are you unpreparing the hardware - the framework should be doing
that for you if the device is active, if it's not you've got an extra
clock disable here?

> +static int __maybe_unused zynq_qspi_resume(struct device *dev)

This doesn't appear to be calling init_hw() - is it guaranteed that all
the register settings written there are OK after power on?

> +	ret = clk_prepare_enable(xqspi->aperclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to enable APER clock.\n");
> +		goto remove_master;
> +	}
> +
> +	ret = clk_prepare_enable(xqspi->devclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to enable device clock.\n");
> +		goto clk_dis_aper;
> +	}

The driver isn't using runtime_pm or otherwise disabling the clocks when
idle so it looks like the clocks will always be enabled and the
management in prepare and unprepare won't have any practical effect.  I
can see needing at least one of the clocks for setting up the device but
probably either the probe should disable them as it finishes or you
should move the clock enable/disable from prepare/unprepare to runtime
PM.

--2MC+DK0smzICZJ/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPdLAAAoJELSic+t+oim949UP/3fG4WMfvQSJqI/Rz2wNRYN8
Tyq/czx/pr1YC5EqGQcRzTW2hVVojxMRBLU/TRofD3tu6nrV5TTz4i6zsCHYzoBf
kPHwDvV2FmiUYnZsf1jc/aH/9ivHsdyenakJw2WWg7Z50aQuwuDT4aT7ZbicTuNC
nM3MlkdowGOoEF1Z982P0fazYYFuZAEKQdwLyrVIudeTHlB7hTYcHOjYfalcDkrH
QHcznMTb7vyKHNcijrqgNRySJuFbG4J1mpF8Wa5yqnrsfAVd5GmyBVojQURvM1Cb
PQWBklTvwbKWVkDyoQ6uU08h1ED8KWEc6O8hpc9dhPubnj6MZrSySqUWw56Oif8k
pQBUVspq5N44a622torQtseUsZ6SqY/a04YrxeYr1Ok/3//+SNQ21WtwW7VvORwA
vK6y/3gstdXT0LoAnnVL4tETPqucsPgPtMCE/PRwCnySg00RCnFSNvVBnuhldHY+
7xAv2wvS4oqLfn5SvfrAd3HYdV57aolFy3j6j/AJNQLAaxwRXQmkFcr49Hd82A7/
7SnEQHKPSyri+aFFqg5qoG1eOEDnXF8wqHKhoiT9IMY9s5OJXpytSeBsOlIHjJ1A
T8LCSwzqsiG5UdzBeexMgmZiJvFCgZ/+6JC4WJA2D0CWxyGeV2Nq4wvV/d7FPWyA
U7BTNfZU6xybdwv30Flo
=DGOM
-----END PGP SIGNATURE-----

--2MC+DK0smzICZJ/6--
