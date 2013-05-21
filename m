Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3EUSNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46867 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3EUSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:15 -0500
Message-Id: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130521181230.GF1627@sirena.org.uk>
References: <20130521181230.GF1627@sirena.org.uk>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/7] mfd: arizona: Read the device identification information after boot
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
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

