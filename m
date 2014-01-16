Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaAPS1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:27:22 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51902 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaAPS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:27:19 -0500
Message-ID: <52D82480.5030901@linux.com>
Date: Thu, 16 Jan 2014 19:27:12 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com> <1389894803-4147-2-git-send-email-sthokal@xilinx.com>
In-Reply-To: <1389894803-4147-2-git-send-email-sthokal@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/16/2014 06:53 PM, Srikanth Thokala wrote:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
> and write channel operation.
> 
> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
> 
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---

Just a few suggestions and fixes.

> NOTE:
> 1. Created a separate directory 'dma/xilinx' as Xilinx has two more
>    DMA IPs and we are also planning to upstream these drivers soon.
> 2. Rebased on v3.13.0-rc8
> ---
>  .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   71 +
>  .../bindings/dma/xilinx/xilinx_vdma_test.txt       |   39 +
>  drivers/dma/Kconfig                                |   23 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/xilinx/Makefile                        |    2 +
>  drivers/dma/xilinx/xilinx_vdma.c                   | 1497 ++++++++++++++++++++
>  drivers/dma/xilinx/xilinx_vdma_test.c              |  629 ++++++++
>  7 files changed, 2262 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma_test.txt
>  create mode 100644 drivers/dma/xilinx/Makefile
>  create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
>  create mode 100644 drivers/dma/xilinx/xilinx_vdma_test.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> new file mode 100644
> index 0000000..3f5c428
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> @@ -0,0 +1,71 @@
> +Xilinx AXI VDMA engine, it does transfers between memory and video devices.
> +It can be configured to have one channel or two channels. If configured
> +as two channels, one is to transmit to the video device and another is
> +to receive from the video device.
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
> +- #dma-cells: Should be <1>, see "dmas" property below
> +- reg: Should contain VDMA registers location and length.
> +- interrupts: Should contain per channel VDMA interrupts.
> +- compatible (child node): It should be either "xlnx,axi-vdma-mm2s-channel" or
> +	"xlnx,axi-vdma-s2mm-channel". It depends on the hardware design and it
> +	can also have both channels.
> +- xlnx,device-id: Should contain device number in each channel. It should be
> +	{0,1,2...so on} to the number of VDMA devices configured in hardware.
> +- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
> +- xlnx,data-width: Should contain the stream data width, takes {32,64...so on}.
> +- xlnx,flush-fsync: (Optional) Tells whether which channel to Flush on Fsync.
> +	It takes following values:
> +	{1}, flush both channels
> +	{2}, flush mm2s channel
> +	{3}, flush s2mm channel
> +- xlnx,include-sg: (Optional) Tells whether configured for Scatter-mode in
> +	the hardware.
> +- xlnx,include-dre: (Optional) Tells whether hardware is configured for Data
> +	Realignment Engine.
> +- xlnx,genlock-mode: (Optional) Tells whether Genlock synchornisation is

     s/synchornisation/synchronization

