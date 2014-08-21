Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaHUW1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:27:42 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:37857
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755356AbaHUW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:27:11 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 2/2] pmbus: ltc2978: add regulator gating
Date: Thu, 21 Aug 2014 17:21:26 -0500
Message-ID: <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(189002)(66066001)(77982001)(47776003)(76482001)(77156001)(31966008)(83322001)(102836001)(74502001)(101416001)(105586002)(80022001)(20776003)(87286001)(95666004)(81156004)(74662001)(106356001)(50466002)(64706001)(85306004)(85852003)(50226001)(107046002)(86362001)(93916002)(79102001)(46102001)(92566001)(86152002)(89996001)(4396001)(42186005)(83072002)(53416004)(69596002)(50986999)(87976001)(92726001)(104166001)(48376002)(19580405001)(21056001)(229853001)(77096002)(575784001)(99396002)(62966002)(81342001)(81542001)(76176999)(88136002)(19580395003)(33646002)(90102001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB320;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add support for enabling or disabling all supplies.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/hwmon/pmbus/Kconfig   |    9 ++++++
 drivers/hwmon/pmbus/ltc2978.c |   69 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index 6e1e493..c0d98f2 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -56,6 +56,15 @@ config SENSORS_LTC2978
 	  This driver can also be built as a module. If so, the module will
 	  be called ltc2978.
 
+config SENSORS_LTC2978_REGULATOR
+	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
+	default n
+	depends on SENSORS_LTC2978
+	select REGULATOR
+	help
+	  If you say yes here you get regulator support for Linear
+	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
+
 config SENSORS_MAX16064
 	tristate "Maxim MAX16064"
 	default n
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index e24ed52..1e25346 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -20,6 +20,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include "pmbus.h"
@@ -151,6 +153,66 @@ static int ltc2978_read_word_data_common(struct i2c_client *client, int page,
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+static int ltc2978_write_pmbus_operation(struct regulator_dev *rdev, u8 value)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	int ret;
+
+	ret = pmbus_set_page(client, 0xff);
+	if (ret < 0)
+		return ret;
+
+	return i2c_smbus_write_byte_data(client, PMBUS_OPERATION, value);
+}
+
+static int ltc2978_enable_all(struct regulator_dev *rdev)
+{
+	return ltc2978_write_pmbus_operation(rdev, 0x80);
+}
+
+static int ltc2978_disable_all(struct regulator_dev *rdev)
+{
+	return ltc2978_write_pmbus_operation(rdev, 0);
+}
+
+static int ltc2978_is_enabled(struct regulator_dev *rdev)
+{
+	struct device *dev = rdev_get_dev(rdev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	int ret;
+
+	ret = pmbus_set_page(client, 0xff);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_read_byte_data(client, PMBUS_OPERATION);
+	if (ret < 0)
+		return ret;
+
+	return !!(ret & 0x80);
+}
+
+static struct regulator_ops ltc2978_regulator_ops = {
+	.enable = ltc2978_enable_all,
+	.disable = ltc2978_disable_all,
+	.is_enabled = ltc2978_is_enabled,
+};
+
+static const struct regulator_desc ltc2978_reg_desc = {
+	.name = "ltc2978",
+	.ops = &ltc2978_regulator_ops,
+	.owner = THIS_MODULE,
+};
+
+static struct regulator_init_data ltc2978_regulator_init = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+};
+#endif
+
 static int ltc2978_read_word_data(struct i2c_client *client, int page, int reg)
 {
 	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
@@ -487,6 +549,13 @@ static int ltc2978_probe(struct i2c_client *client,
 	default:
 		return -ENODEV;
 	}
+
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+	info->num_regulators = 1;
+	info->reg_desc = &ltc2978_reg_desc;
+	info->reg_init = &ltc2978_regulator_init;
+#endif
+
 	return pmbus_do_probe(client, id, info);
 }
 
-- 
1.7.9.5

