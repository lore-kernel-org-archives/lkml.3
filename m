Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3KKWFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:05:33 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64420 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KKWF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:05:27 -0500
Message-ID: <528154A1.1050303@koalo.de>
Date: Mon, 11 Nov 2013 23:05:21 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3] dmaengine: Add support for BCM2835
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
Currently it only supports cyclic DMA.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---

Thank you for your comments!
I hope I have now removed all leftovers of the sg struct.
Regarding the endian-ness: I have not found any hint about that in the datasheet. Therefore, I chose uint32_t. If you think fixed le32 is more likely I will change it.
The PAD fields do not seem to be used, but the datasheet states they should be set to 0.


 .../devicetree/bindings/dma/bcm2835-dma.txt        |   57 ++
 arch/arm/boot/dts/bcm2835.dtsi                     |   23 +
 drivers/dma/Kconfig                                |    6 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/bcm2835-dma.c                          |  810 ++++++++++++++++++++
 5 files changed, 897 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/bcm2835-dma.txt
 create mode 100644 drivers/dma/bcm2835-dma.c

diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
new file mode 100644
index 0000000..9542ac8
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
@@ -0,0 +1,57 @@
+* BCM2835 DMA controller
+
+Required properties:
+- compatible: Should be "brcm,bcm2835-dma".
+- reg: Should contain DMA registers location and length.
+- interrupts: Should contain all DMA interrupts. First cell is the IRQ bank
+		Second cell is the IRQ number.
+- #dma-cells: Must be <1>, used to represent the number of integer cells in
+the dmas property of client devices.
+- dma-channels: Maximum number of DMA channels available
+- dma-requests: Number of DMA Requests. 
+- dma-channel-mask: Bit mask representing the channels available.
+
+Example:
+
+dma: dma@7e007000 {
+	compatible = "brcm,bcm2835-dma";
+	reg = <0x7e007000 0xf00>;
+	interrupts = <1 16
+		      1 17
+		      1 18
+		      1 19
+		      1 20
+		      1 21
+		      1 22
+		      1 23
+		      1 24
+		      1 25
+		      1 26
+		      1 27
+		      1 28>;
+	
+	#dma-cells = <1>;
+	dma-channels = <15>;
+	dma-requests = <32>;
+	dma-channel-mask = <0x7f35>;
+};
+
+DMA clients connected to the BCM2835 DMA controller must use the format
+described in the dma.txt file, using a two-cell specifier for each channel:
+a phandle plus one integer cells.
+The two cells in order are:
+
+1. A phandle pointing to the DMA controller.
+2. The DREQ number.
+
+Example:
+
+bcm2835_i2s: i2s@7e203000 {
+	compatible = "brcm,bcm2835-i2s";
+	reg = <	0x7e203000 0x20
+		0x7e101098 0x02>;
+
+	dmas = <&dma 2
+		&dma 3>;
+	dma-names = "tx", "rx";
+};
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
index 0000000..141a698
--- /dev/null
+++ b/drivers/dma/bcm2835-dma.c
@@ -0,0 +1,810 @@
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
+#include <linux/of.h>
+#include <linux/of_dma.h>
+
+#include "virt-dma.h"
+
+struct bcm2835_dmadev {
+	struct dma_device ddev;
+	spinlock_t lock;
+
+	uint32_t chans_available;
+
+	void __iomem *dma_base;
+	int *dma_irq_numbers;
+
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
+	unsigned dma_sig;
+	bool cyclic;
+	unsigned dreq;
+
+	int dma_ch;
+	struct bcm2835_desc *desc;
+
+	void __iomem *dma_chan_base;
+	int dma_irq_number;
+};
+
+struct bcm2835_desc {
+	struct virt_dma_desc vd;
+	enum dma_transfer_direction dir;
+	dma_addr_t dev_addr;
+
+	unsigned int control_block_size;
+	struct bcm2835_dma_cb *control_block_base;
+	dma_addr_t control_block_base_phys;
+
+	unsigned frames;
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
+#define BCM2835_DMA_CHAN(n)	((n) << 8) /* base address */
+#define BCM2835_DMA_CHANIO(dma_base, n) ((dma_base) + BCM2835_DMA_CHAN(n))
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
+		while ((cs & BCM2835_DMA_ISPAUSED) && --timeout >= 0)
+			cs = readl(dma_chan_base + BCM2835_DMA_CS);
+
+		if (cs & BCM2835_DMA_ISPAUSED) {
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
+	dsb();	/* ARM data synchronization (push) operation */
+
+	writel(d->control_block_base_phys, c->dma_chan_base + BCM2835_DMA_ADDR);
+	writel(BCM2835_DMA_ACTIVE, c->dma_chan_base + BCM2835_DMA_CS);
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
+			bcm2835_dma_start_desc(c);
+			vchan_cookie_complete(&d->vd);
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
+static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+	int ret;
+	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
+	uint32_t chans = d->chans_available;
+	int chanID = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&d->lock, flags);
+
+	chans = d->chans_available;
+
+	dev_dbg(c->vc.chan.device->dev,
+			"allocating channel for %u\n", c->dma_sig);
+
+	/* do not use the FIQ and BULK channels */
+	chans &= ~0xD;
+
+	if (!chans) {
+		spin_unlock_irqrestore(&d->lock, flags);
+		return -ENOMEM;
+	}
+
+	/* return the ordinal of the first channel in the bitmap */
+	chanID = __ffs(chans);
+
+	/* claim the channel */
+	d->chans_available &= ~(1 << chanID);
+
+	c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
+	c->dma_irq_number = d->dma_irq_numbers[chanID];
+	c->dma_ch = chanID;
+
+	ret = request_irq(c->dma_irq_number,
+			bcm2835_dma_callback, 0, "DMA IRQ", c);
+
+	spin_unlock_irqrestore(&d->lock, flags);
+
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
+	unsigned long flags;
+
+	spin_lock_irqsave(&d->lock, flags);
+	vchan_free_chan_resources(&c->vc);
+	d->chans_available |= 1 << c->dma_ch;
+	free_irq(c->dma_irq_number, c);
+	spin_unlock_irqrestore(&d->lock, flags);
+
+	dev_dbg(c->vc.chan.device->dev, "freeing channel for %u\n", c->dma_sig);
+}
+
+static size_t bcm2835_dma_desc_size(struct bcm2835_desc *d)
+{
+	unsigned i;
+	size_t size;
+
+	for (size = i = 0; i < d->frames; i++) {
+		struct bcm2835_dma_cb *control_block =
+			&d->control_block_base[i];
+
+		size += control_block->length;
+	}
+
+	return size;
+}
+
+static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
+{
+	unsigned i;
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
+			pos = readl(c->dma_chan_base + BCM2835_DMA_SOURCE_AD);
+		else if (d->dir == DMA_DEV_TO_MEM)
+			pos = readl(c->dma_chan_base + BCM2835_DMA_DEST_AD);
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
+	c->cyclic = true; /* nothing else is implemented */
+
+	spin_lock_irqsave(&c->vc.lock, flags);
+	if (vchan_issue_pending(&c->vc) && !c->desc) {
+		bcm2835_dma_start_desc(c);
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
+	unsigned es, sync_type;
+	unsigned frame;
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
+	d = kzalloc(sizeof(*d), GFP_ATOMIC);
+	if (!d)
+		return NULL;
+
+	d->dir = direction;
+	d->dev_addr = dev_addr;
+	d->frames = buf_len / period_len;
+
+	/* Allocate memory for control blocks */
+	d->control_block_size = d->frames * sizeof(struct bcm2835_dma_cb);
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
+	for (frame = 0; frame < d->frames; frame++) {
+		struct bcm2835_dma_cb *control_block =
+			&d->control_block_base[frame];
+
+		/* Setup adresses */
+		if (d->dir == DMA_DEV_TO_MEM) {
+			control_block->info = BCM2835_DMA_D_INC;
+			control_block->src = d->dev_addr;
+			control_block->dst = buf_addr + frame * period_len;
+		} else {
+			control_block->info = BCM2835_DMA_S_INC;
+			control_block->src = buf_addr + frame * period_len;
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
+		control_block->length = period_len;
+
+		/*
+		 * Next block is the next frame.
+		 * This DMA engine driver currently only supports cyclic DMA.
+		 * Therefore, wrap around at number of frames.
+		 */
+		control_block->next = d->control_block_base_phys +
+			sizeof(struct bcm2835_dma_cb) * ((frame + 1) % (d->frames));
+
+		/* The following fields are not used here */
+		control_block->stride = 0;
+		control_block->pad[0] = 0;
+		control_block->pad[1] = 0;
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
+	    (cfg->direction != DMA_DEV_TO_MEM &&
+	     cfg->direction != DMA_MEM_TO_DEV)) {
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
+	int timeout = 1000;
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
+		while (timeout > 0) {
+			timeout--;
+			if(!(readl(c->dma_chan_base + BCM2835_DMA_CS) &
+						BCM2835_DMA_ACTIVE))
+				break;
+
+			cpu_relax();
+		}
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
+	int ret;
+
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		return bcm2835_dma_slave_config(c,
+				(struct dma_slave_config *)arg);
+
+	case DMA_TERMINATE_ALL:
+		bcm2835_dma_terminate_all(c);
+		break;
+
+	case DMA_PAUSE:
+		ret = -EINVAL;
+		break;
+
+	case DMA_RESUME:
+		ret = -EINVAL;
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
+	spin_lock_init(&od->lock);
+
+	irq_resources = 0;
+
+	for (i = 0; i < pdev->num_resources; i++) {
+		if (platform_get_resource(pdev, IORESOURCE_IRQ, i) > 0)
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
+module_platform_driver(bcm2835_dma_driver);
+
+MODULE_AUTHOR("Florian Meier");
+MODULE_DESCRIPTION("BCM2835 DMA engine driver");
+MODULE_LICENSE("GPL");
+
-- 
1.7.9.5
