Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBYL2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:28:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:49188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaBYL2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:28:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,539,1389772800"; 
   d="scan'208";a="461861278"
Message-ID: <1393327695.28803.25.camel@smile.fi.intel.com>
Subject: Re: [PATCH 4/5] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date: Tue, 25 Feb 2014 13:28:15 +0200
In-Reply-To: <1393258967-4843-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1393258967-4843-5-git-send-email-maxime.ripard@free-electrons.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 17:22 +0100, Maxime Ripard wrote:
> The Allwinner A31 has a 16 channels DMA controller that it shares with the
> newer A23. Although sharing some similarities with the DMA controller of the
> older Allwinner SoCs, it's significantly different, I don't expect it to be
> possible to share the driver for these two.
> 
> The A31 Controller is able to memory-to-memory or memory-to-device transfers on
> the 16 channels in parallel.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
>  drivers/dma/Kconfig                                |   8 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/sun6i-dma.c                            | 960 +++++++++++++++++++++
>  4 files changed, 1014 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
>  create mode 100644 drivers/dma/sun6i-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/sun6i-dma.txt b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
> new file mode 100644
> index 0000000..5d7c86d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
> @@ -0,0 +1,45 @@
> +Allwinner A31 DMA Controller
> +
> +This driver follows the generic DMA bindings defined in dma.txt.
> +
> +Required properties:
> +
> +- compatible:	Must be "allwinner,sun6i-a31-dma"
> +- reg:		Should contain the registers base address and length
> +- interrupts:	Should contain a reference to the interrupt used by this device
> +- clocks:	Should contain a reference to the parent AHB clock
> +- resets:	Should contain a reference to the reset controller asserting
> +	  	this device in reset
> +- #dma-cells :	Should be 1, a single cell holding a line request number
> +
> +Example:
> +	dma: dma-controller@01c02000 {
> +		compatible = "allwinner,sun6i-a31-dma";
> +		reg = <0x01c02000 0x1000>;
> +		interrupts = <0 50 4>;
> +		clocks = <&ahb1_gates 6>;
> +		resets = <&ahb1_rst 6>;
> +		#dma-cells = <1>;
> +	};
> +
> +Clients:
> +
> +DMA clients connected to the A31 DMA controller must use the format
> +described in the dma.txt file, using a two-cell specifier for each
> +channel: a phandle plus one integer cells.
> +The two cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The port ID as specified in the datasheet
> +
> +Example:
> +spi2: spi@01c6a000 {
> +	compatible = "allwinner,sun6i-a31-spi";
> +	reg = <0x01c6a000 0x1000>;
> +	interrupts = <0 67 4>;
> +	clocks = <&ahb1_gates 22>, <&spi2_clk>;
> +	clock-names = "ahb", "mod";
> +	dmas = <&dma 25>, <&dma 25>;
> +	dma-names = "rx", "tx";
> +	resets = <&ahb1_rst 22>;
> +};
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 605b016..7923697 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -351,6 +351,14 @@ config MOXART_DMA
>  	help
>  	  Enable support for the MOXA ART SoC DMA controller.
>  
> +config DMA_SUN6I
> +	tristate "Allwinner A31 SoCs DMA support"
> +	depends on ARCH_SUNXI
> +	select DMA_ENGINE
> +	select DMA_VIRTUAL_CHANNELS
> +	help
> +	  Support for the DMA engine for Allwinner A31 SoCs.
> +
>  config DMA_ENGINE
>  	bool
>  
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index a029d0f4..18cdbad 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -44,3 +44,4 @@ obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
>  obj-$(CONFIG_TI_CPPI41) += cppi41.o
>  obj-$(CONFIG_K3_DMA) += k3dma.o
>  obj-$(CONFIG_MOXART_DMA) += moxart-dma.o
> +obj-$(CONFIG_DMA_SUN6I) += sun6i-dma.o
> diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
> new file mode 100644
> index 0000000..2649fde
> --- /dev/null
> +++ b/drivers/dma/sun6i-dma.c
> @@ -0,0 +1,960 @@
> +/*
> + * Copyright (C) 2013-2014 Allwinner Tech Co., Ltd
> + * Author: Sugar <shuge@allwinnertech.com>
> + *
> + * Copyright (C) 2014 Maxime Ripard
> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dmapool.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_dma.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include "virt-dma.h"
> +
> +/*
> + * There's 16 physical channels that can work in parallel.
> + *
> + * However we have 30 different endpoints for our requests.
> + *
> + * Since the channels are able to handle only an unidirectional
> + * transfer, we need to allocate more virtual channels so that
> + * everyone can grab one channel.
> + *
> + * Some devices can't work in both direction (mostly because it
> + * wouldn't make sense), so we have a bit fewer virtual channels than
> + * 2 channels per endpoints.
> + */
> +
> +#define NR_MAX_CHANNELS		16
> +#define NR_MAX_REQUESTS		30
> +#define NR_MAX_VCHANS		53
> +
> +/*
> + * Common registers
> + */
> +#define DMA_IRQ_EN(x)		((x) * 0x04)
> +#define DMA_IRQ_HALF			BIT(0)
> +#define DMA_IRQ_PKG			BIT(1)
> +#define DMA_IRQ_QUEUE			BIT(2)
> +
> +#define DMA_IRQ_CHAN_NR			8
> +#define DMA_IRQ_CHAN_WIDTH		4
> +
> +
> +#define DMA_IRQ_STAT(x)		((x) * 0x04 + 0x10)
> +
> +#define DMA_STAT		0x30
> +
> +/*
> + * Channels specific registers
> + */
> +#define DMA_CHAN_ENABLE		0x00
> +#define DMA_CHAN_ENABLE_START		BIT(0)
> +#define DMA_CHAN_ENABLE_STOP		0
> +
> +#define DMA_CHAN_PAUSE		0x04
> +#define DMA_CHAN_PAUSE_PAUSE		BIT(1)
> +#define DMA_CHAN_PAUSE_RESUME		0
> +
> +#define DMA_CHAN_LLI_ADDR	0x08
> +
> +#define DMA_CHAN_CUR_CFG	0x0c
> +#define DMA_CHAN_CFG_SRC_DRQ(x)		((x) & 0x1f)
> +#define DMA_CHAN_CFG_SRC_IO_MODE	BIT(5)
> +#define DMA_CHAN_CFG_SRC_LINEAR_MODE	(0 << 5)
> +#define DMA_CHAN_CFG_SRC_BURST(x)	(((x) & 0x3) << 7)
> +#define DMA_CHAN_CFG_SRC_WIDTH(x)	(((x) & 0x3) << 9)
> +
> +#define DMA_CHAN_CFG_DST_DRQ(x)		(DMA_CHAN_CFG_SRC_DRQ(x) << 16)
> +#define DMA_CHAN_CFG_DST_IO_MODE	(DMA_CHAN_CFG_SRC_IO_MODE << 16)
> +#define DMA_CHAN_CFG_DST_LINEAR_MODE	(DMA_CHAN_CFG_SRC_LINEAR_MODE << 16)
> +#define DMA_CHAN_CFG_DST_BURST(x)	(DMA_CHAN_CFG_SRC_BURST(x) << 16)
> +#define DMA_CHAN_CFG_DST_WIDTH(x)	(DMA_CHAN_CFG_SRC_WIDTH(x) << 16)
> +
> +#define DMA_CHAN_CUR_SRC	0x10
> +
> +#define DMA_CHAN_CUR_DST	0x14
> +
> +#define DMA_CHAN_CUR_CNT	0x18
> +
> +#define DMA_CHAN_CUR_PARA	0x1c
> +
> +
> +/*
> + * Various hardware related defines
> + */
> +#define LLI_LAST_ITEM	0xfffff800
> +#define NORMAL_WAIT	8
> +#define DRQ_SDRAM	1
> +
> +/*
> + * Hardware representation of the LLI
> + *
> + * The hardware will be fed the physical address of this structure,
> + * and read its content in order to start the transfer.
> + */
> +struct sun6i_dma_lli {
> +	u32			cfg;
> +	dma_addr_t		src;
> +	dma_addr_t		dst;
> +	u32			len;
> +	u32			para;
> +	dma_addr_t		p_lli_next;
> +	struct sun6i_dma_lli	*v_lli_next;
> +} __packed;