> +	enabled/disabled in hardware.
> +
> +Example:
> +++++++++
> +
> +axi_vdma_0: axivdma@40030000 {
> +	compatible = "xlnx,axi-vdma-1.00.a";
> +	#dma_cells = <1>;
> +	reg = < 0x40030000 0x10000 >;
> +	xlnx,flush-fsync = <0x1>;
> +	dma-channel@40030000 {
> +		compatible = "xlnx,axi-vdma-mm2s-channel";
> +		interrupts = < 0 54 4 >;
> +		xlnx,num-fstores = <0x8>;
> +		xlnx,device-id = <0x0>;
> +		xlnx,datawidth = <0x40>;
> +	} ;
> +	dma-channel@40030030 {
> +		compatible = "xlnx,axi-vdma-s2mm-channel";
> +		interrupts = < 0 53 4 >;
> +		xlnx,num-fstores = <0x8>;
> +		xlnx,device-id = <0x0>;
> +		xlnx,datawidth = <0x40>;
> +	} ;
> +} ;
> +
> +
> +* Xilinx Video DMA client
> +
> +Required properties:
> +- dmas: a list of <[Video DMA device phandle] [Channel ID]> pairs,
> +	where Channel ID is '0' for write/tx and '1' for read/rx
> +	channel.
> +- dma-names: a list of DMA channel names, one per "dmas" entry
> +
> +VDMA Test Client Example:
> ++++++++++++++++++++++++++
> +
> +vdmatest_0: vdmatest@0 {
> +	compatible ="xlnx,axi-vdma-test-1.00.a";
> +	dmas = <&axi_vdma_0 0
> +		&axi_vdma_0 1>;
> +	dma-names = "vdma0", "vdma1";
> +} ;
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma_test.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma_test.txt
> new file mode 100644
> index 0000000..5821fdc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma_test.txt
> @@ -0,0 +1,39 @@
> +* Xilinx Video DMA Test client
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-vdma-test-1.00.a"
> +- dmas: a list of <[Video DMA device phandle] [Channel ID]> pairs,
> +	where Channel ID is '0' for write/tx and '1' for read/rx
> +	channel.
> +- dma-names: a list of DMA channel names, one per "dmas" entry
> +- xlnx,num-fstores: Should be the number of framebuffers as configured in
> +	VDMA device node.
> +
> +Example:
> +++++++++
> +
> +vdmatest_0: vdmatest@0 {
> +	compatible ="xlnx,axi-vdma-test-1.00.a";
> +	dmas = <&axi_vdma_0 0
> +		&axi_vdma_0 1>;
> +	dma-names = "vdma0", "vdma1";
> +	xlnx,num-fstores = <0x8>;
> +} ;
> +
> +
> +Xilinx Video DMA Device Node Example
> +++++++++++++++++++++++++++++++++++++
> +axi_vdma_0: axivdma@44A40000 {
> +	compatible = "xlnx,axi-vdma-1.00.a";
> +	...
> +	dma-channel@44A40000 {
> +		...
> +		xlnx,num-fstores = <0x8>;
> +		...
> +	} ;
> +	dma-channel@44A40030 {
> +		...
> +		xlnx,num-fstores = <0x8>;
> +		...
> +	} ;
> +} ;
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index c823daa..675719f 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -334,6 +334,20 @@ config K3_DMA
>  	  Support the DMA engine for Hisilicon K3 platform
>  	  devices.
>  
> +config XILINX_VDMA
> +	tristate "Xilinx AXI VDMA Engine"
> +	depends on (ARCH_ZYNQ || MICROBLAZE)
> +	select DMA_ENGINE
> +	help
> +	  Enable support for Xilinx AXI VDMA Soft IP.
> +
> +	  This engine provides high-bandwidth direct memory access
> +	  between memory and AXI4-Stream video type target
> +	  peripherals including peripherals which support AXI4-
> +	  Stream Video Protocol.  It has two stream interfaces/
> +	  channels, Memory Mapped to Stream (MM2S) and Stream to
> +	  Memory Mapped (S2MM) for the data transfers.
> +
>  config DMA_ENGINE
>  	bool
>  
> @@ -384,4 +398,13 @@ config DMATEST
>  config DMA_ENGINE_RAID
>  	bool
>  
> +config XILINX_VDMA_TEST
> +	tristate "DMA Test client for Xilinx AXI VDMA"
> +	depends on XILINX_VDMA
> +	help
> +	  Simple VDMA driver test client. This test assumes both
> +	  the stream interfaces of VDMA engine, MM2S and S2MM are
> +	  connected back-to-back in the hardware design.
> +
> +	  Say N unless you're debugging a DMA Device driver.
>  endif
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 0ce2da9..d84130b 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -42,3 +42,4 @@ obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
>  obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
>  obj-$(CONFIG_TI_CPPI41) += cppi41.o
>  obj-$(CONFIG_K3_DMA) += k3dma.o
> +obj-y += xilinx/
> diff --git a/drivers/dma/xilinx/Makefile b/drivers/dma/xilinx/Makefile
> new file mode 100644
> index 0000000..cef1e88
> --- /dev/null
> +++ b/drivers/dma/xilinx/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_XILINX_VDMA) += xilinx_vdma.o
> +obj-$(CONFIG_XILINX_VDMA_TEST) += xilinx_vdma_test.o
> diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
> new file mode 100644
> index 0000000..66a12de
> --- /dev/null
> +++ b/drivers/dma/xilinx/xilinx_vdma.c
> @@ -0,0 +1,1497 @@
> +/*
> + * DMA driver for Xilinx Video DMA Engine
> + *
> + * Copyright (C) 2010-2013 Xilinx, Inc. All rights reserved.

Happy new year! ;-)


> + *
> + * Based on the Freescale DMA driver.
> + *
> + * Description:
> + * The AXI Video Direct Memory Access (AXI VDMA) core is a soft Xilinx IP
> + * core that provides high-bandwidth direct memory access between memory
> + * and AXI4-Stream type video target peripherals. The core provides efficient
> + * two dimensional DMA operations with independent asynchronous read (S2MM)
> + * and write (MM2S) channel operation. It can be configured to have either
> + * one channel or two channels. If configured as two channels, one is to
> + * transmit to the video device (MM2S) and another is to receive from the
> + * video device (S2MM). Initialization, status, interrupt and management
> + * registers are accessed through an AXI4-Lite slave interface.
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/amba/xilinx_dma.h>
> +#include <linux/bitops.h>
> +#include <linux/dmapool.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/slab.h>
> +
> +/* Register/Descriptor Offsets */
> +#define XILINX_VDMA_MM2S_CTRL_OFFSET		0x0000
> +#define XILINX_VDMA_S2MM_CTRL_OFFSET		0x0030
> +#define XILINX_VDMA_MM2S_DESC_OFFSET		0x0050
> +#define XILINX_VDMA_S2MM_DESC_OFFSET		0x00a0
> +
> +/* Control Registers */
> +#define XILINX_VDMA_REG_DMACR			0x0000
> +#define XILINX_VDMA_DMACR_DELAY_MAX		0xff
> +#define XILINX_VDMA_DMACR_DELAY_SHIFT		24
> +#define XILINX_VDMA_DMACR_FRAME_COUNT_MAX	0xff
> +#define XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT	16
> +#define XILINX_VDMA_DMACR_ERR_IRQ		(1 << 14)
> +#define XILINX_VDMA_DMACR_DLY_CNT_IRQ		(1 << 13)
> +#define XILINX_VDMA_DMACR_FRM_CNT_IRQ		(1 << 12)
> +#define XILINX_VDMA_DMACR_MASTER_SHIFT		8
> +#define XILINX_VDMA_DMACR_FSYNCSRC_SHIFT	5
> +#define XILINX_VDMA_DMACR_FRAMECNT_EN		(1 << 4)
> +#define XILINX_VDMA_DMACR_GENLOCK_EN		(1 << 3)
> +#define XILINX_VDMA_DMACR_RESET			(1 << 2)
> +#define XILINX_VDMA_DMACR_CIRC_EN		(1 << 1)
> +#define XILINX_VDMA_DMACR_RUNSTOP		(1 << 0)

