Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab3GEQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:13:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:45856 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab3GEQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:12:55 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC 1/2] usb/musb dma: add cppi41 dma driver
Date: Fri,  5 Jul 2013 18:12:43 +0200
Message-Id: <1373040764-3711-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de>
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first shot of the cppi41 DMA driver. It is currently used by
a new musb dma-engine implementation. I have to test it somehow.

The state of the cpp41 (and the using dmaengine) is in very early stage.
I was able to send TX packets over DMA and enumerate an USB masstorage
device.
Things that need to be taken care of:
- RX path
- cancel of transfers
- dynamic descriptor allocation
- re-think the current device tree nodes.
  Currently a node looks like:
  	&cppi41dma X Y Z Q
  that means:
   - X: dma channel
   - Y: RX/TX
   - Z: start queue
   - Q: complete queue
  Each value number is hardwired with the USB endpoint it is using. The
  DMA channels are hardwired with USB endpoints and the start/complete
  is hardwired with the DMA channel.

I add each DMA channel twice: once for RX the other for TX (that is why
I need the direction (Y) uppon lookup).
The RX/TX channel can be used simultaneously i.e. program & start RX,
program & start TX and TX can complete before RX.
Currently I think that it would be best to remove the queue logic from
the device and put it into the driver.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am33xx.dtsi  |  50 +++
 drivers/dma/Kconfig            |   9 +
 drivers/dma/Makefile           |   1 +
 drivers/dma/cppi41.c           | 777 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/Kconfig       |   4 +
 drivers/usb/musb/Makefile      |   1 +
 drivers/usb/musb/musb_dma.h    |   2 +-
 drivers/usb/musb/musb_dmaeng.c | 294 ++++++++++++++++
 8 files changed, 1137 insertions(+), 1 deletion(-)
 create mode 100644 drivers/dma/cppi41.c
 create mode 100644 drivers/usb/musb/musb_dmaeng.c

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index bb2298c..fc29b54 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -349,6 +349,18 @@
 			status = "disabled";
 		};
 
+		cppi41dma: dma@07402000 {
+			compatible = "ti,am3359-cppi41";
+			reg =  <0x47400000 0x1000	/* usbss */
+				0x47402000 0x1000	/* controller */
+				0x47403000 0x1000	/* scheduler */
+				0x47404000 0x4000>;	/* queue manager */
+			interrupts = <17>;
+			#dma-cells = <4>;
+			#dma-channels = <30>;
+			#dma-requests = <256>;
+		};
+
 		musb: usb@47400000 {
 			compatible = "ti,musb-am33xx";
 			reg = <0x47400000 0x1000>;
@@ -383,6 +395,44 @@
 				power = <250>;
 				phys = <&musb1_phy>;
 				status = "disabled";
+				dmas = <&cppi41dma 15 0 16 141
+					&cppi41dma 16 0 17 142
+					&cppi41dma 17 0 18 143
+					&cppi41dma 18 0 19 144
+					&cppi41dma 19 0 20 145
+					&cppi41dma 20 0 21 146
+					&cppi41dma 21 0 22 147
+					&cppi41dma 22 0 23 148
+					&cppi41dma 23 0 24 149
+					&cppi41dma 24 0 25 150
+					&cppi41dma 25 0 26 151
+					&cppi41dma 26 0 27 152
+					&cppi41dma 27 0 28 153
+					&cppi41dma 28 0 29 154
+					&cppi41dma 29 0 30 155
+
+					&cppi41dma 15 1 62 125
+					&cppi41dma 16 1 64 126
+					&cppi41dma 17 1 66 127
+					&cppi41dma 18 1 68 128
+					&cppi41dma 19 1 70 129
+					&cppi41dma 20 1 72 130
+					&cppi41dma 21 1 74 131
+					&cppi41dma 22 1 76 132
+					&cppi41dma 23 1 78 133
+					&cppi41dma 24 1 80 134
+					&cppi41dma 25 1 82 135
+					&cppi41dma 26 1 84 136
+					&cppi41dma 27 1 86 137
+					&cppi41dma 28 1 88 138
+					&cppi41dma 29 1 90 139>;
+				dma-names =
+					"rx1", "rx2", "rx3", "rx4", "rx5", "rx6", "rx7",
+					"rx8", "rx9", "rx10", "rx11", "rx12", "rx13",
+					"rx14", "rx15",
+					"tx1", "tx2", "tx3", "tx4", "tx5", "tx6", "tx7",
+					"tx8", "tx9", "tx10", "tx11", "tx12", "tx13",
+					"tx14", "tx15";
 			};
 		};
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3215a3c..c19a593 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -305,6 +305,15 @@ config DMA_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
+config TI_CPPI41
+	tristate "AM33xx CPPI41 DMA support"
+	depends on ARCH_OMAP
+	select DMA_ENGINE
+	select DMA_VIRTUAL_CHANNELS
+	help
+	  The Communications Port Programming Interface (CPPI) 4.1 DMA engine
+	  is currently used by the MUSB driver on AM335x platforms.
+
 config MMP_PDMA
 	bool "MMP PDMA support"
 	depends on (ARCH_MMP || ARCH_PXA)
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index a2b0df5..6ce6ac8 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_DMA_SA11X0) += sa11x0-dma.o
 obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
 obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
