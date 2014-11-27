Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaK0Kn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:43:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33929 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaK0Kma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:42:30 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@kernel.org>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <arnd@arndb.de>, <vinod.koul@intel.com>,
        <khilman@deeprootsystems.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <chris@printf.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 3/3] ARM: edma: Split up header file to platform_data and API file
Date: Thu, 27 Nov 2014 12:41:31 +0200
Message-ID: <1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/platform_data/ is not a correct place to keep the API
definitions for edma, it is meant to be only for the pdata for the device.
Clean up this by moving the API to include/linux/edma.h

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c                     |   3 +-
 arch/arm/mach-davinci/devices.c            |   1 +
 arch/arm/mach-davinci/include/mach/da8xx.h |   1 +
 drivers/dma/edma.c                         |   2 +-
 include/linux/edma.h                       | 153 +++++++++++++++++++++++++++++
 include/linux/platform_data/edma.h         | 148 ++--------------------------
 sound/soc/davinci/davinci-pcm.h            |   1 +
 7 files changed, 165 insertions(+), 144 deletions(-)
 create mode 100644 include/linux/edma.h

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index bac677e65c76..6c49887d326e 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/edma.h>
 #include <linux/edma-dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_address.h>
@@ -33,8 +34,6 @@
 #include <linux/of_irq.h>
 #include <linux/pm_runtime.h>
 
-#include <linux/platform_data/edma.h>
-
 /* Offsets matching "struct edmacc_param" */
 #define PARM_OPT		0x00
 #define PARM_SRC		0x04
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 6257aa452568..28572ef24d9c 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -23,6 +23,7 @@
 #include <linux/platform_data/mmc-davinci.h>
 #include <mach/time.h>
 #include <linux/platform_data/edma.h>
+#include <linux/edma.h>
 
 
 #include "davinci.h"
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index 39e58b48e826..313129cb6f4a 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -23,6 +23,7 @@
 #include <mach/serial.h>
 #include <mach/pm.h>
 #include <linux/platform_data/edma.h>
+#include <linux/edma.h>
 #include <linux/platform_data/i2c-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 8880d6977e5d..126048e79dfc 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -25,7 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/of.h>
 
