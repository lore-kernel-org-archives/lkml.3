Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbaFZSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:16:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33363 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaFZSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:16:52 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 09/14] regmap: Add regmap_reg_copy function
Date: Thu, 26 Jun 2014 20:15:41 +0200
Message-Id: <1403806546-31122-10-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers using the register map API need to copy the
value from one register to another. Even though it can be done
with a combination of regmap_read() and regmap_write(), it is
better to have a function to avoid code duplication and also it
sanity check and do it atomically by holding the regmap lock.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v4: None

Changes since v3: None

 drivers/base/regmap/regmap.c | 34 ++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |  9 +++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 74d8c06..a2e0b04 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2555,6 +2555,40 @@ int regmap_parse_val(struct regmap *map, const void *buf,
 }
 EXPORT_SYMBOL_GPL(regmap_parse_val);
 
+/**
+ * regmap_reg_copy(): Copy a value from a single register to another one
+ *
+ * @map: Register map to operate on
+ * @dest: Register to copy the value to
+ * @src: Register to copy the value from
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_reg_copy(struct regmap *map, unsigned int dest, unsigned int src)
+{
+	int val;
+	int ret = 0;
+
+	if (dest == src)
+		return ret;
+
+	if (dest % map->reg_stride ||
+	    src % map->reg_stride)
+		return -EINVAL;
+
+	map->lock(map->lock_arg);
+
+	ret = _regmap_read(map, src, &val);
+	if (!ret)
+		ret = _regmap_write(map, dest, val);
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_reg_copy);
+
 static int __init regmap_initcall(void)
 {
 	regmap_debugfs_initcall();
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7b0e4b4..116c22b 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -445,6 +445,8 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 int regmap_parse_val(struct regmap *map, const void *buf,
 				unsigned int *val);
 
+int regmap_reg_copy(struct regmap *map, unsigned int dest, unsigned int src);
+
 static inline bool regmap_reg_in_range(unsigned int reg,
 				       const struct regmap_range *range)
 {
@@ -723,6 +725,13 @@ static inline int regmap_parse_val(struct regmap *map, const void *buf,
 	return -EINVAL;
 }
 
+static inline int regmap_reg_copy(struct regmap *map, unsigned int dest,
+				  unsigned int src)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline struct regmap *dev_get_regmap(struct device *dev,
 					    const char *name)
 {
-- 
2.0.0.rc2

