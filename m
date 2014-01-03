Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaACN2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53431 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaACN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:10 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/11] MFD: twl-core: Simplify IO wrapper functions by moving common code out
Date: Fri, 3 Jan 2014 15:27:46 +0200
Message-ID: <1388755676-16036-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new twl_get_regmap() function will return a pointer to the regmap needed
for the given module.
Since both read and write function were using the same code to do the lookup
we can reuse this in both places to simplify the code.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 58 +++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 29473c2c95ae..c91cb4367b9b 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -302,35 +302,50 @@ unsigned int twl_rev(void)
 EXPORT_SYMBOL(twl_rev);
 
 /**
- * twl_i2c_write - Writes a n bit register in TWL4030/TWL5030/TWL60X0
+ * twl_get_regmap - Get the regmap associated with the given module
  * @mod_no: module number
- * @value: an array of num_bytes+1 containing data to write
- * @reg: register address (just offset will do)
- * @num_bytes: number of bytes to transfer
  *
- * Returns the result of operation - 0 is success
+ * Returns the regmap pointer or NULL in case of failure.
  */
-int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
+static struct regmap *twl_get_regmap(u8 mod_no)
 {
-	int ret;
 	int sid;
 	struct twl_client *twl;
 
 	if (unlikely(!twl_priv || !twl_priv->ready)) {
 		pr_err("%s: not initialized\n", DRIVER_NAME);
-		return -EPERM;
+		return NULL;
 	}
 	if (unlikely(mod_no >= twl_get_last_module())) {
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
-		return -EPERM;
+		return NULL;
 	}
 
 	sid = twl_priv->twl_map[mod_no].sid;
 	twl = &twl_priv->twl_modules[sid];
 
-	ret = regmap_bulk_write(twl->regmap,
-				twl_priv->twl_map[mod_no].base + reg, value,
-				num_bytes);
+	return twl->regmap;
+}
+
+/**
+ * twl_i2c_write - Writes a n bit register in TWL4030/TWL5030/TWL60X0
+ * @mod_no: module number
+ * @value: an array of num_bytes+1 containing data to write
+ * @reg: register address (just offset will do)
+ * @num_bytes: number of bytes to transfer
+ *
+ * Returns the result of operation - 0 is success
+ */
+int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
+{
+	struct regmap *regmap = twl_get_regmap(mod_no);
+	int ret;
+
+	if (!regmap)
+		return -EPERM;
+
+	ret = regmap_bulk_write(regmap, twl_priv->twl_map[mod_no].base + reg,
+				value, num_bytes);
 
 	if (ret)
 		pr_err("%s: Write failed (mod %d, reg 0x%02x count %d)\n",
@@ -351,25 +366,14 @@ EXPORT_SYMBOL(twl_i2c_write);
  */
 int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 {
+	struct regmap *regmap = twl_get_regmap(mod_no);
 	int ret;
-	int sid;
-	struct twl_client *twl;
 
-	if (unlikely(!twl_priv || !twl_priv->ready)) {
-		pr_err("%s: not initialized\n", DRIVER_NAME);
-		return -EPERM;
-	}
-	if (unlikely(mod_no >= twl_get_last_module())) {
-		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
+	if (!regmap)
 		return -EPERM;
-	}
-
-	sid = twl_priv->twl_map[mod_no].sid;
-	twl = &twl_priv->twl_modules[sid];
 
-	ret = regmap_bulk_read(twl->regmap,
-			       twl_priv->twl_map[mod_no].base + reg, value,
-			       num_bytes);
+	ret = regmap_bulk_read(regmap, twl_priv->twl_map[mod_no].base + reg,
+			       value, num_bytes);
 
 	if (ret)
 		pr_err("%s: Read failed (mod %d, reg 0x%02x count %d)\n",
-- 
1.8.5.2

