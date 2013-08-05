Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3HEOiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:38:07 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32980 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3HEOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:38:05 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        djbw@fb.com, arnd@arndb.de, linux@arm.linux.org.uk,
        mark.rutland@arm.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v7] dmaengine: Add MOXA ART DMA engine driver
Date: Mon,  5 Aug 2013 16:37:37 +0200
Message-Id: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com>
References: <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MOXA ART SoC has a DMA controller capable of offloading expensive
memory operations, such as large copies. This patch adds support for
the controller including four channels. Two of these are used to
handle MMC copy on the UC-7112-LX hardware. The remaining two can be
used in a future audio driver or client application.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for the replies.
    
    Changes since v6:
    
    1. move callback from interrupt context to tasklet
    2. remove callback and callback_param, use those provided by tx_desc
    3. don't rely on structs for register offsets
    4. remove local bool "found" variable from moxart_alloc_chan_resources()
    5. check return value of irq_of_parse_and_map
    6. use devm_request_irq instead of setup_irq
    7. elaborate commit message
    
    device tree bindings document:
    8. in the example, change "#dma-cells" to "<2>"
    
    Applies to next-20130805

 .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  21 +
 drivers/dma/Kconfig                                |   7 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/moxart-dma.c                           | 614 +++++++++++++++++++++
 4 files changed, 643 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
 create mode 100644 drivers/dma/moxart-dma.c

diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
new file mode 100644
index 0000000..5b9f82c
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -0,0 +1,21 @@
+MOXA ART DMA Controller
+
+See dma.txt first
+
+Required properties:
+
+- compatible :	Must be "moxa,moxart-dma"
+- reg :		Should contain registers location and length
+- interrupts :	Should contain the interrupt number
+- #dma-cells :	Should be 2
+		cell index 0: channel number between 0-3
+		cell index 1: line request number
+
+Example:
+
+	dma: dma@90500000 {
+		compatible = "moxa,moxart-dma";
+		reg = <0x90500000 0x1000>;
+		interrupts = <24 0>;
+		#dma-cells = <2>;
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
index 0000000..7160cc3
--- /dev/null
+++ b/drivers/dma/moxart-dma.c
@@ -0,0 +1,614 @@
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
+#define REG_ADDRESS_SOURCE			0
+#define REG_ADDRESS_DEST			4
+#define REG_CYCLES				8
+#define REG_CTRL				12
+#define REG_CHAN_SIZE				16
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
+#define APB_DMA_CYCLES_MASK			0x00ffffff
+
+struct moxart_dma_chan {
+	struct dma_chan			chan;
+	int				ch_num;
+	bool				allocated;
+	int				error_flag;
+	void __iomem			*base;
+	struct completion		dma_complete;
+	struct dma_slave_config		cfg;
+	struct dma_async_tx_descriptor	tx_desc;
+	unsigned int			line;
+};
+
+struct moxart_dma_container {
+	int			ctlr;
+	struct dma_device	dma_slave;
+	struct moxart_dma_chan	slave_chans[APB_DMA_MAX_CHANNEL];
+	spinlock_t dma_lock;
+	struct tasklet_struct	tasklet;
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
+	ctrl = readl(ch->base + REG_CTRL);
+	ctrl &= ~(APB_DMA_ENABLE | APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, ch->base + REG_CTRL);
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
+	ctrl = readl(mchan->base + REG_CTRL);
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
+		ctrl |= (mchan->line << 16 &
+			 APB_DMA_DEST_REQ_NO_MASK);
+	} else {
+		ctrl |= APB_DMA_DEST_SELECT;
+		ctrl &= ~APB_DMA_SOURCE_SELECT;
+		ctrl |= (mchan->line << 24 &
+			 APB_DMA_SOURCE_REQ_NO_MASK);
+	}
+
+	writel(ctrl, mchan->base + REG_CTRL);
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
+	mchan->error_flag = 0;
+
+	dev_dbg(chan2dev(tx->chan), "%s: mchan=%p mchan->ch_num=%d mchan->base=%p\n",
+		__func__, mchan, mchan->ch_num, mchan->base);
+
+	spin_lock_irqsave(&mc->dma_lock, flags);
+
+	cookie = dma_cookie_assign(tx);
+
+	ctrl = readl(mchan->base + REG_CTRL);
+	ctrl |= (APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(ctrl, mchan->base + REG_CTRL);
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
+		       mchan->base + REG_ADDRESS_SOURCE);
+		writel(mchan->cfg.dst_addr, mchan->base + REG_ADDRESS_DEST);
+
+		adr_width = mchan->cfg.src_addr_width;
+	} else {
+		writel(mchan->cfg.src_addr, mchan->base + REG_ADDRESS_SOURCE);
+		writel(virt_to_phys((void *)sg_dma_address(&sgl[0])),
+		       mchan->base + REG_ADDRESS_DEST);
+
+		adr_width = mchan->cfg.dst_addr_width;
+	}
+
+	size = sgl->length >> adr_width;
+
+	/*
+	 * size is 4 on 64 bytes copied, i.e. once cycle copies 16 bytes
+	 * ( when data_width == APB_DMAB_DATA_WIDTH_4 )
+	 */
+	writel(size, mchan->base + REG_CYCLES);
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
+static struct dma_chan *moxart_of_xlate(struct of_phandle_args *dma_spec,
+					struct of_dma *ofdma)
+{
+	struct dma_chan *chan;
+	struct of_dma_filter_info *info = ofdma->of_dma_data;
+
+	if (!info || !info->filter_fn)
+		return NULL;
+
+	if (dma_spec->args_count != 2)
+		return NULL;
+
+	chan = dma_request_channel(info->dma_cap, info->filter_fn,
+				   &dma_spec->args[0]);
+	if (chan)
+		to_moxart_dma_chan(chan)->line = dma_spec->args[1];
+
+	return chan;
+}
+
+static int moxart_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	int i;
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++) {
+		if (i == mchan->ch_num
+			&& !mchan->allocated) {
+			dev_dbg(chan2dev(chan), "%s: allocating channel #%d\n",
+				__func__, mchan->ch_num);
+			mchan->allocated = true;
+			return 0;
+		}
+	}
+
+	return -ENODEV;
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
+	ctrl = readl(mchan->base + REG_CTRL);
+	ctrl |= APB_DMA_ENABLE;
+	writel(ctrl, mchan->base + REG_CTRL);
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
+static void moxart_dma_tasklet(unsigned long data)
+{
+	struct moxart_dma_container *mc = (void *)data;
+	struct moxart_dma_chan *ch = &mc->slave_chans[0];
+	unsigned int i;
+
+	pr_debug("%s\n", __func__);
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, ch++) {
+		if (ch->allocated && ch->tx_desc.callback) {
+			pr_debug("%s: call callback for ch=%p\n",
+				 __func__, ch);
+			ch->tx_desc.callback(ch->tx_desc.callback_param);
+		}
+	}
+}
+
+static irqreturn_t moxart_dma_interrupt(int irq, void *devid)
+{
+	struct moxart_dma_container *mc = devid;
+	struct moxart_dma_chan *mchan = &mc->slave_chans[0];
+	unsigned int i;
+	u32 ctrl;
+
+	pr_debug("%s\n", __func__);
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
+		if (mchan->allocated) {
+			ctrl = readl(mchan->base + REG_CTRL);
+			if (ctrl & APB_DMA_FIN_INT_STS) {
+				ctrl &= ~APB_DMA_FIN_INT_STS;
+				dma_cookie_complete(&mchan->tx_desc);
+			}
+			if (ctrl & APB_DMA_ERR_INT_STS) {
+				ctrl &= ~APB_DMA_ERR_INT_STS;
+				mchan->error_flag = 1;
+			}
+			mchan->error_flag = 0;
+			writel(ctrl, mchan->base + REG_CTRL);
+		}
+	}
+
+	tasklet_schedule(&mc->tasklet);
+
+	return IRQ_HANDLED;
+}
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
+	if (irq <= 0) {
+		dev_err(dev, "irq_of_parse_and_map failed\n");
+		return -EINVAL;
+	}
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
+		mchan->base = dma_base_addr + 0x80 + i * REG_CHAN_SIZE;
+		mchan->allocated = 0;
+
+		dma_cookie_init(&mchan->chan);
+		mchan->chan.device = &mdc->dma_slave;
+		list_add_tail(&mchan->chan.device_node,
+			      &mdc->dma_slave.channels);
+
+		dev_dbg(dev, "%s: mchans[%d]: mchan->ch_num=%d mchan->base=%p\n",
+			__func__, i, mchan->ch_num, mchan->base);
+	}
+
+	ret = dma_async_device_register(&mdc->dma_slave);
+	platform_set_drvdata(pdev, mdc);
+
+	of_dma_controller_register(node, moxart_of_xlate, &moxart_dma_info);
+
+	tasklet_init(&mdc->tasklet, moxart_dma_tasklet, (unsigned long)mdc);
+
+	devm_request_irq(dev, irq, moxart_dma_interrupt, 0,
+			 "moxart-dma-engine", mdc);
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

