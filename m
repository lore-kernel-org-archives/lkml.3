Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaBYNyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:54:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50493 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbaBYNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:54:09 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 4/4] mfd: arizona: Use new regmap features for manual register patch
Date: Tue, 25 Feb 2014 13:45:52 +0000
Message-Id: <1393335952-28490-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the wm5102 the register patches are applied manually, rather than by
the regmap core. This application is wrapped in calls to
regcache_cache_bypass. However, this is dangerous as other threads may
be accessing the hardware at the same time as the pm_runtime operations
and if they do so during the period whilst cache_bypass is enabled those
writes will miss the cache when they shouldn't.

Apply the register patch using the new regmap_multi_reg_write_bypassed
function to avoid this problem. Also remove the call to
regcache_cache_bypass from the hardware patch application as it is
unneeded there and creates a similar window for writes to miss the
cache.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c  |    4 ----
 drivers/mfd/wm5102-tables.c |   21 ++++-----------------
 2 files changed, 4 insertions(+), 21 deletions(-)

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
index 1e9a4b2..bffc584 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -80,8 +80,7 @@ static const struct reg_default wm5102_revb_patch[] = {
 int wm5102_patch(struct arizona *arizona)
 {
 	const struct reg_default *wm5102_patch;
-	int ret = 0;
-	int i, patch_size;
+	int patch_size;
 
 	switch (arizona->rev) {
 	case 0:
@@ -92,21 +91,9 @@ int wm5102_patch(struct arizona *arizona)
 		patch_size = ARRAY_SIZE(wm5102_revb_patch);
 	}
 
-	regcache_cache_bypass(arizona->regmap, true);
-
-	for (i = 0; i < patch_size; i++) {
-		ret = regmap_write(arizona->regmap, wm5102_patch[i].reg,
-				   wm5102_patch[i].def);
-		if (ret != 0) {
-			dev_err(arizona->dev, "Failed to write %x = %x: %d\n",
-				wm5102_patch[i].reg, wm5102_patch[i].def, ret);
-			goto out;
-		}
-	}
-
-out:
-	regcache_cache_bypass(arizona->regmap, false);
-	return ret;
+	return regmap_multi_reg_write_bypassed(arizona->regmap,
+					       wm5102_patch,
+					       patch_size);
 }
 
 static const struct regmap_irq wm5102_aod_irqs[ARIZONA_NUM_IRQ] = {
-- 
1.7.2.5

