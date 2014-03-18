Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaCRMDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:03:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54684 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaCRMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:03:19 -0400
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 18 Mar 2014 12:02:58 +0000
Message-Id: <1395144178-3729-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Ensure regmap_register_patch() is compatible with fast_io
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

With fast_io we use mutexes to lock the I/O operations so we would need
to do GFP_ATOMIC allocations if we wanted to do allocations inside the
lock as we do currently. Since it is unlikely that we will want to register
a patch outside of init where concurrency shouldn't be an issue move the
allocation of the patch data outside the lock.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 554119535a64..2d7d55b3bedb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2396,6 +2396,9 @@ EXPORT_SYMBOL_GPL(regmap_async_complete);
  * apply them immediately.  Typically this is used to apply
  * corrections to be applied to the device defaults on startup, such
  * as the updates some vendors provide to undocumented registers.
+ *
+ * The caller must ensure that this function cannot be called
+ * concurrently with either itself or regcache_sync().
  */
 int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
@@ -2408,6 +2411,17 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	    num_regs))
 		return 0;
 
+	p = krealloc(map->patch,
+		     sizeof(struct reg_default) * (map->patch_regs + num_regs),
+		     GFP_KERNEL);
+	if (p) {
+		memcpy(p + map->patch_regs, regs, num_regs * sizeof(*regs));
+		map->patch = p;
+		map->patch_regs += num_regs;
+	} else {
+		return -ENOMEM;
+	}
+
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
@@ -2419,17 +2433,6 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	if (ret != 0)
 		goto out;
 
-	p = krealloc(map->patch,
-		     sizeof(struct reg_default) * (map->patch_regs + num_regs),
-		     GFP_KERNEL);
-	if (p) {
-		memcpy(p + map->patch_regs, regs, num_regs * sizeof(*regs));
-		map->patch = p;
-		map->patch_regs += num_regs;
-	} else {
-		ret = -ENOMEM;
-	}
-
 out:
 	map->async = false;
 	map->cache_bypass = bypass;
-- 
1.9.0

