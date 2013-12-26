Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3LZVwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:52:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50193 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3LZVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:52:06 -0500
Date: Thu, 26 Dec 2013 13:52:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] regmap: Allow regmap_bulk_write() to work for "no-bus"
 regmaps
Message-ID: <20131226215204.GL31766@codeaurora.org>
References: <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
 <20131216210153.GA3185@sirena.org.uk>
 <20131217023047.GC31766@codeaurora.org>
 <20131218184541.GH31886@sirena.org.uk>
 <52B897A1.8030205@codeaurora.org>
 <20131224125358.GB30815@sirena.org.uk>
 <20131226193416.GI31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131226193416.GI31766@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap_bulk_write() should decay to performing individual writes
if we're using a "no-bus" regmap. Unfortunately, it returns an
error because there is no map->bus pointer. Fix it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This is based on v3.13-rc4

 drivers/base/regmap/regmap.c | 62 ++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d043d80..13d32fd 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1514,21 +1514,49 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 {
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
-	void *wval;
 
-	if (!map->bus)
-		return -EINVAL;
-	if (!map->format.parse_inplace)
+	if (map->bus && !map->format.parse_inplace)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
+	/*
+	 * Some devices don't support bulk write, for
+	 * them we have a series of single write operations.
+	 */
+	if (!map->bus || map->use_single_rw) {
+		for (i = 0; i < val_count; i++) {
+			unsigned int ival;
+
+			switch (val_bytes) {
+			case 1:
+				ival = *(u8 *)(val + (i * val_bytes));
+				break;
+			case 2:
+				ival = *(u16 *)(val + (i * val_bytes));
+				break;
+			case 4:
+				ival = *(u32 *)(val + (i * val_bytes));
+				break;
+#ifdef CONFIG_64BIT
+			case 8:
+				ival = *(u64 *)(val + (i * val_bytes));
+				break;
+#endif
+			default:
+				ret = -EINVAL;
+				goto out;
+			}
 
-	/* No formatting is require if val_byte is 1 */
-	if (val_bytes == 1) {
-		wval = (void *)val;
+			ret = _regmap_write(map, reg + (i * map->reg_stride),
+					ival);
+			if (ret != 0)
+				goto out;
+		}
 	} else {
+		void *wval;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
@@ -1537,27 +1565,11 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		}
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
 			map->format.parse_inplace(wval + i);
-	}
-	/*
-	 * Some devices does not support bulk write, for
-	 * them we have a series of single write operations.
-	 */
-	if (map->use_single_rw) {
-		for (i = 0; i < val_count; i++) {
-			ret = _regmap_raw_write(map,
-						reg + (i * map->reg_stride),
-						val + (i * val_bytes),
-						val_bytes);
-			if (ret != 0)
-				goto out;
-		}
-	} else {
+
 		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
-	}
 
-	if (val_bytes != 1)
 		kfree(wval);
-
+	}
 out:
 	map->unlock(map->lock_arg);
 	return ret;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