-#include <linux/platform_data/edma.h>
+#include <linux/edma.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/include/linux/edma.h b/include/linux/edma.h
new file mode 100644
index 000000000000..9df92198c117
--- /dev/null
+++ b/include/linux/edma.h
@@ -0,0 +1,153 @@
+/*
+ * TI EDMA definitions
+ *
+ * Copyright (C) 2006-2013 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * This EDMA3 programming framework exposes two basic kinds of resource:
+ *
+ *  Channel	Triggers transfers, usually from a hardware event but
+ *		also manually or by "chaining" from DMA completions.
+ *		Each channel is coupled to a Parameter RAM (PaRAM) slot.
+ *
+ *  Slot	Each PaRAM slot holds a DMA transfer descriptor (PaRAM
+ *		"set"), source and destination addresses, a link to a
+ *		next PaRAM slot (if any), options for the transfer, and
+ *		instructions for updating those addresses.  There are
+ *		more than twice as many slots as event channels.
+ *
+ * Each PaRAM set describes a sequence of transfers, either for one large
+ * buffer or for several discontiguous smaller buffers.  An EDMA transfer
+ * is driven only from a channel, which performs the transfers specified
+ * in its PaRAM slot until there are no more transfers.  When that last
+ * transfer completes, the "link" field may be used to reload the channel's
+ * PaRAM slot with a new transfer descriptor.
+ *
+ * The EDMA Channel Controller (CC) maps requests from channels into physical
+ * Transfer Controller (TC) requests when the channel triggers (by hardware
+ * or software events, or by chaining).  The two physical DMA channels provided
+ * by the TCs are thus shared by many logical channels.
+ *
+ * DaVinci hardware also has a "QDMA" mechanism which is not currently
+ * supported through this interface.  (DSP firmware uses it though.)
+ */
+
+#ifndef __LINUX_EDMA_H_
+#define __LINUX_EDMA_H_
+
+#include <linux/platform_data/edma.h>
+
+/* PaRAM slots are laid out like this */
+struct edmacc_param {
+	u32 opt;
+	u32 src;
+	u32 a_b_cnt;
+	u32 dst;
+	u32 src_dst_bidx;
+	u32 link_bcntrld;
+	u32 src_dst_cidx;
+	u32 ccnt;
+} __packed;
+
+/* fields in edmacc_param.opt */
+#define SAM		BIT(0)
+#define DAM		BIT(1)
+#define SYNCDIM		BIT(2)
+#define STATIC		BIT(3)
+#define EDMA_FWID	(0x07 << 8)
+#define TCCMODE		BIT(11)
+#define EDMA_TCC(t)	((t) << 12)
+#define TCINTEN		BIT(20)
+#define ITCINTEN	BIT(21)
+#define TCCHEN		BIT(22)
+#define ITCCHEN		BIT(23)
+
+/* ch_status parameter of callback function possible values*/
+#define EDMA_DMA_COMPLETE 1
+#define EDMA_DMA_CC_ERROR 2
+#define EDMA_DMA_TC1_ERROR 3
+#define EDMA_DMA_TC2_ERROR 4
+
+enum address_mode {
+	INCR = 0,
+	FIFO = 1
+};
+
+enum fifo_width {
+	W8BIT = 0,
+	W16BIT = 1,
+	W32BIT = 2,
+	W64BIT = 3,
+	W128BIT = 4,
+	W256BIT = 5
+};
+
+enum sync_dimension {
+	ASYNC = 0,
+	ABSYNC = 1
+};
+
+#define EDMA_CTLR_CHAN(ctlr, chan)	(((ctlr) << 16) | (chan))
+#define EDMA_CTLR(i)			((i) >> 16)
+#define EDMA_CHAN_SLOT(i)		((i) & 0xffff)
+
+#define EDMA_CHANNEL_ANY		-1	/* for edma_alloc_channel() */
+#define EDMA_SLOT_ANY			-1	/* for edma_alloc_slot() */
+#define EDMA_CONT_PARAMS_ANY		 1001
+#define EDMA_CONT_PARAMS_FIXED_EXACT	 1002
+#define EDMA_CONT_PARAMS_FIXED_NOT_EXACT 1003
+
+/* alloc/free DMA channels and their dedicated parameter RAM slots */
+int edma_alloc_channel(int channel,
+		  void (*callback)(unsigned channel, u16 ch_status, void *data),
+		  void *data, enum dma_event_q);
+void edma_free_channel(unsigned channel);
+
+/* alloc/free parameter RAM slots */
+int edma_alloc_slot(unsigned ctlr, int slot);
+void edma_free_slot(unsigned slot);
+
+/* alloc/free a set of contiguous parameter RAM slots */
+int edma_alloc_cont_slots(unsigned ctlr, unsigned int id, int slot, int count);
+int edma_free_cont_slots(unsigned slot, int count);
+
+/* calls that operate on part of a parameter RAM slot */
+void edma_set_src(unsigned slot, dma_addr_t src_port, enum address_mode mode,
+		  enum fifo_width);
+void edma_set_dest(unsigned slot, dma_addr_t dest_port, enum address_mode mode,
+		   enum fifo_width);
+dma_addr_t edma_get_position(unsigned slot, bool dst);
+void edma_set_src_index(unsigned slot, s16 src_bidx, s16 src_cidx);
+void edma_set_dest_index(unsigned slot, s16 dest_bidx, s16 dest_cidx);
+void edma_set_transfer_params(unsigned slot, u16 acnt, u16 bcnt, u16 ccnt,
+			      u16 bcnt_rld, enum sync_dimension sync_mode);
+void edma_link(unsigned from, unsigned to);
+void edma_unlink(unsigned from);
+
+/* calls that operate on an entire parameter RAM slot */
+void edma_write_slot(unsigned slot, const struct edmacc_param *params);
+void edma_read_slot(unsigned slot, struct edmacc_param *params);
+
+/* channel control operations */
+int edma_start(unsigned channel);
+void edma_stop(unsigned channel);
+void edma_clean_channel(unsigned channel);
+void edma_clear_event(unsigned channel);
+void edma_pause(unsigned channel);
+void edma_resume(unsigned channel);
+
+void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no);
+
+int edma_trigger_channel(unsigned);
+
+#endif /* __LINUX_EDMA_H_ */
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index bdb2710e2aab..aaf6fc5769eb 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -8,83 +8,10 @@
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
  */
