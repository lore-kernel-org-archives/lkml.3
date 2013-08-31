Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3HaL3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40088 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3HaL3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:33 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:16 +0100
Message-Id: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 01/11] regulator: core: Provide managed regulator registration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Many regulator drivers have a remove function that consists solely of
calling regulator_unregister() so provide a devm_regulator_register()
in order to allow this repeated code to be removed and help eliminate
error handling code.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c         | 66 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |  5 +++
 2 files changed, 71 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3..5f995d2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3492,6 +3492,44 @@ clean:
 }
 EXPORT_SYMBOL_GPL(regulator_register);
 
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
 /**
  * regulator_unregister - unregister regulator
  * @rdev: regulator to unregister
@@ -3521,6 +3559,34 @@ void regulator_unregister(struct regulator_dev *rdev)
 }
 EXPORT_SYMBOL_GPL(regulator_unregister);
 
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
+
 /**
  * regulator_suspend_prepare - prepare regulators for system wide suspend
  * @state: system suspend state
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 67e13aa..8474c7f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -334,7 +334,12 @@ struct regulator_dev {
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *config);
+struct regulator_dev *
+devm_regulator_register(struct device *dev,
+			const struct regulator_desc *regulator_desc,
+			const struct regulator_config *config);
 void regulator_unregister(struct regulator_dev *rdev);
+void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev);
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
-- 
1.8.4.rc3

