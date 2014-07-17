Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbaGQXGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:06:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46628 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbaGQXGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:06:38 -0400
Message-ID: <53C856FB.7010609@codeaurora.org>
Date: Thu, 17 Jul 2014 16:06:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: linux-mmc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        agross@codeaurora.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] mmc: mmci: Add qcom dml support to the driver.
References: <1405079306-1406-1-git-send-email-srinivas.kandagatla@linaro.org> <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1405625780-13503-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/14 12:36, Srinivas Kandagatla wrote:
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index b66b351..a83b7b5 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -74,6 +75,7 @@ static unsigned int fmax = 515633;
>   * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
>   * @explicit_mclk_control: enable explicit mclk control in driver.
>   * @qcom_fifo: enables qcom specific fifo pio read logic.
> + * @qcom_dml: enables qcom specific dml glue for dma transfers.

Maybe s/dml glue/dma glue/ in the comment so we don't refer to the
variable with dml in the name by dml.

>   */
>  struct variant_data {
>  	unsigned int		clkreg;
> @@ -569,6 +579,7 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
>  	struct dma_async_tx_descriptor *desc;
>  	enum dma_data_direction buffer_dirn;
>  	int nr_sg;
> +	u32 flags = DMA_CTRL_ACK;

unsigned long to match function signature please.

>  
>  	if (data->flags & MMC_DATA_READ) {
>  		conf.direction = DMA_DEV_TO_MEM;
> @@ -593,9 +604,12 @@ static int __mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
>  	if (nr_sg == 0)
>  		return -EINVAL;
>  
> +	if (host->variant->qcom_dml)
> +		flags |= DMA_PREP_INTERRUPT;
> +
>  	dmaengine_slave_config(chan, &conf);
>  	desc = dmaengine_prep_slave_sg(chan, data->sg, nr_sg,
> -					    conf.direction, DMA_CTRL_ACK);
> +					    conf.direction, flags);
>  	if (!desc)
>  		goto unmap_exit;
>  
> diff --git a/drivers/mmc/host/mmci_qcom_dml.c b/drivers/mmc/host/mmci_qcom_dml.c
> new file mode 100644
> index 0000000..e2ecd07
> --- /dev/null
> +++ b/drivers/mmc/host/mmci_qcom_dml.c
> @@ -0,0 +1,171 @@

No license text? I'd think most of this code is from qualcomm's kernel
and those files all have the gpl stuff.

> +#include <linux/of.h>
> +#include <linux/of_dma.h>
> +#include <linux/bitops.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/card.h>
> +#include "mmci.h"
> +
> +/* Registers */
> +#define DML_CONFIG			0x00
> +#define PRODUCER_CRCI_MSK		GENMASK(1, 0)
> +#define PRODUCER_CRCI_DISABLE		0
> +#define PRODUCER_CRCI_X_SEL		BIT(0)
> +#define PRODUCER_CRCI_Y_SEL		BIT(1)
> +#define CONSUMER_CRCI_MSK		GENMASK(3, 2)
> +#define CONSUMER_CRCI_DISABLE		0
> +#define CONSUMER_CRCI_X_SEL		BIT(2)
> +#define CONSUMER_CRCI_Y_SEL		BIT(3)
> +#define PRODUCER_TRANS_END_EN		BIT(4)
> +#define BYPASS				BIT(16)
> +#define DIRECT_MODE			BIT(17)
> +#define INFINITE_CONS_TRANS		BIT(18)
> +
> +#define DML_SW_RESET			0x08
> +#define DML_PRODUCER_START		0x0c
> +#define DML_CONSUMER_START		0x10
> +#define DML_PRODUCER_PIPE_LOGICAL_SIZE	0x14
> +#define DML_CONSUMER_PIPE_LOGICAL_SIZE	0x18
> +#define DML_PIPE_ID			0x1c
> +#define PRODUCER_PIPE_ID_SHFT		0
> +#define PRODUCER_PIPE_ID_MSK		GENMASK(4, 0)
> +#define CONSUMER_PIPE_ID_SHFT		16
> +#define CONSUMER_PIPE_ID_MSK		GENMASK(20, 16)
> +
> +#define DML_PRODUCER_BAM_BLOCK_SIZE	0x24
> +#define DML_PRODUCER_BAM_TRANS_SIZE	0x28
> +
> +/* other definitions */
> +#define PRODUCER_PIPE_LOGICAL_SIZE	4096
> +#define CONSUMER_PIPE_LOGICAL_SIZE	4096
> +
> +#define DML_OFFSET			0x800
> +
> +void dml_start_xfer(struct mmci_host *host, struct mmc_data *data)
> +{
> +	u32 config;
> +	void __iomem *dml_base;
> +
> +	dml_base = host->base + DML_OFFSET;
> +
> +	if (data->flags & MMC_DATA_READ) {
> +		/* Read operation: configure DML for producer operation */
> +		/* Set producer CRCI-x and disable consumer CRCI */
> +		config = readl(dml_base + DML_CONFIG);
> +		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_X_SEL;
> +		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_DISABLE;
> +		writel(config, (dml_base + DML_CONFIG));
> +
> +		/* Set the Producer BAM block size */
> +		writel(data->blksz, (dml_base +	DML_PRODUCER_BAM_BLOCK_SIZE));
> +
> +		/* Set Producer BAM Transaction size */
> +		writel(data->blocks * data->blksz,
> +			(dml_base + DML_PRODUCER_BAM_TRANS_SIZE));
> +		/* Set Producer Transaction End bit */
> +		writel((readl_relaxed(dml_base + DML_CONFIG) |
> +			PRODUCER_TRANS_END_EN),
> +			(dml_base + DML_CONFIG));

Please use local variables instead of writel(readl()). It makes things
much more readable.

> +		/* Trigger producer */
> +		writel(1, (dml_base + DML_PRODUCER_START));
> +	} else {
> +		/* Write operation: configure DML for consumer operation */
> +		/* Set consumer CRCI-x and disable producer CRCI*/
> +		config = readl(dml_base + DML_CONFIG);
> +		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_X_SEL;
> +		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_DISABLE;
> +		writel(config, (dml_base + DML_CONFIG));
> +		/* Clear Producer Transaction End bit */
> +		writel((readl_relaxed(dml_base + DML_CONFIG)
> +			& ~PRODUCER_TRANS_END_EN),
> +			(dml_base + DML_CONFIG));
> +		/* Trigger consumer */
> +		writel(1, (dml_base + DML_CONSUMER_START));

It would be better to use the relaxed accessors when possible.

> +	}
> +}
> +
> +static int of_get_dml_pipe_index(struct device_node *np, const char *name)
> +{
> +	int count, i;
> +	const char *s;
> +	struct of_phandle_args	dma_spec;
> +
> +	if (!np || !name)

Looks unnecessary. name is definitely not NULL because this function is
static and the only caller is right down there. np is most likely not
NULL either, but if it is we should blow up with an oops instead of
silently failing.

> +		return -ENODEV;
> +
> +	count = of_property_count_strings(np, "dma-names");
> +	if (count < 0)
> +		return -ENODEV;
> +
> +	for (i = 0; i < count; i++) {
> +
> +		if (of_property_read_string_index(np, "dma-names", i, &s))
> +			continue;
> +
> +		if (strcmp(name, s))
> +			continue;
> +
> +		if (of_parse_phandle_with_args(np, "dmas", "#dma-cells", i,
> +				       &dma_spec))
> +			continue;
> +
> +		if (dma_spec.args_count)
> +			return dma_spec.args[0];
> +	}

Could this be rewritten to use of_property_match_string()?

index = of_property_match_string(np, "dma-names", s);
if (index < 0)
	return index;

if (of_parse_phandle_with_args(np, "dmas", "#dma-cells", index,
			       &dma_spec))
	return -ENODEV;


> +
> +	return -ENODEV;
> +}
> +
> +/* Initialize the dml hardware connected to SD Card controller */
> +int dml_hw_init(struct mmci_host *host, struct device_node *np)
> +{
> +	u32 config = 0;

unnecessary initialization.

> +	void __iomem *dml_base;
> +	u32 consumer_id = 0, producer_id = 0;

unnecessary initialization.

> +
> +	consumer_id = of_get_dml_pipe_index(np, "tx");
> +	producer_id = of_get_dml_pipe_index(np, "rx");
> +
> +	if (IS_ERR_VALUE(producer_id) || IS_ERR_VALUE(consumer_id))

Is it actually possible for these ids to be very large values? Why not
just <= 0?

> +		return -ENODEV;
> +
> +	dml_base = host->base + DML_OFFSET;
> +
> +	/* Reset the DML block */
> +	writel(1, (dml_base + DML_SW_RESET));
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
> +	writel(config, (dml_base + DML_CONFIG));

unnecessary parens (throughout this file actually).

> +
> +	/*
> +	 * Initialize the logical BAM pipe size for producer
> +	 * and consumer.
> +	 */
> +	writel(PRODUCER_PIPE_LOGICAL_SIZE,
> +		(dml_base + DML_PRODUCER_PIPE_LOGICAL_SIZE));
> +	writel(CONSUMER_PIPE_LOGICAL_SIZE,
> +		(dml_base + DML_CONSUMER_PIPE_LOGICAL_SIZE));
> +
> +	/* Initialize Producer/consumer pipe id */
> +	writel(producer_id | (consumer_id << CONSUMER_PIPE_ID_SHFT),
> +		(dml_base + DML_PIPE_ID));
> +
> +	return 0;
> +}
> diff --git a/drivers/mmc/host/mmci_qcom_dml.h b/drivers/mmc/host/mmci_qcom_dml.h
> new file mode 100644
> index 0000000..d2c5aa45
> --- /dev/null
> +++ b/drivers/mmc/host/mmci_qcom_dml.h
> @@ -0,0 +1,17 @@

ditto for license text.

> +#ifndef __MMC_QCOM_DML_H__
> +#define __MMC_QCOM_DML_H__
> +
> +#ifdef CONFIG_MMC_QCOM_DML
> +int dml_hw_init(struct mmci_host *host, struct device_node *np);
> +void dml_start_xfer(struct mmci_host *host, struct mmc_data *data);
> +#else
> +static inline int dml_hw_init(struct mmci_host *host, struct device_node *np)
> +{
> +	return -ENOSYS;
> +}
> +static inline void dml_start_xfer(struct mmci_host *host, struct mmc_data *data)
> +{
> +}
> +#endif /* CONFIG_MMC_QCOM_DML */
> +
> +#endif /* __MMC_QCOM_DML_H__ */


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

