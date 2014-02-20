Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaBTQfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:35:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38573 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaBTQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:35:05 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm5102: Remove cache_bypass from manual register patching
Date: Thu, 20 Feb 2014 16:26:48 +0000
Message-Id: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the wm5102 the register patches are applied manually, rather than by
the regmap core. This application is wrapped in calls to
regcache_cache_bypass. However, this is dangerous as other threads may
be accessing the hardware at the same time as the pm_runtime operations
and if they do so during the period whilst cache_bypass is enabled those
writes will miss the cache when they shouldn't.

As the cache_bypass is not strictly necessary for applying the patches
(the device is always powered on whilst it is applied) remove the calls
to regcache_cache_bypass to avoid this situation.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c  |    4 ----
 drivers/mfd/wm5102-tables.c |   10 +++-------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index a45aab9..1c3ae57 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -251,8 +251,6 @@ static int arizona_apply_hardware_patch(struct arizona* arizona)
 	unsigned int fll, sysclk;
 	int ret, err;
 
-	regcache_cache_bypass(arizona->regmap, true);
-
 	/* Cache existing FLL and SYSCLK settings */
 	ret = regmap_read(arizona->regmap, ARIZONA_FLL1_CONTROL_1, &fll);
 	if (ret != 0) {
@@ -322,8 +320,6 @@ err_fll:
 			err);
 	}
 
-	regcache_cache_bypass(arizona->regmap, false);
-
 	if (ret != 0)
 		return ret;
 	else
diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 187ee86..b9556bc 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -81,7 +81,7 @@ static const struct reg_default wm5102_revb_patch[] = {
 int wm5102_patch(struct arizona *arizona)
 {
 	const struct reg_default *wm5102_patch;
-	int ret = 0;
+	int ret;
 	int i, patch_size;
 
 	switch (arizona->rev) {
@@ -93,21 +93,17 @@ int wm5102_patch(struct arizona *arizona)
 		patch_size = ARRAY_SIZE(wm5102_revb_patch);
 	}
 
-	regcache_cache_bypass(arizona->regmap, true);
-
 	for (i = 0; i < patch_size; i++) {
 		ret = regmap_write(arizona->regmap, wm5102_patch[i].reg,
 				   wm5102_patch[i].def);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to write %x = %x: %d\n",
 				wm5102_patch[i].reg, wm5102_patch[i].def, ret);
-			goto out;
+			return ret;
 		}
 	}
 
-out:
-	regcache_cache_bypass(arizona->regmap, false);
-	return ret;
+	return 0;
 }
 
 static const struct regmap_irq wm5102_aod_irqs[ARIZONA_NUM_IRQ] = {
-- 
1.7.2.5

