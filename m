Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbbAULDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:03:19 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:52268 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbbAULCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:02:38 -0500
From: Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ddutile@redhat.com, jcm@redhat.com, patches@apm.com,
        Rameshwar Prasad Sahu <rsahu@apm.com>, Loc Ho <lho@apm.com>
Subject: [PATCH v4 1/3] dmaengine: Add support for APM X-Gene SoC DMA engine driver
Date: Wed, 21 Jan 2015 16:31:09 +0530
Message-Id: <1421838071-7347-2-git-send-email-rsahu@apm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421838071-7347-1-git-send-email-rsahu@apm.com>
References: <1421838071-7347-1-git-send-email-rsahu@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the APM X-Gene SoC DMA engine driver. The APM X-Gene
SoC DMA engine consists of 4 DMA channels for performing DMA operations.
These DMA operations include memory copy and scatter gathering offload.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
---
 drivers/dma/Kconfig     |    8 +
 drivers/dma/Makefile    |    1 +
 drivers/dma/xgene-dma.c | 1566 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1575 insertions(+)
 create mode 100644 drivers/dma/xgene-dma.c

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f2b2c4e..251ce60 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -416,6 +416,14 @@ config NBPFAXI_DMA
 	help
 	  Support for "Type-AXI" NBPF DMA IPs from Renesas

+config XGENE_DMA
+	tristate "APM X-Gene DMA support"
+	depends on ARCH_XGENE
+	select DMA_ENGINE
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
+	help
+	  Enable support for the APM X-Gene SoC DMA engine.
+
 config DMA_ENGINE
 	bool

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 2022b54..0567e69 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -50,3 +50,4 @@ obj-y += xilinx/
 obj-$(CONFIG_INTEL_MIC_X100_DMA) += mic_x100_dma.o
 obj-$(CONFIG_NBPFAXI_DMA) += nbpfaxi.o
 obj-$(CONFIG_DMA_SUN6I) += sun6i-dma.o
