Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaAPTka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:40:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55788 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAPTk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:40:27 -0500
Date: Thu, 16 Jan 2014 19:40:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140116194003.GN17314@sirena.org.uk>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
 <1389892285-11745-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R92lf0Oi2sxyK3LA"
Content-Disposition: inline
In-Reply-To: <1389892285-11745-4-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] spi: sunxi: Add Allwinner A31 SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R92lf0Oi2sxyK3LA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 06:11:24PM +0100, Maxime Ripard wrote:

Looks pretty clean, a few fairly small things below.

> +- clocks: phandle to the clocks feeding the SPI controller. Two are
> +          needed:
> +  - "ahb": the gated AHB parent clock
> +  - "mod": the parent module clock

I guess you should specify that this needs to be done with clock-names
too then?

> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_SPI_SH_HSPI)		+= spi-sh-hspi.o
>  obj-$(CONFIG_SPI_SH_MSIOF)		+= spi-sh-msiof.o
>  obj-$(CONFIG_SPI_SH_SCI)		+= spi-sh-sci.o
>  obj-$(CONFIG_SPI_SIRF)		+= spi-sirf.o
> +obj-$(CONFIG_ARCH_SUNXI)		+= spi-sun6i.o

I would expect a new Kconfig symbol for this.

> +static inline void sun6i_spi_drain_fifo(struct sun6i_spi *sspi, int len)
> +{
> +	u32 reg, cnt;
> +	u8 byte;
> +
> +	/* See how much data are available */

data is available.

> +	while (len--) {
> +		byte = readb(sspi->base_addr + SUN6I_RXDATA_REG);
> +		if (sspi->rx_buf)
> +			*sspi->rx_buf++ = byte;
> +	}

It seems like this hardware is only able to handle bidirectional
operation - this is actually quite common and isn't always as simple as
it is here.  Can I persuade you to put something in the core which
provides dummy data buffers for this case?  I was thinking flags like
must_tx and must_rx or something but didn't get around to this yet.

> +static int sun6i_spi_finish_transfer(struct spi_device *spi,
> +				     struct spi_transfer *tfr,
> +				     bool cs_change)
> +{
> +	struct sun6i_spi *sspi = spi_master_get_devdata(spi->master);
> +
> +	sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
> +
> +	if (tfr->delay_usecs)
> +		udelay(tfr->delay_usecs);

If you implement this using transfer_one() (as you should) the core will
do this for you.

> +	if (status & SUN6I_INT_CTL_RF_OVF) {
> +		sun6i_spi_drain_fifo(sspi, SUN6I_FIFO_DEPTH);
> +		sun6i_spi_write(sspi, SUN6I_INT_STA_REG, SUN6I_INT_CTL_RF_OVF);
> +		return IRQ_HANDLED;
> +	}

This looks like an overflow - a log message would be helpful for users
and you should possibly be flagging an error on the current transfer.

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sspi->base_addr = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!sspi->base_addr) {
> +		dev_err(&pdev->dev, "Unable to remap IO\n");
> +		ret = -ENXIO;
> +		goto err;
> +	}

devm_ioremap_resource() is nicer in that it returns an error and then
you don't need to log either since it's noisy itself.

> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "No spi IRQ specified\n");
> +		ret = -ENXIO;

Don't overwrite the error code.

> +	ret = clk_set_rate(sspi->mclk, 100000000);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't change module clock rate\n");
> +		goto err2;
> +	}

Does this really need to be fatal (or done at all)?  There seems to be
another reasonably flexible divider in the IP and it's more common to
either set this per transfer to something that rounds nicely or just use
the default and rely on the dividers.

> +	ret = clk_prepare_enable(sspi->mclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't enable clock 'ahb spi'\n");
> +		goto err2;
> +	}

I would recommend moving these to runtime PM so the clocks are only
active when the device is actually in use, the core will do the runtime
PM management if you set auto_runtime_pm so it's really easy to
implement.

> +	ret = reset_control_deassert(sspi->rstc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't deassert the device from reset\n");
> +		goto err3;
> +	}
> +
> +	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
> +			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);

Similarly here the IP could be kept in reset when not in use.

--R92lf0Oi2sxyK3LA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2DWPAAoJELSic+t+oim9JgoQAIHWUh4oREDc5EFQGExWxMPq
lHpGUGK6uaTC7hDzeO588fzZbI7XiokExizatJ29pPrllJQcawokRRiJoQyHUYUR
GtLg9+iz6hpX326TeR+XkCkcVxKCK1Q3TmbIFojUZS0irM3MlyEsnMoWUr98QVyN
M4OkZYt/+dYohC6xAB32NV0lVohh/sNgPFvKtg9eoCKfQ0eicZdWjh7aLjB7zZVP
tGFF3uNoeEnDz8ptYxym/yA+WQ7urVQgsHT1yc9lF71qee8U5fjtvdz811HITuR5
BmJLfxW4GPHRNjMgcVo/s4cfkhPnKFDQksM7TNqR11MQksPnBtF7gpHEOKjH0Htw
RJGoRc5mC/UDp72iyqLcvNd0UdbqTlOCXqo9/ZJxKaeFpsZZ+qyTAKz8ittLFIK9
ZmmbkLB13XDJIe7KQwSUBMFSUgz4Wyql0c0I/N8ihD4yOhoOplf5DeRWVvrd8ekU
xvhlVzojKR5p/il3j80JzZ8rnAb6ipSLE1aGAgFSlzuejPotJVo0dwSaapswOTFi
ntpv5dTJ+/ckpBDbG295SL5he7FxEZw5vk90iSpk8ZYG6LC4oJXpZuH3jQzZ8h/N
vZmfUjJwxW4gaNzJ8rF9RmTqeT+i00kGwmzrNmwjm4TDIEqHvQ69pRkr312SMdY5
+GoHyrHeQQcOnLjUU/d4
=Laes
-----END PGP SIGNATURE-----

--R92lf0Oi2sxyK3LA--
