Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3CCMIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:08:46 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:39681 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3CCMHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:07:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 3/4] spi: s3c64xx: add dma maxburst size initialization
To: Boojin Kim <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, alsa-devel@alsa-project.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
In-Reply-To: <001b01ce10d3$e9f78620$bde69260$%kim@samsung.com>
References: <001b01ce10d3$e9f78620$bde69260$%kim@samsung.com>
Date: Sat, 02 Mar 2013 22:27:10 +0000
Message-Id: <20130302222710.AE2143E2E65@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 17:09:18 +0900, Boojin Kim <boojin.kim@samsung.com> wrote:
> This patch adds dma maxburst size initialization.
> The maxburst should be set by MODE_CFGn.DMA_TYPE,
> because the pl330 dma driver supports burst mode.
> 
> Signed-off-by: Hyeonkook Kim <hk619.kim@samsung.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

This series probably needs to be merged together through the arm-soc
tree.

g.

> ---
>  drivers/spi/spi-s3c64xx.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index e862ab8..5e6cafe 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -287,10 +287,20 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
>  	struct s3c64xx_spi_driver_data *sdd;
>  	struct samsung_dma_prep info;
>  	struct samsung_dma_config config;
> +	void __iomem *regs;
> +	unsigned int mode_cfg;
> 
>  	if (dma->direction == DMA_DEV_TO_MEM) {
>  		sdd = container_of((void *)dma,
>  			struct s3c64xx_spi_driver_data, rx_dma);
> +
> +		regs = sdd->regs;
> +		mode_cfg = readl(regs + S3C64XX_SPI_MODE_CFG);
> +		if (mode_cfg & S3C64XX_SPI_MODE_4BURST)
> +			config.maxburst = 4;
> +		else
> +			config.maxburst = 1;
> +
>  		config.direction = sdd->rx_dma.direction;
>  		config.fifo = sdd->sfr_start + S3C64XX_SPI_RX_DATA;
>  		config.width = sdd->cur_bpw / 8;
> @@ -298,6 +308,14 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
>  	} else {
>  		sdd = container_of((void *)dma,
>  			struct s3c64xx_spi_driver_data, tx_dma);
> +
> +		regs = sdd->regs;
> +		mode_cfg = readl(regs + S3C64XX_SPI_MODE_CFG);
> +		if (mode_cfg & S3C64XX_SPI_MODE_4BURST)
> +			config.maxburst = 4;
> +		else
> +			config.maxburst = 1;
> +
>  		config.direction =  sdd->tx_dma.direction;
>  		config.fifo = sdd->sfr_start + S3C64XX_SPI_TX_DATA;
>  		config.width = sdd->cur_bpw / 8;
> --
> 1.7.5.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
