Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3BFKkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:40:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54396 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3BFKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:40:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4] spi: s3c64xx: add gpio quirk for controller
To: Girish K S <girishks2000@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
In-Reply-To: <1360105784-12282-4-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com> <1360105784-12282-4-git-send-email-ks.giri@samsung.com>
Date: Wed, 06 Feb 2013 10:40:00 +0000
Message-Id: <20130206104000.98E803E1510@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Feb 2013 15:09:43 -0800, Girish K S <girishks2000@gmail.com> wrote:
> This patch adds support for spi controllers with
> dedicated clk/miso/mosi/cs pins. It skips the gpio
> parsing and initialization for controllers that
> have dedicated pins.
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>

Instead of making this a quirk, you should use the presence/absense of a
cs-gpios property to determin whether or not a gpio is used to
manipulate the CS signal.

Also, are you certain that you want to make this change? Most SPI
controllers are actually unfriendly in that they insist on deasserting the
CS line if the FIFO runs empty. Does this driver correctly keep the CS
signal asserted when there are multiple transfers in a message?

g.

> ---
>  drivers/spi/spi-s3c64xx.c |   39 +++++++++++++++++++++++++++++++--------
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 90770bd..f06bbee 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -36,6 +36,7 @@
>  
>  #define MAX_SPI_PORTS		3
>  #define S3C64XX_SPI_QUIRK_POLL		(1 << 0)
> +#define S3C64XX_SPI_QUIRK_GPIO		(1 << 1)
>  
>  /* Registers and bit-fields */
>  
> @@ -404,14 +405,16 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
>  		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
>  			/* Deselect the last toggled device */
>  			cs = sdd->tgl_spi->controller_data;
> -			gpio_set_value(cs->line,
> -				spi->mode & SPI_CS_HIGH ? 0 : 1);
> +			if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
> +				gpio_set_value(cs->line,
> +					spi->mode & SPI_CS_HIGH ? 0 : 1);
>  		}
>  		sdd->tgl_spi = NULL;
>  	}
>  
>  	cs = spi->controller_data;
> -	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
> +	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
> +		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
>  
>  	/* Start the signals */
>  	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
> @@ -503,7 +506,8 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
>  	if (sdd->tgl_spi == spi)
>  		sdd->tgl_spi = NULL;
>  
> -	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
> +	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
> +		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
>  
>  	/* Quiese the signals */
>  	writel(S3C64XX_SPI_SLAVE_SIG_INACT,
> @@ -842,7 +846,10 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
> +	/* In case of dedicated cs pin skip the gpio initialization */
> +	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
> +		cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
> +
>  	if (!gpio_is_valid(cs->line)) {
>  		dev_err(&spi->dev, "chip select gpio is not specified or "
>  					"invalid\n");
> @@ -883,7 +890,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
>  		return -ENODEV;
>  	}
>  
> -	if (!spi_get_ctldata(spi)) {
> +	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)) {
>  		err = gpio_request_one(cs->line, GPIOF_OUT_INIT_HIGH,
>  				       dev_name(&spi->dev));
>  		if (err) {
> @@ -892,9 +899,11 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
>  				cs->line, err);
>  			goto err_gpio_req;
>  		}
> -		spi_set_ctldata(spi, cs);
>  	}
>  
> +	if (!spi_get_ctldata(spi))
> +		spi_set_ctldata(spi, cs);
> +
>  	sci = sdd->cntrlr_info;
>  
>  	spin_lock_irqsave(&sdd->lock, flags);
> @@ -979,8 +988,11 @@ err_gpio_req:
>  static void s3c64xx_spi_cleanup(struct spi_device *spi)
>  {
>  	struct s3c64xx_spi_csinfo *cs = spi_get_ctldata(spi);
> +	struct s3c64xx_spi_driver_data *sdd;
> +
> +	sdd = spi_master_get_devdata(spi->master);
>  
> -	if (cs) {
> +	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO) && cs) {
>  		gpio_free(cs->line);
>  		if (spi->dev.of_node)
>  			kfree(cs);
> @@ -1107,6 +1119,13 @@ static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
>  	struct device *dev = &sdd->pdev->dev;
>  	int idx, gpio, ret;
>  
> +	/*
> +	 * If cs is not controlled by gpio, and
> +	 * the SoC uses internal dedicated pins
> +	 */
> +	if (sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)
> +		return 0;
> +
>  	/* find gpios for mosi, miso and clock lines */
>  	for (idx = 0; idx < 3; idx++) {
>  		gpio = of_get_gpio(dev->of_node, idx);
> @@ -1133,6 +1152,10 @@ free_gpio:
>  static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
>  {
>  	unsigned int idx;
> +
> +	if (sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)
> +		return;
> +
>  	for (idx = 0; idx < 3; idx++)
>  		gpio_free(sdd->gpios[idx]);
>  }
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
