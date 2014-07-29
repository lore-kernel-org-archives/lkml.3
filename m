Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaG2Q3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:29:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58437 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaG2Q3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:29:25 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC 4/5] regulator: tps65090: Set voltage for fixed regulators
Date: Tue, 29 Jul 2014 18:28:58 +0200
Message-Id: <1406651339-28901-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the tps65090 data manual [0], the DCDC1 and DCDC2
step-down converters and the LDO's have a fixed output voltage.

Add this information to the driver since these fixed regulators
be used as input supply for load switches which don't provide
an output voltage and their parent supply voltage is used.

[0]: http://www.ti.com/lit/gpn/tps65090

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/tps65090-regulator.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 2064b3f..919f5ce 100644
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
@@ -205,39 +207,45 @@ static struct regulator_ops tps65090_ldo_ops = {
 	.owner = THIS_MODULE,				\
 }
 
+#define tps65090_REG_FIX(_id, _sname, en_reg, _en_bits, _volt, _ops) \
+	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 1, _volt, _ops)
+
+#define tps65090_REG_VAR(_id, _sname, en_reg, _en_bits, _ops) \
+	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 0, 0, _ops)
+
 static struct regulator_desc tps65090_regulator_desc[] = {
-	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, BIT(CTRL_EN_BIT),
+	tps65090_REG_FIX(DCDC1, "vsys1",   0x0C, BIT(CTRL_EN_BIT), 5000000,
 			  tps65090_reg_control_ops),
-	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, BIT(CTRL_EN_BIT),
+	tps65090_REG_FIX(DCDC2, "vsys2",   0x0D, BIT(CTRL_EN_BIT), 3300000,
 			  tps65090_reg_control_ops),
-	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, BIT(CTRL_EN_BIT),
+	tps65090_REG_VAR(DCDC3, "vsys3",   0x0E, BIT(CTRL_EN_BIT),
 			  tps65090_reg_control_ops),
 
-	tps65090_REG_DESC(FET1,  "infet1",  0x0F,
+	tps65090_REG_VAR(FET1,  "infet1",  0x0F,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET2,  "infet2",  0x10,
+	tps65090_REG_VAR(FET2,  "infet2",  0x10,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET3,  "infet3",  0x11,
+	tps65090_REG_VAR(FET3,  "infet3",  0x11,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET4,  "infet4",  0x12,
+	tps65090_REG_VAR(FET4,  "infet4",  0x12,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET5,  "infet5",  0x13,
+	tps65090_REG_VAR(FET5,  "infet5",  0x13,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET6,  "infet6",  0x14,
+	tps65090_REG_VAR(FET6,  "infet6",  0x14,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
-	tps65090_REG_DESC(FET7,  "infet7",  0x15,
+	tps65090_REG_VAR(FET7,  "infet7",  0x15,
 			  BIT(CTRL_EN_BIT) | BIT(CTRL_PG_BIT),
 			  tps65090_fet_control_ops),
 
-	tps65090_REG_DESC(LDO1,  "vsys-l1", 0, 0,
+	tps65090_REG_FIX(LDO1,  "vsys-l1", 0, 0, 5000000,
 			  tps65090_ldo_ops),
-	tps65090_REG_DESC(LDO2,  "vsys-l2", 0, 0,
+	tps65090_REG_FIX(LDO2,  "vsys-l2", 0, 0, 3300000,
 			  tps65090_ldo_ops),
 };
 
-- 
2.0.0.rc2

