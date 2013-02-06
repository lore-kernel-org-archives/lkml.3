Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3BFKfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:35:45 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:37497 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3BFKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:35:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] spi: s3c64xx: added support for polling mode
To: Girish K S <girishks2000@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
In-Reply-To: <1360105784-12282-3-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com> <1360105784-12282-3-git-send-email-ks.giri@samsung.com>
Date: Wed, 06 Feb 2013 10:35:39 +0000
Message-Id: <20130206103539.B3B283E1510@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Feb 2013 15:09:42 -0800, Girish K S <girishks2000@gmail.com> wrote:
> The 64xx spi driver supports partial polling mode.
> Only the last chunk of the transfer length is transferred
> or recieved in polling mode.
> 
> Some SoC's that adopt this controller might not have have dma
> interface. This patch adds support for complete polling mode
> and gives flexibity for the user to select poll/dma mode.
> 
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> ---
>  drivers/spi/spi-s3c64xx.c |   65 +++++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index b770f88..90770bd 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -345,19 +348,7 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
>  
>  	chcfg = readl(regs + S3C64XX_SPI_CH_CFG);
>  	chcfg &= ~S3C64XX_SPI_CH_TXCH_ON;
> -
> -	if (dma_mode) {
>  		chcfg &= ~S3C64XX_SPI_CH_RXCH_ON;
> -	} else {
> -		/* Always shift in data in FIFO, even if xfer is Tx only,
> -		 * this helps setting PCKT_CNT value for generating clocks
> -		 * as exactly needed.
> -		 */
> -		chcfg |= S3C64XX_SPI_CH_RXCH_ON;
> -		writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
> -					| S3C64XX_SPI_PACKET_CNT_EN,
> -					regs + S3C64XX_SPI_PACKET_CNT);
> -	}

The removes a block of code, but leaves the modification of chcfg where
it is without fixing the indentation. I could also use some help
understanding why this particular else block is moved down in the
function.

>  	if (xfer->tx_buf != NULL) {
>  		sdd->state |= TXBUSY;
> @@ -385,6 +376,10 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
>  
>  	if (xfer->rx_buf != NULL) {
>  		sdd->state |= RXBUSY;
> +		chcfg |= S3C64XX_SPI_CH_RXCH_ON;
> +		writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
> +				| S3C64XX_SPI_PACKET_CNT_EN,
> +				regs + S3C64XX_SPI_PACKET_CNT);
>  
>  		if (sdd->port_conf->high_speed && sdd->cur_speed >= 30000000UL
>  					&& !(sdd->cur_mode & SPI_CPHA))
> @@ -392,10 +387,6 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
>  
>  		if (dma_mode) {
>  			modecfg |= S3C64XX_SPI_MODE_RXDMA_ON;
> -			chcfg |= S3C64XX_SPI_CH_RXCH_ON;
> -			writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
> -					| S3C64XX_SPI_PACKET_CNT_EN,
> -					regs + S3C64XX_SPI_PACKET_CNT);
>  			prepare_dma(&sdd->rx_dma, xfer->len, xfer->rx_dma);
>  		}
>  	}
> @@ -421,6 +412,9 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
>  
>  	cs = spi->controller_data;
>  	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
> +
> +	/* Start the signals */
> +	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
>  }
>  
>  static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
> @@ -480,16 +474,19 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
>  
>  		switch (sdd->cur_bpw) {
>  		case 32:
> -			ioread32_rep(regs + S3C64XX_SPI_RX_DATA,
> -				xfer->rx_buf, xfer->len / 4);
> +			for (val = 0; val < (xfer->len / 4); val++)
> +				*((u32 *)xfer->rx_buf + val) =
> +					ioread32(regs + S3C64XX_SPI_RX_DATA);
>  			break;
>  		case 16:
> -			ioread16_rep(regs + S3C64XX_SPI_RX_DATA,
> -				xfer->rx_buf, xfer->len / 2);
> +			for (val = 0; val < (xfer->len / 2); val++)
> +				*((u16 *)xfer->rx_buf + val) =
> +					ioread16(regs + S3C64XX_SPI_RX_DATA);
>  			break;
>  		default:
> -			ioread8_rep(regs + S3C64XX_SPI_RX_DATA,
> -				xfer->rx_buf, xfer->len);
> +			for (val = 0; val < xfer->len; val++)
> +				*((u8 *)xfer->rx_buf + val) =
> +					ioread8(regs + S3C64XX_SPI_RX_DATA);

What are all of the above lines changed? That seems to have nothing to
do with making the driver be albe to do polling transfers. Nor is it
described in the patch description.

I think this patch needs some more work. It certainly need to be
described better, and it appears that some of the changes really should be
in a separate patch.