-
-/*
- * This EDMA3 programming framework exposes two basic kinds of resource:
- *
- *  Channel	Triggers transfers, usually from a hardware event but
- *		also manually or by "chaining" from DMA completions.
- *		Each channel is coupled to a Parameter RAM (PaRAM) slot.
- *
- *  Slot	Each PaRAM slot holds a DMA transfer descriptor (PaRAM
- *		"set"), source and destination addresses, a link to a
- *		next PaRAM slot (if any), options for the transfer, and
- *		instructions for updating those addresses.  There are
- *		more than twice as many slots as event channels.
- *
- * Each PaRAM set describes a sequence of transfers, either for one large
- * buffer or for several discontiguous smaller buffers.  An EDMA transfer
- * is driven only from a channel, which performs the transfers specified
- * in its PaRAM slot until there are no more transfers.  When that last
- * transfer completes, the "link" field may be used to reload the channel's
- * PaRAM slot with a new transfer descriptor.
- *
- * The EDMA Channel Controller (CC) maps requests from channels into physical
- * Transfer Controller (TC) requests when the channel triggers (by hardware
- * or software events, or by chaining).  The two physical DMA channels provided
- * by the TCs are thus shared by many logical channels.
- *
- * DaVinci hardware also has a "QDMA" mechanism which is not currently
- * supported through this interface.  (DSP firmware uses it though.)
- */
-
 #ifndef EDMA_H_
 #define EDMA_H_
 
