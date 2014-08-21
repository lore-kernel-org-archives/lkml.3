Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaHUW1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:27:12 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:37857
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755336AbaHUW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:27:10 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 1/2] pmbus: add regulator support
Date: Thu, 21 Aug 2014 17:21:25 -0500
Message-ID: <1408659686-29106-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA061.namprd04.prod.outlook.com (10.141.154.179) To
 DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(189002)(66066001)(77982001)(47776003)(76482001)(77156001)(31966008)(83322001)(102836001)(74502001)(101416001)(105586002)(80022001)(20776003)(87286001)(95666004)(81156004)(74662001)(106356001)(50466002)(64706001)(85306004)(85852003)(50226001)(107046002)(86362001)(93916002)(79102001)(46102001)(92566001)(86152002)(89996001)(4396001)(42186005)(83072002)(53416004)(69596002)(50986999)(87976001)(92726001)(104166001)(48376002)(19580405001)(21056001)(229853001)(77096002)(99396002)(62966002)(81342001)(81542001)(76176999)(88136002)(19580395003)(33646002)(90102001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB320;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Enable pmbus device drivers to add regulator functionality.

To add a regulator, it's pretty straightforward.  The pmbus
device driver needs to add regulator information to its
pmbus_driver_info struct:

 * num_regulators : number of regulators
 * reg_init       : array of struct regulator_init_data
 * reg_desc       : array of struct regulator_desc

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/hwmon/pmbus/pmbus.h      |    7 +++++++
 drivers/hwmon/pmbus/pmbus_core.c |   40 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index fa9beb3..a45722f 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -19,6 +19,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/regulator/driver.h>
+
 #ifndef PMBUS_H
 #define PMBUS_H
 
@@ -365,6 +367,11 @@ struct pmbus_driver_info {
 	 */
 	int (*identify)(struct i2c_client *client,
 			struct pmbus_driver_info *info);
+
+	/* Regulator functionality, if supported by this chip driver. */
+	int num_regulators;
+	struct regulator_init_data *reg_init;
+	const struct regulator_desc *reg_desc;
 };
 
 /* Function declarations */
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 291d11f..10315ee 100644
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
@@ -1727,6 +1729,39 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_REGULATOR)
+static int pmbus_register_regulators(struct pmbus_data *data)
+{
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+	const struct pmbus_driver_info *info = data->info;
+	struct device *dev = data->dev;
+	int i;
+
+	config.dev = dev;
+	config.driver_data = data;
+
+	for (i = 0; i < info->num_regulators; i++) {
+		config.init_data = &info->reg_init[i];
+		rdev = devm_regulator_register(dev, &info->reg_desc[i],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(dev, "failed to register regulator %s\n",
+				info->reg_desc[i].name);
+			hwmon_device_unregister(data->hwmon_dev);
+			return PTR_ERR(rdev);
+		}
+	}
+
+	return 0;
+}
+#else
+static int pmbus_register_regulators(struct pmbus_data *data)
+{
+	return 0;
+}
+#endif
+
 int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		   struct pmbus_driver_info *info)
 {
@@ -1781,6 +1816,11 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
 		dev_err(dev, "Failed to register hwmon device\n");
 		goto out_kfree;
 	}
+
+	ret = pmbus_register_regulators(data);
+	if (ret)
+		goto out_kfree;
+
 	return 0;
 
 out_kfree:
-- 
1.7.9.5

