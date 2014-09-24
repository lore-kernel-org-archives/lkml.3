Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaIXSVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:21:42 -0400
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:50176
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753941AbaIXSVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:21:40 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
Date: Wed, 24 Sep 2014 12:57:56 -0500
Message-ID: <1411581476-12222-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0046.namprd02.prod.outlook.com (10.141.56.46) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB312;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(50226001)(19580405001)(83322001)(19580395003)(87976001)(69596002)(50466002)(77156001)(102836001)(42186005)(48376002)(10300001)(50986999)(104166001)(62966002)(85306004)(105586002)(76176999)(97736003)(106356001)(88136002)(81542003)(47776003)(20776003)(87286001)(101416001)(77096002)(76482002)(120916001)(93916002)(86362001)(85852003)(86152002)(79102003)(90102001)(107046002)(92566001)(53416004)(66066001)(74662003)(31966008)(77982003)(33646002)(89996001)(81156004)(81342003)(21056001)(92726001)(64706001)(80022003)(229853001)(95666004)(99396003)(46102003)(74502003)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB312;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add simple on/off regulator support for ltc2978 and
other pmbus parts supported by ltc2978.c

Signed-off-by: Alan Tull <atull@opensource.altera.com>

v2: Remove '#include <linux/regulator/machine.h>'
    Only one regulator per pmbus device
    Get regulator_init_data from pdata or device tree

v3: Support multiple regulators for each chip
    Move most code to pmbus_core.c
    fixed values for on/off
---
 drivers/hwmon/pmbus/Kconfig   |    7 ++++++
 drivers/hwmon/pmbus/ltc2978.c |   51 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

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
index e24ed52..7d4dcd7 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -22,6 +22,8 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
 #include "pmbus.h"
 
 enum chips { ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676 };
@@ -374,6 +376,30 @@ static const struct i2c_device_id ltc2978_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ltc2978_id);
 
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+static const struct regulator_desc ltc2978_reg_desc[] = {
+	PMBUS_REGULATOR("vout_en", 0),
+	PMBUS_REGULATOR("vout_en", 1),
+	PMBUS_REGULATOR("vout_en", 2),
+	PMBUS_REGULATOR("vout_en", 3),
+	PMBUS_REGULATOR("vout_en", 4),
+	PMBUS_REGULATOR("vout_en", 5),
+	PMBUS_REGULATOR("vout_en", 6),
+	PMBUS_REGULATOR("vout_en", 7),
+};
+
+static struct of_regulator_match ltc2978_reg_matches[] = {
+	{ .name = "vout_en0" },
+	{ .name = "vout_en1" },
+	{ .name = "vout_en2" },
+	{ .name = "vout_en3" },
+	{ .name = "vout_en4" },
+	{ .name = "vout_en5" },
+	{ .name = "vout_en6" },
+	{ .name = "vout_en7" },
+};
+#endif /* CONFIG_REGULATOR */
+
 static int ltc2978_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -487,6 +513,31 @@ static int ltc2978_probe(struct i2c_client *client,
 	default:
 		return -ENODEV;
 	}
+
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+	info->reg_desc = ltc2978_reg_desc;
+	info->reg_matches = ltc2978_reg_matches;
+
+	switch (data->id) {
+	case ltc2974:
+		info->num_regulators = LTC2974_NUM_PAGES;
+		break;
+	case ltc2977:
+	case ltc2978:
+		info->num_regulators = LTC2978_NUM_PAGES;
+		break;
+	case ltc3880:
+	case ltm4676:
+		info->num_regulators = LTC3880_NUM_PAGES;
+		break;
+	case ltc3883:
+		info->num_regulators = LTC3883_NUM_PAGES;
+		break;
+	default:
+		return -ENODEV;
+	}
+	BUG_ON(info->num_regulators > ARRAY_SIZE(ltc2978_reg_desc));
+#endif
 	return pmbus_do_probe(client, id, info);
 }
 
-- 
1.7.9.5

