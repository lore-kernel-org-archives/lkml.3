Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3G3LrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:47:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38665 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3G3LrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:47:01 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 30 Jul 2013 12:46:13 +0100
Message-Id: <1375184777-25404-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/5] regulator: core: Provide hints to the core about optional supplies
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

While the majority of supplies on devices are mandatory and can't be
physically omitted for electrical reasons some devices do have optional
supplies and need to know if they are missing, MMC being the most common
of these.

Currently the core accurately reports all errors when regulators are
requested since it does not know if the supply is one that must be provided
even if by a regulator software does not know about or if it is one that
may genuinely be disconnected. In order to allow this behaviour to be
changed and stub regulators to be provided in the former case add a new
regulator request function regulator_get_optional() which provides a hint
to the core that the regulator may genuinely not be connected.

Currently the implementation is identical to the current behaviour, future
patches will add support in the core for returning stub regulators in the
case where normal regulator_get() fails and the board has requested it.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c           | 59 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h | 18 +++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 61e4060..f24f401 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1414,6 +1414,65 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
+/**
+ * regulator_get_optional - obtain optional access to a regulator.
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.  Other consumers will be
+ * unable to obtain this reference is held and the use count for the
+ * regulator will be initialised to reflect the current state of the
+ * regulator.
+ *
+ * This is intended for use by consumers for devices which can have
+ * some supplies unconnected in normal use, such as some MMC devices.
+ * It can allow the regulator core to provide stub supplies for other
+ * supplies requested using normal regulator_get() calls without
+ * disrupting the operation of drivers that can handle absent
+ * supplies.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *regulator_get_optional(struct device *dev, const char *id)
+{
+	return _regulator_get(dev, id, 0);
+}
+EXPORT_SYMBOL_GPL(regulator_get_optional);
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
+	struct regulator **ptr, *regulator;
+
+	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	regulator = regulator_get_optional(dev, id);
+	if (!IS_ERR(regulator)) {
+		*ptr = regulator;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return regulator;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
+
 /* Locks held by regulator_put() */
 static void _regulator_put(struct regulator *regulator)
 {
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 1ccc889..2582e41 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -137,6 +137,10 @@ struct regulator *__must_check devm_regulator_get(struct device *dev,
 					     const char *id);
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
+struct regulator *__must_check regulator_get_optional(struct device *dev,
+						      const char *id);
+struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
+							   const char *id);
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
@@ -212,14 +216,26 @@ static inline struct regulator *__must_check regulator_get(struct device *dev,
 }
 
 static inline struct regulator *__must_check
+devm_regulator_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct regulator *__must_check
 regulator_get_exclusive(struct device *dev, const char *id)
 {
 	return NULL;
 }
 
+static inline struct regulator *__must_check
+regulator_get_optional(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
 
 static inline struct regulator *__must_check
-devm_regulator_get(struct device *dev, const char *id)
+devm_regulator_get_optional(struct device *dev, const char *id)
 {
 	return NULL;
 }
-- 
1.8.3.2

