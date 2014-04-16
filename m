Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaDPSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:25:58 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:61402 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaDPSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:25:34 -0400
From: Doug Anderson <dianders@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] regulator: tps65090: Make FETs more reliable by adding retries
Date: Wed, 16 Apr 2014 11:25:24 -0700
Message-Id: <1397672724-9063-6-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397672724-9063-1-git-send-email-dianders@chromium.org>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An issue was discovered with tps65090 where sometimes the FETs
wouldn't actually turn on when requested (they would report
overcurrent).  The most problematic FET was the one used for the LCD
backlight on the Samsung ARM Chromebook (FET1).  Problems were
especially prevalent when the device was plugged in to AC power (when
the backlight voltage was higher).

Mitigate the problem by adding retries on the enables of the FETs,
which works around the problem fairly effectively.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Michael Spang <spang@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
Changes in v2:
- Separated the overcurrent and retries changes into two patches.
- No longer open code fet_is_enabled().
- Fixed tps6090 typo.
- For loop => "while true".
- Removed a set of braces.

 drivers/regulator/tps65090-regulator.c | 153 +++++++++++++++++++++++++++++----
 1 file changed, 138 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index ca13a1a..c37ffb72 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
@@ -28,7 +29,13 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/tps65090.h>
 
+#define MAX_CTRL_READ_TRIES	5
+#define MAX_FET_ENABLE_TRIES	1000
+
+#define CTRL_EN_BIT		0 /* Regulator enable bit, active high */
 #define CTRL_WT_BIT		2 /* Regulator wait time 0 bit */
+#define CTRL_PG_BIT		4 /* Regulator power good bit, 1=good */
+#define CTRL_TO_BIT		7 /* Regulator timeout bit, 1=wait */
 
 #define MAX_OVERCURRENT_WAIT	3 /* Overcurrent wait must be <= this */
 
@@ -79,40 +86,156 @@ static int tps65090_reg_set_overcurrent_wait(struct tps65090_regulator *ri,
 	return ret;
 }
 
-static struct regulator_ops tps65090_reg_contol_ops = {
+/**
+ * tps65090_try_enable_fet - Try to enable a FET
+ *
+ * @rdev:	Regulator device
+ * @return 0 if ok, -ENOTRECOVERABLE if the FET power good bit did not get set,
+ * or some other -ve value if another error occurred (e.g. i2c error)
+ */
+static int tps65090_try_enable_fet(struct regulator_dev *rdev)
+{
+	unsigned int control;
+	int ret, i;
+
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				 rdev->desc->enable_mask,
+				 rdev->desc->enable_mask);
+	if (ret < 0) {
+		dev_err(&rdev->dev, "Error in updating reg %#x\n",
+			rdev->desc->enable_reg);
+		return ret;
+	}
+
+	for (i = 0; i < MAX_CTRL_READ_TRIES; i++) {
+		ret = regmap_read(rdev->regmap, rdev->desc->enable_reg,
+				  &control);
+		if (ret < 0)
+			return ret;
+
+		if (!(control & BIT(CTRL_TO_BIT)))
+			break;
+
+		usleep_range(1000, 1500);
+	}
+	if (!(control & BIT(CTRL_PG_BIT)))
+		return -ENOTRECOVERABLE;
+
+	return 0;
+}
+
+/**
+ * tps65090_fet_enable - Enable a FET, trying a few times if it fails
+ *
+ * Some versions of the tps65090 have issues when turning on the FETs.
+ * This function goes through several steps to ensure the best chance of the
+ * FET going on.  Specifically:
+ * - We'll make sure that we bump the "overcurrent wait" to the maximum, which
+ *   increases the chances that we'll turn on properly.
+ * - We'll retry turning the FET on multiple times (turning off in between).
+ *
+ * @rdev:	Regulator device
+ * @return 0 if ok, non-zero if it fails.
+ */
+static int tps65090_fet_enable(struct regulator_dev *rdev)
+{
+	int ret, tries;
+
+	/*
+	 * Try enabling multiple times until we succeed since sometimes the
+	 * first try times out.
+	 */
+	tries = 0;
+	while (true) {
+		ret = tps65090_try_enable_fet(rdev);
+		if (!ret)
+			break;
+		if (ret != -ENOTRECOVERABLE || tries == MAX_FET_ENABLE_TRIES)
+			goto err;
+
+		/* Try turning the FET off (and then on again) */
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+					 rdev->desc->enable_mask, 0);
+		if (ret)
+			goto err;
+
+		tries++;
+	}
+
+	if (tries)
+		dev_warn(&rdev->dev, "reg %#x enable ok after %d tries\n",
+			 rdev->desc->enable_reg, tries);
+
+	return 0;
+err:
+	dev_warn(&rdev->dev, "reg %#x enable failed\n", rdev->desc->enable_reg);
+	WARN_ON(1);
+
+	return ret;
+}
+
+static struct regulator_ops tps65090_reg_control_ops = {
 	.enable		= regulator_enable_regmap,
 	.disable	= regulator_disable_regmap,
 	.is_enabled	= regulator_is_enabled_regmap,
 };
 
+static struct regulator_ops tps65090_fet_control_ops = {
+	.enable		= tps65090_fet_enable,
+	.disable	= regulator_disable_regmap,
+	.is_enabled	= regulator_is_enabled_regmap,
+};
+
 static struct regulator_ops tps65090_ldo_ops = {
 };
 
-#define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
+#define tps65090_REG_DESC(_id, _sname, _en_reg, _en_bits, _ops)	\
 {							\
 	.name = "TPS65090_RAILS"#_id,			\
 	.supply_name = _sname,				\
 	.id = TPS65090_REGULATOR_##_id,			\
 	.ops = &_ops,					\
 	.enable_reg = _en_reg,				\
-	.enable_mask = BIT(0),				\
+	.enable_val = _en_bits,				\
+	.enable_mask = _en_bits,			\
 	.type = REGULATOR_VOLTAGE,			\
 	.owner = THIS_MODULE,				\
 }
 
 static struct regulator_desc tps65090_regulator_desc[] = {
-	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_reg_contol_ops),
-	tps65090_REG_DESC(LDO1,  "vsys-l1", 0,    tps65090_ldo_ops),
-	tps65090_REG_DESC(LDO2,  "vsys-l2", 0,    tps65090_ldo_ops),
+	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, BIT(CTRL_EN_BIT),
+			  tps65090_reg_control_ops),
+	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, BIT(CTRL_EN_BIT),
+			  tps65090_reg_control_ops),
+	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, BIT(CTRL_EN_BIT),
+			  tps65090_reg_control_ops),
+
+	tps65090_REG_DESC(FET1,  "infet1",  0x0F,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET2,  "infet2",  0x10,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET3,  "infet3",  0x11,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET4,  "infet4",  0x12,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET5,  "infet5",  0x13,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET6,  "infet6",  0x14,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+	tps65090_REG_DESC(FET7,  "infet7",  0x15,
+			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			  tps65090_fet_control_ops),
+
+	tps65090_REG_DESC(LDO1,  "vsys-l1", 0, 0,
+			  tps65090_ldo_ops),
+	tps65090_REG_DESC(LDO2,  "vsys-l2", 0, 0,
+			  tps65090_ldo_ops),
 };
 
 static inline bool is_dcdc(int id)
-- 
1.9.1.423.g4596e3a

