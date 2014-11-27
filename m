Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaK0NBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:01:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40813 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaK0NBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:01:19 -0500
Date: Thu, 27 Nov 2014 12:59:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141127125904.GV7712@sirena.org.uk>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WRti+3vh3AAwVLXR"
Content-Disposition: inline
In-Reply-To: <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] spi: Add new driver for STMicroelectronics' SPI
 Controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WRti+3vh3AAwVLXR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 11:43:53AM +0000, Lee Jones wrote:

> +config SPI_ST
> +	tristate "STMicroelectronics SPI SSC-based driver"

Please select a more specific symbol, I bet ST already have other sPI
controllers.  Based on the descripton SPI_ST_SSC might work.

> +	depends on ARCH_STI

Please add an || COMPILE_TEST unless there's a good reason not to,
there's no obvious one.  You may have an OF dependency though if the
functions you call aren't stubbed, I've not checked.

> +struct spi_st {
> +	/* SSC SPI Controller */
> +	struct spi_bitbang	bitbang;

Is there a good reason for using bitbang over the core transmit_one()
interface?  The operations are basically the same but more modern and
the functionality is more discoverable.

> +static void spi_st_gpio_chipselect(struct spi_device *spi, int is_active)
> +{
> +	int cs =3D spi->cs_gpio;
> +	int out;
> +
> +	if (cs =3D=3D -ENOENT)
> +		return;
> +
> +	out =3D (spi->mode & SPI_CS_HIGH) ? is_active : !is_active;
> +	gpio_set_value(cs, out);

The core can handle GPIO chip selects automatically.

> +static int spi_st_setup_transfer(struct spi_device *spi,
> +				 struct spi_transfer *t)
> +{
> +	struct spi_st *spi_st =3D spi_master_get_devdata(spi->master);
> +	u32 spi_st_clk, sscbrg, var, hz;
> +	u8 bits_per_word;
> +
> +	bits_per_word 	=3D t ? t->bits_per_word	: spi->bits_per_word;
> +	hz		=3D t ? t->speed_hz	: spi->max_speed_hz;

Please avoid the ternery operator; in this case the core should already
be ensuring that these parameters are configured on every transfer.

> +	/* Actually, can probably support 2-16 without any other changees */
> +	if (bits_per_word !=3D 8 && bits_per_word !=3D 16) {
> +		dev_err(&spi->dev, "unsupported bits_per_word %d\n",
> +			bits_per_word);
> +		return -EINVAL;
> +	}

Set bits_per_word_mask and the core will do this.

> +	} else if (spi_st->bits_per_word =3D=3D 8 && !(t->len & 0x1)) {
> +		/*
> +		 * If transfer is even-length, and 8 bits-per-word, then
> +		 * implement as half-length 16 bits-per-word transfer
> +		 */
> +		spi_st->bytes_per_word =3D 2;
> +		spi_st->words_remaining =3D t->len/2;
> +
> +		/* Set SSC_CTL to 16 bits-per-word */
> +		ctl =3D readl_relaxed(spi_st->base + SSC_CTL);
> +		writel_relaxed((ctl | 0xf), spi_st->base + SSC_CTL);
> +
> +		readl_relaxed(spi_st->base + SSC_RBUF);

No byte swapping issues here?

> +	init_completion(&spi_st->done);

reinit_completion().

> +	/* Wait for transfer to complete */
> +	wait_for_completion(&spi_st->done);

Should have a timeout of some kind, if you use transfer_one() it'll
provide one.

> +	pm_runtime_put(spi_st->dev);

The core can do runtime PM for you.

> +	printk("LEE: %s: %s()[%d]: Probing\n", __FILE__, __func__, __LINE__);

Tsk.

> +	spi_st->clk =3D of_clk_get_by_name(np, "ssc");
> +	if (IS_ERR(spi_st->clk)) {
> +		dev_err(&pdev->dev, "Unable to request clock\n");
> +		ret =3D PTR_ERR(spi_st->clk);
> +		goto free_master;
> +	}

Why is this of_get_clk_by_name() and not just devm_clk_get()?

> +	/* Disable I2C and Reset SSC */
> +	writel_relaxed(0x0, spi_st->base + SSC_I2C);
> +	var =3D readw(spi_st->base + SSC_CTL);
> +	var |=3D SSC_CTL_SR;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);
> +
> +	udelay(1);
> +	var =3D readl_relaxed(spi_st->base + SSC_CTL);
> +	var &=3D ~SSC_CTL_SR;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);
> +
> +	/* Set SSC into slave mode before reconfiguring PIO pins */
> +	var =3D readl_relaxed(spi_st->base + SSC_CTL);
> +	var &=3D ~SSC_CTL_MS;
> +	writel_relaxed(var, spi_st->base + SSC_CTL);

We requested the interrupt before putting the hardware into a known good
state - it'd be safer to do things the other way around.

> +	dev_info(&pdev->dev, "registered SPI Bus %d\n", master->bus_num);

This is just noise, remove it.

> +	/* by default the device is on */
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);

You should do this before registering the device so that we don't get
confused about runtime PM if we start using the device immediately.

> +#ifdef CONFIG_PM_SLEEP
> +static int spi_st_suspend(struct device *dev)

> +static SIMPLE_DEV_PM_OPS(spi_st_pm, spi_st_suspend, spi_st_resume);

These look like they should be runtime PM ops too - I'd expect to at
least have the clocks disabled by runtime PM,=20

--WRti+3vh3AAwVLXR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdyAXAAoJECTWi3JdVIfQXHIH/0wng3wh9YTGIObOn5M44p4b
FuFFI2jamNB6XIAd7Cxmx2gERTh+aEsvO23HGuRdkqKB3t/ndEw/CTjaotnUn+Tp
xQBObQuaL6Cn49IxS3Vb+sCqsEEEU8WOZ67hxwvjiH2FBn9MUlUJ1PIfQOLy8NUr
T0Dp88PTxTVGXSngj6hhW5tWfh+yo7D4IzeI8TQIPQENx42C67er2YvfUXuxmLgR
g100FOoalz7P3v9jD5DQjqlZnE0rj2AzYXg7Sp4IKzQoEg63EMBYzybM1DdYMk2E
IdKyDDKcKEYLwveMlvVkr9CZXsTGW/0Scw09DcXlkubmgQNUdq9132LsyHwrOoo=
=rR6Q
-----END PGP SIGNATURE-----

--WRti+3vh3AAwVLXR--
