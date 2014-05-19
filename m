Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaESLOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:14:45 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62390 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaESLOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:14:42 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 2/2] regulator:  tps6586x: Add support for the TPS658640
Date: Mon, 19 May 2014 13:14:21 +0200
Message-Id: <1400498061-1071-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400498061-1071-1-git-send-email-alban.bedel@avionic-design.de>
References: <1400498061-1071-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:bIKv/8+Oj+sD8toYlqaqQYYTvORS1yY28mz3gP/pPNK
 cl90EgoaEaGok10slYp0VUm4kh0WbppbcedS8d/SqNs3ma1v20
 UzBMzobEzR7JP+A5km+8K/7LrADcn6ForWMpf9Gf4EV90Ioe0U
 MqoIaFKG63xUkC343ONFN+zeS73G8p5EosSG39B0uGQruIVmo8
 SrVD0ZYnG2cbQKworruhDuObMM19LQh3rUHE6SiI5CjVt/+vvC
 T55ZoeqR0iUYyyC4YAQ6Zqr5NgusUCKgJK+SYL7rpD8eNjeqd5
 kOScjEVlHerz3BB1zvEp54ZNU4SHXkz5+mBGy8QKiCFZ/pAW4b
 50/5fjNjcRV6MyUK/XYPQBg/lBfLYuYRxLnaCJS/xsWZ7e62zx
 lUBYULgxWI8tVAPf7UfNQc2YDhbv/n6emjPLpJ6n2n3lSsnECQ
 l1j+Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS658640 has a different set of output voltage for most LDO and
the RTC LDO isn't settable.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/mfd/tps6586x.c                 |  4 ++++
 drivers/regulator/tps6586x-regulator.c | 37 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6586x.h           |  2 ++
 3 files changed, 43 insertions(+)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index bbd5441..835e554 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -495,6 +495,10 @@ static void tps6586x_print_version(struct i2c_client *client, int version)
 	case TPS658623:
 		name = "TPS658623";
 		break;
+	case TPS658640:
+	case TPS658640v2:
+		name = "TPS658640";
+		break;
 	case TPS658643:
 		name = "TPS658643";
 		break;
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index da8ee02..27bf153 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -116,6 +116,13 @@ static const unsigned int tps6586x_sm2_voltages[] = {
 	4200000, 4250000, 4300000, 4350000, 4400000, 4450000, 4500000, 4550000,
 };
 
+static int tps658640_sm2_voltages[] = {
+	2150000, 2200000, 2250000, 2300000, 2350000, 2400000, 2450000, 2500000,
+	2550000, 2600000, 2650000, 2700000, 2750000, 2800000, 2850000, 2900000,
+	2950000, 3000000, 3050000, 3100000, 3150000, 3200000, 3250000, 3300000,
+	3350000, 3400000, 3450000, 3500000, 3550000, 3600000, 3650000, 3700000,
+};
+
 static const unsigned int tps658643_sm2_voltages[] = {
 	1025000, 1050000, 1075000, 1100000, 1125000, 1150000, 1175000, 1200000,
 	1225000, 1250000, 1275000, 1300000, 1325000, 1350000, 1375000, 1400000,
@@ -130,6 +137,10 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
+static int tps658640_rtc_voltages[] = {
+	2500000, 2850000, 3100000, 3300000,
+};
+
 #define TPS6586X_REGULATOR(_id, _ops, _pin_name, vdata, vreg, shift, nbits, \
 			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 	.desc	= {							\
@@ -224,6 +235,27 @@ static struct tps6586x_regulator tps658623_regulator[] = {
 					END, 7),
 };
 
+static struct tps6586x_regulator tps658640_regulator[] = {
+	TPS6586X_LDO(LDO_3, "vinldo23", tps6586x_ldo0, SUPPLYV4, 0, 3,
+					ENC, 2, END, 2),
+	TPS6586X_LDO(LDO_5, "REG-SYS", tps6586x_ldo0, SUPPLYV6, 0, 3,
+					ENE, 6, ENE, 6),
+	TPS6586X_LDO(LDO_6, "vinldo678", tps6586x_ldo0, SUPPLYV3, 0, 3,
+					ENC, 4, END, 4),
+	TPS6586X_LDO(LDO_7, "vinldo678", tps6586x_ldo0, SUPPLYV3, 3, 3,
+					ENC, 5, END, 5),
+	TPS6586X_LDO(LDO_8, "vinldo678", tps6586x_ldo0, SUPPLYV2, 5, 3,
+					ENC, 6, END, 6),
+	TPS6586X_LDO(LDO_9, "vinldo9", tps6586x_ldo0, SUPPLYV6, 3, 3,
+					ENE, 7, ENE, 7),
+	TPS6586X_LDO(SM_2, "vin-sm2", tps658640_sm2, SUPPLYV2, 0, 5,
+					ENC, 7, END, 7),
+
+	TPS6586X_FIXED_LDO(LDO_RTC, "REG-SYS", tps658640_rtc, SUPPLYV4, 3, 3,
+					V4, 7, V4, 7),
+};
+
+
 static struct tps6586x_regulator tps658643_regulator[] = {
 	TPS6586X_LDO(SM_2, "vin-sm2", tps658643_sm2, SUPPLYV2, 0, 5, ENC, 7,
 					END, 7),
@@ -312,6 +344,11 @@ static struct tps6586x_regulator *find_regulator_info(int id, int version)
 		table = tps658623_regulator;
 		num = ARRAY_SIZE(tps658623_regulator);
 		break;
+	case TPS658640:
+	case TPS658640v2:
+		table = tps658640_regulator;
+		num = ARRAY_SIZE(tps658640_regulator);
+		break;
 	case TPS658643:
 		table = tps658643_regulator;
 		num = ARRAY_SIZE(tps658643_regulator);
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index cbecec2..96187ed 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -17,6 +17,8 @@
 #define TPS658621A	0x15
 #define TPS658621CD	0x2c
 #define TPS658623	0x1b
+#define TPS658640	0x01
+#define TPS658640v2	0x02
 #define TPS658643	0x03
 
 enum {
-- 
1.9.3

