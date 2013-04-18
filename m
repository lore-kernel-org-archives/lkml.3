Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab3DRCe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 22:34:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50566 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940Ab3DRCez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 22:34:55 -0400
Message-ID: <1366252489.17095.1.camel@phoenix>
Subject: [PATCH RFC v2] regulator: core: Add regulator_map_voltage_ascend()
 API
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Apr 2013 10:34:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of regulator hardware has ascendant voltage list.
This patch adds regulator_map_voltage_ascend() and export it.

Drivers that have ascendant voltage list can use this as their map_voltage()
operation, this is more efficient than default regulator_map_voltage_iterate()
function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2:
Since the voltage list is in ascendant order, and we iterate the list from the
smallest voltage. So it is safe to break out if the voltage is greater than max_uV.

 drivers/regulator/core.c         |   31 +++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 23df943..944d172 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2265,6 +2265,37 @@ int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 EXPORT_SYMBOL_GPL(regulator_map_voltage_iterate);
 
 /**
+ * regulator_map_voltage_ascend - map_voltage() for ascendant voltage list
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers that have ascendant voltage list can use this as their
+ * map_voltage() operation.
+ */
+int regulator_map_voltage_ascend(struct regulator_dev *rdev,
+				 int min_uV, int max_uV)
+{
+	int i, ret;
+
+	for (i = 0; i < rdev->desc->n_voltages; i++) {
+		ret = rdev->desc->ops->list_voltage(rdev, i);
+		if (ret < 0)
+			continue;
+
+		if (ret > max_uV)
+			break;
+
+		if (ret >= min_uV && ret <= max_uV)
+			return i;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_ascend);
+
+/**
  * regulator_map_voltage_linear - map_voltage() for simple linear mappings
  *
  * @rdev: Regulator to operate on
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 5e2d13d..6700cc9 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -332,6 +332,8 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
 int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
+int regulator_map_voltage_ascend(struct regulator_dev *rdev,
+				  int min_uV, int max_uV);
 int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev);
 int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel);
 int regulator_is_enabled_regmap(struct regulator_dev *rdev);
-- 
1.7.10.4



