Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaJaE2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:28:19 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52659 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaJaE1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:27:21 -0400
From: Tim Harvey <tharvey@gateworks.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, linux-pm@vger.kernel.org
Subject: [PATCH 2/5] regulator: add function to determine if a regulator is in bypass mode
Date: Thu, 30 Oct 2014 21:27:08 -0700
Message-Id: <1414729631-11005-3-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators can be configured to allow bypass mode and can be told by a consumer 
that they are allowed to go into bypass mode from that consumer's perspective.
This adds a function to determine if the regulator actually has gone into
bypass mode (meaning all consumers allowed it to do so).

Cc: linux-pm@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/regulator/core.c           | 23 +++++++++++++++++++++++
 include/linux/regulator/consumer.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6d4a627..904c271 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3150,6 +3150,29 @@ int regulator_allow_bypass(struct regulator *regulator, bool enable)
 EXPORT_SYMBOL_GPL(regulator_allow_bypass);
 
 /**
+ * regulator_is_bypass - determine if a regulator is in bypass mode
+ *
+ * @regulator: Regulator to configure
+ *
+ * return positive if regulator is in bypass mode.
+ */
+int regulator_is_bypass(struct regulator *regulator)
+{
+	struct regulator_dev *rdev = regulator->rdev;
+	int ret;
+
+	if (!regulator)
+		return -EINVAL;
+
+	mutex_lock(&rdev->mutex);
+	ret = regulator->bypass ? 1 : 0;
+	mutex_unlock(&rdev->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_is_bypass);
+
+/**
  * regulator_register_notifier - register regulator event notifier
  * @regulator: regulator source
  * @nb: notifier block
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 972090a..a766946 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -237,6 +237,7 @@ unsigned int regulator_get_mode(struct regulator *regulator);
 int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
 
 int regulator_allow_bypass(struct regulator *regulator, bool allow);
+int regulator_is_bypass(struct regulator *regulator);
 
 struct regmap *regulator_get_regmap(struct regulator *regulator);
 int regulator_get_hardware_vsel_register(struct regulator *regulator,
@@ -493,6 +494,11 @@ static inline int regulator_allow_bypass(struct regulator *regulator,
 	return 0;
 }
 
+static inline int regulator_is_bypass(struct regulator *regulator)
+{
+	return 0;
+}
+
 static inline struct regmap *regulator_get_regmap(struct regulator *regulator)
 {
 	return ERR_PTR(-EOPNOTSUPP);
-- 
1.8.3.2

