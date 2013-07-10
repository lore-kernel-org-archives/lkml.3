Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3GJMoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:44:22 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39372 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3GJMoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:44:20 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, vinod.koul@intel.com,
        djbw@fb.com, arnd@arndb.de, linux@arm.linux.org.uk,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] dmaengine: Add MOXA ART DMA engine driver
Date: Wed, 10 Jul 2013 14:43:59 +0200
Message-Id: <1373460239-20102-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373446263-7772-1-git-send-email-jonas.jensen@gmail.com>
References: <1373446263-7772-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dmaengine driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703
    
    Changes since v1:
    
    1. remove use of vchan support

 drivers/dma/Kconfig      |   9 +
 drivers/dma/Makefile     |   1 +
 drivers/dma/moxart-dma.c | 477 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/moxart-dma.h | 188 +++++++++++++++++++
 4 files changed, 675 insertions(+)
 create mode 100644 drivers/dma/moxart-dma.c
 create mode 100644 drivers/dma/moxart-dma.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6825957..d4ba42b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -300,6 +300,15 @@ config DMA_JZ4740
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
+config MOXART_DMA
+	tristate "MOXART DMA support"
+	depends on ARCH_MOXART
+	select DMA_ENGINE
+	select DMA_VIRTUAL_CHANNELS
+	default n
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
index 0000000..16fddf4
--- /dev/null
+++ b/drivers/dma/moxart-dma.c
@@ -0,0 +1,477 @@
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
+
+#include <asm/cacheflush.h>
+
+#include "dmaengine.h"
+#include "moxart-dma.h"
+
+static DEFINE_SPINLOCK(dma_lock);
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
+};
+
+struct moxart_dma_container *mdc;
+
+static struct device *chan2dev(struct dma_chan *chan)
+{
+	return &chan->dev->device;
+}
+
+static inline struct moxart_dma_container
+*to_moxart_dma_container(struct dma_device *d)
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
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	union moxart_dma_reg_cfg mcfg;
+	unsigned long flags;
+
+	dev_dbg(chan2dev(chan), "%s: mchan=%p\n", __func__, mchan);
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	mcfg.ul = readl(&mchan->reg->cfg.ul);
+	mcfg.ul &= ~(APB_DMA_ENABLE | APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(mcfg.ul, &mchan->reg->cfg.ul);
+
+	spin_unlock_irqrestore(&dma_lock, flags);
+
+	return 0;
+}
+
+static int moxart_slave_config(struct dma_chan *chan,
+			       struct dma_slave_config *cfg)
+{
+	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
+	union moxart_dma_reg_cfg mcfg;
+	unsigned long flags;
+	unsigned int data_width, data_inc;
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	memcpy(&mchan->cfg, cfg, sizeof(mchan->cfg));
+
+	mcfg.ul = readl(&mchan->reg->cfg.ul);
+	mcfg.bits.burst = APB_DMAB_BURST_MODE;
+
+	switch (mchan->cfg.src_addr_width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		data_width = APB_DMAB_DATA_WIDTH_1;
+		data_inc = APB_DMAB_DEST_INC_1_4;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		data_width = APB_DMAB_DATA_WIDTH_2;
+		data_inc = APB_DMAB_DEST_INC_2_8;
+		break;
+	default:
+		data_width = APB_DMAB_DATA_WIDTH_4;
+		data_inc = APB_DMAB_DEST_INC_4_16;
+		break;
+	}
+
+	if (mchan->cfg.direction == DMA_MEM_TO_DEV) {
+		mcfg.bits.data_width = data_width;
+		mcfg.bits.dest_sel = APB_DMAB_DEST_APB;
+		mcfg.bits.dest_inc = APB_DMAB_DEST_INC_0;
+		mcfg.bits.source_sel = APB_DMAB_SOURCE_AHB;
+		mcfg.bits.source_inc = data_inc;
+
+		mcfg.bits.dest_req_no = mchan->cfg.slave_id;
+		mcfg.bits.source_req_no = 0;
+	} else {
+		mcfg.bits.data_width = data_width;
+		mcfg.bits.dest_sel = APB_DMAB_SOURCE_AHB;
+		mcfg.bits.dest_inc = data_inc;
+		mcfg.bits.source_sel = APB_DMAB_DEST_APB;
+		mcfg.bits.source_inc = APB_DMAB_DEST_INC_0;
+
+		mcfg.bits.dest_req_no = 0;
+		mcfg.bits.source_req_no = mchan->cfg.slave_id;
+	}
+
+	writel(mcfg.ul, &mchan->reg->cfg.ul);
+
+	spin_unlock_irqrestore(&dma_lock, flags);
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
+	dma_cookie_t cookie;
+	union moxart_dma_reg_cfg mcfg;
+	unsigned long flags;
+
+	mchan->callback = tx->callback;
+	mchan->callback_param = tx->callback_param;
+	mchan->error_flag = 0;
+
+	dev_dbg(chan2dev(tx->chan), "%s: mchan=%p mchan->ch_num=%d mchan->reg=%p\n",
+		__func__, mchan, mchan->ch_num, mchan->reg);
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	cookie = dma_cookie_assign(tx);
+
+	mcfg.ul = readl(&mchan->reg->cfg.ul);
+	mcfg.ul |= (APB_DMA_FIN_INT_EN | APB_DMA_ERR_INT_EN);
+	writel(mcfg.ul, &mchan->reg->cfg.ul);
+
+	spin_unlock_irqrestore(&dma_lock, flags);
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
+	unsigned long flags;
+	union moxart_dma_reg_cfg mcfg;
+	unsigned int size, adr_width;
+
+	spin_lock_irqsave(&dma_lock, flags);
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
+	dev_dbg(chan2dev(chan), "%s: mcfg.ul=%x read from &mchan->reg->cfg.ul=%x\n",
+		__func__, mcfg.ul, (unsigned int)&mchan->reg->cfg.ul);
+
+	dma_async_tx_descriptor_init(&mchan->tx_desc, chan);
+	mchan->tx_desc.tx_submit = moxart_tx_submit;
+
+	spin_unlock_irqrestore(&dma_lock, flags);
+
+	return &mchan->tx_desc;
+}
+
+static struct platform_driver moxart_driver;
+
+bool moxart_filter_fn(struct dma_chan *chan, void *param)
+{
+	if (chan->device->dev->driver == &moxart_driver.driver) {
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
+EXPORT_SYMBOL(moxart_filter_fn);
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
+	union moxart_dma_reg_cfg mcfg;
+	unsigned long flags;
+
+	dev_dbg(chan2dev(chan), "%s: mchan=%p\n", __func__, mchan);
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	mcfg.ul = readl(&mchan->reg->cfg.ul);
+	mcfg.ul |= APB_DMA_ENABLE;
+	writel(mcfg.ul, &mchan->reg->cfg.ul);
+
+	spin_unlock_irqrestore(&dma_lock, flags);
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
+	struct device *dev = devid;
+	struct moxart_dma_chan *mchan = &mdc->slave_chans[0];
+	unsigned int i;
+	union moxart_dma_reg_cfg mcfg;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
+		if (mchan->allocated) {
+			mcfg.ul = readl(&mchan->reg->cfg.ul);
+			if (mcfg.ul & APB_DMA_FIN_INT_STS) {
+				mcfg.ul &= ~APB_DMA_FIN_INT_STS;
+				dma_cookie_complete(&mchan->tx_desc);
+			}
+			if (mcfg.ul & APB_DMA_ERR_INT_STS) {
+				mcfg.ul &= ~APB_DMA_ERR_INT_STS;
+				mchan->error_flag = 1;
+			}
+			if (mchan->callback) {
+				dev_dbg(dev, "%s: call callback for mchan=%p\n",
+					__func__, mchan);
+				mchan->callback(mchan->callback_param);
+			}
+			mchan->error_flag = 0;
+			writel(mcfg.ul, &mchan->reg->cfg.ul);
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
+	struct resource res_dma;
+	static void __iomem *dma_base_addr;
+	int ret, i;
+	unsigned int irq;
+	struct moxart_dma_chan *mchan;
+
+	mdc = devm_kzalloc(dev, sizeof(*mdc), GFP_KERNEL);
+	if (!mdc) {
+		dev_err(dev, "can't allocate DMA container\n");
+		return -ENOMEM;
+	}
+
+	ret = of_address_to_resource(node, 0, &res_dma);
+	if (ret) {
+		dev_err(dev, "can't get DMA base resource\n");
+		return ret;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+
+	dma_base_addr = devm_ioremap_resource(dev, &res_dma);
+	if (IS_ERR(dma_base_addr)) {
+		dev_err(dev, "devm_ioremap_resource failed\n");
+		return PTR_ERR(dma_base_addr);
+	}
+
+	mdc->ctlr = pdev->id;
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
+	moxart_dma_irq.dev_id = dev;
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
diff --git a/drivers/dma/moxart-dma.h b/drivers/dma/moxart-dma.h
new file mode 100644
index 0000000..358c006
--- /dev/null
+++ b/drivers/dma/moxart-dma.h
@@ -0,0 +1,188 @@
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
+#ifndef __DMA_MOXART_H
+#define __DMA_MOXART_H
+
+#define APB_DMA_MAX_CHANNEL			4
+
+union moxart_dma_reg_cfg {
+
+#define APB_DMA_ENABLE				(1<<0)
+#define APB_DMA_FIN_INT_STS			(1<<1)
+#define APB_DMA_FIN_INT_EN			(1<<2)
+#define APB_DMA_BURST_MODE			(1<<3)
+#define APB_DMA_ERR_INT_STS			(1<<4)
+#define APB_DMA_ERR_INT_EN			(1<<5)
+#define APB_DMA_SOURCE_AHB			(1<<6)
+#define APB_DMA_SOURCE_APB			0
+#define APB_DMA_DEST_AHB			(1<<7)
+#define APB_DMA_DEST_APB			0
+#define APB_DMA_SOURCE_INC_0			0
+#define APB_DMA_SOURCE_INC_1_4			(1<<8)
+#define APB_DMA_SOURCE_INC_2_8			(2<<8)
+#define APB_DMA_SOURCE_INC_4_16			(3<<8)
+#define APB_DMA_SOURCE_DEC_1_4			(5<<8)
+#define APB_DMA_SOURCE_DEC_2_8			(6<<8)
+#define APB_DMA_SOURCE_DEC_4_16			(7<<8)
+#define APB_DMA_SOURCE_INC_MASK			(7<<8)
+#define APB_DMA_DEST_INC_0			0
+#define APB_DMA_DEST_INC_1_4			(1<<12)
+#define APB_DMA_DEST_INC_2_8			(2<<12)
+#define APB_DMA_DEST_INC_4_16			(3<<12)
+#define APB_DMA_DEST_DEC_1_4			(5<<12)
+#define APB_DMA_DEST_DEC_2_8			(6<<12)
+#define APB_DMA_DEST_DEC_4_16			(7<<12)
+#define APB_DMA_DEST_INC_MASK			(7<<12)
+#define APB_DMA_DEST_REQ_NO_MASK		(15<<16)
+#define APB_DMA_DATA_WIDTH_MASK			(3<<20)
+#define APB_DMA_DATA_WIDTH_4			0
+#define APB_DMA_DATA_WIDTH_2			(1<<20)
+#define APB_DMA_DATA_WIDTH_1			(2<<20)
+#define APB_DMA_SOURCE_REQ_NO_MASK		(15<<24)
+	unsigned int ul;
+
+	struct {
+
+#define APB_DMAB_ENABLE				1
+		/* enable DMA */
+		unsigned int enable:1;
+
+#define APB_DMAB_FIN_INT_STS			1
+		/* finished interrupt status */
+		unsigned int fin_int_sts:1;
+
+#define APB_DMAB_FIN_INT_EN			1
+		/* finished interrupt enable */
+		unsigned int fin_int_en:1;
+
+#define APB_DMAB_BURST_MODE			1
+		/* burst mode */
+		unsigned int burst:1;
+
+#define APB_DMAB_ERR_INT_STS			1
+		/* error interrupt status */
+		unsigned int err_int_sts:1;
+
+#define APB_DMAB_ERR_INT_EN			1
+		/* error interrupt enable */
+		unsigned int err_int_en:1;
+
+#define APB_DMAB_SOURCE_AHB			1
+#define APB_DMAB_SOURCE_APB			0
+		/* 0:APB (device), 1:AHB (RAM) */
+		unsigned int source_sel:1;
+
+#define APB_DMAB_DEST_AHB			1
+#define APB_DMAB_DEST_APB			0
+		/* 0:APB, 1:AHB */
+		unsigned int dest_sel:1;
+
+#define APB_DMAB_SOURCE_INC_0			0
+#define APB_DMAB_SOURCE_INC_1_4			1
+#define APB_DMAB_SOURCE_INC_2_8			2
+#define APB_DMAB_SOURCE_INC_4_16		3
+#define APB_DMAB_SOURCE_DEC_1_4			5
+#define APB_DMAB_SOURCE_DEC_2_8			6
+#define APB_DMAB_SOURCE_DEC_4_16		7
+#define APB_DMAB_SOURCE_INC_MASK		7
+		/*
+		 * 000: no increment
+		 * 001: +1 (busrt=0), +4  (burst=1)
+		 * 010: +2 (burst=0), +8  (burst=1)
+		 * 011: +4 (burst=0), +16 (burst=1)
+		 * 101: -1 (burst=0), -4  (burst=1)
+		 * 110: -2 (burst=0), -8  (burst=1)
+		 * 111: -4 (burst=0), -16 (burst=1)
+		 */
+		unsigned int source_inc:3;
+
+		unsigned int reserved1:1;
+
+#define APB_DMAB_DEST_INC_0			0
+#define APB_DMAB_DEST_INC_1_4			1
+#define APB_DMAB_DEST_INC_2_8			2
+#define APB_DMAB_DEST_INC_4_16			3
+#define APB_DMAB_DEST_DEC_1_4			5
+#define APB_DMAB_DEST_DEC_2_8			6
+#define APB_DMAB_DEST_DEC_4_16			7
+#define APB_DMAB_DEST_INC_MASK			7
+		/*
+		 * 000: no increment
+		 * 001: +1 (busrt=0), +4  (burst=1)
+		 * 010: +2 (burst=0), +8  (burst=1)
+		 * 011: +4 (burst=0), +16 (burst=1)
+		 * 101: -1 (burst=0), -4  (burst=1)
+		 * 110: -2 (burst=0), -8  (burst=1)
+		 * 111: -4 (burst=0), -16 (burst=1)
+		*/
+		unsigned int dest_inc:3;
+
+		unsigned int reserved2:1;
+
+#define APB_DMAB_DEST_REQ_NO_MASK		15
+		/*
+		 * request signal select of destination
+		 * address for DMA hardware handshake
+		 *
+		 * the request line number is a property of
+		 * the DMA controller itself, e.g. MMC must
+		 * always request channels where
+		 * dma_slave_config->slave_id == 5
+		 *
+		 * 0:	 no request / grant signal
+		 * 1-15: request / grant signal
+		 */
+		unsigned int dest_req_no:4;
+
+#define APB_DMAB_DATA_WIDTH_MASK		3
+#define APB_DMAB_DATA_WIDTH_4			0
+#define APB_DMAB_DATA_WIDTH_2			1
+#define APB_DMAB_DATA_WIDTH_1			2
+		/*
+		 * data width of transfer
+		 * 00: word
+		 * 01: half
+		 * 10: byte
+		 */
+		unsigned int data_width:2;
+
+		unsigned int reserved3:2;
+
+#define APB_DMAB_SOURCE_REQ_NO_MASK		15
+		/*
+		 * request signal select of source
+		 * address for DMA hardware handshake
+		 *
+		 * the request line number is a property of
+		 * the DMA controller itself, e.g. MMC must
+		 * always request channels where
+		 * dma_slave_config->slave_id == 5
+		 *
+		 * 0:	 no request / grant signal
+		 * 1-15: request / grant signal
+		 */
+		unsigned int source_req_no:4;
+
+		unsigned int reserved4:4;
+	} bits;
+};
+
+struct moxart_dma_reg {
+	unsigned int source_addr;
+	unsigned int dest_addr;
+#define APB_DMA_CYCLES_MASK			0x00ffffff
+	unsigned int cycles;	/* depend on burst mode */
+	union moxart_dma_reg_cfg cfg;
+};
+
+#endif
-- 
1.8.2.1

