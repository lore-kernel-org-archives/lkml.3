Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3GKLmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:42:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38016 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3GKLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:42:34 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@linaro.org>
Date: Thu, 11 Jul 2013 12:42:06 +0100
Message-Id: <1373542926-19481-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Allow multiple patches to be registered
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

It may be useful to register multiple patches with regmap, for example
one that depends on the device revision and one that depends on the system
configuration. Add support for doing this, appending any new patches to
the existing patches.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e0d0c7d..b2aeaba 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1888,13 +1888,10 @@ EXPORT_SYMBOL_GPL(regmap_async_complete);
 int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
+	struct reg_default *p;
 	int i, ret;
 	bool bypass;
 
-	/* If needed the implementation can be extended to support this */
-	if (map->patch)
-		return -EBUSY;
-
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
@@ -1911,11 +1908,13 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 		}
 	}
 
-	map->patch = kcalloc(num_regs, sizeof(struct reg_default), GFP_KERNEL);
-	if (map->patch != NULL) {
-		memcpy(map->patch, regs,
-		       num_regs * sizeof(struct reg_default));
-		map->patch_regs = num_regs;
+	p = krealloc(map->patch,
+		     sizeof(struct reg_default) * (map->patch_regs + num_regs),
+		     GFP_KERNEL);
+	if (p) {
+		memcpy(p + map->patch_regs, regs, num_regs);
+		map->patch = p;
+		map->patch_regs += num_regs;
 	} else {
 		ret = -ENOMEM;
 	}
-- 
1.8.3.2

