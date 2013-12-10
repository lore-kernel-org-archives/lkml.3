Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3LJXot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:44:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38980 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3LJXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:19 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 4/7] Input: pm8xxx-vibrator - Migrate to regmap APIs
Date: Tue, 10 Dec 2013 15:43:13 -0800
Message-Id: <1386718996-3733-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regmap APIs for this driver instead of custom pm8xxx
APIs. This breaks this driver's dependency on the pm8xxx APIs and
allows us to easily port it to other bus protocols in the future.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pm8xxx-vibrator.c | 61 +++++++++---------------------------
 1 file changed, 14 insertions(+), 47 deletions(-)

diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index 2a92ab0..cb5a8e8f 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/slab.h>
-#include <linux/mfd/pm8xxx/core.h>
+#include <linux/regmap.h>
 
 #define VIB_DRV			0x4A
 
@@ -35,7 +35,7 @@
  * struct pm8xxx_vib - structure to hold vibrator data
  * @vib_input_dev: input device supporting force feedback
  * @work: work structure to set the vibration parameters
- * @dev: device supporting force feedback
+ * @regmap: regmap for register read/write
  * @speed: speed of vibration set from userland
  * @active: state of vibrator
  * @level: level of vibration to set in the chip
@@ -44,7 +44,7 @@
 struct pm8xxx_vib {
 	struct input_dev *vib_input_dev;
 	struct work_struct work;
-	struct device *dev;
+	struct regmap *regmap;
 	int speed;
 	int level;
 	bool active;
@@ -52,42 +52,6 @@ struct pm8xxx_vib {
 };
 
 /**
- * pm8xxx_vib_read_u8 - helper to read a byte from pmic chip
- * @vib: pointer to vibrator structure
- * @data: placeholder for data to be read
- * @reg: register address
- */
-static int pm8xxx_vib_read_u8(struct pm8xxx_vib *vib,
-				 u8 *data, u16 reg)
-{
-	int rc;
-
-	rc = pm8xxx_readb(vib->dev->parent, reg, data);
-	if (rc < 0)
-		dev_warn(vib->dev, "Error reading pm8xxx reg 0x%x(0x%x)\n",
-				reg, rc);
-	return rc;
-}
-
-/**
- * pm8xxx_vib_write_u8 - helper to write a byte to pmic chip
- * @vib: pointer to vibrator structure
- * @data: data to write
- * @reg: register address
- */
-static int pm8xxx_vib_write_u8(struct pm8xxx_vib *vib,
-				 u8 data, u16 reg)
-{
-	int rc;
-
-	rc = pm8xxx_writeb(vib->dev->parent, reg, data);
-	if (rc < 0)
-		dev_warn(vib->dev, "Error writing pm8xxx reg 0x%x(0x%x)\n",
-				reg, rc);
-	return rc;
-}
-
-/**
  * pm8xxx_vib_set - handler to start/stop vibration
  * @vib: pointer to vibrator structure
  * @on: state to set
@@ -95,14 +59,14 @@ static int pm8xxx_vib_write_u8(struct pm8xxx_vib *vib,
 static int pm8xxx_vib_set(struct pm8xxx_vib *vib, bool on)
 {
 	int rc;
-	u8 val = vib->reg_vib_drv;
+	unsigned int val = vib->reg_vib_drv;
 
 	if (on)
 		val |= ((vib->level << VIB_DRV_SEL_SHIFT) & VIB_DRV_SEL_MASK);
 	else
 		val &= ~VIB_DRV_SEL_MASK;
 
-	rc = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
+	rc = regmap_write(vib->regmap, VIB_DRV, val);
 	if (rc < 0)
 		return rc;
 
@@ -118,9 +82,9 @@ static void pm8xxx_work_handler(struct work_struct *work)
 {
 	struct pm8xxx_vib *vib = container_of(work, struct pm8xxx_vib, work);
 	int rc;
-	u8 val;
+	unsigned int val;
 
-	rc = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
+	rc = regmap_read(vib->regmap, VIB_DRV, &val);
 	if (rc < 0)
 		return;
 
@@ -184,27 +148,30 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	struct pm8xxx_vib *vib;
 	struct input_dev *input_dev;
 	int error;
-	u8 val;
+	unsigned int val;
 
 	vib = devm_kzalloc(&pdev->dev, sizeof(*vib), GFP_KERNEL);
 	if (!vib)
 		return -ENOMEM;
 
+	vib->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!vib->regmap)
+		return -ENODEV;
+
 	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev)
 		return -ENOMEM;
 
 	INIT_WORK(&vib->work, pm8xxx_work_handler);
-	vib->dev = &pdev->dev;
 	vib->vib_input_dev = input_dev;
 
 	/* operate in manual mode */
-	error = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
+	error = regmap_read(vib->regmap, VIB_DRV, &val);
 	if (error < 0)
 		return error;
 
 	val &= ~VIB_DRV_EN_MANUAL_MASK;
-	error = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
+	error = regmap_write(vib->regmap, VIB_DRV, val);
 	if (error < 0)
 		return error;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

