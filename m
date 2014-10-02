Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaJBSoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:44:17 -0400
Received: from mail-bl2on0062.outbound.protection.outlook.com ([65.55.169.62]:1758
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbaJBSoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:44:12 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 3/4] pmbus: add regulator support
Date: Thu, 2 Oct 2014 13:37:50 -0500
Message-ID: <1412275071-6417-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA048.namprd06.prod.outlook.com (10.141.250.166) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966002)(77156001)(81156004)(85852003)(89996001)(120916001)(105586002)(77096002)(107046002)(76482002)(106356001)(31966008)(10300001)(88136002)(87286001)(20776003)(47776003)(99396003)(64706001)(87976001)(101416001)(33646002)(21056001)(229853001)(66066001)(104166001)(93916002)(86362001)(53416004)(102836001)(97736003)(69596002)(42186005)(50466002)(92726001)(48376002)(95666004)(46102003)(80022003)(85306004)(50226001)(92566001)(50986999)(76176999)(4396001)(86152002)(19580405001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add support for simple on/off control of each channel.

To add regulator support, the pmbus part driver needs to add
regulator_desc information and number of regulators to its
pmbus_driver_info struct.

regulator_desc can be declared using default macro for a
regulator (PMBUS_REGULATOR) that is in pmbus.h

The regulator_init_data can be intialized from either
platform data or the device tree.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
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

v5: use "regulator: of: Provide simplified DT parsing method"
    remove #include <linux/regulator/of_regulator.h>
    remove of_regulator_match structure in pmbus_driver_info
    add of_match and regulators_node for regulator_desc macro
    remove pmbus_regulator_parse_dt
    remove unneeded 'else' that set init_data and of_node
---
 drivers/hwmon/pmbus/pmbus.h      |   26 ++++++++++++
 drivers/hwmon/pmbus/pmbus_core.c |   87 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pmbus.h        |    4 ++
 3 files changed, 117 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index 3ae79a7..89a23ff 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -19,6 +19,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/regulator/driver.h>
+
 #ifndef PMBUS_H
 #define PMBUS_H
 
@@ -186,6 +188,11 @@
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
@@ -365,8 +372,27 @@ struct pmbus_driver_info {
 	 */
 	int (*identify)(struct i2c_client *client,
 			struct pmbus_driver_info *info);
+
+	/* Regulator functionality, if supported by this chip driver. */
+	int num_regulators;
+	const struct regulator_desc *reg_desc;
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
+		.of_match = of_match_ptr(_name # _id),		\
+		.regulators_node = of_match_ptr("regulators"),	\
+		.ops = &pmbus_regulator_ops,			\
+		.owner = THIS_MODULE,				\
+	}
+
 /* Function declarations */
 
 void pmbus_clear_cache(struct i2c_client *client);
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index d6c3701..f2e47c7 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -29,6 +29,8 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/jiffies.h>
 #include <linux/i2c/pmbus.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
 #include "pmbus.h"
 
 /*
@@ -1758,6 +1760,84 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
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
+static int pmbus_regulator_register(struct pmbus_data *data)
+{
+	struct device *dev = data->dev;
+	const struct pmbus_driver_info *info = data->info;
+	const struct pmbus_platform_data *pdata = dev_get_platdata(dev);
+	struct regulator_dev *rdev;
+	int i;
+
+	for (i = 0; i < info->num_regulators; i++) {
+		struct regulator_config config = { };
+
+		config.dev = dev;
+		config.driver_data = data;
+
+		if (pdata && pdata->reg_init_data)
+			config.init_data = &pdata->reg_init_data[i];
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
@@ -1812,8 +1892,15 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
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