-/* PaRAM slots are laid out like this */
-struct edmacc_param {
-	u32 opt;
-	u32 src;
-	u32 a_b_cnt;
-	u32 dst;
-	u32 src_dst_bidx;
-	u32 link_bcntrld;
-	u32 src_dst_cidx;
-	u32 ccnt;
-} __packed;
-
-/* fields in edmacc_param.opt */
-#define SAM		BIT(0)
-#define DAM		BIT(1)
-#define SYNCDIM		BIT(2)
-#define STATIC		BIT(3)
-#define EDMA_FWID	(0x07 << 8)
-#define TCCMODE		BIT(11)
-#define EDMA_TCC(t)	((t) << 12)
-#define TCINTEN		BIT(20)
-#define ITCINTEN	BIT(21)
-#define TCCHEN		BIT(22)
-#define ITCCHEN		BIT(23)
-
-/*ch_status paramater of callback function possible values*/
-#define EDMA_DMA_COMPLETE 1
-#define EDMA_DMA_CC_ERROR 2
-#define EDMA_DMA_TC1_ERROR 3
-#define EDMA_DMA_TC2_ERROR 4
-
-enum address_mode {
-	INCR = 0,
-	FIFO = 1
-};
-
-enum fifo_width {
-	W8BIT = 0,
-	W16BIT = 1,
-	W32BIT = 2,
-	W64BIT = 3,
-	W128BIT = 4,
-	W256BIT = 5
-};
+#define EDMA_MAX_CC	2
 
 enum dma_event_q {
 	EVENTQ_0 = 0,
@@ -94,68 +21,9 @@ enum dma_event_q {
 	EVENTQ_DEFAULT = -1
 };
 
-enum sync_dimension {
-	ASYNC = 0,
-	ABSYNC = 1
-};
-
-#define EDMA_CTLR_CHAN(ctlr, chan)	(((ctlr) << 16) | (chan))
-#define EDMA_CTLR(i)			((i) >> 16)
-#define EDMA_CHAN_SLOT(i)		((i) & 0xffff)
-
-#define EDMA_CHANNEL_ANY		-1	/* for edma_alloc_channel() */
-#define EDMA_SLOT_ANY			-1	/* for edma_alloc_slot() */
-#define EDMA_CONT_PARAMS_ANY		 1001
-#define EDMA_CONT_PARAMS_FIXED_EXACT	 1002
-#define EDMA_CONT_PARAMS_FIXED_NOT_EXACT 1003
-
-#define EDMA_MAX_CC               2
-
-/* alloc/free DMA channels and their dedicated parameter RAM slots */
-int edma_alloc_channel(int channel,
-	void (*callback)(unsigned channel, u16 ch_status, void *data),
-	void *data, enum dma_event_q);
-void edma_free_channel(unsigned channel);
-
-/* alloc/free parameter RAM slots */
-int edma_alloc_slot(unsigned ctlr, int slot);
-void edma_free_slot(unsigned slot);
-
-/* alloc/free a set of contiguous parameter RAM slots */
-int edma_alloc_cont_slots(unsigned ctlr, unsigned int id, int slot, int count);
-int edma_free_cont_slots(unsigned slot, int count);
-
-/* calls that operate on part of a parameter RAM slot */
-void edma_set_src(unsigned slot, dma_addr_t src_port,
-				enum address_mode mode, enum fifo_width);
-void edma_set_dest(unsigned slot, dma_addr_t dest_port,
-				 enum address_mode mode, enum fifo_width);
-dma_addr_t edma_get_position(unsigned slot, bool dst);
-void edma_set_src_index(unsigned slot, s16 src_bidx, s16 src_cidx);
-void edma_set_dest_index(unsigned slot, s16 dest_bidx, s16 dest_cidx);
-void edma_set_transfer_params(unsigned slot, u16 acnt, u16 bcnt, u16 ccnt,
-		u16 bcnt_rld, enum sync_dimension sync_mode);
-void edma_link(unsigned from, unsigned to);
-void edma_unlink(unsigned from);
-
-/* calls that operate on an entire parameter RAM slot */
-void edma_write_slot(unsigned slot, const struct edmacc_param *params);
-void edma_read_slot(unsigned slot, struct edmacc_param *params);
-
-/* channel control operations */
-int edma_start(unsigned channel);
-void edma_stop(unsigned channel);
-void edma_clean_channel(unsigned channel);
-void edma_clear_event(unsigned channel);
-void edma_pause(unsigned channel);
-void edma_resume(unsigned channel);
-
-void edma_assign_channel_eventq(unsigned channel, enum dma_event_q eventq_no);
-
 struct edma_rsv_info {
-
-	const s16	(*rsv_chans)[2];
-	const s16	(*rsv_slots)[2];
+	const s16 (*rsv_chans)[2];
+	const s16 (*rsv_slots)[2];
 };
 
 /* platform_data for EDMA driver */
@@ -165,15 +33,13 @@ struct edma_soc_info {
 	 * This way, long transfers on the default queue started
 	 * by the codec engine will not cause audio defects.
 	 */
-	enum dma_event_q	default_queue;
+	enum dma_event_q default_queue;
 
 	/* Resource reservation for other cores */
-	struct edma_rsv_info	*rsv;
+	struct edma_rsv_info *rsv;
 
-	s8	(*queue_priority_mapping)[2];
-	const s16	(*xbar_chans)[2];
+	s8 (*queue_priority_mapping)[2];
+	const s16 (*xbar_chans)[2];
 };
 
-int edma_trigger_channel(unsigned);
-
 #endif
diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-pcm.h
index 0fe2346a9aa2..ddc07de04067 100644
--- a/sound/soc/davinci/davinci-pcm.h
+++ b/sound/soc/davinci/davinci-pcm.h
@@ -15,6 +15,7 @@
 #include <linux/genalloc.h>
 #include <linux/platform_data/davinci_asp.h>
 #include <linux/platform_data/edma.h>
+#include <linux/edma.h>
 
 struct davinci_pcm_dma_params {
 	int channel;			/* sync dma channel ID */
-- 
2.1.3

