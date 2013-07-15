Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3GOPwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:52:30 -0400
Received: from smtp-out-191.synserver.de ([212.40.185.191]:1034 "EHLO
	smtp-out-191.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210Ab3GOPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:52:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3256
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] dma: pl330: Implement device_slave_caps
Date: Mon, 15 Jul 2013 17:53:08 +0200
Message-Id: <1373903588-19358-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemnt the device_slave_caps() callback for the pl330 driver. This allows
dmaengine users like the generic ALSA dmaengine PCM driver to query the
capabilities of the driver. The PL330 supports all buswidths and both
mem-to-dev as well as dev-to-mem transfers. In theory there is no limit on the
number of segments that can be transferred (in practice you'll run out of memory
eventually) and the number of bytes per segment is limited by the size of the
PL330 program buffer. Due to the nature of the PL330 the maximum number of bytes
per segment depends on the burstsize, the driver sets it to the value for a
1-byte burstsize, since it is the smallest.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/pl330.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 593827b..2bf578c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2855,6 +2855,32 @@ static irqreturn_t pl330_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 }
 
+#define PL330_DMA_BUSWIDTHS \
+	BIT(DMA_SLAVE_BUSWIDTH_UNDEFINED) | \
+	BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
+	BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
+	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) | \
+	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)
+
+static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
+	struct dma_slave_caps *caps)
+{
+	caps->src_addr_widths = PL330_DMA_BUSWIDTHS;
+	caps->dstn_addr_widths = PL330_DMA_BUSWIDTHS;
+	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	caps->cmd_pause = false;
+	caps->cmd_terminate = true;
+
+	/* 
+	 * This is the limit for transfers with a buswidth of 1, larger buswidths
+	 * will have larger limits.
+	 */
+	caps->max_sg_len = 1900800;
+	caps->max_sg_nr = 0;
+
+	return 0;
+}
+
 static int
 pl330_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2959,6 +2985,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pd->device_prep_slave_sg = pl330_prep_slave_sg;
 	pd->device_control = pl330_control;
 	pd->device_issue_pending = pl330_issue_pending;
+	pd->device_slave_caps = pl330_dma_device_slave_caps;
 
 	ret = dma_async_device_register(pd);
 	if (ret) {
-- 
1.8.0

