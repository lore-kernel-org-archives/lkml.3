Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3HVAeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:34:20 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:55518 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3HVAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:34:18 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linus.walleij@linaro.org
Cc: vinod.koul@intel.com, khilman@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: ste_dma: Fix warning when CONFIG_ARM_LPAE=y
Date: Wed, 21 Aug 2013 21:34:02 -0300
Message-Id: <1377131642-19494-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

When CONFIG_ARM_LPAE=y the following build warning are generated:

drivers/dma/ste_dma40.c:3228:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
drivers/dma/ste_dma40.c:3593:5: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]

According to Documentation/printk-formats.txt '%pa' can be used to properly 
print 'resource_size_t'.

Also, for printing memory region the '%pr' is more convenient.

Reported-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/ste_dma40.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0036756..044abe4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3226,8 +3226,8 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
 	dev_info(&pdev->dev,
-		 "hardware rev: %d @ 0x%x with %d physical and %d logical channels\n",
-		 rev, res->start, num_phy_chans, num_log_chans);
+		 "hardware rev: %d @ %pa with %d physical and %d logical channels\n",
+		 rev, &res->start, num_phy_chans, num_log_chans);
 
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
 		       (num_phy_chans + num_log_chans + num_memcpy_chans) *
@@ -3579,9 +3579,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (request_mem_region(res->start, resource_size(res),
 			       D40_NAME " I/O lcpa") == NULL) {
 		ret = -EBUSY;
-		d40_err(&pdev->dev,
-			"Failed to request LCPA region 0x%x-0x%x\n",
-			res->start, res->end);
+		d40_err(&pdev->dev, "Failed to request LCPA region %pR\n", res);
 		goto failure;
 	}
 
@@ -3589,8 +3587,8 @@ static int __init d40_probe(struct platform_device *pdev)
 	val = readl(base->virtbase + D40_DREG_LCPA);
 	if (res->start != val && val != 0) {
 		dev_warn(&pdev->dev,
-			 "[%s] Mismatch LCPA dma 0x%x, def 0x%x\n",
-			 __func__, val, res->start);
+			 "[%s] Mismatch LCPA dma 0x%x, def %pa\n",
+			 __func__, val, &res->start);
 	} else
 		writel(res->start, base->virtbase + D40_DREG_LCPA);
 
-- 
1.8.1.2

