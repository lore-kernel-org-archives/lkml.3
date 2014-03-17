Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaCQRat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:30:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35038 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaCQRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:30:42 -0400
Date: Mon, 17 Mar 2014 17:30:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, michals@xilinx.com
Message-ID: <20140317173017.GW11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eLx2Oic5rP1+EtIt"
Content-Disposition: inline
In-Reply-To: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eLx2Oic5rP1+EtIt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 17, 2014 at 05:35:36PM +0530, Harini Katakam wrote:

> +	bits_per_word = transfer ?
> +			transfer->bits_per_word : spi->bits_per_word;

This would be a lot more legible without the ternery operator.

> +	if (bits_per_word != 8) {
> +		dev_err(&spi->dev, "%s, unsupported bits per word %x\n",
> +			__func__, spi->bits_per_word);
> +		return -EINVAL;
> +	}

The core will check this for you.

> +static int cdns_spi_setup(struct spi_device *spi)
> +{
> +	if (!spi->max_speed_hz)
> +		return -EINVAL;
> +
> +	if (!spi->bits_per_word)
> +		spi->bits_per_word = 8;

The core does this for you.

> +	return cdns_spi_setup_transfer(spi, NULL);
> +}

It's not clear to me why this has been split into a separate function
and the function will write to the hardware which you're not allowed to
do in setup() if it might affect an ongoing transfer.

> +	intr_status = cdns_spi_read(xspi->regs + CDNS_SPI_ISR_OFFSET);
> +	cdns_spi_write(xspi->regs + CDNS_SPI_ISR_OFFSET, intr_status);
> +
> +	if (intr_status & CDNS_SPI_IXR_MODF_MASK) {
> +		/* Indicate that transfer is completed, the SPI subsystem will
> +		 * identify the error as the remaining bytes to be
> +		 * transferred is non-zero
> +		 */
> +		cdns_spi_write(xspi->regs + CDNS_SPI_IDR_OFFSET,
> +			       CDNS_SPI_IXR_DEFAULT_MASK);
> +		complete(&xspi->done);
> +	} else if (intr_status & CDNS_SPI_IXR_TXOW_MASK) {

What happens if both interrupts are flagged at the same time?

> +		if (xspi->remaining_bytes) {
> +			/* There is more data to send */
> +			cdns_spi_fill_tx_fifo(xspi);
> +		} else {
> +			/* Transfer is completed */
> +			cdns_spi_write(xspi->regs + CDNS_SPI_IDR_OFFSET,
> +				       CDNS_SPI_IXR_DEFAULT_MASK);
> +			complete(&xspi->done);
> +		}
> +	}

I see from further up the file that there are error interrupt states
which might be flagged but these are just being ignored.

> +
> +	return IRQ_HANDLED;

This should only be returned if an interrupt was actually handled - if
the line is shared in some system this will break.

> +	cdns_spi_write(xspi->regs + CDNS_SPI_IER_OFFSET,
> +		       CDNS_SPI_IXR_DEFAULT_MASK);
> +
> +	ret = wait_for_completion_interruptible_timeout(&xspi->done,
> +							CDNS_SPI_TIMEOUT);
> +	if (ret < 1) {

If you return a positive value from transfer_one() the core will wait
for you.

> +static int cdns_prepare_transfer_hardware(struct spi_master *master)
> +{
> +	struct cdns_spi *xspi = spi_master_get_devdata(master);
> +
> +	if (xspi->driver_state != CDNS_SPI_DRIVER_STATE_READY)
> +		return -EINVAL;
> +
> +	cdns_spi_write(xspi->regs + CDNS_SPI_ER_OFFSET,
> +		       CDNS_SPI_ER_ENABLE_MASK);
> +
> +	return 0;
> +}

You probably want to enable the clocks here (and disable them when
unpreparing too).

> +static int cdns_transfer_one_message(struct spi_master *master,
> +				     struct spi_message *msg)
> +{

Just implement transfer_one() and provide a set_cs() operation and most
of this code will go away.

> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		ret = -ENXIO;
> +		dev_err(&pdev->dev, "irq number is negative\n");
> +		goto remove_master;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, irq, cdns_spi_irq,
> +			       0, pdev->name, xspi);
> +	if (ret != 0) {
> +		ret = -ENXIO;
> +		dev_err(&pdev->dev, "request_irq failed\n");
> +		goto remove_master;
> +	}

I'd expect to see something that initialises the hardware prior to
requesting the interrupt, you don't know what state the hardware is in
when the driver takes control.

> +	init_completion(&xspi->done);

This needs to be done prior to the interrupt as well.

> +	ret = of_property_read_u16(pdev->dev.of_node, "num-chip-select",
> +				   &master->num_chipselect);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "couldn't determine num-chip-select\n");
> +		goto clk_dis_all;
> +	}

