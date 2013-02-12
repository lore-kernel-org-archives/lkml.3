Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3BLK7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:59:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:25915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab3BLK7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:59:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="286099336"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/6] edma: do not waste memory for dma_mask
Date: Tue, 12 Feb 2013 12:58:38 +0200
Message-Id: <1360666720-19006-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accordingly to commentary in the platform_device_register_full the memory
allocated for dma_mask will not going to be freed. That's why is better to
assign dma_mask afterwards.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/edma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 06ea4b8..cd7e328 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -620,13 +620,11 @@ static struct platform_device *pdev0, *pdev1;
 static const struct platform_device_info edma_dev_info0 = {
 	.name = "edma-dma-engine",
 	.id = 0,
-	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static const struct platform_device_info edma_dev_info1 = {
 	.name = "edma-dma-engine",
 	.id = 1,
-	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static int edma_init(void)
@@ -640,6 +638,8 @@ static int edma_init(void)
 			ret = PTR_ERR(pdev0);
 			goto out;
 		}
+		pdev0->dev.dma_mask = &pdev0->dev.coherent_dma_mask;
+		pdev0->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 	if (EDMA_CTLRS == 2) {
@@ -649,6 +649,8 @@ static int edma_init(void)
 			platform_device_unregister(pdev0);
 			ret = PTR_ERR(pdev1);
 		}
+		pdev1->dev.dma_mask = &pdev1->dev.coherent_dma_mask;
+		pdev1->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 out:
-- 
1.7.10.4