+obj-$(CONFIG_XGENE_DMA) += xgene-dma.o
diff --git a/drivers/dma/xgene-dma.c b/drivers/dma/xgene-dma.c
new file mode 100644
index 0000000..3cc622c
--- /dev/null
+++ b/drivers/dma/xgene-dma.c
@@ -0,0 +1,1566 @@
+/* Applied Micro X-Gene SoC DMA engine Driver
+ *
+ * Copyright (c) 2014, Applied Micro Circuits Corporation
+ * Authors: Rameshwar Prasad Sahu <rsahu@apm.com>
+ *	    Loc Ho <lho@apm.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/highmem.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/pm_runtime.h>
+
+#include "dmaengine.h"
+
+/* DMA ring csr registers and bit definations */
+#define RING_CONFIG		0x04
+#define RING_ENABLE		BIT(31)
+#define RING_ID			0x08
+#define RING_ID_SETUP(v)	((v) | BIT(31))
+#define RING_ID_BUF		0x0C
+#define RING_ID_BUF_SETUP(v)	(((v) << 9) | BIT(21))
+#define RING_THRESLD0_SET1	0x30
+#define RING_THRESLD0_SET1_VAL	0X64
+#define RING_THRESLD1_SET1	0x34
+#define RING_THRESLD1_SET1_VAL	0xC8
+#define RING_HYSTERESIS		0x68
+#define RING_HYSTERESIS_VAL	0xFFFFFFFF
+#define RING_STATE		0x6C
+#define RING_STATE_WR_BASE	0x70
+#define RING_NE_INT_MODE	0x017C
+#define RING_NE_INT_MODE_SET(m, v)	\
+	((m) = ((m) & ~BIT(31 - (v))) | BIT(31 - (v)))
+#define RING_NE_INT_MODE_RESET(m, v)	\
+	((m) &= (~BIT(31 - (v))))
+#define RING_CLKEN		0xC208
+#define RING_SRST		0xC200
+#define RING_MEM_RAM_SHUTDOWN	0xD070
+#define RING_BLK_MEM_RDY	0xD074
+#define RING_BLK_MEM_RDY_VAL	0xFFFFFFFF
+#define RING_ID_GET(owner, num)	(((owner) << 6) | (num))
+#define RING_DST_RING_ID(v)	((1 << 10) | (v))
+#define RING_CMD_OFFSET(v)	(((v) << 6) + 0x2C)
+#define RING_NUM_CONFIG		5
+#define RING_QCOHERENT_SET(m)	(((u32 *)(m))[2] |= BIT(4))
+#define RING_ADDRL_SET(m, v)	(((u32 *)(m))[2] |= (((v) >> 8) << 5))
+#define RING_ADDRH_SET(m, v)	(((u32 *)(m))[3] |= ((v) >> 35))
+#define RING_ACCEPTLERR_SET(m)	(((u32 *)(m))[3] |= BIT(19))
+#define RING_SIZE_SET(m, v)	(((u32 *)(m))[3] |= ((v) << 23))
+#define RING_RECOMBBUF_SET(m)	(((u32 *)(m))[3] |= BIT(27))
+#define RING_RECOMTIMEOUTL_SET(m)	\
+	(((u32 *)(m))[3] |= (0x7 << 28))
+#define RINNG_RECOMTIMEOUTH_SET(m)	\
+	(((u32 *)(m))[4] |= 0x3)
+#define RING_SELTHRSH_SET(m)	(((u32 *)(m))[4] |= BIT(3))
+#define RING_TYPE_SET(m, v)	(((u32 *)(m))[4] |= ((v) << 19))
+
+/* DMA device csr registers and bit definitions */
+#define DMA_IPBRR		0x0
+#define DMA_BUS_ID_RD(v)	(((v) >> 12) & 3)
+#define DMA_REV_NO_RD(v)	(((v) >> 14) & 3)
+#define DMA_DEVICE_ID_RD(v)	((v) & 0x00000FFF)
+#define DMA_GCR			0x10
+#define DMA_CH_SETUP(m)		((m) = ((m) & ~0x000FFFFF) | 0x000AAFFF)
+#define DMA_ENABLE(m)		((m) = ((m) & ~BIT(31)) | BIT(31))
+#define DMA_INT			0x70
+#define DMA_INT_MASK		0x74
+#define DMA_INT_ALL_UNMASK	0x0
+#define DMA_INT_MASK_SHIFT	0x14
+#define DMA_RING_INT0_MASK	0x90A0
+#define DMA_RING_INT1_MASK	0x90A8
+#define DMA_RING_INT2_MASK	0x90B0
+#define DMA_RING_INT3_MASK	0x90B8
+#define DMA_RING_INT4_MASK	0x90C0
+#define DMA_CFG_RING_WQ_ASSOC	0x90E0
+#define DMA_WQ_ASSOC_RING_MNGR1	0xFFFFFFFF
+#define DMA_CFG_RING_HOLD	0x90F8
+#define DMA_RING_MNGR1_HOLD_EN	BIT(1)
+#define DMA_MEM_RAM_SHUTDOWN	0xD070
+#define DMA_BLK_MEM_RDY		0xD074
+#define DMA_BLK_MEM_RDY_VAL	0xFFFFFFFF
+
+/* Descriptor ring format */
+#define RING_DESC_UINFO_RD(m)		(u32)((m) & 0xFFFFFFFF)
+#define RING_DESC_UINFO_SET(m, v)	(((u64 *)(m))[0] |= (v))
+#define RING_DESC_ELERR_RD(m)		(((m) >> 46) & 0x3)
+#define RING_DESC_NV_SET(m)		(((u64 *)(m))[0] |= BIT_ULL(50))
+#define RING_DESC_IN_SET(m)		(((u64 *)(m))[0] |= BIT_ULL(55))
+#define RING_DESC_RTYPE_SET(m, v)	(((u64 *)(m))[0] |= ((u64)(v) << 56))
+#define RING_DESC_LERR_RD(m)		(((m) >> 60) & 0x7)
+#define RING_DESC_BUFADDR_SET(m, v)	(((u64 *)(m))[0] |= (v))
+#define RING_DESC_BUFLEN_SET(m, v)	(((u64 *)(m))[0] |= ((u64)(v) << 48))
+#define RING_DESC_C_SET(m)		(((u64 *)(m))[1] |= BIT_ULL(63))
+#define RING_DESC_DR_SET(m)		(((u64 *)(m))[2] |= BIT_ULL(61))
+#define RING_DESC_DST_ADDR_SET(m, v)	(((u64 *)(m))[3] |= (v))
+#define RING_DESC_H0ENQ_NUM_SET(m, v)	(((u64 *)(m))[3] |= ((u64)(v) << 48))
+#define RING_DESC_STATUS(x, y)		(((x) << 4) | (y))
+
+/* Descriptor ring empty s/w signature */
+#define RING_DESC_EMPTY_INDEX		0
+#define RING_DESC_EMPTY_SIGNATURE	~0ULL
+#define RING_DESC_IS_EMPTY(m)		\
+	(((u64 *)(m))[RING_DESC_EMPTY_INDEX] == RING_DESC_EMPTY_SIGNATURE)
+#define RING_DESC_SET_EMPTY(m)		\
+	(((u64 *)(m))[RING_DESC_EMPTY_INDEX] = RING_DESC_EMPTY_SIGNATURE)
+
+/* DMA ring descriptor hex dump */
+#define RING_DESC_ERR_DUMP(desc)	\
+	print_hex_dump(KERN_ERR, "X-Gene DMA: Rx ERR DESC ",	\
+		       DUMP_PREFIX_ADDRESS, 16, 8, (desc), 32, 0)
+
+/* DMA channel configurations */
+#define DMA_MAX_CHANNEL			4
+#define DMA_SLOT_PER_CHANNEL		64
+#define DMA_CHANNEL_BUDGET		1024
+#define DMA_MAX_RING_DESC_CNT_PER_SLOT	32
+#define DMA_MAX_BYTE_CNT		0x4000		/* 16 KB */
+#define DMA_MAX_64B_DESC_BYTE_CNT	0x14000		/* 80KB */
+#define DMA_MAX_MEMCPY_BYTE_CNT		0x140000	/* 1280KB */
+#define DMA_MAX_SG_BYTE_CNT		0x80000		/* 512KB */
+#define DMA_16K_BUFFER_LEN_CODE		0x0
+#define DMA_INVALID_LEN_CODE		0x7800
+
+/* DMA ring Configurations */
+#define START_DMA_RING_NUM		512
+#define START_DMA_BUFNUM		0x00
+#define START_CPU_BUFNUM		0x18
+#define RING_OWNER_DMA			0x03
+#define RING_OWNER_CPU			0x0F
+#define RING_TYPE_REGULAR		0x01
+
+/* DMA channel slot flags */
+#define FLAG_SG_ACTIVE			BIT(1)
+#define FLAG_SLOT_IN_USE		BIT(2)
+
+/* DMA ring descriptor error codes */
+#define ERR_DESC_AXI			0x01
+#define ERR_BAD_DESC			0x02
+#define ERR_READ_DATA_AXI		0x03
+#define ERR_WRITE_DATA_AXI		0x04
+#define ERR_FBP_TIMEOUT			0x05
+#define ERR_ECC				0x06
+#define ERR_DIFF_SIZE			0x08
+#define ERR_SCT_GAT_LEN			0x09
+#define ERR_CRC_ERR			0x10
+#define ERR_CHKSUM			0x12
+#define ERR_DIF				0x13
+
+/* DMA error interrupt codes */
+#define ERR_DIF_SIZE_INT		0x0
+#define ERR_GS_ERR_INT			0x1
+#define ERR_FPB_TIMEO_INT		0x2
+#define ERR_WFIFO_OVF_INT		0x3
+#define ERR_RFIFO_OVF_INT		0x4
+#define ERR_WR_TIMEO_INT		0x5
+#define ERR_RD_TIMEO_INT		0x6
+#define ERR_WR_ERR_INT			0x7
+#define ERR_RD_ERR_INT			0x8
+#define ERR_BAD_DESC_INT		0x9
+#define ERR_DESC_DST_INT		0xA
+#define ERR_DESC_SRC_INT		0xB
+
+/* DMA ring descriptor */
+struct xgene_dma_ring_desc {
+	u64 m0;
+	u64 m1;
+	u64 m2;
+	u64 m3;
+};
+
+/* DMA ring configurable size */
+enum xgene_dma_ring_cfgsize {
+	RING_CFG_SIZE_512B,
+	RING_CFG_SIZE_2KB,
+	RING_CFG_SIZE_16KB,
+	RING_CFG_SIZE_64KB,
+	RING_CFG_SIZE_512KB,
+	RING_CFG_SIZE_INVALID
+};
+
+/* DMA ring descriptor */
+struct xgene_dma_ring_info {
+	struct xgene_dma *pdma;
+	u8 buf_num;
+	u16 id;
+	u16 num;
+	u16 head;
+	u16 owner;
+	u16 slots;
+	u32 size;
+	void __iomem *cmd;
+	dma_addr_t desc_paddr;
+	u32 state[RING_NUM_CONFIG];
+	enum xgene_dma_ring_cfgsize cfgsize;
+	union {
+		void *desc_vaddr;
+		struct xgene_dma_ring_desc *desc;
+	};
+};
+
+/* DMA slot descriptor */
+struct xgene_dma_slot {
+	u32 index;
+	u32 flags;
+	u32 status;
+	u32 desc_cnt;
+	struct dma_async_tx_descriptor async_tx;
+
+	/* Shadow copy to use in submit */
+	dma_addr_t dst;
+	dma_addr_t src;
+	size_t len;
+
+	/* Scatter/Gather shadow copy to use in submit */
+	struct scatterlist *srcdst_list;
+	u32 src_nents;
+};
+
+/* DMA channel descriptor */
+struct xgene_dma_chan {
+	struct dma_chan dma_chan;
+	struct xgene_dma *pdma;
+	int index;
+	int rx_irq;
+	int tx_cmd;
+	char name[16];
+	spinlock_t lock;	/* DMA Channel lock */
+	struct xgene_dma_ring_info tx_ring;
+	struct xgene_dma_ring_info rx_ring;
+	struct tasklet_struct rx_tasklet;
+	struct xgene_dma_slot *slots;
+	struct xgene_dma_slot *last_used;
+};
+
+/* DMA device */
+struct xgene_dma {
+	struct device *dev;
+	struct clk *dma_clk;
+	int irq;	/* Error IRQ */
+	int ring_num;
+	void __iomem *csr_dma;
+	void __iomem *csr_ring;
+	void __iomem *csr_ring_cmd;
+	struct dma_device dma_dev;
+	struct xgene_dma_chan channels[DMA_MAX_CHANNEL];
+};
+
+static const char * const xgene_dma_ring_desc_err[] = {
+	[ERR_DESC_AXI] = "AXI error when reading Src/Dst link list",
+	[ERR_BAD_DESC] =
+		"ERR or El_ERR fields not set to zero in the descriptor",
+	[ERR_READ_DATA_AXI] = "AXI error when reading data",
+	[ERR_WRITE_DATA_AXI] = "AXI error when writing data",
+	[ERR_FBP_TIMEOUT] = "Timeout on free pool buffer fetch",
+	[ERR_ECC] = "ECC double bit error",
+	[ERR_DIFF_SIZE] =
+		"Free pool buffer too small to hold all the DIF result",
+	[ERR_SCT_GAT_LEN] =
+		"Gather and scatter don't have the same data length",
+	[ERR_CRC_ERR] = "CRC error",
+	[ERR_CHKSUM] = "Checksum error",
+	[ERR_DIF] = "DIF error",
+};
+
+static const char * const xgene_dma_err[] = {
+	[ERR_DIF_SIZE_INT]  = "DIF size error",
+	[ERR_GS_ERR_INT]    = "Gather scatter not same size error",
+	[ERR_FPB_TIMEO_INT] = "Free pool time out error",
+	[ERR_WFIFO_OVF_INT] = "Write FIFO over flow error",
+	[ERR_RFIFO_OVF_INT] = "Read FIFO over flow error",
+	[ERR_WR_TIMEO_INT]  = "Write time out error",
+	[ERR_RD_TIMEO_INT]  = "Read time out error",
+	[ERR_WR_ERR_INT]    = "HBF bus write error",
+	[ERR_RD_ERR_INT]    = "HBF bus read error",
+	[ERR_BAD_DESC_INT]  = "Ring descriptor HE0 not set error",
+	[ERR_DESC_DST_INT]  = "HFB reading destination link address error",
+	[ERR_DESC_SRC_INT]  = "HFB reading source link address error",
+};
+
+#define to_xgene_dma_chan(chan)		\
+	container_of(chan, struct xgene_dma_chan, dma_chan)
+#define tx_to_xgene_dma_slot(tx)	\
+	container_of(tx, struct xgene_dma_slot, async_tx)
+
+static void xgene_dma_cpu_to_le64(u64 *desc)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		desc[i] = cpu_to_le64(desc[i]);
+}
+
+static u16 xgene_dma_encode_len(u32 len)
+{
+	return ((len < DMA_MAX_BYTE_CNT) ?
+		len : DMA_16K_BUFFER_LEN_CODE);
+}
+
+static u32 xgene_dma_encode_uinfo(struct xgene_dma_slot *slot)
+{
+	return slot->index;
+}
+
+static void *xgene_dma_decode_uinfo(struct xgene_dma_chan *chan,
+				    u32 uinfo)
+{
+	return ((uinfo < DMA_SLOT_PER_CHANNEL) ?
+		&chan->slots[uinfo] : NULL);
+}
+
+static int xgene_dma_process_desc(struct xgene_dma_chan *chan,
+				  struct xgene_dma_ring_desc *desc)
+{
+	struct xgene_dma_slot *slot;
+
+	/* Get the DMA channel slot */
+	slot = xgene_dma_decode_uinfo(chan,
+				      RING_DESC_UINFO_RD(
+				      le64_to_cpu(desc->m0)));
+	if (unlikely(!slot)) {
+		dev_err(chan->pdma->dev,
+			"Channel %d invalid uinfo %d\n",
+			chan->index, RING_DESC_UINFO_RD(le64_to_cpu(desc->m0)));
+		return -EINVAL;
+	}
+
+	if (unlikely(!(slot->flags & FLAG_SLOT_IN_USE)))
+		return -EINVAL;
+
+	/* Check the descriptor if any error */
+	slot->status = RING_DESC_STATUS(
+				RING_DESC_ELERR_RD(le64_to_cpu(desc->m0)),
+				RING_DESC_LERR_RD(le64_to_cpu(desc->m0)));
+	if (slot->status) {
+		dev_err(chan->pdma->dev,
+			"channel %d slot %d %s (tag=%p)\n", chan->index,
+			slot->index, xgene_dma_ring_desc_err[slot->status],
+			slot->async_tx.callback_param);
+		RING_DESC_ERR_DUMP(desc);
+	}
+
+	/* Check whether we have completed all descriptor */
+	if (--slot->desc_cnt == 0) {
+		dma_cookie_complete(&slot->async_tx);
+
+		/* call the client callback function */
+		if (slot->async_tx.callback)
+			slot->async_tx.callback(
+				slot->async_tx.callback_param);
+
+		dma_descriptor_unmap(&slot->async_tx);
+
+		if (slot->flags & FLAG_SG_ACTIVE) {
+			devm_kfree(chan->pdma->dev, slot->srcdst_list);
+			slot->srcdst_list = NULL;
+		}
+
+		slot->flags = 0;
+
+		/* run dependent operations */
+		dma_run_dependencies(&slot->async_tx);
+	}
+
+	return 0;
+}
+
+static void xgene_dma_tasklet_cb(unsigned long data)
+{
+	struct xgene_dma_chan *chan = (struct xgene_dma_chan *)data;
+	struct xgene_dma_ring_info *ring = &chan->rx_ring;
+	struct xgene_dma_ring_desc *desc;
+	u32 budget = DMA_CHANNEL_BUDGET;
+	u32 rx_cmd = 0;
+
+	do {
+		/* Get completed descriptor */
+		desc = &ring->desc[ring->head];
+
+		/* Check for completed descriptor */
+		if (unlikely(RING_DESC_IS_EMPTY(desc)))
+			break;
+
+		/* Process completed DMA channel slots */
+		if (xgene_dma_process_desc(chan, desc))
+			break;
+
+		/* Mark descriptor as empty */
+		RING_DESC_SET_EMPTY(desc);
+		ring->head = (ring->head + 1) % ring->slots;
+		--rx_cmd;
+	} while (--budget);
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d processed %d 32B desc Tx ring id 0x%X Rx ring id 0x%X\n",
+		chan->index, rx_cmd, chan->tx_ring.id, ring->id);
+
+	if (likely(rx_cmd))
+		iowrite32(rx_cmd, ring->cmd);
+
+	/* Re-enable DMA channel IRQ */
+	enable_irq(chan->rx_irq);
+}
+
+static irqreturn_t xgene_dma_ring_isr(int irq, void *id)
+{
+	struct xgene_dma_chan *chan = (struct xgene_dma_chan *)id;
+
+	BUG_ON(!chan);
+
+	/* Disable DMA channel IRQ */
+	disable_irq_nosync(chan->rx_irq);
+
+	/* Schedule tasklet */
+	tasklet_schedule(&chan->rx_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static void xgene_dma_write_ring_state(struct xgene_dma_ring_info *ring)
+{
+	int i;
+
+	iowrite32(ring->num, ring->pdma->csr_ring + RING_STATE);
+
+	for (i = 0; i < RING_NUM_CONFIG; i++)
+		iowrite32(ring->state[i], ring->pdma->csr_ring +
+		       RING_STATE_WR_BASE + (i * 4));
+}
+
+static void xgene_dma_clr_ring_state(struct xgene_dma_ring_info *ring)
+{
+	memset(ring->state, 0, sizeof(u32) * RING_NUM_CONFIG);
+	xgene_dma_write_ring_state(ring);
+}
+
+static void xgene_dma_setup_ring(struct xgene_dma_ring_info *ring)
+{
+	void *ring_cfg = ring->state;
+	u64 addr = ring->desc_paddr;
+	void *desc;
+	u32 i, val;
+
+	/* Clear DMA ring state */
+	xgene_dma_clr_ring_state(ring);
+
+	/* Set DMA ring type */
+	RING_TYPE_SET(ring_cfg, RING_TYPE_REGULAR);
+
+	/* Set recombination buffer and timeout value */
+	if (ring->owner == RING_OWNER_DMA) {
+		RING_RECOMBBUF_SET(ring_cfg);
+		RING_RECOMTIMEOUTL_SET(ring_cfg);
+		RINNG_RECOMTIMEOUTH_SET(ring_cfg);
+	}
+
+	/* Initialize DMA ring state */
+	RING_SELTHRSH_SET(ring_cfg);
+	RING_ACCEPTLERR_SET(ring_cfg);
+	RING_QCOHERENT_SET(ring_cfg);
+	RING_ADDRL_SET(ring_cfg, addr);
+	RING_ADDRH_SET(ring_cfg, addr);
+	RING_SIZE_SET(ring_cfg, ring->cfgsize);
+
+	/* Write DMA ring configurations */
+	xgene_dma_write_ring_state(ring);
+
+	/* Set DMA ring id */
+	iowrite32(RING_ID_SETUP(ring->id),
+		  ring->pdma->csr_ring + RING_ID);
+	iowrite32(RING_ID_BUF_SETUP(ring->num),
+		  ring->pdma->csr_ring + RING_ID_BUF);
+
+	ring->slots = ring->size / 32;
+
+	if (ring->owner != RING_OWNER_CPU)
+		return;
+
+	/* Set empty signature to DMA Rx ring descriptors */
+	for (i = 0; i < ring->slots; i++) {
+		desc = &ring->desc[i];
+		RING_DESC_SET_EMPTY(desc);
+	}
+
+	/* Enable DMA Rx ring interrupt */
+	val = ioread32(ring->pdma->csr_ring + RING_NE_INT_MODE);
+	RING_NE_INT_MODE_SET(val, ring->buf_num);
+	iowrite32(val, ring->pdma->csr_ring + RING_NE_INT_MODE);
+}
+
+static void xgene_dma_clear_ring(struct xgene_dma_ring_info *ring)
+{
+	u32 val;
+
+	if (ring->owner == RING_OWNER_CPU) {
+		/* Disable DMA Rx ring interrupt */
+		val = ioread32(ring->pdma->csr_ring + RING_NE_INT_MODE);
+		RING_NE_INT_MODE_RESET(val, ring->buf_num);
+		iowrite32(val, ring->pdma->csr_ring + RING_NE_INT_MODE);
+	}
+
+	/* Clear DMA ring state */
+	iowrite32(RING_ID_SETUP(ring->id), ring->pdma->csr_ring + RING_ID);
+	iowrite32(0, ring->pdma->csr_ring + RING_ID_BUF);
+	xgene_dma_clr_ring_state(ring);
+}
+
+/* Setup DMA ring cmd base address */
+static void xgene_dma_set_ring_cmd(struct xgene_dma_ring_info *ring)
+{
+	ring->cmd = ring->pdma->csr_ring_cmd +
+			RING_CMD_OFFSET((ring->num - START_DMA_RING_NUM));
+}
+
+static int xgene_dma_get_ring_size(struct xgene_dma_chan *chan,
+				   enum xgene_dma_ring_cfgsize cfgsize)
+{
+	int size;
+
+	switch (cfgsize) {
+	case RING_CFG_SIZE_512B:
+		size = 0x200;
+		break;
+	case RING_CFG_SIZE_2KB:
+		size = 0x800;
+		break;
+	case RING_CFG_SIZE_16KB:
+		size = 0x4000;
+		break;
+	case RING_CFG_SIZE_64KB:
+		size = 0x10000;
+		break;
+	case RING_CFG_SIZE_512KB:
+		size = 0x80000;
+		break;
+	default:
+		dev_err(chan->pdma->dev,
+			"Channel %d Unsupported cfg ring size %d\n",
+			chan->index, cfgsize);
+		return -EINVAL;
+	}
+
+	return size;
+}
+
+static void xgene_dma_delete_ring_one(struct xgene_dma_ring_info *ring)
+{
+	/* Clear DMA ring configurations */
+	xgene_dma_clear_ring(ring);
+
+	/* De-allocate DMA ring descriptor */
+	if (ring->desc_vaddr) {
+		dma_free_coherent(ring->pdma->dev, ring->size,
+				  ring->desc_vaddr, ring->desc_paddr);
+		ring->desc_vaddr = NULL;
+	}
+}
+
+static void xgene_dma_delete_chan_rings(struct xgene_dma_chan *chan)
+{
+	xgene_dma_delete_ring_one(&chan->rx_ring);
+	xgene_dma_delete_ring_one(&chan->tx_ring);
+}
+
+static int xgene_dma_create_ring_one(struct xgene_dma_chan *chan,
+				     struct xgene_dma_ring_info *ring,
+				     enum xgene_dma_ring_cfgsize cfgsize)
+{
+	/* Setup DMA ring descriptor variables */
+	ring->pdma = chan->pdma;
+	ring->cfgsize = cfgsize;
+	ring->num = chan->pdma->ring_num++;
+	ring->id = RING_ID_GET(ring->owner, ring->buf_num);
+
+	ring->size = xgene_dma_get_ring_size(chan, cfgsize);
+	if (ring->size <= 0)
+		return ring->size;
+
+	/* Allocate memory for DMA ring descriptor */
+	ring->desc_vaddr = dma_zalloc_coherent(chan->pdma->dev, ring->size,
+					       &ring->desc_paddr, GFP_KERNEL);
+	if (!ring->desc_vaddr) {
+		dev_err(chan->pdma->dev,
+			"Channel %d failed to allocate ring desc\n",
+			chan->index);
+		return -ENOMEM;
+	}
+
+	/* Configure and enable DMA ring */
+	xgene_dma_set_ring_cmd(ring);
+	xgene_dma_setup_ring(ring);
+
+	return 0;
+}
+
+static int xgene_dma_create_chan_rings(struct xgene_dma_chan *chan)
+{
+	struct xgene_dma_ring_info *rx_ring = &chan->rx_ring;
+	struct xgene_dma_ring_info *tx_ring = &chan->tx_ring;
+	int ret;
+
+	/* Create DMA Rx ring descriptor */
+	rx_ring->owner = RING_OWNER_CPU;
+	rx_ring->buf_num = START_CPU_BUFNUM + chan->index;
+
+	ret = xgene_dma_create_ring_one(chan, rx_ring, RING_CFG_SIZE_64KB);
+	if (ret)
+		return ret;
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d Rx ring id 0x%X num %d desc 0x%p\n",
+		chan->index, rx_ring->id, rx_ring->num, rx_ring->desc_vaddr);
+
+	/* Create DMA Tx ring descriptor */
+	tx_ring->owner = RING_OWNER_DMA;
+	tx_ring->buf_num = START_DMA_BUFNUM + chan->index;
+
+	ret = xgene_dma_create_ring_one(chan, tx_ring, RING_CFG_SIZE_64KB);
+	if (ret)
+		goto err;
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d Tx ring id 0x%X num %d desc 0x%p\n",
+		chan->index, tx_ring->id, tx_ring->num, tx_ring->desc_vaddr);
+
+	return ret;
+
+err:
+	/* Delete DMA Rx ring descriptor created for this DMA channel */
+	xgene_dma_delete_ring_one(rx_ring);
+	return ret;
+}
+
+static int xgene_dma_init_rings(struct xgene_dma *pdma)
+{
+	int ret, i, j;
+
+	for (i = 0; i < DMA_MAX_CHANNEL; i++) {
+		ret = xgene_dma_create_chan_rings(&pdma->channels[i]);
+		if (ret)
+			goto err;
+	}
+
+	return ret;
+
+err:
+	/* Delete DMA rings created for other channels */
+	for (j = 0; j < i; j++)
+		xgene_dma_delete_chan_rings(&pdma->channels[j]);
+
+	return ret;
+}
+
+static void xgene_dma_init_hw(struct xgene_dma *pdma)
+{
+	u32 val;
+
+	/*
+	 * Unmask DMA ring overflow, underflow and
+	 * AXI write/read error interrupts
+	 */
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_RING_INT0_MASK);
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_RING_INT1_MASK);
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_RING_INT2_MASK);
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_RING_INT3_MASK);
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_RING_INT4_MASK);
+
+	/* Associate DMA ring to corresponding ring HW */
+	iowrite32(DMA_WQ_ASSOC_RING_MNGR1,
+		  pdma->csr_dma + DMA_CFG_RING_WQ_ASSOC);
+	iowrite32(DMA_RING_MNGR1_HOLD_EN,
+		  pdma->csr_dma + DMA_CFG_RING_HOLD);
+
+	/* Configure and enable DMA channels */
+	val = ioread32(pdma->csr_dma + DMA_GCR);
+	DMA_CH_SETUP(val);
+	DMA_ENABLE(val);
+	iowrite32(val, pdma->csr_dma + DMA_GCR);
+
+	/* Unmask DMA error interrupts */
+	iowrite32(DMA_INT_ALL_UNMASK, pdma->csr_dma + DMA_INT_MASK);
+
+	/* Get DMA id and version info */
+	val = ioread32(pdma->csr_dma + DMA_IPBRR);
+
+	/* DMA device info */
+	dev_info(pdma->dev,
+		 "X-Gene DMA v%d.%02d.%02d driver registered %d channels",
+		 DMA_REV_NO_RD(val), DMA_BUS_ID_RD(val),
+		 DMA_DEVICE_ID_RD(val), DMA_MAX_CHANNEL);
+}
+
+int xgene_dma_init_ring_mgr(struct xgene_dma *pdma)
+{
+	if (ioread32(pdma->csr_ring + RING_CLKEN) &&
+	    (!ioread32(pdma->csr_ring + RING_SRST)))
+		return 0;
+
+	iowrite32(0x3, pdma->csr_ring + RING_CLKEN);
+	iowrite32(0x0, pdma->csr_ring + RING_SRST);
+
+	/* Bring up memory */
+	iowrite32(0x0, pdma->csr_ring + RING_MEM_RAM_SHUTDOWN);
+
+	/* Force a barrier */
+	ioread32(pdma->csr_ring + RING_MEM_RAM_SHUTDOWN);
+
+	/* reset may take up to 1ms */
+	usleep_range(1000, 1100);
+
+	if (ioread32(pdma->csr_ring + RING_BLK_MEM_RDY)
+		!= RING_BLK_MEM_RDY_VAL) {
+		dev_err(pdma->dev,
+			"failed to release memory from shutdown\n");
+		return -ENODEV;
+	}
+
+	/* program threshold set 1 and all hysteresis */
+	iowrite32(RING_THRESLD0_SET1_VAL,
+		  pdma->csr_ring + RING_THRESLD0_SET1);
+	iowrite32(RING_THRESLD1_SET1_VAL,
+		  pdma->csr_ring + RING_THRESLD1_SET1);
+	iowrite32(RING_HYSTERESIS_VAL,
+		  pdma->csr_ring + RING_HYSTERESIS);
+
+	/* Enable QPcore and assign error queue */
+	iowrite32(RING_ENABLE, pdma->csr_ring + RING_CONFIG);
+
+	return 0;
+}
+
+static int xgene_dma_init_mem(struct xgene_dma *pdma)
+{
+	int ret;
+
+	ret = xgene_dma_init_ring_mgr(pdma);
+	if (ret)
+		return ret;
+
+	/* Bring up memory */
+	iowrite32(0x0, pdma->csr_dma + DMA_MEM_RAM_SHUTDOWN);
+
+	/* Force a barrier */
+	ioread32(pdma->csr_dma + DMA_MEM_RAM_SHUTDOWN);
+
+	/* reset may take up to 1ms */
+	usleep_range(1000, 1100);
+
+	if (ioread32(pdma->csr_dma + DMA_BLK_MEM_RDY)
+		!= DMA_BLK_MEM_RDY_VAL) {
+		dev_err(pdma->dev,
+			"failed to release memory from shutdown\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static irqreturn_t xgene_dma_err_isr(int irq, void *id)
+{
+	struct xgene_dma *pdma = (struct xgene_dma *)id;
+	unsigned long int_mask;
+	u32 val, i;
+
+	val = ioread32(pdma->csr_dma + DMA_INT);
+
+	/* Clear DMA interrupts */
+	iowrite32(val, pdma->csr_dma + DMA_INT);
+
+	/* DMA error info */
+	int_mask = val >> DMA_INT_MASK_SHIFT;
+	for_each_set_bit(i, &int_mask, ARRAY_SIZE(xgene_dma_err))
+		dev_err(pdma->dev,
+			"%s Interrupt 0x%08X\n", xgene_dma_err[i], val);
+
+	return IRQ_HANDLED;
+}
+
+static int xgene_dma_alloc_chan_resources(struct dma_chan *channel)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(channel);
+	int i;
+
+	/* Check if we have already allcated resources */
+	if (chan->slots)
+		return DMA_SLOT_PER_CHANNEL;
+
+	spin_lock_bh(&chan->lock);
+
+	chan->slots = devm_kzalloc(chan->pdma->dev,
+				   sizeof(struct xgene_dma_slot) *
+				   DMA_SLOT_PER_CHANNEL, GFP_ATOMIC);
+	if (!chan->slots) {
+		spin_unlock_bh(&chan->lock);
+		dev_err(chan->pdma->dev,
+			"Channel %d failed to allocate memory for resources\n",
+			chan->index);
+		return -ENOMEM;
+	}
+
+	/* Setup DMA channel resources */
+	for (i = 0; i < DMA_SLOT_PER_CHANNEL; i++) {
+		chan->slots[i].index = i;
+		chan->slots[i].flags = 0;
+		chan->slots[i].async_tx.cookie = 0;
+		dma_async_tx_descriptor_init(&chan->slots[i].async_tx, channel);
+	}
+
+	chan->last_used = &chan->slots[0];
+	dma_cookie_init(&chan->dma_chan);
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d allocated %d slot descriptors (size %d) @0x%p\n",
+		chan->index, DMA_SLOT_PER_CHANNEL,
+		(int)sizeof(struct xgene_dma_slot), &chan->slots[0]);
+
+	spin_unlock_bh(&chan->lock);
+
+	return DMA_SLOT_PER_CHANNEL;
+}
+
+static void xgene_dma_free_chan_resources(struct dma_chan *channel)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(channel);
+
+	spin_lock_bh(&chan->lock);
+
+	/* Check if we have already free resources */
+	if (chan->slots)
+		devm_kfree(chan->pdma->dev, chan->slots);
+
+	/* Mark channel resources free */
+	chan->slots = NULL;
+	chan->last_used = NULL;
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d free %d slot descriptors\n",
+		chan->index, DMA_SLOT_PER_CHANNEL);
+
+	spin_unlock_bh(&chan->lock);
+}
+
+static enum dma_status xgene_dma_tx_status(struct dma_chan *channel,
+					   dma_cookie_t cookie,
+					   struct dma_tx_state *txstate)
+{
+	return dma_cookie_status(channel, cookie, txstate);
+}
+
+static void xgene_dma_issue_pending(struct dma_chan *channel)
+{
+	/* Nothing to do */
+}
+
+static struct xgene_dma_slot *xgene_dma_get_channel_slot(
+				struct xgene_dma_chan *chan)
+{
+	struct xgene_dma_slot *slot;
+
+	slot = (chan->last_used ==
+		(&chan->slots[DMA_SLOT_PER_CHANNEL - 1]) ?
+		&chan->slots[0] : (chan->last_used + 1));
+
+	/* Check if slot is already in use */
+	if (slot->flags & FLAG_SLOT_IN_USE) {
+		dev_dbg(chan->pdma->dev,
+			"Channel %d: No Slot\n", chan->index);
+		return NULL;
+	}
+
+	chan->last_used = slot;
+	slot->async_tx.cookie = -EBUSY;
+
+	return slot;
+}
+
+static void xgene_dma_set_src_buffer(void *ext8, size_t *len,
+				     dma_addr_t *paddr)
+{
+	size_t nbytes = ((*len < DMA_MAX_BYTE_CNT) ?
+			*len : DMA_MAX_BYTE_CNT);
+
+	RING_DESC_BUFADDR_SET(ext8, *paddr);
+	RING_DESC_BUFLEN_SET(ext8, xgene_dma_encode_len(*len));
+	*len -= nbytes;
+	*paddr += nbytes;
+}
+
+static void xgene_dma_invalidate_buffer(void *ext8)
+{
+	RING_DESC_BUFLEN_SET(ext8, DMA_INVALID_LEN_CODE);
+}
+
+static void *xgene_dma_lookup_ext8(void *desc, int idx)
+{
+	return ((idx % 2) ? ((u64 *)desc + (idx - 1)) :
+		((u64 *)desc + (idx + 1)));
+}
+
+static void xgene_dma_init_ring_desc(struct xgene_dma_slot *slot,
+				     void *desc, u16 dst_ring_num)
+{
+	RING_DESC_C_SET(desc); /* Coherent IO */
+	RING_DESC_IN_SET(desc);
+	RING_DESC_DR_SET(desc);
+	RING_DESC_RTYPE_SET(desc, RING_OWNER_DMA);
+	RING_DESC_H0ENQ_NUM_SET(desc, dst_ring_num);
+	RING_DESC_UINFO_SET(desc, xgene_dma_encode_uinfo(slot));
+}
+
+static void xgene_dma_prep_desc(struct xgene_dma_chan *chan,
+				struct xgene_dma_slot *slot,
+				dma_addr_t dst, dma_addr_t src,
+				size_t len)
+{
+	struct xgene_dma_ring_info *ring = &chan->tx_ring;
+	void *dst_virt, *src_virt;
+	u32 dst_off, src_off;
+	void *desc1, *desc2;
+	int i;
+
+	/*
+	 * Size of the DMA ring descriptor is limited to 32 * 32B
+	 * per DMA channel slot. So software memcpy is used for copy
+	 * operations of rest of the buffer beyond this limit.
+	 */
+	if (chan->tx_cmd >=
+		((len > DMA_MAX_BYTE_CNT) ?
+			(DMA_MAX_RING_DESC_CNT_PER_SLOT - 1) :
+			DMA_MAX_RING_DESC_CNT_PER_SLOT))
+		goto sw_memcpy;
+
+	/* Get DMA ring descriptor */
+	desc1 = &ring->desc[ring->head];
+	ring->head = (ring->head + 1) % ring->slots;
+	memset(desc1, 0, 32);
+
+	/* Initialize DMA ring descriptor */
+	xgene_dma_init_ring_desc(slot, desc1,
+				 RING_DST_RING_ID(chan->rx_ring.num));
+
+	/* Set destination address */
+	RING_DESC_DST_ADDR_SET(desc1, dst);
+
+	/* Set 1st source address */
+	xgene_dma_set_src_buffer(desc1 + 8, &len, &src);
+
+	if (len <= 0) {
+		desc2 = NULL;
+		chan->tx_cmd++;
+		goto skip_additional_src;
+	}
+
+	/* Get next DMA ring descriptor */
+	desc2 = &ring->desc[ring->head];
+	ring->head = (ring->head + 1) % ring->slots;
+	memset(desc2, 0, 32);
+
+	RING_DESC_NV_SET(desc1);
+	chan->tx_cmd += 2;
+
+	/* Set 2nd to 5th source address */
+	for (i = 0; i < 4 && len; i++)
+		xgene_dma_set_src_buffer(xgene_dma_lookup_ext8(desc2, i),
+					 &len, &src);
+
+	/* Invalidate unused source address field */
+	for (; i < 4; i++)
+		xgene_dma_invalidate_buffer(xgene_dma_lookup_ext8(desc2, i));
+
+skip_additional_src:
+	slot->desc_cnt++;
+
+	/* Hardware stores descriptor in little endian format */
+	xgene_dma_cpu_to_le64(desc1);
+	if (desc2)
+		xgene_dma_cpu_to_le64(desc2);
+
+	return;
+
+sw_memcpy:
+	dev_dbg(chan->pdma->dev,
+		"Out of ring descriptor, so using sw memcpy\n");
+	dev_dbg(chan->pdma->dev,
+		"dst 0x%llX src 0x%llX len 0x%zX\n", dst, src, len);
+
+	dst_virt = kmap_atomic(phys_to_page(dst));
+	src_virt = kmap_atomic(phys_to_page(src));
+
+	dst_off = dst & ~PAGE_MASK;
+	src_off = src & ~PAGE_MASK;
+
+	memcpy(dst_virt + dst_off, src_virt + src_off, len);
+
+	kunmap_atomic(dst_virt);
+	kunmap_atomic(src_virt);
+}
+
+static dma_cookie_t xgene_dma_tx_memcpy_submit(
+	struct dma_async_tx_descriptor *tx)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(tx->chan);
+	struct xgene_dma_slot *slot = tx_to_xgene_dma_slot(tx);
+	dma_addr_t dst = slot->dst;
+	dma_addr_t src = slot->src;
+	size_t len = slot->len;
+	size_t copy;
+	dma_cookie_t cookie;
+
+	spin_lock_bh(&chan->lock);
+
+	chan->tx_cmd = 0;
+	slot->desc_cnt = 0;
+
+	/* Run until we are out of length */
+	do {
+		/* Create the largest transaction possible */
+		copy = min_t(size_t, len, DMA_MAX_64B_DESC_BYTE_CNT);
+
+		/* Prepare DMA descriptor */
+		xgene_dma_prep_desc(chan, slot, dst, src, copy);
+
+		/* Update metadata */
+		dst += copy;
+		src += copy;
+		len -= copy;
+	} while (len);
+
+	cookie = dma_cookie_assign(tx);
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d issuing op cmd %d Tx ring id 0x%X Rx ring id 0x%X\n",
+		chan->index, chan->tx_cmd, chan->tx_ring.id, chan->rx_ring.id);
+
+	iowrite32(chan->tx_cmd, chan->tx_ring.cmd);
+
+	spin_unlock_bh(&chan->lock);
+
+	return cookie;
+}
+
+static struct dma_async_tx_descriptor *xgene_dma_prep_memcpy(
+	struct dma_chan *channel, dma_addr_t dst, dma_addr_t src,
+	size_t len, unsigned long flags)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(channel);
+	struct xgene_dma_slot *slot;
+
+	/* Sanity check */
+	BUG_ON(len > DMA_MAX_MEMCPY_BYTE_CNT);
+
+	spin_lock_bh(&chan->lock);
+
+	slot = xgene_dma_get_channel_slot(chan);
+	if (!slot) {
+		spin_unlock_bh(&chan->lock);
+		return NULL;
+	}
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d slot %d len 0x%zX dst 0x%llX src 0x%llX\n",
+		chan->index, slot->index, len, dst, src);
+
+	/* Setup slot variables */
+	slot->flags = FLAG_SLOT_IN_USE;
+	slot->async_tx.flags = flags;
+	slot->async_tx.tx_submit = xgene_dma_tx_memcpy_submit;
+
+	/*
+	 * Due to the race in tx_submit call from the client,
+	 * need to serialize the submission of H/W DMA descriptors.
+	 * So make shadow copy to prepare DMA descriptor during
+	 * tx_submit call.
+	 */
+	slot->dst = dst;
+	slot->src = src;
+	slot->len = len;
+
+	spin_unlock_bh(&chan->lock);
+
+	return &slot->async_tx;
+}
+
+static dma_cookie_t xgene_dma_tx_sgcpy_submit(
+	struct dma_async_tx_descriptor *tx)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(tx->chan);
+	struct xgene_dma_slot *slot = tx_to_xgene_dma_slot(tx);
+	struct scatterlist *dst_sg, *src_sg;
+	size_t dst_avail, src_avail;
+	dma_addr_t dst, src;
+	size_t len;
+	dma_cookie_t cookie;
+	size_t nbytes  = slot->len;
+
+	spin_lock_bh(&chan->lock);
+
+	dst_sg = slot->srcdst_list + slot->src_nents;
+	src_sg = slot->srcdst_list;
+
+	chan->tx_cmd = 0;
+	slot->desc_cnt = 0;
+
+	/* Get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
+
+	/* Run until we are out of length */
+	do {
+		/* Create the largest transaction possible */
+		len = min_t(size_t, src_avail, dst_avail);
+		len = min_t(size_t, len, DMA_MAX_64B_DESC_BYTE_CNT);
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
+
+		/* Prepare DMA descriptor */
+		xgene_dma_prep_desc(chan, slot, dst, src, len);
+
+		/* Update metadata */
+		dst_avail -= len;
+		src_avail -= len;
+		nbytes -= len;
+
+fetch:
+		/* Fetch the next dst scatterlist entry */
+		if (dst_avail == 0 && nbytes > 0) {
+			dst_sg = sg_next(dst_sg);
+			BUG_ON(!dst_sg);
+			dst_avail = sg_dma_len(dst_sg);
+		}
+
+		/* Fetch the next src scatterlist entry */
+		if (src_avail == 0 && nbytes > 0) {
+			src_sg = sg_next(src_sg);
+			BUG_ON(!src_sg);
+			src_avail = sg_dma_len(src_sg);
+		}
+	} while (nbytes > 0);
+
+	cookie = dma_cookie_assign(tx);
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d issuing op cmd %d Tx ring id 0x%X Rx ring id 0x%X\n",
+		chan->index, chan->tx_cmd, chan->tx_ring.id, chan->rx_ring.id);
+
+	iowrite32(chan->tx_cmd, chan->tx_ring.cmd);
+
+	spin_unlock_bh(&chan->lock);
+
+	return cookie;
+}
+
+static struct dma_async_tx_descriptor *xgene_dma_prep_sg(
+	struct dma_chan *channel, struct scatterlist *dst_sg,
+	u32 dst_nents, struct scatterlist *src_sg, u32 src_nents,
+	unsigned long flags)
+{
+	struct xgene_dma_chan *chan = to_xgene_dma_chan(channel);
+	struct xgene_dma_slot *slot;
+	struct scatterlist *srcdst_list, *sg;
+	u32 dst_len = 0;
+	u32 src_len = 0;
+	int i;
+
+	/* Sanity checks */
+	BUG_ON(dst_nents == 0 || src_nents == 0);
+	BUG_ON(!dst_sg || !src_sg);
+
+	for_each_sg(dst_sg, sg, dst_nents, i)
+		dst_len += sg_dma_len(sg);
+
+	for_each_sg(src_sg, sg, src_nents, i)
+		src_len += sg_dma_len(sg);
+
+	BUG_ON(dst_len != src_len);
+	BUG_ON(dst_len > DMA_MAX_SG_BYTE_CNT);
+
+	srcdst_list = devm_kzalloc(chan->pdma->dev,
+				   sizeof(struct scatterlist) *
+				   (dst_nents + src_nents),
+				   GFP_KERNEL);
+	if (!srcdst_list) {
+		dev_err(chan->pdma->dev,
+			"Channel %d failed to allocate memory for srcdst_list\n",
+			chan->index);
+		return NULL;
+	}
+
+	spin_lock_bh(&chan->lock);
+
+	slot = xgene_dma_get_channel_slot(chan);
+	if (!slot) {
+		spin_unlock_bh(&chan->lock);
+		devm_kfree(chan->pdma->dev, srcdst_list);
+		return NULL;
+	}
+
+	dev_dbg(chan->pdma->dev,
+		"Channel %d slot %d dst_nents %d src_nents %d len 0x%X\n",
+		chan->index, slot->index, dst_nents, src_nents, dst_len);
+
+	/* Setup slot variables */
+	slot->flags =  FLAG_SLOT_IN_USE | FLAG_SG_ACTIVE;
+	slot->async_tx.flags = flags;
+	slot->async_tx.tx_submit = xgene_dma_tx_sgcpy_submit;
+
+	/*
+	 * Due to the race in tx_submit call from the client,
+	 * need to serialize the submission of H/W DMA descriptors.
+	 * So make shadow copy to prepare DMA descriptor during
+	 * tx_submit call.
+	 */
+	memcpy(srcdst_list, src_sg,
+	       src_nents * sizeof(struct scatterlist));
+	memcpy(srcdst_list + src_nents, dst_sg,
+	       dst_nents * sizeof(struct scatterlist));
+	slot->srcdst_list = srcdst_list;
+	slot->src_nents = src_nents;
+	slot->len = dst_len;
+
+	spin_unlock_bh(&chan->lock);
+
+	return &slot->async_tx;
+}
+
+static void xgene_dma_channels_init(struct xgene_dma *pdma)
+{
+	struct xgene_dma_chan *chan;
+	int i;
+
+	pdma->ring_num = START_DMA_RING_NUM;
+
+	for (i = 0; i < DMA_MAX_CHANNEL; i++) {
+		chan = &pdma->channels[i];
+		chan->pdma = pdma;
+		chan->index = i;
+		chan->slots = NULL;
+		spin_lock_init(&chan->lock);
+		tasklet_init(&chan->rx_tasklet, xgene_dma_tasklet_cb,
+			     (unsigned long)chan);
+	}
+}
+
+static int xgene_dma_async_init(struct xgene_dma *pdma)
+{
+	struct dma_device *dma_dev = &pdma->dma_dev;
+	struct xgene_dma_chan *chan;
+	int i, ret;
+
+	/* Initialize DMA device list head */
+	INIT_LIST_HEAD(&dma_dev->channels);
+
+	/* Initialize DMA device capability mask */
+	dma_cap_zero(dma_dev->cap_mask);
+
+	/* Set DMA device capability */
+	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
+	dma_cap_set(DMA_SG, dma_dev->cap_mask);
+
+	for (i = 0; i < DMA_MAX_CHANNEL; i++) {
+		chan = &pdma->channels[i];
+		chan->dma_chan.device = dma_dev;
+		list_add_tail(&chan->dma_chan.device_node, &dma_dev->channels);
+		sprintf(chan->name, "DMA%d", chan->index);
+
+		ret = devm_request_irq(chan->pdma->dev, chan->rx_irq,
+				       xgene_dma_ring_isr, 0, chan->name, chan);
+		if (ret) {
+			dev_err(chan->pdma->dev,
+				"Channel %d failed to register Rx IRQ %d\n",
+				chan->index, chan->rx_irq);
+			return ret;
+		}
+	}
+
+	/* Set base and prep routines */
+	dma_dev->dev = chan->pdma->dev;
+	dma_dev->device_alloc_chan_resources = xgene_dma_alloc_chan_resources;
+	dma_dev->device_free_chan_resources = xgene_dma_free_chan_resources;
+	dma_dev->device_issue_pending = xgene_dma_issue_pending;
+	dma_dev->device_tx_status = xgene_dma_tx_status;
+
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_memcpy = xgene_dma_prep_memcpy;
+
+	if (dma_has_cap(DMA_SG, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_sg = xgene_dma_prep_sg;
+
+	/* Register with Linux async DMA framework*/
+	ret = dma_async_device_register(dma_dev);
+	if (ret) {
+		dev_err(pdma->dev,
+			"Failed to register async DMA %d", ret);
+		return ret;
+	}
+
+	/* DMA capability info */
+	dev_info(pdma->dev, "CAPABILITY (%s, %s)\n",
+		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ?
+		 "MEMCPY" : "", dma_has_cap(DMA_SG, dma_dev->cap_mask) ?
+		 "Scatter/Gather" : "");
+
+	return 0;
+}
+
+static int xgene_dma_get_resources(struct platform_device *pdev,
+				   struct xgene_dma *pdma)
+{
+	struct resource *res;
+	int irq, i;
+
+	/* Get DMA csr region */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dma_csr");
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get DMA csr region\n");
+		return -ENXIO;
+	}
+	pdma->csr_dma = devm_ioremap(&pdev->dev, res->start,
+				     resource_size(res));
+	if (IS_ERR(pdma->csr_dma)) {
+		dev_err(&pdev->dev, "Failed to ioremap DMA csr region");
+		return PTR_ERR(pdma->csr_dma);
+	}
+
+	/* Get DMA ring csr region */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ring_csr");
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get DMA ring csr region\n");
+		return -ENXIO;
+	}
+	pdma->csr_ring =  devm_ioremap(&pdev->dev, res->start,
+				       resource_size(res));
+	if (IS_ERR(pdma->csr_ring)) {
+		dev_err(&pdev->dev, "Failed to ioremap DMA ring csr region");
+		return PTR_ERR(pdma->csr_ring);
+	}
+
+	/* Get DMA ring cmd csr region */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ring_cmd");
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get DMA ring cmd csr region\n");
+		return -ENXIO;
+	}
+	pdma->csr_ring_cmd = devm_ioremap(&pdev->dev, res->start,
+				     resource_size(res));
+	if (IS_ERR(pdma->csr_ring_cmd)) {
+		dev_err(&pdev->dev, "Failed to ioremap DMA ring cmd csr region");
+		return PTR_ERR(pdma->csr_ring_cmd);
+	}
+
+	/* Get DMA error interrupt */
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev, "Failed to get DMA Error IRQ\n");
+		return -ENXIO;
+	}
+	pdma->irq = irq;
+
+	/* Get DMA Rx ring descriptor interrupts for all DMA channels */
+	for (i = 1; i <= DMA_MAX_CHANNEL; i++) {
+		irq = platform_get_irq(pdev, i);
+		if (irq <= 0) {
+			dev_err(&pdev->dev,
+				"Channel %d Failed to get DMA Rx IRQ\n",
+				(i - 1));
+			return -ENXIO;
+		}
+		pdma->channels[i - 1].rx_irq = irq;
+	}
+
+	return 0;
+}
+
+static int xgene_dma_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct xgene_dma *pdma = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(pdma->dma_clk);
+
+	return 0;
+}
+
+static int xgene_dma_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct xgene_dma *pdma = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = clk_prepare_enable(pdma->dma_clk);
+	if (ret) {
+		dev_err(dev, "Failed to enable clk %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int xgene_dma_probe(struct platform_device *pdev)
+{
+	struct xgene_dma *pdma;
+	int ret;
+
+	/* Allocate memory to DMA device */
+	pdma = devm_kzalloc(&pdev->dev, sizeof(*pdma), GFP_KERNEL);
+	if (!pdma)
+		return -ENOMEM;
+
+	pdma->dev = &pdev->dev;
+	platform_set_drvdata(pdev, pdma);
+
+	/* Get all DMA device resources */
+	ret = xgene_dma_get_resources(pdev, pdma);
+	if (ret)
+		return ret;
+
+	/* Get DMA clk */
+	pdma->dma_clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pdma->dma_clk)) {
+		dev_err(&pdev->dev, "Failed to get DMA clk\n");
+		return PTR_ERR(pdma->dma_clk);
+	}
+
+	/* Setup runtime resume and suspend */
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		ret = xgene_dma_runtime_resume(&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to resume at runtime %d\n", ret);
+			goto err_rt_resume;
+		}
+	}
+
+	/* Enable clk before accessing registers */
+	ret = clk_prepare_enable(pdma->dma_clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to enable clk %d\n", ret);
+		goto err_pm_enable;
+	}
+
+	/* Remove DMA RAM out of shutdown */
+	ret = xgene_dma_init_mem(pdma);
+	if (ret)
+		goto err_pm_enable;
+
+	/* Register IRQ for DMA error */
+	ret = devm_request_irq(&pdev->dev, pdma->irq, xgene_dma_err_isr,
+			       0, "DMA", pdma);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to register DMA error IRQ %d\n", pdma->irq);
+		goto err_pm_enable;
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(42));
+	if (ret) {
+		dev_err(&pdev->dev, "No usable DMA configuration\n");
+		goto err_pm_enable;
+	}
+
+	/* Initialize DMA channels software state */
+	xgene_dma_channels_init(pdma);
+
+	/* Configue DMA ring descriptors */
+	ret = xgene_dma_init_rings(pdma);
+	if (ret)
+		goto err_pm_enable;
+
+	/* Register DMA device with linux async framework */
+	ret = xgene_dma_async_init(pdma);
+	if (ret)
+		goto err_pm_enable;
+
+	/* Configure and enable DMA engine */
+	xgene_dma_init_hw(pdma);
+
+	return 0;
+
+err_pm_enable:
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		xgene_dma_runtime_suspend(&pdev->dev);
+
+err_rt_resume:
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
+}
+
+static int xgene_dma_remove(struct platform_device *pdev)
+{
+	struct xgene_dma *pdma = platform_get_drvdata(pdev);
+	struct xgene_dma_chan *chan;
+	int i;
+
+	for (i = 0; i < DMA_MAX_CHANNEL; i++) {
+		chan = &pdma->channels[i];
+
+		/* Delete DMA ring descriptors */
+		xgene_dma_delete_chan_rings(chan);
+
+		/* Kill the DMA channel tasklet */
+		tasklet_kill(&chan->rx_tasklet);
+	}
+
+	/* Unregister DMA device */
+	dma_async_device_unregister(&pdma->dma_dev);
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		xgene_dma_runtime_suspend(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id xgene_dma_of_match_ptr[] = {
+	{.compatible = "apm,xgene-dma",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, xgene_dma_of_match_ptr);
+
+static const struct dev_pm_ops xgene_dma_pm_ops = {
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_suspend = xgene_dma_runtime_suspend,
+	.runtime_resume = xgene_dma_runtime_resume,
+#endif
+};
+
+static struct platform_driver xgene_dma_driver = {
+	.probe = xgene_dma_probe,
+	.remove = xgene_dma_remove,
+	.driver = {
+		.name = "X-Gene-DMA",
+		.owner = THIS_MODULE,
+		.pm = &xgene_dma_pm_ops,
+		.of_match_table = xgene_dma_of_match_ptr,
+	},
+};
+
+module_platform_driver(xgene_dma_driver);
+
+MODULE_DESCRIPTION("APM X-Gene SoC DMA driver");
+MODULE_AUTHOR("Rameshwar Prasad Sahu <rsahu@apm.com>");
+MODULE_AUTHOR("Loc Ho <lho@apm.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
--
1.8.2.1