dma_addr_t could be different depending on platform configuration. If
your hardware is using constant length of those field I think would be
better to use something reliable in that case.

> +
> +
> +struct sun6i_desc {
> +	struct virt_dma_desc	vd;
> +	dma_addr_t		p_lli;
> +	struct sun6i_dma_lli	*v_lli;
> +};
> +
> +struct sun6i_pchan {
> +	u32			idx;
> +	void __iomem		*base;
> +	struct sun6i_vchan	*vchan;
> +	struct sun6i_desc	*desc;
> +	struct sun6i_desc	*done;
> +};
> +
> +struct sun6i_vchan {
> +	struct virt_dma_chan	vc;
> +	struct list_head	node;
> +	struct dma_slave_config	cfg;
> +	struct sun6i_pchan	*phy;
> +	u8			port;
> +};
> +
> +struct sun6i_dma_dev {
> +	struct dma_device	slave;
> +	void __iomem		*base;
> +	struct clk		*clk;
> +	struct reset_control	*rstc;
> +	spinlock_t		lock;
> +	struct tasklet_struct	task;
> +	struct list_head	pending;
> +	struct dma_pool		*pool;
> +	struct sun6i_pchan	*pchans;
> +	struct sun6i_vchan	*vchans;
> +};
> +
> +static struct device *chan2dev(struct dma_chan *chan)
> +{
> +	return &chan->dev->device;
> +}
> +
> +static inline struct sun6i_dma_dev *to_sun6i_dma_dev(struct dma_device *d)
> +{
> +	return container_of(d, struct sun6i_dma_dev, slave);
> +}
> +
> +static inline struct sun6i_vchan *to_sun6i_vchan(struct dma_chan *chan)
> +{
> +	return container_of(chan, struct sun6i_vchan, vc.chan);
> +}
> +
> +static inline struct sun6i_desc *
> +to_sun6i_desc(struct dma_async_tx_descriptor *tx)
> +{
> +	return container_of(tx, struct sun6i_desc, vd.tx);
> +}
> +
> +static inline void sun6i_dma_dump_com_regs(struct sun6i_dma_dev *sdev)
> +{
> +	pr_debug("Common register:\n"
> +		 "\tmask0(%04x): 0x%08x\n"
> +		 "\tmask1(%04x): 0x%08x\n"
> +		 "\tpend0(%04x): 0x%08x\n"
> +		 "\tpend1(%04x): 0x%08x\n"
> +		 "\tstats(%04x): 0x%08x\n",
> +		 DMA_IRQ_EN(0), readl(sdev->base + DMA_IRQ_EN(0)),
> +		 DMA_IRQ_EN(1), readl(sdev->base + DMA_IRQ_EN(1)),
> +		 DMA_IRQ_STAT(0), readl(sdev->base + DMA_IRQ_STAT(0)),
> +		 DMA_IRQ_STAT(1), readl(sdev->base + DMA_IRQ_STAT(1)),
> +		 DMA_STAT, readl(sdev->base + DMA_STAT));

dev_dbg() ?

> +}
> +
> +static inline void sun6i_dma_dump_chan_regs(struct sun6i_pchan *pchan)
> +{
> +	pr_debug("Chan %d reg: 0x%x\n"
> +		 "\t___en(%04x): \t0x%08x\n"
> +		 "\tpause(%04x): \t0x%08x\n"
> +		 "\tstart(%04x): \t0x%08x\n"
> +		 "\t__cfg(%04x): \t0x%08x\n"
> +		 "\t__src(%04x): \t0x%08x\n"
> +		 "\t__dst(%04x): \t0x%08x\n"
> +		 "\tcount(%04x): \t0x%08x\n"
> +		 "\t_para(%04x): \t0x%08x\n\n",
> +		 pchan->idx, __virt_to_phys((unsigned long)pchan->base),
> +		 DMA_CHAN_ENABLE,
> +		 readl(pchan->base + DMA_CHAN_ENABLE),
> +		 DMA_CHAN_PAUSE,
> +		 readl(pchan->base + DMA_CHAN_PAUSE),
> +		 DMA_CHAN_LLI_ADDR,
> +		 readl(pchan->base + DMA_CHAN_LLI_ADDR),
> +		 DMA_CHAN_CUR_CFG,
> +		 readl(pchan->base + DMA_CHAN_CUR_CFG),
> +		 DMA_CHAN_CUR_SRC,
> +		 readl(pchan->base + DMA_CHAN_CUR_SRC),
> +		 DMA_CHAN_CUR_DST,
> +		 readl(pchan->base + DMA_CHAN_CUR_DST),
> +		 DMA_CHAN_CUR_CNT,
> +		 readl(pchan->base + DMA_CHAN_CUR_CNT),
> +		 DMA_CHAN_CUR_PARA,
> +		 readl(pchan->base + DMA_CHAN_CUR_PARA));

Ditto.

> +}
> +
> +static inline u8 convert_burst(u8 maxburst)
> +{
> +	if (maxburst == 1 || maxburst > 16)
> +		return 0;
> +
> +	return ilog2(maxburst) - 1;

fls() - 1 ?

> +}
> +
> +static inline u8 convert_buswidth(enum dma_slave_buswidth addr_width)
> +{
> +	switch (addr_width) {
> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +		return 1;
> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +		return 2;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static void *sun6i_dma_lli_add(struct sun6i_dma_lli *prev,
> +			       struct sun6i_dma_lli *next,
> +			       dma_addr_t next_phy,
> +			       struct sun6i_desc *txd)
> +{
> +	if ((!prev && !txd) || !next)
> +		return NULL;
> +
> +	if (!prev) {
> +		txd->p_lli = next_phy;
> +		txd->v_lli = next;
> +	} else {
> +		prev->p_lli_next = next_phy;
> +		prev->v_lli_next = next;
> +	}
> +
> +	next->p_lli_next = LLI_LAST_ITEM;
> +	next->v_lli_next = NULL;
> +
> +	return next;
> +}
> +
> +static inline void sun6i_dma_cfg_lli(struct sun6i_dma_lli *lli,
> +				     dma_addr_t src,
> +				     dma_addr_t dst, u32 len,
> +				     struct dma_slave_config *config)
> +{
> +	u32 src_width, dst_width, src_burst, dst_burst;
> +
> +	if (!config)
> +		return;
> +
> +	src_burst = convert_burst(config->src_maxburst);
> +	dst_burst = convert_burst(config->dst_maxburst);
> +
> +	src_width = convert_buswidth(config->src_addr_width);
> +	dst_width = convert_buswidth(config->dst_addr_width);
> +
> +	lli->cfg = DMA_CHAN_CFG_SRC_BURST(src_burst) |
> +		DMA_CHAN_CFG_SRC_WIDTH(src_width) |
> +		DMA_CHAN_CFG_DST_BURST(dst_burst) |
> +		DMA_CHAN_CFG_DST_WIDTH(dst_width);
> +
> +	lli->src = src;
> +	lli->dst = dst;
> +	lli->len = len;
> +	lli->para = NORMAL_WAIT;
> +
> +}
> +
> +static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
> +				      struct sun6i_dma_lli *lli)
> +{
> +	dev_dbg(chan2dev(&vchan->vc.chan),
> +		"\n\tdesc:   p - 0x%08x v - 0x%08x\n"
> +		"\t\tc - 0x%08x s - 0x%08x d - 0x%08x\n"
> +		"\t\tl - 0x%08x p - 0x%08x n - 0x%08x\n",
> +		__virt_to_phys((unsigned long)lli), (u32)lli,
> +		lli->cfg, lli->src, lli->dst,
> +		lli->len, lli->para, lli->p_lli_next);
> +}
> +
> +static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
> +{
> +	struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vd->tx.chan->device);
> +	struct sun6i_dma_lli *v_lli, *v_next;
> +	dma_addr_t p_lli, p_next;
> +
> +	if (unlikely(!txd))
> +		return;
> +
> +	p_lli = txd->p_lli;
> +	v_lli = txd->v_lli;
> +
> +	while (v_lli) {
> +		v_next = v_lli->v_lli_next;
> +		p_next = v_lli->p_lli_next;
> +
> +		dma_pool_free(sdev->pool, v_lli, p_lli);
> +
> +		v_lli = v_next;
> +		p_lli = p_next;
> +	}
> +
> +	kfree(txd);
> +}
> +
> +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
> +	struct sun6i_pchan *pchan = vchan->phy;
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock(&sdev->lock);
> +	list_del_init(&vchan->node);
> +	spin_unlock(&sdev->lock);
> +
> +	spin_lock_irqsave(&vchan->vc.lock, flags);
> +
> +	vchan_get_all_descriptors(&vchan->vc, &head);
> +
> +	if (pchan) {
> +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> +
> +		vchan->phy = NULL;
> +		pchan->vchan = NULL;
> +		pchan->desc = NULL;
> +		pchan->done = NULL;
> +	}
> +
> +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> +
> +	vchan_dma_desc_free_list(&vchan->vc, &head);
> +
> +	return 0;
> +}
> +
> +static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
> +	struct virt_dma_desc *desc = vchan_next_desc(&vchan->vc);
> +	struct sun6i_pchan *pchan = vchan->phy;
> +	u32 irq_val, irq_reg, irq_offset;
> +
> +	if (!pchan)
> +		return -EAGAIN;
> +
> +	if (!desc) {
> +		pchan->desc = NULL;
> +		pchan->done = NULL;
> +		return -EAGAIN;
> +	}
> +
> +	list_del(&desc->node);
> +
> +	pchan->desc = to_sun6i_desc(&desc->tx);
> +	pchan->done = NULL;
> +
> +	sun6i_dma_dump_lli(vchan, pchan->desc->v_lli);
> +
> +	irq_reg = pchan->idx / DMA_IRQ_CHAN_NR;
> +	irq_offset = pchan->idx % DMA_IRQ_CHAN_NR;
> +
> +	irq_val = readl(sdev->base + DMA_IRQ_EN(irq_offset));
> +	irq_val |= DMA_IRQ_QUEUE << (irq_offset * DMA_IRQ_CHAN_WIDTH);
> +	writel(irq_val, sdev->base + DMA_IRQ_EN(irq_offset));
> +
> +	writel(pchan->desc->p_lli, pchan->base + DMA_CHAN_LLI_ADDR);
> +	writel(DMA_CHAN_ENABLE_START, pchan->base + DMA_CHAN_ENABLE);
> +
> +	sun6i_dma_dump_com_regs(sdev);
> +	sun6i_dma_dump_chan_regs(pchan);
> +
> +	return 0;
> +}
> +
> +static void sun6i_dma_tasklet(unsigned long data)
> +{
> +	struct sun6i_dma_dev *sdev = (struct sun6i_dma_dev *)data;
> +	struct sun6i_vchan *vchan;
> +	struct sun6i_pchan *pchan;
> +	unsigned int pchan_alloc = 0;
> +	unsigned int pchan_idx;
> +
> +	list_for_each_entry(vchan, &sdev->slave.channels, vc.chan.device_node) {
> +		spin_lock_irq(&vchan->vc.lock);
> +
> +		pchan = vchan->phy;
> +
> +		if (pchan && pchan->done) {
> +			if (sun6i_dma_start_desc(vchan)) {
> +				/*
> +				 * No current txd associated with this channel
> +				 */
> +				dev_dbg(sdev->slave.dev, "pchan %u: free\n",
> +					pchan->idx);
> +
> +				/* Mark this channel free */
> +				vchan->phy = NULL;
> +				pchan->vchan = NULL;
> +			}
> +		}
> +		spin_unlock_irq(&vchan->vc.lock);
> +	}
> +
> +	spin_lock_irq(&sdev->lock);
> +	for (pchan_idx = 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> +		pchan = &sdev->pchans[pchan_idx];
> +
> +		if (pchan->vchan == NULL && !list_empty(&sdev->pending)) {
> +			vchan = list_first_entry(&sdev->pending,
> +						 struct sun6i_vchan, node);
> +
> +			/* remove from pending channels */

Keep style in the comments. Like capital letter to start sentence with.

> +			list_del_init(&vchan->node);
> +			pchan_alloc |= BIT(pchan_idx);
> +
> +			/* Mark this channel allocated */
> +			pchan->vchan = vchan;
> +			vchan->phy = pchan;
> +			dev_dbg(sdev->slave.dev, "pchan %u: alloc vchan %p\n",
> +				pchan->idx, &vchan->vc);
> +		}
> +	}
> +	spin_unlock_irq(&sdev->lock);
> +
> +	for (pchan_idx = 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> +		if (pchan_alloc & BIT(pchan_idx)) {
> +			pchan = sdev->pchans + pchan_idx;
> +			vchan = pchan->vchan;
> +			if (vchan) {
> +				spin_lock_irq(&vchan->vc.lock);
> +				sun6i_dma_start_desc(vchan);
> +				spin_unlock_irq(&vchan->vc.lock);
> +			}
> +		}
> +	}
> +}
> +
> +static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
> +{
> +	struct sun6i_dma_dev *sdev = (struct sun6i_dma_dev *)dev_id;
> +	struct sun6i_vchan *vchan;
> +	struct sun6i_pchan *pchan;
> +	int i, j, ret = 0;
> +	u32 status;
> +
> +	for (i = 0; i < 2; i++) {
> +		status = readl(sdev->base + DMA_IRQ_STAT(i));
> +		if (!status) {
> +			ret |= IRQ_NONE;

Maybe move this to definition block.

> +			continue;
> +		}
> +
> +		dev_dbg(sdev->slave.dev, "DMA irq status %s: 0x%x\n",
> +			i ? "high" : "low", status);
> +
> +		writel(status, sdev->base + DMA_IRQ_STAT(i));
> +
> +		for (j = 0; (j < 8) && status; j++) {
> +			if (status & DMA_IRQ_QUEUE) {
> +				pchan = sdev->pchans + j;
> +				vchan = pchan->vchan;
> +
> +				if (vchan) {
> +					unsigned long flags;
> +
> +					spin_lock_irqsave(&vchan->vc.lock,
> +							  flags);
> +					vchan_cookie_complete(&pchan->desc->vd);
> +					pchan->done = pchan->desc;
> +					spin_unlock_irqrestore(&vchan->vc.lock,
> +							       flags);
> +				}
> +			}
> +
> +			status = status >> 4;
> +		}
> +
> +		ret |= IRQ_HANDLED;

In case one is handled, another is not, what you have to do?

> +	}
> +
> +	if (ret == IRQ_HANDLED)
> +		tasklet_schedule(&sdev->task);
> +
> +	return ret;
> +}
> +
> +static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
> +		struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> +		size_t len, unsigned long flags)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	struct dma_slave_config *sconfig = &vchan->cfg;
> +	struct sun6i_dma_lli *v_lli;
> +	struct sun6i_desc *txd;
> +	dma_addr_t p_lli;
> +
> +	dev_dbg(chan2dev(chan),
> +		"%s; chan: %d, dest: 0x%08x, src: 0x%08x, len: 0x%08x. flags: 0x%08lx\n",
> +		__func__, vchan->vc.chan.chan_id, dest, src, len, flags);
> +
> +	if (!len)
> +		return NULL;
> +
> +	txd = kzalloc(sizeof(*txd), GFP_NOWAIT);
> +	if (!txd)
> +		return NULL;
> +
> +	v_lli = dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
> +	if (!v_lli) {
> +		dev_err(sdev->slave.dev, "Failed to alloc lli memory\n");
> +		kfree(txd);
> +		return NULL;
> +	}
> +
> +	sun6i_dma_cfg_lli(v_lli, src, dest, len, sconfig);
> +	v_lli->cfg |= DMA_CHAN_CFG_SRC_DRQ(DRQ_SDRAM) |
> +		DMA_CHAN_CFG_DST_DRQ(DRQ_SDRAM) |
> +		DMA_CHAN_CFG_DST_LINEAR_MODE |
> +		DMA_CHAN_CFG_SRC_LINEAR_MODE;
> +
> +	sun6i_dma_lli_add(NULL, v_lli, p_lli, txd);
> +
> +	sun6i_dma_dump_lli(vchan, v_lli);
> +
> +	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
> +}
> +
> +static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction dir,
> +		unsigned long flags, void *context)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	struct dma_slave_config *sconfig = &vchan->cfg;
> +	struct sun6i_dma_lli *v_lli, *prev = NULL;
> +	struct sun6i_desc *txd;
> +	struct scatterlist *sg;
> +	dma_addr_t p_lli;
> +	int i;
> +
> +	if (!sgl)
> +		return NULL;
> +
> +	txd = kzalloc(sizeof(*txd), GFP_NOWAIT);
> +	if (!txd)
> +		return NULL;
> +
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		v_lli = dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
> +		if (!v_lli) {
> +			kfree(txd);
> +			return NULL;
> +		}
> +
> +		if (dir == DMA_MEM_TO_DEV) {
> +			sun6i_dma_cfg_lli(v_lli, sg_dma_address(sg),
> +					  sconfig->dst_addr, sg_dma_len(sg),
> +					  sconfig);
> +			v_lli->cfg |= DMA_CHAN_CFG_DST_IO_MODE |
> +				DMA_CHAN_CFG_SRC_LINEAR_MODE |
> +				DMA_CHAN_CFG_SRC_DRQ(DRQ_SDRAM) |
> +				DMA_CHAN_CFG_DST_DRQ(vchan->port);
> +
> +			dev_dbg(chan2dev(chan), "%s; chan: %d, dest: 0x%08x, "
> +				"src: 0x%08x, len: 0x%08x. flags: 0x%08lx\n",
> +				__func__, vchan->vc.chan.chan_id,
> +				sconfig->dst_addr, sg_dma_address(sg),
> +				sg_dma_len(sg), flags);
> +
> +		} else if (dir == DMA_DEV_TO_MEM) {
> +			sun6i_dma_cfg_lli(v_lli, sconfig->src_addr,
> +					  sg_dma_address(sg), sg_dma_len(sg),
> +					  sconfig);
> +			v_lli->cfg |= DMA_CHAN_CFG_DST_LINEAR_MODE |
> +				DMA_CHAN_CFG_SRC_IO_MODE |
> +				DMA_CHAN_CFG_DST_DRQ(DRQ_SDRAM) |
> +				DMA_CHAN_CFG_SRC_DRQ(vchan->port);
> +
> +			dev_dbg(chan2dev(chan), "%s; chan: %d, dest: 0x%08x, "
> +				"src: 0x%08x, len: 0x%08x. flags: 0x%08lx\n",
> +				__func__, vchan->vc.chan.chan_id,
> +				sg_dma_address(sg), sconfig->src_addr,
> +				sg_dma_len(sg), flags);
> +		}
> +
> +		prev = sun6i_dma_lli_add(prev, v_lli, p_lli, txd);
> +	}
> +
> +#ifdef DEBUG
> +	dev_dbg(chan2dev(chan), "First: 0x%08x\n", txd->p_lli);
> +	for (prev = txd->v_lli; prev != NULL; prev = prev->v_lli_next)
> +		sun6i_dma_dump_lli(vchan, prev);
> +#endif
> +
> +	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
> +}
> +
> +static int sun6i_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +		       unsigned long arg)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	struct sun6i_pchan *pchan = vchan->phy;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case DMA_RESUME:
> +		dev_dbg(chan2dev(chan), "vchan %p: resume\n", &vchan->vc);
> +
> +		spin_lock_irqsave(&vchan->vc.lock, flags);
> +
> +		if (pchan) {
> +			writel(DMA_CHAN_PAUSE_RESUME,
> +			       pchan->base + DMA_CHAN_PAUSE);
> +		} else if (!list_empty(&vchan->vc.desc_issued)) {
> +			spin_lock(&sdev->lock);
> +			list_add_tail(&vchan->node, &sdev->pending);
> +			spin_unlock(&sdev->lock);
> +		}
> +
> +		spin_unlock_irqrestore(&vchan->vc.lock, flags);
> +		break;
> +
> +	case DMA_PAUSE:
> +		dev_dbg(chan2dev(chan), "vchan %p: pause\n", &vchan->vc);
> +
> +		if (pchan) {
> +			writel(DMA_CHAN_PAUSE_PAUSE,
> +			       pchan->base + DMA_CHAN_PAUSE);
> +		} else {
> +			spin_lock(&sdev->lock);
> +			list_del_init(&vchan->node);
> +			spin_unlock(&sdev->lock);
> +		}
> +		break;
> +
> +	case DMA_TERMINATE_ALL:
> +		ret = sun6i_dma_terminate_all(vchan);
> +		break;
> +	case DMA_SLAVE_CONFIG:
> +		memcpy(&vchan->cfg, (struct dma_slave_config *)arg,
> +		       sizeof(struct dma_slave_config));
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static enum dma_status sun6i_dma_tx_status(struct dma_chan *chan,
> +					   dma_cookie_t cookie,
> +					   struct dma_tx_state *state)
> +{
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	struct sun6i_pchan *pchan = vchan->phy;
> +	struct sun6i_dma_lli *lli;
> +	struct virt_dma_desc *vd;
> +	struct sun6i_desc *txd;
> +	enum dma_status ret;
> +	unsigned long flags;
> +	size_t bytes = 0;
> +
> +	ret = dma_cookie_status(chan, cookie, state);
> +	if (ret == DMA_COMPLETE)
> +		return ret;
> +
> +	spin_lock_irqsave(&vchan->vc.lock, flags);
> +
> +	vd = vchan_find_desc(&vchan->vc, cookie);
> +	txd = to_sun6i_desc(&vd->tx);
> +
> +	if (vd) {
> +		for (lli = txd->v_lli; lli != NULL; lli = lli->v_lli_next)
> +			bytes += lli->len;
> +	} else if (!pchan || !pchan->desc) {
> +		bytes = 0;
> +	} else {
> +		bytes = readl(pchan->base + DMA_CHAN_CUR_CNT);
> +	}
> +
> +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> +
> +	dma_set_residue(state, bytes);
> +
> +	return ret;
> +}
> +
> +static void sun6i_dma_issue_pending(struct dma_chan *chan)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vchan->vc.lock, flags);
> +
> +	if (vchan_issue_pending(&vchan->vc)) {
> +		spin_lock(&sdev->lock);
> +
> +		if (!vchan->phy) {
> +			if (list_empty(&vchan->node)) {
> +				list_add_tail(&vchan->node, &sdev->pending);
> +				tasklet_schedule(&sdev->task);
> +				dev_dbg(chan2dev(chan), "vchan %p: issued\n",
> +					&vchan->vc);
> +			}
> +		}
> +
> +		spin_unlock(&sdev->lock);
> +	} else {
> +		dev_dbg(chan2dev(chan), "vchan %p: nothing to issue\n",
> +			&vchan->vc);
> +	}
> +
> +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> +}
> +
> +static int sun6i_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	return 0;
> +}
> +
> +static void sun6i_dma_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
> +	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sdev->lock, flags);
> +	list_del_init(&vchan->node);
> +	spin_unlock_irqrestore(&sdev->lock, flags);
> +
> +	vchan_free_chan_resources(&vchan->vc);
> +}
> +
> +static inline void sun6i_dma_free(struct sun6i_dma_dev *sdc)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_MAX_VCHANS; i++) {
> +		struct sun6i_vchan *vchan = &sdc->vchans[i];
> +
> +		list_del(&vchan->vc.chan.device_node);
> +		tasklet_kill(&vchan->vc.task);
> +	}
> +
> +	tasklet_kill(&sdc->task);
> +}
> +
> +static struct dma_chan *sun6i_dma_of_xlate(struct of_phandle_args *dma_spec,
> +					   struct of_dma *ofdma)
> +{
> +	struct sun6i_dma_dev *sdev = ofdma->of_dma_data;
> +	struct sun6i_vchan *vchan;
> +	struct dma_chan *chan;
> +	u8 port = dma_spec->args[0];
> +
> +	if (port > NR_MAX_REQUESTS)
> +		return NULL;
> +
> +	chan = dma_get_any_slave_channel(&sdev->slave);
> +	if (!chan)
> +		return NULL;
> +
> +	vchan = to_sun6i_vchan(chan);
> +	vchan->port = port;
> +
> +	return chan;
> +}
> +
> +static int sun6i_dma_probe(struct platform_device *pdev)
> +{
> +	struct sun6i_dma_dev *sdc;
> +	struct resource *res;
> +	int irq;
> +	int ret, i;
> +
> +	sdc = devm_kzalloc(&pdev->dev, sizeof(*sdc), GFP_KERNEL);
> +	if (!sdc)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sdc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sdc->base))
> +		return PTR_ERR(sdc->base);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, irq, sun6i_dma_interrupt, 0,
> +			       dev_name(&pdev->dev), sdc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot request IRQ\n");
> +		return ret;
> +	}
> +
> +	sdc->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(sdc->clk)) {
> +		dev_err(&pdev->dev, "No clock specified\n");
> +		return PTR_ERR(sdc->clk);
> +	}
> +
> +	sdc->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(sdc->rstc)) {
> +		dev_err(&pdev->dev, "No reset controller specified\n");
> +		return PTR_ERR(sdc->rstc);
> +	}
> +
> +	sdc->pool = dma_pool_create(dev_name(&pdev->dev), &pdev->dev,
> +					sizeof(struct sun6i_dma_lli), 4, 0);

