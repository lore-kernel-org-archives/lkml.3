Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaDPLmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:42:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:5946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbaDPLmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,871,1389772800"; 
   d="scan'208";a="514123891"
Date: Wed, 16 Apr 2014 17:01:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org, lars@metafoo.de,
        andriy.shevchenko@linux.jf.intel.com, jaswinder.singh@linaro.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Message-ID: <20140416113135.GT32284@intel.com>
References: <1396355224-20863-1-git-send-email-sthokal@xilinx.com>
 <1396355224-20863-2-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396355224-20863-2-git-send-email-sthokal@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:57:04PM +0530, Srikanth Thokala wrote:
> This is the driver for the AXI Direct Memory Access (AXI DMA)
> core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type target peripherals.
> 
> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
> 
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---
> Note:
> - This driver patch is created on top of earlier series,
>   1/2 - "dma: Add Xilinx Video DMA DT Binding Documentation"
>   2/2 - "dma: Add Xilinx AXI Video Direct Memory Access Engine driver support"
> - Rebased on v3.14.0-rc8
> 
> Changes in v2:
> - Simplified the logic to set SOP and APP words in prep_slave_sg().
> - Corrected function description comments to match the return type.
> - Fixed some minor comments as suggested by Andy, Thanks.
> ---
>  drivers/dma/Kconfig             |   13 +
>  drivers/dma/xilinx/Makefile     |    1 +
>  drivers/dma/xilinx/xilinx_dma.c | 1225 +++++++++++++++++++++++++++++++++++++++
>  include/linux/amba/xilinx_dma.h |   17 +
>  4 files changed, 1256 insertions(+)
>  create mode 100644 drivers/dma/xilinx/xilinx_dma.c
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 44b312e..8cfcc74 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -365,6 +365,19 @@ config XILINX_VDMA
>  	  channels, Memory Mapped to Stream (MM2S) and Stream to
>  	  Memory Mapped (S2MM) for the data transfers.
>  
> +config XILINX_DMA
> +	tristate "Xilinx AXI DMA Engine"
> +	depends on (ARCH_ZYNQ || MICROBLAZE)
> +	select DMA_ENGINE
> +	help
> +	  Enable support for Xilinx AXI DMA Soft IP.
> +
> +	  This engine provides high-bandwidth direct memory access
> +	  between memory and AXI4-Stream type target peripherals.
> +	  It has two stream interfaces/channels, Memory Mapped to
> +	  Stream (MM2S) and Stream to Memory Mapped (S2MM) for the
> +	  data transfers.
> +
>  config DMA_ENGINE
>  	bool
>  
> diff --git a/drivers/dma/xilinx/Makefile b/drivers/dma/xilinx/Makefile
> index 3c4e9f2..6224a49 100644
> --- a/drivers/dma/xilinx/Makefile
> +++ b/drivers/dma/xilinx/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_XILINX_VDMA) += xilinx_vdma.o
> +obj-$(CONFIG_XILINX_DMA) += xilinx_dma.o
> diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
> new file mode 100644
> index 0000000..0500773
> --- /dev/null
> +++ b/drivers/dma/xilinx/xilinx_dma.c
> @@ -0,0 +1,1225 @@
> +/*
> + * DMA driver for Xilinx DMA Engine
> + *
> + * Copyright (C) 2010 - 2014 Xilinx, Inc. All rights reserved.
> + *
> + * Based on the Freescale DMA driver.
> + *
> + * Description:
> + *  The AXI DMA, is a soft IP, which provides high-bandwidth Direct Memory
> + *  Access between memory and AXI4-Stream-type target peripherals. It can be
> + *  configured to have one channel or two channels and if configured as two
> + *  channels, one is to transmit data from memory to a device and another is
> + *  to receive from a device.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/amba/xilinx_dma.h>
> +#include <linux/bitops.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +#include <linux/slab.h>
> +
> +#include "../dmaengine.h"
> +
> +/* Register Offsets */
> +#define XILINX_DMA_REG_CONTROL		0x00
> +#define XILINX_DMA_REG_STATUS		0x04
> +#define XILINX_DMA_REG_CURDESC		0x08
> +#define XILINX_DMA_REG_TAILDESC		0x10
> +#define XILINX_DMA_REG_SRCADDR		0x18
> +#define XILINX_DMA_REG_DSTADDR		0x20
> +#define XILINX_DMA_REG_BTT		0x28
> +
> +/* Channel/Descriptor Offsets */
> +#define XILINX_DMA_MM2S_CTRL_OFFSET	0x00
> +#define XILINX_DMA_S2MM_CTRL_OFFSET	0x30
> +
> +/* General register bits definitions */
> +#define XILINX_DMA_CR_RUNSTOP_MASK	BIT(0)
> +#define XILINX_DMA_CR_RESET_MASK	BIT(2)
> +
> +#define XILINX_DMA_CR_DELAY_SHIFT	24
> +#define XILINX_DMA_CR_COALESCE_SHIFT	16
> +
> +#define XILINX_DMA_CR_DELAY_MAX		GENMASK(7, 0)
> +#define XILINX_DMA_CR_COALESCE_MAX	GENMASK(7, 0)
> +
> +#define XILINX_DMA_SR_HALTED_MASK	BIT(0)
> +#define XILINX_DMA_SR_IDLE_MASK		BIT(1)
> +
> +#define XILINX_DMA_XR_IRQ_IOC_MASK	BIT(12)
> +#define XILINX_DMA_XR_IRQ_DELAY_MASK	BIT(13)
> +#define XILINX_DMA_XR_IRQ_ERROR_MASK	BIT(14)
> +#define XILINX_DMA_XR_IRQ_ALL_MASK	GENMASK(14, 12)
> +
> +/* BD definitions */
> +#define XILINX_DMA_BD_STS_ALL_MASK	GENMASK(31, 28)
> +#define XILINX_DMA_BD_SOP		BIT(27)
> +#define XILINX_DMA_BD_EOP		BIT(26)
> +
> +/* Hw specific definitions */
> +#define XILINX_DMA_MAX_CHANS_PER_DEVICE	0x2
> +#define XILINX_DMA_MAX_TRANS_LEN	GENMASK(22, 0)
> +
> +/* Delay loop counter to prevent hardware failure */
> +#define XILINX_DMA_LOOP_COUNT		1000000
> +
> +/* Maximum number of Descriptors */
> +#define XILINX_DMA_NUM_DESCS		64
> +
> +/**
> + * struct xilinx_dma_desc_hw - Hardware Descriptor
> + * @next_desc: Next Descriptor Pointer @0x00
> + * @pad1: Reserved @0x04
> + * @buf_addr: Buffer address @0x08
> + * @pad2: Reserved @0x0C
> + * @pad3: Reserved @0x10
> + * @pad4: Reserved @0x14
> + * @control: Control field @0x18
> + * @status: Status field @0x1C
> + * @app: APP Fields @0x20 - 0x30
> + */
> +struct xilinx_dma_desc_hw {
> +	u32 next_desc;
> +	u32 pad1;
> +	u32 buf_addr;
> +	u32 pad2;
> +	u32 pad3;
> +	u32 pad4;
> +	u32 control;
> +	u32 status;
> +	u32 app[XILINX_DMA_NUM_APP_WORDS];
> +} __aligned(64);
> +
> +/**
> + * struct xilinx_dma_tx_segment - Descriptor segment
> + * @hw: Hardware descriptor
> + * @node: Node in the descriptor segments list
> + * @phys: Physical address of segment
> + */
> +struct xilinx_dma_tx_segment {
> +	struct xilinx_dma_desc_hw hw;
> +	struct list_head node;
> +	dma_addr_t phys;
> +} __aligned(64);
> +
> +/**
> + * struct xilinx_dma_tx_descriptor - Per Transaction structure
> + * @async_tx: Async transaction descriptor
> + * @segments: TX segments list
> + * @node: Node in the channel descriptors list
> + */
> +struct xilinx_dma_tx_descriptor {
> +	struct dma_async_tx_descriptor async_tx;
> +	struct list_head segments;
> +	struct list_head node;
> +};
> +
> +/**
> + * struct xilinx_dma_chan - Driver specific DMA channel structure
> + * @xdev: Driver specific device structure
> + * @ctrl_offset: Control registers offset
> + * @lock: Descriptor operation lock
> + * @pending_list: Descriptors waiting
> + * @active_desc: Active descriptor
> + * @allocated_desc: Allocated descriptor
> + * @done_list: Complete descriptors
> + * @free_seg_list: Free descriptors
> + * @common: DMA common channel
> + * @seg_v: Statically allocated segments base
> + * @seg_p: Physical allocated segments base
> + * @dev: The dma device
> + * @irq: Channel IRQ
> + * @id: Channel ID
> + * @direction: Transfer direction
> + * @has_sg: Support scatter transfers
> + * @err: Channel has errors
> + * @tasklet: Cleanup work after irq
> + * @residue: Residue
> + */
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
> +	bool has_sg;
> +	int err;
> +	struct tasklet_struct tasklet;
> +	u32 residue;
> +};
> +
> +/**
> + * struct xilinx_dma_device - DMA device structure
> + * @regs: I/O mapped base address
> + * @dev: Device Structure
> + * @common: DMA device structure
> + * @chan: Driver specific DMA channel
> + * @has_sg: Specifies whether Scatter-Gather is present or not
> + */
> +struct xilinx_dma_device {
> +	void __iomem *regs;
> +	struct device *dev;
> +	struct dma_device common;
> +	struct xilinx_dma_chan *chan[XILINX_DMA_MAX_CHANS_PER_DEVICE];
> +	bool has_sg;
> +};
> +
> +/* Macros */
> +#define to_xilinx_chan(chan) \
> +	container_of(chan, struct xilinx_dma_chan, common)
> +#define to_dma_tx_descriptor(tx) \
> +	container_of(tx, struct xilinx_dma_tx_descriptor, async_tx)
> +
> +/* IO accessors */
> +static inline u32 dma_read(struct xilinx_dma_chan *chan, u32 reg)
> +{
> +	return ioread32(chan->xdev->regs + reg);
> +}
> +
> +static inline void dma_write(struct xilinx_dma_chan *chan, u32 reg, u32 value)
> +{
> +	iowrite32(value, chan->xdev->regs + reg);
> +}
> +
> +static inline u32 dma_ctrl_read(struct xilinx_dma_chan *chan, u32 reg)
> +{
> +	return dma_read(chan, chan->ctrl_offset + reg);
> +}
> +
> +static inline void dma_ctrl_write(struct xilinx_dma_chan *chan, u32 reg,
> +				  u32 value)
> +{
> +	dma_write(chan, chan->ctrl_offset + reg, value);
> +}
> +
> +static inline void dma_ctrl_clr(struct xilinx_dma_chan *chan, u32 reg, u32 clr)
> +{
> +	dma_ctrl_write(chan, reg, dma_ctrl_read(chan, reg) & ~clr);
> +}
> +
> +static inline void dma_ctrl_set(struct xilinx_dma_chan *chan, u32 reg, u32 set)
> +{
> +	dma_ctrl_write(chan, reg, dma_ctrl_read(chan, reg) | set);
> +}

dma_xxx calls are too generic names, perhaps xilinx_write?
Also for both of the driver can we have common template code for this?

After going thru the driver, I think most of the code is just
_same_ as what you have in the other driver. So why not reuse?? Adding support
in the other driver would have made more more sense.

You can have two HW specific handlers which comprehend the programming
of the controller differently but other code remains common.

And the other question is what exactly is the delta between two controllers ??

-- 
~Vinod
