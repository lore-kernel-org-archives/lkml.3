Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaJBSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:44:34 -0400
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:22992
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbaJBSoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:44:15 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 4/4] pmbus: ltc2978: add regulator support
Date: Thu, 2 Oct 2014 13:37:51 -0500
Message-ID: <1412275071-6417-5-git-send-email-atull@opensource.altera.com>
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

Add simple on/off regulator support for ltc2978 and
other pmbus parts supported by ltc2978.c

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v2: Remove '#include <linux/regulator/machine.h>'
    Only one regulator per pmbus device
    Get regulator_init_data from pdata or device tree

v3: Support multiple regulators for each chip
    Move most code to pmbus_core.c
    fixed values for on/off

v4: fix a #endif comment
    simplify probe code, remove added switch statement
    remove BUG_ON(), add error message and fix num_regulators

v5: Kconfig: update list of supported chips
    use "regulator: of: Provide simplified DT parsing method"
    remove #include <linux/regulator/of_regulator.h>
    remove of_regulator_match
---
 drivers/hwmon/pmbus/Kconfig   |   11 +++++++++--
 drivers/hwmon/pmbus/ltc2978.c |   24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index 6e1e493..a674cd8 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -47,15 +47,22 @@ config SENSORS_LM25066
 	  be called lm25066.
 
 config SENSORS_LTC2978
-	tristate "Linear Technologies LTC2974, LTC2978, LTC3880, and LTC3883"
+	tristate "Linear Technologies LTC2978 and compatibles"
 	default n
 	help
 	  If you say yes here you get hardware monitoring support for Linear
-	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
+	  Technology LTC2974, LTC2977, LTC2978, LTC3880, LTC3883, and LTM4676.
 
 	  This driver can also be built as a module. If so, the module will
 	  be called ltc2978.
 
+config SENSORS_LTC2978_REGULATOR
+	boolean "Regulator support for LTC2978 and compatibles"
+	depends on SENSORS_LTC2978 && REGULATOR
+	help
+	  If you say yes here you get regulator support for Linear
+	  Technology LTC2974, LTC2977, LTC2978, LTC3880, LTC3883, and LTM4676.
+
 config SENSORS_MAX16064
 	tristate "Maxim MAX16064"
 	default n
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index e24ed52..efac4bf 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/regulator/driver.h>
 #include "pmbus.h"
 
 enum chips { ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676 };
@@ -374,6 +375,19 @@ static const struct i2c_device_id ltc2978_id[] = {
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
+#endif /* CONFIG_SENSORS_LTC2978_REGULATOR */
+
 static int ltc2978_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -487,6 +501,16 @@ static int ltc2978_probe(struct i2c_client *client,
 	default:
 		return -ENODEV;
 	}
+
+#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
+	info->num_regulators = info->pages;
+	info->reg_desc = ltc2978_reg_desc;
+	if (info->num_regulators > ARRAY_SIZE(ltc2978_reg_desc)) {
+		dev_err(&client->dev, "num_regulators too large!");
+		info->num_regulators = ARRAY_SIZE(ltc2978_reg_desc);
+	}
+#endif
+
 	return pmbus_do_probe(client, id, info);
 }
 
-- 
1.7.9.5

