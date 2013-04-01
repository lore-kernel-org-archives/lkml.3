Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3DAR3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:29:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501Ab3DAR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/15] mfd: wm5102: Manually apply register patch
Date: Mon,  1 Apr 2013 18:28:08 +0100
Message-Id: <1364837292-30191-11-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Future updates will require us to manually apply the register patch for
wm5102.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c  |   10 ++++++++++
 drivers/mfd/wm5102-tables.c |   31 +++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1967a01..4a8093d4 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -256,6 +256,16 @@ static int arizona_runtime_resume(struct device *dev)
 		return ret;
 	}
 
+	switch (arizona->type) {
+	case WM5102:
+		ret = wm5102_patch(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to apply patch: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	ret = regcache_sync(arizona->regmap);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to restore register cache\n");
diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 909e043..44cb7be 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/device.h>
 #include <linux/module.h>
 
 #include <linux/mfd/arizona/core.h>
@@ -77,16 +78,34 @@ static const struct reg_default wm5102_revb_patch[] = {
 /* We use a function so we can use ARRAY_SIZE() */
 int wm5102_patch(struct arizona *arizona)
 {
+	const struct reg_default *wm5102_patch;
+	int ret = 0;
+	int i, patch_size;
+
 	switch (arizona->rev) {
 	case 0:
-		return regmap_register_patch(arizona->regmap,
-					     wm5102_reva_patch,
-					     ARRAY_SIZE(wm5102_reva_patch));
+		wm5102_patch = wm5102_reva_patch;
+		patch_size = ARRAY_SIZE(wm5102_reva_patch);
 	default:
-		return regmap_register_patch(arizona->regmap,
-					     wm5102_revb_patch,
-					     ARRAY_SIZE(wm5102_revb_patch));
+		wm5102_patch = wm5102_revb_patch;
+		patch_size = ARRAY_SIZE(wm5102_revb_patch);
 	}
+
+	regcache_cache_bypass(arizona->regmap, true);
+
+	for (i = 0; i < patch_size; i++) {
+		ret = regmap_write(arizona->regmap, wm5102_patch[i].reg,
+				   wm5102_patch[i].def);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to write %x = %x: %d\n",
+				wm5102_patch[i].reg, wm5102_patch[i].def, ret);
+			goto out;
+		}
+	}
+
+out:
+	regcache_cache_bypass(arizona->regmap, false);
+	return ret;
 }
 
 static const struct regmap_irq wm5102_aod_irqs[ARIZONA_NUM_IRQ] = {
-- 
1.7.10.4

