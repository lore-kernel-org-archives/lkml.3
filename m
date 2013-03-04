Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3CDBOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:14:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48695 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab3CDBOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:14:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: core: Split out in place value parsing
Date: Mon,  4 Mar 2013 09:14:39 +0800
Message-Id: <1362359680-23747-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the value parsing operations both return the parsed value and
modify the passed buffer. This precludes their use in places like the cache
code so split out the in place modification into a new parse_inplace()
operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    3 ++-
 drivers/base/regmap/regmap.c   |   52 +++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2aa8772..f0e0ca4 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -38,7 +38,8 @@ struct regmap_format {
 			     unsigned int reg, unsigned int val);
 	void (*format_reg)(void *buf, unsigned int reg, unsigned int shift);
 	void (*format_val)(void *buf, unsigned int val, unsigned int shift);
-	unsigned int (*parse_val)(void *buf);
+	unsigned int (*parse_val)(const void *buf);
+	void (*parse_inplace)(void *buf);
 };
 
 struct regmap_async {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7c6d3be..4b01404 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -228,30 +228,39 @@ static void regmap_format_32_native(void *buf, unsigned int val,
 	*(u32 *)buf = val << shift;
 }
 
-static unsigned int regmap_parse_8(void *buf)
+static void regmap_parse_inplace_noop(void *buf)
 {
-	u8 *b = buf;
+}
+
+static unsigned int regmap_parse_8(const void *buf)
+{
+	const u8 *b = buf;
 
 	return b[0];
 }
 
-static unsigned int regmap_parse_16_be(void *buf)
+static unsigned int regmap_parse_16_be(const void *buf)
+{
+	const __be16 *b = buf;
+
+	return be16_to_cpu(b[0]);
+}
+
+static void regmap_parse_16_be_inplace(void *buf)
 {
 	__be16 *b = buf;
 
 	b[0] = be16_to_cpu(b[0]);
-
-	return b[0];
 }
 
-static unsigned int regmap_parse_16_native(void *buf)
+static unsigned int regmap_parse_16_native(const void *buf)
 {
 	return *(u16 *)buf;
 }
 
-static unsigned int regmap_parse_24(void *buf)
+static unsigned int regmap_parse_24(const void *buf)
 {
-	u8 *b = buf;
+	const u8 *b = buf;
 	unsigned int ret = b[2];
 	ret |= ((unsigned int)b[1]) << 8;
 	ret |= ((unsigned int)b[0]) << 16;
@@ -259,16 +268,21 @@ static unsigned int regmap_parse_24(void *buf)
 	return ret;
 }
 
-static unsigned int regmap_parse_32_be(void *buf)
+static unsigned int regmap_parse_32_be(const void *buf)
+{
+	const __be32 *b = buf;
+
+	return be32_to_cpu(b[0]);
+}
+
+static void regmap_parse_32_be_inplace(void *buf)
 {
 	__be32 *b = buf;
 
 	b[0] = be32_to_cpu(b[0]);
-
-	return b[0];
 }
 
-static unsigned int regmap_parse_32_native(void *buf)
+static unsigned int regmap_parse_32_native(const void *buf)
 {
 	return *(u32 *)buf;
 }
@@ -555,16 +569,21 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	if (val_endian == REGMAP_ENDIAN_NATIVE)
+		map->format.parse_inplace = regmap_parse_inplace_noop;
+
 	switch (config->val_bits) {
 	case 8:
 		map->format.format_val = regmap_format_8;
 		map->format.parse_val = regmap_parse_8;
+		map->format.parse_inplace = regmap_parse_inplace_noop;
 		break;
 	case 16:
 		switch (val_endian) {
 		case REGMAP_ENDIAN_BIG:
 			map->format.format_val = regmap_format_16_be;
 			map->format.parse_val = regmap_parse_16_be;
+			map->format.parse_inplace = regmap_parse_16_be_inplace;
 			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_16_native;
@@ -585,6 +604,7 @@ struct regmap *regmap_init(struct device *dev,
 		case REGMAP_ENDIAN_BIG:
 			map->format.format_val = regmap_format_32_be;
 			map->format.parse_val = regmap_parse_32_be;
+			map->format.parse_inplace = regmap_parse_32_be_inplace;
 			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_32_native;
@@ -1242,7 +1262,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 
 	if (!map->bus)
 		return -EINVAL;
-	if (!map->format.parse_val)
+	if (!map->format.parse_inplace)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1260,7 +1280,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			goto out;
 		}
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
-			map->format.parse_val(wval + i);
+			map->format.parse_inplace(wval + i);
 	}
 	/*
 	 * Some devices does not support bulk write, for
@@ -1521,7 +1541,7 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 
 	if (!map->bus)
 		return -EINVAL;
-	if (!map->format.parse_val)
+	if (!map->format.parse_inplace)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1548,7 +1568,7 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 		}
 
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
-			map->format.parse_val(val + i);
+			map->format.parse_inplace(val + i);
 	} else {
 		for (i = 0; i < val_count; i++) {
 			unsigned int ival;
-- 
1.7.10.4

