Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbbAIEi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:38:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57042 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbbAIEi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:38:27 -0500
Message-ID: <54AF5B3C.7070305@codeaurora.org>
Date: Fri, 09 Jan 2015 10:08:20 +0530
From: Archit Taneja <architt@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 1/2] dmaengine: Add ADM driver
References: <1420687572-7116-1-git-send-email-agross@codeaurora.org> <1420687572-7116-2-git-send-email-agross@codeaurora.org>
In-Reply-To: <1420687572-7116-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/08/2015 08:56 AM, Andy Gross wrote:
> Signed-off-by: Andy Gross <agross@codeaurora.org>
<snip>

> +static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
> +	struct scatterlist *sgl, unsigned int sg_len,
> +	enum dma_transfer_direction direction, unsigned long flags,
> +	void *context)
> +{
> +	struct adm_chan *achan = to_adm_chan(chan);
> +	struct adm_device *adev = achan->adev;
> +	struct adm_async_desc *async_desc;
> +	struct scatterlist *sg;
> +	u32 i;
> +	u32 single_count = 0, box_count = 0, desc_offset = 0, crci = 0;
> +	struct adm_desc_hw_box *box_desc;
> +	struct adm_desc_hw_single *single_desc;
> +	void *desc;
> +	u32 *cple, *last_cmd;
> +	u32 burst;
> +	int blk_size = -EINVAL;

blk_size should be set to 0 here. Otherwise async_desc->blk_size takes 
-EINVAL when no flow control.

> +
> +
> +	if (!is_slave_direction(direction)) {
> +		dev_err(adev->dev, "invalid dma direction\n");
> +		return NULL;
> +	}
> +
> +	/*
> +	 * get burst value from slave configuration
> +	 * If zero, default to maximum burst size
> +	 * If larger than the max transfer size, set to ADM_MAX_XFER
> +	 */
> +	burst = (direction == DMA_MEM_TO_DEV) ?
> +		achan->slave.dst_maxburst :
> +		achan->slave.src_maxburst;
> +
> +	if (!burst || burst > ADM_MAX_XFER)
> +		burst = ADM_MAX_XFER;
> +
> +	/* if using flow control, validate burst and crci values */
> +	if (achan->slave.device_fc) {
> +
> +		blk_size = adm_get_blksize(burst);
> +		if (blk_size < 0) {
> +			dev_err(adev->dev, "invalid burst value w/ crci: %d\n",
> +				burst);
> +			return ERR_PTR(-EINVAL);
> +		}
> +
> +		crci = achan->slave.slave_id;
> +		if (!(crci & 0xf)) {

This check isn't sufficient for the crci to lie between 1 and 15. 
slave_id passed as, say, 0xf5, will be valid.

<snip>


> +/**
> + * adm_dma_irq - irq handler for ADM controller
> + * @irq: IRQ of interrupt
> + * @data: callback data
> + *
> + * IRQ handler for the bam controller
> + */
> +static irqreturn_t adm_dma_irq(int irq, void *data)
> +{
> +	struct adm_device *adev = data;
> +	u32 srcs, i;
> +	struct adm_async_desc *async_desc;
> +	unsigned long flags;
> +
> +	srcs = readl_relaxed(adev->regs +
> +			HI_SEC_DOMAIN_IRQ_STATUS(adev->ee));
> +
> +	for (i = 0; i < 16; i++) {

we could use adev->num_channels here instead of 16.

> +		struct adm_chan *achan = &adev->channels[i];
> +		u32 status, result;
> +
> +		if (srcs & BIT(i)) {
> +			status = readl_relaxed(adev->regs +
> +				HI_CH_STATUS_SD(i, adev->ee));
> +
> +			/* if no result present, skip */
> +			if (!(status & CH_STATUS_VALID))
> +				continue;
> +
> +			result = readl_relaxed(adev->regs +
> +				HI_CH_RSLT(i, adev->ee));
> +
> +			/* no valid results, skip */
> +			if (!(result & CH_RSLT_VALID))
> +				continue;
> +
> +			/* flag error if transaction was flushed or failed */
> +			if (result & (CH_RSLT_ERR | CH_RSLT_FLUSH))
> +				achan->error = 1;
> +
> +			spin_lock_irqsave(&achan->vc.lock, flags);
> +			async_desc = achan->curr_txd;
> +
> +			achan->curr_txd = NULL;
> +
> +			if (async_desc) {
> +				vchan_cookie_complete(&async_desc->vd);
> +
> +				/* kick off next DMA */
> +				adm_start_dma(achan);
> +			}
> +
> +			spin_unlock_irqrestore(&achan->vc.lock, flags);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}

<snip>

> +
> +static int adm_dma_probe(struct platform_device *pdev)
> +{
> +	struct adm_device *adev;
> +	struct resource *iores;
> +	int ret;
> +	u32 i;
> +
> +	adev = devm_kzalloc(&pdev->dev, sizeof(*adev), GFP_KERNEL);
> +	if (!adev)
> +		return -ENOMEM;
> +
> +	adev->dev = &pdev->dev;
> +
> +	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	adev->regs = devm_ioremap_resource(&pdev->dev, iores);
> +	if (IS_ERR(adev->regs))
> +		return PTR_ERR(adev->regs);
> +
> +	adev->irq = platform_get_irq(pdev, 0);
> +	if (adev->irq < 0)
> +		return adev->irq;
> +
> +	ret = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &adev->ee);
> +	if (ret) {
> +		dev_err(adev->dev, "Execution environment unspecified\n");
> +		return ret;
> +	}
> +
> +	adev->core_clk = devm_clk_get(adev->dev, "core");
> +	if (IS_ERR(adev->core_clk))
> +		return PTR_ERR(adev->core_clk);
> +
> +	ret = clk_prepare_enable(adev->core_clk);
> +	if (ret) {
> +		dev_err(adev->dev, "failed to prepare/enable core clock\n");
> +		return ret;
> +	}
> +
> +	adev->iface_clk = devm_clk_get(adev->dev, "iface");
> +	if (IS_ERR(adev->iface_clk))
> +		return PTR_ERR(adev->iface_clk);
> +

An error here or below would leave core_clk on.

> +	ret = clk_prepare_enable(adev->iface_clk);
> +	if (ret) {
> +		dev_err(adev->dev, "failed to prepare/enable iface clock\n");
> +		return ret;
> +	}
> +
> +	adev->clk_reset = devm_reset_control_get(&pdev->dev, "clk");
> +	if (IS_ERR(adev->clk_reset)) {
> +		dev_err(adev->dev, "failed to get ADM0 reset\n");
> +		return PTR_ERR(adev->clk_reset);
> +	}
> +
> +	adev->c0_reset = devm_reset_control_get(&pdev->dev, "c0");
> +	if (IS_ERR(adev->c0_reset)) {
> +		dev_err(adev->dev, "failed to get ADM0 C0 reset\n");
> +		return PTR_ERR(adev->c0_reset);
> +	}
> +
> +	adev->c1_reset = devm_reset_control_get(&pdev->dev, "c1");
> +	if (IS_ERR(adev->c1_reset)) {
> +		dev_err(adev->dev, "failed to get ADM0 C1 reset\n");
> +		return PTR_ERR(adev->c1_reset);
> +	}
> +
> +	adev->c2_reset = devm_reset_control_get(&pdev->dev, "c2");
> +	if (IS_ERR(adev->c2_reset)) {
> +		dev_err(adev->dev, "failed to get ADM0 C2 reset\n");
> +		return PTR_ERR(adev->c2_reset);
> +	}

All the devm_reset_control_get() failures should disable the clocks too.

Looks good otherwise.

Thanks,
Archit
