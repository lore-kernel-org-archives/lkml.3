Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaBGRMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:12:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38360 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGRMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:12:14 -0500
Date: Fri, 7 Feb 2014 17:12:02 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Message-ID: <20140207171202.GD1757@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 06:57:48PM +0200, Ivan T. Ivanov wrote:

This looks mostly good, there's a few odd things and missing use of
framework features.

> Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> provides a common data path (an output FIFO and an input FIFO)
> for serial peripheral interface (SPI) mini-core. SPI in master mode
> support up to 50MHz, up to four chip selects, and a programmable
> data path from 4 bits to 32 bits; MODE0..3 protocols

The grammar in this and the Kconfig text is a bit garbled, might want to
give it a once over (support -> supports for example).

> +static void spi_qup_deassert_cs(struct spi_qup *controller,
> +				struct spi_qup_device *chip)
> +{


> +	if (chip->mode & SPI_CS_HIGH)
> +		iocontol &= ~mask;
> +	else
> +		iocontol |= mask;

Implement a set_cs() operation and let the core worry about all this
for you as well as saving two implementations.

> +		word = 0;
> +		for (idx = 0; idx < controller->bytes_per_word &&
> +		     controller->tx_bytes < xfer->len; idx++,
> +		     controller->tx_bytes++) {
> +
> +			if (!tx_buf)
> +				continue;

Do you need to set the _MUST_TX flag?

> +	qup_err = readl_relaxed(controller->base + QUP_ERROR_FLAGS);
> +	spi_err = readl_relaxed(controller->base + SPI_ERROR_FLAGS);
> +	opflags = readl_relaxed(controller->base + QUP_OPERATIONAL);
> +
> +	writel_relaxed(qup_err, controller->base + QUP_ERROR_FLAGS);
> +	writel_relaxed(spi_err, controller->base + SPI_ERROR_FLAGS);
> +	writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
> +
> +	if (!xfer)
> +		return IRQ_HANDLED;

Are you sure?  It seems wrong to just ignore interrupts, some comments
would help explain why.

> +static int spi_qup_transfer_do(struct spi_qup *controller,
> +			       struct spi_qup_device *chip,
> +			       struct spi_transfer *xfer)

This looks like a transfer_one() function, please use the framework
features where you can.

> +	if (controller->speed_hz != chip->speed_hz) {
> +		ret = clk_set_rate(controller->cclk, chip->speed_hz);
> +		if (ret) {
> +			dev_err(controller->dev, "fail to set frequency %d",
> +				chip->speed_hz);
> +			return -EIO;
> +		}
> +	}

Is calling into the clock framework really so expensive that we need to
avoid doing it?  You also shouldn't be interacting with the hardware in
setup().

> +	if (chip->bits_per_word <= 8)
> +		controller->bytes_per_word = 1;
> +	else if (chip->bits_per_word <= 16)
> +		controller->bytes_per_word = 2;
> +	else
> +		controller->bytes_per_word = 4;

This looks like a switch statement, and looking at the above it's not
clear that the device actually supports anything other than whole bytes.
I'm not sure what that would mean from an API point of view.

> +static int spi_qup_transfer_one(struct spi_master *master,
> +				struct spi_message *msg)
> +{

This entire function can be removed, the core can do it for you.

> +	if (of_property_read_u32(dev->of_node, "spi-max-frequency", &max_freq))
> +		max_freq = 19200000;
> +
> +	if (!max_freq) {
> +		dev_err(dev, "invalid clock frequency %d\n", max_freq);
> +		return -ENXIO;
> +	}
> +
> +	ret = clk_set_rate(cclk, max_freq);
> +	if (ret)
> +		dev_warn(dev, "fail to set SPI frequency %d\n", max_freq);

You set the clock rate per transfer so why bother setting it here,
perhaps we support the rate the devices request but not this maximum
rate?

> +	master->num_chipselect = SPI_NUM_CHIPSELECTS;
> +	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);

Are you *sure* the device supports anything other than whole bytes?

> +	ret = devm_spi_register_master(dev, master);
> +	if (!ret) {
> +		pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
> +		pm_runtime_use_autosuspend(dev);
> +		pm_runtime_set_active(dev);
> +		pm_runtime_enable(dev);
> +		return ret;
> +	}

This is really unclearly written, the success case looks like error
handling.

> +#ifdef CONFIG_PM_RUNTIME
> +static int spi_qup_pm_suspend_runtime(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +
> +	disable_irq(controller->irq);

Why do you need to disable the interrupt?  Will the hardware generate
spurious interrupts, if so some documentation is in order.

> +static int spi_qup_pm_resume_runtime(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +
> +	clk_prepare_enable(controller->cclk);
> +	clk_prepare_enable(controller->iclk);
> +	enable_irq(controller->irq);

No error checking here...

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9RPfAAoJELSic+t+oim9C1IP/jkaeqsJ8MiBedYpgVpTKx6O
hIE8EqUN0e3HrSqkYjc80EsrnBuvVu+kT2L5Hpi3eWZAqmKYUyThZv12UnPhA5xs
xFgO91CCmeud7V7YwfB5b+5BCjrhY+lBLuE0ZiHFdThyqykPH7oBAS2YPrYxZJJ4
cNTXkSSV5zpJOu81Sx12RCjFPtdYoJEbLrOav733QAtSesODb6fkiXB+VglygtPd
Ri0m6LDKqnz5wzF7oyaE/Ik+4jk6opc4HES5/aCm6rNdffvElEYx/2NdqPEtSXUV
Udbp6gVvSIypBb1QgbHExBICYJ/hu4qZrxN9e6LHiiwW0XwQc2Gss8CLvFrTSmLi
zPO6Ks5ZQ+AZ3uny46O/Zt27rL1EdhO3Ff8aSvr6epHPBaQjIvgJ95On1elSrOJs
Ih8S1HpfO7e10uRiQsMeIxKXtB9cMUxftWhKyTgdO823HTgl3aQO01v3VfkuCamO
bozUKmrsHK5WBSO2z57ZmYlLgs35Yw8o/0/MWf1tpbO6YWNQ8KI21W44DX+49MQr
xfQZxPU26LaA3mfjV4Vnj7TKBqdx3E7inucHA/CagefuCN/OMFcouDaQLNNzdNlk
k02Se18c/HnPJcF2/L6VQMSWgfO9DnLQhtFw1arVodRog3LA1gu1j2ejMu87UlKv
oZ6iDmN3GXZKj05thder
=APuf
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
