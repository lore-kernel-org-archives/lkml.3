Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaBYNyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:54:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50478 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbaBYNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:54:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/4] regmap: Add bypassed version of regmap_multi_reg_write
Date: Tue, 25 Feb 2014 13:45:50 +0000
Message-Id: <1393335952-28490-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices with more complex boot proceedures may occasionally apply the
register patch manual. regmap_multi_reg_write is a logical way to do so,
however the patch must be applied with cache bypass on, such that it
doesn't override any user settings. This patch adds a
regmap_multi_reg_write_bypassed function that applies a set of writes
with the bypass enabled.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   75 ++++++++++++++++++++++++++++++++++-------
 include/linux/regmap.h       |    3 ++
 2 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1ebc6df..6b07a97 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1591,6 +1591,26 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+static int _regmap_multi_reg_write(struct regmap *map,
+				   const struct reg_default *regs,
+				   int num_regs)
+{
+	int i, ret;
+
+	for (i = 0; i < num_regs; i++) {
+		if (regs[i].reg % map->reg_stride)
+			return -EINVAL;
+		ret = _regmap_write(map, regs[i].reg, regs[i].def);
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to write %x = %x: %d\n",
+				regs[i].reg, regs[i].def, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * regmap_multi_reg_write(): Write multiple registers to the device
  *
@@ -1610,28 +1630,57 @@ EXPORT_SYMBOL_GPL(regmap_bulk_write);
 int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
 			   int num_regs)
 {
-	int ret = 0, i;
-
-	for (i = 0; i < num_regs; i++) {
-		int reg = regs[i].reg;
-		if (reg % map->reg_stride)
-			return -EINVAL;
-	}
+	int ret;
 
 	map->lock(map->lock_arg);
 
-	for (i = 0; i < num_regs; i++) {
-		ret = _regmap_write(map, regs[i].reg, regs[i].def);
-		if (ret != 0)
-			goto out;
-	}
-out:
+	ret = _regmap_multi_reg_write(map, regs, num_regs);
+
 	map->unlock(map->lock_arg);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_multi_reg_write);
 
+/*
+ * regmap_multi_reg_write_bypassed(): Write multiple registers to the
+ *                                    device but not the cache
+ *
+ * where the set of register are supplied in any order
+ *
+ * @map: Register map to write to
+ * @regs: Array of structures containing register,value to be written
+ * @num_regs: Number of registers to write
+ *
+ * This function is intended to be used for writing a large block of data
+ * atomically to the device in single transfer for those I2C client devices
+ * that implement this alternative block write mode.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_multi_reg_write_bypassed(struct regmap *map,
+				    const struct reg_default *regs,
+				    int num_regs)
+{
+	int ret;
+	bool bypass;
+
+	map->lock(map->lock_arg);
+
+	bypass = map->cache_bypass;
+	map->cache_bypass = true;
+
+	ret = _regmap_multi_reg_write(map, regs, num_regs);
+
+	map->cache_bypass = bypass;
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_multi_reg_write_bypassed);
+
 /**
  * regmap_raw_write_async(): Write raw values to one or more registers
  *                           asynchronously
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index ccb2ed0..15a6c2c 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -390,6 +390,9 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			size_t val_count);
 int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
 			int num_regs);
+int regmap_multi_reg_write_bypassed(struct regmap *map,
+				    const struct reg_default *regs,
+				    int num_regs);
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
-- 
1.7.2.5

