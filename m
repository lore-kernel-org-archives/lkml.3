Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaBUTp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:45:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbaBUTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:45:28 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/3] regmap: Check stride of register patch as we register it
Date: Fri, 21 Feb 2014 19:37:10 +0000
Message-Id: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we check the registers in the patch are aligned to the
register stride everytime we sync the cache and the first time the patch
is written out is unchecked.

This patch checks the register patch when we first register it so the
first writes are no longer unchecked and then doesn't check on
subsequent syncs as the patch will be unchanged.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    4 ----
 drivers/base/regmap/regmap.c   |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index dd56177..c6b1ac1 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -312,10 +312,6 @@ int regcache_sync(struct regmap *map)
 	/* Apply any patch first */
 	map->cache_bypass = 1;
 	for (i = 0; i < map->patch_regs; i++) {
-		if (map->patch[i].reg % map->reg_stride) {
-			ret = -EINVAL;
-			goto out;
-		}
 		ret = _regmap_write(map, map->patch[i].reg, map->patch[i].def);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to write %x = %x: %d\n",
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c766f5f..c2ba89a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2212,6 +2212,10 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 
 	/* Write out first; it's useful to apply even if we fail later. */
 	for (i = 0; i < num_regs; i++) {
+		if (regs[i].reg % map->reg_stride) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = _regmap_write(map, regs[i].reg, regs[i].def);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to write %x = %x: %d\n",
-- 
1.7.2.5

