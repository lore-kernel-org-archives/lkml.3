Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaHSQsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:48:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53657 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaHSQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:48:52 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>
Cc: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH V2] regmap: of_regmap_get_endian() cleanup
Date: Tue, 19 Aug 2014 10:49:07 -0600
Message-Id: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit d647c199510c ("regmap: add DT endianness binding support") had
some issues. Commit ba1b53feb8ca ("regmap: Fix DT endianess parsing
logic") fixed the main problem. This patch fixes the other.

Specifically, restore the overall default of REGMAP_ENDIAN_BIG if none of
the config, DT, or the bus specify any endianness. Without this,
of_regmap_get_endian() could return REGMAP_ENDIAN_DEFAULT, which the
calling code can't handle. Since all busses do specify an endianness in
the current code, this makes no difference right now, but I saw no
justification in the patch description for removing this final default.

Also, clean up the code a bit:

* s/of_regmap_get_endian/regmap_get_endian/ since the function isn't DT-
  specific, even if the reason it was originally added was to add some
  DT-specific features.
* After potentially reading an endianess specification from DT, the code
  checks whether DT did specify an endianness, and if so, returns it. Move
  this test outside the whole switch statement so that if the
  REGMAP_ENDIAN_REG case ever modifies *endian, this check will pick that
  up. This partially reverts part of commit ba1b53feb8ca ("regmap: Fix DT
  endianess parsing logic"), while maintaining the bug-fix that commit
  made to this code.
* Make the comments briefer, and only refer to the specific action taken
  at their location. This makes most of the comments independent of DT,
  and easier to follow.

Cc: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Thierry Reding <treding@nvidia.com>
Fixes: d647c199510c ("regmap: add DT endianness binding support")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
V2: Rebase on Javier's earlier fix, amend commit description due to this.

 drivers/base/regmap/regmap.c | 54 ++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 055a9c3a3b12..bb4502a48be5 100644
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
@@ -485,31 +477,17 @@ static int of_regmap_get_endian(struct device *dev,
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
-	 */
+	/* Parse the device's DT node for an endianness specification */
 	switch (type) {
 	case REGMAP_ENDIAN_VAL:
 		if (of_property_read_bool(np, "big-endian"))
 			*endian = REGMAP_ENDIAN_BIG;
 		else if (of_property_read_bool(np, "little-endian"))
 			*endian = REGMAP_ENDIAN_LITTLE;
-
-		if (*endian != REGMAP_ENDIAN_DEFAULT)
-			return 0;
-
 		break;
 	case REGMAP_ENDIAN_REG:
 		break;
@@ -517,10 +495,11 @@ static int of_regmap_get_endian(struct device *dev,
 		return -EINVAL;
 	}
 
-	/*
-	 * Finally, try to parse the endianness from regmap bus config
-	 * if in device's DT node the endianness property is absent.
-	 */
+	/* If the endianness was specified in DT, use that */
+	if (*endian != REGMAP_ENDIAN_DEFAULT)
+		return 0;
+
+	/* Retrieve the endianness specification from the bus config */
 	switch (type) {
 	case REGMAP_ENDIAN_REG:
 		if (bus && bus->reg_format_endian_default)
@@ -534,6 +513,13 @@ static int of_regmap_get_endian(struct device *dev,
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
 
@@ -640,13 +626,13 @@ struct regmap *regmap_init(struct device *dev,
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