dmam_pool_create()

> +	if (!sdc->pool) {
> +		dev_err(&pdev->dev, "No memory for descriptors dma pool\n");
> +		return -ENOMEM;
> +	}
> +
> +	platform_set_drvdata(pdev, sdc);
> +	INIT_LIST_HEAD(&sdc->pending);
> +	spin_lock_init(&sdc->lock);
> +
> +	dma_cap_set(DMA_PRIVATE, sdc->slave.cap_mask);
> +	dma_cap_set(DMA_MEMCPY, sdc->slave.cap_mask);
> +	dma_cap_set(DMA_SLAVE, sdc->slave.cap_mask);
> +
> +	INIT_LIST_HEAD(&sdc->slave.channels);
> +	sdc->slave.device_alloc_chan_resources	= sun6i_dma_alloc_chan_resources;
> +	sdc->slave.device_free_chan_resources	= sun6i_dma_free_chan_resources;
> +	sdc->slave.device_tx_status		= sun6i_dma_tx_status;
> +	sdc->slave.device_issue_pending		= sun6i_dma_issue_pending;
> +	sdc->slave.device_prep_slave_sg		= sun6i_dma_prep_slave_sg;
> +	sdc->slave.device_prep_dma_memcpy	= sun6i_dma_prep_dma_memcpy;
> +	sdc->slave.device_control		= sun6i_dma_control;
> +	sdc->slave.chancnt			= NR_MAX_VCHANS;
> +
> +	sdc->slave.dev = &pdev->dev;
> +
> +	sdc->pchans = devm_kzalloc(&pdev->dev,
> +				   NR_MAX_CHANNELS * sizeof(struct sun6i_pchan),
> +				   GFP_KERNEL);
> +	if (!sdc->pchans) {
> +		ret = -ENOMEM;
> +		goto err_dma_pool_destroy;
> +	}
> +
> +	sdc->vchans = devm_kzalloc(&pdev->dev,
> +				   NR_MAX_VCHANS * sizeof(struct sun6i_vchan),
> +				   GFP_KERNEL);
> +	if (!sdc->vchans) {
> +		ret = -ENOMEM;
> +		goto err_dma_pool_destroy;
> +	}
> +
> +	tasklet_init(&sdc->task, sun6i_dma_tasklet, (unsigned long)sdc);
> +
> +	for (i = 0; i < NR_MAX_CHANNELS; i++) {
> +		struct sun6i_pchan *pchan = &sdc->pchans[i];
> +
> +		pchan->idx = i;
> +		pchan->base = sdc->base + 0x100 + i * 0x40;
> +	}
> +
> +	for (i = 0; i < NR_MAX_VCHANS; i++) {
> +		struct sun6i_vchan *vchan = &sdc->vchans[i];
> +
> +		INIT_LIST_HEAD(&vchan->node);
> +		vchan->vc.desc_free = sun6i_dma_free_desc;
> +		vchan_init(&vchan->vc, &sdc->slave);
> +	}
> +
> +	reset_control_deassert(sdc->rstc);
> +
> +	clk_prepare_enable(sdc->clk);

