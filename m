Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbaGDSdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:33:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47240 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaGDSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:33:16 -0400
Date: Fri, 4 Jul 2014 19:32:49 +0100
From: Mark Brown <broonie@kernel.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20140704183249.GC14896@sirena.org.uk>
References: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com>
 <1404176639-3315-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <1404176639-3315-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: This bag is recyclable.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] spi: add driver for Rockchip RK3xxx SoCs
 integrated SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 01, 2014 at 09:03:59AM +0800, addy ke wrote:
> In order to facilitate understanding, rockchip SPI controller IP design
> looks similar in its registers to designware. But IC implementation
> is different from designware, So we need a dedicated driver for Rockchip
> RK3XXX SoCs integrated SPI. The main differences:

This looks good overall, a nice clean driver.  I've applied it but there
are a few small issues that need fixing up which I've noted below, can
you please send followup patches dealing with these?

> +	 * static void spi_set_cs(struct spi_device *spi, bool enable)
> +	 * {
> +	 *		if (spi->mode & SPI_CS_HIGH)
> +	 *			enable = !enable;
> +	 *
> +	 *		if (spi->cs_gpio >= 0)
> +	 *			gpio_set_value(spi->cs_gpio, !enable);
> +	 *		else if (spi->master->set_cs)
> +	 *		spi->master->set_cs(spi, !enable);
> +	 * }
> +	 *
> +	 * Note: enable(rockchip_spi_set_cs) = !enable(spi_set_cs)
> +	 */

So, the point here is that chip select is an active low signal by
default which means that if chip select is asserted we have a low logic
level and the parameter means "asserted" not "logic level for the
output".  It doesn't really matter but it might be clearer to say so
directly.

> +	if (spi->mode & SPI_CS_HIGH) {
> +		dev_err(rs->dev, "spi_cs_hign: not support\n");
> +		return -EINVAL;

Typo here (high).

> +static int rockchip_spi_unprepare_message(struct spi_master *master,
> +		struct spi_message *msg)
> +{
> +	unsigned long flags;
> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
> +
> +	spin_lock_irqsave(&rs->lock, flags);
> +
> +	if (rs->use_dma) {
> +		if (rs->state & RXBUSY) {
> +			dmaengine_terminate_all(rs->dma_rx.ch);
> +			flush_fifo(rs);
> +		}
> +
> +		if (rs->state & TXBUSY)
> +			dmaengine_terminate_all(rs->dma_tx.ch);
> +	}

This initially looks wrong - the DMA should all be quiesced by the time
that we get to unpreparing the hardware, otherwise the transfer might be
ongoing while the chip select is deasserted.  However this is really
just error handling in case something went wrong which is sensible and
reasonable, a comment explaining this would help so can you please send
a followup patch adding one.

The error handling here is actually a good point - we should probably
add a callback for the core to use when it times out since the issue
also applies if there are further transactions queued with the hardware.
I'll look into that later unless someone does it first.

> +	/* Delay until the FIFO data completely */
> +	if (xfer->tx_buf)
> +		xfer->delay_usecs
> +			= rs->fifo_len * rs->bpw * 1000000 / rs->speed;

The driver shouldn't be doing this, if it needs a delay it needs to
implement it itself.  delay_usecs can be set by devices if they need a
delay between transfers, it should be in addition to the time taken for
the transfer to complete.

Please send a followup patch fixing this.

> +static bool rockchip_spi_can_dma(struct spi_master *master,
> +		struct spi_device *spi,
> +		struct spi_transfer *xfer)
> +{
> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
> +
> +	return (xfer->len > rs->fifo_len);
> +}

We should factor this out into the core as well, just let the driver set
the minimum size for DMA since it's such a common pattern.  I'll look
into this as well.

> +	master = spi_alloc_master(&pdev->dev, sizeof(struct rockchip_spi));
> +	if (!master) {
> +		dev_err(&pdev->dev, "No memory for spi_master\n");
> +		return -ENOMEM;
> +	}

No need to print an error message - OOM messags from the memory
management subsystem are already noisy enough as it is.

> +	dev_info(&pdev->dev, "Rockchip SPI controller initialized\n");

Please send a followup patch removing this, it's not really adding
anything and there's core debug messages that can be enabled - usually
these prints are done when there is some information that has been read
back from the hardware (eg, IP revisions).

> +static const struct of_device_id rockchip_spi_dt_match[] = {
> +	{ .compatible = "rockchip,rk3066-spi", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rockchip_spi_dt_match);

Your DT binding defined some additional compatible strings, please add
those to the driver.

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtvNOAAoJELSic+t+oim9AZ0QAJTDMzcAA9zy8yPpNZCO/3qs
/60RdNNIAbrqWO2X4nl3ihEoCHflUtf0LgEhKhubvXSS21bVG0056Q6Bba69YaL6
4Z7DgBdHJ3Hx2h1HRZLtpXztJcd5hZa3+7mePGWE0ucXeyFbnTTpr7fEvyl3In71
5MapcJhM+rcFrOAbBCbMrBP89WVHCH1tK04NExPRivM8M3lAuJpDzIm93tbo8DMP
dYnvMYH3X0q4+qGY9kMXAD5pK5l6yCk/DGg9xcwBm4hzTkunQq7TniUo3xmsl+qt
0Fo8wSWk+wTnIJ0YRCwEwEzxiffY6PjroCAji4NY6CuVyuuLS1rCTiWcNWT0CgRc
8T7Kmv+u/p9OC78mKRdauhlCMgjMxY69X6Nb6swd8+hO0wAsPtC4OU+7GFnEVrEu
q35hpYz+tk/thx0JGV9QAfD37O/0IEeRq91ZVXBJJUaLhpj+3r5Y5r4vMtbAvHVX
ShVBCUXIQVOXrrkqFHKzgl9ZNmONOxHaee46/HrMIbUAn4Q0G5li9CSce0HerwFG
vqpoB40CYcETpsk3wc32aPym+1DsjjmaWNYkkpAyd6wzITaX7x+reZmKOSCVdYDa
itL+dUu2AYunV9qtmKc88N6eQ3QQYKo7QPiF2diB35gvmgxWhGAFytRzFtCwytgI
aS3y/2XspxVDHGu3epL0
=ZtBZ
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
