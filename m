Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaAWLZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:25:31 -0500
Received: from smtp-out-180.synserver.de ([212.40.185.180]:1078 "EHLO
	smtp-out-085.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751979AbaAWLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:25:29 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17395
Message-ID: <52E0FC22.8060903@metafoo.de>
Date: Thu, 23 Jan 2014 12:25:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>
CC: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com> <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
In-Reply-To: <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
[...]
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

You really shouldn't be overloading the generic API with your own semantics.
DMA_SLAVE_CONFIG should take a dma_slave_config and nothing else.

> +	default:
> +		return -ENXIO;
> +	}
> +}
> +
[...]
> +
> +	/* Request the interrupt */
> +	chan->irq = irq_of_parse_and_map(node, 0);
> +	err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
> +			       IRQF_SHARED, "xilinx-vdma-controller", chan);

This is a clasic example of where to not use devm_request_irq. 'chan' is
accessed in the interrupt handler, but if you use devm_request_irq 'chan'
will be freed before the interrupt handler has been released, which means
there is now a race condition where the interrupt handler can access already
freed memory.

> +	if (err) {
> +		dev_err(xdev->dev, "unable to request IRQ\n");
> +		return err;
> +	}
> +
> +	/* Initialize the DMA channel and add it to the DMA engine channels
> +	 * list.
> +	 */
> +	chan->common.device = &xdev->common;
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

There is a new helper function called dma_get_slave_channel, which makes
this much easier. Take a look at the k3dma.c driver for an example.
> +}

