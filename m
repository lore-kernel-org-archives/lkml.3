Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3GIGwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:52:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48063 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3GIGwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:52:07 -0400
Date: Tue, 9 Jul 2013 09:51:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Sourav Poddar <sourav.poddar@ti.com>, <broonie@kernel.org>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130709065143.GC5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
 <1373290980-17883-3-git-send-email-sourav.poddar@ti.com>
 <20130708203330.GA28322@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20130708203330.GA28322@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 08, 2013 at 03:33:30PM -0500, Nishanth Menon wrote:
> > +static inline unsigned long dra7xxx_readl_data(struct dra7xxx_qspi *qs=
pi,
> > +		unsigned long reg, int wlen)
> > +{
> > +	switch (wlen) {
> > +	case 8:
> > +		return readw(qspi->base + reg);
> > +		break;
> > +	case 16:
> > +		return readb(qspi->base + reg);
> > +		break;
> > +	case 32:
> > +		return readl(qspi->base + reg);
> > +		break;
> > +	default:
> > +		return -1;
> > +	}
> > +}
> > +
> > +static inline void dra7xxx_writel_data(struct dra7xxx_qspi *qspi,
> > +		unsigned long val, unsigned long reg, int wlen)
> > +{
> > +	switch (wlen) {
> > +	case 8:
> > +		writew(val, qspi->base + reg);
> > +		break;
> > +	case 16:
> > +		writeb(val, qspi->base + reg);
> > +		break;
> > +	case 32:
> > +		writeb(val, qspi->base + reg);
> > +		break;
> > +	default:
> > +		dev_dbg(qspi->dev, "word lenght out of range");
> > +		break;
> > +	}
> > +}
> Looks like a case to use regmap?
> Dumb q: why cant we use regmap_spi? worst case, you should be able to

read regmap-spi and you'll see why it can't be used in this case.

regmap-spi is for SPI clients who want to read their register map
through SPI commands. This is a driver for the SPI master which has its
registers memory mapped.

> > +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
> > +		struct spi_message *m)
> > +{
> > +	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> > +	struct spi_device *spi =3D m->spi;
> > +	struct spi_transfer *t;
> > +	int status =3D 0;
> > +	int frame_length;
> > +
> > +	/* setup device control reg */
> > +	qspi->dc =3D 0;
> > +
> > +	if (spi->mode & SPI_CPHA)
> > +		qspi->dc |=3D QSPI_CKPHA(spi->chip_select);
> > +	if (spi->mode & SPI_CPOL)
> > +		qspi->dc |=3D QSPI_CKPOL(spi->chip_select);
> > +	if (spi->mode & SPI_CS_HIGH)
> > +		qspi->dc |=3D QSPI_CSPOL(spi->chip_select);
> > +
> > +	frame_length =3D DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
> > +				spi->bits_per_word);
> > +
> > +	frame_length =3D clamp(frame_length, 0, QSPI_FRAME_MAX);
> > +
> > +	/* setup command reg */
> > +	qspi->cmd =3D 0;
> > +	qspi->cmd |=3D QSPI_EN_CS(spi->chip_select);
> > +	qspi->cmd |=3D QSPI_FLEN(frame_length);
> > +
> how does one ensure pm runtime has not disabled clocks in
> background? e.g. long latency between transfers.

because pm_runtime_put*() has not been called ?

There's no way clocks will be gated until we kick the pm autosuspend
timer, which is only done when the transfer is finished.

> > +static irqreturn_t dra7xxx_qspi_isr(int irq, void *dev_id)
> > +{
> > +	struct dra7xxx_qspi *qspi =3D dev_id;
> > +	u16 mask, stat;
> > +
> > +	irqreturn_t ret =3D IRQ_HANDLED;
> > +
> > +	spin_lock(&qspi->lock);
> > +
> what if autosuspend has triggered here? before ISR was scheduled?

how ?

the pm timer hasn't been kicked yet

> > +	stat =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> > +	mask =3D dra7xxx_readl(qspi, QSPI_SPI_CMD_REG);
> > +
> > +	if ((stat & QSPI_WC) && (mask & QSPI_WC_CMD_INT_EN))
> > +		ret =3D IRQ_WAKE_THREAD;
> > +
> > +	spin_unlock(&qspi->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static irqreturn_t dra7xxx_qspi_threaded_isr(int this_irq, void *dev_i=
d)
> > +{
> > +	struct dra7xxx_qspi *qspi =3D dev_id;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&qspi->lock, flags);
> > +
> what if autosuspend has triggered here? before ISR was scheduled?

how ?

pm timer hasn't been kicked yet

> > +	qspi->base =3D devm_ioremap_resource(&pdev->dev, r);
> > +	if (IS_ERR(qspi->base)) {
> > +		ret =3D -ENOMEM;
> > +		goto free_master;
> > +	}
> why not use devm_request_and_ioremap? Lock that region down so that no
> two drivers can manage the same region?

read devm_ioremap_resource() and look at the git log for all the
numerous drivers which were converted to devm_ioremap_resource() to find
the reason.

> > +static struct platform_driver dra7xxx_qspi_driver =3D {
> > +	.probe	=3D dra7xxx_qspi_probe,
> > +	.remove	=3D dra7xxx_qspi_remove,
> > +	.driver =3D {
> > +		.name	=3D "ti,dra7xxx-qspi",
> > +		.owner	=3D THIS_MODULE,
> > +		.of_match_table =3D dra7xxx_qspi_match,
> > +	}
> no need for pm_ops?

+1

> > +};
> > +
> > +module_platform_driver(dra7xxx_qspi_driver);
> > +
> > +MODULE_LICENSE("GPL");
> GPL V2?

+1

> > +MODULE_DESCRIPTION("TI QSPI controller driver");
> MODULE_AUTHOR?

+1

--=20
balbi

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR27L/AAoJEIaOsuA1yqRE1JUQAKYl15ph7O3TsVSPAsOe12eE
qTORaT3XGCQvBax+CvYB/osnJMmEY7Ehd3U6ycVjkNg8w9KufmNFuZ9Us5hv4qTv
HjH6NQG0b/piNuxBf+z1E/khWSO+SQZwp7ntjikG7DiAp58b69l8icn/lzdwq00y
usyuVuquZFlubz15SRlLogW4z+bjFaHh6cSqJUFESYhpD576W16wirxD7ppd0FVy
f6BeyXNZdBp7015xQnByEoC9AVL0xVEgrk3ZQTtpFG+k94OxO26/epvQ7Dkh/Crc
WZcZy2FQA506MIp48mqtPDCg9kswMDSPqZ4FELDllMb0GQMHx4A8hypbOIEtogqd
EvXZuidVrvUHPOeHicdHqZGirHdOoJ5v2QxIW/Vj1e79ztEEF7rIuj2XWXioGlRu
wcpbjohxiybOHij4bi6ujYT43pvWQmkGY891nXpSrr4Br3yFDSGUZxC8a7gT3zYh
yx28DmcuXGTesbcoNNfznbsL76fpviFjxyOU5CDYDH91SW4UnNCJEyRn1tj6YRrz
/My33lQNVw4umCFsS9S2l50U16giDOO4Q3jIzEM+F8hpmXF1Pd673fQhXbrNuPkM
SL6jZlbm5ZXNKP4loOStDz3C+CcXJ4ifIHQTlkKNteeM3k3I2+jCF/+BKgvofZoe
b6RvzDon+TFv5Y+rDdV4
=/lHe
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
