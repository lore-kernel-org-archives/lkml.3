Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAQOhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:37:18 -0500
Received: from plane.gmane.org ([80.91.229.3]:52474 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQOhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:37:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philip Balister <philip@balister.org>
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
Date: Fri, 17 Jan 2014 09:36:54 -0500
Message-ID: <52D94006.2090104@balister.org>
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com> <1389894803-4147-2-git-send-email-sthokal@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-171-41-155.ronkva.east.verizon.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
In-Reply-To: <1389894803-4147-2-git-send-email-sthokal@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 12:53 PM, Srikanth Thokala wrote:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
> and write channel operation.
>

[snip]

> +/**
> + * xilinx_vdma_start - Start VDMA channel
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_start(struct xilinx_vdma_chan *chan)
> +{
> +	int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +
> +	vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RUNSTOP);
> +
> +	/* Wait for the hardware to start */
> +	while (loop)


loop-- ?

Philip

> +		if (!(vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +		      XILINX_VDMA_DMASR_HALTED))
> +			break;
> +
> +	if (!loop) {
> +		dev_err(chan->dev, "Cannot start channel %p: %x\n",
> +			chan, vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +
> +		chan->err = true;
> +	}
> +
> +	return;
> +}
> +
> +/**
> + * xilinx_vdma_start_transfer - Starts VDMA transfer
> + * @chan: Driver specific channel struct pointer
> + */
> +static void xilinx_vdma_start_transfer(struct xilinx_vdma_chan *chan)
> +{
> +	struct xilinx_vdma_config *config = &chan->config;
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	unsigned long flags;
> +	u32 reg;
> +	struct xilinx_vdma_tx_segment *head, *tail = NULL;
> +
> +	if (chan->err)
> +		return;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	/* There's already an active descriptor, bail out. */
> +	if (chan->active_desc)
> +		goto out_unlock;
> +
> +	if (list_empty(&chan->pending_list))
> +		goto out_unlock;
> +
> +	desc = list_first_entry(&chan->pending_list,
> +				struct xilinx_vdma_tx_descriptor, node);
> +
> +	/* If it is SG mode and hardware is busy, cannot submit */
> +	if (chan->has_sg && xilinx_vdma_is_running(chan) &&
> +	    !xilinx_vdma_is_idle(chan)) {
> +		dev_dbg(chan->dev, "DMA controller still busy\n");
> +		goto out_unlock;
> +	}
> +
> +	if (chan->err)
> +		goto out_unlock;
> +
> +	/*
> +	 * If hardware is idle, then all descriptors on the running lists are
> +	 * done, start new transfers
> +	 */
> +	if (chan->has_sg) {
> +		head = list_first_entry(&desc->segments,
> +					struct xilinx_vdma_tx_segment, node);
> +		tail = list_entry(desc->segments.prev,
> +				  struct xilinx_vdma_tx_segment, node);
> +
> +		vdma_ctrl_write(chan, XILINX_VDMA_REG_CURDESC, head->phys);
> +	}
> +
> +	/* Configure the hardware using info in the config structure */
> +	reg = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
> +
> +	if (config->frm_cnt_en)
> +		reg |= XILINX_VDMA_DMACR_FRAMECNT_EN;
> +	else
> +		reg &= ~XILINX_VDMA_DMACR_FRAMECNT_EN;
> +
> +	/*
> +	 * With SG, start with circular mode, so that BDs can be fetched.
> +	 * In direct register mode, if not parking, enable circular mode
> +	 */
> +	if (chan->has_sg || !config->park)
> +		reg |= XILINX_VDMA_DMACR_CIRC_EN;
> +
> +	if (config->park)
> +		reg &= ~XILINX_VDMA_DMACR_CIRC_EN;
> +
> +	vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, reg);
> +
> +	if (config->park && (config->park_frm >= 0) &&
> +			(config->park_frm < chan->num_frms)) {
> +		if (chan->direction == DMA_MEM_TO_DEV)
> +			vdma_write(chan, XILINX_VDMA_REG_PARK_PTR,
> +				config->park_frm <<
> +					XILINX_VDMA_PARK_PTR_RD_REF_SHIFT);
> +		else
> +			vdma_write(chan, XILINX_VDMA_REG_PARK_PTR,
> +				config->park_frm <<
> +					XILINX_VDMA_PARK_PTR_WR_REF_SHIFT);
> +	}
> +
> +	/* Start the hardware */
> +	xilinx_vdma_start(chan);
> +
> +	if (chan->err)
> +		goto out_unlock;
> +
> +	/* Start the transfer */
> +	if (chan->has_sg) {
> +		vdma_ctrl_write(chan, XILINX_VDMA_REG_TAILDESC, tail->phys);
> +	} else {
> +		struct xilinx_vdma_tx_segment *segment;
> +		int i = 0;
> +
> +		list_for_each_entry(segment, &desc->segments, node)
> +			vdma_desc_write(chan,
> +					XILINX_VDMA_REG_START_ADDRESS(i++),
> +					segment->hw.buf_addr);
> +
> +		vdma_desc_write(chan, XILINX_VDMA_REG_HSIZE, config->hsize);
> +		vdma_desc_write(chan, XILINX_VDMA_REG_FRMDLY_STRIDE,
> +				(config->frm_dly <<
> +				 XILINX_VDMA_FRMDLY_STRIDE_FRMDLY_SHIFT) |
> +				(config->stride <<
> +				 XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT));
> +		vdma_desc_write(chan, XILINX_VDMA_REG_VSIZE, config->vsize);
> +	}
> +
> +	list_del(&desc->node);
> +	chan->active_desc = desc;
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/**
> + * xilinx_vdma_issue_pending - Issue pending transactions
> + * @dchan: DMA channel
> + */
> +static void xilinx_vdma_issue_pending(struct dma_chan *dchan)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
> +	xilinx_vdma_start_transfer(chan);
> +}
> +
> +/**
> + * xilinx_vdma_complete_descriptor - Mark the active descriptor as complete
> + * @chan : xilinx DMA channel
> + *
> + * CONTEXT: hardirq
> + */
> +static void xilinx_vdma_complete_descriptor(struct xilinx_vdma_chan *chan)
> +{
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	desc = chan->active_desc;
> +	if (!desc) {
> +		dev_dbg(chan->dev, "no running descriptors\n");
> +		goto out_unlock;
> +	}
> +
> +	list_add_tail(&desc->node, &chan->done_list);
> +
> +	/* Update the completed cookie and reset the active descriptor. */
> +	chan->completed_cookie = desc->async_tx.cookie;
> +	chan->active_desc = NULL;
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/**
> + * xilinx_vdma_reset - Reset VDMA channel
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_reset(struct xilinx_vdma_chan *chan)
> +{
> +	int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +	u32 tmp;
> +
> +	vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RESET);
> +
> +	tmp = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
> +		XILINX_VDMA_DMACR_RESET;
> +
> +	/* Wait for the hardware to finish reset */
> +	while (loop-- && tmp)
> +		tmp = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
> +			XILINX_VDMA_DMACR_RESET;
> +
> +	if (!loop) {
> +		dev_err(chan->dev, "reset timeout, cr %x, sr %x\n",
> +			vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR),
> +			vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +		return -ETIMEDOUT;
> +	}
> +
> +	chan->err = false;
> +
> +	return 0;
> +}
> +
> +/**
> + * xilinx_vdma_chan_reset - Reset VDMA channel and enable interrupts
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_chan_reset(struct xilinx_vdma_chan *chan)
> +{
> +	int err;
> +
> +	/* Reset VDMA */
> +	err = xilinx_vdma_reset(chan);
> +	if (err)
> +		return err;
> +
> +	/* Enable interrupts */
> +	vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR,
> +		      XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +	return 0;
> +}
> +
> +/**
> + * xilinx_vdma_irq_handler - VDMA Interrupt handler
> + * @irq: IRQ number
> + * @data: Pointer to the Xilinx VDMA channel structure
> + *
> + * Return: IRQ_HANDLED/IRQ_NONE
> + */
> +static irqreturn_t xilinx_vdma_irq_handler(int irq, void *data)
> +{
> +	struct xilinx_vdma_chan *chan = data;
> +	u32 status;
> +
> +	/* Read the status and ack the interrupts. */
> +	status = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR);
> +	if (!(status & XILINX_VDMA_DMAXR_ALL_IRQ_MASK))
> +		return IRQ_NONE;
> +
> +	vdma_ctrl_write(chan, XILINX_VDMA_REG_DMASR,
> +			status & XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +	if (status & XILINX_VDMA_DMASR_ERR_IRQ) {
> +		/*
> +		 * An error occurred. If C_FLUSH_ON_FSYNC is enabled and the
> +		 * error is recoverable, ignore it. Otherwise flag the error.
> +		 *
> +		 * Only recoverable errors can be cleared in the DMASR register,
> +		 * make sure not to write to other error bits to 1.
> +		 */
> +		u32 errors = status & XILINX_VDMA_DMASR_ALL_ERR_MASK;
> +		vdma_ctrl_write(chan, XILINX_VDMA_REG_DMASR,
> +				errors & XILINX_VDMA_DMASR_ERR_RECOVER_MASK);
> +
> +		if (!chan->flush_on_fsync ||
> +		    (errors & ~XILINX_VDMA_DMASR_ERR_RECOVER_MASK)) {
> +			dev_err(chan->dev,
> +				"Channel %p has errors %x, cdr %x tdr %x\n",
> +				chan, errors,
> +				vdma_ctrl_read(chan, XILINX_VDMA_REG_CURDESC),
> +				vdma_ctrl_read(chan, XILINX_VDMA_REG_TAILDESC));
> +			chan->err = true;
> +		}
> +	}
> +
> +	if (status & XILINX_VDMA_DMASR_DLY_CNT_IRQ) {
> +		/*
> +		 * Device takes too long to do the transfer when user requires
> +		 * responsiveness.
> +		 */
> +		dev_dbg(chan->dev, "Inter-packet latency too long\n");
> +	}
> +
> +	if (status & XILINX_VDMA_DMASR_FRM_CNT_IRQ) {
> +		xilinx_vdma_complete_descriptor(chan);
> +		xilinx_vdma_start_transfer(chan);
> +	}
> +
> +	tasklet_schedule(&chan->tasklet);
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * xilinx_vdma_tx_submit - Submit DMA transaction
> + * @tx: Async transaction descriptor
> + *
> + * Return: cookie value on success and failure value on error
> + */
> +static dma_cookie_t xilinx_vdma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct xilinx_vdma_tx_descriptor *desc = to_vdma_tx_descriptor(tx);
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(tx->chan);
> +	struct xilinx_vdma_tx_segment *segment;
> +	dma_cookie_t cookie;
> +	unsigned long flags;
> +	int err;
> +
> +	if (chan->err) {
> +		/*
> +		 * If reset fails, need to hard reset the system.
> +		 * Channel is no longer functional
> +		 */
> +		err = xilinx_vdma_chan_reset(chan);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	/* Assign cookies to all of the segments that make up this transaction.
> +	 * Use the cookie of the last segment as the transaction cookie.
> +	 */
> +	cookie = chan->cookie;
> +
> +	list_for_each_entry(segment, &desc->segments, node) {
> +		if (cookie < DMA_MAX_COOKIE)
> +			cookie++;
> +		else
> +			cookie = DMA_MIN_COOKIE;
> +
> +		segment->cookie = cookie;
> +	}
> +
> +	tx->cookie = cookie;
> +	chan->cookie = cookie;
> +
> +	/* Append the transaction to the pending transactions queue. */
> +	list_add_tail(&desc->node, &chan->pending_list);
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	return cookie;
> +}
> +
> +/**
> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
> + * @dchan: DMA channel
> + * @sgl: scatterlist to transfer to/from
> + * @sg_len: number of entries in @sgl
> + * @dir: DMA direction
> + * @flags: transfer ack flags
> + * @context: unused
> + *
> + * Return: Async transaction descriptor on success and NULL on failure
> + */
> +static struct dma_async_tx_descriptor *
> +xilinx_vdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
> +			  unsigned int sg_len, enum dma_transfer_direction dir,
> +			  unsigned long flags, void *context)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	struct xilinx_vdma_tx_segment *segment;
> +	struct xilinx_vdma_tx_segment *prev = NULL;
> +	struct scatterlist *sg;
> +	int i;
> +
> +	if (chan->direction != dir || sg_len == 0)
> +		return NULL;
> +
> +	/* Enforce one sg entry for one frame. */
> +	if (sg_len != chan->num_frms) {
> +		dev_err(chan->dev,
> +		"number of entries %d not the same as num stores %d\n",
> +			sg_len, chan->num_frms);
> +		return NULL;
> +	}
> +
> +	/* Allocate a transaction descriptor. */
> +	desc = xilinx_vdma_alloc_tx_descriptor(chan);
> +	if (!desc)
> +		return NULL;
> +
> +	dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
> +	desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
> +	desc->async_tx.cookie = 0;
> +	async_tx_ack(&desc->async_tx);
> +
> +	/* Build the list of transaction segments. */
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		struct xilinx_vdma_desc_hw *hw;
> +
> +		/* Allocate the link descriptor from DMA pool */
> +		segment = xilinx_vdma_alloc_tx_segment(chan);
> +		if (!segment)
> +			goto error;
> +
> +		/* Fill in the hardware descriptor */
> +		hw = &segment->hw;
> +		hw->buf_addr = sg_dma_address(sg);
> +		hw->vsize = chan->config.vsize;
> +		hw->hsize = chan->config.hsize;
> +		hw->stride = (chan->config.frm_dly <<
> +			      XILINX_VDMA_FRMDLY_STRIDE_FRMDLY_SHIFT) |
> +			     (chan->config.stride <<
> +			      XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT);
> +		if (prev)
> +			prev->hw.next_desc = segment->phys;
> +
> +		/* Insert the segment into the descriptor segments list. */
> +		list_add_tail(&segment->node, &desc->segments);
> +
> +		prev = segment;
> +	}
> +
> +	/* Link the last hardware descriptor with the first. */
> +	segment = list_first_entry(&desc->segments,
> +				   struct xilinx_vdma_tx_segment, node);
> +	prev->hw.next_desc = segment->phys;
> +
> +	return &desc->async_tx;
> +
> +error:
> +	xilinx_vdma_free_tx_descriptor(chan, desc);
> +	return NULL;
> +}
> +
> +/**
> + * xilinx_vdma_terminate_all - Halt the channel and free descriptors
> + * @chan: Driver specific VDMA Channel pointer
> + */
> +static void xilinx_vdma_terminate_all(struct xilinx_vdma_chan *chan)
> +{
> +	/* Halt the DMA engine */
> +	xilinx_vdma_halt(chan);
> +
> +	/* Remove and free all of the descriptors in the lists */
> +	xilinx_vdma_free_descriptors(chan);
> +}
> +
> +/**
> + * xilinx_vdma_slave_config - Configure VDMA channel
> + * Run-time configuration for Axi VDMA, supports:
> + * . halt the channel
> + * . configure interrupt coalescing and inter-packet delay threshold
> + * . start/stop parking
> + * . enable genlock
> + * . set transfer information using config struct
> + *
> + * @chan: Driver specific VDMA Channel pointer
> + * @cfg: Channel configuration pointer
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_slave_config(struct xilinx_vdma_chan *chan,
> +				    struct xilinx_vdma_config *cfg)
> +{
> +	u32 dmacr;
> +
> +	if (cfg->reset)
> +		return xilinx_vdma_chan_reset(chan);
> +
> +	dmacr = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
> +
> +	/* If vsize is -1, it is park-related operations */
> +	if (cfg->vsize == -1) {
> +		if (cfg->park)
> +			dmacr &= ~XILINX_VDMA_DMACR_CIRC_EN;
> +		else
> +			dmacr |= XILINX_VDMA_DMACR_CIRC_EN;
> +
> +		vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +		return 0;
> +	}
> +
> +	/* If hsize is -1, it is interrupt threshold settings */
> +	if (cfg->hsize == -1) {
> +		if (cfg->coalesc <= XILINX_VDMA_DMACR_FRAME_COUNT_MAX) {
> +			dmacr &= ~XILINX_VDMA_DMACR_FRAME_COUNT_MASK;
> +			dmacr |= cfg->coalesc <<
> +				 XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT;
> +			chan->config.coalesc = cfg->coalesc;
> +		}
> +
> +		if (cfg->delay <= XILINX_VDMA_DMACR_DELAY_MAX) {
> +			dmacr &= ~XILINX_VDMA_DMACR_DELAY_MASK;
> +			dmacr |= cfg->delay << XILINX_VDMA_DMACR_DELAY_SHIFT;
> +			chan->config.delay = cfg->delay;
> +		}
> +
> +		vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +		return 0;
> +	}
> +
> +	/* Transfer information */
> +	chan->config.vsize = cfg->vsize;
> +	chan->config.hsize = cfg->hsize;
> +	chan->config.stride = cfg->stride;
> +	chan->config.frm_dly = cfg->frm_dly;
> +	chan->config.park = cfg->park;
> +
> +	/* genlock settings */
> +	chan->config.gen_lock = cfg->gen_lock;
> +	chan->config.master = cfg->master;
> +
> +	if (cfg->gen_lock && chan->genlock) {
> +		dmacr |= XILINX_VDMA_DMACR_GENLOCK_EN;
> +		dmacr |= cfg->master << XILINX_VDMA_DMACR_MASTER_SHIFT;
> +	}
> +
> +	chan->config.frm_cnt_en = cfg->frm_cnt_en;
> +	if (cfg->park)
> +		chan->config.park_frm = cfg->park_frm;
> +	else
> +		chan->config.park_frm = -1;
> +
> +	chan->config.coalesc = cfg->coalesc;
> +	chan->config.delay = cfg->delay;
> +	if (cfg->coalesc <= XILINX_VDMA_DMACR_FRAME_COUNT_MAX) {
> +		dmacr |= cfg->coalesc << XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT;
> +		chan->config.coalesc = cfg->coalesc;
> +	}
> +
> +	if (cfg->delay <= XILINX_VDMA_DMACR_DELAY_MAX) {
> +		dmacr |= cfg->delay << XILINX_VDMA_DMACR_DELAY_SHIFT;
> +		chan->config.delay = cfg->delay;
> +	}
> +
> +	/* FSync Source selection */
> +	dmacr &= ~XILINX_VDMA_DMACR_FSYNCSRC_MASK;
> +	dmacr |= cfg->ext_fsync << XILINX_VDMA_DMACR_FSYNCSRC_SHIFT;
> +
> +	vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +	return 0;
> +}
> +
> +/**
> + * xilinx_vdma_device_control - Configure DMA channel of the device
> + * @dchan: DMA Channel pointer
> + * @cmd: DMA control command
> + * @arg: Channel configuration
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
> +				      enum dma_ctrl_cmd cmd, unsigned long arg)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		xilinx_vdma_terminate_all(chan);
> +		return 0;
> +	case DMA_SLAVE_CONFIG:
> +		return xilinx_vdma_slave_config(chan,
> +					(struct xilinx_vdma_config *)arg);
> +	default:
> +		return -ENXIO;
> +	}
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Probe and remove
> + */
> +
> +/**
> + * xilinx_vdma_chan_remove - Per Channel remove function
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_chan_remove(struct xilinx_vdma_chan *chan)
> +{
> +	/* Disable all interrupts */
> +	vdma_ctrl_clr(chan, XILINX_VDMA_REG_DMACR,
> +		      XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +	list_del(&chan->common.device_node);
> +}
> +
> +/**
> + * xilinx_vdma_chan_probe - Per Channel Probing
> + * It get channel features from the device tree entry and
> + * initialize special channel handling routines
> + *
> + * @xdev: Driver specific device structure
> + * @node: Device node
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_chan_probe(struct xilinx_vdma_device *xdev,
> +				  struct device_node *node)
> +{
> +	struct xilinx_vdma_chan *chan;
> +	bool has_dre = false;
> +	u32 device_id;
> +	u32 value;
> +	int err;
> +
> +	/* Allocate and initialize the channel structure */
> +	chan = devm_kzalloc(xdev->dev, sizeof(*chan), GFP_KERNEL);
> +	if (!chan)
> +		return -ENOMEM;
> +
> +	chan->dev = xdev->dev;
> +	chan->xdev = xdev;
> +	chan->has_sg = xdev->has_sg;
> +
> +	spin_lock_init(&chan->lock);
> +	INIT_LIST_HEAD(&chan->pending_list);
> +	INIT_LIST_HEAD(&chan->done_list);
> +
> +	/* Retrieve the channel properties from the device tree */
> +	has_dre = of_property_read_bool(node, "xlnx,include-dre");
> +
> +	chan->genlock = of_property_read_bool(node, "xlnx,genlock-mode");
> +
> +	err = of_property_read_u32(node, "xlnx,datawidth", &value);
> +	if (!err) {
> +		u32 width = value >> 3; /* Convert bits to bytes */
> +
> +		/* If data width is greater than 8 bytes, DRE is not in hw */
> +		if (width > 8)
> +			has_dre = false;
> +
> +		if (!has_dre)
> +			xdev->common.copy_align = fls(width - 1);
> +	}
> +
> +	err = of_property_read_u32(node, "xlnx,device-id", &device_id);
> +	if (err < 0) {
> +		dev_err(xdev->dev, "missing xlnx,device-id property\n");
> +		return err;
> +	}
> +
> +	if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel")) {
> +		chan->direction = DMA_MEM_TO_DEV;
> +		chan->id = 0;
> +
> +		chan->ctrl_offset = XILINX_VDMA_MM2S_CTRL_OFFSET;
> +		chan->desc_offset = XILINX_VDMA_MM2S_DESC_OFFSET;
> +
> +		if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
> +		    xdev->flush_on_fsync == XILINX_VDMA_FLUSH_MM2S)
> +			chan->flush_on_fsync = true;
> +	} else if (of_device_is_compatible(node,
> +					    "xlnx,axi-vdma-s2mm-channel")) {
> +		chan->direction = DMA_DEV_TO_MEM;
> +		chan->id = 1;
> +
> +		chan->ctrl_offset = XILINX_VDMA_S2MM_CTRL_OFFSET;
> +		chan->desc_offset = XILINX_VDMA_S2MM_DESC_OFFSET;
> +
> +		if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
> +		    xdev->flush_on_fsync == XILINX_VDMA_FLUSH_S2MM)
> +			chan->flush_on_fsync = true;
> +	} else {
> +		dev_err(xdev->dev, "Invalid channel compatible node\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Used by DMA clients who doesnt have a device node and can request
> +	 * the channel by passing this as a filter to 'dma_request_channel()'.
> +	 */
> +	chan->private = (chan->direction & 0xff) |
> +			XILINX_DMA_IP_VDMA |
> +			(device_id << XILINX_DMA_DEVICE_ID_SHIFT);
> +
> +	/* Request the interrupt */
> +	chan->irq = irq_of_parse_and_map(node, 0);
> +	err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
> +			       IRQF_SHARED, "xilinx-vdma-controller", chan);
> +	if (err) {
> +		dev_err(xdev->dev, "unable to request IRQ\n");
> +		return err;
> +	}
> +
> +	/* Initialize the DMA channel and add it to the DMA engine channels
> +	 * list.
> +	 */
> +	chan->common.device = &xdev->common;
> +	chan->common.private = (void *)&(chan->private);
> +
> +	list_add_tail(&chan->common.device_node, &xdev->common.channels);
> +	xdev->chan[chan->id] = chan;
> +
> +	/* Reset the channel */
> +	err = xilinx_vdma_chan_reset(chan);
> +	if (err < 0) {
> +		dev_err(xdev->dev, "Reset channel failed\n");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * struct of_dma_filter_xilinx_args - Channel filter args
> + * @dev: DMA device structure
> + * @chan_id: Channel id
> + */
> +struct of_dma_filter_xilinx_args {
> +	struct dma_device *dev;
> +	u32 chan_id;
> +};
> +
> +/**
> + * xilinx_vdma_dt_filter - VDMA channel filter function
> + * @chan: DMA channel pointer
> + * @param: Filter match value
> + *
> + * Return: true/false based on the result
> + */
> +static bool xilinx_vdma_dt_filter(struct dma_chan *chan, void *param)
> +{
> +	struct of_dma_filter_xilinx_args *args = param;
> +
> +	return chan->device == args->dev && chan->chan_id == args->chan_id;
> +}
> +
> +/**
> + * of_dma_xilinx_xlate - Translation function
> + * @dma_spec: Pointer to DMA specifier as found in the device tree
> + * @ofdma: Pointer to DMA controller data
> + *
> + * Return: DMA channel pointer on success and NULL on error
> + */
> +static struct dma_chan *of_dma_xilinx_xlate(struct of_phandle_args *dma_spec,
> +						struct of_dma *ofdma)
> +{
> +	struct of_dma_filter_xilinx_args args;
> +	dma_cap_mask_t cap;
> +
> +	args.dev = ofdma->of_dma_data;
> +	if (!args.dev)
> +		return NULL;
> +
> +	if (dma_spec->args_count != 1)
> +		return NULL;
> +
> +	dma_cap_zero(cap);
> +	dma_cap_set(DMA_SLAVE, cap);
> +
> +	args.chan_id = dma_spec->args[0];
> +
> +	return dma_request_channel(cap, xilinx_vdma_dt_filter, &args);
> +}
> +
> +/**
> + * xilinx_vdma_probe - Driver probe function
> + * @pdev: Pointer to the platform_device structure
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct xilinx_vdma_device *xdev;
> +	struct device_node *child;
> +	struct resource *io;
> +	u32 num_frames;
> +	int i, err;
> +
> +	dev_info(&pdev->dev, "Probing xilinx axi vdma engine\n");
> +
> +	/* Allocate and initialize the DMA engine structure */
> +	xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
> +	if (!xdev)
> +		return -ENOMEM;
> +
> +	xdev->dev = &pdev->dev;
> +
> +	/* Request and map I/O memory */
> +	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	xdev->regs = devm_ioremap_resource(&pdev->dev, io);
> +	if (IS_ERR(xdev->regs))
> +		return PTR_ERR(xdev->regs);
> +
> +	/* Retrieve the DMA engine properties from the device tree */
> +	xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
> +
> +	err = of_property_read_u32(node, "xlnx,num-fstores", &num_frames);
> +	if (err < 0) {
> +		dev_err(xdev->dev, "missing xlnx,num-fstores property\n");
> +		return err;
> +	}
> +
> +	of_property_read_u32(node, "xlnx,flush-fsync", &xdev->flush_on_fsync);
> +
> +	/* Initialize the DMA engine */
> +	xdev->common.dev = &pdev->dev;
> +
> +	INIT_LIST_HEAD(&xdev->common.channels);
> +	dma_cap_set(DMA_SLAVE, xdev->common.cap_mask);
> +	dma_cap_set(DMA_PRIVATE, xdev->common.cap_mask);
> +
> +	xdev->common.device_alloc_chan_resources =
> +				xilinx_vdma_alloc_chan_resources;
> +	xdev->common.device_free_chan_resources =
> +				xilinx_vdma_free_chan_resources;
> +	xdev->common.device_prep_slave_sg = xilinx_vdma_prep_slave_sg;
> +	xdev->common.device_control = xilinx_vdma_device_control;
> +	xdev->common.device_tx_status = xilinx_vdma_tx_status;
> +	xdev->common.device_issue_pending = xilinx_vdma_issue_pending;
> +
> +	platform_set_drvdata(pdev, xdev);
> +
> +	/* Initialize the channels */
> +	for_each_child_of_node(node, child) {
> +		err = xilinx_vdma_chan_probe(xdev, child);
> +		if (err < 0)
> +			goto error;
> +	}
> +
> +	for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +		if (xdev->chan[i])
> +			xdev->chan[i]->num_frms = num_frames;
> +	}
> +
> +	/* Register the DMA engine with the core */
> +	dma_async_device_register(&xdev->common);
> +
> +	err = of_dma_controller_register(node, of_dma_xilinx_xlate,
> +					 &xdev->common);
> +	if (err < 0)
> +		dev_err(&pdev->dev, "Unable to register DMA to DT\n");
> +
> +	return 0;
> +
> +error:
> +	for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +		if (xdev->chan[i])
> +			xilinx_vdma_chan_remove(xdev->chan[i]);
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * xilinx_vdma_remove - Driver remove function
> + * @pdev: Pointer to the platform_device structure
> + *
> + * Return: Always '0'
> + */
> +static int xilinx_vdma_remove(struct platform_device *pdev)
> +{
> +	struct xilinx_vdma_device *xdev;
> +	int i;
> +
> +	of_dma_controller_free(pdev->dev.of_node);
> +
> +	xdev = platform_get_drvdata(pdev);
> +	dma_async_device_unregister(&xdev->common);
> +
> +	for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +		if (xdev->chan[i])
> +			xilinx_vdma_chan_remove(xdev->chan[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id xilinx_vdma_of_ids[] = {
> +	{ .compatible = "xlnx,axi-vdma-1.00.a",},
> +	{}
> +};
> +
> +static struct platform_driver xilinx_vdma_driver = {
> +	.driver = {
> +		.name = "xilinx-vdma",
> +		.owner = THIS_MODULE,
> +		.of_match_table = xilinx_vdma_of_ids,
> +	},
> +	.probe = xilinx_vdma_probe,
> +	.remove = xilinx_vdma_remove,
> +};
> +
> +module_platform_driver(xilinx_vdma_driver);
> +
> +MODULE_AUTHOR("Xilinx, Inc.");
> +MODULE_DESCRIPTION("Xilinx VDMA driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/dma/xilinx/xilinx_vdma_test.c b/drivers/dma/xilinx/xilinx_vdma_test.c
> new file mode 100644
> index 0000000..813b67c
> --- /dev/null
> +++ b/drivers/dma/xilinx/xilinx_vdma_test.c
> @@ -0,0 +1,629 @@
> +/*
> + * XILINX VDMA Engine test client driver
> + *
> + * Copyright (C) 2010-2013 Xilinx, Inc. All rights reserved.
> + *
> + * Based on Atmel DMA Test Client
> + *
> + * Description:
> + * This is a simple Xilinx VDMA test client for AXI VDMA driver.
> + * This test assumes both the channels of VDMA are enabled in the
> + * hardware design and configured in back-to-back connection. Test
> + * starts by pumping the data onto one channel (MM2S) and then
> + * compares the data that is received on the other channel (S2MM).
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/amba/xilinx_dma.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/kthread.h>
> +#include <linux/module.h>
> +#include <linux/of_dma.h>
> +#include <linux/platform_device.h>
> +#include <linux/random.h>
> +#include <linux/slab.h>
> +#include <linux/wait.h>
> +
> +static unsigned int test_buf_size = 64;
> +module_param(test_buf_size, uint, S_IRUGO);
> +MODULE_PARM_DESC(test_buf_size, "Size of the memcpy test buffer");
> +
> +static unsigned int iterations;
> +module_param(iterations, uint, S_IRUGO);
> +MODULE_PARM_DESC(iterations,
> +		"Iterations before stopping test (default: infinite)");
> +
> +/*
> + * Initialization patterns. All bytes in the source buffer has bit 7
> + * set, all bytes in the destination buffer has bit 7 cleared.
> + *
> + * Bit 6 is set for all bytes which are to be copied by the DMA
> + * engine. Bit 5 is set for all bytes which are to be overwritten by
> + * the DMA engine.
> + *
> + * The remaining bits are the inverse of a counter which increments by
> + * one for each byte address.
> + */
> +#define PATTERN_SRC		0x80
> +#define PATTERN_DST		0x00
> +#define PATTERN_COPY		0x40
> +#define PATTERN_OVERWRITE	0x20
> +#define PATTERN_COUNT_MASK	0x1f
> +
> +/* Maximum number of frame buffers */
> +#define MAX_NUM_FRAMES	32
> +
> +/**
> + * struct vdmatest_slave_thread - VDMA test thread
> + * @node: Thread node
> + * @task: Task structure pointer
> + * @tx_chan: Tx channel pointer
> + * @rx_chan: Rx Channel pointer
> + * @srcs: Source buffer
> + * @dsts: Destination buffer
> + * @type: DMA transaction type
> + */
> +struct xilinx_vdmatest_slave_thread {
> +	struct list_head node;
> +	struct task_struct *task;
> +	struct dma_chan *tx_chan;
> +	struct dma_chan *rx_chan;
> +	u8 **srcs;
> +	u8 **dsts;
> +	enum dma_transaction_type type;
> +};
> +
> +/**
> + * struct vdmatest_chan - VDMA Test channel
> + * @node: Channel node
> + * @chan: DMA channel pointer
> + * @threads: List of VDMA test threads
> + */
> +struct xilinx_vdmatest_chan {
> +	struct list_head node;
> +	struct dma_chan *chan;
> +	struct list_head threads;
> +};
> +
> +/* Global variables */
> +static LIST_HEAD(xilinx_vdmatest_channels);
> +static unsigned int nr_channels;
> +static unsigned int frm_cnt;
> +static dma_addr_t dma_srcs[MAX_NUM_FRAMES];
> +static dma_addr_t dma_dsts[MAX_NUM_FRAMES];
> +static struct scatterlist tx_sg[MAX_NUM_FRAMES];
> +static struct scatterlist rx_sg[MAX_NUM_FRAMES];
> +
> +static void xilinx_vdmatest_init_srcs(u8 **bufs, unsigned int start,
> +					unsigned int len)
> +{
> +	unsigned int i;
> +	u8 *buf;
> +
> +	for (; (buf = *bufs); bufs++) {
> +		for (i = 0; i < start; i++)
> +			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
> +		for (; i < start + len; i++)
> +			buf[i] = PATTERN_SRC | PATTERN_COPY
> +				| (~i & PATTERN_COUNT_MASK);
> +		for (; i < test_buf_size; i++)
> +			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
> +		buf++;
> +	}
> +}
> +
> +static void xilinx_vdmatest_init_dsts(u8 **bufs, unsigned int start,
> +					unsigned int len)
> +{
> +	unsigned int i;
> +	u8 *buf;
> +
> +	for (; (buf = *bufs); bufs++) {
> +		for (i = 0; i < start; i++)
> +			buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
> +		for (; i < start + len; i++)
> +			buf[i] = PATTERN_DST | PATTERN_OVERWRITE
> +				| (~i & PATTERN_COUNT_MASK);
> +		for (; i < test_buf_size; i++)
> +			buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
> +	}
> +}
> +
> +static void xilinx_vdmatest_mismatch(u8 actual, u8 pattern, unsigned int index,
> +		unsigned int counter, bool is_srcbuf)
> +{
> +	u8 diff = actual ^ pattern;
> +	u8 expected = pattern | (~counter & PATTERN_COUNT_MASK);
> +	const char *thread_name = current->comm;
> +
> +	if (is_srcbuf)
> +		pr_warn(
> +		"%s: srcbuf[0x%x] overwritten! Expected %02x, got %02x\n",
> +				thread_name, index, expected, actual);
> +	else if ((pattern & PATTERN_COPY)
> +			&& (diff & (PATTERN_COPY | PATTERN_OVERWRITE)))
> +		pr_warn(
> +		"%s: dstbuf[0x%x] not copied! Expected %02x, got %02x\n",
> +				thread_name, index, expected, actual);
> +	else if (diff & PATTERN_SRC)
> +		pr_warn(
> +		"%s: dstbuf[0x%x] was copied! Expected %02x, got %02x\n",
> +				thread_name, index, expected, actual);
> +	else
> +		pr_warn(
> +		"%s: dstbuf[0x%x] mismatch! Expected %02x, got %02x\n",
> +				thread_name, index, expected, actual);
> +}
> +
> +static unsigned int xilinx_vdmatest_verify(u8 **bufs, unsigned int start,
> +		unsigned int end, unsigned int counter, u8 pattern,
> +		bool is_srcbuf)
> +{
> +	unsigned int i, error_count = 0;
> +	u8 actual, expected, *buf;
> +	unsigned int counter_orig = counter;
> +
> +	for (; (buf = *bufs); bufs++) {
> +		counter = counter_orig;
> +		for (i = start; i < end; i++) {
> +			actual = buf[i];
> +			expected = pattern | (~counter & PATTERN_COUNT_MASK);
> +			if (actual != expected) {
> +				if (error_count < 32)
> +					xilinx_vdmatest_mismatch(actual,
> +							pattern, i,
> +							counter, is_srcbuf);
> +				error_count++;
> +			}
> +			counter++;
> +		}
> +	}
> +
> +	if (error_count > 32)
> +		pr_warn("%s: %u errors suppressed\n",
> +			current->comm, error_count - 32);
> +
> +	return error_count;
> +}
> +
> +static void xilinx_vdmatest_slave_tx_callback(void *completion)
> +{
> +	pr_debug("Got tx callback\n");
> +	complete(completion);
> +}
> +
> +static void xilinx_vdmatest_slave_rx_callback(void *completion)
> +{
> +	pr_debug("Got rx callback\n");
> +	complete(completion);
> +}
> +
> +/*
> + * Function for slave transfers
> + * Each thread requires 2 channels, one for transmit, and one for receive
> + */
> +static int xilinx_vdmatest_slave_func(void *data)
> +{
> +	struct xilinx_vdmatest_slave_thread *thread = data;
> +	struct dma_chan *tx_chan, *rx_chan;
> +	const char *thread_name;
> +	unsigned int len, error_count;
> +	unsigned int failed_tests = 0, total_tests = 0;
> +	dma_cookie_t tx_cookie, rx_cookie;
> +	enum dma_status status;
> +	enum dma_ctrl_flags flags;
> +	int ret = -ENOMEM, i;
> +	int hsize = 64, vsize = 32;
> +	struct xilinx_vdma_config config;
> +
> +	thread_name = current->comm;
> +
> +	/* Limit testing scope here */
> +	iterations = 1;
> +	test_buf_size = hsize * vsize;
> +
> +	/* This barrier ensures 'thread' is initialized and
> +	 * we get valid DMA channels
> +	 */
> +	smp_rmb();
> +	tx_chan = thread->tx_chan;
> +	rx_chan = thread->rx_chan;
> +
> +	thread->srcs = kcalloc(frm_cnt+1, sizeof(u8 *), GFP_KERNEL);
> +	if (!thread->srcs)
> +		goto err_srcs;
> +	for (i = 0; i < frm_cnt; i++) {
> +		thread->srcs[i] = kmalloc(test_buf_size, GFP_KERNEL);
> +		if (!thread->srcs[i])
> +			goto err_srcbuf;
> +	}
> +
> +	thread->dsts = kcalloc(frm_cnt+1, sizeof(u8 *), GFP_KERNEL);
> +	if (!thread->dsts)
> +		goto err_dsts;
> +	for (i = 0; i < frm_cnt; i++) {
> +		thread->dsts[i] = kmalloc(test_buf_size, GFP_KERNEL);
> +		if (!thread->dsts[i])
> +			goto err_dstbuf;
> +	}
> +
> +	set_user_nice(current, 10);
> +
> +	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
> +
> +	while (!kthread_should_stop()
> +		&& !(iterations && total_tests >= iterations)) {
> +		struct dma_device *tx_dev = tx_chan->device;
> +		struct dma_device *rx_dev = rx_chan->device;
> +		struct dma_async_tx_descriptor *txd = NULL;
> +		struct dma_async_tx_descriptor *rxd = NULL;
> +		struct completion rx_cmp, tx_cmp;
> +		unsigned long rx_tmo =
> +				msecs_to_jiffies(30000); /* RX takes longer */
> +		unsigned long tx_tmo = msecs_to_jiffies(30000);
> +		u8 align = 0;
> +
> +		total_tests++;
> +
> +		/* honor larger alignment restrictions */
> +		align = tx_dev->copy_align;
> +		if (rx_dev->copy_align > align)
> +			align = rx_dev->copy_align;
> +
> +		if (1 << align > test_buf_size) {
> +			pr_err("%u-byte buffer too small for %d-byte alignment\n",
> +			       test_buf_size, 1 << align);
> +			break;
> +		}
> +
> +		len = test_buf_size;
> +		xilinx_vdmatest_init_srcs(thread->srcs, 0, len);
> +		xilinx_vdmatest_init_dsts(thread->dsts, 0, len);
> +
> +		sg_init_table(tx_sg, frm_cnt);
> +		sg_init_table(rx_sg, frm_cnt);
> +
> +		for (i = 0; i < frm_cnt; i++) {
> +			u8 *buf = thread->srcs[i];
> +
> +			dma_srcs[i] = dma_map_single(tx_dev->dev, buf, len,
> +							DMA_MEM_TO_DEV);
> +			pr_debug("src buf %x dma %x\n", (unsigned int)buf,
> +				 (unsigned int)dma_srcs[i]);
> +			sg_dma_address(&tx_sg[i]) = dma_srcs[i];
> +			sg_dma_len(&tx_sg[i]) = len;
> +		}
> +
> +		for (i = 0; i < frm_cnt; i++) {
> +			dma_dsts[i] = dma_map_single(rx_dev->dev,
> +							thread->dsts[i],
> +							test_buf_size,
> +							DMA_DEV_TO_MEM);
> +			pr_debug("dst %x dma %x\n",
> +				 (unsigned int)thread->dsts[i],
> +				 (unsigned int)dma_dsts[i]);
> +			sg_dma_address(&rx_sg[i]) = dma_dsts[i];
> +			sg_dma_len(&rx_sg[i]) = len;
> +		}
> +
> +		/* Zero out configuration */
> +		memset(&config, 0, sizeof(struct xilinx_vdma_config));
> +
> +		/* Set up hardware configuration information */
> +		config.vsize = vsize;
> +		config.hsize = hsize;
> +		config.stride = hsize;
> +		config.frm_cnt_en = 1;
> +		config.coalesc = frm_cnt * 10;
> +		config.park = 1;
> +		tx_dev->device_control(tx_chan, DMA_SLAVE_CONFIG,
> +					(unsigned long)&config);
> +
> +		config.park = 0;
> +		rx_dev->device_control(rx_chan, DMA_SLAVE_CONFIG,
> +					(unsigned long)&config);
> +
> +		rxd = rx_dev->device_prep_slave_sg(rx_chan, rx_sg, frm_cnt,
> +				DMA_DEV_TO_MEM, flags, NULL);
> +
> +		txd = tx_dev->device_prep_slave_sg(tx_chan, tx_sg, frm_cnt,
> +				DMA_MEM_TO_DEV, flags, NULL);
> +
> +		if (!rxd || !txd) {
> +			for (i = 0; i < frm_cnt; i++)
> +				dma_unmap_single(tx_dev->dev, dma_srcs[i], len,
> +						DMA_MEM_TO_DEV);
> +			for (i = 0; i < frm_cnt; i++)
> +				dma_unmap_single(rx_dev->dev, dma_dsts[i],
> +						test_buf_size,
> +						DMA_DEV_TO_MEM);
> +			pr_warn("%s: #%u: prep error with len=0x%x ",
> +					thread_name, total_tests - 1, len);
> +			msleep(100);
> +			failed_tests++;
> +			continue;
> +		}
> +
> +		init_completion(&rx_cmp);
> +		rxd->callback = xilinx_vdmatest_slave_rx_callback;
> +		rxd->callback_param = &rx_cmp;
> +		rx_cookie = rxd->tx_submit(rxd);
> +
> +		init_completion(&tx_cmp);
> +		txd->callback = xilinx_vdmatest_slave_tx_callback;
> +		txd->callback_param = &tx_cmp;
> +		tx_cookie = txd->tx_submit(txd);
> +
> +		if (dma_submit_error(rx_cookie) ||
> +				dma_submit_error(tx_cookie)) {
> +			pr_warn("%s: #%u: submit error %d/%d with len=0x%x ",
> +					thread_name, total_tests - 1,
> +					rx_cookie, tx_cookie, len);
> +			msleep(100);
> +			failed_tests++;
> +			continue;
> +		}
> +		dma_async_issue_pending(tx_chan);
> +		dma_async_issue_pending(rx_chan);
> +
> +		tx_tmo = wait_for_completion_timeout(&tx_cmp, tx_tmo);
> +
> +		status = dma_async_is_tx_complete(tx_chan, tx_cookie,
> +							NULL, NULL);
> +
> +		if (tx_tmo == 0) {
> +			pr_warn("%s: #%u: tx test timed out\n",
> +					thread_name, total_tests - 1);
> +			failed_tests++;
> +			continue;
> +		} else if (status != DMA_COMPLETE) {
> +			pr_warn(
> +			"%s: #%u: tx got completion callback, ",
> +				   thread_name, total_tests - 1);
> +			pr_warn("but status is \'%s\'\n",
> +				   status == DMA_ERROR ? "error" :
> +							"in progress");
> +			failed_tests++;
> +			continue;
> +		}
> +
> +		rx_tmo = wait_for_completion_timeout(&rx_cmp, rx_tmo);
> +		status = dma_async_is_tx_complete(rx_chan, rx_cookie,
> +							NULL, NULL);
> +
> +		if (rx_tmo == 0) {
> +			pr_warn("%s: #%u: rx test timed out\n",
> +					thread_name, total_tests - 1);
> +			failed_tests++;
> +			continue;
> +		} else if (status != DMA_COMPLETE) {
> +			pr_warn(
> +			"%s: #%u: rx got completion callback, ",
> +					thread_name, total_tests - 1);
> +			pr_warn("but status is \'%s\'\n",
> +					status == DMA_ERROR ? "error" :
> +							"in progress");
> +			failed_tests++;
> +			continue;
> +		}
> +
> +		for (i = 0; i < frm_cnt; i++)
> +			dma_unmap_single(rx_dev->dev, dma_dsts[i],
> +					 test_buf_size, DMA_DEV_TO_MEM);
> +
> +		error_count = 0;
> +
> +		pr_debug("%s: verifying source buffer...\n", thread_name);
> +		error_count += xilinx_vdmatest_verify(thread->srcs, 0, 0,
> +				0, PATTERN_SRC, true);
> +		error_count += xilinx_vdmatest_verify(thread->srcs, 0,
> +				len, 0, PATTERN_SRC | PATTERN_COPY, true);
> +		error_count += xilinx_vdmatest_verify(thread->srcs, len,
> +				test_buf_size, len, PATTERN_SRC, true);
> +
> +		pr_debug("%s: verifying dest buffer...\n",
> +				thread->task->comm);
> +		error_count += xilinx_vdmatest_verify(thread->dsts, 0, 0,
> +				0, PATTERN_DST, false);
> +		error_count += xilinx_vdmatest_verify(thread->dsts, 0,
> +				len, 0, PATTERN_SRC | PATTERN_COPY, false);
> +		error_count += xilinx_vdmatest_verify(thread->dsts, len,
> +				test_buf_size, len, PATTERN_DST, false);
> +
> +		if (error_count) {
> +			pr_warn("%s: #%u: %u errors with len=0x%x\n",
> +				thread_name, total_tests - 1, error_count, len);
> +			failed_tests++;
> +		} else {
> +			pr_debug("%s: #%u: No errors with len=0x%x\n",
> +				thread_name, total_tests - 1, len);
> +		}
> +	}
> +
> +	ret = 0;
> +	for (i = 0; thread->dsts[i]; i++)
> +		kfree(thread->dsts[i]);
> +err_dstbuf:
> +	kfree(thread->dsts);
> +err_dsts:
> +	for (i = 0; thread->srcs[i]; i++)
> +		kfree(thread->srcs[i]);
> +err_srcbuf:
> +	kfree(thread->srcs);
> +err_srcs:
> +	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
> +			thread_name, total_tests, failed_tests, ret);
> +
> +	if (iterations > 0)
> +		while (!kthread_should_stop()) {
> +			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_vdmatest_exit);
> +			interruptible_sleep_on(&wait_vdmatest_exit);
> +		}
> +
> +	return ret;
> +}
> +
> +static void xilinx_vdmatest_cleanup_channel(struct xilinx_vdmatest_chan *dtc)
> +{
> +	struct xilinx_vdmatest_slave_thread *thread, *_thread;
> +	int ret;
> +
> +	list_for_each_entry_safe(thread, _thread,
> +				&dtc->threads, node) {
> +		ret = kthread_stop(thread->task);
> +		pr_info("xilinx_vdmatest: thread %s exited with status %d\n",
> +				thread->task->comm, ret);
> +		list_del(&thread->node);
> +		kfree(thread);
> +	}
> +	kfree(dtc);
> +}
> +
> +static int
> +xilinx_vdmatest_add_slave_threads(struct xilinx_vdmatest_chan *tx_dtc,
> +					struct xilinx_vdmatest_chan *rx_dtc)
> +{
> +	struct xilinx_vdmatest_slave_thread *thread;
> +	struct dma_chan *tx_chan = tx_dtc->chan;
> +	struct dma_chan *rx_chan = rx_dtc->chan;
> +
> +	thread = kzalloc(sizeof(struct xilinx_vdmatest_slave_thread),
> +			GFP_KERNEL);
> +	if (!thread)
> +		pr_warn("xilinx_vdmatest: No memory for slave thread %s-%s\n",
> +			   dma_chan_name(tx_chan), dma_chan_name(rx_chan));
> +
> +	thread->tx_chan = tx_chan;
> +	thread->rx_chan = rx_chan;
> +	thread->type = (enum dma_transaction_type)DMA_SLAVE;
> +
> +	/* This barrier ensures the DMA channels in the 'thread'
> +	 * are initialized
> +	 */
> +	smp_wmb();
> +	thread->task = kthread_run(xilinx_vdmatest_slave_func, thread, "%s-%s",
> +		dma_chan_name(tx_chan), dma_chan_name(rx_chan));
> +	if (IS_ERR(thread->task)) {
> +		pr_warn("xilinx_vdmatest: Failed to run thread %s-%s\n",
> +				dma_chan_name(tx_chan), dma_chan_name(rx_chan));
> +		kfree(thread);
> +	}
> +
> +	list_add_tail(&thread->node, &tx_dtc->threads);
> +
> +	/* Added one thread with 2 channels */
> +	return 1;
> +}
> +
> +static int xilinx_vdmatest_add_slave_channels(struct dma_chan *tx_chan,
> +					struct dma_chan *rx_chan)
> +{
> +	struct xilinx_vdmatest_chan *tx_dtc, *rx_dtc;
> +	unsigned int thread_count = 0;
> +
> +	tx_dtc = kmalloc(sizeof(struct xilinx_vdmatest_chan), GFP_KERNEL);
> +	if (!tx_dtc)
> +		return -ENOMEM;
> +
> +	rx_dtc = kmalloc(sizeof(struct xilinx_vdmatest_chan), GFP_KERNEL);
> +	if (!rx_dtc)
> +		return -ENOMEM;
> +
> +	tx_dtc->chan = tx_chan;
> +	rx_dtc->chan = rx_chan;
> +	INIT_LIST_HEAD(&tx_dtc->threads);
> +	INIT_LIST_HEAD(&rx_dtc->threads);
> +
> +	xilinx_vdmatest_add_slave_threads(tx_dtc, rx_dtc);
> +	thread_count += 1;
> +
> +	pr_info("xilinx_vdmatest: Started %u threads using %s %s\n",
> +		thread_count, dma_chan_name(tx_chan), dma_chan_name(rx_chan));
> +
> +	list_add_tail(&tx_dtc->node, &xilinx_vdmatest_channels);
> +	list_add_tail(&rx_dtc->node, &xilinx_vdmatest_channels);
> +	nr_channels += 2;
> +
> +	return 0;
> +}
> +
> +static int xilinx_vdmatest_probe(struct platform_device *pdev)
> +{
> +	struct dma_chan *chan, *rx_chan;
> +	int err;
> +
> +	err = of_property_read_u32(pdev->dev.of_node,
> +					"xlnx,num-fstores", &frm_cnt);
> +	if (err < 0) {
> +		pr_err("xilinx_vdmatest: missing xlnx,num-fstores property\n");
> +		return err;
> +	}
> +
> +	chan = dma_request_slave_channel(&pdev->dev, "vdma0");
> +	if (IS_ERR(chan)) {
> +		pr_err("xilinx_vdmatest: No Tx channel\n");
> +		return PTR_ERR(chan);
> +	}
> +
> +	rx_chan = dma_request_slave_channel(&pdev->dev, "vdma1");
> +	if (IS_ERR(rx_chan)) {
> +		err = PTR_ERR(rx_chan);
> +		pr_err("xilinx_vdmatest: No Rx channel\n");
> +		goto free_tx;
> +	}
> +
> +	err = xilinx_vdmatest_add_slave_channels(chan, rx_chan);
> +	if (err) {
> +		pr_err("xilinx_vdmatest: Unable to add channels\n");
> +		goto free_rx;
> +	}
> +	return 0;
> +
> +free_rx:
> +	dma_release_channel(rx_chan);
> +free_tx:
> +	dma_release_channel(chan);
> +
> +	return err;
> +}
> +
> +static int xilinx_vdmatest_remove(struct platform_device *pdev)
> +{
> +	struct xilinx_vdmatest_chan *dtc, *_dtc;
> +	struct dma_chan *chan;
> +
> +	list_for_each_entry_safe(dtc, _dtc, &xilinx_vdmatest_channels, node) {
> +		list_del(&dtc->node);
> +		chan = dtc->chan;
> +		xilinx_vdmatest_cleanup_channel(dtc);
> +		pr_info("xilinx_vdmatest: dropped channel %s\n",
> +			dma_chan_name(chan));
> +		dma_release_channel(chan);
> +	}
> +	return 0;
> +}
> +
> +static const struct of_device_id xilinx_vdmatest_of_ids[] = {
> +	{ .compatible = "xlnx,axi-vdma-test-1.00.a",},
> +	{}
> +};
> +
> +static struct platform_driver xilinx_vdmatest_driver = {
> +	.driver = {
> +		.name = "xilinx_vdmatest",
> +		.owner = THIS_MODULE,
> +		.of_match_table = xilinx_vdmatest_of_ids,
> +	},
> +	.probe = xilinx_vdmatest_probe,
> +	.remove = xilinx_vdmatest_remove,
> +};
> +
> +module_platform_driver(xilinx_vdmatest_driver);
> +
> +MODULE_AUTHOR("Xilinx, Inc.");
> +MODULE_DESCRIPTION("Xilinx AXI VDMA Test Client");
> +MODULE_LICENSE("GPL v2");
>


