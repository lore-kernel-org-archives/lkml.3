Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3IKMT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:19:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49452 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IKMTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:19:54 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 11 Sep 2013 13:19:28 +0100
Message-Id: <1378901968-7368-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Split devres code out into a separate file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Cut down on the size of core.c a bit more and ensure that the devres
versions of things don't do too much peering inside the internals of
the APIs they wrap.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/Makefile   |   2 +-
 drivers/regulator/core.c     | 252 +------------------------------------------
 drivers/regulator/devres.c   | 252 +++++++++++++++++++++++++++++++++++++++++++
 drivers/regulator/internal.h |  38 +++++++
 4 files changed, 292 insertions(+), 252 deletions(-)
 create mode 100644 drivers/regulator/devres.c
 create mode 100644 drivers/regulator/internal.h

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 185cce2..69db4c8 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -3,7 +3,7 @@
 #
 
 
-obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o helpers.o
+obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o helpers.o devres.o
 obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02d2ccc..02af90e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -36,6 +36,7 @@
 #include <trace/events/regulator.h>
 
 #include "dummy.h"
+#include "internal.h"
 
 #define rdev_crit(rdev, fmt, ...)					\
 	pr_crit("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
@@ -82,25 +83,6 @@ struct regulator_enable_gpio {
 	unsigned int ena_gpio_invert:1;
 };
 
-/*
- * struct regulator
- *
- * One for each consumer device.
- */
-struct regulator {
-	struct device *dev;
-	struct list_head list;
-	unsigned int always_on:1;
-	unsigned int bypass:1;
-	int uA_load;
-	int min_uV;
-	int max_uV;
-	char *supply_name;
-	struct device_attribute dev_attr;
-	struct regulator_dev *rdev;
-	struct dentry *debugfs;
-};
-
 static int _regulator_is_enabled(struct regulator_dev *rdev);
 static int _regulator_disable(struct regulator_dev *rdev);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
@@ -1334,50 +1316,6 @@ out:
 	return regulator;
 }
 
-enum {
-	NORMAL_GET,
-	EXCLUSIVE_GET,
-	OPTIONAL_GET,
-};
-
-static void devm_regulator_release(struct device *dev, void *res)
-{
-	regulator_put(*(struct regulator **)res);
-}
-
-static struct regulator *_devm_regulator_get(struct device *dev, const char *id,
-					     int get_type)
-{
-	struct regulator **ptr, *regulator;
-
-	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	switch (get_type) {
-	case NORMAL_GET:
-		regulator = regulator_get(dev, id);
-		break;
-	case EXCLUSIVE_GET:
-		regulator = regulator_get_exclusive(dev, id);
-		break;
-	case OPTIONAL_GET:
-		regulator = regulator_get_optional(dev, id);
-		break;
-	default:
-		regulator = ERR_PTR(-EINVAL);
-	}
-
-	if (!IS_ERR(regulator)) {
-		*ptr = regulator;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return regulator;
-}
-
 /**
  * regulator_get - lookup and obtain a reference to a regulator.
  * @dev: device for regulator "consumer"
@@ -1398,21 +1336,6 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 EXPORT_SYMBOL_GPL(regulator_get);
 
 /**
- * devm_regulator_get - Resource managed regulator_get()
- * @dev: device for regulator "consumer"
- * @id: Supply name or regulator ID.
- *
- * Managed regulator_get(). Regulators returned from this function are
- * automatically regulator_put() on driver detach. See regulator_get() for more
- * information.
- */
-struct regulator *devm_regulator_get(struct device *dev, const char *id)
-{
-	return _devm_regulator_get(dev, id, NORMAL_GET);
-}
-EXPORT_SYMBOL_GPL(devm_regulator_get);
-
-/**
  * regulator_get_exclusive - obtain exclusive access to a regulator.
  * @dev: device for regulator "consumer"
  * @id: Supply name or regulator ID.
@@ -1440,22 +1363,6 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
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
-	return _devm_regulator_get(dev, id, EXCLUSIVE_GET);
-}
-EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
-
-/**
  * regulator_get_optional - obtain optional access to a regulator.
  * @dev: device for regulator "consumer"
  * @id: Supply name or regulator ID.
@@ -1484,22 +1391,6 @@ struct regulator *regulator_get_optional(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get_optional);
 
-/**
- * devm_regulator_get_optional - Resource managed regulator_get_optional()
- * @dev: device for regulator "consumer"
- * @id: Supply name or regulator ID.
- *
- * Managed regulator_get_optional(). Regulators returned from this
- * function are automatically regulator_put() on driver detach. See
- * regulator_get_optional() for more information.
- */
-struct regulator *devm_regulator_get_optional(struct device *dev,
-					      const char *id)
-{
-	return _devm_regulator_get(dev, id, OPTIONAL_GET);
-}
-EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
-
 /* Locks held by regulator_put() */
 static void _regulator_put(struct regulator *regulator)
 {
@@ -1541,35 +1432,6 @@ void regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
-static int devm_regulator_match(struct device *dev, void *res, void *data)
-{
-	struct regulator **r = res;
-	if (!r || !*r) {
-		WARN_ON(!r || !*r);
-		return 0;
-	}
-	return *r == data;
-}
-
-/**
- * devm_regulator_put - Resource managed regulator_put()
- * @regulator: regulator to free
- *
- * Deallocate a regulator allocated with devm_regulator_get(). Normally
- * this function will not need to be called and the resource management
- * code will ensure that the resource is freed.
- */
-void devm_regulator_put(struct regulator *regulator)
-{
-	int rc;
-
-	rc = devres_release(regulator->dev, devm_regulator_release,
-			    devm_regulator_match, regulator);
-	if (rc != 0)
-		WARN_ON(rc);
-}
-EXPORT_SYMBOL_GPL(devm_regulator_put);
-
 /* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
 static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 				const struct regulator_config *config)
@@ -2911,52 +2773,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(regulator_bulk_get);
 
-/**
- * devm_regulator_bulk_get - managed get multiple regulator consumers
- *
- * @dev:           Device to supply
- * @num_consumers: Number of consumers to register
- * @consumers:     Configuration of consumers; clients are stored here.
- *
- * @return 0 on success, an errno on failure.
- *
- * This helper function allows drivers to get several regulator
- * consumers in one operation with management, the regulators will
- * automatically be freed when the device is unbound.  If any of the
- * regulators cannot be acquired then any regulators that were
- * allocated will be freed before returning to the caller.
- */
-int devm_regulator_bulk_get(struct device *dev, int num_consumers,
-			    struct regulator_bulk_data *consumers)
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < num_consumers; i++)
-		consumers[i].consumer = NULL;
-
-	for (i = 0; i < num_consumers; i++) {
-		consumers[i].consumer = devm_regulator_get(dev,
-							   consumers[i].supply);
-		if (IS_ERR(consumers[i].consumer)) {
-			ret = PTR_ERR(consumers[i].consumer);
-			dev_err(dev, "Failed to get supply '%s': %d\n",
-				consumers[i].supply, ret);
-			consumers[i].consumer = NULL;
-			goto err;
-		}
-	}
-
-	return 0;
-
-err:
-	for (i = 0; i < num_consumers && consumers[i].consumer; i++)
-		devm_regulator_put(consumers[i].consumer);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devm_regulator_bulk_get);
-
 static void regulator_bulk_enable_async(void *data, async_cookie_t cookie)
 {
 	struct regulator_bulk_data *bulk = data;
@@ -3492,44 +3308,6 @@ clean:
 }
 EXPORT_SYMBOL_GPL(regulator_register);
 