You could use the BIT(n) field from <linux/bitops.h>

> +#define XILINX_VDMA_DMACR_DELAY_MASK		\
> +				(XILINX_VDMA_DMACR_DELAY_MAX << \
> +				XILINX_VDMA_DMACR_DELAY_SHIFT)
> +#define XILINX_VDMA_DMACR_FRAME_COUNT_MASK	\
> +				(XILINX_VDMA_DMACR_FRAME_COUNT_MAX << \
> +				XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT)
> +#define XILINX_VDMA_DMACR_MASTER_MASK		\
> +				(0xf << XILINX_VDMA_DMACR_MASTER_SHIFT)
> +#define XILINX_VDMA_DMACR_FSYNCSRC_MASK		\
> +				(3 << XILINX_VDMA_DMACR_FSYNCSRC_SHIFT)
> +
> +#define XILINX_VDMA_REG_DMASR			0x0004
> +#define XILINX_VDMA_DMASR_DELAY_SHIFT		24
> +#define XILINX_VDMA_DMASR_FRAME_COUNT_SHIFT	16
> +#define XILINX_VDMA_DMASR_EOL_LATE_ERR		(1 << 15)
> +#define XILINX_VDMA_DMASR_ERR_IRQ		(1 << 14)
> +#define XILINX_VDMA_DMASR_DLY_CNT_IRQ		(1 << 13)
> +#define XILINX_VDMA_DMASR_FRM_CNT_IRQ		(1 << 12)
> +#define XILINX_VDMA_DMASR_SOF_LATE_ERR		(1 << 11)
> +#define XILINX_VDMA_DMASR_SG_DEC_ERR		(1 << 10)
> +#define XILINX_VDMA_DMASR_SG_SLV_ERR		(1 << 9)
> +#define XILINX_VDMA_DMASR_EOF_EARLY_ERR		(1 << 8)
> +#define XILINX_VDMA_DMASR_SOF_EARLY_ERR		(1 << 7)
> +#define XILINX_VDMA_DMASR_DMA_DEC_ERR		(1 << 6)
> +#define XILINX_VDMA_DMASR_DMA_SLAVE_ERR		(1 << 5)
> +#define XILINX_VDMA_DMASR_DMA_INT_ERR		(1 << 4)
> +#define XILINX_VDMA_DMASR_IDLE			(1 << 1)
> +#define XILINX_VDMA_DMASR_HALTED		(1 << 0)

Here as well.
> +#define XILINX_VDMA_DMASR_DELAY_MASK		\
> +				(0xff << XILINX_VDMA_DMASR_DELAY_SHIFT)
> +#define XILINX_VDMA_DMASR_FRAME_COUNT_MASK	\
> +				(0xff << XILINX_VDMA_DMASR_FRAME_COUNT_SHIFT)
> +
> +#define XILINX_VDMA_REG_CURDESC			0x0008
> +#define XILINX_VDMA_REG_TAILDESC		0x0010
> +#define XILINX_VDMA_REG_REG_INDEX		0x0014
> +#define XILINX_VDMA_REG_FRMSTORE		0x0018
> +#define XILINX_VDMA_REG_THRESHOLD		0x001c
> +#define XILINX_VDMA_REG_FRMPTR_STS		0x0024
> +#define XILINX_VDMA_REG_PARK_PTR		0x0028
> +#define XILINX_VDMA_PARK_PTR_WR_REF_SHIFT	8
> +#define XILINX_VDMA_PARK_PTR_RD_REF_SHIFT	0
> +#define XILINX_VDMA_REG_VDMA_VERSION		0x002c
> +
> [...]
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

Can't this be done with a memcpy? Not sure though.
> +
> +	/* genlock settings */
> +	chan->config.gen_lock = cfg->gen_lock;
> +	chan->config.master = cfg->master;

This as well maybe.
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
> [...]
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

Shouldn't this return 'err'? Like when you can't register the DMA to the node,
you might want to bail out, don't you?

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
> [...]
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

That's a memory leak. You gotta kfree tx_dtc.
> [...]
> 


-- 
Regards,
Levente Kurusa
