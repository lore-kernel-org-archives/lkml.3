Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3GVSMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:12:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:41867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab3GVSMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:12:14 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH 16/16] usb/musb dma: add cppi41 dma driver
Date: Mon, 22 Jul 2013 20:10:07 +0200
Message-Id: <1374516607-2705-17-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is currently used by musb' cppi41 couter part. I may merge
both dma engine user of musb at some point but not just yet.
The driver seems to work in RX/TX mode. Canceling of transfer is missing
haven't noticed any problems so far.

v1..v2:
- RX path added
- dma mode 0 & 1 is working
- device tree nodes re-created.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am335x-evm.dts |   4 +
 arch/arm/boot/dts/am33xx.dtsi    |  61 +++
 drivers/dma/Kconfig              |   8 +
 drivers/dma/Makefile             |   1 +
 drivers/dma/cppi41.c             | 911 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/Kconfig         |   4 +
 drivers/usb/musb/Makefile        |   1 +
 drivers/usb/musb/musb_cppi41.c   | 433 +++++++++++++++++++
 drivers/usb/musb/musb_dma.h      |   2 +-
 9 files changed, 1424 insertions(+), 1 deletion(-)
 create mode 100644 drivers/dma/cppi41.c
 create mode 100644 drivers/usb/musb/musb_cppi41.c

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index a3a642a..d71ca92 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -189,6 +189,10 @@
 			usb@47401800 {
 				status = "okay";
 			};
+
+			dma@07402000  {
+				status = "okay";
+			};
 		};
 
 		i2c1: i2c@4802a000 {
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 81afb27..9e2b543 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -375,6 +375,29 @@
 					port-mode = <3>;
 					power = <250>;
 					phys = <&usb0_phy>;
+
+				dmas = <&cppi41dma  0 0 &cppi41dma  1 0
+					&cppi41dma  2 0 &cppi41dma  3 0
+					&cppi41dma  4 0 &cppi41dma  5 0
+					&cppi41dma  6 0 &cppi41dma  7 0
+					&cppi41dma  8 0 &cppi41dma  9 0
+					&cppi41dma 10 0 &cppi41dma 11 0
+					&cppi41dma 12 0 &cppi41dma 13 0
+					&cppi41dma 14 0 &cppi41dma  0 1
+					&cppi41dma  1 1 &cppi41dma  2 1
+					&cppi41dma  3 1 &cppi41dma  4 1
+					&cppi41dma  5 1 &cppi41dma  6 1
+					&cppi41dma  7 1 &cppi41dma  8 1
+					&cppi41dma  9 1 &cppi41dma 10 1
+					&cppi41dma 11 1 &cppi41dma 12 1
+					&cppi41dma 13 1 &cppi41dma 14 1>;
+				dma-names =
+					"rx1", "rx2", "rx3", "rx4", "rx5", "rx6", "rx7",
+					"rx8", "rx9", "rx10", "rx11", "rx12", "rx13",
+					"rx14", "rx15",
+					"tx1", "tx2", "tx3", "tx4", "tx5", "tx6", "tx7",
+					"tx8", "tx9", "tx10", "tx11", "tx12", "tx13",
+					"tx14", "tx15";
 				};
 			};
 
@@ -407,8 +430,46 @@
 					port-mode = <3>;
 					power = <250>;
 					phys = <&usb1_phy>;
+
+				dmas = <&cppi41dma 15 0 &cppi41dma 16 0
+					&cppi41dma 17 0 &cppi41dma 18 0
+					&cppi41dma 19 0 &cppi41dma 20 0
+					&cppi41dma 21 0 &cppi41dma 22 0
+					&cppi41dma 23 0 &cppi41dma 24 0
+					&cppi41dma 25 0 &cppi41dma 26 0
+					&cppi41dma 27 0 &cppi41dma 28 0
+					&cppi41dma 29 0 &cppi41dma 15 1
+					&cppi41dma 16 1 &cppi41dma 17 1
+					&cppi41dma 18 1 &cppi41dma 19 1
+					&cppi41dma 20 1 &cppi41dma 21 1
+					&cppi41dma 22 1 &cppi41dma 23 1
+					&cppi41dma 24 1 &cppi41dma 25 1
+					&cppi41dma 26 1 &cppi41dma 27 1
+					&cppi41dma 28 1 &cppi41dma 29 1>;
+				dma-names =
+					"rx1", "rx2", "rx3", "rx4", "rx5", "rx6", "rx7",
+					"rx8", "rx9", "rx10", "rx11", "rx12", "rx13",
+					"rx14", "rx15",
+					"tx1", "tx2", "tx3", "tx4", "tx5", "tx6", "tx7",
+					"tx8", "tx9", "tx10", "tx11", "tx12", "tx13",
+					"tx14", "tx15";
 				};
 			};