+obj-$(CONFIG_TI_CPPI41) += cppi41.o
diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
new file mode 100644
index 0000000..80dcb56
--- /dev/null
+++ b/drivers/dma/cppi41.c
@@ -0,0 +1,777 @@
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/of_dma.h>
+#include <linux/of_irq.h>
+#include <linux/dmapool.h>
+#include <linux/interrupt.h>
+#include <linux/of_address.h>
+#include "dmaengine.h"
+
+#define DESC_TYPE	27
+#define DESC_TYPE_HOST	0x10
+#define DESC_TYPE_TEARD	0x13
+
+#define TD_DESC_TX_RX	16
+#define TD_DESC_DMA_NUM	10
+
+/* USB SS */
+#define USBSS_IRQ_STATUS	(0x28)
+#define USBSS_IRQ_ENABLER	(0x2c)
+#define USBSS_IRQ_CLEARR	(0x30)
+
+#define USBSS_IRQ_RX1		(1 << 11)
+#define USBSS_IRQ_TX1		(1 << 10)
+#define USBSS_IRQ_RX0		(1 <<  9)
+#define USBSS_IRQ_TX0		(1 <<  8)
+#define USBSS_IRQ_PD_COMP	(1 <<  2)
+
+#define USBSS_IRQ_RXTX1		(USBSS_IRQ_RX1 | USBSS_IRQ_TX1)
+#define USBSS_IRQ_RXTX0		(USBSS_IRQ_RX0 | USBSS_IRQ_TX0)
+#define USBSS_IRQ_RXTX01	(USBSS_IRQ_RXTX0 | USBSS_IRQ_RXTX1)
+
+/* DMA engine */
+#define DMA_TXGCR(x)	(0x800 + (x) * 0x20)
+#define DMA_RXGCR(x)	(0x808 + (x) * 0x20)
+
+#define GCR_CHAN_ENABLE		(1 << 31)
+
+/* DMA scheduler */
+#define DMA_SCHED_CTRL		0
+#define DMA_SCHED_CTRL_EN	(1 << 31)
+#define DMA_SCHED_WORD(x)	((x) * 4 + 0x800)
+
+#define SCHED_ENTRY0_CHAN(x)	((x) << 0)
+#define SCHED_ENTRY0_IS_RX	(1 << 7)
+
+#define SCHED_ENTRY1_CHAN(x)	((x) << 8)
+#define SCHED_ENTRY1_IS_RX	(1 << 15)
+
+#define SCHED_ENTRY2_CHAN(x)	((x) << 16)
+#define SCHED_ENTRY2_IS_RX	(1 << 23)
+
+#define SCHED_ENTRY3_CHAN(x)	((x) << 24)
+#define SCHED_ENTRY3_IS_RX	(1 << 31)
+
+/* Queue manager */
+/* 4 KiB of memory for descriptors, 2 for each endpoint */
+#define ALLOC_DECS_NUM		128
+#define DESCS_AREAS		1
+#define TOTAL_DESCS_NUM		(ALLOC_DECS_NUM * DESCS_AREAS)
+#define QMGR_SCRATCH_SIZE	(TOTAL_DESCS_NUM * 4)
+
+#define QMGR_LRAM0_BASE		0x80
+#define QMGR_LRAM_SIZE		0x84
+#define QMGR_LRAM1_BASE		0x88
+#define QMGR_MEMBASE(x)		(0x1000 + (x) * 0x10)
+#define QMGR_MEMCTRL(x)		(0x1004 + (x) * 0x10)
+#define QMGR_MEMCTRL_IDX_SH	16
+#define QMGR_MEMCTRL_DESC_SH	8
+
+#define QMGR_QUEUE_A(n)	(0x2000 + (n) * 0x10)
+#define QMGR_QUEUE_B(n)	(0x2004 + (n) * 0x10)
+#define QMGR_QUEUE_C(n)	(0x2008 + (n) * 0x10)
+#define QMGR_QUEUE_D(n)	(0x200c + (n) * 0x10)
+
+struct cppi41_channel {
+	struct dma_chan chan;
+	struct dma_async_tx_descriptor txd;
+	struct cppi41_dd *cdd;
+	struct cppi41_desc *desc;
+	dma_addr_t desc_phys;
+	void __iomem *gcr_reg;
+	int is_tx;
+
+	unsigned int q_num;
+	unsigned int q_comp_num;
+	unsigned int port_num;
+};
+
+struct cppi41_common_desc {
+	u32 pd0;
+	u32 pd1;
+	u32 pd2;
+	u32 pd3;
+	u32 pd4;
+	u32 pd5;
+	u32 pd6;
+	u32 pd7;
+} __packed __aligned(32);
+
+struct cppi41_desc {
+	struct cppi41_common_desc d;
+} __aligned(32);
+
+struct cppi41_dd {
+	struct dma_device ddev;
+
+	void *qmgr_scratch;
+	dma_addr_t scratch_phys;
+
+	struct cppi41_desc *cd;
+	dma_addr_t descs_phys;
+	struct cppi41_channel *chan_busy[ALLOC_DECS_NUM];
+
+	void __iomem *usbss_mem;
+	void __iomem *ctrl_mem;
+	void __iomem *sched_mem;
+	void __iomem *qmgr_mem;
+	unsigned int irq;
+};
+
+static u32 compute_td_desc(unsigned is_rx, unsigned dma, unsigned chan)
+{
+	u32 val;
+
+	val = DESC_TYPE_TEARD << DESC_TYPE;
+	val |= (!!is_rx) << TD_DESC_TX_RX;
+	val |= dma << TD_DESC_DMA_NUM;
+	val |= chan;
+	return chan;
+}
+
+static struct cppi41_channel *to_cpp41_chan(struct dma_chan *c)
+{
+	return container_of(c, struct cppi41_channel, chan);
+}
+
+static struct cppi41_channel *desc_to_chan(struct cppi41_dd *cdd, u32 desc)
+{
+	struct cppi41_channel *c;
+	u32 descs_size;
+	u32 desc_num;
+
+	descs_size = sizeof(struct cppi41_desc) * ALLOC_DECS_NUM;
+
+	if (!((desc >= cdd->descs_phys) &&
+			(desc < (cdd->descs_phys + descs_size)))) {
+		return NULL;
+	}
+
+	desc_num = (desc - cdd->descs_phys) / sizeof(struct cppi41_desc);
+	BUG_ON(desc_num > ALLOC_DECS_NUM);
+	c = cdd->chan_busy[desc_num];
+	cdd->chan_busy[desc_num] = NULL;
+	return c;
+}
+
+static void cppi_writel(u32 val, void *__iomem *mem)
+{
+	writel(val, mem);
+}
+
+static u32 cppi_readl(void *__iomem *mem)
+{
+	u32 val;
+	val = readl(mem);
+	return val;
+}
+
+#define QMGR_NUM_PEND	5
+#define QMGR_PEND(x)	(0x90 + (x) * 4)
+
+static irqreturn_t cppi41_irq(int irq, void *data)
+{
+	struct cppi41_dd *cdd = data;
+	struct cppi41_channel *c;
+	u32 status;
+	int i;
+
+	status = cppi_readl(cdd->usbss_mem + USBSS_IRQ_STATUS);
+	if (!(status & USBSS_IRQ_PD_COMP))
+		return IRQ_NONE;
+	for (i = 0; i < QMGR_NUM_PEND; i++) {
+		u32 val;
+		u32 q_num;
+
+		val = cppi_readl(cdd->qmgr_mem + QMGR_PEND(i));
+		while (val) {
+			u32 desc;
+
+			q_num = __fls(val);
+			val &= ~(1 << q_num);
+			q_num += 32 * i;
+			desc = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(q_num));
+			desc &= ~0x1f;
+			pr_err("%s(%d) Found %u => %08x\n", __func__, __LINE__,
+					q_num, desc);
+			c = desc_to_chan(cdd, desc);
+			if (!c) {
+				/* XXX */
+				continue;
+			}
+			dma_cookie_complete(&c->txd);
+			c->txd.callback(c->txd.callback_param);
+		}
+	}
+	cppi_writel(status, cdd->usbss_mem + USBSS_IRQ_STATUS);
+	return IRQ_HANDLED;
+}
+
+static dma_cookie_t cppi41_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	dma_cookie_t cookie;
+
+	cookie = dma_cookie_assign(tx);
+
+	return cookie;
+}
+
+static int cppi41_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct cppi41_channel *c = to_cpp41_chan(chan);
+
+	dma_cookie_init(chan);
+	dma_async_tx_descriptor_init(&c->txd, chan);
+	c->txd.tx_submit = cppi41_tx_submit;
+	return 0;
+}
+
+static void cppi41_dma_free_chan_resources(struct dma_chan *chan)
+{
+	pr_err("%s(%d)\n", __func__, __LINE__);
+}
+
+static enum dma_status cppi41_dma_tx_status(struct dma_chan *chan,
+	dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	enum dma_status ret;
+
+	/* lock */
+	ret = dma_cookie_status(chan, cookie, txstate);
+	/* unlock */
+
+	return ret;
+}
+
+static void push_desc_queue(struct cppi41_channel *cppi41_chan)
+{
+	struct cppi41_dd *cdd = cppi41_chan->cdd;
+	u32 desc_num;
+	u32 desc_phys;
+	u32 reg;
+
+	desc_phys = lower_32_bits(cppi41_chan->desc_phys);
+	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
+	WARN_ON(cdd->chan_busy[desc_num]);
+	cdd->chan_busy[desc_num] = cppi41_chan;
+
+	reg = (sizeof(struct cppi41_desc) - 24) / 4;
+	reg |= desc_phys;
+	cppi_writel(reg, cdd->qmgr_mem + QMGR_QUEUE_D(cppi41_chan->q_num));
+}
+
+static void cppi41_dma_issue_pending(struct dma_chan *chan)
+{
+	struct cppi41_channel *cppi41_chan = to_cpp41_chan(chan);
+	u32 reg;
+
+	pr_err("%s() chan addr %p q %d c %d p %d\n", __func__,
+			cppi41_chan->gcr_reg,
+			cppi41_chan->q_num,
+			cppi41_chan->q_comp_num,
+			cppi41_chan->port_num);
+
+	reg = GCR_CHAN_ENABLE;
+//	reg |= cppi41_chan->q_num;
+	if (!cppi41_chan->is_tx)
+		reg |= 1 << 14; /* host format */
+
+	cppi_writel(reg, cppi41_chan->gcr_reg);
+
+	dsb();
+	push_desc_queue(cppi41_chan);
+}
+
+static u32 get_host_pd0(u32 length)
+{
+	u32 reg;
+
+	reg = DESC_TYPE_HOST << DESC_TYPE;
+	reg |= length;
+
+	return reg;
+}
+
+static u32 get_host_pd1(struct cppi41_channel *c)
+{
+	u32 reg;
+
+	reg = 0;
+
+	return reg;
+}
+
+static u32 get_host_pd2(struct cppi41_channel *c)
+{
+	u32 reg;
+
+	reg = 5 << 26; /* USB TYPE */
+	reg |= c->q_comp_num;
+
+	return reg;
+}
+
+static u32 get_host_pd3(u32 length)
+{
+	u32 reg;
+
+	/* PD3 = packet size */
+	reg = length;
+
+	return reg;
+}
+
+static u32 get_host_pd6(u32 length)
+{
+	u32 reg;
+
+	/* PD6 buffer size */
+	reg = 1 << 31; /* XXX PD complete interrupt */
+	reg |= length;
+
+	return reg;
+}
+
+static u32 get_host_pd4_or_7(u32 addr)
+{
+	u32 reg;
+
+	reg = addr;
+
+	return reg;
+}
+
+static u32 get_host_pd5(void)
+{
+	u32 reg;
+
+	reg = 0;
+
+	return reg;
+}
+
+static struct dma_async_tx_descriptor *cppi41_dma_prep_slave_sg(
+	struct dma_chan *chan, struct scatterlist *sgl, unsigned sg_len,
+	enum dma_transfer_direction dir, unsigned long tx_flags, void *context)
+{
+	struct cppi41_channel *c = to_cpp41_chan(chan);
+	struct cppi41_desc *d;
+	struct scatterlist *sg;
+	unsigned int i;
+	unsigned int num;
+
+	num = 0;
+	d = c->desc;
+	for_each_sg(sgl, sg, sg_len, i) {
+		u32 addr;
+		u32 len;
+
+		/* XXX at some point we might to want to setup more than one desc */
+		BUG_ON(num > 0);
+		addr = lower_32_bits(sg_dma_address(sg));
+		len = sg_dma_len(sg);
+
+		d->d.pd0 = get_host_pd0(len);
+		d->d.pd1 = get_host_pd1(c);
+		d->d.pd2 = get_host_pd2(c);
+		d->d.pd3 = get_host_pd3(len);
+		d->d.pd4 = get_host_pd4_or_7(addr);
+		d->d.pd5 = get_host_pd5();
+		d->d.pd6 = get_host_pd6(len);
+		d->d.pd7 = get_host_pd4_or_7(addr);
+
+		d++;
+	}
+
+	return &c->txd;
+}
+
+static int cpp41_cfg_chan(struct cppi41_channel *c,
+		struct dma_slave_config *cfg)
+{
+	return 0;
+}
+
+static int cppi41_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+	unsigned long arg)
+{
+	struct cppi41_channel *c = to_cpp41_chan(chan);
+	int ret;
+
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		ret = cpp41_cfg_chan(c, (struct dma_slave_config *) arg);
+		break;
+#if 0
+	case DMA_TERMINATE_ALL:
+		ret = 0;
+		break;
+
+	case DMA_PAUSE:
+		ret = 0;
+		break;
+
+	case DMA_RESUME:
+		ret = 0;
+		break;
+#endif
+	default:
+		ret = -ENXIO;
+		break;
+	}
+	return ret;
+}
+
+static void cleanup_chans(struct cppi41_dd *cdd)
+{
+	while (!list_empty(&cdd->ddev.channels)) {
+		struct cppi41_channel *cchan;
+
+		cchan = list_first_entry(&cdd->ddev.channels,
+				struct cppi41_channel, chan.device_node);
+		list_del(&cchan->chan.device_node);
+		kfree(cchan);
+	}
+}
+
+static int cppi41_add_chans(struct platform_device *pdev, struct cppi41_dd *cdd)
+{
+	struct cppi41_channel *cchan;
+	int i;
+	int ret;
+	u32 n_chans;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "#dma-channels",
+			&n_chans);
+	if (ret)
+		return ret;
+	/*
+	 * The channels can only be used as TX or as RX. So we add twice
+	 * that much dma channels because USB can only do RX or TX.
+	 */
+	n_chans *= 2;
+
+	for (i = 0; i < n_chans; i++) {
+		cchan = kzalloc(sizeof(*cchan), GFP_KERNEL);
+		if (!cchan)
+			goto err;
+
+		cchan->cdd = cdd;
+		if (i & 1) {
+			cchan->gcr_reg = cdd->ctrl_mem + DMA_TXGCR(i >> 1);
+			cchan->is_tx = 1;
+		} else {
+			cchan->gcr_reg = cdd->ctrl_mem + DMA_RXGCR(i >> 1);
+			cchan->is_tx = 0;
+		}
+		cchan->port_num = i >> 1;
+		cchan->desc = &cdd->cd[i * 2];
+		cchan->desc_phys = cdd->descs_phys;
+		cchan->desc_phys += i * 2 * sizeof(struct cppi41_desc);
+		cchan->chan.device = &cdd->ddev;
+		list_add_tail(&cchan->chan.device_node, &cdd->ddev.channels);
+	}
+	return 0;
+err:
+	cleanup_chans(cdd);
+	return -ENOMEM;
+}
+
+static void purge_descs(struct platform_device *pdev, struct cppi41_dd *cdd)
+{
+	unsigned int mem_decs;
+	int i;
+
+	mem_decs = ALLOC_DECS_NUM * sizeof(struct cppi41_desc);
+
+	for (i = 0; i < DESCS_AREAS; i++) {
+
+		cppi_writel(0, cdd->qmgr_mem + QMGR_MEMBASE(i));
+		cppi_writel(0, cdd->qmgr_mem + QMGR_MEMCTRL(i));
+
+		dma_free_coherent(&pdev->dev, mem_decs, cdd->cd,
+				cdd->descs_phys);
+	}
+}
+
+static void disable_sched(struct cppi41_dd *cdd)
+{
+	cppi_writel(0, cdd->sched_mem + DMA_SCHED_CTRL);
+}
+
+static void deinit_cpii41(struct platform_device *pdev, struct cppi41_dd *cdd)
+{
+	disable_sched(cdd);
+
+	purge_descs(pdev, cdd);
+
+	cppi_writel(0, cdd->qmgr_mem + QMGR_LRAM0_BASE);
+	cppi_writel(0, cdd->qmgr_mem + QMGR_LRAM0_BASE);
+	dma_free_coherent(&pdev->dev, QMGR_SCRATCH_SIZE, cdd->qmgr_scratch,
+			cdd->scratch_phys);
+}
+
+static int init_descs(struct platform_device *pdev, struct cppi41_dd *cdd)
+{
+	unsigned int desc_size;
+	unsigned int mem_decs;
+	int i;
+	u32 reg;
+	u32 idx;
+
+	BUILD_BUG_ON(sizeof(struct cppi41_desc) &
+			(sizeof(struct cppi41_desc) - 1));
+	BUILD_BUG_ON(sizeof(struct cppi41_desc) < 32);
+	BUILD_BUG_ON(ALLOC_DECS_NUM < 32);
+
+	desc_size = sizeof(struct cppi41_desc);
+	mem_decs = ALLOC_DECS_NUM * desc_size;
+
+	idx = 0;
+	for (i = 0; i < DESCS_AREAS; i++) {
+
+		reg = idx << QMGR_MEMCTRL_IDX_SH;
+		reg |= (ilog2(desc_size) - 5) << QMGR_MEMCTRL_DESC_SH;
+		reg |= ilog2(ALLOC_DECS_NUM) - 5;
+
+		BUILD_BUG_ON(DESCS_AREAS != 1);
+		cdd->cd = dma_alloc_coherent(&pdev->dev, mem_decs,
+				&cdd->descs_phys, GFP_KERNEL);
+		if (!cdd->cd)
+			return -ENOMEM;
+
+		cppi_writel(cdd->descs_phys, cdd->qmgr_mem + QMGR_MEMBASE(i));
+		cppi_writel(reg, cdd->qmgr_mem + QMGR_MEMCTRL(i));
+
+		idx += ALLOC_DECS_NUM;
+	}
+	return 0;
+}
+
+static void init_sched(struct cppi41_dd *cdd)
+{
+	unsigned ch;
+	unsigned word;
+	u32 reg;
+
+	word = 0;
+	cppi_writel(0, cdd->sched_mem + DMA_SCHED_CTRL);
+	for (ch = 0; ch < 15 * 2; ch += 2) {
+
+		reg = SCHED_ENTRY0_CHAN(ch);
+		reg |= SCHED_ENTRY1_CHAN(ch) | SCHED_ENTRY1_IS_RX;
+
+		reg |= SCHED_ENTRY2_CHAN(ch + 1);
+		reg |= SCHED_ENTRY3_CHAN(ch + 1) | SCHED_ENTRY3_IS_RX;
+		cppi_writel(reg, cdd->sched_mem + DMA_SCHED_WORD(word));
+		word++;
+	}
+	reg = 15 * 2 * 2 - 1;
+	reg |= DMA_SCHED_CTRL_EN;
+	cppi_writel(reg, cdd->sched_mem + DMA_SCHED_CTRL);
+}
+
+static int init_cppi41(struct platform_device *pdev, struct cppi41_dd *cdd)
+{
+	int ret;
+
+	BUILD_BUG_ON(QMGR_SCRATCH_SIZE > ((1 << 14) - 1));
+	cdd->qmgr_scratch = dma_alloc_coherent(&pdev->dev, QMGR_SCRATCH_SIZE,
+			&cdd->scratch_phys, GFP_KERNEL);
+	if (!cdd->qmgr_scratch)
+		return -ENOMEM;
+
+	cppi_writel(cdd->scratch_phys, cdd->qmgr_mem + QMGR_LRAM0_BASE);
+	cppi_writel(QMGR_SCRATCH_SIZE, cdd->qmgr_mem + QMGR_LRAM_SIZE);
+	cppi_writel(0, cdd->qmgr_mem + QMGR_LRAM1_BASE);
+
+	ret = init_descs(pdev, cdd);
+	if (ret)
+		goto err_td;
+
+	init_sched(cdd);
+	return 0;
+err_td:
+	deinit_cpii41(pdev, cdd);
+	return ret;
+}
+
+static struct platform_driver cpp41_dma_driver;
+/*
+ * The param format is:
+ * Q X Y Z
+ * Q: Port
+ * X: 0 = RX else TX
+ * Y: queue number
+ * Z: queue complete number
+ */
+#define INFO_PORT	0
+#define INFO_IS_TX	1
+#define INFO_QUEUE_NUM	2
+#define INFO_QUEUEC_NUM	3
+
+static bool cpp41_dma_filter_fn(struct dma_chan *chan, void *param)
+{
+	struct cppi41_channel *cchan;
+	u32 *num = param;
+
+	if (chan->device->dev->driver != &cpp41_dma_driver.driver)
+		return false;
+
+	cchan = to_cpp41_chan(chan);
+
+	if (cchan->port_num != num[INFO_PORT])
+		return false;
+
+	if (cchan->is_tx && !num[INFO_IS_TX])
+		return false;
+
+	cchan->q_num = num[INFO_QUEUE_NUM];
+	cchan->q_comp_num = num[INFO_QUEUEC_NUM];
+	return true;
+}
+
+static struct of_dma_filter_info cpp41_dma_info = {
+	.filter_fn = cpp41_dma_filter_fn,
+};
+
+/* a little advanced */
+static struct dma_chan *cppi41_dma_xlate(struct of_phandle_args *dma_spec,
+		struct of_dma *ofdma)
+{
+	int count = dma_spec->args_count;
+	struct of_dma_filter_info *info = ofdma->of_dma_data;
+
+	if (!info || !info->filter_fn)
+		return NULL;
+
+	if (count != 4)
+		return NULL;
+
+	return dma_request_channel(info->dma_cap, info->filter_fn,
+			&dma_spec->args[0]);
+}
+
+static int cppi41_dma_probe(struct platform_device *pdev)
+{
+	struct cppi41_dd *cdd;
+	int irq;
+	int ret;
+
+	cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
+	if (!cdd)
+		return -ENOMEM;
+
+	dma_cap_set(DMA_SLAVE, cdd->ddev.cap_mask);
+	cdd->ddev.device_alloc_chan_resources = cppi41_dma_alloc_chan_resources;
+	cdd->ddev.device_free_chan_resources = cppi41_dma_free_chan_resources;
+	cdd->ddev.device_tx_status = cppi41_dma_tx_status;
+	cdd->ddev.device_issue_pending = cppi41_dma_issue_pending;
+	cdd->ddev.device_prep_slave_sg = cppi41_dma_prep_slave_sg;
+	cdd->ddev.device_control = cppi41_dma_control;
+	cdd->ddev.dev = &pdev->dev;
+	INIT_LIST_HEAD(&cdd->ddev.channels);
+	cpp41_dma_info.dma_cap = cdd->ddev.cap_mask;
+
+	cdd->usbss_mem = of_iomap(pdev->dev.of_node, 0);
+	cdd->ctrl_mem = of_iomap(pdev->dev.of_node, 1);
+	cdd->sched_mem = of_iomap(pdev->dev.of_node, 2);
+	cdd->qmgr_mem = of_iomap(pdev->dev.of_node, 3);
+
+	if (!cdd->usbss_mem || !cdd->ctrl_mem || !cdd->sched_mem ||
+			!cdd->qmgr_mem) {
+		ret = -ENXIO;
+		goto err_remap;
+	}
+
+	ret = init_cppi41(pdev, cdd);
+	if (ret)
+		goto err_init_cppi;
+
+	ret = cppi41_add_chans(pdev, cdd);
+	if (ret)
+		goto err_chans;
+
+	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (!irq)
+		goto err_irq;
+
+	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
+
+	ret = request_irq(irq, cppi41_irq, IRQF_SHARED, "cppi41", cdd);
+	if (ret)
+		goto err_irq;
+	cdd->irq = irq;
+
+	ret = dma_async_device_register(&cdd->ddev);
+	if (ret)
+		goto err_dma_reg;
+
+	ret = of_dma_controller_register(pdev->dev.of_node,
+			cppi41_dma_xlate, &cpp41_dma_info);
+	if (ret)
+		goto err_of;
+
+	platform_set_drvdata(pdev, cdd);
+	dev_err(&pdev->dev, "finally\n");
+	return 0;
+err_of:
+	dma_async_device_unregister(&cdd->ddev);
+err_dma_reg:
+	free_irq(irq, cdd);
+err_irq:
+	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
+	cleanup_chans(cdd);
+err_chans:
+	deinit_cpii41(pdev, cdd);
+err_init_cppi:
+	iounmap(cdd->usbss_mem);
+	iounmap(cdd->ctrl_mem);
+	iounmap(cdd->sched_mem);
+	iounmap(cdd->qmgr_mem);
+err_remap:
+	kfree(cdd);
+	return ret;
+}
+
+static int cppi41_dma_remove(struct platform_device *pdev)
+{
+	struct cppi41_dd *cdd = platform_get_drvdata(pdev);
+
+	of_dma_controller_free(pdev->dev.of_node);
+	dma_async_device_unregister(&cdd->ddev);
+
+	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
+	free_irq(cdd->irq, cdd);
+	cleanup_chans(cdd);
+	deinit_cpii41(pdev, cdd);
+	iounmap(cdd->usbss_mem);
+	iounmap(cdd->ctrl_mem);
+	iounmap(cdd->sched_mem);
+	iounmap(cdd->qmgr_mem);
+	kfree(cdd);
+	return 0;
+}
+
+static const struct of_device_id cppi41_dma_ids[] = {
+	{ .compatible = "ti,am3359-cppi41", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, cppi41_dma_ids);
+
+static struct platform_driver cpp41_dma_driver = {
+	.probe  = cppi41_dma_probe,
+	.remove = cppi41_dma_remove,
+	.driver = {
+		.name = "cppi41-dma-engine",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(cppi41_dma_ids),
+	},
+};
+
+module_platform_driver(cpp41_dma_driver);
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 797e3fd..9d74a93 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -125,6 +125,10 @@ config USB_TI_CPPI_DMA
 	help
 	  Enable DMA transfers when TI CPPI DMA is available.
 
+config USB_TI_CPPI41_DMA
+	bool 'TI CPPI 4.1 (AM335x)'
+	depends on ARCH_OMAP
+
 config USB_TUSB_OMAP_DMA
 	bool 'TUSB 6010'
 	depends on USB_MUSB_TUSB6010
diff --git a/drivers/usb/musb/Makefile b/drivers/usb/musb/Makefile
index 2b82ed7..c9eb245 100644
--- a/drivers/usb/musb/Makefile
+++ b/drivers/usb/musb/Makefile
@@ -29,3 +29,4 @@ musb_hdrc-$(CONFIG_USB_INVENTRA_DMA)		+= musbhsdma.o
 musb_hdrc-$(CONFIG_USB_TI_CPPI_DMA)		+= cppi_dma.o
 musb_hdrc-$(CONFIG_USB_TUSB_OMAP_DMA)		+= tusb6010_omap.o
 musb_hdrc-$(CONFIG_USB_UX500_DMA)		+= ux500_dma.o
+musb_hdrc-$(CONFIG_USB_TI_CPPI41_DMA)		+= musb_dmaeng.o
diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index c8e67fd..bfe2993 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -71,7 +71,7 @@ struct musb_hw_ep;
 #ifdef CONFIG_USB_TI_CPPI_DMA
 #define	is_cppi_enabled()	1
 #else
-#define	is_cppi_enabled()	0
+#define	is_cppi_enabled()	1
 #endif
 
 #ifdef CONFIG_USB_TUSB_OMAP_DMA
diff --git a/drivers/usb/musb/musb_dmaeng.c b/drivers/usb/musb/musb_dmaeng.c
new file mode 100644
index 0000000..c12f42a
--- /dev/null
+++ b/drivers/usb/musb/musb_dmaeng.c
@@ -0,0 +1,294 @@
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/sizes.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+
+#include "musb_core.h"
+
+struct cppi41_dma_channel {
+	struct dma_channel channel;
+	struct cppi41_dma_controller *controller;
+	struct musb_hw_ep *hw_ep;
+	struct dma_chan *dc;
+	unsigned int cur_len;
+	dma_cookie_t cookie;
+	u8 port_num;
+	u8 is_tx;
+	u8 is_allocated;
+};
+
+#define MUSB_DMA_NUM_CHANNELS 15
+
+struct cppi41_dma_controller {
+	struct dma_controller controller;
+	struct cppi41_dma_channel rx_channel[MUSB_DMA_NUM_CHANNELS];
+	struct cppi41_dma_channel tx_channel[MUSB_DMA_NUM_CHANNELS];
+	struct musb *musb;
+};
+
+static void cppi41_dma_callback(void *private_data)
+{
+	struct dma_channel *channel = private_data;
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct musb_hw_ep       *hw_ep = cppi41_channel->hw_ep;
+	struct musb *musb = hw_ep->musb;
+	unsigned long flags;
+
+	dev_err(musb->controller, "DMA transfer done on hw_ep=%d\n",
+		hw_ep->epnum);
+
+	spin_lock_irqsave(&musb->lock, flags);
+	cppi41_channel->channel.actual_len = cppi41_channel->cur_len;
+	cppi41_channel->channel.status = MUSB_DMA_STATUS_FREE;
+	musb_dma_completion(musb, hw_ep->epnum, cppi41_channel->is_tx);
+	spin_unlock_irqrestore(&musb->lock, flags);
+}
+
+static bool cppi41_configure_channel(struct dma_channel *channel,
+				u16 packet_sz, u8 mode,
+				dma_addr_t dma_addr, u32 len)
+{
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct dma_chan *dc = cppi41_channel->dc;
+	struct dma_async_tx_descriptor *dma_desc;
+	enum dma_transfer_direction direction;
+	struct musb *musb = cppi41_channel->controller->musb;
+
+	dev_err(musb->controller,
+		"configure packet_sz=%d, mode=%d, dma_addr=0x%llx, len=%d is_tx=%d\n",
+		packet_sz, mode, (unsigned long long) dma_addr,
+		len, cppi41_channel->is_tx);
+
+	cppi41_channel->cur_len = len;
+
+	direction = cppi41_channel->is_tx ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM;
+	dma_desc = dmaengine_prep_slave_single(dc, dma_addr, len, direction,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!dma_desc)
+		return false;
+
+	dma_desc->callback = cppi41_dma_callback;
+	dma_desc->callback_param = channel;
+	cppi41_channel->cookie = dma_desc->tx_submit(dma_desc);
+
+	dma_async_issue_pending(dc);
+	return true;
+}
+
+static struct dma_channel *cppi41_dma_channel_allocate(struct dma_controller *c,
+				struct musb_hw_ep *hw_ep, u8 is_tx)
+{
+	struct cppi41_dma_controller *controller = container_of(c,
+			struct cppi41_dma_controller, controller);
+	struct cppi41_dma_channel *cppi41_channel = NULL;
+	struct musb *musb = controller->musb;
+	u8 ch_num = hw_ep->epnum - 1;
+
+	if (ch_num >= MUSB_DMA_NUM_CHANNELS)
+		return NULL;
+
+	if (!is_tx)
+		return NULL;
+	if (is_tx)
+		cppi41_channel = &controller->tx_channel[ch_num];
+	else
+		cppi41_channel = &controller->rx_channel[ch_num];
+
+	if (!cppi41_channel->dc)
+		return NULL;
+
+	if (cppi41_channel->is_allocated)
+		return NULL;
+
+	cppi41_channel->hw_ep = hw_ep;
+	cppi41_channel->is_allocated = 1;
+
+	dev_err(musb->controller, "alloc hw_ep=%d, is_tx=0x%x, port=%d\n",
+		hw_ep->epnum, is_tx,
+		cppi41_channel->port_num);
+
+	return &cppi41_channel->channel;
+}
+
+static void cppi41_dma_channel_release(struct dma_channel *channel)
+{
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct musb *musb = cppi41_channel->controller->musb;
+
+	dev_err(musb->controller, "release channel=%d\n", cppi41_channel->port_num);
+
+	if (cppi41_channel->is_allocated) {
+		cppi41_channel->is_allocated = 0;
+		channel->status = MUSB_DMA_STATUS_FREE;
+		channel->actual_len = 0;
+	}
+}
+
+static int cppi41_dma_channel_program(struct dma_channel *channel,
+				u16 packet_sz, u8 mode,
+				dma_addr_t dma_addr, u32 len)
+{
+	int ret;
+
+	BUG_ON(channel->status == MUSB_DMA_STATUS_UNKNOWN ||
+		channel->status == MUSB_DMA_STATUS_BUSY);
+
+	channel->status = MUSB_DMA_STATUS_BUSY;
+	channel->actual_len = 0;
+	ret = cppi41_configure_channel(channel, packet_sz, mode, dma_addr, len);
+	if (!ret)
+		channel->status = MUSB_DMA_STATUS_FREE;
+
+	return ret;
+}
+
+static int cppi41_dma_channel_abort(struct dma_channel *channel)
+{
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct cppi41_dma_controller *controller = cppi41_channel->controller;
+	struct musb *musb = controller->musb;
+
+	dev_err(musb->controller, "abort channel=%d, is_tx=%d\n",
+		cppi41_channel->port_num, cppi41_channel->is_tx);
+	return 0;
+}
+
+static void cppi41_release_all_dma_chans(struct cppi41_dma_controller *ctrl)
+{
+	struct dma_chan *dc;
+	int i;
+
+	for (i = 0; i < MUSB_DMA_NUM_CHANNELS; i++) {
+		dc = ctrl->tx_channel[i].dc;
+		if (dc)
+			dma_release_channel(dc);
+		dc = ctrl->rx_channel[i].dc;
+		if (dc)
+			dma_release_channel(dc);
+	}
+}
+
+static void cppi41_dma_controller_stop(struct cppi41_dma_controller *controller)
+{
+	cppi41_release_all_dma_chans(controller);
+}
+
+static int cppi41_dma_controller_start(struct cppi41_dma_controller *controller)
+{
+	struct musb *musb = controller->musb;
+	struct device *dev = musb->controller;
+	struct device_node *np = dev->of_node;
+	struct cppi41_dma_channel *cppi41_channel;
+	int count;
+	int i;
+	int ret;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	count = of_property_count_strings(np, "dma-names");
+	if (count < 0)
+		return count;
+
+	for (i = 0; i < count; i++) {
+		struct dma_chan *dc;
+		struct dma_channel *musb_dma;
+		const char *str;
+		unsigned is_tx;
+		unsigned int port;
+
+		ret = of_property_read_string_index(np, "dma-names", i, &str);
+		if (ret)
+			goto err;
+		if (!strncmp(str, "tx", 2))
+			is_tx = 1;
+		else if (!strncmp(str, "rx", 2))
+			is_tx = 0;
+		else {
+			dev_err(dev, "Wrong dmatype %s\n", str);
+			goto err;
+		}
+		ret = kstrtouint(str + 2, 0, &port);
+		if (ret)
+			goto err;
+
+		if (port > MUSB_DMA_NUM_CHANNELS || !port)
+			goto err;
+		if (is_tx)
+			cppi41_channel = &controller->tx_channel[port - 1];
+		else
+			cppi41_channel = &controller->rx_channel[port - 1];
+
+		cppi41_channel->controller = controller;
+		cppi41_channel->port_num = port;
+		cppi41_channel->is_tx = is_tx;
+
+		musb_dma = &cppi41_channel->channel;
+		musb_dma->private_data = cppi41_channel;
+		musb_dma->status = MUSB_DMA_STATUS_FREE;
+		musb_dma->max_len = SZ_4M;
+
+		dc = dma_request_slave_channel(dev, str);
+		if (!dc) {
+			dev_err(dev, "Falied to request %s.\n", str);
+			goto err;
+		}
+		cppi41_channel->dc = dc;
+
+#if 0
+		XXX just in case
+		ret = dc->device->device_control(dc, DMA_SLAVE_CONFIG,
+				(unsigned long) &cfg);
+		if (ret)
+			goto err;
+#endif
+	}
+	return 0;
+err:
+	cppi41_release_all_dma_chans(controller);
+	return -EINVAL;
+}
+
+void dma_controller_destroy(struct dma_controller *c)
+{
+	struct cppi41_dma_controller *controller = container_of(c,
+			struct cppi41_dma_controller, controller);
+
+	cppi41_dma_controller_stop(controller);
+	kfree(controller);
+}
+
+struct dma_controller *dma_controller_create(struct musb *musb,
+					void __iomem *base)
+{
+	struct cppi41_dma_controller *controller;
+	int ret;
+
+	if (musb->controller->of_node) {
+		dev_err(musb->controller, "Need DT for the DMA engine.\n");
+		return NULL;
+	}
+	controller = kzalloc(sizeof(*controller), GFP_KERNEL);
+	if (!controller)
+		goto kzalloc_fail;
+
+	controller->musb = musb;
+
+	controller->controller.channel_alloc = cppi41_dma_channel_allocate;
+	controller->controller.channel_release = cppi41_dma_channel_release;
+	controller->controller.channel_program = cppi41_dma_channel_program;
+	controller->controller.channel_abort = cppi41_dma_channel_abort;
+
+	ret = cppi41_dma_controller_start(controller);
+	if (ret)
+		goto plat_get_fail;
+	return &controller->controller;
+
+plat_get_fail:
+	kfree(controller);
+kzalloc_fail:
+	return NULL;
+}
-- 
1.8.3.2

