Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab3DRCPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 22:15:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32777 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935812Ab3DRCPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 22:15:44 -0400
Message-ID: <1366251337.14376.2.camel@phoenix>
Subject: [PATCH RFC] regulator: core: Add regulator_map_voltage_ascend() API
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Apr 2013 10:15:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of regulator hardware has ascendant voltage list.
This patch adds regulator_map_voltage_ascend() and exports it.

Drivers that have ascendant voltage list can use this as their map_voltage()
operation, this is more efficient than default regulator_map_voltage_iterate()
function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c         |   28 ++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 23df943..fde1d47 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2265,6 +2265,34 @@ int regulator_map_voltage_iterate(struct regulator_dev *rdev,
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



