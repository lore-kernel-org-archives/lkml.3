Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3JJUCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:02:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49908 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3JJUCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:02:18 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 10 Oct 2013 21:02:10 +0100
Message-Id: <1381435330-23308-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Use async I/O for patch application
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Try to speed up patch application a little using async I/O.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ccdac61..437f7f6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2132,6 +2132,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	bypass = map->cache_bypass;
 
 	map->cache_bypass = true;
+	map->async = true;
 
 	/* Write out first; it's useful to apply even if we fail later. */
 	for (i = 0; i < num_regs; i++) {
@@ -2155,10 +2156,13 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	}
 
 out:
+	map->async = false;
 	map->cache_bypass = bypass;
 
 	map->unlock(map->lock_arg);
 
+	regmap_async_complete(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_register_patch);
-- 
1.8.4.rc3