-static void devm_rdev_release(struct device *dev, void *res)
-{
-	regulator_unregister(*(struct regulator_dev **)res);
-}
-
-/**
- * devm_regulator_register - Resource managed regulator_register()
- * @regulator_desc: regulator to register
- * @config: runtime configuration for regulator
- *
- * Called by regulator drivers to register a regulator.  Returns a
- * valid pointer to struct regulator_dev on success or an ERR_PTR() on
- * error.  The regulator will automaticall be released when the device
- * is unbound.
- */
-struct regulator_dev *devm_regulator_register(struct device *dev,
-				  const struct regulator_desc *regulator_desc,
-				  const struct regulator_config *config)
-{
-	struct regulator_dev **ptr, *rdev;
-
-	ptr = devres_alloc(devm_rdev_release, sizeof(*ptr),
-			   GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	rdev = regulator_register(regulator_desc, config);
-	if (!IS_ERR(rdev)) {
-		*ptr = rdev;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return rdev;
-}
-EXPORT_SYMBOL_GPL(devm_regulator_register);
-
 /**
  * regulator_unregister - unregister regulator
  * @rdev: regulator to unregister
@@ -3559,34 +3337,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 }
 EXPORT_SYMBOL_GPL(regulator_unregister);
 
-static int devm_rdev_match(struct device *dev, void *res, void *data)
-{
-	struct regulator_dev **r = res;
-	if (!r || !*r) {
-		WARN_ON(!r || !*r);
-		return 0;
-	}
-	return *r == data;
-}
-
-/**
- * devm_regulator_unregister - Resource managed regulator_unregister()
- * @regulator: regulator to free
- *
- * Unregister a regulator registered with devm_regulator_register().
- * Normally this function will not need to be called and the resource
- * management code will ensure that the resource is freed.
- */
-void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev)
-{
-	int rc;
-
-	rc = devres_release(dev, devm_rdev_release, devm_rdev_match, rdev);
-	if (rc != 0)
-		WARN_ON(rc);
-}
-EXPORT_SYMBOL_GPL(devm_regulator_unregister);
-
 /**
  * regulator_suspend_prepare - prepare regulators for system wide suspend
  * @state: system suspend state
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
new file mode 100644
index 0000000..5891212
--- /dev/null
+++ b/drivers/regulator/devres.c
@@ -0,0 +1,252 @@
+/*
+ * devres.c  --  Voltage/Current Regulator framework devres implementation.
+ *
+ * Copyright 2013 Linaro Ltd
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/driver.h>
+#include <linux/module.h>
+
+#include "internal.h"
+
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
+/**
+ * devm_regulator_get - Resource managed regulator_get()
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get(). Regulators returned from this function are
+ * automatically regulator_put() on driver detach. See regulator_get() for more
+ * information.
+ */
+struct regulator *devm_regulator_get(struct device *dev, const char *id)
+{
+	return _devm_regulator_get(dev, id, NORMAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get);
+
+/**
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
+ * devm_regulator_get_optional - Resource managed regulator_get_optional()
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get_optional(). Regulators returned from this
+ * function are automatically regulator_put() on driver detach. See
+ * regulator_get_optional() for more information.
+ */
+struct regulator *devm_regulator_get_optional(struct device *dev,
+					      const char *id)
+{
+	return _devm_regulator_get(dev, id, OPTIONAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
+
+static int devm_regulator_match(struct device *dev, void *res, void *data)
+{
+	struct regulator **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+/**
+ * devm_regulator_put - Resource managed regulator_put()
+ * @regulator: regulator to free
+ *
+ * Deallocate a regulator allocated with devm_regulator_get(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_regulator_put(struct regulator *regulator)
+{
+	int rc;
+
+	rc = devres_release(regulator->dev, devm_regulator_release,
+			    devm_regulator_match, regulator);
+	if (rc != 0)
+		WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_put);
+
+/**
+ * devm_regulator_bulk_get - managed get multiple regulator consumers
+ *
+ * @dev:           Device to supply
+ * @num_consumers: Number of consumers to register
+ * @consumers:     Configuration of consumers; clients are stored here.
+ *
+ * @return 0 on success, an errno on failure.
+ *
+ * This helper function allows drivers to get several regulator
+ * consumers in one operation with management, the regulators will
+ * automatically be freed when the device is unbound.  If any of the
+ * regulators cannot be acquired then any regulators that were
+ * allocated will be freed before returning to the caller.
+ */
+int devm_regulator_bulk_get(struct device *dev, int num_consumers,
+			    struct regulator_bulk_data *consumers)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < num_consumers; i++)
+		consumers[i].consumer = NULL;
+
+	for (i = 0; i < num_consumers; i++) {
+		consumers[i].consumer = devm_regulator_get(dev,
+							   consumers[i].supply);
+		if (IS_ERR(consumers[i].consumer)) {
+			ret = PTR_ERR(consumers[i].consumer);
+			dev_err(dev, "Failed to get supply '%s': %d\n",
+				consumers[i].supply, ret);
+			consumers[i].consumer = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	for (i = 0; i < num_consumers && consumers[i].consumer; i++)
+		devm_regulator_put(consumers[i].consumer);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_get);
+
+static void devm_rdev_release(struct device *dev, void *res)
+{
+	regulator_unregister(*(struct regulator_dev **)res);
+}
+
+/**
+ * devm_regulator_register - Resource managed regulator_register()
+ * @regulator_desc: regulator to register
+ * @config: runtime configuration for regulator
+ *
+ * Called by regulator drivers to register a regulator.  Returns a
+ * valid pointer to struct regulator_dev on success or an ERR_PTR() on
+ * error.  The regulator will automaticall be released when the device
+ * is unbound.
+ */
+struct regulator_dev *devm_regulator_register(struct device *dev,
+				  const struct regulator_desc *regulator_desc,
+				  const struct regulator_config *config)
+{
+	struct regulator_dev **ptr, *rdev;
+
+	ptr = devres_alloc(devm_rdev_release, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	rdev = regulator_register(regulator_desc, config);
+	if (!IS_ERR(rdev)) {
+		*ptr = rdev;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return rdev;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_register);
+
+static int devm_rdev_match(struct device *dev, void *res, void *data)
+{
+	struct regulator_dev **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+/**
+ * devm_regulator_unregister - Resource managed regulator_unregister()
+ * @regulator: regulator to free
+ *
+ * Unregister a regulator registered with devm_regulator_register().
+ * Normally this function will not need to be called and the resource
+ * management code will ensure that the resource is freed.
+ */
+void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_rdev_release, devm_rdev_match, rdev);
+	if (rc != 0)
+		WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_unregister);
diff --git a/drivers/regulator/internal.h b/drivers/regulator/internal.h
new file mode 100644
index 0000000..84bbda1
--- /dev/null
+++ b/drivers/regulator/internal.h
@@ -0,0 +1,38 @@
+/*
+ * internal.h  --  Voltage/Current Regulator framework internal code
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ * Copyright 2008 SlimLogic Ltd.
+ *
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __REGULATOR_INTERNAL_H
+#define __REGULATOR_INTERNAL_H
+
+/*
+ * struct regulator
+ *
+ * One for each consumer device.
+ */
+struct regulator {
+	struct device *dev;
+	struct list_head list;
+	unsigned int always_on:1;
+	unsigned int bypass:1;
+	int uA_load;
+	int min_uV;
+	int max_uV;
+	char *supply_name;
+	struct device_attribute dev_attr;
+	struct regulator_dev *rdev;
+	struct dentry *debugfs;
+};
+
+#endif
-- 
1.8.4.rc3

