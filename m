Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaGBO1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:27:04 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50724 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaGBO1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:27:01 -0400
Message-ID: <1404311191.3622.22.camel@iivanov-dev>
Subject: Re: [PATCH] spi: qup: Add DMA capabilities
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 02 Jul 2014 17:26:31 +0300
In-Reply-To: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
References: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andy,

Just few comments.

On Thu, 2014-06-26 at 16:06 -0500, Andy Gross wrote:
> This patch adds DMA capabilities to the spi-qup driver.  If DMA channels are
> present, the QUP will use DMA instead of block mode for transfers to/from SPI
> peripherals for transactions larger than the length of a block.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  .../devicetree/bindings/spi/qcom,spi-qup.txt       |   10 +
>  drivers/spi/spi-qup.c                              |  361 ++++++++++++++++++--
>  2 files changed, 350 insertions(+), 21 deletions(-)
> 

<snip>
 
> diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
> index fc1de86..9b01db5 100644
> --- a/drivers/spi/spi-qup.c
> +++ b/drivers/spi/spi-qup.c
> @@ -22,6 +22,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/spi/spi.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
>  
>  #define QUP_CONFIG			0x0000
>  #define QUP_STATE			0x0004
> @@ -116,6 +118,8 @@
>  
>  #define SPI_NUM_CHIPSELECTS		4
>  
> +#define SPI_MAX_XFER			(SZ_64K - 64)
> +
>  /* high speed mode is when bus rate is greater then 26MHz */
>  #define SPI_HS_MIN_RATE			26000000
>  #define SPI_MAX_RATE			50000000
> @@ -142,6 +146,17 @@ struct spi_qup {
>  	int			w_size;	/* bytes per SPI word */
>  	int			tx_bytes;
>  	int			rx_bytes;
> +
> +	int			use_dma;
> +
> +	struct dma_chan		*rx_chan;
> +	struct dma_slave_config	rx_conf;
> +	struct dma_chan		*tx_chan;
> +	struct dma_slave_config tx_conf;
> +	dma_addr_t		rx_dma;
> +	dma_addr_t		tx_dma;

DMA addresses seems unused.

> +	void			*dummy;

This is not so dummy, probably 'spare'.

> +	atomic_t		dma_outstanding;
>  };

<snip>

>  
>  
> @@ -632,6 +896,56 @@ static int spi_qup_probe(struct platform_device *pdev)
>  	writel_relaxed(SPI_ERROR_CLK_UNDER_RUN | SPI_ERROR_CLK_OVER_RUN,
>  		       base + SPI_ERROR_FLAGS_EN);
>  
> +	/* allocate dma resources, if available */
> +	controller->rx_chan = dma_request_slave_channel(&pdev->dev, "rx");
> +	if (controller->rx_chan) {
> +		controller->tx_chan =
> +			dma_request_slave_channel(&pdev->dev, "tx");
> +
> +		if (!controller->tx_chan) {
> +			dev_err(&pdev->dev, "Failed to allocate dma tx chan");
> +			dma_release_channel(controller->rx_chan);


There is no point to go further with DMA configuration
if there are no channels, right?

> +		}
> +
> +		/* set DMA parameters */
> +		controller->rx_conf.device_fc = 1;
> +		controller->rx_conf.src_addr = res->start + QUP_INPUT_FIFO;
> +		controller->rx_conf.src_maxburst = controller->in_blk_sz;
> +
> +		controller->tx_conf.device_fc = 1;
> +		controller->tx_conf.dst_addr = res->start + QUP_OUTPUT_FIFO;
> +		controller->tx_conf.dst_maxburst = controller->out_blk_sz;
> +


Please, could you share blsp2_bam device node configuration? 
I would like to test these changes.

Regards,
Ivan

