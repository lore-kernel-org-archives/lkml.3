Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaHVVRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:17:00 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:39178
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbaHVVQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:16:58 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 1/2] pmbus: add regulator support
Date: Fri, 22 Aug 2014 16:11:33 -0500
Message-ID: <1408741894-24879-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA041.namprd06.prod.outlook.com (10.242.160.31) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(189002)(33646002)(48376002)(85852003)(4396001)(87976001)(19580395003)(20776003)(87286001)(81542001)(81342001)(83322001)(92566001)(83072002)(50226001)(21056001)(92726001)(95666004)(62966002)(81156004)(50466002)(106356001)(105586002)(90102001)(64706001)(19580405001)(229853001)(66066001)(99396002)(69596002)(47776003)(79102001)(86152002)(77156001)(77982001)(31966008)(53416004)(107046002)(102836001)(89996001)(77096002)(74662001)(76482001)(74502001)(42186005)(76176999)(85306004)(80022001)(86362001)(101416001)(46102001)(50986999)(104166001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

To add a regulator, the pmbus device driver needs to add
regulator_desc information to its pmbus_driver_info struct.
The regulator_init_data can be intialized from either
platform data or the device tree.

Signed-off-by: Alan Tull <atull@opensource.altera.com>

v2: Remove '#include <linux/regulator/machine.h>'
    Only one regulator per pmbus device
    Get regulator_init_data from pdata or device tree
---
 drivers/hwmon/pmbus/pmbus.h      |    5 ++++
 drivers/hwmon/pmbus/pmbus_core.c |   51 ++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pmbus.h        |    1 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index fa9beb3..93fadc3 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -19,6 +19,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/regulator/driver.h>
+
 #ifndef PMBUS_H
 #define PMBUS_H
 
@@ -365,6 +367,9 @@ struct pmbus_driver_info {
 	 */
 	int (*identify)(struct i2c_client *client,
 			struct pmbus_driver_info *info);
+
+	/* Regulator functionality, if supported by this chip driver. */
+	const struct regulator_desc *reg_desc;
 };
 
 /* Function declarations */
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 291d11f..472baff 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -29,6 +29,8 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/jiffies.h>
 #include <linux/i2c/pmbus.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/driver.h>
 #include "pmbus.h"
 
 /*
@@ -1727,6 +1729,48 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_REGULATOR)
+static int pmbus_regulator_register(struct pmbus_data *data,
+				    const struct pmbus_platform_data *pdata)
+{
+	struct device *dev = data->dev;
+	struct device_node *np = dev->of_node;
+	const struct pmbus_driver_info *info = data->info;
+	const struct regulator_desc *reg_desc = info->reg_desc;
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+
+	if (!reg_desc)
+		return 0;
+
+	if (pdata && pdata->reg_init_data) {
+		config.init_data = pdata->reg_init_data;
+	} else {
+		config.init_data = of_get_regulator_init_data(dev, np);
+		if (!config.init_data)
+			return -ENOMEM;
+	}
+
+	config.dev = dev;
+	config.driver_data = data;
+
+	rdev = devm_regulator_register(dev, reg_desc, &config);
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register regulator %s\n",
+			reg_desc->name);
+		return PTR_ERR(rdev);
+	}
+
+	return 0;
+}
+#else
+static int pmbus_regulator_register(struct pmbus_data *data,
+				    const struct pmbus_platform_data *pdata)
+{
+	return 0;
+}
+#endif
+
 int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		   struct pmbus_driver_info *info)
 {
@@ -1781,8 +1825,15 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		dev_err(dev, "Failed to register hwmon device\n");
 		goto out_kfree;
 	}
+
+	ret = pmbus_regulator_register(data, pdata);
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
index 69280db..15e08da 100644
--- a/include/linux/i2c/pmbus.h
+++ b/include/linux/i2c/pmbus.h
@@ -40,6 +40,7 @@
 
 struct pmbus_platform_data {
 	u32 flags;		/* Device specific flags */
+	struct regulator_init_data *reg_init_data;
 };
 
 #endif /* _PMBUS_H_ */
-- 
1.7.9.5

