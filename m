Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaCNSls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:41:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:13970 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbaCNSlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,656,1389772800"; 
   d="scan'208";a="492221065"
Message-ID: <1394822501.28803.280.camel@smile.fi.intel.com>
Subject: Re: [PATCH v5 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org, levex@linux.com,
        lars@metafoo.de, jaswinder.singh@linaro.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2014 20:41:41 +0200
In-Reply-To: <1394819415-2511-3-git-send-email-sthokal@xilinx.com>
References: <1394819415-2511-1-git-send-email-sthokal@xilinx.com>
	 <1394819415-2511-3-git-send-email-sthokal@xilinx.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 23:20 +0530, Srikanth Thokala wrote:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
> and write channel operation.
> 
> This module works on Zynq (ARM Based SoC) and Microblaze platforms.

Few comments below.

[]

> +++ b/drivers/dma/xilinx/xilinx_vdma.c

[]

> +/**
> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
> + * @dchan: DMA channel
> + * @xt: Interleaved template pointer
> + * @flags: transfer ack flags
> + *
> + * Return: Async transaction descriptor on success and NULL on failure
> + */
> +static struct dma_async_tx_descriptor *
> +xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
> +				 struct dma_interleaved_template *xt,
> +				 unsigned long flags)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	struct xilinx_vdma_tx_segment *segment, *prev = NULL;
> +	struct xilinx_vdma_desc_hw *hw;
> +
> +	if ((xt->dir != DMA_MEM_TO_DEV) && (xt->dir != DMA_DEV_TO_MEM))
> +		return NULL;

!is_slave_direction()

[]

> +static int xilinx_vdma_chan_probe(struct xilinx_vdma_device *xdev,
> +				  struct device_node *node)
> +{
> +	struct xilinx_vdma_chan *chan;
> +	bool has_dre = false;
> +	u32 value, width;
> +	int err;

[]

> +	width = value >> 3; /* Convert bits to bytes */
> +
> +	/* If data width is greater than 8 bytes, DRE is not in hw */
> +	if (width > 8)
> +		has_dre = false;
> +
> +	if (!has_dre)
> +		xdev->common.copy_align = fls(width - 1);

Is width power of two? For me looks like it should be fls(width) - 1;

So, device can't work with alignment less than defined in this case,
correct?

[]

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

dev_dbg? Or move this to the end of function and change text to
something like "Probed ..."


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

