Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbaGYI4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:56:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:55348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaGYI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="548879886"
Date: Fri, 25 Jul 2014 14:20:22 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Brown <broonie@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] spi: sh-msiof: Use correct device for DMA
 mapping with IOMMU
Message-ID: <20140725085022.GM8181@intel.com>
References: <1405094182-13962-1-git-send-email-geert+renesas@glider.be>
 <1405094182-13962-2-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405094182-13962-2-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 05:56:22PM +0200, Geert Uytterhoeven wrote:
> To function correctly in the presence of an IOMMU, the DMA buffers must be
> mapped using the DMA channel's device instead of the MSIOF platform
> device's device.

Acked-by: Vinod Koul <vinod.koul@intel.com>

I think Mark should pick this one up, I will pick the Documentation update
thru slave-dmanegine tree

-- 
~Vinod
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Use "dma_chan.device->dev" instead of "dma_chan.dev->device",
>   - Also fix calls to dma_unmap_single(), dma_mapping_error(), and
>     dma_sync_single_for_*()".
> ---
>  drivers/spi/spi-sh-msiof.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
> index 9922ed3a4441..6f449b24704a 100644
> --- a/drivers/spi/spi-sh-msiof.c
> +++ b/drivers/spi/spi-sh-msiof.c
> @@ -644,8 +644,8 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
>  
>  	if (tx) {
>  		ier_bits |= IER_TDREQE | IER_TDMAE;
> -		dma_sync_single_for_device(&p->pdev->dev, p->tx_dma_addr, len,
> -					   DMA_TO_DEVICE);
> +		dma_sync_single_for_device(p->master->dma_tx->device->dev,
> +					   p->tx_dma_addr, len, DMA_TO_DEVICE);
>  		desc_tx = dmaengine_prep_slave_single(p->master->dma_tx,
>  					p->tx_dma_addr, len, DMA_TO_DEVICE,
>  					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> @@ -716,7 +716,8 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
>  	}
>  
>  	if (rx)
> -		dma_sync_single_for_cpu(&p->pdev->dev, p->rx_dma_addr, len,
> +		dma_sync_single_for_cpu(p->master->dma_rx->device->dev,
> +					p->rx_dma_addr, len,
>  					DMA_FROM_DEVICE);
>  
>  	return 0;
> @@ -996,6 +997,7 @@ static int sh_msiof_request_dma(struct sh_msiof_spi_priv *p)
>  	const struct sh_msiof_spi_info *info = dev_get_platdata(dev);
>  	const struct resource *res;
>  	struct spi_master *master;
> +	struct device *tx_dev, *rx_dev;
>  
>  	if (!info || !info->dma_tx_id || !info->dma_rx_id)
>  		return 0;	/* The driver assumes no error */
> @@ -1026,21 +1028,23 @@ static int sh_msiof_request_dma(struct sh_msiof_spi_priv *p)
>  	if (!p->rx_dma_page)
>  		goto free_tx_page;
>  
> -	p->tx_dma_addr = dma_map_single(dev, p->tx_dma_page, PAGE_SIZE,
> +	tx_dev = master->dma_tx->device->dev;
> +	p->tx_dma_addr = dma_map_single(tx_dev, p->tx_dma_page, PAGE_SIZE,
>  					DMA_TO_DEVICE);
> -	if (dma_mapping_error(dev, p->tx_dma_addr))
> +	if (dma_mapping_error(tx_dev, p->tx_dma_addr))
>  		goto free_rx_page;
>  
> -	p->rx_dma_addr = dma_map_single(dev, p->rx_dma_page, PAGE_SIZE,
> +	rx_dev = master->dma_rx->device->dev;
> +	p->rx_dma_addr = dma_map_single(rx_dev, p->rx_dma_page, PAGE_SIZE,
>  					DMA_FROM_DEVICE);
> -	if (dma_mapping_error(dev, p->rx_dma_addr))
> +	if (dma_mapping_error(rx_dev, p->rx_dma_addr))
>  		goto unmap_tx_page;
>  
>  	dev_info(dev, "DMA available");
>  	return 0;
>  
>  unmap_tx_page:
> -	dma_unmap_single(dev, p->tx_dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
> +	dma_unmap_single(tx_dev, p->tx_dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
>  free_rx_page:
>  	free_page((unsigned long)p->rx_dma_page);
>  free_tx_page:
> @@ -1062,8 +1066,10 @@ static void sh_msiof_release_dma(struct sh_msiof_spi_priv *p)
>  		return;
>  
>  	dev = &p->pdev->dev;
> -	dma_unmap_single(dev, p->rx_dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
> -	dma_unmap_single(dev, p->tx_dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
> +	dma_unmap_single(master->dma_rx->device->dev, p->rx_dma_addr,
> +			 PAGE_SIZE, DMA_FROM_DEVICE);
> +	dma_unmap_single(master->dma_tx->device->dev, p->tx_dma_addr,
> +			 PAGE_SIZE, DMA_TO_DEVICE);
>  	free_page((unsigned long)p->rx_dma_page);
>  	free_page((unsigned long)p->tx_dma_page);
>  	dma_release_channel(master->dma_rx);
> -- 
> 1.9.1
> 

-- 