+
+			cppi41dma: dma@07402000 {
+				compatible = "ti,am3359-cppi41";
+				reg =  <0x47400000 0x1000
+					0x47402000 0x1000
+					0x47403000 0x1000
+					0x47404000 0x4000>;
+				reg-names = "glue controller scheduler queuemgr";
+				interrupts = <17>;
+				interrupt-names = "glue";
+				#dma-cells = <2>;
+				#dma-channels = <30>;
+				#dma-requests = <256>;
+				status = "disabled";
+			};
 		};
 
 		epwmss0: epwmss@48300000 {
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6825957..77bc480 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -287,6 +287,14 @@ config DMA_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 
+config TI_CPPI41
+	tristate "AM33xx CPPI41 DMA support"
+	depends on ARCH_OMAP
+	select DMA_ENGINE
+	help
+	  The Communications Port Programming Interface (CPPI) 4.1 DMA engine
+	  is currently used by the USB driver on AM335x platforms.
+
 config MMP_PDMA
 	bool "MMP PDMA support"
 	depends on (ARCH_MMP || ARCH_PXA)
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 5e0f2ef..6d62ec3 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
 obj-$(CONFIG_DMA_OMAP) += omap-dma.o
 obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
 obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
+obj-$(CONFIG_TI_CPPI41) += cppi41.o
diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
new file mode 100644
index 0000000..040209a
--- /dev/null
+++ b/drivers/dma/cppi41.c
@@ -0,0 +1,911 @@
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
+#define DESC_LENGTH_BITS_NUM	21
+
+#define DESC_TYPE_USB	(5 << 26)
+#define DESC_PD_COMPLETE	(1 << 31)
+
+/* DMA engine */
+#define DMA_TXGCR(x)	(0x800 + (x) * 0x20)
+#define DMA_RXGCR(x)	(0x808 + (x) * 0x20)
+#define RXHPCRA0		4
+
+#define GCR_CHAN_ENABLE		(1 << 31)
+#define GCR_STARV_RETRY		(1 << 24)
+#define GCR_DESC_TYPE_HOST	(1 << 14)
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
+#define QMGR_NUM_PEND	5
+#define QMGR_PEND(x)	(0x90 + (x) * 4)
+
+#define QMGR_PENDING_SLOT_Q(x)	(x / 32)
+#define QMGR_PENDING_BIT_Q(x)	(x % 32)
+
+#define QMGR_QUEUE_A(n)	(0x2000 + (n) * 0x10)
+#define QMGR_QUEUE_B(n)	(0x2004 + (n) * 0x10)
+#define QMGR_QUEUE_C(n)	(0x2008 + (n) * 0x10)
+#define QMGR_QUEUE_D(n)	(0x200c + (n) * 0x10)
+
+/* Glue layer specific */
+/* USBSS  / USB AM335x */
+#define USBSS_IRQ_STATUS	0x28
+#define USBSS_IRQ_ENABLER	0x2c
+#define USBSS_IRQ_CLEARR	0x30
+
+#define USBSS_IRQ_PD_COMP	(1 <<  2)
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
+struct cppi41_desc {
+	u32 pd0;
+	u32 pd1;
+	u32 pd2;
+	u32 pd3;
+	u32 pd4;
+	u32 pd5;
+	u32 pd6;
+	u32 pd7;
+} __aligned(32);
+
+struct chan_queues {
+	u16 submit;
+	u16 complete;
+};
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
+	const struct chan_queues *queues_rx;
+	const struct chan_queues *queues_tx;
+};
+
+#define FIST_COMPLETION_QUEUE	93
+static struct chan_queues usb_queues_tx[] = {
+	/* USB0 ENDP 1 */
+	[ 0] = { .submit = 32, .complete =  93},
+	[ 1] = { .submit = 34, .complete =  94},
+	[ 2] = { .submit = 36, .complete =  95},
+	[ 3] = { .submit = 38, .complete =  96},
+	[ 4] = { .submit = 40, .complete =  97},
+	[ 5] = { .submit = 42, .complete =  98},
+	[ 6] = { .submit = 44, .complete =  99},
+	[ 7] = { .submit = 46, .complete = 100},
+	[ 8] = { .submit = 48, .complete = 101},
+	[ 9] = { .submit = 50, .complete = 102},
+	[10] = { .submit = 52, .complete = 103},
+	[11] = { .submit = 54, .complete = 104},
+	[12] = { .submit = 56, .complete = 105},
+	[13] = { .submit = 58, .complete = 106},
+	[14] = { .submit = 60, .complete = 107},
+
+	/* USB1 ENDP1 */
+	[15] = { .submit = 62, .complete = 125},
+	[16] = { .submit = 64, .complete = 126},
+	[17] = { .submit = 66, .complete = 127},
+	[18] = { .submit = 68, .complete = 128},
+	[19] = { .submit = 70, .complete = 129},
+	[20] = { .submit = 72, .complete = 130},
+	[21] = { .submit = 74, .complete = 131},
+	[22] = { .submit = 76, .complete = 132},
+	[23] = { .submit = 78, .complete = 133},
+	[24] = { .submit = 80, .complete = 134},
+	[25] = { .submit = 82, .complete = 135},
+	[26] = { .submit = 84, .complete = 136},
+	[27] = { .submit = 86, .complete = 137},
+	[28] = { .submit = 88, .complete = 138},
+	[29] = { .submit = 90, .complete = 139},
+};
+
+static const struct chan_queues usb_queues_rx[] = {
+	/* USB0 ENDP 1 */
+	[ 0] = { .submit =  0, .complete = 109},
+	[ 1] = { .submit =  1, .complete = 110},
+	[ 2] = { .submit =  2, .complete = 111},
+	[ 3] = { .submit =  3, .complete = 112},
+	[ 4] = { .submit =  4, .complete = 113},
+	[ 5] = { .submit =  5, .complete = 114},
+	[ 6] = { .submit =  6, .complete = 115},
+	[ 7] = { .submit =  7, .complete = 116},
+	[ 8] = { .submit =  8, .complete = 117},
+	[ 9] = { .submit =  9, .complete = 118},
+	[10] = { .submit = 10, .complete = 119},
+	[11] = { .submit = 11, .complete = 120},
+	[12] = { .submit = 12, .complete = 121},
+	[13] = { .submit = 13, .complete = 122},
+	[14] = { .submit = 14, .complete = 123},
+
+	/* USB1 ENDP 1 */
+	[15] = { .submit = 16, .complete = 141},
+	[16] = { .submit = 17, .complete = 142},
+	[17] = { .submit = 18, .complete = 143},
+	[18] = { .submit = 19, .complete = 144},
+	[19] = { .submit = 20, .complete = 145},
+	[20] = { .submit = 21, .complete = 146},
+	[21] = { .submit = 22, .complete = 147},
+	[22] = { .submit = 23, .complete = 148},
+	[23] = { .submit = 24, .complete = 149},
+	[24] = { .submit = 25, .complete = 150},
+	[25] = { .submit = 26, .complete = 151},
+	[26] = { .submit = 27, .complete = 152},
+	[27] = { .submit = 28, .complete = 153},
+	[28] = { .submit = 29, .complete = 154},
+	[29] = { .submit = 30, .complete = 155},
+};
+
+struct cppi_glue_infos {
+	irqreturn_t (*isr)(int irq, void *data);
+	const struct chan_queues *queues_rx;
+	const struct chan_queues *queues_tx;
+};
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
+	__raw_writel(val, mem);
+}
+
+static u32 cppi_readl(void *__iomem *mem)
+{
+	return __raw_readl(mem);
+}
+
+static u32 pd_trans_len(u32 val)
+{
+	return val & ((1 << (DESC_LENGTH_BITS_NUM + 1)) - 1);
+}
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
+	cppi_writel(status, cdd->usbss_mem + USBSS_IRQ_STATUS);
+
+	for (i = QMGR_PENDING_SLOT_Q(FIST_COMPLETION_QUEUE); i < QMGR_NUM_PEND;
+			i++) {
+		u32 val;
+		u32 q_num;
+
+		val = cppi_readl(cdd->qmgr_mem + QMGR_PEND(i));
+		if (i == QMGR_PENDING_SLOT_Q(FIST_COMPLETION_QUEUE) && val) {
+			u32 mask;
+			/* set corresponding bit for completetion Q 93 */
+			mask = 1 << QMGR_PENDING_BIT_Q(FIST_COMPLETION_QUEUE);
+			/* not set all bits for queues less than Q 93 */
+			mask--;
+			/* now invert and keep only Q 93+ set */
+			val &= ~mask;
+		}
+
+		if (val)
+			__iormb();
+
+		while (val) {
+			u32 desc;
+
+			q_num = __fls(val);
+			val &= ~(1 << q_num);
+			q_num += 32 * i;
+			desc = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(q_num));
+			desc &= ~0x1f;
+			c = desc_to_chan(cdd, desc);
+			if (WARN_ON(!c))
+				continue;
+			c->txd.transfered = pd_trans_len(c->desc->pd0);
+
+			dma_cookie_complete(&c->txd);
+			c->txd.callback(c->txd.callback_param);
+		}
+	}
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
+
+	if (!c->is_tx)
+		cppi_writel(c->q_num, c->gcr_reg + RXHPCRA0);
+
+	return 0;
+}
+
+static void cppi41_dma_free_chan_resources(struct dma_chan *chan)
+{
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
+	reg = GCR_CHAN_ENABLE;
+	if (!cppi41_chan->is_tx) {
+		reg |= GCR_STARV_RETRY;
+		reg |= GCR_DESC_TYPE_HOST;
+		reg |= cppi41_chan->q_comp_num;
+	}
+
+	cppi_writel(reg, cppi41_chan->gcr_reg);
+
+	/*
+	 * We don't use writel() but __raw_writel() so we have to make sure
+	 * that the DMA descriptor in coherent memory made to the main memory
+	 * before starting the dma engine.
+	 */
+	__iowmb();
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
+	reg = DESC_TYPE_USB;
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
+	reg = DESC_PD_COMPLETE;
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
+		/* We need to use more than one desc once musb supports sg */
+		BUG_ON(num > 0);
+		addr = lower_32_bits(sg_dma_address(sg));
+		len = sg_dma_len(sg);
+
+		d->pd0 = get_host_pd0(len);
+		d->pd1 = get_host_pd1(c);
+		d->pd2 = get_host_pd2(c);
+		d->pd3 = get_host_pd3(len);
+		d->pd4 = get_host_pd4_or_7(addr);
+		d->pd5 = get_host_pd5();
+		d->pd6 = get_host_pd6(len);
+		d->pd7 = get_host_pd4_or_7(addr);
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
+static int cppi41_stop_chan(struct dma_chan *chan)
+{
+	struct cppi41_channel *c = to_cpp41_chan(chan);
+	struct cppi41_dd *cdd = c->cdd;
+	u32 desc_num;
+	u32 desc_phys;
+
+	/* XXX tear down */
+	desc_phys = lower_32_bits(c->desc_phys);
+	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
+	WARN_ON(!cdd->chan_busy[desc_num]);
+	cdd->chan_busy[desc_num] = NULL;
+
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
+	case DMA_TERMINATE_ALL:
+
+		ret = cppi41_stop_chan(chan);
+		break;
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
+ * X Y
+ * X: Port
+ * Y: 0 = RX else TX
+ */
+#define INFO_PORT	0
+#define INFO_IS_TX	1
+
+static bool cpp41_dma_filter_fn(struct dma_chan *chan, void *param)
+{
+	struct cppi41_channel *cchan;
+	struct cppi41_dd *cdd;
+	const struct chan_queues *queues;
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
+	cdd = cchan->cdd;
+	if (cchan->is_tx)
+		queues = cdd->queues_tx;
+	else
+		queues = cdd->queues_rx;
+
+	BUILD_BUG_ON(ARRAY_SIZE(usb_queues_rx) != ARRAY_SIZE(usb_queues_tx));
+	if (WARN_ON(cchan->port_num > ARRAY_SIZE(usb_queues_rx)))
+		return false;
+
+	cchan->q_num = queues[cchan->port_num].submit;
+	cchan->q_comp_num = queues[cchan->port_num].complete;
+	return true;
+}
+
+static struct of_dma_filter_info cpp41_dma_info = {
+	.filter_fn = cpp41_dma_filter_fn,
+};
+
+static struct dma_chan *cppi41_dma_xlate(struct of_phandle_args *dma_spec,
+		struct of_dma *ofdma)
+{
+	int count = dma_spec->args_count;
+	struct of_dma_filter_info *info = ofdma->of_dma_data;
+
+	if (!info || !info->filter_fn)
+		return NULL;
+
+	if (count != 2)
+		return NULL;
+
+	return dma_request_channel(info->dma_cap, info->filter_fn,
+			&dma_spec->args[0]);
+}
+
+static const struct cppi_glue_infos usb_infos = {
+	.isr = cppi41_irq,
+	.queues_rx = usb_queues_rx,
+	.queues_tx = usb_queues_tx,
+};
+
+static const struct of_device_id cppi41_dma_ids[] = {
+	{ .compatible = "ti,am3359-cppi41", .data = &usb_infos},
+	{},
+};
+MODULE_DEVICE_TABLE(of, cppi41_dma_ids);
+
+static const struct cppi_glue_infos *get_glue_info(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id;
+
+	of_id = of_match_node(cppi41_dma_ids, pdev->dev.of_node);
+	if (!of_id)
+		return NULL;
+	return of_id->data;
+}
+
+static int cppi41_dma_probe(struct platform_device *pdev)
+{
+	struct cppi41_dd *cdd;
+	const struct cppi_glue_infos *glue_info;
+	int irq;
+	int ret;
+
+	glue_info = get_glue_info(pdev);
+	if (!glue_info)
+		return -EINVAL;
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
+	cdd->queues_rx = glue_info->queues_rx;
+	cdd->queues_tx = glue_info->queues_tx;
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
+	ret = request_irq(irq, glue_info->isr, IRQF_SHARED,
+			dev_name(&pdev->dev), cdd);
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
+MODULE_AUTHOR("Sebastian Andrzej Siewior <bigeasy@linutronix.de>");
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index b7257ae..04658d7 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -129,6 +129,10 @@ config USB_TI_CPPI_DMA
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
index 52f552c..c5ea5c6 100644
--- a/drivers/usb/musb/Makefile
+++ b/drivers/usb/musb/Makefile
@@ -32,3 +32,4 @@ musb_hdrc-$(CONFIG_USB_INVENTRA_DMA)		+= musbhsdma.o
 musb_hdrc-$(CONFIG_USB_TI_CPPI_DMA)		+= cppi_dma.o
 musb_hdrc-$(CONFIG_USB_TUSB_OMAP_DMA)		+= tusb6010_omap.o
 musb_hdrc-$(CONFIG_USB_UX500_DMA)		+= ux500_dma.o
+musb_hdrc-$(CONFIG_USB_TI_CPPI41_DMA)		+= musb_cppi41.o
diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
new file mode 100644
index 0000000..2b66204
--- /dev/null
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -0,0 +1,433 @@
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/sizes.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+
+#include "musb_core.h"
+
+#define RNDIS_REG(x) (0x80 + ((x - 1) * 4))
+
+#define EP_MODE_AUTOREG_NONE		0
+#define EP_MODE_AUTOREG_ALL_NEOP	1
+#define EP_MODE_AUTOREG_ALWAYS		3
+
+#define EP_MODE_DMA_TRANSPARENT		0
+#define EP_MODE_DMA_RNDIS		1
+#define EP_MODE_DMA_GEN_RNDIS		3
+
+#define USB_CTRL_TX_MODE	0x70
+#define USB_CTRL_RX_MODE	0x74
+#define USB_CTRL_AUTOREQ	0xd0
+
+struct cppi41_dma_channel {
+	struct dma_channel channel;
+	struct cppi41_dma_controller *controller;
+	struct musb_hw_ep *hw_ep;
+	struct dma_chan *dc;
+	struct dma_async_tx_descriptor *desc;
+	dma_cookie_t cookie;
+	u8 port_num;
+	u8 is_tx;
+	u8 is_allocated;
+
+	dma_addr_t buf_addr;
+	u32 total_len;
+	u32 transfered;
+	u32 packet_sz;
+};
+
+#define MUSB_DMA_NUM_CHANNELS 15
+
+struct cppi41_dma_controller {
+	struct dma_controller controller;
+	struct cppi41_dma_channel rx_channel[MUSB_DMA_NUM_CHANNELS];
+	struct cppi41_dma_channel tx_channel[MUSB_DMA_NUM_CHANNELS];
+	struct musb *musb;
+	u32 rx_mode;
+	u32 tx_mode;
+	u32 auto_req;
+};
+
+static void cppi41_dma_callback(void *private_data)
+{
+	struct dma_channel *channel = private_data;
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
+	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
+	struct musb *musb = hw_ep->musb;
+	struct dma_async_tx_descriptor *dma_desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&musb->lock, flags);
+	dma_desc = cppi41_channel->desc;
+	cppi41_channel->transfered += dma_desc->transfered;
+
+	dev_dbg(musb->controller, "DMA transfer done on hw_ep=%d bytes=%d/%d\n",
+		hw_ep->epnum, cppi41_channel->transfered,
+		cppi41_channel->total_len);
+
+	if (cppi41_channel->transfered == cppi41_channel->total_len ||
+			dma_desc->transfered < cppi41_channel->packet_sz) {
+
+		/* done, complete */
+		cppi41_channel->channel.actual_len = cppi41_channel->transfered;
+		cppi41_channel->channel.status = MUSB_DMA_STATUS_FREE;
+		musb_dma_completion(musb, hw_ep->epnum, cppi41_channel->is_tx);
+	} else {
+		/* next iteration, reload */
+		struct dma_chan *dc = cppi41_channel->dc;
+		enum dma_transfer_direction direction;
+		u16 csr;
+		u32 remain_bytes;
+		void __iomem *epio = cppi41_channel->hw_ep->regs;
+
+		cppi41_channel->buf_addr += cppi41_channel->packet_sz;
+
+		remain_bytes = cppi41_channel->total_len;
+		remain_bytes -= cppi41_channel->transfered;
+		remain_bytes = min(remain_bytes, cppi41_channel->packet_sz);
+
+		direction = cppi41_channel->is_tx ? DMA_MEM_TO_DEV
+			: DMA_DEV_TO_MEM;
+		dma_desc = dmaengine_prep_slave_single(dc,
+				cppi41_channel->buf_addr,
+				remain_bytes,
+				direction,
+				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (WARN_ON(!dma_desc))
+			return;
+		cppi41_channel->desc = dma_desc;
+
+		dma_desc->callback = cppi41_dma_callback;
+		dma_desc->callback_param = channel;
+		cppi41_channel->cookie = dma_desc->tx_submit(dma_desc);
+		dma_async_issue_pending(dc);
+
+		if (!cppi41_channel->is_tx) {
+			csr = musb_readw(epio, MUSB_RXCSR);
+			csr |= MUSB_RXCSR_H_REQPKT;
+			musb_writew(epio, MUSB_RXCSR, csr);
+		}
+	}
+	spin_unlock_irqrestore(&musb->lock, flags);
+}
+
+static u32 update_ep_mode(unsigned ep, unsigned mode, u32 old)
+{
+	unsigned shift;
+
+	shift = (ep - 1) * 2;
+	old &= ~(3 << shift);
+	old |= mode << shift;
+	return old;
+}
+
+static void cppi41_set_dma_mode(struct cppi41_dma_channel *cppi41_channel,
+		unsigned mode)
+{
+	struct cppi41_dma_controller *controller = cppi41_channel->controller;
+	u32 port;
+	u32 new_mode;
+	u32 old_mode;
+
+	if (cppi41_channel->is_tx)
+		old_mode = controller->tx_mode;
+	else
+		old_mode = controller->rx_mode;
+	port = cppi41_channel->port_num;
+	new_mode = update_ep_mode(port, mode, old_mode);
+
+	if (new_mode == old_mode)
+		return;
+	if (cppi41_channel->is_tx) {
+		controller->tx_mode = new_mode;
+		musb_writel(controller->musb->ctrl_base, USB_CTRL_TX_MODE,
+				new_mode);
+	} else {
+		controller->rx_mode = new_mode;
+		musb_writel(controller->musb->ctrl_base, USB_CTRL_RX_MODE,
+				new_mode);
+	}
+}
+
+static void cppi41_set_autoreq_mode(struct cppi41_dma_channel *cppi41_channel,
+		unsigned mode)
+{
+	struct cppi41_dma_controller *controller = cppi41_channel->controller;
+	u32 port;
+	u32 new_mode;
+	u32 old_mode;
+
+	old_mode = controller->auto_req;
+	port = cppi41_channel->port_num;
+	new_mode = update_ep_mode(port, mode, old_mode);
+
+	if (new_mode == old_mode)
+		return;
+	controller->auto_req = new_mode;
+	musb_writel(controller->musb->ctrl_base, USB_CTRL_AUTOREQ, new_mode);
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
+	dev_dbg(musb->controller,
+		"configure ep%d/%x packet_sz=%d, mode=%d, dma_addr=0x%llx, len=%d is_tx=%d\n",
+		cppi41_channel->port_num, RNDIS_REG(cppi41_channel->port_num),
+		packet_sz, mode, (unsigned long long) dma_addr,
+		len, cppi41_channel->is_tx);
+
+	cppi41_channel->buf_addr = dma_addr;
+	cppi41_channel->total_len = len;
+	cppi41_channel->transfered = 0;
+	cppi41_channel->packet_sz = packet_sz;
+#if 0
+	/* RNDIS mode */
+	if (len > packet_sz) {
+		musb_writel(musb->ctrl_base,
+				RNDIS_REG(cppi41_channel->port_num), len);
+		/* gen rndis */
+		cppi41_set_dma_mode(cppi41_channel, EP_MODE_DMA_GEN_RNDIS);
+
+		/* auto req */
+		cppi41_set_autoreq_mode(cppi41_channel,
+				EP_MODE_AUTOREG_ALL_NEOP);
+	} else {
+		musb_writel(musb->ctrl_base,
+				RNDIS_REG(cppi41_channel->port_num), 0);
+		cppi41_set_dma_mode(cppi41_channel, EP_MODE_DMA_TRANSPARENT);
+		cppi41_set_autoreq_mode(cppi41_channel,
+				EP_MODE_AUTOREG_NONE);
+	}
+#else
+	/* fallback mode */
+	cppi41_set_dma_mode(cppi41_channel, EP_MODE_DMA_TRANSPARENT);
+	cppi41_set_autoreq_mode(cppi41_channel, EP_MODE_AUTOREG_NONE);
+	len = min_t(u32, packet_sz, len);
+#endif
+	direction = cppi41_channel->is_tx ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM;
+	dma_desc = dmaengine_prep_slave_single(dc, dma_addr, len, direction,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!dma_desc)
+		return false;
+
+	cppi41_channel->desc = dma_desc;
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
+	u8 ch_num = hw_ep->epnum - 1;
+
+	if (ch_num >= MUSB_DMA_NUM_CHANNELS)
+		return NULL;
+
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
+	return &cppi41_channel->channel;
+}
+
+static void cppi41_dma_channel_release(struct dma_channel *channel)
+{
+	struct cppi41_dma_channel *cppi41_channel = channel->private_data;
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
+	dmaengine_terminate_all(cppi41_channel->dc);
+	cppi41_channel->channel.status = MUSB_DMA_STATUS_FREE;
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
+	if (!musb->controller->of_node) {
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
diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index c8e67fd..1345a4f 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -68,7 +68,7 @@ struct musb_hw_ep;
 #define	is_dma_capable()	(1)
 #endif
 
-#ifdef CONFIG_USB_TI_CPPI_DMA
+#if defined(CONFIG_USB_TI_CPPI_DMA) || defined(CONFIG_USB_TI_CPPI41_DMA)
 #define	is_cppi_enabled()	1
 #else
 #define	is_cppi_enabled()	0
-- 
1.8.3.2

