Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3GRKnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:43:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58136 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3GRKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:43:00 -0400
Date: Thu, 18 Jul 2013 11:42:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718104233.GG22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cMRp6r1K6JdiUiOM"
Content-Disposition: inline
In-Reply-To: <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cMRp6r1K6JdiUiOM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 03:31:26PM +0530, Sourav Poddar wrote:

> QSPI is a kind of spi module that allows single,
> dual and quad read access to external spi devices. The module
> has a memory mapped interface which provide direct interface
> for accessing data form external spi devices.

Have you seen the ongoing thread about SPI buses with extra data lines?
How does this driver fit in with that?

> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_SPI_OCTEON)		+= spi-octeon.o
>  obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi-omap-uwire.o
>  obj-$(CONFIG_SPI_OMAP_100K)		+= spi-omap-100k.o
>  obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
> +obj-$(CONFIG_QSPI_DRA7xxx)              += spi-ti-qspi.o
>  obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
>  obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
>  obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o

Please use SPI_ like the other drivers.

> +static int ti_qspi_prepare_xfer(struct spi_master *master)
> +{
> +	struct ti_qspi *qspi = spi_master_get_devdata(master);
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(qspi->dev);
> +	if (ret < 0) {
> +		dev_err(qspi->dev, "pm_runtime_get_sync() failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}

This is a very common pattern, it should probably be factored out into
the core, probably not even as ops but rather as an actual feature.

> +	list_for_each_entry(t, &m->transfers, transfer_list) {
> +		qspi->cmd |= QSPI_WLEN(t->bits_per_word);
> +		qspi->cmd |= QSPI_WC_CMD_INT_EN;
> +
> +		ret = qspi_transfer_msg(qspi, t);
> +		if (ret) {
> +			dev_dbg(qspi->dev, "transfer message failed\n");
> +			return -EINVAL;
> +		}
> +
> +		m->actual_length += t->len;
> +
> +		if (list_is_last(&t->transfer_list, &m->transfers))
> +			goto out;
> +	}

The use of list_is_last() here is *realy* strange - what's going on
there?

> +static irqreturn_t ti_qspi_isr(int irq, void *dev_id)
> +{
> +	struct ti_qspi *qspi = dev_id;
> +	u16 mask, stat;
> +
> +	irqreturn_t ret = IRQ_HANDLED;
> +
> +	spin_lock(&qspi->lock);
> +
> +	stat = ti_qspi_readl(qspi, QSPI_SPI_STATUS_REG);
> +	mask = ti_qspi_readl(qspi, QSPI_INTR_ENABLE_SET_REG);
> +
> +	if (stat && mask)
> +		ret = IRQ_WAKE_THREAD;
> +
> +	spin_unlock(&qspi->lock);
> +
> +	return ret;

According to the above code we might interrupt for masked events...
that's a bit worrying isn't it?

> +	ret = devm_request_threaded_irq(&pdev->dev, irq, ti_qspi_isr,
> +			ti_qspi_threaded_isr, IRQF_NO_SUSPEND | IRQF_ONESHOT,
> +			dev_name(&pdev->dev), qspi);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
> +				irq);
> +		goto free_master;
> +	}

Standard question about devm_request_threaded_irq() - how can we be
certain it's safe to use during removal?

--cMRp6r1K6JdiUiOM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR58aWAAoJELSic+t+oim9xJ4QAJm/Wqlsli/tSWF94XdIAfpk
MXFm8VC9SYXBEsQKcsCeUddwOKlcnjRXOXv7KDPuvnfb8jmolCu0uy4HMSidMPgX
1DE/1JwZv6A/OOKjJRM98qNdn7o06Cjv0Yra61ebxpDljGxlFegUSIo1Ey5PRLiN
GhzJsjKunkVmrYDbUCSYUUJlZVykLX9s4ab1Y6XjCuz3lQmwikkQNrzMbESOX7gC
ctZbHTB+L056egqEI+h4Pe9heAUnSmD/9N/3XIDemervD3a0lD0SNL06UNaMJe/i
vvW4ISIzg/tt337nYiRE/BIrJc9O5hRhp0w02v+053uq0fQ+/d83UuPmrOf/xiuI
HMs4CdDaHY7XiRMwZB4IJYhBqh9n/wL5Zy8iNoM1BS5tuZFz6tgf0JulpghfttLj
2i/TQqtt8jrLxiq8WF4sjMqZSeF+GaX2gFegyxaC45YiJyfkwEsub3Fz9tIY+vot
KpsBJfrCWPNIR4YbLX4EszECFwuFpO/iF0iHDA9bo3rZH4+Inb0G589PfLmPFc+i
1Ksb50/G55/GPin784pUZzGdQ2OAL4BZLCmgdqIZPtWMIC3+b01+u7a4YsvrqJ8g
Ue7Af2Y3oe/ONoRuXO3wCxNhXug0GImaBx2fcWZRM8sR9kHklM0dVryC6Ghj0602
sXM6FFLI5bTZvvI7LFLC
=li9c
-----END PGP SIGNATURE-----

--cMRp6r1K6JdiUiOM--
