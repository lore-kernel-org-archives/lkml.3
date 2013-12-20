Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3LTJfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:35:53 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30854 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3LTJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:35:26 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-34-52b40f5c55d9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] mfd: max77693: Set proper maximum register for MUIC regmap
Date: Fri, 20 Dec 2013 10:35:08 +0100
Message-id: <1387532108-9813-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
References: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xa7ox/FuCDL6c1rR4/cLQ4mzTG3aL
	+1+PMlpc3jWHzWLtkbvsFqe7WR3YPO5c28PmMe9koEffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBlLJu+hblgIk/FuskTmRsYu7m6GDk5JARMJJbO28MMYYtJXLi3nq2LkYtDSGApo8TkWd0s
	EE4fk8Tn9hVMIFVsAsYSm5cvYQOxRQSyJH5MWw1WxCzQyyjx4N0vRpCEsIC/xKdTj1lAbBYB
	VYnG2VtZQWxeATeJs2/+Aq3jAFqnIDFnkg1ImFPAXeLs1v1g5UJAJW/u/meawMi7gJFhFaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZI8HzZwbj4mNUhRgEORiUe3gbbzUFCrIllxZW5hxgl
	OJiVRHg5ngOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MIbev3+Mteh38HzFk1/Vfr5bbWa2jCld
	86OPc+I0iwJHR1FND8MI5h/5nguqvv7f4fw0Q+99GFdn2X2HELv1xQq3P6XWb78snHmg2Czw
	f8mq+8JLDvA4yRoZrpvyOyRn07dn0RwH/xyu3PKrQyP/DYP246knr84y2/9K5WlgevC6Y8cv
	qDD8VFNiKc5INNRiLipOBAAmRYjX/AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MUIC block in max77693 has different I2C address than PMIC. The
driver allocated two regmaps: for PMIC and MUIC. However it used the
same regmap_config (with max_register field) for both regmaps. Actual
maximum address of register for MUIC is different than for PMIC.

Define another regmap_config for MUIC with proper max_register value.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mfd/max77693.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9f92463f4f7e..3873a54e16ff 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -107,6 +107,12 @@ static const struct regmap_config max77693_regmap_config = {
 	.max_register = MAX77693_PMIC_REG_END,
 };
 
+static const struct regmap_config max77693_regmap_muic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX77693_MUIC_REG_END,
+};
+
 static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -153,7 +159,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	 * before call max77693-muic probe() function.
 	 */
 	max77693->regmap_muic = devm_regmap_init_i2c(max77693->muic,
-					 &max77693_regmap_config);
+					 &max77693_regmap_muic_config);
 	if (IS_ERR(max77693->regmap_muic)) {
 		ret = PTR_ERR(max77693->regmap_muic);
 		dev_err(max77693->dev,
-- 
1.7.9.5

