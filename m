Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaFWN1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:27:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaFWNDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 23/93] dma: dw: allow shared interrupts
Date: Mon, 23 Jun 2014 14:02:02 +0100
Message-Id: <1403528592-2163-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 3783cef876e0f24e93a11f1a76cc0b3fe7ea8d94 upstream.

In the PC world is quite possible that devices are sharing the same interrupt
line. The patch prepares dw_dmac driver to such cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/dw/core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index eea479c12173..1292a6eda60f 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -644,10 +644,13 @@ static void dw_dma_tasklet(unsigned long data)
 static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 {
 	struct dw_dma *dw = dev_id;
-	u32 status;
+	u32 status = dma_readl(dw, STATUS_INT);
 
-	dev_vdbg(dw->dma.dev, "%s: status=0x%x\n", __func__,
-			dma_readl(dw, STATUS_INT));
+	dev_vdbg(dw->dma.dev, "%s: status=0x%x\n", __func__, status);
+
+	/* Check if we have any interrupt from the DMAC */
+	if (!status)
+		return IRQ_NONE;
 
 	/*
 	 * Just disable the interrupts. We'll turn them back on in the
@@ -1560,8 +1563,8 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 	/* Disable BLOCK interrupts as well */
 	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 
-	err = devm_request_irq(chip->dev, chip->irq, dw_dma_interrupt, 0,
-			       "dw_dmac", dw);
+	err = devm_request_irq(chip->dev, chip->irq, dw_dma_interrupt,
+			       IRQF_SHARED, "dw_dmac", dw);
 	if (err)
 		return err;
 
-- 
1.9.1

