Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3IAEYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 00:24:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53027 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3IAEYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 00:24:22 -0400
Message-ID: <1378009457.25863.3.camel@phoenix>
Subject: [PATCH] regulator: core: Refactor devm_regulator_get* APIs
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 01 Sep 2013 12:24:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of devm_regulator_get, devm_regulator_get_exclusive and
devm_regulator_get_optional are almost the same.
Introduce _devm_regulator_get helper function and refactor the code.

Also move devm_regulator_get_exclusive to proper place, put it after
regulator_get_exclusive() function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c | 127 +++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 65 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3..39e550a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1334,6 +1334,50 @@ out:
 	return regulator;
 }
 
+enum {
+	NORMAL_GET,
+	EXCLUSIVE_GET,
+	OPTIONAL_GET,
+};
+
+static void devm_regulator_release(struct device *dev, void *res)
+{
+	regulator_put(*(struct regulator **)res);
+}
+
+static struct regulator *_devm_regulator_get(struct device *dev, const char *id,
+					     int get_type)
+{
+	struct regulator **ptr, *regulator;
+
+	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	switch (get_type) {
+	case NORMAL_GET:
+		regulator = regulator_get(dev, id);
+		break;
+	case EXCLUSIVE_GET:
+		regulator = regulator_get_exclusive(dev, id);
+		break;
+	case OPTIONAL_GET:
+		regulator = regulator_get_optional(dev, id);
+		break;
+	default:
+		regulator = ERR_PTR(-EINVAL);
+	}
+
+	if (!IS_ERR(regulator)) {
+		*ptr = regulator;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return regulator;
+}
+
 /**
  * regulator_get - lookup and obtain a reference to a regulator.
  * @dev: device for regulator "consumer"
@@ -1353,11 +1397,6 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get);
 
-static void devm_regulator_release(struct device *dev, void *res)
-{
-	regulator_put(*(struct regulator **)res);
-}
-
 /**
  * devm_regulator_get - Resource managed regulator_get()
  * @dev: device for regulator "consumer"
@@ -1369,21 +1408,7 @@ static void devm_regulator_release(struct device *dev, void *res)
  */
 struct regulator *devm_regulator_get(struct device *dev, const char *id)
 {
-	struct regulator **ptr, *regulator;
-
-	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	regulator = regulator_get(dev, id);
-	if (!IS_ERR(regulator)) {
-		*ptr = regulator;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return regulator;
+	return _devm_regulator_get(dev, id, NORMAL_GET);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get);
 
@@ -1415,6 +1440,22 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
 /**
+ * devm_regulator_get_exclusive - Resource managed regulator_get_exclusive()
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get_exclusive(). Regulators returned from this function
+ * are automatically regulator_put() on driver detach. See regulator_get() for
+ * more information.
+ */
+struct regulator *devm_regulator_get_exclusive(struct device *dev,
+					       const char *id)
+{
+	return _devm_regulator_get(dev, id, EXCLUSIVE_GET);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
+
+/**
  * regulator_get_optional - obtain optional access to a regulator.
  * @dev: device for regulator "consumer"
  * @id: Supply name or regulator ID.
@@ -1455,21 +1496,7 @@ EXPORT_SYMBOL_GPL(regulator_get_optional);
 struct regulator *devm_regulator_get_optional(struct device *dev,
 					      const char *id)
 {
-	struct regulator **ptr, *regulator;
-
-	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	regulator = regulator_get_optional(dev, id);
-	if (!IS_ERR(regulator)) {
-		*ptr = regulator;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return regulator;
+	return _devm_regulator_get(dev, id, OPTIONAL_GET);
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
 
@@ -1499,36 +1526,6 @@ static void _regulator_put(struct regulator *regulator)
 }
 
 /**
- * devm_regulator_get_exclusive - Resource managed regulator_get_exclusive()
- * @dev: device for regulator "consumer"
- * @id: Supply name or regulator ID.
- *
- * Managed regulator_get_exclusive(). Regulators returned from this function
- * are automatically regulator_put() on driver detach. See regulator_get() for
- * more information.
- */
-struct regulator *devm_regulator_get_exclusive(struct device *dev,
-					       const char *id)
-{
-	struct regulator **ptr, *regulator;
-
-	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	regulator = _regulator_get(dev, id, 1);
-	if (!IS_ERR(regulator)) {
-		*ptr = regulator;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return regulator;
-}
-EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
-
-/**
  * regulator_put - "free" the regulator source
  * @regulator: regulator source
  *
-- 
1.8.1.2



