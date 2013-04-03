Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035Ab3DCSGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:06:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53535 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762890Ab3DCSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:05:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: arizona: Hold device in reset while ramping supplies
Date: Wed,  3 Apr 2013 19:05:19 +0100
Message-Id: <1365012321-7673-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130403180423.GA6985@opensource.wolfsonmicro.com>
References: <20130403180423.GA6985@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acquire the /RESET GPIO before we enable regulators and hold the device
in reset while the regulators power up in order to improve robustness
during the initial power up.

Also fix the error path so that the device is left in reset while we're
at it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 26ac372..e4c8dc2 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -494,6 +494,17 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_early;
 	}
 
+	if (arizona->pdata.reset) {
+		/* Start out with /RESET low to put the chip into reset */
+		ret = gpio_request_one(arizona->pdata.reset,
+				       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+				       "arizona /RESET");
+		if (ret != 0) {
+			dev_err(dev, "Failed to request /RESET: %d\n", ret);
+			goto err_early;
+		}
+	}
+
 	ret = regulator_bulk_enable(arizona->num_core_supplies,
 				    arizona->core_supplies);
 	if (ret != 0) {
@@ -508,18 +519,8 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_enable;
 	}
 
-	if (arizona->pdata.reset) {
-		/* Start out with /RESET low to put the chip into reset */
-		ret = gpio_request_one(arizona->pdata.reset,
-				       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
-				       "arizona /RESET");
-		if (ret != 0) {
-			dev_err(dev, "Failed to request /RESET: %d\n", ret);
-			goto err_dcvdd;
-		}
-
+	if (arizona->pdata.reset)
 		gpio_set_value_cansleep(arizona->pdata.reset, 1);
-	}
 
 	regcache_cache_only(arizona->regmap, false);
 
@@ -759,10 +760,9 @@ err_irq:
 	arizona_irq_exit(arizona);
 err_reset:
 	if (arizona->pdata.reset) {
-		gpio_set_value_cansleep(arizona->pdata.reset, 1);
+		gpio_set_value_cansleep(arizona->pdata.reset, 0);
 		gpio_free(arizona->pdata.reset);
 	}
-err_dcvdd:
 	regulator_disable(arizona->dcvdd);
 err_enable:
 	regulator_bulk_disable(arizona->num_core_supplies,
-- 
1.7.10.4

