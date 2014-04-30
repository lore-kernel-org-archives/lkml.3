Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbaD3IlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:41:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24357 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbaD3Ikq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:40:46 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-2a-5360b70b6b02
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] regulator: s2mps11: Allow GPIO 0 to be used as external
 control on S2MPS14
Date: Wed, 30 Apr 2014 10:40:42 +0200
Message-id: <1398847242-9394-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
References: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4FV3u7QnBBj1bLC02zljPajH14RM2
	i9cvDC3ONr1ht/h2pYPJ4vKuOWwWa4/cZbc4+aeX0eLiii9MDpweO2fdZffYtKqTzePOtT1s
	Hn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJVx6W4ra8FM0Yq2tdfYGxhXCXYxcnJICJhIdJ/9
	wwhhi0lcuLeerYuRi0NIYCmjxPGJvVBOH5PE07/NTCBVbALGEpuXLwFLiAj0MEq83PqZGcRh
	FnjPKHHm4VKwWcICiRKrP60Hsjk4WARUJd7P8wMJ8wq4SXzZfIMJYp2cxMljk1lBbE4Bd4kb
	t5eygdhCQDXLlm5gm8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSKh92cG4+JjV
	IUYBDkYlHl6BrfHBQqyJZcWVuYcYJTiYlUR4MzoSgoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	mihcbph0aP61yY4cP00eb/tWt3pJu526k5NAYkB+8qf1P+7Mfy1Z5jlxn5zEdVfTz9YPzASC
	AhefiZxlfkx+8rLVp2L+lMW+cHRfIyr08fHJqVyzv90+GPt91TK7iq828/QOREzOcLUW65iq
	Ub1Sdnm+X9Lspjgv/TAmM/WLGyL8FbqmVu74p8RSnJFoqMVcVJwIAFpZC00TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO 0 is a valid GPIO so allow using it as external control for
S2MPS14 regulators.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 6dad0aa74a47..1583d4eaf911 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -412,7 +412,7 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
 
 	if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
 		val = S2MPS14_ENABLE_SUSPEND;
-	else if (s2mps11->ext_control_gpio[rdev_get_id(rdev)])
+	else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
 		val = S2MPS14_ENABLE_EXT_CONTROL;
 	else
 		val = rdev->desc->enable_mask;
@@ -593,9 +593,7 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 
 		gpio[reg] = of_get_named_gpio(rdata[reg].of_node,
 				"samsung,ext-control-gpios", 0);
-		if (!gpio_is_valid(gpio[reg]))
-			gpio[reg] = 0;
-		else
+		if (gpio_is_valid(gpio[reg]))
 			dev_dbg(&pdev->dev, "Using GPIO %d for ext-control over %d/%s\n",
 					gpio[reg], reg, rdata[reg].name);
 	}
@@ -658,6 +656,12 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 	if (!s2mps11->ext_control_gpio)
 		return -ENOMEM;
+	/*
+	 * 0 is a valid GPIO so initialize all GPIO-s to negative value
+	 * to indicate that external control won't be used for this regulator.
+	 */
+	for (i = 0; i < s2mps11->rdev_num; i++)
+		s2mps11->ext_control_gpio[i] = -EINVAL;
 
 	if (!iodev->dev->of_node) {
 		if (iodev->pdata) {
@@ -687,6 +691,7 @@ common_reg:
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
+	config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
 	for (i = 0; i < s2mps11->rdev_num; i++) {
 		struct regulator_dev *regulator;
 
@@ -697,12 +702,7 @@ common_reg:
 			config.init_data = rdata[i].init_data;
 			config.of_node = rdata[i].of_node;
 		}
-
-		if (s2mps11->ext_control_gpio[i]) {
-			config.ena_gpio = s2mps11->ext_control_gpio[i];
-			config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
-		} else
-			config.ena_gpio = config.ena_gpio_flags = 0;
+		config.ena_gpio = s2mps11->ext_control_gpio[i];
 
 		regulator = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
@@ -713,7 +713,7 @@ common_reg:
 			goto out;
 		}
 
-		if (s2mps11->ext_control_gpio[i]) {
+		if (gpio_is_valid(s2mps11->ext_control_gpio[i])) {
 			ret = s2mps14_pmic_enable_ext_control(s2mps11,
 					regulator);
 			if (ret < 0) {
-- 
1.9.1