Is there no reasonable default?

> +	/* Set to default valid value */
> +	xspi->speed_hz = clk_get_rate(xspi->ref_clk) / 4;

The driver should set max_speed_hz as well.

> +	dev_info(&pdev->dev, "at 0x%08X mapped to 0x%08X, irq=%d\n",
> +		 res->start, (u32 __force)xspi->regs, irq);

No need for this, it's just noisy.

> +static int __maybe_unused cdns_spi_suspend(struct device *dev)
> +{

This needs to call spi_master_suspend() as well (and similarly on
resume).

> +	cdns_spi_write(xspi->regs + CDNS_SPI_IDR_OFFSET,
> +		       CDNS_SPI_IXR_DEFAULT_MASK);
> +	complete(&xspi->done);
> +
> +	ctrl_reg = cdns_spi_read(xspi->regs + CDNS_SPI_CR_OFFSET);
> +	ctrl_reg |= CDNS_SPI_CR_SSCTRL_MASK;
> +	cdns_spi_write(xspi->regs + CDNS_SPI_CR_OFFSET, ctrl_reg);

Don't do this, the spi_master_suspend() call will quiesce transfers (or
if open coding it should be doing something similar rather than just
breaking any ongoing transfer).

> +	clk_disable(xspi->ref_clk);
> +	clk_disable(xspi->pclk);

Why not unprepare?

--eLx2Oic5rP1+EtIt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJzEmAAoJELSic+t+oim9wEkP/1P7ScD65qsVH6V2O/QK6doB
c1Xc/IrO6P82LOKM4HwAIFrXmhVO3nVHX+uCvLhg1zoKUshu7W9ATYbGdUg9CE78
X09YE1YplvYu5BsMLeCWE6f5O5hPbLYl0qUON5jfPgBscMEpjIz8agUJDaG0JCCz
GN4Y99To8OCkrGGwaTNaOqyKHk6WiNnj6PetOQuDds8UHAZ/z0ibdLwYsav6Oivb
lh/46HN8RSf4bM/DxCz1QJ+SiFZcMzodMMTZD0I5i1iwz6OL5UZpYixpJeJW8E0g
j8sZifiMb++SyrWQtBgfZuyelY/8G50dMk9Ym8Gik+ZErUViyogWOfMvZndgWDkb
BL68YExorUJFR6VbcOyqkZ1ssMyrkzDaQueI8MQLgyED1mNXdiPVtu7RDmzxiQU2
APmunciPbJx7GQkequ51uZj2gWajDkN8ETwOtKcpilBz5C1hT4/0idmT4FZPo+oj
6wo5M125rcB3JI/5jdxuEDCaQzXwHD3wfjaEWpYf/LlnyhdJi2XDMDWUMjgzd2Ic
AnZkVIp7zi3cPIlKWt7PoojUUnXmU+lxX5h/K3PzAumlDLi+xWvXAfOE7exrvgGD
EtNmrkUnneIu1Lz2klMMBDqL/lTMZpybXVp5xnbV62chFYMA0RNzOt053YH35Jxs
RfwrMlpgQDYW5xvT81qG
=s9A7
-----END PGP SIGNATURE-----

--eLx2Oic5rP1+EtIt--
