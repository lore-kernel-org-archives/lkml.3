Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbbAIRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:08:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60515 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAIRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:08:51 -0500
Date: Fri, 9 Jan 2015 11:08:49 -0600
From: Andy Gross <agross@codeaurora.org>
To: Archit Taneja <architt@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 1/2] dmaengine: Add ADM driver
Message-ID: <20150109170849.GA16970@qualcomm.com>
References: <1420687572-7116-1-git-send-email-agross@codeaurora.org>
 <1420687572-7116-2-git-send-email-agross@codeaurora.org>
 <54AF5B3C.7070305@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AF5B3C.7070305@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 10:08:20AM +0530, Archit Taneja wrote:
> Hi,
> 
> On 01/08/2015 08:56 AM, Andy Gross wrote:
> >Signed-off-by: Andy Gross <agross@codeaurora.org>
> <snip>
> 
> >+static struct dma_async_tx_descriptor *adm_prep_slave_sg(struct dma_chan *chan,
> >+	struct scatterlist *sgl, unsigned int sg_len,
> >+	enum dma_transfer_direction direction, unsigned long flags,
> >+	void *context)
> >+{
> >+	struct adm_chan *achan = to_adm_chan(chan);
> >+	struct adm_device *adev = achan->adev;
> >+	struct adm_async_desc *async_desc;
> >+	struct scatterlist *sg;
> >+	u32 i;
> >+	u32 single_count = 0, box_count = 0, desc_offset = 0, crci = 0;
> >+	struct adm_desc_hw_box *box_desc;
> >+	struct adm_desc_hw_single *single_desc;
> >+	void *desc;
> >+	u32 *cple, *last_cmd;
> >+	u32 burst;
> >+	int blk_size = -EINVAL;
> 
> blk_size should be set to 0 here. Otherwise async_desc->blk_size
> takes -EINVAL when no flow control.

We only use the blk_size value in the start_dma function, and only if
device_fc=1.  So for no flow control, any value is acceptable.  You can't prep a
descriptor with a bad blk_size and flow control on.  So we're covered both ways.

> 
> >+
> >+
> >+	if (!is_slave_direction(direction)) {
> >+		dev_err(adev->dev, "invalid dma direction\n");
> >+		return NULL;
> >+	}
> >+
> >+	/*
> >+	 * get burst value from slave configuration
> >+	 * If zero, default to maximum burst size
> >+	 * If larger than the max transfer size, set to ADM_MAX_XFER
> >+	 */
> >+	burst = (direction == DMA_MEM_TO_DEV) ?
> >+		achan->slave.dst_maxburst :
> >+		achan->slave.src_maxburst;
> >+
> >+	if (!burst || burst > ADM_MAX_XFER)
> >+		burst = ADM_MAX_XFER;
> >+
> >+	/* if using flow control, validate burst and crci values */
> >+	if (achan->slave.device_fc) {
> >+
> >+		blk_size = adm_get_blksize(burst);
> >+		if (blk_size < 0) {
> >+			dev_err(adev->dev, "invalid burst value w/ crci: %d\n",
> >+				burst);
> >+			return ERR_PTR(-EINVAL);
> >+		}
> >+
> >+		crci = achan->slave.slave_id;
> >+		if (!(crci & 0xf)) {
> 
> This check isn't sufficient for the crci to lie between 1 and 15.
> slave_id passed as, say, 0xf5, will be valid.

True.  The real range would be 0x10->0x1F, as bit 8 denotes the mux setting.
I'll put in a check here.

> 
> <snip>
> 
> 
> >+/**
> >+ * adm_dma_irq - irq handler for ADM controller
> >+ * @irq: IRQ of interrupt
> >+ * @data: callback data
> >+ *
> >+ * IRQ handler for the bam controller
> >+ */
> >+static irqreturn_t adm_dma_irq(int irq, void *data)
> >+{
> >+	struct adm_device *adev = data;
> >+	u32 srcs, i;
> >+	struct adm_async_desc *async_desc;
> >+	unsigned long flags;
> >+
> >+	srcs = readl_relaxed(adev->regs +
> >+			HI_SEC_DOMAIN_IRQ_STATUS(adev->ee));
> >+
> >+	for (i = 0; i < 16; i++) {
> 
> we could use adev->num_channels here instead of 16.

Right.  will fix.


> <snip>
> 
> >+
> >+static int adm_dma_probe(struct platform_device *pdev)
> >+{
> >+	struct adm_device *adev;
> >+	struct resource *iores;
> >+	int ret;
> >+	u32 i;
> >+
> >+	adev = devm_kzalloc(&pdev->dev, sizeof(*adev), GFP_KERNEL);
> >+	if (!adev)
> >+		return -ENOMEM;
> >+
> >+	adev->dev = &pdev->dev;
> >+
> >+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	adev->regs = devm_ioremap_resource(&pdev->dev, iores);
> >+	if (IS_ERR(adev->regs))
> >+		return PTR_ERR(adev->regs);
> >+
> >+	adev->irq = platform_get_irq(pdev, 0);
> >+	if (adev->irq < 0)
> >+		return adev->irq;
> >+
> >+	ret = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &adev->ee);
> >+	if (ret) {
> >+		dev_err(adev->dev, "Execution environment unspecified\n");
> >+		return ret;
> >+	}
> >+
> >+	adev->core_clk = devm_clk_get(adev->dev, "core");
> >+	if (IS_ERR(adev->core_clk))
> >+		return PTR_ERR(adev->core_clk);
> >+
> >+	ret = clk_prepare_enable(adev->core_clk);
> >+	if (ret) {
> >+		dev_err(adev->dev, "failed to prepare/enable core clock\n");
> >+		return ret;
> >+	}
> >+
> >+	adev->iface_clk = devm_clk_get(adev->dev, "iface");
> >+	if (IS_ERR(adev->iface_clk))
> >+		return PTR_ERR(adev->iface_clk);
> >+
> 
> An error here or below would leave core_clk on.

Will fix, thanks.

> >+		dev_err(adev->dev, "failed to get ADM0 C2 reset\n");
> >+		return PTR_ERR(adev->c2_reset);
> >+	}
> 
> All the devm_reset_control_get() failures should disable the clocks too.

Thanks, I'll fix that up.


-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

