Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579Ab3FUK1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:27:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43507 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3FUK1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:27:50 -0400
Message-ID: <51C42A71.1090403@ti.com>
Date: Fri, 21 Jun 2013 15:56:57 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Joel A Fernandes <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 09/11] spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-10-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371762407-24544-10-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On Friday 21 June 2013 02:36 AM, Joel A Fernandes wrote:
> From: Matt Porter<mporter@ti.com>
>
> Convert dmaengine channel requests to use
> dma_request_slave_channel_compat(). This supports the DT case of
> platforms requiring channel selection from either the OMAP DMA or
> the EDMA engine. AM33xx only boots from DT and is the only user
> implementing EDMA so in the !DT case we can default to the OMAP DMA
> filter.
>
> Signed-off-by: Matt Porter<mporter@ti.com>
> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Joel A Fernandes<joelagnel@ti.com>
> ---
>   drivers/spi/spi-omap2-mcspi.c |   64 ++++++++++++++++++++++++++++-------------
>   1 file changed, 44 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 86d2158..ca4ab78 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -102,6 +102,9 @@ struct omap2_mcspi_dma {
>
>   	struct completion dma_tx_completion;
>   	struct completion dma_rx_completion;
> +
> +	char dma_rx_ch_name[14];
> +	char dma_tx_ch_name[14];
>   };
>
>   /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
> @@ -830,12 +833,20 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
>   	dma_cap_zero(mask);
>   	dma_cap_set(DMA_SLAVE, mask);
>   	sig = mcspi_dma->dma_rx_sync_dev;
> -	mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn,&sig);
> +
> +	mcspi_dma->dma_rx =
> +		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> +						&sig,&master->dev,
> +						 mcspi_dma->dma_rx_ch_name);
>   	if (!mcspi_dma->dma_rx)
>   		goto no_dma;
>
>   	sig = mcspi_dma->dma_tx_sync_dev;
> -	mcspi_dma->dma_tx = dma_request_channel(mask, omap_dma_filter_fn,&sig);
> +	mcspi_dma->dma_tx =
> +		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> +						&sig,&master->dev,
> +						 mcspi_dma->dma_tx_ch_name);
> +
>   	if (!mcspi_dma->dma_tx) {
>   		dma_release_channel(mcspi_dma->dma_rx);
>   		mcspi_dma->dma_rx = NULL;
> @@ -1256,29 +1267,42 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
>   		goto free_master;
>
>   	for (i = 0; i<  master->num_chipselect; i++) {
> -		char dma_ch_name[14];
> +		char *dma_rx_ch_name = mcspi->dma_channels[i].dma_rx_ch_name;
> +		char *dma_tx_ch_name = mcspi->dma_channels[i].dma_tx_ch_name;
>   		struct resource *dma_res;
>
> -		sprintf(dma_ch_name, "rx%d", i);
> -		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
> -				dma_ch_name);
> -		if (!dma_res) {
> -			dev_dbg(&pdev->dev, "cannot get DMA RX channel\n");
> -			status = -ENODEV;
> -			break;
> -		}
> +		sprintf(dma_rx_ch_name, "rx%d", i);
> +		if (!pdev->dev.of_node) {
> +			dma_res =
> +				platform_get_resource_byname(pdev,
> +							     IORESOURCE_DMA,
> +							     dma_rx_ch_name);
> +			if (!dma_res) {
> +				dev_dbg(&pdev->dev,
> +					"cannot get DMA RX channel\n");
> +				status = -ENODEV;
> +				break;
> +			}
>
> -		mcspi->dma_channels[i].dma_rx_sync_dev = dma_res->start;
> -		sprintf(dma_ch_name, "tx%d", i);
> -		dma_res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
> -				dma_ch_name);
> -		if (!dma_res) {
> -			dev_dbg(&pdev->dev, "cannot get DMA TX channel\n");
> -			status = -ENODEV;
> -			break;
> +			mcspi->dma_channels[i].dma_rx_sync_dev =
> +				dma_res->start;
>   		}
> +		sprintf(dma_tx_ch_name, "tx%d", i);
> +		if (!pdev->dev.of_node) {
> +			dma_res =
> +				platform_get_resource_byname(pdev,
> +							     IORESOURCE_DMA,
> +							     dma_tx_ch_name);
> +			if (!dma_res) {
> +				dev_dbg(&pdev->dev,
> +					"cannot get DMA TX channel\n");
> +				status = -ENODEV;
> +				break;
> +			}
>
> -		mcspi->dma_channels[i].dma_tx_sync_dev = dma_res->start;
> +			mcspi->dma_channels[i].dma_tx_sync_dev =
> +				dma_res->start;
> +		}
>   	}
>
>   	if (status<  0)
Acked-by: Sourav Poddar <sourav.poddar@ti.com>
Tested-by: Sourav Poddar <sourav.poddar@ti.com>

This patch can go independently and does not depend on the rest of the
series.
Can these patch be pulled?



