Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaHVVRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:17:05 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:39406
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbaHVVRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:17:01 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 2/2] pmbus: ltc2978: add regulator gating
Date: Fri, 22 Aug 2014 16:11:34 -0500
Message-ID: <1408741894-24879-3-git-send-email-atull@opensource.altera.com>
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

Add regulator with support for enabling or disabling all
supplies.

Signed-off-by: Alan Tull <atull@opensource.altera.com>

v2:  Remove '#include <linux/regulator/machine.h>'
     Kconfig fixes
     Remove hardwired regulator_init_data
---
 drivers/hwmon/pmbus/Kconfig   |    7 +++++
 drivers/hwmon/pmbus/ltc2978.c |   60 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index 6e1e493..79117b7 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -56,6 +56,13 @@ config SENSORS_LTC2978
 	  This driver can also be built as a module. If so, the module will
 	  be called ltc2978.
 
+config SENSORS_LTC2978_REGULATOR
+	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
+	depends on SENSORS_LTC2978 && REGULATOR
+	help
+	  If you say yes here you get regulator support for Linear
+	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
+
 config SENSORS_MAX16064
 	tristate "Maxim MAX16064"
 	default n
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index e24ed52..2bdcfe2 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/regulator/driver.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include "pmbus.h"
@@ -151,6 +152,60 @@ static int ltc2978_read_word_data_common(struct i2c_client *client, int page,
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
+#endif
+
 static int ltc2978_read_word_data(struct i2c_client *client, int page, int reg)
 {
 	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
@@ -487,6 +542,11 @@ static int ltc2978_probe(struct i2c_client *client,
 	default:
 		return -ENODEV;
 	}
+
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+	info->reg_desc = &ltc2978_reg_desc;
+#endif
+
 	return pmbus_do_probe(client, id, info);
 }
 
-- 
1.7.9.5

