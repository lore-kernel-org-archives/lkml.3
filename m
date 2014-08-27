Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbaH0OgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:36:19 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:57112 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934944AbaH0OgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:36:16 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RFC] regmap: Split regmap_get_endian() in two functions
Date: Wed, 27 Aug 2014 16:36:03 +0200
Message-Id: <1409150163-25729-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split regmap_get_endian() in two functions, regmap_get_reg_endian() and
regmap_get_val_endian().

This allows to:
  - Get rid of the three switch()es on "type", incl. error handling in
    three "default" cases,
  - Get rid of the regmap_endian_type enum,
  - Get rid of the non-NULL check of "config" (regmap_init() already
    checks for that),
  - Get rid of the "endian" output parameters, and just return the
    regmap_endian enum value, as the functions can no longer fail.

This saves 21 lines of code (despite the still-present
one-comment-per-line over-documentation), and 30 bytes of code on ARM
V7.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This allows to drop "regmap: Make sure regmap_init() returns non-NULL on
failure" (unless you want to keep it for philosophical reasons).
This patch is against today's regmap/for-next.

 drivers/base/regmap/regmap.c | 107 +++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 64 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 44c2df8284d7..f2281af24ec6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -449,78 +449,64 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
-enum regmap_endian_type {
-	REGMAP_ENDIAN_REG,
-	REGMAP_ENDIAN_VAL,
-};
+static enum regmap_endian regmap_get_reg_endian(const struct regmap_bus *bus,
+					const struct regmap_config *config)
+{
+	enum regmap_endian endian;
 
-static int regmap_get_endian(struct device *dev,
-				const struct regmap_bus *bus,
-				const struct regmap_config *config,
-				enum regmap_endian_type type,
-				enum regmap_endian *endian)
+	/* Retrieve the endianness specification from the regmap config */
+	endian = config->reg_format_endian;
+
+	/* If the regmap config specified a non-default value, use that */
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		return endian;
+
+	/* Retrieve the endianness specification from the bus config */
+	if (bus && bus->reg_format_endian_default)
+		endian = bus->reg_format_endian_default;
+
+	/* If the bus specified a non-default value, use that */
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		return endian;
+
+	/* Use this if no other value was found */
+	return REGMAP_ENDIAN_BIG;
+}
+
+static enum regmap_endian regmap_get_val_endian(struct device *dev,
+					const struct regmap_bus *bus,
+					const struct regmap_config *config)
 {
 	struct device_node *np = dev->of_node;
-
-	if (!endian || !config)
-		return -EINVAL;
+	enum regmap_endian endian;
 
 	/* Retrieve the endianness specification from the regmap config */
-	switch (type) {
-	case REGMAP_ENDIAN_REG:
-		*endian = config->reg_format_endian;
-		break;
-	case REGMAP_ENDIAN_VAL:
-		*endian = config->val_format_endian;
-		break;
-	default:
-		return -EINVAL;
-	}
+	endian = config->val_format_endian;
 
 	/* If the regmap config specified a non-default value, use that */
-	if (*endian != REGMAP_ENDIAN_DEFAULT)
-		return 0;
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		return endian;
 
 	/* Parse the device's DT node for an endianness specification */
-	switch (type) {
-	case REGMAP_ENDIAN_VAL:
-		if (of_property_read_bool(np, "big-endian"))
-			*endian = REGMAP_ENDIAN_BIG;
-		else if (of_property_read_bool(np, "little-endian"))
-			*endian = REGMAP_ENDIAN_LITTLE;
-		break;
-	case REGMAP_ENDIAN_REG:
-		break;
-	default:
-		return -EINVAL;
-	}
+	if (of_property_read_bool(np, "big-endian"))
+		endian = REGMAP_ENDIAN_BIG;
+	else if (of_property_read_bool(np, "little-endian"))
+		endian = REGMAP_ENDIAN_LITTLE;
 
 	/* If the endianness was specified in DT, use that */
-	if (*endian != REGMAP_ENDIAN_DEFAULT)
-		return 0;
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		return endian;
 
 	/* Retrieve the endianness specification from the bus config */
-	switch (type) {
-	case REGMAP_ENDIAN_REG:
-		if (bus && bus->reg_format_endian_default)
-			*endian = bus->reg_format_endian_default;
-		break;
-	case REGMAP_ENDIAN_VAL:
-		if (bus && bus->val_format_endian_default)
-			*endian = bus->val_format_endian_default;
-		break;
-	default:
-		return -EINVAL;
-	}
+	if (bus && bus->val_format_endian_default)
+		endian = bus->val_format_endian_default;
 
 	/* If the bus specified a non-default value, use that */
-	if (*endian != REGMAP_ENDIAN_DEFAULT)
-		return 0;
+	if (endian != REGMAP_ENDIAN_DEFAULT)
+		return endian;
 
 	/* Use this if no other value was found */
-	*endian = REGMAP_ENDIAN_BIG;
-
-	return 0;
+	return REGMAP_ENDIAN_BIG;
 }
 
 /**
@@ -626,15 +612,8 @@ struct regmap *regmap_init(struct device *dev,
 		map->reg_read  = _regmap_bus_read;
 	}
 
-	ret = regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_REG,
-				&reg_endian);
-	if (ret)
-		return ERR_PTR(ret);
-
-	ret = regmap_get_endian(dev, bus, config, REGMAP_ENDIAN_VAL,
-				&val_endian);
-	if (ret)
-		return ERR_PTR(ret);
+	reg_endian = regmap_get_reg_endian(bus, config);
+	val_endian = regmap_get_val_endian(dev, bus, config);
 
 	switch (config->reg_bits + map->reg_shift) {
 	case 2:
-- 
1.9.1

