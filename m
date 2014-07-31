Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaGaMbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:31:20 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59631 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaGaMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:31:18 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH] regulator: tps65090: Set voltage for fixed regulators
Date: Thu, 31 Jul 2014 14:31:05 +0200
Message-Id: <1406809865-13115-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the tps65090 data manual [0], the DCDC1 and DCDC2
step-down converters and the LDO's have a fixed output voltage.

Add this information to the driver since these fixed regulators
can be used as parent input supply for switches that don't have
an output voltage defined. So the regulator core needs to fetch
the FET parent output voltage if the child voltage is queried.

[0]: http://www.ti.com/lit/gpn/tps65090

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since RFC:
 - Use better names to describe the macro used to create the regulator desc.
   Suggested by Mark Brown.

 drivers/regulator/tps65090-regulator.c | 76 +++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 2064b3f..d5df1e9 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -192,12 +192,14 @@ static struct regulator_ops tps65090_fet_control_ops = {
 static struct regulator_ops tps65090_ldo_ops = {
 };
 
-#define tps65090_REG_DESC(_id, _sname, _en_reg, _en_bits, _ops)	\
+#define tps65090_REG_DESC(_id, _sname, _en_reg, _en_bits, _nvolt, _volt, _ops) \
 {							\
 	.name = "TPS65090_RAILS"#_id,			\
 	.supply_name = _sname,				\
 	.id = TPS65090_REGULATOR_##_id,			\
+	.n_voltages = _nvolt,				\
 	.ops = &_ops,					\
+	.fixed_uV = _volt,				\
 	.enable_reg = _en_reg,				\
 	.enable_val = _en_bits,				\
 	.enable_mask = _en_bits,			\
@@ -205,40 +207,46 @@ static struct regulator_ops tps65090_ldo_ops = {
 	.owner = THIS_MODULE,				\
 }
 
+#define tps65090_REG_FIXEDV(_id, _sname, en_reg, _en_bits, _volt, _ops) \
+	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 1, _volt, _ops)
+
+#define tps65090_REG_SWITCH(_id, _sname, en_reg, _en_bits, _ops) \
+	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 0, 0, _ops)
+
 static struct regulator_desc tps65090_regulator_desc[] = {
-	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, BIT(CTRL_EN_BIT),
-			  tps65090_reg_control_ops),
-	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, BIT(CTRL_EN_BIT),
-			  tps65090_reg_control_ops),
-	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, BIT(CTRL_EN_BIT),
-			  tps65090_reg_control_ops),
-
-	tps65090_REG_DESC(FET1,  "infet1",  0x0F,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET2,  "infet2",  0x10,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET3,  "infet3",  0x11,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET4,  "infet4",  0x12,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET5,  "infet5",  0x13,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET6,  "infet6",  0x14,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET7,  "infet7",  0x15,
-			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
-			  tps65090_fet_control_ops),
-
-	tps65090_REG_DESC(LDO1,  "vsys-l1", 0, 0,
-			  tps65090_ldo_ops),
-	tps65090_REG_DESC(LDO2,  "vsys-l2", 0, 0,
-			  tps65090_ldo_ops),
+	tps65090_REG_FIXEDV(DCDC1, "vsys1",   0x0C, BIT(CTRL_EN_BIT), 5000000,
+			    tps65090_reg_control_ops),
+	tps65090_REG_FIXEDV(DCDC2, "vsys2",   0x0D, BIT(CTRL_EN_BIT), 3300000,
+			    tps65090_reg_control_ops),
+	tps65090_REG_SWITCH(DCDC3, "vsys3",   0x0E, BIT(CTRL_EN_BIT),
+			    tps65090_reg_control_ops),
+
+	tps65090_REG_SWITCH(FET1,  "infet1",  0x0F,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET2,  "infet2",  0x10,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET3,  "infet3",  0x11,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET4,  "infet4",  0x12,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET5,  "infet5",  0x13,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET6,  "infet6",  0x14,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+	tps65090_REG_SWITCH(FET7,  "infet7",  0x15,
+			    BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
+			    tps65090_fet_control_ops),
+
+	tps65090_REG_FIXEDV(LDO1,  "vsys-l1", 0, 0, 5000000,
+			    tps65090_ldo_ops),
+	tps65090_REG_FIXEDV(LDO2,  "vsys-l2", 0, 0, 3300000,
+			    tps65090_ldo_ops),
 };
 
 static inline bool is_dcdc(int id)
-- 
2.0.0.rc2

