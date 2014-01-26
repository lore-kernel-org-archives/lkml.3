Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAZRqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 12:46:13 -0500
Received: from smtp-out-105.synserver.de ([212.40.185.105]:1155 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752397AbaAZRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 12:46:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5089
Message-ID: <52E549E3.8040300@metafoo.de>
Date: Sun, 26 Jan 2014 18:46:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com> <1390409565-4200-2-git-send-email-sthokal@xilinx.com> <20140126142436.GF10628@intel.com>
In-Reply-To: <20140126142436.GF10628@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 03:24 PM, Vinod Koul wrote:
> On Wed, Jan 22, 2014 at 10:22:45PM +0530, Srikanth Thokala wrote:
>> This is the driver for the AXI Video Direct Memory Access (AXI
>> VDMA) core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type video target peripherals. The core provides efficient two
>> dimensional DMA operations with independent asynchronous read
> ok here is tha catch, do you want to support interleaved API rather?
> 
>> +* DMA client + +Required properties: +- dmas: a list of <[Video DMA device
>> phandle] [Channel ID]> pairs, +	where Channel ID is '0' for write/tx and
>> '1' for read/rx +	channel.  +- dma-names: a list of DMA channel names, one
>> per "dmas" entry + +Example: +++++++++ + +vdmatest_0: vdmatest@0 { +
>> compatible ="xlnx,axi-vdma-test-1.00.a"; +	dmas = <&axi_vdma_0 0 +
>> &axi_vdma_0 1>; +	dma-names = "vdma0", "vdma1"; +} ;
> Need ack from DT folks. ALso would be better to split the binding to a separate
> patch
> 
> 
>> +/**
>> + * struct xilinx_vdma_chan - Driver specific VDMA channel structure
>> + * @xdev: Driver specific device structure
>> + * @ctrl_offset: Control registers offset
>> + * @desc_offset: TX descriptor registers offset
>> + * @completed_cookie: Maximum cookie completed
>> + * @cookie: The current cookie
>> + * @lock: Descriptor operation lock
>> + * @pending_list: Descriptors waiting
>> + * @active_desc: Active descriptor
>> + * @done_list: Complete descriptors
>> + * @common: DMA common channel
>> + * @desc_pool: Descriptors pool
>> + * @dev: The dma device
>> + * @irq: Channel IRQ
>> + * @id: Channel ID
>> + * @direction: Transfer direction
>> + * @num_frms: Number of frames
>> + * @has_sg: Support scatter transfers
>> + * @genlock: Support genlock mode
>> + * @err: Channel has errors
>> + * @tasklet: Cleanup work after irq
>> + * @config: Device configuration info
>> + * @flush_on_fsync: Flush on Frame sync
>> + */
>> +struct xilinx_vdma_chan {
>> +	struct xilinx_vdma_device *xdev;
>> +	u32 ctrl_offset;
>> +	u32 desc_offset;
>> +	dma_cookie_t completed_cookie;
>> +	dma_cookie_t cookie;
>> +	spinlock_t lock;
>> +	struct list_head pending_list;
>> +	struct xilinx_vdma_tx_descriptor *active_desc;
>> +	struct list_head done_list;
>> +	struct dma_chan common;
>> +	struct dma_pool *desc_pool;
>> +	struct device *dev;
>> +	int irq;
>> +	int id;
>> +	enum dma_transfer_direction direction;
> why should channel have a direction... descriptor should have direction and not
> the channel!

The channel only supports transfers in one direction. Either from memory to
peripheral or from peripheral to memory, that's fixed and can't be changed
at runtime. The driver needs to know which direction the channel supports so
it can reject transfers with the wrong direction.

[...]
>> +
> 
>> + * xilinx_vdma_tx_status - Get VDMA transaction status
>> + * @dchan: DMA channel
>> + * @cookie: Transaction identifier
>> + * @txstate: Transaction state
>> + *
>> + * Return: DMA transaction status
>> + */
>> +static enum dma_status xilinx_vdma_tx_status(struct dma_chan *dchan,
>> +					dma_cookie_t cookie,
>> +					struct dma_tx_state *txstate)
>> +{
>> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>> +	dma_cookie_t last_used;
>> +	dma_cookie_t last_complete;
>> +
>> +	xilinx_vdma_chan_desc_cleanup(chan);
>> +
>> +	last_used = dchan->cookie;
>> +	last_complete = chan->completed_cookie;
>> +
>> +	dma_set_tx_state(txstate, last_complete, last_used, 0);
>> +
>> +	return dma_async_is_complete(cookie, last_complete, last_used);
> no residue calculation?
> 

The hardware doesn't support that.

>> +/**
>> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
>> + * @dchan: DMA channel
>> + * @sgl: scatterlist to transfer to/from
>> + * @sg_len: number of entries in @sgl
>> + * @dir: DMA direction
>> + * @flags: transfer ack flags
>> + * @context: unused
>> + *
>> + * Return: Async transaction descriptor on success and NULL on failure
>> + */
>> +static struct dma_async_tx_descriptor *
>> +xilinx_vdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
>> +			  unsigned int sg_len, enum dma_transfer_direction dir,
>> +			  unsigned long flags, void *context)
> okay now am worried, this is supposed to memcpy DMA so why slave-sg??

The DMA is either from memory to peripheral or from peripheral to memory
depending on the direction. So slave sg should be fine.

> 
> Looking at the driver overall, IMHO we need to do:
> - use the virt-dma to simplfy the cookie handling and perhpasn the descrptors
>   too!
> - Perhpas use interleaved API..?
> - I dont think we should use the slave API as this seems memcpy case!
> 

