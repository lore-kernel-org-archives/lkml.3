Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3J1Wyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:54:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757770Ab3J1Wye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:54:34 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        sachin.kamat@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
Date: Mon, 28 Oct 2013 19:54:15 -0300
Message-Id: <1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite requesting two memory resources, called 'base' and 'high_base', the
driver uses explicitly only the former. The latter is being used implicitly
by addressing at offset +0x200, which in practice accesses high_base.

Instead of relying in such trick, let's define the registers with the
offset from high_base, and use high_base explicitly where appropriate.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/dma/mv_xor.c |  3 ++-
 drivers/dma/mv_xor.h | 25 +++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index d00d58e..c7da545 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1076,6 +1076,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	}
 
 	mv_chan->mmr_base = xordev->xor_base;
+	mv_chan->mmr_high_base = xordev->xor_high_base;
 	tasklet_init(&mv_chan->irq_tasklet, mv_xor_tasklet, (unsigned long)
 		     mv_chan);
 
@@ -1134,7 +1135,7 @@ static void
 mv_xor_conf_mbus_windows(struct mv_xor_device *xordev,
 			 const struct mbus_dram_target_info *dram)
 {
-	void __iomem *base = xordev->xor_base;
+	void __iomem *base = xordev->xor_high_base;
 	u32 win_enable = 0;
 	int i;
 
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 06b067f..d074922 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -34,13 +34,13 @@
 #define XOR_OPERATION_MODE_MEMCPY	2
 #define XOR_DESCRIPTOR_SWAP		BIT(14)
 
-#define XOR_CURR_DESC(chan)	(chan->mmr_base + 0x210 + (chan->idx * 4))
-#define XOR_NEXT_DESC(chan)	(chan->mmr_base + 0x200 + (chan->idx * 4))
-#define XOR_BYTE_COUNT(chan)	(chan->mmr_base + 0x220 + (chan->idx * 4))
-#define XOR_DEST_POINTER(chan)	(chan->mmr_base + 0x2B0 + (chan->idx * 4))
-#define XOR_BLOCK_SIZE(chan)	(chan->mmr_base + 0x2C0 + (chan->idx * 4))
-#define XOR_INIT_VALUE_LOW(chan)	(chan->mmr_base + 0x2E0)
-#define XOR_INIT_VALUE_HIGH(chan)	(chan->mmr_base + 0x2E4)
+#define XOR_CURR_DESC(chan)	(chan->mmr_high_base + 0x10 + (chan->idx * 4))
+#define XOR_NEXT_DESC(chan)	(chan->mmr_high_base + 0x00 + (chan->idx * 4))
+#define XOR_BYTE_COUNT(chan)	(chan->mmr_high_base + 0x20 + (chan->idx * 4))
+#define XOR_DEST_POINTER(chan)	(chan->mmr_high_base + 0xB0 + (chan->idx * 4))
+#define XOR_BLOCK_SIZE(chan)	(chan->mmr_high_base + 0xC0 + (chan->idx * 4))
+#define XOR_INIT_VALUE_LOW(chan)	(chan->mmr_high_base + 0xE0)
+#define XOR_INIT_VALUE_HIGH(chan)	(chan->mmr_high_base + 0xE4)
 
 #define XOR_CONFIG(chan)	(chan->mmr_base + 0x10 + (chan->idx * 4))
 #define XOR_ACTIVATION(chan)	(chan->mmr_base + 0x20 + (chan->idx * 4))
@@ -50,11 +50,11 @@
 #define XOR_ERROR_ADDR(chan)	(chan->mmr_base + 0x60)
 #define XOR_INTR_MASK_VALUE	0x3F5
 
-#define WINDOW_BASE(w)		(0x250 + ((w) << 2))
-#define WINDOW_SIZE(w)		(0x270 + ((w) << 2))
-#define WINDOW_REMAP_HIGH(w)	(0x290 + ((w) << 2))
-#define WINDOW_BAR_ENABLE(chan)	(0x240 + ((chan) << 2))
-#define WINDOW_OVERRIDE_CTRL(chan)	(0x2A0 + ((chan) << 2))
+#define WINDOW_BASE(w)		(0x50 + ((w) << 2))
+#define WINDOW_SIZE(w)		(0x70 + ((w) << 2))
+#define WINDOW_REMAP_HIGH(w)	(0x90 + ((w) << 2))
+#define WINDOW_BAR_ENABLE(chan)	(0x40 + ((chan) << 2))
+#define WINDOW_OVERRIDE_CTRL(chan)	(0xA0 + ((chan) << 2))
 
 struct mv_xor_device {
 	void __iomem	     *xor_base;
@@ -82,6 +82,7 @@ struct mv_xor_chan {
 	int			pending;
 	spinlock_t		lock; /* protects the descriptor slot pool */
 	void __iomem		*mmr_base;
+	void __iomem		*mmr_high_base;
 	unsigned int		idx;
 	int                     irq;
 	enum dma_transaction_type	current_type;
-- 
1.8.1.5

