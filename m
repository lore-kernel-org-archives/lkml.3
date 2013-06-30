Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3F3QOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:14:55 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43330 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3QOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:14:54 -0400
Date: Sun, 30 Jun 2013 19:13:58 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Message-ID: <20130630161358.GA786@mwesterb-mobl.lan>
References: <201306281143.07615.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281143.07615.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:43:07AM -0700, H Hartley Sweeten wrote:
> This driver supports 16 to 4 bits per work. Set the bits_per_word_mask
> to allows the spi core to handle validation.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/spi/spi-ep93xx.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index c633cd0..93ae7b6 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -272,12 +272,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
>  	struct ep93xx_spi *espi = spi_master_get_devdata(spi->master);
>  	struct ep93xx_spi_chip *chip;
>  
> -	if (spi->bits_per_word < 4 || spi->bits_per_word > 16) {
> -		dev_err(&espi->pdev->dev, "invalid bits per word %d\n",
> -			spi->bits_per_word);
> -		return -EINVAL;
> -	}
> -
>  	chip = spi_get_ctldata(spi);
>  	if (!chip) {
>  		dev_dbg(&espi->pdev->dev, "initial setup for %s\n",
> @@ -341,10 +335,6 @@ static int ep93xx_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>  
>  	/* first validate each transfer */
>  	list_for_each_entry(t, &msg->transfers, transfer_list) {
> -		if (t->bits_per_word) {
> -			if (t->bits_per_word < 4 || t->bits_per_word > 16)
> -				return -EINVAL;
> -		}
>  		if (t->speed_hz && t->speed_hz < espi->min_rate)
>  				return -EINVAL;
>  	}
> @@ -1022,6 +1012,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
>  	master->bus_num = pdev->id;
>  	master->num_chipselect = info->num_chipselect;
>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
> +	master->bits_per_word_mask = 0xfff8;	/* 16 to 4 bits per word */

Please use SPI_BPW_RANGE_MASK(4, 16) here.
