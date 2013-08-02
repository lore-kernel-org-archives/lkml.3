Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3HBMDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:03:54 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49271 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3HBMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:03:52 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        djbw@fb.com, arnd@arndb.de, linux@arm.linux.org.uk,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5] dmaengine: Add MOXA ART DMA engine driver
Date: Fri,  2 Aug 2013 14:03:38 +0200
Message-Id: <1375445018-20713-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1375105442-14827-1-git-send-email-jonas.jensen@gmail.com>
References: <1375105442-14827-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dmaengine driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v4:
    
    1. use DT probing / remove EXPORT_SYMBOL(moxart_filter_fn)
    2. remove struct moxart_dma_reg_cfg
    3. refactor and use hex literals
    4. moxart_dma_filter_fn(): compare device instead of driver
    5. remove moxart-dma.h
    6. move spinlock to moxart_dma_container
    7. use u32 instead of unsigned int (registers)
    8. use platform_get_resource()
    9. remove use of BIT()
    
    device tree bindings document:
    10. describe single cell #dma-cells property
    
    Applies to next-20130802

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  20 +
 drivers/dma/Kconfig                                |   7 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/moxart-dma.c                           | 589 +++++++++++++++++++++
 4 files changed, 617 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
 create mode 100644 drivers/dma/moxart-dma.c

diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
new file mode 100644
index 0000000..9a4db43
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -0,0 +1,20 @@
+MOXA ART DMA Controller
+
+See dma.txt first
+
+Required properties:
+
+- compatible :	Must be "moxa,moxart-dma"
+- reg :		Should contain registers location and length
+- interrupts :	Should contain the interrupt number
+- #dma-cells :	Should be 1, this is a single cell used to
+		specify	a channel number between 0-3
+
+Example:
+
+	dma: dma@90500000 {
+		compatible = "moxa,moxart-dma";
+		reg = <0x90500000 0x1000>;
+		interrupts = <24 0>;
+		#dma-cells = <1>;
+	};
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6825957..56c3aaa 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -300,6 +300,13 @@ config DMA_JZ4740
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
+config MOXART_DMA
+	tristate "MOXART DMA support"
+	depends on ARCH_MOXART
+	select DMA_ENGINE
+	help
+	  Enable support for the MOXA ART SoC DMA controller.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 5e0f2ef..470c11b 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
 obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
 obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
