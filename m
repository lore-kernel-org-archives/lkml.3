Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBNPGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:06:53 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.117]:62752 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbaBNPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:06:51 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-6.tower-194.messagelabs.com!1392390408!10169064!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402141506.s1EF6iYr002690@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Fri, 14 Feb 2014 14:08:11 +0000
Subject: [RFC V2] mfd: da9063: Add support for production silicon variant
 code
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
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

There is also some small amount of correction done in this patch:
it splits the revision code and correctly names it according to
the hardware specification and moves the dev_info() call before
the variant ID test.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140214/scripts/checkpatch.pl
 da9063-core.c             total: 0 errors, 0 warnings, 188 lines checked
 core.h                    total: 0 errors, 0 warnings, 97 lines checked
This patch applies against kernel version linux-next next-20140214

These changes are meant to be a pre-cursor to the upcoming patch set to 
support the new silicon revision.

The previous test silicon was only sent out in sample form and no longer
available. Only the production variant (0x5) of DA9063 PMIC will be
available from Dialog Semiconductor Ltd.

Changes made after RFC V1:
 - Lee Jones: https://lkml.org/lkml/2014/2/14/140
  . Removed whitespace at the top of the files
  . Removed the chip_id change since this should be made as part of a
    different patch set and it confuses the intention of this patch.



 drivers/mfd/da9063-core.c       | 25 ++++++++++++++-----------
 include/linux/mfd/da9063/core.h |  6 +++++-
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index 26937cd..e70ae31 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -110,7 +110,7 @@ static const struct mfd_cell da9063_devs[] = {
 int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 {
 	struct da9063_pdata *pdata = da9063->dev->platform_data;
-	int model, revision;
+	int model, variant_id, variant_code;
 	int ret;
 
 	if (pdata) {
@@ -141,23 +141,26 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
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
+
+	variant_code = variant_id >> DA9063_CHIP_VARIANT_SHIFT;
+
+	dev_info(da9063->dev,
+		 "Device detected (chip-ID: 0x%02X, var-ID: 0x%02X)\n",
+		 model, variant_id);
+
+	if (variant_code != PMIC_DA9063_BB) {
+		dev_err(da9063->dev, "Unknown chip variant code: 0x%02X\n",
+				variant_code);
 		return -ENODEV;
 	}
 
 	da9063->model = model;
-	da9063->revision = revision;
-
-	dev_info(da9063->dev,
-		 "Device detected (model-ID: 0x%02X  rev-ID: 0x%02X)\n",
-		 model, revision);
+	da9063->variant_code = variant_code;
 
 	ret = da9063_irq_init(da9063);
 	if (ret) {
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
index 2d2a0af..00a9aac 100644
--- a/include/linux/mfd/da9063/core.h
+++ b/include/linux/mfd/da9063/core.h
@@ -33,6 +33,10 @@ enum da9063_models {
 	PMIC_DA9063 = 0x61,
 };
 
+enum da9063_variant_codes {
+	PMIC_DA9063_BB = 0x5
+};
+
 /* Interrupts */
 enum da9063_irqs {
 	DA9063_IRQ_ONKEY = 0,
@@ -72,7 +76,7 @@ struct da9063 {
 	/* Device */
 	struct device	*dev;
 	unsigned short	model;
-	unsigned short	revision;
+	unsigned char	variant_code;
 	unsigned int	flags;
 
 	/* Control interface */
-- 
end-of-patch for RFC V2

