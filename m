Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966913Ab3DQP6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:58:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965042Ab3DQP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:58:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] mfd: arizona: Read the device identification information after boot
Date: Wed, 17 Apr 2013 16:58:32 +0100
Message-Id: <1366214315-29032-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130417155815.GA13687@opensource.wolfsonmicro.com>
References: <20130417155815.GA13687@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Future devices may not fully report the device identification information
until their boot sequence is complete so defer acting on these until that
has finished.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   80 +++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 6ab0304..81907f9 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -536,51 +536,22 @@ int arizona_dev_init(struct arizona *arizona)
 
 	regcache_cache_only(arizona->regmap, false);
 
+	/* Verify that this is a chip we know about */
 	ret = regmap_read(arizona->regmap, ARIZONA_SOFTWARE_RESET, &reg);
 	if (ret != 0) {
 		dev_err(dev, "Failed to read ID register: %d\n", ret);
 		goto err_reset;
 	}
 
-	ret = regmap_read(arizona->regmap, ARIZONA_DEVICE_REVISION,
-			  &arizona->rev);
-	if (ret != 0) {
-		dev_err(dev, "Failed to read revision register: %d\n", ret);
-		goto err_reset;
-	}
-	arizona->rev &= ARIZONA_DEVICE_REVISION_MASK;
-
 	switch (reg) {
-#ifdef CONFIG_MFD_WM5102
 	case 0x5102:
-		type_name = "WM5102";
-		if (arizona->type != WM5102) {
-			dev_err(arizona->dev, "WM5102 registered as %d\n",
-				arizona->type);
-			arizona->type = WM5102;
-		}
-		apply_patch = wm5102_patch;
-		arizona->rev &= 0x7;
-		break;
-#endif
-#ifdef CONFIG_MFD_WM5110
 	case 0x5110:
-		type_name = "WM5110";
-		if (arizona->type != WM5110) {
-			dev_err(arizona->dev, "WM5110 registered as %d\n",
-				arizona->type);
-			arizona->type = WM5110;
-		}
-		apply_patch = wm5110_patch;
 		break;
-#endif
 	default:
-		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
+		dev_err(arizona->dev, "Unknown device ID: %x\n", reg);
 		goto err_reset;
 	}
 
-	dev_info(dev, "%s revision %c\n", type_name, arizona->rev + 'A');
-
 	/* If we have a /RESET GPIO we'll already be reset */
 	if (!arizona->pdata.reset) {
 		regcache_mark_dirty(arizona->regmap);
@@ -600,6 +571,7 @@ int arizona_dev_init(struct arizona *arizona)
 		}
 	}
 
+	/* Ensure device startup is complete */
 	switch (arizona->type) {
 	case WM5102:
 		ret = regmap_read(arizona->regmap, 0x19, &val);
@@ -620,6 +592,52 @@ int arizona_dev_init(struct arizona *arizona)
 		break;
 	}
 
+	/* Read the device ID information & do device specific stuff */
+	ret = regmap_read(arizona->regmap, ARIZONA_SOFTWARE_RESET, &reg);
+	if (ret != 0) {
+		dev_err(dev, "Failed to read ID register: %d\n", ret);
+		goto err_reset;
+	}
+
+	ret = regmap_read(arizona->regmap, ARIZONA_DEVICE_REVISION,
+			  &arizona->rev);
+	if (ret != 0) {
+		dev_err(dev, "Failed to read revision register: %d\n", ret);
+		goto err_reset;
+	}
+	arizona->rev &= ARIZONA_DEVICE_REVISION_MASK;
+
+	switch (reg) {
+#ifdef CONFIG_MFD_WM5102
+	case 0x5102:
+		type_name = "WM5102";
+		if (arizona->type != WM5102) {
+			dev_err(arizona->dev, "WM5102 registered as %d\n",
+				arizona->type);
+			arizona->type = WM5102;
+		}
+		apply_patch = wm5102_patch;
+		arizona->rev &= 0x7;
+		break;
+#endif
+#ifdef CONFIG_MFD_WM5110
+	case 0x5110:
+		type_name = "WM5110";
+		if (arizona->type != WM5110) {
+			dev_err(arizona->dev, "WM5110 registered as %d\n",
+				arizona->type);
+			arizona->type = WM5110;
+		}
+		apply_patch = wm5110_patch;
+		break;
+#endif
+	default:
+		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
+		goto err_reset;
+	}
+
+	dev_info(dev, "%s revision %c\n", type_name, arizona->rev + 'A');
+
 	if (apply_patch) {
 		ret = apply_patch(arizona);
 		if (ret != 0) {
-- 
1.7.10.4

