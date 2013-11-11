Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3KKQd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:33:56 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63795 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KKQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:33:47 -0500
Message-ID: <528106E5.5000307@koalo.de>
Date: Mon, 11 Nov 2013 17:33:41 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCHv2] dmaengine: Add support for BCM2835.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
Currently it only supports cyclic DMA.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

Second version of patch. Main improvements:
- Initialization of control blocks in prep function
- Request DREQ from device tree
- Request channel mask from device tree

 arch/arm/boot/dts/bcm2835.dtsi |   23 ++
 drivers/dma/Kconfig            |    6 +
 drivers/dma/Makefile           |    1 +
 drivers/dma/bcm2835-dma.c      |  896 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 926 insertions(+)
 create mode 100644 drivers/dma/bcm2835-dma.c

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 1e12aef..7389405 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -103,6 +103,29 @@
 			clocks = <&clk_mmc>;
 			status = "disabled";
 		};
+
+		dma: dma@7e007000 {
+			compatible = "brcm,bcm2835-dma";
+			reg = <0x7e007000 0xf00>;
+			interrupts = <1 16
+				      1 17
+				      1 18
+				      1 19
+				      1 20
+				      1 21
+				      1 22
+				      1 23
+				      1 24
+				      1 25
+				      1 26
+				      1 27
+				      1 28>;
+
+			#dma-cells = <1>;
+			dma-channels = <15>;   /* DMA channel 15 is not handled yet */
+			dma-requests = <32>;
+			dma-channel-mask = <0x7f35>;
+		};
 	};
 
 	clocks {
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f238cfd..f2d253b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -288,6 +288,12 @@ config DMA_OMAP
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
index db89035..6348157 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
 obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
 obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
+obj-$(CONFIG_DMA_BCM2835) += bcm2835-dma.o
 obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
 obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
 obj-$(CONFIG_TI_CPPI41) += cppi41.o
diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
new file mode 100644
index 0000000..6972c0c
--- /dev/null
+++ b/drivers/dma/bcm2835-dma.c
@@ -0,0 +1,896 @@
+/*
+ * BCM2835 DMA engine support
+ *
+ * This driver only supports cyclic DMA transfers
+ * as needed for the I2S module.
+ *
+ * Author:      Florian Meier, <florian.meier@koalo.de>
+ *              Copyright 2013
+ *
+ * based on
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_dma.h>
+
+#include "virt-dma.h"
+
+struct bcm2835_dmadev {
+	struct dma_device ddev;
+	spinlock_t lock;
+	struct tasklet_struct task;
+	struct list_head pending;
+	uint32_t chans_available;
+	void __iomem *dma_base;
+	int *dma_irq_numbers;
+};
+
+struct bcm2835_dma_cb {
+	unsigned long info;
+	unsigned long src;
+	unsigned long dst;
+	unsigned long length;
+	unsigned long stride;
+	unsigned long next;
+	unsigned long pad[2];
+};
+
+struct bcm2835_chan {
+	struct virt_dma_chan vc;
+	struct list_head node;
+
+	struct dma_slave_config	cfg;
+	unsigned dma_sig;
+	bool cyclic;
+	unsigned dreq;
+
+	int dma_ch;
+	struct bcm2835_desc *desc;
+	unsigned sgidx;
+
+	void __iomem *dma_chan_base;
+	int dma_irq_number;
+	struct irqaction dma_irq_handler;
+};
+
+struct bcm2835_sg {
+	dma_addr_t addr;
+	uint32_t en;		/* number of elements (24-bit) */
+	uint32_t fn;		/* number of frames (16-bit) */
+};
+
+struct bcm2835_desc {
+	struct virt_dma_desc vd;
+	enum dma_transfer_direction dir;
+	dma_addr_t dev_addr;
+
+	uint8_t es;
+
+	unsigned int control_block_size;
+	struct bcm2835_dma_cb *control_block_base;
+	dma_addr_t control_block_base_phys;
+
+	unsigned sglen;
+	struct bcm2835_sg sg[0];
+};
+
+#define BCM2835_DMA_CS		0x00
+#define BCM2835_DMA_ADDR	0x04
+#define BCM2835_DMA_SOURCE_AD	0x0c
+#define BCM2835_DMA_DEST_AD	0x10
+#define BCM2835_DMA_NEXTCB	0x1C
+
+/* DMA CS Control and Status bits */
+#define BCM2835_DMA_ACTIVE	(1 << 0)
+#define BCM2835_DMA_INT	(1 << 2)
+#define BCM2835_DMA_ISPAUSED	(1 << 4)  /* Pause requested or not active */
+#define BCM2835_DMA_ISHELD	(1 << 5)  /* Is held by DREQ flow control */
+#define BCM2835_DMA_ERR	(1 << 8)
+#define BCM2835_DMA_ABORT	(1 << 30) /* stop current CB, go to next, WO */
+#define BCM2835_DMA_RESET	(1 << 31) /* WO, self clearing */
+
+#define BCM2835_DMA_INT_EN	(1 << 0)
+#define BCM2835_DMA_D_INC	(1 << 4)
+#define BCM2835_DMA_D_DREQ	(1 << 6)
+#define BCM2835_DMA_S_INC	(1 << 8)
+#define BCM2835_DMA_S_DREQ	(1 << 6)
+
+#define BCM2835_DMA_PER_MAP(x)	((x) << 16)
+
+#define BCM2835_DMA_DATA_TYPE_S8 1
+#define BCM2835_DMA_DATA_TYPE_S16 2
+#define BCM2835_DMA_DATA_TYPE_S32 4
+#define BCM2835_DMA_DATA_TYPE_S128 16
+
+/* valid only for channels 0 - 14, 15 has its own base address */
+#define BCM2835_DMA_CHAN(n)	((n)<<8) /* base address */
+#define BCM2835_DMA_CHANIO(dma_base, n) ((dma_base)+BCM2835_DMA_CHAN(n))
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
+static int bcm2835_dma_abort(void __iomem *dma_chan_base)
+{
+	unsigned long int cs;
+	int rc = 0;
+
+	cs = readl(dma_chan_base + BCM2835_DMA_CS);
+
+	if (BCM2835_DMA_ACTIVE & cs) {
+		long int timeout = 10000;
+
+		/* write 0 to the active bit - pause the DMA */
+		writel(0, dma_chan_base + BCM2835_DMA_CS);
+
+		/* wait for any current AXI transfer to complete */
+		while (0 != (cs & BCM2835_DMA_ISPAUSED) && --timeout >= 0)
+			cs = readl(dma_chan_base + BCM2835_DMA_CS);
+
+		if (0 != (cs & BCM2835_DMA_ISPAUSED)) {
+			/* we'll un-pause when we set of our next DMA */
+			rc = -ETIMEDOUT;
+
+		} else if (BCM2835_DMA_ACTIVE & cs) {
+			/* terminate the control block chain */
+			writel(0, dma_chan_base + BCM2835_DMA_NEXTCB);
+
+			/* abort the whole DMA */
+			writel(BCM2835_DMA_ABORT | BCM2835_DMA_ACTIVE,
+			       dma_chan_base + BCM2835_DMA_CS);
+		}
+	}
+
+	return rc;
+}
+
+static void bcm2835_dma_start_sg(struct bcm2835_chan *c, struct bcm2835_desc *d,
+		unsigned idx)
+{
+	dsb();	/* ARM data synchronization (push) operation */
+
+	writel(d->control_block_base_phys, c->dma_chan_base+BCM2835_DMA_ADDR);
+	writel(BCM2835_DMA_ACTIVE, c->dma_chan_base+BCM2835_DMA_CS);
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
+	c->sgidx = 0;
+
+	bcm2835_dma_start_sg(c, d, 0);
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
+	/* acknowledge interrupt */
+	writel(BCM2835_DMA_INT, c->dma_chan_base + BCM2835_DMA_CS);
+
+	d = c->desc;
+
+	if (d) {
+		if (!c->cyclic) {
+			if (++c->sgidx < d->sglen) {
+				bcm2835_dma_start_sg(c, d, c->sgidx);
+			} else {
+				bcm2835_dma_start_desc(c);
+				vchan_cookie_complete(&d->vd);
+			}
+		} else {
+			vchan_cyclic_callback(&d->vd);
+		}
+	}
+
+	/* keep the DMA engine running */
+	dsb(); /* ARM synchronization barrier */
+	writel(BCM2835_DMA_ACTIVE, c->dma_chan_base + BCM2835_DMA_CS);
+
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * This callback schedules all pending channels.  We could be more
+ * clever here by postponing allocation of the real DMA channels to
+ * this point, and freeing them when our virtual channel becomes idle.
+ *
+ * We would then need to deal with 'all channels in-use'
+ */
+static void bcm2835_dma_sched(unsigned long data)
+{
+	struct bcm2835_dmadev *d = (struct bcm2835_dmadev *)data;
+	LIST_HEAD(head);
+
+	spin_lock_irq(&d->lock);
+	list_splice_tail_init(&d->pending, &head);
+	spin_unlock_irq(&d->lock);
+
+	while (!list_empty(&head)) {
+		struct bcm2835_chan *c = list_first_entry(&head,
+			struct bcm2835_chan, node);
+
+		spin_lock_irq(&c->vc.lock);
+		list_del_init(&c->node);
+		bcm2835_dma_start_desc(c);
+		spin_unlock_irq(&c->vc.lock);
+	}
+}
+
+static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	int ret;
+	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
+	uint32_t chans = d->chans_available;
+	int chanID = 0;
+
+	dev_dbg(c->vc.chan.device->dev,
+			"allocating channel for %u\n", c->dma_sig);
+
+	/* do not use the FIQ and BULK channels */
+	chans &= ~0xD;
+
+	if (chans) {
+		/* return the ordinal of the first channel in the bitmap */
+		while (chans != 0 && (chans & 1) == 0) {
+			chans >>= 1;
+			chanID++;
+		}
+
+		/* claim the channel */
+		d->chans_available &= ~(1 << chanID);
+
+		c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
+		c->dma_irq_number = d->dma_irq_numbers[chanID];
+		c->dma_ch = chanID;
+	} else {
+		return -ENOMEM;
+	}
+
+	c->dma_irq_handler.name = "DMA engine IRQ handler";
+	c->dma_irq_handler.flags = 0;
+	c->dma_irq_handler.handler = bcm2835_dma_callback;
+
+	ret = request_irq(c->dma_irq_number,
+			bcm2835_dma_callback, 0, "DMA IRQ", c);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void bcm2835_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
+
+	vchan_free_chan_resources(&c->vc);
+	d->chans_available |= (1 << c->dma_ch);
+	free_irq(c->dma_irq_number, c);
+
+	dev_dbg(c->vc.chan.device->dev, "freeing channel for %u\n", c->dma_sig);
+}
+
+static size_t bcm2835_dma_sg_size(struct bcm2835_sg *sg)
+{
+	return sg->en * sg->fn;
+}
+
+static size_t bcm2835_dma_desc_size(struct bcm2835_desc *d)
+{
+	unsigned i;
+	size_t size;
+
+	for (size = i = 0; i < d->sglen; i++)
+		size += bcm2835_dma_sg_size(&d->sg[i]);
+
+	return size * d->es;
+}
+
+static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
+{
+	unsigned i;
+	size_t size;
+
+	for (size = i = 0; i < d->sglen; i++) {
+		size_t this_size = bcm2835_dma_sg_size(&d->sg[i]);
+
+		if (size)
+			size += this_size;
+		else if (addr >= d->sg[i].addr &&
+			 addr < d->sg[i].addr + this_size)
+			size += d->sg[i].addr + this_size - addr;
+	}
+	return size;
+}
+
+
+/*
+ * Returns current physical source address for the given DMA channel.
+ * If the channel is running the caller must disable interrupts prior calling
+ * this function and process the returned value before re-enabling interrupt to
+ * prevent races with the interrupt handler.
+ */
+static dma_addr_t bcm2835_get_dma_src_pos(struct bcm2835_chan *c)
+{
+	return readl(c->dma_chan_base + BCM2835_DMA_SOURCE_AD);
+}
+
+/*
+ * Returns current physical destination address for the given DMA channel.
+ * If the channel is running the caller must disable interrupts prior calling
+ * this function and process the returned value before re-enabling interrupt to
+ * prevent races with the interrupt handler.
+ */
+static dma_addr_t bcm2835_get_dma_dst_pos(struct bcm2835_chan *c)
+{
+	return readl(c->dma_chan_base + BCM2835_DMA_DEST_AD);
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
+			pos = bcm2835_get_dma_src_pos(c);
+		else if (d->dir == DMA_DEV_TO_MEM)
+			pos = bcm2835_get_dma_dst_pos(c);
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
+	spin_lock_irqsave(&c->vc.lock, flags);
+	if (vchan_issue_pending(&c->vc) && !c->desc) {
+		struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
+		spin_lock(&d->lock);
+		if (list_empty(&c->node))
+			list_add_tail(&c->node, &d->pending);
+		spin_unlock(&d->lock);
+		tasklet_schedule(&d->task);
+	}
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+}
+
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
+	int frame;
+	int frames;
+
+	/* Grab configuration */
+	if (direction == DMA_DEV_TO_MEM) {
+		dev_addr = c->cfg.src_addr;
+		dev_width = c->cfg.src_addr_width;
+		sync_type = BCM2835_DMA_S_DREQ;
+	} else if (direction == DMA_MEM_TO_DEV) {
+		dev_addr = c->cfg.dst_addr;
+		dev_width = c->cfg.dst_addr_width;
+		sync_type = BCM2835_DMA_D_DREQ;
+	} else {
+		dev_err(chan->device->dev, "%s: bad direction?\n", __func__);
+		return NULL;
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
+	d = kzalloc(sizeof(*d) + sizeof(d->sg[0]), GFP_ATOMIC);
+	if (!d)
+		return NULL;
+
+	d->dir = direction;
+	d->dev_addr = dev_addr;
+	d->es = es;
+	d->sg[0].addr = buf_addr;
+	d->sg[0].en = period_len;
+	d->sg[0].fn = buf_len / period_len;
+	d->sglen = 1;
+
+	/* Allocate memory for control blocks */
+	d->control_block_size = d->sg[0].fn*sizeof(struct bcm2835_dma_cb);
+	d->control_block_base = dma_alloc_coherent(chan->device->dev,
+			d->control_block_size, &d->control_block_base_phys,
+			GFP_KERNEL);
+
+	if (!d->control_block_base) {
+		dev_err(chan->device->dev,
+				"%s: Memory allocation error\n", __func__);
+		return NULL;
+	}
+
+	memset(d->control_block_base, 0, d->control_block_size);
+
+	/*
+	 * Iterate over all frames, create a control block
+	 * for each frame and link them together.
+	 */
+	frames = d->sg[0].fn;
+
+	for (frame = 0; frame < frames; frame++) {
+		struct bcm2835_dma_cb *control_block =
+			&d->control_block_base[frame];
+
+		/* Setup adresses */
+		if (d->dir == DMA_DEV_TO_MEM) {
+			control_block->info = BCM2835_DMA_D_INC;
+			control_block->src = d->dev_addr;
+			control_block->dst = d->sg[0].addr+frame*d->sg[0].en;
+		} else {
+			control_block->info = BCM2835_DMA_S_INC;
+			control_block->src = d->sg[0].addr+frame*d->sg[0].en;
+			control_block->dst = d->dev_addr;
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
+		control_block->length = d->sg[0].en;
+
+		/*
+		 * Next block is the next frame.
+		 * This DMA engine driver currently only supports cyclic DMA.
+		 * Therefore, wrap around at number of frames.
+		 */
+		control_block->next = d->control_block_base_phys +
+			sizeof(struct bcm2835_dma_cb)*((frame+1)%(frames));
+
+		/* The following fields are not used here */
+		control_block->stride = 0;
+		control_block->pad[0] = 0;
+		control_block->pad[1] = 0;
+	}
+
+	c->cyclic = true; /* nothing else is implemented */
+
+	return vchan_tx_prep(&c->vc, &d->vd, flags);
+}
+
+static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
+		struct dma_slave_config *cfg)
+{
+	if ((cfg->direction == DMA_DEV_TO_MEM
+			&& cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
+	    (cfg->direction == DMA_MEM_TO_DEV
+			&& cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)) {
+		return -EINVAL;
+	}
+
+	memcpy(&c->cfg, cfg, sizeof(c->cfg));
+
+	return 0;
+}
+
+static int bcm2835_dma_terminate_all(struct bcm2835_chan *c)
+{
+	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(c->vc.chan.device);
+	unsigned long flags;
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
+		bcm2835_dma_abort(c->dma_chan_base);
+
+		/* Wait for stopping */
+		while (readl(c->dma_chan_base + BCM2835_DMA_CS)
+			& BCM2835_DMA_ACTIVE)
+			;
+	}
+
+	vchan_get_all_descriptors(&c->vc, &head);
+	spin_unlock_irqrestore(&c->vc.lock, flags);
+	vchan_dma_desc_free_list(&c->vc, &head);
+
+	return 0;
+}
+
+static int bcm2835_dma_pause(struct bcm2835_chan *c)
+{
+	/* FIXME: not supported by platform private API */
+	return -EINVAL;
+}
+
+static int bcm2835_dma_resume(struct bcm2835_chan *c)
+{
+	/* FIXME: not supported by platform private API */
+	return -EINVAL;
+}
+
+static int bcm2835_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+	unsigned long arg)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	int ret;
+
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		ret = bcm2835_dma_slave_config(c,
+				(struct dma_slave_config *)arg);
+		break;
+
+	case DMA_TERMINATE_ALL:
+		ret = bcm2835_dma_terminate_all(c);
+		break;
+
+	case DMA_PAUSE:
+		ret = bcm2835_dma_pause(c);
+		break;
+
+	case DMA_RESUME:
+		ret = bcm2835_dma_resume(c);
+		break;
+
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+static int bcm2835_dma_chan_init(struct bcm2835_dmadev *od, int dma_sig)
+{
+	struct bcm2835_chan *c;
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->dma_sig = dma_sig;
+	c->vc.desc_free = bcm2835_dma_desc_free;
+	vchan_init(&c->vc, &od->ddev);
+	INIT_LIST_HEAD(&c->node);
+
+	od->ddev.chancnt++;
+
+	return 0;
+}
+
+static void bcm2835_dma_free(struct bcm2835_dmadev *od)
+{
+	tasklet_kill(&od->task);
+	while (!list_empty(&od->ddev.channels)) {
+		struct bcm2835_chan *c = list_first_entry(&od->ddev.channels,
+			struct bcm2835_chan, vc.chan.device_node);
+
+		list_del(&c->vc.chan.device_node);
+		tasklet_kill(&c->vc.task);
+		kfree(c);
+	}
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id bcm2835_dma_of_match[] = {
+	{
+		.compatible = "brcm,bcm2835-dma",
+	}
+};
+MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);
+#endif
+
+static struct dma_chan *bcm2835_dma_xlate(struct of_phandle_args *dma_spec,
+					   struct of_dma *ofdma)
+{
+	struct bcm2835_dmadev *d = ofdma->of_dma_data;
+	struct dma_chan *chan, *candidate;
+
+retry:
+	candidate = NULL;
+
+	/* walk the list of channels registered with the current instance and
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
+	if (chan) {
+		struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+
+		/* Set DREQ from param */
+		c->dreq = dma_spec->args[0];
+
+		return chan;
+	}
+
+	goto retry;
+}
+
+static int bcm2835_dma_probe(struct platform_device *pdev)
+{
+	struct bcm2835_dmadev *od;
+	struct resource *dma_res = NULL;
+	void __iomem *dma_base = NULL;
+	int rc = 0;
+	int i;
+	struct resource *irq;
+	int irq_resources;
+
+	od = devm_kzalloc(&pdev->dev, sizeof(*od), GFP_KERNEL);
+	if (!od)
+		return -ENOMEM;
+
+	dma_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dma_base = devm_ioremap_resource(&pdev->dev, dma_res);
+	if (IS_ERR(dma_base))
+		return PTR_ERR(dma_base);
+
+	od->dma_base = dma_base;
+
+	dma_cap_set(DMA_SLAVE, od->ddev.cap_mask);
+	dma_cap_set(DMA_CYCLIC, od->ddev.cap_mask);
+	od->ddev.device_alloc_chan_resources = bcm2835_dma_alloc_chan_resources;
+	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;
+	od->ddev.device_tx_status = bcm2835_dma_tx_status;
+	od->ddev.device_issue_pending = bcm2835_dma_issue_pending;
+	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
+	od->ddev.device_control = bcm2835_dma_control;
+	od->ddev.dev = &pdev->dev;
+	INIT_LIST_HEAD(&od->ddev.channels);
+	INIT_LIST_HEAD(&od->pending);
+	spin_lock_init(&od->lock);
+
+	tasklet_init(&od->task, bcm2835_dma_sched, (unsigned long)od);
+
+	irq_resources = 0;
+
+	for (i = 0; i < pdev->num_resources; i++) {
+		if (IORESOURCE_IRQ == resource_type(&pdev->resource[i]))
+			irq_resources++;
+	}
+
+	od->dma_irq_numbers = devm_kzalloc(&pdev->dev,
+			irq_resources*sizeof(int), GFP_KERNEL);
+	if (!od)
+		return -ENOMEM;
+
+	for (i = 0; i < irq_resources; i++) {
+		rc = bcm2835_dma_chan_init(od, i);
+		if (rc) {
+			bcm2835_dma_free(od);
+			return rc;
+		}
+
+		irq = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		if (!irq) {
+			dev_err(&pdev->dev,
+					"No IRQ resource for channel %i\n", i);
+			return -ENODEV;
+		}
+		od->dma_irq_numbers[i] = irq->start;
+	}
+
+	rc = dma_async_device_register(&od->ddev);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"Failed to register slave DMA engine device: %d\n", rc);
+		bcm2835_dma_free(od);
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, od);
+
+	if (pdev->dev.of_node) {
+		const void *chan_mask;
+
+		/* Device-tree DMA controller registration */
+		rc = of_dma_controller_register(pdev->dev.of_node,
+				bcm2835_dma_xlate, od);
+		if (rc) {
+			dev_err(&pdev->dev, "Failed to register DMA controller\n");
+			dma_async_device_unregister(&od->ddev);
+			bcm2835_dma_free(od);
+			return rc;
+		}
+
+		/* Request DMA channel mask from device tree */
+		chan_mask = of_get_property(pdev->dev.of_node,
+				"dma-channel-mask", NULL);
+
+		if (!chan_mask) {
+			dev_err(&pdev->dev, "Failed to get channel mask\n");
+			dma_async_device_unregister(&od->ddev);
+			bcm2835_dma_free(od);
+			return -EINVAL;
+		}
+
+		od->chans_available = be32_to_cpup(chan_mask);
+	}
+
+	dev_dbg(&pdev->dev, "Load BCM2835 DMA engine driver\n");
+
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
+static const struct platform_device_info bcm2835_dma_dev_info = {
+	.name = "bcm2835-dma",
+	.id = -1,
+	.dma_mask = DMA_BIT_MASK(32),
+};
+
+static int bcm2835_dma_init(void)
+{
+	int rc = platform_driver_register(&bcm2835_dma_driver);
+	return rc;
+}
+subsys_initcall(bcm2835_dma_init);
+
+static void __exit bcm2835_dma_exit(void)
+{
+	platform_driver_unregister(&bcm2835_dma_driver);
+}
+module_exit(bcm2835_dma_exit);
+
+MODULE_AUTHOR("Florian Meier");
+MODULE_DESCRIPTION("BCM2835 DMA engine driver");
+MODULE_LICENSE("GPL");
+
-- 
1.7.9.5

