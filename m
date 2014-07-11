Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaGKADa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:03:30 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:49401 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaGKAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:03:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Apelete Seketeli <apelete@seketeli.net>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mmc: jz4740: add dma infrastructure for data transfers
Date: Fri, 11 Jul 2014 02:03:27 +0200
Message-ID: <26025372.ALyVZ87vgl@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405031246-16365-2-git-send-email-apelete@seketeli.net>
References: <1405031246-16365-1-git-send-email-apelete@seketeli.net> <1405031246-16365-2-git-send-email-apelete@seketeli.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Apelete,

Thank you for the patch.

On Friday 11 July 2014 00:27:26 Apelete Seketeli wrote:
> Until now the MMC driver for JZ4740 SoC was relying on PIO mode only
> for data transfers.
> This patch allows the use of DMA for data trasnfers in addition to PIO
> mode by relying on DMA Engine.
> 
> DMA tranfers performance might be further improved by taking advantage
> of the asynchronous request capability of the MMC framework.
> 
> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> ---
> drivers/mmc/host/jz4740_mmc.c |  172 +++++++++++++++++++++++++++++++++++++--
> 1 file changed, 164
> insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
> index 537d6c7..2897b49 100644
> --- a/drivers/mmc/host/jz4740_mmc.c
> +++ b/drivers/mmc/host/jz4740_mmc.c

[snip]

> +static void jz4740_dma_unmap(struct jz4740_mmc_host *host,
> +			     struct mmc_data *data)
> +{
> +	enum dma_data_direction dir = jz4740_get_dma_dir(data);
> +
> +	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, dir);
> +}
> +
> +static int jz4740_start_dma_transfer(struct jz4740_mmc_host *host,
> +				     struct mmc_data *data)
> +{
> +	struct dma_chan *chan;
> +	struct dma_async_tx_descriptor *desc;
> +	struct dma_slave_config conf = {
> +		.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
> +		.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
> +		.src_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
> +		.dst_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
> +	};
> +	enum dma_data_direction dir = jz4740_get_dma_dir(data);
> +
> +	host->sg_len = dma_map_sg(mmc_dev(host->mmc),

You should use the DMA engine device here, not the MMC device, as the memory 
transfers will be performed by the DMA engine. Same for the dma_unmap_sg() 
call above.

> +				  data->sg,
> +				  data->sg_len,
> +				  dir);
> +
> +	if (host->sg_len < 0) {
> +		dev_err(mmc_dev(host->mmc),
> +			 "Failed to map scatterlist for DMA operation\n");
> +		return -EINVAL;
> +	}
> +
> +	if (dir == DMA_TO_DEVICE) {
> +		conf.direction = DMA_MEM_TO_DEV;
> +		conf.dst_addr = host->mem_res->start + JZ_REG_MMC_TXFIFO;
> +		conf.slave_id = JZ4740_DMA_TYPE_MMC_TRANSMIT;
> +		chan = host->dma_tx;
> +	} else {
> +		conf.direction = DMA_DEV_TO_MEM;
> +		conf.src_addr = host->mem_res->start + JZ_REG_MMC_RXFIFO;
> +		conf.slave_id = JZ4740_DMA_TYPE_MMC_RECEIVE;
> +		chan = host->dma_rx;
> +	}
> +
> +	dmaengine_slave_config(chan, &conf);
> +	desc = dmaengine_prep_slave_sg(chan,
> +				       data->sg,
> +				       host->sg_len,
> +				       conf.direction,
> +				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!desc) {
> +		dev_err(mmc_dev(host->mmc),
> +			 "Failed to allocate DMA %s descriptor",
> +			 conf.direction == DMA_MEM_TO_DEV ? "TX" : "RX");
> +		goto dma_unmap;
> +	}
> +
> +	dmaengine_submit(desc);
> +	dma_async_issue_pending(chan);
> +
> +	return 0;
> +
> +dma_unmap:
> +	jz4740_dma_unmap(host, data);
> +	return -ENOMEM;
> +}
> +
> +/*-------------------------------------------------------------------------
> ---*/ +
>  static void jz4740_mmc_set_irq_enabled(struct jz4740_mmc_host *host,
>  	unsigned int irq, bool enabled)
>  {

[snip]

> @@ -784,10 +922,17 @@ static int jz4740_mmc_probe(struct platform_device*
> pdev) goto err_free_host;
>  	}
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	host->base = devm_ioremap_resource(&pdev->dev, res);
> +	host->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!host->mem_res) {
> +		ret = -EBUSY;
> +		dev_err(&pdev->dev, "Failed to request memory region\n");
> +		goto err_free_host;

The devm_ioremap_resource() call below will handle the mem_res == NULL case 
and print a message, so you could remove this check.

> +	}
> +
> +	host->base = devm_ioremap_resource(&pdev->dev, host->mem_res);
>  	if (IS_ERR(host->base)) {
>  		ret = PTR_ERR(host->base);
> +		dev_err(&pdev->dev, "Failed to ioremap base memory\n");
>  		goto err_free_host;
>  	}
> 

[snip]

-- 
Regards,

Laurent Pinchart

