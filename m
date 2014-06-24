Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaFXK4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:56:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55524 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaFXK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:56:43 -0400
Date: Tue, 24 Jun 2014 11:56:25 +0100
From: Mark Brown <broonie@kernel.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com
Message-ID: <20140624105625.GH23300@sirena.org.uk>
References: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
 <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline
In-Reply-To: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: add driver for Rockchip RK3xxx SoCs integrated
 SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 12:07:32PM +0800, addy ke wrote:

> In order to facilitate understanding,rockchip SPI controller IP design looks
> similar in its registers to designware. But IC implementation is different from
> designware, such as dma request line, register offset, register configuration,
> and so on.So we need a dedicated driver for Rockchip RK3XXX SoCs integrated SPI.

Can you be more specific about the differences please?

> +struct rockchip_spi {
> +	struct device			*dev;
> +	struct spi_master		*master;
> +
> +	struct clk				*spiclk;
> +	struct clk				*apb_pclk;
> +
> +	void __iomem			*regs;
> +	int						irq;
> +	/*depth of the FIFO buffer */
> +	u32						fifo_len;
> +	/* max bus freq supported */
> +	u32						max_freq;
> +	u16						bus_num;
> +	/* supported slave numbers */
> +	u16						num_cs;
> +	enum rockchip_ssi_type	type;

The indentation in this struct appears to be all over the place, in
general it's simpler and clearer to not try to align the variable names.

> +static inline void spi_chip_sel(struct rockchip_spi *rs, u16 cs)
> +{
> +	writel_relaxed(1 << cs, rs->regs + ROCKCHIP_SPI_SER);
> +}

There's no clear operation I can see and I'm not seeing a set_cs()
operation provided to the core as I'd expect, this means that chip
select handling doesn't work properly.

> +static void rockchip_spi_hw_init(struct rockchip_spi *rs)
> +{
> +	u32 fifo;
> +
> +	spi_enable_chip(rs, 0);
> +	spi_mask_intr(rs, INT_MASK);
> +
> +	for (fifo = 2; fifo < 32; fifo++) {
> +		writel_relaxed(fifo, rs->regs + ROCKCHIP_SPI_TXFTLR);
> +		if (fifo != readl_relaxed(rs->regs + ROCKCHIP_SPI_TXFTLR))
> +			break;
> +
> +	}
> +	rs->fifo_len = (fifo == 31) ? 0 : fifo;
> +	writel_relaxed(0, rs->regs + ROCKCHIP_SPI_TXFTLR);
> +}

Some more commenting would make it much clearer what this does.

> +static int rockchip_spi_setup(struct spi_device *spi)
> +{
> +	struct rockchip_spi *rs;
> +
> +	rs = spi_master_get_devdata(spi->master);
> +
> +	pm_runtime_get_sync(rs->dev);
> +
> +	if (spi->max_speed_hz > rs->max_freq)
> +		spi->max_speed_hz = rs->max_freq;
> +
> +	pm_runtime_put(rs->dev);

I can't see any reason to runtime enable the hardware here - there's no
interaction with it.

> +static int rockchip_spi_prepare_message(struct spi_master *master,
> +		struct spi_message *msg)
> +{
> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
> +	struct spi_device *spi = msg->spi;
> +
> +	if (spi->chip_select >= rs->num_cs) {
> +		dev_err(rs->dev, "chip_select %d is invalide, max is %d\n",

invalid.

> +static void wait_for_not_busy(struct rockchip_spi *rs)
> +{
> +	u32 status;
> +	unsigned long tmo;
> +	int ms;
> +
> +	ms = rs->len * 8 * 1000 / rs->speed;
> +	ms += 10;
> +
> +	tmo = msecs_to_loops(ms);
> +	do {
> +		status = readl_relaxed(rs->regs + ROCKCHIP_SPI_SR);
> +	} while ((status & SR_BUSY) && tmo--);

This is a potentially long busy wait and there's not much headroom if
the calculations are wrong.

> +
> +	BUG_ON(!tmo);

I'd expect a WARN_ON() at most here.

> +static int wait_for_dma(struct rockchip_spi *rs)
> +{
> +	unsigned long tmo;
> +	int ms;
> +
> +	ms = rs->len * 8 * 1000 / rs->speed;
> +	ms += 10;

10ms probably isn't enough headroom on a loaded system - the scheduler
may take longer than that to run the thread.  It looks like you could
also be using the core timeout code here, return a positive value from
transfer_one() and then call spi_finalize_current_transfer() when done.

> +static int rockchip_spi_transfer_one(struct spi_master *master,
> +		struct spi_device *spi,
> +		struct spi_transfer *xfer)
> +{
> +	int ret = 0;
> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
> +
> +	if (!xfer->tx_buf && !xfer->rx_buf) {
> +		dev_err(rs->dev, "No buffer for transfer\n");
> +		return -EINVAL;
> +	}

Let the core worry about things like this.

> +	rs->speed = xfer->speed_hz?:spi->max_speed_hz;

The core will ensure that the transfer will have the correct speed set.
In general there's a lot of copy values from the transfer into the
driver data, it seems like it'd be simpler to just refer to the original
source of the data.

> +	rs->tx = (void *)xfer->tx_buf;

Why is the driver casting away const here?

> +static irqreturn_t rockchip_spi_irq(int irq, void *data)
> +{
> +	struct rockchip_spi *rs = data;
> +	u32 isr = readl_relaxed(rs->regs + ROCKCHIP_SPI_ISR);
> +
> +	dev_dbg(rs->dev, "isr 0x%x\n", isr);
> +
> +	return IRQ_HANDLED;
> +}

This is completely ignoring the interrupt except for logging it - it'd
be simpler to just not have an interrupt handler, or at least log any
errors that the controller reports.

> +err_register_master:
> +	if (rs->dma_tx.ch)
> +		dma_release_channel(rs->dma_tx.ch);
> +	if (rs->dma_rx.ch)
> +		dma_release_channel(rs->dma_rx.ch);

Is there no managed interface for requesting DMA channels?

> +	if (!pm_runtime_suspended(dev)) {
> +		ret = clk_prepare_enable(rs->apb_pclk);
> +		if (ret < 0)
> +			return ret;
> +		ret = clk_prepare_enable(rs->spiclk);
> +
> +		if (ret < 0) {
> +			clk_disable_unprepare(rs->apb_pclk);
> +			return ret;
> +		}

Funnly line spacing here - I'd expect the second clk_prepare_enable() to
be in the same block as the error handling.

> +	return spi_master_resume(rs->master);

Should disable the clocks if this fails.

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqVlWAAoJELSic+t+oim9Te8P/2B8CKYZE36Y2blH/XcvUygI
9bRm8Gk7c/K6j2HGCuBhE2IE0efs2VuCYXTgSTGMI8lDQf+uoB6OYaNJcFGD3kbm
Qeo/C/vAVbZ0EZor38F62p9Ai0fW5S7jG3gIOBYu3lR4Fci6WrxMvoCmzLcxLgkx
uQxw9rPpDEgvagDBDqIwyFW9cLYiWvGqf8jcXrMiP1nxRq5F0/nj7s2cPJuSAwWp
DctI9+lyXDZkzTekuiDE74oAifJHkTuHD03Ndf36KrVpW2gDnKuJ3WLR5pl4PhYb
b+3/CXSTYHzA5fCYjmJcbkFuXgSpeFZsSmOsexm62OZVkYGE7NA5k9hZsfuRTI2z
IqIdzYA5ie++gtUHxWU4ffCILWyRBlCS5zTOSwxznAMYYeoUcngXz+Uz33Cg1CRe
m5DOB65+g1TvAHEeNlA/2KKZEN0xPNZWz+6m423CCtuwiRQc7V0MZRO2kgv12eM+
Zno8Gdv+eITcXQPFDZ57gxl7ZUm2sboOGJCfDzhJ/ISRtThMMPXAIsXhYIJVLq2O
mrpcuaAs2nFBS95QMVLyt1moHWeVsyP8NqnknNBzm6MrbuMzKj84kUlx/wlmKLsT
5k0qIKuC1lqCag+dEpmw1q9H7B7VJEJ9qWQlX6v6lq7ZRhZYG8hyfsVPvvb5GxsJ
hahSWgO7KNrMtf3xyFXK
=IQAH
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--