+obj-$(CONFIG_MOXART_DMA) += moxart-dma.o
diff --git a/drivers/dma/moxart-dma.c b/drivers/dma/moxart-dma.c
new file mode 100644
index 0000000..708c238
--- /dev/null
+++ b/drivers/dma/moxart-dma.c
@@ -0,0 +1,589 @@
+/*
+ * MOXA ART SoCs DMA Engine support.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/irq.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_dma.h>
+
+#include <asm/cacheflush.h>
+
+#include "dmaengine.h"
+
+#define APB_DMA_MAX_CHANNEL			4
+
+#define APB_DMA_ENABLE				0x1
+#define APB_DMA_FIN_INT_STS			0x2
+#define APB_DMA_FIN_INT_EN			0x4
+#define APB_DMA_BURST_MODE			0x8
+#define APB_DMA_ERR_INT_STS			0x10
+#define APB_DMA_ERR_INT_EN			0x20
+
+/*
+ * unset to select APB source
+ * set to select AHB source
+ */
+#define APB_DMA_SOURCE_SELECT			0x40
+
+/*
+ * unset to select APB destination
+ * set to select AHB destination
+ */
+#define APB_DMA_DEST_SELECT			0x80
+
+#define APB_DMA_SOURCE				0x100
+#define APB_DMA_SOURCE_MASK			0x700
+/*
+ * 000: no increment
+ * 001: +1 (busrt=0), +4  (burst=1)
+ * 010: +2 (burst=0), +8  (burst=1)
+ * 011: +4 (burst=0), +16 (burst=1)
+ * 101: -1 (burst=0), -4  (burst=1)
+ * 110: -2 (burst=0), -8  (burst=1)
+ * 111: -4 (burst=0), -16 (burst=1)
+ */
+#define APB_DMA_SOURCE_INC_0			0
+#define APB_DMA_SOURCE_INC_1_4			0x100
+#define APB_DMA_SOURCE_INC_2_8			0x200
+#define APB_DMA_SOURCE_INC_4_16			0x300
+#define APB_DMA_SOURCE_DEC_1_4			0x500
+#define APB_DMA_SOURCE_DEC_2_8			0x600
+#define APB_DMA_SOURCE_DEC_4_16			0x700
+
+#define APB_DMA_DEST				0x1000
+#define APB_DMA_DEST_MASK			0x7000
+/*
+ * 000: no increment
+ * 001: +1 (busrt=0), +4  (burst=1)
+ * 010: +2 (burst=0), +8  (burst=1)
+ * 011: +4 (burst=0), +16 (burst=1)
+ * 101: -1 (burst=0), -4  (burst=1)
+ * 110: -2 (burst=0), -8  (burst=1)
+ * 111: -4 (burst=0), -16 (burst=1)
+*/
+#define APB_DMA_DEST_INC_0			0
+#define APB_DMA_DEST_INC_1_4			0x1000
+#define APB_DMA_DEST_INC_2_8			0x2000
+#define APB_DMA_DEST_INC_4_16			0x3000
+#define APB_DMA_DEST_DEC_1_4			0x5000
+#define APB_DMA_DEST_DEC_2_8			0x6000
+#define APB_DMA_DEST_DEC_4_16			0x7000
+
+/*
+ * request signal select of destination
+ * address for DMA hardware handshake
+ *
+ * the request line number is a property of
+ * the DMA controller itself, e.g. MMC must
+ * always request channels where
+ * dma_slave_config->slave_id == 5
+ *
+ * 0:    no request / grant signal
+ * 1-15: request / grant signal
+ */
+#define APB_DMA_DEST_REQ_NO			0x10000
+#define APB_DMA_DEST_REQ_NO_MASK		0xf0000
+
+#define APB_DMA_DATA_WIDTH			0x100000
+#define APB_DMA_DATA_WIDTH_MASK			0x300000
+/*
+ * data width of transfer
+ * 00: word
+ * 01: half
+ * 10: byte
+ */
+#define APB_DMA_DATA_WIDTH_4			0
+#define APB_DMA_DATA_WIDTH_2			0x100000
+#define APB_DMA_DATA_WIDTH_1			0x200000
+
+/*
+ * request signal select of source
+ * address for DMA hardware handshake
+ *
+ * the request line number is a property of
+ * the DMA controller itself, e.g. MMC must
+ * always request channels where
+ * dma_slave_config->slave_id == 5
+ *
+ * 0:    no request / grant signal
+ * 1-15: request / grant signal
+ */
+#define APB_DMA_SOURCE_REQ_NO			0x1000000
+#define APB_DMA_SOURCE_REQ_NO_MASK		0xf000000
+
+struct moxart_dma_reg {
+	u32 source_addr;
+	u32 dest_addr;
+#define APB_DMA_CYCLES_MASK			0x00ffffff
+	u32 cycles;	/* depend on burst mode */
+	u32 ctrl;
+};
+
+struct moxart_dma_chan {
+	struct dma_chan			chan;
+	int				ch_num;
+	bool				allocated;
+	int				error_flag;
+	struct moxart_dma_reg		*reg;
+	void				(*callback)(void *param);
+	void				*callback_param;
+	struct completion		dma_complete;
+	struct dma_slave_config		cfg;
+	struct dma_async_tx_descriptor	tx_desc;
+};
+
+struct moxart_dma_container {
+	int			ctlr;
+	struct dma_device	dma_slave;
+	struct moxart_dma_chan	slave_chans[APB_DMA_MAX_CHANNEL];
+	spinlock_t dma_lock;
+};
+
+static struct device *chan2dev(struct dma_chan *chan)
+{
+	return &chan->dev->device;
+}
+
+static inline struct moxart_dma_container
+*to_dma_container(struct dma_device *d)
+{
+	return container_of(d, struct moxart_dma_container, dma_slave);
+}
+
+static inline struct moxart_dma_chan *to_moxart_dma_chan(struct dma_chan *c)
+{
+	return container_of(c, struct moxart_dma_chan, chan);
+}
+
+static int moxart_terminate_all(struct dma_chan *chan)
+{
+	struct moxart_dma_chan *ch = to_moxart_dma_chan(chan);
+	struct moxart_dma_container *c = to_dma_container(ch->chan.device);
+	u32 ctrl;
+	unsigned long flags;
+
+	dev_dbg(chan2dev(chan), "%s: ch=%p\n", __func__, ch);
+
+	spin_lock_irqsave(&c->dma_lock, flags);
+
+	ctrl = readl(&ch->reg->ctrl);
+	ctrl &= ~(APB_DMA_ENABLE | APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, &ch->reg->ctrl);
+
+	spin_unlock_irqrestore(&c->dma_lock, flags);
+
+	return 0;
+}
+
+static int moxart_slave_config(struct dma_chan *chan,
+			       struct dma_slave_config *cfg)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
+	u32 ctrl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mc->dma_lock, flags);
+
+	memcpy(&mchan->cfg, cfg, sizeof(mchan->cfg));
+
+	ctrl = readl(&mchan->reg->ctrl);
+	ctrl |= APB_DMA_BURST_MODE;
+	ctrl &= ~(APB_DMA_DEST_MASK | APB_DMA_SOURCE_MASK);
+	ctrl &= ~(APB_DMA_DEST_REQ_NO_MASK | APB_DMA_SOURCE_REQ_NO_MASK);
+
+	switch (mchan->cfg.src_addr_width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		ctrl |= APB_DMA_DATA_WIDTH_1;
+		if (mchan->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_1_4;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_1_4;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		ctrl |= APB_DMA_DATA_WIDTH_2;
+		if (mchan->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_2_8;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_2_8;
+		break;
+	default:
+		ctrl &= ~APB_DMA_DATA_WIDTH;
+		if (mchan->cfg.direction != DMA_MEM_TO_DEV)
+			ctrl |= APB_DMA_DEST_INC_4_16;
+		else
+			ctrl |= APB_DMA_SOURCE_INC_4_16;
+		break;
+	}
+
+	if (mchan->cfg.direction == DMA_MEM_TO_DEV) {
+		ctrl &= ~APB_DMA_DEST_SELECT;
+		ctrl |= APB_DMA_SOURCE_SELECT;
+		ctrl |= (mchan->cfg.slave_id << 16 &
+			 APB_DMA_DEST_REQ_NO_MASK);
+	} else {
+		ctrl |= APB_DMA_DEST_SELECT;
+		ctrl &= ~APB_DMA_SOURCE_SELECT;
+		ctrl |= (mchan->cfg.slave_id << 24 &
+			 APB_DMA_SOURCE_REQ_NO_MASK);
+	}
+
+	writel(ctrl, &mchan->reg->ctrl);
+
+	spin_unlock_irqrestore(&mc->dma_lock, flags);
+
+	return 0;
+}
+
+static int moxart_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			  unsigned long arg)
+{
+	int ret = 0;
+	struct dma_slave_config *config;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		moxart_terminate_all(chan);
+		break;
+	case DMA_SLAVE_CONFIG:
+		config = (struct dma_slave_config *)arg;
+		ret = moxart_slave_config(chan, config);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	return ret;
+}
+
+static dma_cookie_t moxart_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(tx->chan);
+	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
+	dma_cookie_t cookie;
+	u32 ctrl;
+	unsigned long flags;
+
+	mchan->callback = tx->callback;
+	mchan->callback_param = tx->callback_param;
+	mchan->error_flag = 0;
+
+	dev_dbg(chan2dev(tx->chan), "%s: mchan=%p mchan->ch_num=%d mchan->reg=%p\n",
+		__func__, mchan, mchan->ch_num, mchan->reg);
+
+	spin_lock_irqsave(&mc->dma_lock, flags);
+
+	cookie = dma_cookie_assign(tx);
+
+	ctrl = readl(&mchan->reg->ctrl);
+	ctrl |= (APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, &mchan->reg->ctrl);
+
+	spin_unlock_irqrestore(&mc->dma_lock, flags);
+
+	return cookie;
+}
+
+static struct dma_async_tx_descriptor
+*moxart_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+		      unsigned int sg_len,
+		      enum dma_transfer_direction direction,
+		      unsigned long tx_flags, void *context)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
+	unsigned long flags;
+	unsigned int size, adr_width;
+
+	spin_lock_irqsave(&mc->dma_lock, flags);
+
+	if (direction == DMA_MEM_TO_DEV) {
+		writel(virt_to_phys((void *)sg_dma_address(&sgl[0])),
+		       &mchan->reg->source_addr);
+		writel(mchan->cfg.dst_addr, &mchan->reg->dest_addr);
+		adr_width = mchan->cfg.src_addr_width;
+	} else {
+		writel(mchan->cfg.src_addr, &mchan->reg->source_addr);
+		writel(virt_to_phys((void *)sg_dma_address(&sgl[0])),
+		       &mchan->reg->dest_addr);
+		adr_width = mchan->cfg.dst_addr_width;
+	}
+
+	size = sgl->length >> adr_width;
+
+	/*
+	 * size is 4 on 64 bytes copied, i.e. once cycle copies 16 bytes
+	 * ( when data_width == APB_DMAB_DATA_WIDTH_4 )
+	 */
+	writel(size, &mchan->reg->cycles);
+
+	dev_dbg(chan2dev(chan), "%s: set %d DMA cycles (sgl->length=%d adr_width=%d)\n",
+		__func__, size, sgl->length, adr_width);
+
+	dma_async_tx_descriptor_init(&mchan->tx_desc, chan);
+	mchan->tx_desc.tx_submit = moxart_tx_submit;
+
+	spin_unlock_irqrestore(&mc->dma_lock, flags);
+
+	return &mchan->tx_desc;
+}
+
+bool moxart_dma_filter_fn(struct dma_chan *chan, void *param)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
+
+	if (chan->device->dev == mc->dma_slave.dev) {
+		struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+		unsigned int ch_req = *(unsigned int *)param;
+		dev_dbg(chan2dev(chan), "%s: mchan=%p ch_req=%d mchan->ch_num=%d\n",
+			__func__, mchan, ch_req, mchan->ch_num);
+		return ch_req == mchan->ch_num;
+	} else {
+		dev_dbg(chan2dev(chan), "%s: device not registered to this DMA engine\n",
+			__func__);
+		return false;
+	}
+}
+
+static struct of_dma_filter_info moxart_dma_info = {
+	.filter_fn = moxart_dma_filter_fn,
+};
+
+static int moxart_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	int i;
+	bool found = false;
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++) {
+		if (i == mchan->ch_num
+			&& !mchan->allocated) {
+			dev_dbg(chan2dev(chan), "%s: allocating channel #%d\n",
+				__func__, mchan->ch_num);
+			mchan->allocated = true;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -ENODEV;
+
+	return 0;
+}
+
+static void moxart_free_chan_resources(struct dma_chan *chan)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+
+	mchan->allocated = false;
+
+	dev_dbg(chan2dev(chan), "%s: freeing channel #%u\n",
+		__func__, mchan->ch_num);
+}
+
+static void moxart_issue_pending(struct dma_chan *chan)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	struct moxart_dma_container *mc = to_dma_container(mchan->chan.device);
+	u32 ctrl;
+	unsigned long flags;
+
+	dev_dbg(chan2dev(chan), "%s: mchan=%p\n", __func__, mchan);
+
+	spin_lock_irqsave(&mc->dma_lock, flags);
+
+	ctrl = readl(&mchan->reg->ctrl);
+	ctrl |= APB_DMA_ENABLE;
+	writel(ctrl, &mchan->reg->ctrl);
+
+	spin_unlock_irqrestore(&mc->dma_lock, flags);
+}
+
+static enum dma_status moxart_tx_status(struct dma_chan *chan,
+					dma_cookie_t cookie,
+					struct dma_tx_state *txstate)
+{
+	enum dma_status ret;
+
+	ret = dma_cookie_status(chan, cookie, txstate);
+	if (ret == DMA_SUCCESS || !txstate)
+		return ret;
+
+	return ret;
+}
+
+static void moxart_dma_init(struct dma_device *dma, struct device *dev)
+{
+	dma->device_prep_slave_sg		= moxart_prep_slave_sg;
+	dma->device_alloc_chan_resources	= moxart_alloc_chan_resources;
+	dma->device_free_chan_resources		= moxart_free_chan_resources;
+	dma->device_issue_pending		= moxart_issue_pending;
+	dma->device_tx_status			= moxart_tx_status;
+	dma->device_control			= moxart_control;
+	dma->dev				= dev;
+
+	INIT_LIST_HEAD(&dma->channels);
+}
+
+static irqreturn_t moxart_dma_interrupt(int irq, void *devid)
+{
+	struct moxart_dma_container *mc = to_dma_container(devid);
+	struct moxart_dma_chan *mchan = &mc->slave_chans[0];
+	unsigned int i;
+	u32 ctrl;
+
+	pr_debug("%s\n", __func__);
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
+		if (mchan->allocated) {
+			ctrl = readl(&mchan->reg->ctrl);
+			if (ctrl & APB_DMA_FIN_INT_STS) {
+				ctrl &= ~APB_DMA_FIN_INT_STS;
+				dma_cookie_complete(&mchan->tx_desc);
+			}
+			if (ctrl & APB_DMA_ERR_INT_STS) {
+				ctrl &= ~APB_DMA_ERR_INT_STS;
+				mchan->error_flag = 1;
+			}
+			if (mchan->callback) {
+				pr_debug("%s: call callback for mchan=%p\n",
+					 __func__, mchan);
+				mchan->callback(mchan->callback_param);
+			}
+			mchan->error_flag = 0;
+			writel(ctrl, &mchan->reg->ctrl);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction moxart_dma_irq = {
+	.name       = "moxart-dma-engine",
+	.flags      = IRQF_DISABLED,
+	.handler    = moxart_dma_interrupt,
+};
+
+static int moxart_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct resource *res;
+	static void __iomem *dma_base_addr;
+	int ret, i;
+	unsigned int irq;
+	struct moxart_dma_chan *mchan;
+	struct moxart_dma_container *mdc;
+
+	mdc = devm_kzalloc(dev, sizeof(*mdc), GFP_KERNEL);
+	if (!mdc) {
+		dev_err(dev, "can't allocate DMA container\n");
+		return -ENOMEM;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dma_base_addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dma_base_addr)) {
+		dev_err(dev, "devm_ioremap_resource failed\n");
+		return PTR_ERR(dma_base_addr);
+	}
+
+	mdc->ctlr = pdev->id;
+	spin_lock_init(&mdc->dma_lock);
+
+	dma_cap_zero(mdc->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE, mdc->dma_slave.cap_mask);
+
+	moxart_dma_init(&mdc->dma_slave, dev);
+
+	mchan = &mdc->slave_chans[0];
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
+		mchan->ch_num = i;
+		mchan->reg = (struct moxart_dma_reg *)(dma_base_addr + 0x80
+			     + i * sizeof(struct moxart_dma_reg));
+		mchan->callback = NULL;
+		mchan->allocated = 0;
+		mchan->callback_param = NULL;
+
+		dma_cookie_init(&mchan->chan);
+		mchan->chan.device = &mdc->dma_slave;
+		list_add_tail(&mchan->chan.device_node,
+			      &mdc->dma_slave.channels);
+
+		dev_dbg(dev, "%s: mchans[%d]: mchan->ch_num=%d mchan->reg=%p\n",
+			__func__, i, mchan->ch_num, mchan->reg);
+	}
+
+	ret = dma_async_device_register(&mdc->dma_slave);
+	platform_set_drvdata(pdev, mdc);
+
+	of_dma_controller_register(node, of_dma_simple_xlate, &moxart_dma_info);
+
+	moxart_dma_irq.dev_id = &mdc->dma_slave;
+	setup_irq(irq, &moxart_dma_irq);
+
+	dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
+
+	return ret;
+}
+
+static int moxart_remove(struct platform_device *pdev)
+{
+	struct moxart_dma_container *m = dev_get_drvdata(&pdev->dev);
+	dma_async_device_unregister(&m->dma_slave);
+	return 0;
+}
+
+static const struct of_device_id moxart_dma_match[] = {
+	{ .compatible = "moxa,moxart-dma" },
+	{ }
+};
+
+static struct platform_driver moxart_driver = {
+	.probe	= moxart_probe,
+	.remove	= moxart_remove,
+	.driver = {
+		.name		= "moxart-dma-engine",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_dma_match,
+	},
+};
+
+static int moxart_init(void)
+{
+	return platform_driver_register(&moxart_driver);
+}
+subsys_initcall(moxart_init);
+
+static void __exit moxart_exit(void)
+{
+	platform_driver_unregister(&moxart_driver);
+}
+module_exit(moxart_exit);
+
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
+MODULE_DESCRIPTION("MOXART DMA engine driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1

