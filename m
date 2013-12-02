Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab3LBVTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:19:52 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43055 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3LBTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:47 -0500
Message-ID: <529CDBA8.6070107@koalo.de>
Date: Mon, 02 Dec 2013 20:12:40 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>
Subject: [PATCHv8] dmaengine: Add support for BCM2835
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
Currently it only supports cyclic DMA.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

This version includes some more style improvements
suggested in the previous thread.

 .../devicetree/bindings/dma/bcm2835-dma.txt        |  57 ++
 drivers/dma/Kconfig                                |   6 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/bcm2835-dma.c                          | 727 +++++++++++++++++++++
 4 files changed, 791 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/bcm2835-dma.txt
 create mode 100644 drivers/dma/bcm2835-dma.c

diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
new file mode 100644
index 0000000..e7c31c1
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
@@ -0,0 +1,57 @@
+* BCM2835 DMA controller
+
+The BCM2835 DMA controller has 16 channels in total.
+Only the lower 13 channels have an associated IRQ.
+Some arbitrary channels are used by the firmware
+(1,3,6,7 in the current firmware version).
+The channels 0,2 and 3 have special functionality
+and should not be used by the driver.
+
+Required properties:
+- compatible: Should be "brcm,bcm2835-dma".
+- reg: Should contain DMA registers location and length.
+- interrupts: Should contain the DMA interrupts associated
+		to the DMA channels in ascending order.
+- #dma-cells: Must be <1>, the cell in the dmas property of the
+		client device represents the DREQ number.
+- brcm,dma-channel-mask: Bit mask representing the channels
+			 not used by the firmware in ascending order,
+			 i.e. first channel corresponds to LSB.
+
+Example:
+
+dma: dma@7e007000 {
+	compatible = "brcm,bcm2835-dma";
+	reg = <0x7e007000 0xf00>;
+	interrupts = <1 16>
+		     <1 17>
+		     <1 18>
+		     <1 19>
+		     <1 20>
+		     <1 21>
+		     <1 22>
+		     <1 23>
+		     <1 24>
+		     <1 25>
+		     <1 26>
+		     <1 27>
+		     <1 28>;
+
+	#dma-cells = <1>;
+	brcm,dma-channel-mask = <0x7f35>;
+};
+
+DMA clients connected to the BCM2835 DMA controller must use the format
+described in the dma.txt file, using a two-cell specifier for each channel.
+
+Example:
+
+bcm2835_i2s: i2s@7e203000 {
+	compatible = "brcm,bcm2835-i2s";
+	reg = <	0x7e203000 0x20>
+	      < 0x7e101098 0x02>;
+
+	dmas = <&dma 2>
+	       <&dma 3>;
+	dma-names = "tx", "rx";
+};
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index c61a6ec..880e723 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -300,6 +300,12 @@ config DMA_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
+config DMA_BCM2835
+	tristate "BCM2835 DMA engine support"
+	depends on (ARCH_BCM2835 || MACH_BCM2708)
+	select DMA_ENGINE
+	select DMA_VIRTUAL_CHANNELS
+
 config TI_CPPI41
 	tristate "AM33xx CPPI41 DMA support"
 	depends on ARCH_OMAP
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 0ce2da9..0a6f08e 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
 obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
 obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
+obj-$(CONFIG_DMA_BCM2835) += bcm2835-dma.o
 obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
 obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
 obj-$(CONFIG_TI_CPPI41) += cppi41.o
diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
new file mode 100644
index 0000000..a9d34df
--- /dev/null
+++ b/drivers/dma/bcm2835-dma.c
@@ -0,0 +1,727 @@
+/*
+ * BCM2835 DMA engine support
+ *
+ * This driver only supports cyclic DMA transfers
+ * as needed for the I2S module.
+ *
+ * Author:      Florian Meier <florian.meier@koalo.de>
+ *              Copyright 2013
+ *
+ * Based on
+ *	OMAP DMAengine support by Russell King
+ *
+ *	BCM2708 DMA Driver
+ *	Copyright (C) 2010 Broadcom
+ *
+ *	Raspberry Pi PCM I2S ALSA Driver
+ *	Copyright (c) by Phil Poole 2013
+ *
+ *	MARVELL MMP Peripheral DMA Driver
+ *	Copyright 2012 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/of.h>
+#include <linux/of_dma.h>
+
+#include "virt-dma.h"
+
+struct bcm2835_dmadev {
+	struct dma_device ddev;
+	spinlock_t lock;
+	void __iomem *base;
+	struct device_dma_parameters dma_parms;
+};
+
+struct bcm2835_dma_cb {
+	uint32_t info;
+	uint32_t src;
+	uint32_t dst;
+	uint32_t length;
+	uint32_t stride;
+	uint32_t next;
+	uint32_t pad[2];
+};
+
+struct bcm2835_chan {
+	struct virt_dma_chan vc;
+	struct list_head node;
+
+	struct dma_slave_config	cfg;
+	bool cyclic;
+	unsigned int dreq;
+
+	int ch;
+	struct bcm2835_desc *desc;
+
+	void __iomem *chan_base;
+	int irq_number;
+};
+
+struct bcm2835_desc {
+	struct virt_dma_desc vd;
+	enum dma_transfer_direction dir;
+
+	unsigned int control_block_size;
+	struct bcm2835_dma_cb *control_block_base;
+	dma_addr_t control_block_base_phys;
+
+	unsigned int frames;
+	size_t size;
+};
+
+#define BCM2835_DMA_CS		0x00
+#define BCM2835_DMA_ADDR	0x04
+#define BCM2835_DMA_SOURCE_AD	0x0c
+#define BCM2835_DMA_DEST_AD	0x10
+#define BCM2835_DMA_NEXTCB	0x1C
+
+/* DMA CS Control and Status bits */
+#define BCM2835_DMA_ACTIVE	BIT(0)
+#define BCM2835_DMA_INT	BIT(2)
+#define BCM2835_DMA_ISPAUSED	BIT(4)  /* Pause requested or not active */
+#define BCM2835_DMA_ISHELD	BIT(5)  /* Is held by DREQ flow control */
+#define BCM2835_DMA_ERR	BIT(8)
+#define BCM2835_DMA_ABORT	BIT(30) /* Stop current CB, go to next, WO */
+#define BCM2835_DMA_RESET	BIT(31) /* WO, self clearing */
+
+#define BCM2835_DMA_INT_EN	BIT(0)
+#define BCM2835_DMA_D_INC	BIT(4)
+#define BCM2835_DMA_D_DREQ	BIT(6)
+#define BCM2835_DMA_S_INC	BIT(8)
+#define BCM2835_DMA_S_DREQ	BIT(10)
+
+#define BCM2835_DMA_PER_MAP(x)	((x) << 16)
+
+#define BCM2835_DMA_DATA_TYPE_S8	1
+#define BCM2835_DMA_DATA_TYPE_S16	2
+#define BCM2835_DMA_DATA_TYPE_S32	4
+#define BCM2835_DMA_DATA_TYPE_S128	16
+
+#define BCM2835_DMA_BULK_MASK	BIT(0)
+#define BCM2835_DMA_FIQ_MASK	(BIT(2) | BIT(3))
+
+/* Valid only for channels 0 - 14, 15 has its own base address */
+#define BCM2835_DMA_CHAN(n)	((n) << 8) /* Base address */
+#define BCM2835_DMA_CHANIO(base, n) ((base) + BCM2835_DMA_CHAN(n))
+
+static inline struct bcm2835_dmadev *to_bcm2835_dma_dev(struct dma_device *d)
+{
+	return container_of(d, struct bcm2835_dmadev, ddev);
+}
+
+static inline struct bcm2835_chan *to_bcm2835_dma_chan(struct dma_chan *c)
+{
+	return container_of(c, struct bcm2835_chan, vc.chan);
+}
+
+static inline struct bcm2835_desc *to_bcm2835_dma_desc(
+		struct dma_async_tx_descriptor *t)
+{
+	return container_of(t, struct bcm2835_desc, vd.tx);
+}
+
+static void bcm2835_dma_desc_free(struct virt_dma_desc *vd)
+{
+	struct bcm2835_desc *desc = container_of(vd, struct bcm2835_desc, vd);
+	dma_free_coherent(desc->vd.tx.chan->device->dev,
+			desc->control_block_size,
+			desc->control_block_base,
+			desc->control_block_base_phys);
+	kfree(desc);
+}
+
+static int bcm2835_dma_abort(void __iomem *chan_base)
+{
+	unsigned long cs;
+	long int timeout = 10000;
+
+	cs = readl(chan_base + BCM2835_DMA_CS);
+	if (!(cs & BCM2835_DMA_ACTIVE))
+		return 0;
+
+	/* Write 0 to the active bit - Pause the DMA */
+	writel(0, chan_base + BCM2835_DMA_CS);
+
+	/* Wait for any current AXI transfer to complete */
+	while ((cs & BCM2835_DMA_ISPAUSED) && --timeout) {
+		cpu_relax();
+		cs = readl(chan_base + BCM2835_DMA_CS);
+	}
+
+	/* We'll un-pause when we set of our next DMA */
+	if (!timeout)
+		return -ETIMEDOUT;
+
+	if (!(cs & BCM2835_DMA_ACTIVE))
+		return 0;
+
+	/* Terminate the control block chain */
+	writel(0, chan_base + BCM2835_DMA_NEXTCB);
+
+	/* Abort the whole DMA */
+	writel(BCM2835_DMA_ABORT | BCM2835_DMA_ACTIVE,
+	       chan_base + BCM2835_DMA_CS);
+
+	return 0;
+}
+
+static void bcm2835_dma_start_desc(struct bcm2835_chan *c)
+{
+	struct virt_dma_desc *vd = vchan_next_desc(&c->vc);
+	struct bcm2835_desc *d;
+
+	if (!vd) {
+		c->desc = NULL;
+		return;
+	}
+
+	list_del(&vd->node);
+
+	c->desc = d = to_bcm2835_dma_desc(&vd->tx);
+
+	writel(d->control_block_base_phys, c->chan_base + BCM2835_DMA_ADDR);
+	writel(BCM2835_DMA_ACTIVE, c->chan_base + BCM2835_DMA_CS);
+}
+
+static irqreturn_t bcm2835_dma_callback(int irq, void *data)
+{
+	struct bcm2835_chan *c = data;
+	struct bcm2835_desc *d;
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->vc.lock, flags);
+
+	/* Acknowledge interrupt */
+	writel(BCM2835_DMA_INT, c->chan_base + BCM2835_DMA_CS);
+
+	d = c->desc;
+
+	if (d) {
+		/* TODO Only works for cyclic DMA */
+		vchan_cyclic_callback(&d->vd);
+	}
+
+	/* Keep the DMA engine running */
+	writel(BCM2835_DMA_ACTIVE, c->chan_base + BCM2835_DMA_CS);
+
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+
+	dev_dbg(c->vc.chan.device->dev,
+			"Allocating DMA channel %d\n", c->ch);
+
+	return request_irq(c->irq_number,
+			bcm2835_dma_callback, 0, "DMA IRQ", c);
+}
+
+static void bcm2835_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+
+	vchan_free_chan_resources(&c->vc);
+	free_irq(c->irq_number, c);
+
+	dev_dbg(c->vc.chan.device->dev, "Freeing DMA channel %u\n", c->ch);
+}
+
+static size_t bcm2835_dma_desc_size(struct bcm2835_desc *d)
+{
+	return d->size;
+}
+
+static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
+{
+	unsigned int i;
+	size_t size;
+
+	for (size = i = 0; i < d->frames; i++) {
+		struct bcm2835_dma_cb *control_block =
+			&d->control_block_base[i];
+		size_t this_size = control_block->length;
+		dma_addr_t dma;
+
+		if (d->dir == DMA_DEV_TO_MEM)
+			dma = control_block->dst;
+		else
+			dma = control_block->src;
+
+		if (size)
+			size += this_size;
+		else if (addr >= dma && addr < dma + this_size)
+			size += dma + this_size - addr;
+	}
+
+	return size;
+}
+
+static enum dma_status bcm2835_dma_tx_status(struct dma_chan *chan,
+	dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	struct virt_dma_desc *vd;
+	enum dma_status ret;
+	unsigned long flags;
+
+	ret = dma_cookie_status(chan, cookie, txstate);
+	if (ret == DMA_SUCCESS || !txstate)
+		return ret;
+
+	spin_lock_irqsave(&c->vc.lock, flags);
+	vd = vchan_find_desc(&c->vc, cookie);
+	if (vd) {
+		txstate->residue =
+			bcm2835_dma_desc_size(to_bcm2835_dma_desc(&vd->tx));
+	} else if (c->desc && c->desc->vd.tx.cookie == cookie) {
+		struct bcm2835_desc *d = c->desc;
+		dma_addr_t pos;
+
+		if (d->dir == DMA_MEM_TO_DEV)
+			pos = readl(c->chan_base + BCM2835_DMA_SOURCE_AD);
+		else if (d->dir == DMA_DEV_TO_MEM)
+			pos = readl(c->chan_base + BCM2835_DMA_DEST_AD);
+		else
+			pos = 0;
+
+		txstate->residue = bcm2835_dma_desc_size_pos(d, pos);
+	} else {
+		txstate->residue = 0;
+	}
+
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+
+	return ret;
+}
+
+static void bcm2835_dma_issue_pending(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	unsigned long flags;
+
+	c->cyclic = true; /* Nothing else is implemented */
+
+	spin_lock_irqsave(&c->vc.lock, flags);
+	if (vchan_issue_pending(&c->vc) && !c->desc)
+		bcm2835_dma_start_desc(c);
+
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+}
+
+static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
+	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+	size_t period_len, enum dma_transfer_direction direction,
+	unsigned long flags, void *context)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	enum dma_slave_buswidth dev_width;
+	struct bcm2835_desc *d;
+	dma_addr_t dev_addr;
+	unsigned int es, sync_type;
+	unsigned int frame;
+
+	/* Grab configuration */
+	if (!is_slave_direction(direction)) {
+		dev_err(chan->device->dev, "%s: bad direction?\n", __func__);
+		return NULL;
+	}
+
+	if (direction == DMA_DEV_TO_MEM) {
+		dev_addr = c->cfg.src_addr;
+		dev_width = c->cfg.src_addr_width;
+		sync_type = BCM2835_DMA_S_DREQ;
+	} else {
+		dev_addr = c->cfg.dst_addr;
+		dev_width = c->cfg.dst_addr_width;
+		sync_type = BCM2835_DMA_D_DREQ;
+	}
+
+	/* Bus width translates to the element size (ES) */
+	switch (dev_width) {
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		es = BCM2835_DMA_DATA_TYPE_S32;
+		break;
+	default:
+		return NULL;
+	}
+
+	/* Now allocate and setup the descriptor. */
+	d = kzalloc(sizeof(*d), GFP_NOWAIT);
+	if (!d)
+		return NULL;
+
+	d->dir = direction;
+	d->frames = buf_len / period_len;
+
+	/* Allocate memory for control blocks */
+	d->control_block_size = d->frames * sizeof(struct bcm2835_dma_cb);
+	d->control_block_base = dma_zalloc_coherent(chan->device->dev,
+			d->control_block_size, &d->control_block_base_phys,
+			GFP_NOWAIT);
+
+	if (!d->control_block_base) {
+		kfree(d);
+		return NULL;
+	}
+
+	/*
+	 * Iterate over all frames, create a control block
+	 * for each frame and link them together.
+	 */
+	for (frame = 0; frame < d->frames; frame++) {
+		struct bcm2835_dma_cb *control_block =
+			&d->control_block_base[frame];
+
+		/* Setup adresses */
+		if (d->dir == DMA_DEV_TO_MEM) {
+			control_block->info = BCM2835_DMA_D_INC;
+			control_block->src = dev_addr;
+			control_block->dst = buf_addr + frame * period_len;
+		} else {
+			control_block->info = BCM2835_DMA_S_INC;
+			control_block->src = buf_addr + frame * period_len;
+			control_block->dst = dev_addr;
+		}
+
+		/* Enable interrupt */
+		control_block->info |= BCM2835_DMA_INT_EN;
+
+		/* Setup synchronization */
+		if (sync_type != 0)
+			control_block->info |= sync_type;
+
+		/* Setup DREQ channel */
+		if (c->dreq != 0)
+			control_block->info |=
+				BCM2835_DMA_PER_MAP(c->dreq);
+
+		/* Length of a frame */
+		control_block->length = period_len;
+		d->size += control_block->length;
+
+		/*
+		 * Next block is the next frame.
+		 * This DMA engine driver currently only supports cyclic DMA.
+		 * Therefore, wrap around at number of frames.
+		 */
+		control_block->next = d->control_block_base_phys +
+			sizeof(struct bcm2835_dma_cb)
+			* ((frame + 1) % d->frames);
+	}
+
+	return vchan_tx_prep(&c->vc, &d->vd, flags);
+}
+
+static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
+		struct dma_slave_config *cfg)
+{
+	if ((cfg->direction == DMA_DEV_TO_MEM &&
+	     cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
+	    (cfg->direction == DMA_MEM_TO_DEV &&
+	     cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
+	    !is_slave_direction(cfg->direction)) {
+		return -EINVAL;
+	}
+
+	c->cfg = *cfg;
+
+	return 0;
+}
+
+static int bcm2835_dma_terminate_all(struct bcm2835_chan *c)
+{
+	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(c->vc.chan.device);
+	unsigned long flags;
+	int timeout = 10000;
+	LIST_HEAD(head);
+
+	spin_lock_irqsave(&c->vc.lock, flags);
+
+	/* Prevent this channel being scheduled */
+	spin_lock(&d->lock);
+	list_del_init(&c->node);
+	spin_unlock(&d->lock);
+
+	/*
+	 * Stop DMA activity: we assume the callback will not be called
+	 * after bcm_dma_abort() returns (even if it does, it will see
+	 * c->desc is NULL and exit.)
+	 */
+	if (c->desc) {
+		c->desc = NULL;
+		bcm2835_dma_abort(c->chan_base);
+
+		/* Wait for stopping */
+		while (--timeout) {
+			if (!(readl(c->chan_base + BCM2835_DMA_CS) &
+						BCM2835_DMA_ACTIVE))
+				break;
+
+			cpu_relax();
+		}
+
+		if (!timeout)
+			dev_err(d->ddev.dev, "DMA transfer could not be terminated\n");
+	}
+
+	vchan_get_all_descriptors(&c->vc, &head);
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+	vchan_dma_desc_free_list(&c->vc, &head);
+
+	return 0;
+}
+
+static int bcm2835_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+	unsigned long arg)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		return bcm2835_dma_slave_config(c,
+				(struct dma_slave_config *)arg);
+
+	case DMA_TERMINATE_ALL:
+		return bcm2835_dma_terminate_all(c);
+
+	default:
+		return -ENXIO;
+	}
+}
+
+static int bcm2835_dma_chan_init(struct bcm2835_dmadev *d, int chan_id, int irq)
+{
+	struct bcm2835_chan *c;
+
+	c = devm_kzalloc(d->ddev.dev, sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->vc.desc_free = bcm2835_dma_desc_free;
+	vchan_init(&c->vc, &d->ddev);
+	INIT_LIST_HEAD(&c->node);
+
+	d->ddev.chancnt++;
+
+	c->chan_base = BCM2835_DMA_CHANIO(d->base, chan_id);
+	c->ch = chan_id;
+	c->irq_number = irq;
+
+	return 0;
+}
+
+static void bcm2835_dma_free(struct bcm2835_dmadev *od)
+{
+	while (!list_empty(&od->ddev.channels)) {
+		struct bcm2835_chan *c = list_first_entry(&od->ddev.channels,
+			struct bcm2835_chan, vc.chan.device_node);
+
+		list_del(&c->vc.chan.device_node);
+		tasklet_kill(&c->vc.task);
+	}
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id bcm2835_dma_of_match[] = {
+	{ .compatible = "brcm,bcm2835-dma", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);
+#endif
+
+static struct dma_chan *bcm2835_dma_xlate(struct of_phandle_args *spec,
+					   struct of_dma *ofdma)
+{
+	struct bcm2835_dmadev *d = ofdma->of_dma_data;
+	struct dma_chan *chan, *candidate;
+
+retry:
+	candidate = NULL;
+
+	/* Walk the list of channels registered with the current instance and
+	 * find one that is currently unused */
+	list_for_each_entry(chan, &d->ddev.channels, device_node)
+		if (chan->client_count == 0) {
+			candidate = chan;
+			break;
+		}
+
+	if (!candidate)
+		return NULL;
+
+	/* dma_get_slave_channel will return NULL if we lost a race between
+	 * the lookup and the reservation */
+	chan = dma_get_slave_channel(candidate);
+
+	if (!chan)
+		goto retry;
+
+	/* Set DREQ from param */
+	to_bcm2835_dma_chan(chan)->dreq = spec->args[0];
+
+	return chan;
+}
+
+static int bcm2835_dma_device_slave_caps(struct dma_chan *dchan,
+	struct dma_slave_caps *caps)
+{
+	caps->src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	caps->dstn_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	caps->cmd_pause = false;
+	caps->cmd_terminate = true;
+
+	return 0;
+}
+
+static int bcm2835_dma_probe(struct platform_device *pdev)
+{
+	struct bcm2835_dmadev *od;
+	struct resource *res;
+	void __iomem *base;
+	int rc;
+	int i;
+	int irq;
+	uint32_t chans_available;
+
+	if (!pdev->dev.dma_mask)
+		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+
+	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
+	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+
+	od = devm_kzalloc(&pdev->dev, sizeof(*od), GFP_KERNEL);
+	if (!od)
+		return -ENOMEM;
+
+	pdev->dev.dma_parms = &od->dma_parms;
+	dma_set_max_seg_size(&pdev->dev, 0x3FFFFFFF);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	od->base = base;
+
+	dma_cap_set(DMA_SLAVE, od->ddev.cap_mask);
+	dma_cap_set(DMA_CYCLIC, od->ddev.cap_mask);
+	od->ddev.device_alloc_chan_resources = bcm2835_dma_alloc_chan_resources;
+	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;
+	od->ddev.device_tx_status = bcm2835_dma_tx_status;
+	od->ddev.device_issue_pending = bcm2835_dma_issue_pending;
+	od->ddev.device_slave_caps = bcm2835_dma_device_slave_caps;
+	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
+	od->ddev.device_control = bcm2835_dma_control;
+	od->ddev.dev = &pdev->dev;
+	INIT_LIST_HEAD(&od->ddev.channels);
+	spin_lock_init(&od->lock);
+
+	platform_set_drvdata(pdev, od);
+
+	/* Request DMA channel mask from device tree */
+	if (of_property_read_u32(pdev->dev.of_node,
+			"brcm,dma-channel-mask",
+			&chans_available)) {
+		dev_err(&pdev->dev, "Failed to get channel mask\n");
+		rc = -EINVAL;
+		goto err_no_dma;
+	}
+
+	/* Do not use the FIQ and BULK channels,
+	 * because they are used by the GPU.
+	 */
+	chans_available &= ~(BCM2835_DMA_FIQ_MASK | BCM2835_DMA_BULK_MASK);
+
+	for (i = 0; i < pdev->num_resources; i++) {
+		irq = platform_get_irq(pdev, i);
+		if (irq < 0)
+			break;
+
+		if (chans_available & (1 << i)) {
+			rc = bcm2835_dma_chan_init(od, i, irq);
+			if (rc)
+				goto err_no_dma;
+		}
+	}
+
+	dev_dbg(&pdev->dev, "Initialized %i DMA channels\n", i);
+
+	if (pdev->dev.of_node) {
+		/* Device-tree DMA controller registration */
+		rc = of_dma_controller_register(pdev->dev.of_node,
+				bcm2835_dma_xlate, od);
+		if (rc) {
+			dev_err(&pdev->dev, "Failed to register DMA controller\n");
+			goto err_no_dma;
+		}
+	}
+
+	rc = dma_async_device_register(&od->ddev);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"Failed to register slave DMA engine device: %d\n", rc);
+		goto err_no_dma;
+	}
+
+	dev_dbg(&pdev->dev, "Load BCM2835 DMA engine driver\n");
+
+	return 0;
+
+err_no_dma:
+	bcm2835_dma_free(od);
+	return rc;
+}
+
+static int bcm2835_dma_remove(struct platform_device *pdev)
+{
+	struct bcm2835_dmadev *od = platform_get_drvdata(pdev);
+
+	dma_async_device_unregister(&od->ddev);
+	bcm2835_dma_free(od);
+
+	return 0;
+}
+
+static struct platform_driver bcm2835_dma_driver = {
+	.probe	= bcm2835_dma_probe,
+	.remove	= bcm2835_dma_remove,
+	.driver = {
+		.name = "bcm2835-dma",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(bcm2835_dma_of_match),
+	},
+};
+
+module_platform_driver(bcm2835_dma_driver);
+
+MODULE_ALIAS("platform:bcm2835-dma");
+MODULE_DESCRIPTION("BCM2835 DMA engine driver");
+MODULE_AUTHOR("Florian Meier <florian.meier@koalo.de>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2
