Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3JaVq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:46:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36568 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3JaVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:46:25 -0400
Date: Thu, 31 Oct 2013 16:46:21 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2] dmaengine: add msm bam dma driver
Message-ID: <20131031214621.GC24406@agross>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
 <1382732643-8184-2-git-send-email-agross@codeaurora.org>
 <20131031165948.GM18788@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031165948.GM18788@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 10:29:48PM +0530, Vinod Koul wrote:
> On Fri, Oct 25, 2013 at 03:24:02PM -0500, Andy Gross wrote:
> 
> This should be sent to dmaengine@vger.kernel.org
 
I'll add the list when I send the second iteration or should I send it over mid
stream?

> > Add the DMA engine driver for the MSM Bus Access Manager (BAM) DMA controller
> > found in the MSM 8x74 platforms.
> > 
> > Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> > channel provides a uni-directional data transfer engine that is capable of
> > transferring data between the peripheral and system memory (System mode) or
> > between two peripherals (BAM2BAM).
> > 
> > The initial release of this driver only supports slave transfers between
> > peripherals and system memory.
> > 
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > +/*
> > + * bam_alloc_chan - Allocate channel resources for DMA channel.
> > + * @chan: specified channel
> > + *
> > + * This function allocates the FIFO descriptor memory and resets the channel
> > + */
> > +static int bam_alloc_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	u32 val;
> > +	union bam_pipe_ctrl pctrl;
> > +
> > +	/* check for channel activity */
> > +	pctrl.value = ioread32(bdev->regs + BAM_P_CTRL(bchan->id));
> > +	if (pctrl.bits.p_en) {
> > +		dev_err(bdev->dev, "channel already active\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* allocate FIFO descriptor space */
> > +	bchan->fifo_virt = (struct bam_desc_hw *)dma_alloc_coherent(bdev->dev,
> > +				BAM_DESC_FIFO_SIZE, &bchan->fifo_phys,
> > +				GFP_KERNEL);
> > +
> > +	if (!bchan->fifo_virt) {
> > +		dev_err(bdev->dev, "Failed to allocate descriptor fifo\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* reset channel */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	/* configure fifo address/size in bam channel registers */
> > +	iowrite32(bchan->fifo_phys, bdev->regs +
> > +			BAM_P_DESC_FIFO_ADDR(bchan->id));
> > +	iowrite32(BAM_DESC_FIFO_SIZE, bdev->regs +
> > +			BAM_P_FIFO_SIZES(bchan->id));
> > +
> > +	/* unmask and enable interrupts for defined EE, bam and error irqs */
> > +	iowrite32(BAM_IRQ_MSK, bdev->regs + BAM_IRQ_SRCS_EE(bchan->ee));
> > +
> > +	/* enable the per pipe interrupts, enable EOT and INT irqs */
> > +	iowrite32(P_DEFAULT_IRQS_EN, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> > +
> > +	/* unmask the specific pipe and EE combo */
> > +	val = ioread32(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +	val |= 1 << bchan->id;
> > +	iowrite32(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +
> > +	/* set fixed direction and mode, then enable channel */
> I was going to question why you are doing hw specfic stuff in alloc channel but
> now why do you enable seems to be a bigger question in mind?

The fifo_virt is used to store the hardware descriptors that are used directly
by the dma controller.  I have to at least fill in the descriptor FIFO address
and size and reset the channel to clear the fifo offset inside the hardware.
After reset the internal fifo offset is 0.  And every subsequent transaction
increments this.  That is how it knows which descriptors to work on inside the
descriptor fifo memory.

I can definitely defer the rest of hte h/w interactions until the point that I
need to actually kick off the dma controller.


> > +	pctrl.value = 0;
> > +	pctrl.bits.p_direction =
> > +		(bchan->bam_slave.slave.direction == DMA_DEV_TO_MEM) ?
> > +			BAM_PIPE_PRODUCER : BAM_PIPE_CONSUMER;
> > +	pctrl.bits.p_sys_mode = BAM_PIPE_MODE_SYSTEM;
> > +	pctrl.bits.p_en = 1;
> > +
> > +	iowrite32(pctrl.value, bdev->regs + BAM_P_CTRL(bchan->id));
> > +
> > +	/* set desc threshold */
> > +	/* do bookkeeping for tracking used EEs, used during IRQ handling */
> > +	set_bit(bchan->ee, &bdev->enabled_ees);
> > +
> > +	bchan->head = 0;
> > +	bchan->tail = 0;
> > +
> > +	return 0;
> You said you are going to allocate descriptors so right thing would be return
> number of allocated desc here!

OK, I missed that.

> > +}
> > +
> > +/*
> > + * bam_free_chan - Frees dma resources associated with specific channel
> > + * @chan: specified channel
> > + *
> > + * Free the allocated fifo descriptor memory and channel resources
> > + *
> > + */
> > +static void bam_free_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	u32 val;
> > +
> Shouldn't you check if channel is busy?
> 

Yes, I'll add that in.  With no return code, how useful is this to the caller?


> > +	/* reset channel */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	dma_free_coherent(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
> > +				bchan->fifo_phys);
> > +
> > +	/* mask irq for pipe/channel */
> > +	val = ioread32(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +	val &= ~(1 << bchan->id);
> > +	iowrite32(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +
> > +	/* disable irq */
> > +	iowrite32(0, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> > +
> > +	clear_bit(bchan->ee, &bdev->enabled_ees);
> > +}
> > +
> > +/*
> > + * bam_slave_config - set slave configuration for channel
> > + * @chan: dma channel
> > + * @cfg: slave configuration
> > + *
> > + * Sets slave configuration for channel
> > + * Only allow setting direction once.  BAM channels are unidirectional
> > + * and the direction is set in hardware.
> > + *
> > + */
> > +static void bam_slave_config(struct bam_chan *bchan,
> > +		struct bam_dma_slave_config *bcfg)
> 
> > +{
> > +	struct bam_device *bdev = bchan->device;
> > +
> > +	bchan->bam_slave.desc_threshold = bcfg->desc_threshold;
> what does the desc_threshold mean?
 
The desc threshhold determines the minimum number of bytes of descriptor that
causes a write event to be communicated to the peripheral.  I default to 4 bytes
(1 descriptor), but this is configurable through the DMA_SLAVE_CONFIG interface
using the extended slave_config structure.

> > +
> > +	/* set desc threshold */
> > +	iowrite32(bcfg->desc_threshold, bdev->regs + BAM_DESC_CNT_TRSHLD);
> > +}
> > +
> > +/*
> > + * bam_start_dma - loads up descriptors and starts dma
> > + * @chan: dma channel
> > + *
> > + * Loads descriptors into descriptor fifo and starts dma controller
> > + *
> > + * NOTE: Must hold channel lock
> > +*/
> > +static void bam_start_dma(struct bam_chan *bchan)
> > +{
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_async_desc *async_desc, *_adesc;
> > +	u32 curr_len, val;
> > +	u32 num_processed = 0;
> > +
> > +	if (list_empty(&bchan->pending))
> > +		return;
> > +
> > +	curr_len = (bchan->head <= bchan->tail) ?
> > +			bchan->tail - bchan->head :
> > +			MAX_DESCRIPTORS - bchan->head + bchan->tail;
> > +
> > +	list_for_each_entry_safe(async_desc, _adesc, &bchan->pending, node) {
> > +
> > +		/* bust out if we are out of room */
> > +		if (async_desc->num_desc + curr_len > MAX_DESCRIPTORS)
> > +			break;
> > +
> > +		/* copy descriptors into fifo */
> > +		if (bchan->tail + async_desc->num_desc > MAX_DESCRIPTORS) {
> > +			u32 partial = MAX_DESCRIPTORS - bchan->tail;
> > +
> > +			memcpy(&bchan->fifo_virt[bchan->tail], async_desc->desc,
> > +				partial * sizeof(struct bam_desc_hw));
> > +			memcpy(bchan->fifo_virt, &async_desc->desc[partial],
> > +				(async_desc->num_desc - partial) *
> > +					sizeof(struct bam_desc_hw));
> memcpy for device memory copy?

My initial thought was that I needed to wait until now to fill in the
descriptors on the fifo that was allocated.  The fifo memory is accessed from
the dma controller.  The controller just manages an internal offset that rolls
over based on the size of the configured fifo memory.  I was keeping the
descriptors on hand until I needed to program them into the fifo memory, hence
the copy.

> > +		} else {
> > +			memcpy(&bchan->fifo_virt[bchan->tail], async_desc->desc,
> > +				async_desc->num_desc *
> > +				sizeof(struct bam_desc_hw));
> > +		}
> > +
> > +		num_processed++;
> > +		bchan->tail += async_desc->num_desc;
> > +		bchan->tail %= MAX_DESCRIPTORS;
> > +		curr_len += async_desc->num_desc;
> > +
> > +		list_move_tail(&async_desc->node, &bchan->active);
> > +	}
> > +
> > +	/* bail if we didn't queue anything to the active queue */
> > +	if (!num_processed)
> > +		return;
> > +
> > +	async_desc = list_first_entry(&bchan->active, struct bam_async_desc,
> > +			node);
> > +
> > +	val = ioread32(bdev->regs + BAM_P_SW_OFSTS(bchan->id));
> > +	val &= P_SW_OFSTS_MASK;
> > +
> > +	/* kick off dma by forcing a write event to the pipe */
> > +	iowrite32((bchan->tail * sizeof(struct bam_desc_hw)),
> > +			bdev->regs + BAM_P_EVNT_REG(bchan->id));
> > +}
> > +
> > +/*
> > + * bam_tx_submit - Adds transaction to channel pending queue
> > + * @tx: transaction to queue
> > + *
> > + * Adds dma transaction to pending queue for channel
> > + *
> > +*/
> > +static dma_cookie_t bam_tx_submit(struct dma_async_tx_descriptor *tx)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(tx->chan);
> > +	struct bam_async_desc *desc = to_bam_async_desc(tx);
> > +	dma_cookie_t cookie;
> > +
> > +	spin_lock_bh(&bchan->lock);
> > +
> > +	cookie = dma_cookie_assign(tx);
> > +	list_add_tail(&desc->node, &bchan->pending);
> > +
> > +	spin_unlock_bh(&bchan->lock);
> > +
> > +	return cookie;
> > +}
> Okay you are *NOT* using virt-dma layer, all this can be removed if you do that,
> this is similar to what vchan_tx_submit() does!
>

I'll look into reworking and utilizing the virt-dma layer.
 
> > +
> > +/*
> > + * bam_prep_slave_sg - Prep slave sg transaction
> > + *
> > + * @chan: dma channel
> > + * @sgl: scatter gather list
> > + * @sg_len: length of sg
> > + * @direction: DMA transfer direction
> > + * @flags: DMA flags
> > + * @context: transfer context (unused)
> > + */
> > +static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
> > +	struct scatterlist *sgl, unsigned int sg_len,
> > +	enum dma_transfer_direction direction, unsigned long flags,
> > +	void *context)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_async_desc *async_desc = NULL;
> > +	struct scatterlist *sg;
> > +	u32 i;
> > +	struct bam_desc_hw *desc;
> > +
> > +
> > +	if (!is_slave_direction(direction)) {
> > +		dev_err(bdev->dev, "invalid dma direction\n");
> > +		goto err_out;
> > +	}
> > +
> > +	/* direction has to match pipe configuration from the slave config */
> > +	if (direction != bchan->bam_slave.slave.direction) {
> > +		dev_err(bdev->dev,
> > +				"trans does not match channel configuration\n");
> > +		goto err_out;
> > +	}
> > +
> > +	/* make sure number of descriptors will fit within the fifo */
> > +	if (sg_len > MAX_DESCRIPTORS) {
> > +		dev_err(bdev->dev, "not enough fifo descriptor space\n");
> > +		goto err_out;
> > +	}
> what prevents you from assigning more virtual descriptors to this case and then
> submit those after HW descriptors are done.

I hadn't considered the virtual descriptors.  I'll see what I can do to utilize
that and rework this.  I can see the virtual descriptors simplifying this a good
bit.

> > +
> > +	/* allocate enough room to accomodate the number of entries */
> > +	async_desc = kzalloc(sizeof(*async_desc) +
> > +			(sg_len * sizeof(struct bam_desc_hw)), GFP_KERNEL);
> this cna be called from non sleepy context and the recommedation is to use
> GFP_NOWAIT for memory allocation
> 

I missed this.  I'll change it.

> > +static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> > +	unsigned long arg)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_dma_slave_config *bconfig;
> > +	int ret = 0;
> > +
> > +	switch (cmd) {
> > +	case DMA_PAUSE:
> > +		spin_lock_bh(&bchan->lock);
> > +		iowrite32(1, bdev->regs + BAM_P_HALT(bchan->id));
> > +		spin_unlock_bh(&bchan->lock);
> > +		break;
> > +	case DMA_RESUME:
> > +		spin_lock_bh(&bchan->lock);
> > +		iowrite32(0, bdev->regs + BAM_P_HALT(bchan->id));
> > +		spin_unlock_bh(&bchan->lock);
> > +		break;
> > +	case DMA_TERMINATE_ALL:
> > +		bam_dma_terminate_all(chan);
> > +		break;
> > +	case DMA_SLAVE_CONFIG:
> > +		bconfig = (struct bam_dma_slave_config *)arg;
> > +		bam_slave_config(bchan, bconfig);
> DMA_SLAVE_CONFIG expects arg as struct dma_slave_config, not this. Pls dont
> voilate APIs

So for extended slave_config structures, the caller needs to send in a ptr to
the dma_slave_config and then I can determine the bam_dma_slave_config.  Will
fix.

> > +		break;
> > +	default:
> > +		ret = -EIO;
> I would expect -ENXIO here!
> 

OK.

> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * bam_tx_status - returns status of transaction
> > + * @chan: dma channel
> > + * @cookie: transaction cookie
> > + * @txstate: DMA transaction state
> > + *
> > + * Return status of dma transaction
> > + */
> > +static enum dma_status bam_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> > +		struct dma_tx_state *txstate)
> > +{
> > +	return dma_cookie_status(chan, cookie, txstate);
> hmmm, this wont work in many cases for slave. For example if you try to get this
> working with audio you need to provide the residue values.
> The results you are providing here will not be useful, so I would recommedn
> fixing it
> 

Ok so in this case I'd need to read where I am in the descriptor chain and
calculate the residual.  That shouldn't be a problem.

> > +
> > +static int bam_dma_probe(struct platform_device *pdev)
> > +{
> > +	struct bam_device *bdev;
> > +	int err, i;
> > +
> > +	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
> devm_ pls
>

will fix.

> > +	if (!bdev) {
> > +		dev_err(&pdev->dev, "insufficient memory for private data\n");
> > +		err = -ENOMEM;
> > +		goto err_no_bdev;
> > +	}
> > +
> > +	bdev->dev = &pdev->dev;
> > +	dev_set_drvdata(bdev->dev, bdev);
> > +
> > +	bdev->regs = of_iomap(pdev->dev.of_node, 0);
> > +	if (!bdev->regs) {
> > +		dev_err(bdev->dev, "unable to ioremap base\n");
> > +		err = -ENOMEM;
> > +		goto err_free_bamdev;
> > +	}
> > +
> > +	bdev->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> > +	if (bdev->irq == NO_IRQ) {
> > +		dev_err(bdev->dev, "unable to map irq\n");
> > +		err = -EINVAL;
> > +		goto err_unmap_mem;
> > +	}
> > +
> > +	bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
> > +	if (IS_ERR(bdev->bamclk)) {
> > +		err = PTR_ERR(bdev->bamclk);
> > +		goto err_free_irq;
> > +	}
> > +
> > +	err = clk_prepare_enable(bdev->bamclk);
> > +	if (err) {
> > +		dev_err(bdev->dev, "failed to prepare/enable clock");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	err = request_irq(bdev->irq, &bam_dma_irq, IRQF_TRIGGER_HIGH, "bam_dma",
> > +				bdev);
> > +	if (err) {
> > +		dev_err(bdev->dev, "error requesting irq\n");
> > +		err = -EINVAL;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	if (bam_init(bdev)) {
> > +		dev_err(bdev->dev, "cannot initialize bam device\n");
> > +		err = -EINVAL;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	bdev->channels = kzalloc(sizeof(*bdev->channels) * bdev->num_channels,
> > +				GFP_KERNEL);
> > +
> > +	if (!bdev->channels) {
> > +		dev_err(bdev->dev, "unable to allocate channels\n");
> > +		err = -ENOMEM;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* allocate and initialize channels */
> > +	INIT_LIST_HEAD(&bdev->common.channels);
> > +
> > +	for (i = 0; i < bdev->num_channels; i++)
> > +		bam_channel_init(bdev, &bdev->channels[i], i);
> > +
> > +	/* set max dma segment size */
> > +	bdev->common.dev = bdev->dev;
> > +	bdev->common.dev->dma_parms = &bdev->dma_parms;
> > +	if (dma_set_max_seg_size(bdev->common.dev, BAM_MAX_DATA_SIZE)) {
> > +		dev_err(bdev->dev, "cannot set maximum segment size\n");
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* set capabilities */
> > +	dma_cap_zero(bdev->common.cap_mask);
> > +	dma_cap_set(DMA_SLAVE, bdev->common.cap_mask);
> > +
> > +	/* initialize dmaengine apis */
> > +	bdev->common.device_alloc_chan_resources = bam_alloc_chan;
> > +	bdev->common.device_free_chan_resources = bam_free_chan;
> > +	bdev->common.device_prep_slave_sg = bam_prep_slave_sg;
> > +	bdev->common.device_control = bam_control;
> > +	bdev->common.device_issue_pending = bam_issue_pending;
> > +	bdev->common.device_tx_status = bam_tx_status;
> > +	bdev->common.dev = bdev->dev;
> > +
> > +	dma_async_device_register(&bdev->common);
> > +
> > +	if (pdev->dev.of_node) {
> > +		err = of_dma_controller_register(pdev->dev.of_node,
> > +				bam_dma_xlate, &bdev->common);
> > +
> > +		if (err) {
> > +			dev_err(bdev->dev, "failed to register of_dma\n");
> > +			goto err_unregister_dma;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +err_unregister_dma:
> > +	dma_async_device_unregister(&bdev->common);
> > +err_free_irq:
> > +	free_irq(bdev->irq, bdev);
> > +err_disable_clk:
> > +	clk_disable_unprepare(bdev->bamclk);
> > +err_unmap_mem:
> > +	iounmap(bdev->regs);
> > +err_free_bamdev:
> > +	if (bdev)
> > +		kfree(bdev->channels);
> > +	kfree(bdev);
> > +err_no_bdev:
> you need to get yourslef introduced with devm_ friends to ease this part!
> 
> Overall I think driver needs to bit more plumbing and also needs to use the
> virt-dma so that bunch of work already done is not redefined here.

I'll rework for comments and see how I can incorporate the virt-dma.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
