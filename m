Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbaGWW6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:58:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35581 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaGWW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:58:45 -0400
Message-ID: <53D03E23.1000801@codeaurora.org>
Date: Wed, 23 Jul 2014 15:58:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: linux-mmc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] mmc: mmci: Add qcom dml support to the driver.
References: <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org> <1405716797-28122-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1405716797-28122-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/14 13:53, Srinivas Kandagatla wrote:
>
> @@ -468,6 +473,11 @@ static void mmci_dma_setup(struct mmci_host *host)
>  		if (max_seg_size < host->mmc->max_seg_size)
>  			host->mmc->max_seg_size = max_seg_size;
>  	}
> +
> +	if (variant->qcom_dml && host->dma_rx_channel && host->dma_tx_channel) {
> +		if (dml_hw_init(host, host->mmc->parent->of_node))
> +			variant->qcom_dml = false;
> +	}

Style nit: Braces aren't needed.

> +
> +void dml_start_xfer(struct mmci_host *host, struct mmc_data *data)
> +{
> +	u32 config;
> +	void __iomem *base = host->base + DML_OFFSET;
> +
> +	if (data->flags & MMC_DATA_READ) {
> +		/* Read operation: configure DML for producer operation */
> +		/* Set producer CRCI-x and disable consumer CRCI */
> +		config = readl_relaxed(base + DML_CONFIG);
> +		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_X_SEL;
> +		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_DISABLE;
> +		writel_relaxed(config, base + DML_CONFIG);
> +
> +		/* Set the Producer BAM block size */
> +		writel_relaxed(data->blksz, base + DML_PRODUCER_BAM_BLOCK_SIZE);
> +
> +		/* Set Producer BAM Transaction size */
> +		writel_relaxed(data->blocks * data->blksz,
> +			       base + DML_PRODUCER_BAM_TRANS_SIZE);
> +		/* Set Producer Transaction End bit */
> +		config = readl_relaxed(base + DML_CONFIG);
> +		config |= PRODUCER_TRANS_END_EN;
> +		writel_relaxed(config, base + DML_CONFIG);
> +		/* Trigger producer */
> +		writel_relaxed(1, base + DML_PRODUCER_START);
> +	} else {
> +		/* Write operation: configure DML for consumer operation */
> +		/* Set consumer CRCI-x and disable producer CRCI*/
> +		config = readl_relaxed(base + DML_CONFIG);
> +		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_X_SEL;
> +		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_DISABLE;
> +		writel_relaxed(config, base + DML_CONFIG);
> +		/* Clear Producer Transaction End bit */
> +		config = readl_relaxed(base + DML_CONFIG);
> +		config &= ~PRODUCER_TRANS_END_EN;
> +		writel_relaxed(config, base + DML_CONFIG);
> +		/* Trigger consumer */
> +		writel_relaxed(1, base + DML_CONSUMER_START);
> +	}

I think we need a memory barrier here. Does the DML need to be enabled
before the mmci driver sets MCI_DPSM_DMAENABLE? My understanding is that
relaxed accesses to different devices aren't ordered with respect to one
another.  So not having a memory barrier here could cause the
consumer/producer to be enabled after MCI_DPSM_DMAENABLE is set in the
mmci hardware. Downstream I see that we have an mb(), but I think we
could just a wmb() because we're just ordering with the mmci hardware right?

Is there any ordering required between bam and dml? I think enabling bam
could happen after enabling the consumer unless we had a wmb() after we
kick off bam and before we write a 1 to DML_CONSUMER_START.

> +}
> +
> +static int of_get_dml_pipe_index(struct device_node *np, const char *name)

return type of u32?

> +{
> +	int index;
> +	struct of_phandle_args	dma_spec;
> +
> +	index = of_property_match_string(np, "dma-names", name);
> +
> +	if (index < 0)
> +		return -ENODEV;
> +
> +	if (of_parse_phandle_with_args(np, "dmas", "#dma-cells", index,
> +				       &dma_spec))
> +		return -ENODEV;
> +
> +	if (dma_spec.args_count)
> +		return dma_spec.args[0];
> +
> +	return -ENODEV;
> +}

Much cleaner!

> +
> +/* Initialize the dml hardware connected to SD Card controller */
> +int dml_hw_init(struct mmci_host *host, struct device_node *np)
> +{
> +	u32 config;
> +	void __iomem *base;
> +	u32 consumer_id, producer_id;
> +
> +	consumer_id = of_get_dml_pipe_index(np, "tx");
> +	producer_id = of_get_dml_pipe_index(np, "rx");
> +
> +	if (producer_id < 0 || consumer_id < 0)
> +		return -ENODEV;
> +
> +	base = host->base + DML_OFFSET;
> +
> +	/* Reset the DML block */
> +	writel_relaxed(1, base + DML_SW_RESET);
> +
> +	/* Disable the producer and consumer CRCI */
> +	config = (PRODUCER_CRCI_DISABLE | CONSUMER_CRCI_DISABLE);
> +	/*
> +	 * Disable the bypass mode. Bypass mode will only be used
> +	 * if data transfer is to happen in PIO mode and don't
> +	 * want the BAM interface to connect with SDCC-DML.
> +	 */
> +	config &= ~BYPASS;
> +	/*
> +	 * Disable direct mode as we don't DML to MASTER the AHB bus.
> +	 * BAM connected with DML should MASTER the AHB bus.
> +	 */
> +	config &= ~DIRECT_MODE;
> +	/*
> +	 * Disable infinite mode transfer as we won't be doing any
> +	 * infinite size data transfers. All data transfer will be
> +	 * of finite data size.
> +	 */
> +	config &= ~INFINITE_CONS_TRANS;
> +	writel_relaxed(config, base + DML_CONFIG);
> +
> +	/*
> +	 * Initialize the logical BAM pipe size for producer
> +	 * and consumer.
> +	 */
> +	writel_relaxed(PRODUCER_PIPE_LOGICAL_SIZE,
> +		       base + DML_PRODUCER_PIPE_LOGICAL_SIZE);
> +	writel_relaxed(CONSUMER_PIPE_LOGICAL_SIZE,
> +		       base + DML_CONSUMER_PIPE_LOGICAL_SIZE);
> +
> +	/* Initialize Producer/consumer pipe id */
> +	writel_relaxed(producer_id | (consumer_id << CONSUMER_PIPE_ID_SHFT),
> +		       base + DML_PIPE_ID);
> +

We have an mb() here too. Not sure why though. There's lots of comments
downstream but not where it actually would help!

> +	return 0;
> +}
> diff --git a/drivers/mmc/host/mmci_qcom_dml.h b/drivers/mmc/host/mmci_qcom_dml.h
> new file mode 100644
> index 0000000..412e9a3
> --- /dev/null
> +++ b/drivers/mmc/host/mmci_qcom_dml.h
> @@ -0,0 +1,31 @@
> +/*
> + *
> + * Copyright (c) 2014, Code Aurora Forum. All rights reserved.

Hmm I see:

Copyright (c) 2011, The Linux Foundation. All rights reserved.

in these files. Can you use that?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