Would you like to check an return code here?

> +
> +	ret = dma_async_device_register(&sdc->slave);
> +	if (ret) {
> +		dev_warn(&pdev->dev, "Failed to register DMA engine device\n");
> +		goto err_clk_disable;
> +	}
> +
> +	ret = of_dma_controller_register(pdev->dev.of_node, sun6i_dma_of_xlate,
> +					 sdc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "of_dma_controller_register failed\n");
> +		goto err_dma_unregister;
> +	}
> +
> +	return 0;
> +
> +err_dma_unregister:
> +	dma_async_device_unregister(&sdc->slave);
> +err_clk_disable:
> +	clk_disable_unprepare(sdc->clk);
> +	reset_control_assert(sdc->rstc);
> +	sun6i_dma_free(sdc);
> +err_dma_pool_destroy:
> +	dma_pool_destroy(sdc->pool);
> +	return ret;
> +}
> +
> +static int sun6i_dma_remove(struct platform_device *pdev)
> +{
> +	struct sun6i_dma_dev *sdc = platform_get_drvdata(pdev);
> +
> +	of_dma_controller_free(pdev->dev.of_node);
> +	dma_async_device_unregister(&sdc->slave);
> +
> +	clk_disable_unprepare(sdc->clk);
> +	reset_control_assert(sdc->rstc);
> +
> +	sun6i_dma_free(sdc);
> +
> +	dma_pool_destroy(sdc->pool);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id sun6i_dma_match[] = {
> +	{ .compatible = "allwinner,sun6i-a31-dma" }
> +};
> +
> +static struct platform_driver sun6i_dma_driver = {
> +	.probe		= sun6i_dma_probe,
> +	.remove		= sun6i_dma_remove,
> +	.driver = {
> +		.name		= "sun6i-dma",
> +		.of_match_table	= sun6i_dma_match,
> +	},
> +};
> +module_platform_driver(sun6i_dma_driver);
> +
> +MODULE_DESCRIPTION("Allwinner A31 DMA Controller Driver");
> +MODULE_AUTHOR("Sugar <shuge@allwinnertech.com>");
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
> +MODULE_LICENSE("GPL");


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

