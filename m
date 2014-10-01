Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaJATMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:12:13 -0400
Received: from mail-bn1bon0097.outbound.protection.outlook.com ([157.56.111.97]:22688
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751283AbaJATMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:12:09 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 3/4] pmbus: add regulator support
Date: Wed, 1 Oct 2014 14:05:49 -0500
Message-ID: <1412190349-16343-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(20776003)(64706001)(47776003)(88136002)(80022003)(85852003)(50466002)(50226001)(48376002)(77156001)(33646002)(229853001)(107046002)(66066001)(87976001)(87286001)(76482002)(89996001)(42186005)(105586002)(81156004)(69596002)(106356001)(102836001)(53416004)(99396003)(86362001)(120916001)(85306004)(86152002)(62966002)(92726001)(92566001)(10300001)(21056001)(93916002)(101416001)(97736003)(77096002)(50986999)(46102003)(19580405001)(95666004)(31966008)(76176999)(104166001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add support for simple on/off control of each channel.

To add regulator support, the pmbus part driver needs to add
regulator_desc information, of_regulator_match information,
and number of regulators to its pmbus_driver_info struct.

regulator_desc can be declared using default macro for a
regulator (PMBUS_REGULATOR) that is in pmbus.h

The regulator_init_data can be intialized from either
platform data or the device tree.

Signed-off-by: Alan Tull <atull@opensource.altera.com>

v2: Remove '#include <linux/regulator/machine.h>'
    Only one regulator per pmbus device
    Get regulator_init_data from pdata or device tree

v3: Support multiple regulators for each chip
    Move most code to pmbus_core.c
    fixed values for on/off

v4: rename _pmbus_regulator_enable to _pmbus_regulator_on_off
    simplify _pmbus_regulator_on_off code
    s/regulator_regulator/regulator/
    fix break when !CONFIG_REGULATOR
    remove unused #define PB_OPERATION_CONTROL_SEQ_OFF
---
 drivers/hwmon/pmbus/pmbus.h      |   26 ++++++++
 drivers/hwmon/pmbus/pmbus_core.c |  129 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pmbus.h        |    4 ++
 3 files changed, 159 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index fa9beb3..64b44a1 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -19,6 +19,9 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
 #ifndef PMBUS_H
 #define PMBUS_H
 
@@ -186,6 +189,11 @@
 #define PMBUS_VIRT_STATUS_VMON		(PMBUS_VIRT_BASE + 35)
 
 /*
+ * OPERATION
+ */
+#define PB_OPERATION_CONTROL_ON		(1<<7)
+
+/*
  * CAPABILITY
  */
 #define PB_CAPABILITY_SMBALERT		(1<<4)
@@ -365,8 +373,26 @@ struct pmbus_driver_info {
 	 */
 	int (*identify)(struct i2c_client *client,
 			struct pmbus_driver_info *info);
+
+	/* Regulator functionality, if supported by this chip driver. */
+	int num_regulators;
+	const struct regulator_desc *reg_desc;
+	struct of_regulator_match *reg_matches;
 };
 
+/* Regulator ops */
+
+extern struct regulator_ops pmbus_regulator_ops;
+
+/* Macro for filling in array of struct regulator_desc */
+#define PMBUS_REGULATOR(_name, _id)				\
+	[_id] = {						\
+		.name = (_name # _id),				\
+		.id = (_id),					\
+		.ops = &pmbus_regulator_ops,			\
+		.owner = THIS_MODULE,				\
+	}
+
 /* Function declarations */
 
 void pmbus_clear_cache(struct i2c_client *client);
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index d6c3701..a8a5cee 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -29,6 +29,9 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/jiffies.h>
 #include <linux/i2c/pmbus.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
 #include "pmbus.h"
 
 /*
@@ -1758,6 +1761,125 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_REGULATOR)
+static int pmbus_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	u8 page = rdev_get_id(rdev);
+	int ret;
+
+	ret = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+	if (ret < 0)
+		return ret;
+
+	return !!(ret & PB_OPERATION_CONTROL_ON);
+}
+
+static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool enable)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	u8 page = rdev_get_id(rdev);
+
+	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
+				      PB_OPERATION_CONTROL_ON,
+				      enable ? PB_OPERATION_CONTROL_ON : 0);
+}
+
+static int pmbus_regulator_enable(struct regulator_dev *rdev)
+{
+	return _pmbus_regulator_on_off(rdev, 1);
+}
+
+static int pmbus_regulator_disable(struct regulator_dev *rdev)
+{
+	return _pmbus_regulator_on_off(rdev, 0);
+}
+
+struct regulator_ops pmbus_regulator_ops = {
+	.enable = pmbus_regulator_enable,
+	.disable = pmbus_regulator_disable,
+	.is_enabled = pmbus_regulator_is_enabled,
+};
+EXPORT_SYMBOL_GPL(pmbus_regulator_ops);
+
+#if IS_ENABLED(CONFIG_OF)
+static int pmbus_regulator_parse_dt(struct device *dev,
+				    const struct pmbus_driver_info *info)
+{
+	struct device_node *np_regulators;
+	int ret;
+
+	if (!info->num_regulators)
+		return 0;
+
+	if (!info->reg_matches || !info->reg_desc)
+		return -EINVAL;
+
+	np_regulators = of_get_child_by_name(dev->of_node, "regulators");
+	if (!np_regulators)
+		return 0;
+
+	ret = of_regulator_match(dev, np_regulators, info->reg_matches,
+				 info->num_regulators);
+	of_node_put(np_regulators);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+#else
+static int pmbus_regulator_parse_dt(struct device *dev,
+				    const struct pmbus_driver_info *info)
+{
+	return 0;
+}
+#endif
+
+static int pmbus_regulator_register(struct pmbus_data *data)
+{
+	struct device *dev = data->dev;
+	const struct pmbus_driver_info *info = data->info;
+	const struct pmbus_platform_data *pdata = dev_get_platdata(dev);
+	struct regulator_dev *rdev;
+	int ret, i;
+
+	ret = pmbus_regulator_parse_dt(dev, info);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < info->num_regulators; i++) {
+		struct regulator_config config = { };
+
+		config.dev = dev;
+		config.driver_data = data;
+
+		if (pdata && pdata->reg_init_data) {
+			config.init_data = &pdata->reg_init_data[i];
+		} else {
+			config.init_data = info->reg_matches[i].init_data;
+			config.of_node = info->reg_matches[i].of_node;
+		}
+
+		rdev = devm_regulator_register(dev, &info->reg_desc[i],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(dev, "Failed to register %s regulator\n",
+				info->reg_desc[i].name);
+			return PTR_ERR(rdev);
+		}
+	}
+
+	return 0;
+}
+#else
+static int pmbus_regulator_register(struct pmbus_data *data)
+{
+	return 0;
+}
+#endif
+
 int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		   struct pmbus_driver_info *info)
 {
@@ -1812,8 +1934,15 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		dev_err(dev, "Failed to register hwmon device\n");
 		goto out_kfree;
 	}
+
+	ret = pmbus_regulator_register(data);
+	if (ret)
+		goto out_unregister;
+
 	return 0;
 
+out_unregister:
+	hwmon_device_unregister(data->hwmon_dev);
 out_kfree:
 	kfree(data->group.attrs);
 	return ret;
diff --git a/include/linux/i2c/pmbus.h b/include/linux/i2c/pmbus.h
index 69280db..ee3c2ab 100644
--- a/include/linux/i2c/pmbus.h
+++ b/include/linux/i2c/pmbus.h
@@ -40,6 +40,10 @@
 
 struct pmbus_platform_data {
 	u32 flags;		/* Device specific flags */
+
+	/* regulator support */
+	int num_regulators;
+	struct regulator_init_data *reg_init_data;
 };
 
 #endif /* _PMBUS_H_ */
-- 
1.7.9.5

