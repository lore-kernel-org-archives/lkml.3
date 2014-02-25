Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaBYNyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:54:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50487 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbaBYNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:54:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 3/4] regmap: Base regmap_register_patch on _regmap_multi_reg_write
Date: Tue, 25 Feb 2014 13:45:51 +0000
Message-Id: <1393335952-28490-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have an internal version of regmap_multi_reg_write use this
to apply the register patch.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6b07a97..0e5c833 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2245,7 +2245,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
 	struct reg_default *p;
-	int i, ret;
+	int ret;
 	bool bypass;
 
 	if (WARN_ONCE(num_regs <= 0, "invalid registers number (%d)\n",
@@ -2259,19 +2259,9 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	map->cache_bypass = true;
 	map->async = true;
 
-	/* Write out first; it's useful to apply even if we fail later. */
-	for (i = 0; i < num_regs; i++) {
-		if (regs[i].reg % map->reg_stride) {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = _regmap_write(map, regs[i].reg, regs[i].def);
-		if (ret != 0) {
-			dev_err(map->dev, "Failed to write %x = %x: %d\n",
-				regs[i].reg, regs[i].def, ret);
-			goto out;
-		}
-	}
+	ret = _regmap_multi_reg_write(map, regs, num_regs);
+	if (ret != 0)
+		goto out;
 
 	p = krealloc(map->patch,
 		     sizeof(struct reg_default) * (map->patch_regs + num_regs),
-- 
1.7.2.5

