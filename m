Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaBMKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:31:40 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:47994 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbaBMKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:31:38 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-8.tower-179.messagelabs.com!1392287495!24512441!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Thu, 13 Feb 2014 09:43:05 +0000
Subject: [RFC V1] mfd: da9063: Add support for production silicon variant code
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Add the correct silicon variant code ID (0x5) to the driver. This
new code is the 'production' variant code ID for DA9063.
 
This patch will remove the older variant code ID which matches the
pre-production silicon ID (0x3) for the DA9063 chip.

There is also some small amount of correction done in this patch: it
renames various incorrectly named variables and moves the dev_info()
call before the variant ID test.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140213/scripts/checkpatch.pl
 da9063-core.c             total: 0 errors, 0 warnings, 189 lines checked
 core.h                    total: 0 errors, 0 warnings, 98 lines checked

This patch applies against kernel version linux-next next-20140213

These changes are meant to be a pre-cursor to the upcoming patch set to 
support the new silicon revision.

The previous test silicon (0x3) was only sent out in sample form and is
no longer produced by Dialog Semiconductor Ltd.

Samples of this chip pre-production chip were supplied under the proviso
that the production silicon would replace this test variant. The new
silicon variant code (0x5) correctly identifies the new production
silicon revision for the DA9063 PMIC

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/mfd/da9063-core.c       | 36 ++++++++++++++++++++----------------
 include/linux/mfd/da9063/core.h |  7 ++++++-
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index 26937cd..80ce35a 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -1,3 +1,4 @@
+
 /*
  * da9063-core.c: Device access for Dialog DA9063 modules
  *
@@ -110,7 +111,7 @@ static const struct mfd_cell da9063_devs[] = {
 int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 {
 	struct da9063_pdata *pdata = da9063->dev->platform_data;
-	int model, revision;
+	int chip_id, variant_id, variant_code;
 	int ret;
 
 	if (pdata) {
@@ -131,33 +132,36 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		}
 	}
 
-	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_ID, &model);
+	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_ID, &chip_id);
 	if (ret < 0) {
-		dev_err(da9063->dev, "Cannot read chip model id.\n");
+		dev_err(da9063->dev, "Cannot read chip id.\n");
 		return -EIO;
 	}
-	if (model != PMIC_DA9063) {
-		dev_err(da9063->dev, "Invalid chip model id: 0x%02x\n", model);
+	if (chip_id != PMIC_DA9063) {
+		dev_err(da9063->dev, "Invalid chip id: 0x%02x\n", chip_id);
 		return -ENODEV;
 	}
 
-	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_VARIANT, &revision);
+	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_VARIANT, &variant_id);
 	if (ret < 0) {
-		dev_err(da9063->dev, "Cannot read chip revision id.\n");
+		dev_err(da9063->dev, "Cannot read chip variant id.\n");
 		return -EIO;
 	}
-	revision >>= DA9063_CHIP_VARIANT_SHIFT;
-	if (revision != 3) {
-		dev_err(da9063->dev, "Unknown chip revision: %d\n", revision);
-		return -ENODEV;
-	}
 
-	da9063->model = model;
-	da9063->revision = revision;
+	variant_code = variant_id >> DA9063_CHIP_VARIANT_SHIFT;
 
 	dev_info(da9063->dev,
-		 "Device detected (model-ID: 0x%02X  rev-ID: 0x%02X)\n",
-		 model, revision);
+		 "Device detected (chip-ID: 0x%02X, var-ID: 0x%02X)\n",
+		 chip_id, variant_id);
+
+	if (variant_code != PMIC_DA9063_BB) {
+		dev_err(da9063->dev, "Unknown chip variant code: 0x%02X\n",
+				variant_code);
+		return -ENODEV;
+	}
+
+	da9063->model = chip_id;
+	da9063->variant_code = variant_code;
 
 	ret = da9063_irq_init(da9063);
 	if (ret) {
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
index 2d2a0af..2265ccb 100644
--- a/include/linux/mfd/da9063/core.h
+++ b/include/linux/mfd/da9063/core.h
@@ -1,3 +1,4 @@
+
 /*
  * Definitions for DA9063 MFD driver
  *
@@ -33,6 +34,10 @@ enum da9063_models {
 	PMIC_DA9063 = 0x61,
 };
 
+enum da9063_variant_codes {
+	PMIC_DA9063_BB = 0x5
+};
+
 /* Interrupts */
 enum da9063_irqs {
 	DA9063_IRQ_ONKEY = 0,
@@ -72,7 +77,7 @@ struct da9063 {
 	/* Device */
 	struct device	*dev;
 	unsigned short	model;
-	unsigned short	revision;
+	unsigned char	variant_code;
 	unsigned int	flags;
 
 	/* Control interface */
-- 
end-of-patch for RFC V1

