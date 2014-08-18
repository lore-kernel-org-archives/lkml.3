Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaHRWNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:13:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60923 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaHRWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:13:52 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>
Cc: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: fix of_regmap_get_endian()
Date: Mon, 18 Aug 2014 16:14:04 -0600
Message-Id: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit d647c199510c ("regmap: add DT endianness binding support") has
some issues. Specifically, if config->reg_format_endian is not explicitly
set, it will be zero, i.e. REGMAP_ENDIAN_DEFAULT. The switch statement
that looks up the *endian from DT for the type==REGMAP_ENDIAN_VAL case
doesn't change *endian in the type==REGMAP_ENDIAN_REG case. However, the
test immediately following, compares *endian against REGMAP_ENDIAN_NATIVE,
and if not equal, returns *endian as is. This ends up returning
REGMAP_ENDIAN_DEFAULT, which the calling code does not expect, eventually
leading to e.g.:

Unable to handle kernel NULL pointer dereference at virtual address 00000024
...
[<c02efd64>] (regcache_cache_only) from [<c0465fa8>] (tegra30_ahub_probe+0x1b8/0x430)
[<c0465fa8>] (tegra30_ahub_probe) from [<c02e196c>] (platform_drv_probe+0x2c/0x5c)
[<c02e196c>] (platform_drv_probe) from [<c02e0580>] (driver_probe_device+0x10c/0x22c)
[<c02e0580>] (driver_probe_device) from [<c02e072c>] (__driver_attach+0x8c/0x90)

This patch solves this by:
* When looking up the endianness from DT, don't change *endian at all if
  there is no DT property; leave it set to REGMAP_ENDIAN_DEFAULT so the
  code falls through to other data sources in the same way as before.
  Now, the "unspecified" case acts the same for both REGMAP_ENDIAN_REG and
  REGMAP_ENDIAN_VAL.
* After potentially looking up the endianness from DT, check *endian
  against REGMAP_ENDIAN_DEFAULT instead of REGMAP_ENDIAN_NATIVE to avoid
  returning unexpected values.

Also, clean up the code a bit:

* Make the comments briefer, and only refer to the specific action taken
  at their location. This makes most of the comments independent of DT,
  and easier to follow.
* Restore the overall default of REGMAP_ENDIAN_BIG if none of the config,
  DT, or the bus specify any endianness. Since all busses specify an
  endianness now, this makes no difference, but I saw no justification in
  the patch description for changing the default default.
* s/of_regmap_get_endian/regmap_get_endian/ since the function isn't DT-
  specific, even if the reason it was originally added was to add some
  DT-specific features.

Reported-by: Thierry Reding <treding@nvidia.com>
Fixes: d647c199510c ("regmap: add DT endianness binding support")
Cc: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap.c | 58 ++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e4e567e82b84..bb4502a48be5 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -454,7 +454,7 @@ enum regmap_endian_type {
 	REGMAP_ENDIAN_VAL,
 };
 
-static int of_regmap_get_endian(struct device *dev,
+static int regmap_get_endian(struct device *dev,
 				const struct regmap_bus *bus,
 				const struct regmap_config *config,
 				enum regmap_endian_type type,
@@ -465,15 +465,7 @@ static int of_regmap_get_endian(struct device *dev,
 	if (!endian || !config)
 		return -EINVAL;
 
-	/*
-	 * Firstly, try to parse the endianness from driver's config,
-	 * this is to be compatible with the none DT or the old drivers.
-	 * From the driver's config the endianness value maybe:
-	 *   REGMAP_ENDIAN_BIG,
-	 *   REGMAP_ENDIAN_LITTLE,
-	 *   REGMAP_ENDIAN_NATIVE,
-	 *   REGMAP_ENDIAN_DEFAULT.
-	 */
+	/* Retrieve the endianness specification from the regmap config */
 	switch (type) {
 	case REGMAP_ENDIAN_REG:
 		*endian = config->reg_format_endian;
@@ -485,30 +477,17 @@ static int of_regmap_get_endian(struct device *dev,
 		return -EINVAL;
 	}
 
-	/*
-	 * If the endianness parsed from driver config is
-	 * REGMAP_ENDIAN_DEFAULT, that means maybe we are using the DT
-	 * node to specify the endianness information.
-	 */
+	/* If the regmap config specified a non-default value, use that */
 	if (*endian != REGMAP_ENDIAN_DEFAULT)
 		return 0;
 
-	/*
-	 * Secondly, try to parse the endianness from DT node if the
-	 * driver config does not specify it.
-	 * From the DT node the endianness value maybe:
-	 *   REGMAP_ENDIAN_BIG,
-	 *   REGMAP_ENDIAN_LITTLE,
-	 *   REGMAP_ENDIAN_NATIVE,
-	 */
+	/* Parse the device's DT node for an endianness specification */
 	switch (type) {
 	case REGMAP_ENDIAN_VAL:
 		if (of_property_read_bool(np, "big-endian"))
 			*endian = REGMAP_ENDIAN_BIG;
 		else if (of_property_read_bool(np, "little-endian"))
 			*endian = REGMAP_ENDIAN_LITTLE;
-		else
-			*endian = REGMAP_ENDIAN_NATIVE;
 		break;
 	case REGMAP_ENDIAN_REG:
 		break;
@@ -516,19 +495,11 @@ static int of_regmap_get_endian(struct device *dev,
 		return -EINVAL;
 	}
 
-	/*
-	 * If the endianness parsed from DT node is REGMAP_ENDIAN_NATIVE, that
-	 * maybe means the DT does not care the endianness or it should use
-	 * the regmap bus's default endianness, then we should try to check
-	 * whether the regmap bus has specified the default endianness.
-	 */
-	if (*endian != REGMAP_ENDIAN_NATIVE)
+	/* If the endianness was specified in DT, use that */
+	if (*endian != REGMAP_ENDIAN_DEFAULT)
 		return 0;
 
-	/*
-	 * Finally, try to parse the endianness from regmap bus config
-	 * if in device's DT node the endianness property is absent.
-	 */
+	/* Retrieve the endianness specification from the bus config */
 	switch (type) {
 	case REGMAP_ENDIAN_REG:
 		if (bus && bus->reg_format_endian_default)
@@ -542,6 +513,13 @@ static int of_regmap_get_endian(struct device *dev,
 		return -EINVAL;
 	}
 
+	/* If the bus specified a non-default value, use that */
+	if (*endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/* Use this if no other value was found */
+	*endian = REGMAP_ENDIAN_BIG;
+
 	return 0;
 }
 
@@ -648,13 +626,13 @@ struct regmap *regmap_init(struct device *dev,
 		map->reg_read  = _regmap_bus_read;
 	}
 
-	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
-				   &reg_endian);
+	ret = regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
+				&reg_endian);
 	if (ret)
 		return ERR_PTR(ret);
 
-	ret = of_regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
-				   &val_endian);
+	ret = regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
+				&val_endian);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
1.9.1

