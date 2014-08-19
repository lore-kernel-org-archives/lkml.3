Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaHSRTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:19:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:8120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaHSRTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="590317456"
Date: Tue, 19 Aug 2014 22:33:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org, levex@linux.com, jassisinghbrar@gmail.com,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        anirudh@xilinx.com, svemula@xilinx.com
Subject: Re: [PATCH v3 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Message-ID: <20140819170346.GS13288@intel.com>
References: <1406549869-24422-1-git-send-email-sthokal@xilinx.com>
 <1406549869-24422-2-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406549869-24422-2-git-send-email-sthokal@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 05:47:49PM +0530, Srikanth Thokala wrote:
> +struct xilinx_dma_chan {
> +	struct xilinx_dma_device *xdev;
> +	u32 ctrl_offset;
> +	spinlock_t lock;
> +	struct list_head pending_list;
> +	struct xilinx_dma_tx_descriptor *active_desc;
> +	struct xilinx_dma_tx_descriptor *allocated_desc;
> +	struct list_head done_list;
> +	struct list_head free_seg_list;
> +	struct dma_chan common;
> +	struct xilinx_dma_tx_segment *seg_v;
> +	dma_addr_t seg_p;
> +	struct device *dev;
> +	int irq;
> +	int id;
> +	enum dma_transfer_direction direction;
This looks suspect. Why should channel have direction, for a descriptor it
makes sense though.

> +static enum dma_status xilinx_dma_tx_status(struct dma_chan *dchan,
> +					    dma_cookie_t cookie,
> +					    struct dma_tx_state *txstate)
> +{
> +	struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
> +	enum dma_status ret;
> +	unsigned long flags;
> +
> +	ret = dma_cookie_status(dchan, cookie, txstate);
> +	if (ret != DMA_COMPLETE) {
> +		spin_lock_irqsave(&chan->lock, flags);
> +		dma_set_residue(txstate, chan->residue);
> +		spin_unlock_irqrestore(&chan->lock, flags);
> +	}
No residue reporting?

> +static int xilinx_dma_device_control(struct dma_chan *dchan,
> +				     enum dma_ctrl_cmd cmd, unsigned long arg)
> +{
> +	struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
> +	unsigned long flags;
> +
> +	if (cmd != DMA_TERMINATE_ALL)
> +		return -ENXIO;
> +
> +	/* Halt the DMA engine */
> +	xilinx_dma_halt(chan);
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	/* Remove and free all of the descriptors in the lists */
> +	xilinx_dma_free_desc_list(chan, &chan->pending_list);
> +	xilinx_dma_free_desc_list(chan, &chan->done_list);

> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * xilinx_dma_channel_set_config - Configure DMA channel
> + * @dchan: DMA channel
> + * @cfg: DMA device configuration pointer
> + *
> + * Return: '0' on success and failure value on error
> + */
> +int xilinx_dma_channel_set_config(struct dma_chan *dchan,
> +				  struct xilinx_dma_config *cfg)
> +{
> +	struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
> +	u32 reg = dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL);
> +
> +	if (cfg->reset)
> +		return xilinx_dma_reset(chan);
> +
> +	if (cfg->coalesc <= XILINX_DMA_CR_COALESCE_MAX)
> +		reg |= cfg->coalesc << XILINX_DMA_CR_COALESCE_SHIFT;
> +
> +	if (cfg->delay <= XILINX_DMA_CR_DELAY_MAX)
> +		reg |= cfg->delay << XILINX_DMA_CR_DELAY_SHIFT;
> +
> +	dma_ctrl_write(chan, XILINX_DMA_REG_CONTROL, reg);
You aren't checking if a transaction is already running on this channel.
Also don't you need other slave parameters, I see you have removed the
dma_slave_config entirely

-- 
~Vinod
