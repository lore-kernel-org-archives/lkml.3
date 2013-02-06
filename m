Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3BFK0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:26:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43529 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3BFK0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:26:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] spi: s3c64xx: modified error interrupt handling and init
To: Girish K S <girishks2000@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
In-Reply-To: <1360105784-12282-2-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com> <1360105784-12282-2-git-send-email-ks.giri@samsung.com>
Date: Wed, 06 Feb 2013 10:26:28 +0000
Message-Id: <20130206102628.5E7413E1510@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Feb 2013 15:09:41 -0800, Girish K S <girishks2000@gmail.com> wrote:
> The status of the interrupt is available in the status register,
> so reading the clear pending register and writing back the same
> value will not actually clear the pending interrupts. This patch
> modifies the interrupt handler to read the status register and
> clear the corresponding pending bit in the clear pending register.
> 
> Modified the hwInit function to clear all the pending interrupts.
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> ---
>  drivers/spi/spi-s3c64xx.c |   41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index ad93231..b770f88 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq, void *data)
>  {
>  	struct s3c64xx_spi_driver_data *sdd = data;
>  	struct spi_master *spi = sdd->master;
> -	unsigned int val;
> +	unsigned int val, clr = 0;
>  
> -	val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
> +	val = readl(sdd->regs + S3C64XX_SPI_STATUS);
>  
> -	val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
> -		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
> -		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
> -		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> -
> -	writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> -
> -	if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
> +	if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
> +		clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
>  		dev_err(&spi->dev, "RX overrun\n");
> -	if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
> +	}
> +	if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
> +		clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
>  		dev_err(&spi->dev, "RX underrun\n");
> -	if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
> +	}
> +	if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
> +		clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
>  		dev_err(&spi->dev, "TX overrun\n");
> -	if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
> +	}
> +	if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
> +		clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
>  		dev_err(&spi->dev, "TX underrun\n");
> +	}
> +
> +	/* Clear the pending irq by setting and then clearing it */
> +	writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
> +	writel(clr & ~clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);

Wait, what?  clr & ~clr == 0   Always.  What are you actually trying to do here?

>  
>  	return IRQ_HANDLED;
>  }
> @@ -1039,9 +1044,13 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
>  	writel(0, regs + S3C64XX_SPI_MODE_CFG);
>  	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
>  
> -	/* Clear any irq pending bits */
> -	writel(readl(regs + S3C64XX_SPI_PENDING_CLR),
> -				regs + S3C64XX_SPI_PENDING_CLR);
> +	/* Clear any irq pending bits, should set and clear the bits */
> +	val = S3C64XX_SPI_PND_RX_OVERRUN_CLR |
> +		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
> +		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
> +		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
> +	writel(val, regs + S3C64XX_SPI_PENDING_CLR);
> +	writel(val & ~val, regs + S3C64XX_SPI_PENDING_CLR);

Ditto.

g.
