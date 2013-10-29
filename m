Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3J2S4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:56:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46352 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3J2S43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:56:29 -0400
Date: Tue, 29 Oct 2013 11:56:16 -0700
From: Mark Brown <broonie@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: ning.li@intel.com, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>
Message-ID: <20131029185616.GE20251@sirena.org.uk>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2013 at 11:05:49AM -0700, David Cohen wrote:
> From: Fei Yang <fei.yang@intel.com>
>=20
> This patch adds driver for ssp spi interface on Intel Mid platform.

Is there not any possibility of code sharing with the PXA SSP IP?  It
seems odd that Intel would make a second IP of the same name that's
totally incompatible...  not looked at the register interfaces in detail
but the register names certainly look familiar.

> +	tristate "SSP SPI controller driver for Intel MID platforms (EXPERIMENT=
AL)"
> +	depends on X86_INTEL_MID && SPI_MASTER && INTEL_MID_DMAC
> +	help

Are these all build time dependencies?  There's certainly no need to
depend on SPI_MASTER, all drivers are inside an if SPI_MASTER block.

> +static int ssp_timing_wr;

Why is this a static global?

> +#ifdef DUMP_RX
> +static void dump_trailer(const struct device *dev, char *buf, int len, i=
nt sz)
> +{

Please add this support as a standard feature of the SPI core if it's
useful, there's nothing specific to this driver in it.  Using trace
would probably be better than dumping to the console.

> +	static char msg[MAX_SPI_TRANSFER_SIZE];

Where did that limit come from?

> +static inline u32 is_tx_fifo_empty(struct ssp_drv_context *sspc)
> +{
> +	u32 sssr;
> +	sssr =3D read_SSSR(sspc->ioaddr);
> +	if ((sssr & SSSR_TFL_MASK) || (sssr & SSSR_TNF) =3D=3D 0)

This looks odd, why not sssr & (SSSR_TFL_MASK | SSSR_TNF)?

> +static void flush(struct ssp_drv_context *sspc)
> +{
> +	void *reg =3D sspc->ioaddr;
> +	u32 i =3D 0;
> +
> +	/* If the transmit fifo is not empty, reset the interface. */
> +	if (!is_tx_fifo_empty(sspc)) {
> +		dev_err(&sspc->pdev->dev, "TX FIFO not empty. Reset of SPI IF");
> +		disable_interface(sspc);
> +		return;
> +	}

This isn't a flush then?

> +	dev_dbg(&sspc->pdev->dev, " SSSR=3D%x\r\n", read_SSSR(reg));

No extra space at the start of the message and why is there a \r in
there?  Throughout the driver your log messages have a range of odd
formatting quirks that aren't consistent and don't look like normal
Linux log messages either.

Please also check the severity of your messages, many of them seem too
loud.

> +	while (!is_rx_fifo_empty(sspc) && (i < SPI_FIFO_SIZE + 1)) {
> +		read_SSDR(reg);
> +		i++;
> +	}

What happens if the FIFO doesn't drain?

> +	WARN(i > 0, "%d words flush occured\n", i);

This seems *very* loud for a flush operation...

> +	if (sspc->quirks & QUIRKS_SRAM_ADDITIONAL_CPY) {
> +		sspc->virt_addr_sram_rx =3D ioremap_nocache(SRAM_BASE_ADDR,
> +				2 * MAX_SPI_TRANSFER_SIZE);

This doesn't look terribly clever, it's remapping a hard coded address
rather than getting the address enumerated from a device enumeration
interface.

> +	/* get Data Read/Write address */
> +	ssdr_addr =3D (dma_addr_t)(sspc->paddr + 0x10);

I'm not entirely sure what this does but it looks dodgy...  what's the
cast doing for a start?

> +		/* In Rx direction, TRAIL Bytes are handled by memcpy */

Please don't randomly CAPITALISE words.

> +	rxdesc =3D rxchan->device->device_prep_dma_memcpy
> +		(rxchan,			/* DMA Channel */
> +		sspc->rx_dma,			/* DAR */
> +		ssdr_addr,			/* SAR */
> +		sspc->len_dma_rx,		/* Data Length */
> +		flag);					/* Flag */

What's going on here?  Why is there a DMAed memcpy()?  This doesn't
reflect normal DMA usage in SPI drivers at all, I'd expect to see
dmaengine_prep_ being used.

> +static void int_transfer_complete(struct ssp_drv_context *sspc)
> +{
> +	void *reg =3D sspc->ioaddr;
> +	struct spi_message *msg;
> +	struct device *dev =3D &sspc->pdev->dev;
> +
> +	if (unlikely(sspc->quirks & QUIRKS_USE_PM_QOS))
> +		pm_qos_update_request(&sspc->pm_qos_req,
> +					PM_QOS_DEFAULT_VALUE);

Why is this a quirk and not abstracted away by the PM QoS API on
platforms that don't need it?  I'd also expect these updates to be done
in runtime PM callbacks so that if two transfers follow one another we
don't bounce the Qos up and down.

> +	dev_dbg(dev, "End of transfer. SSSR:%08X\n", read_SSSR(reg));
> +	msg =3D sspc->cur_msg;
> +	if (likely(msg->complete))
> +		msg->complete(msg->context);
> +	complete(&sspc->msg_done);

Remove all these likely()s, they're making the code less clear and seem
vanishingly unlikely to have any practical impact on performance.

> +static void int_transfer_complete_work(struct work_struct *work)
> +{
> +	struct ssp_drv_context *sspc =3D container_of(work,
> +				struct ssp_drv_context, complete_work);
> +
> +	int_transfer_complete(sspc);
> +}

This wrapper function doesn't seem terribly useful...  why not just
inline it into the internal function?

> +	if (status & SSSR_ROR || status & SSSR_TUR) {
> +		dev_err(dev, "--- SPI ROR or TUR occurred : SSSR=3D%x\n",	status);
> +		WARN_ON(1);
> +		if (status & SSSR_ROR)
> +			dev_err(dev, "we have Overrun\n");
> +		if (status & SSSR_TUR)
> +			dev_err(dev, "we have Underrun\n");
> +	}
> +
> +	/* We can fall here when not using DMA mode */
> +	if (!sspc->cur_msg) {
> +		disable_interface(sspc);
> +		disable_triggers(sspc);
> +	}
> +	/* clear status register */
> +	write_SSSR(sspc->clear_sr, reg);

More comments explaining what's going on here would be good...

> +static void poll_transfer(unsigned long data)
> +{
> +	struct ssp_drv_context *sspc =3D (void *)data;
> +
> +	if (sspc->tx) {
> +		while (sspc->tx !=3D sspc->tx_end) {
> +			if (ssp_timing_wr) {
> +				int timeout =3D 100;
> +				/* It is used as debug UART on Tangier. Since
> +				   baud rate =3D 115200, it needs at least 312us
> +				   for one word transferring. Becuase of silicon
> +				   issue, it MUST check SFIFOL here instead of
> +				   TNF. It is the workaround for A0 stepping*/
> +				while (--timeout &&
> +					((read_SFIFOL(sspc->ioaddr)) & 0xFFFF))
> +					udelay(10);
> +			}

This doesn't look like it shouldn't be here at all or should be made
more generic but I can't really tell what it's supposed to do...

> +static void start_bitbanging(struct ssp_drv_context *sspc)
> +{

The SPI core has bitbanging helpers which you don't seem to be using.
However...

> +	/* Bit bang the clock until CSS clears */
> +	while ((sssr & 0x400000) && (count < MAX_BITBANGING_LOOP)) {
> +		write_I2CDATA(0x2, i2c_reg);
> +		udelay(I2C_ACCESS_USDELAY);

=2E..this code is talking about I2C?

> +		udelay(I2C_ACCESS_USDELAY);
> +		write_I2CCTRL(0x01070034, i2c_reg);

This appears to be randomly bashing on an absolute register address.

> +/**
> + * transfer() - Start a SPI transfer
> + * @spi:	Pointer to the spi_device struct
> + * @msg:	Pointer to the spi_message struct
> + */
> +static int transfer(struct spi_device *spi, struct spi_message *msg)

Use of plain transfer() has been deprecated since v3.4, you should at
least be using transfer_one_message().  I've stopped reviewing at this
point since a lot of the rest of the code is replicating stuff that's in
the SPI core and will go away when you update to use the current APIs.

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScATLAAoJELSic+t+oim9Gc4P/jTusS03zoOCXQq2z7jjR37t
sy4stsrg+5hNIAXVVOIvXnXj/gIzaHJDUfUYvk5X5WLkG8DOIlwpqI05IpK3OwbU
R93FtLYRrKXNZa1lVfxTcu6zcq8H4mR/Qb+TWQzs/lfi5/oH7QFA3XIgfpJ0YXEe
1f//jGZ5uRj1Eb75oS7WUOPuACypkDu09K9WsX202qkJcr/tGt0qHqP3kHXtWPMX
S/sPu2EQ8X8VOPf3lhFMV6okfAldTk1Hleor39v7k/TrmuNGcRvTQTRoyTygPZpP
MULhfpSVmk4byR/435xxJALmrK09LhfCxyBIGtUzPWRZiPaz4UtrAxUK1PGCeWFV
nihoRz6XHY05v+/f1F7VyjL/uB4B36gtBscJnqbPIGwb3qmQm0z++j9rKA8qmHcm
k/O4wJBFitTINJk9HFGH2Rgjzijy5Ztf9cN/zEoz6eQqVu5UDBz8WAqdBHbOR4Iz
Tb+TqMc2wHWPh8TXp2igCXf1aO60EbFm9DFYrT98mhSc6k/FoZugPpgzvUPH8abE
dk5VtLJm2QMP015z5t8J6sSkWJgGPl14kQFT10InnBKn+MLdnA9Bm84Q1BQEyEJJ
/U0661vIiMHcTaz2Btxh/aXBTJWE7UBDnHNuiy1Xelu+UO2ajsddK/JnqEIWoJBt
rLVwUPBuSlvW0quy3nBx
=A2Kq
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
