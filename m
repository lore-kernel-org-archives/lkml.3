Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaCWVDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:03:44 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:53588 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbaCWVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:03:41 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-179.messagelabs.com!1395608616!26673463!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <31eb9829645b11a109e7699d5da888ab7d2a68c1.1395607051.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1395607051.git.stwiss.opensource@diasemi.com>
References: <cover.1395607051.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Sun, 23 Mar 2014 20:37:30 +0000
Subject: [RFC V1 2/3] mfd: da9063: Add HWMON dependencies
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Rob Landley <rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Dependencies required for DA9063 HWMON support.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with linux-next/next-20140321/scripts/checkpatch.pl
 core.h                    total: 0 errors, 0 warnings, 100 lines checked
 pdata.h                   total: 0 errors, 0 warnings, 129 lines checked
 da9063-core.c             total: 0 errors, 0 warnings, 199 lines checked

This patch includes the following changes:

There are small changes to da9063-core.c to allow reading the temperature
trimming offset value from the PMIC register list. This value is passed
to HWMON and is used during its calculations of the PMIC's internal junction
temperature.

There are also changes to the platform data definitions so that values may
be set for the current sources ADCIN[123]_CUR. These are provided so that
they may be configured outside the driver.

This patch applies against linux-next and next-20140321

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/mfd/da9063-core.c        |   13 ++++++++++++-
 include/linux/mfd/da9063/core.h  |    3 +++
 include/linux/mfd/da9063/pdata.h |   18 ++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index e70ae31..24c1838 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -111,6 +111,7 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 {
 	struct da9063_pdata *pdata = da9063->dev->platform_data;
 	int model, variant_id, variant_code;
+	int t_offset = 0;
 	int ret;
 
 	if (pdata) {
@@ -171,8 +172,18 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 	ret = mfd_add_devices(da9063->dev, -1, da9063_devs,
 			      ARRAY_SIZE(da9063_devs), NULL, da9063->irq_base,
 			      NULL);
-	if (ret)
+	if (ret) {
 		dev_err(da9063->dev, "Cannot add MFD cells\n");
+		return ret;
+	}
+
+	ret = regmap_read(da9063->regmap, DA9063_REG_T_OFFSET, &t_offset);
+	if (ret < 0)
+		dev_warn(da9063->dev,
+			 "Temperature trimming value cannot be read (defaulting to 0)\n");
+
+	/* pass this on to the hwmon driver */
+	da9063->t_offset = t_offset;
 
 	return ret;
 }
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
index 00a9aac..7327d37 100644
--- a/include/linux/mfd/da9063/core.h
+++ b/include/linux/mfd/da9063/core.h
@@ -86,6 +86,9 @@ struct da9063 {
 	int		chip_irq;
 	unsigned int	irq_base;
 	struct regmap_irq_chip_data *regmap_irq;
+
+	/* Trimming */
+	int		t_offset;
 };
 
 int da9063_device_init(struct da9063 *da9063, unsigned int irq);
diff --git a/include/linux/mfd/da9063/pdata.h b/include/linux/mfd/da9063/pdata.h
index 95c8742..576033e 100644
--- a/include/linux/mfd/da9063/pdata.h
+++ b/include/linux/mfd/da9063/pdata.h
@@ -62,6 +62,23 @@ struct da9063_regulators_pdata {
 	struct da9063_regulator_data	*regulator_data;
 };
 
+/* HWMON platform data */
+#define DA9063_SET_ADCIN1_CUR_1UA	0x00
+#define DA9063_SET_ADCIN1_CUR_2UA	0x01
+#define DA9063_SET_ADCIN1_CUR_10UA	0x02
+#define DA9063_SET_ADCIN1_CUR_40UA	0x03
+#define DA9063_SET_ADCIN2_CUR_1UA	0x00
+#define DA9063_SET_ADCIN2_CUR_2UA	0x01
+#define DA9063_SET_ADCIN2_CUR_10UA	0x02
+#define DA9063_SET_ADCIN2_CUR_40UA	0x03
+#define DA9063_SET_ADCIN3_CUR_10UA	0x00
+
+struct da9063_hwmon_pdata {
+	unsigned char adcin1_cur;
+	unsigned char adcin2_cur;
+	unsigned char adcin3_cur;
+};
+
 
 /*
  * RGB LED configuration
@@ -106,6 +123,7 @@ struct da9063_pdata {
 	unsigned			flags;
 	struct da9063_regulators_pdata	*regulators_pdata;
 	struct led_platform_data	*leds_pdata;
+	struct da9063_hwmon_pdata	*hwmon_pdata;
 };
 
 #endif	/* __MFD_DA9063_PDATA_H__ */
-- 
end-of-patch for RFC V1

