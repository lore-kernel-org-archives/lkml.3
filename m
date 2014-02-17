Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBQJPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:15:50 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39130 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaBQJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:15 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-8e-5301d1047b7b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 09/15] extcon: max14577: Add support for max77836
Date: Mon, 17 Feb 2014 10:05:44 +0100
Message-id: <1392627950-26927-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7osFxmDDea9NbfYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJb3G5cwWZx
	upvVYv2M1ywOfB47Z91l99i8Qstj06pONo871/awecw7GeixeUm9R9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGWs3n2IpWC/Q8WnL7tZGhg3mHYxcnJICJhITF60nwnCFpO4cG89WxcjF4eQ
	wFJGiSfzW5kgnD4mifuPDzGDVLEJGEtsXr4ErEpEoIVJ4v36/YwgDrPAISaJBTdugFUJC7hI
	PP22jRXEZhFQlWg43AwW5xXwkLh46iZLFyMH0D4FiTmTbEDCnEDhm0tvsYPYQgLuEk8e7WCZ
	wMi7gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIyH7dwbj0mNUhRgEORiUeXoNqxmAh
	1sSy4srcQ4wSHMxKIry264BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGLMMYrj37etec6JQ+o7W
	5oUvNV6tjzog21ZiM9PmptRd6YirDU2PI60k3gWyxPfMl3h9e+NTW9eyCxLiG+u5fgupNDI9
	KZjnIrLvzIc4bVfTD3Olb3w1qTFVube1dXa/xTy9jZpLH2e5SL+r6PCbYXbsldLXI4H874yd
	1v61PrvN1/tDwsYwJiWW4oxEQy3mouJEAGK2r8Q3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MAX77836 chipset to the max14577 extcon driver. The
MAX77836 MUIC has additional interrupts (VIDRM, ADC1K) so IRQ handling
is split up into two functions: max14577_parse_irq() and
max77836_parse_irq().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c     |  109 ++++++++++++++++++++++++++++------
 drivers/mfd/max14577.c               |    1 +
 include/linux/mfd/max14577-private.h |    3 +
 3 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index e986a9b92b60..82ac6b0fb1bc 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -1,8 +1,9 @@
 /*
- * extcon-max14577.c - MAX14577 extcon driver to support MAX14577 MUIC
+ * extcon-max14577.c - MAX14577/77836 extcon driver to support MUIC
  *
- * Copyright (C) 2013 Samsung Electrnoics
+ * Copyright (C) 2013,2014 Samsung Electrnoics
  * Chanwoo Choi <cw00.choi@samsung.com>
+ * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -62,6 +63,19 @@ static struct max14577_muic_irq max14577_muic_irqs[] = {
 	{ MAXIM_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
 };
 
+static struct max14577_muic_irq max77836_muic_irqs[] = {
+	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
+	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
+	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
+	{ MAX77836_IRQ_INT1_ADC1K,	"muic-ADC1K" },
+	{ MAXIM_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
+	{ MAXIM_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
+	{ MAXIM_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
+	{ MAXIM_IRQ_INT2_DBCHG,		"muic-DBCHG" },
+	{ MAXIM_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
+	{ MAX77836_IRQ_INT2_VIDRM,	"muic-VIDRM" },
+};
+
 struct max14577_muic_info {
 	struct device *dev;
 	struct maxim_core *maxim_core;
@@ -532,21 +546,12 @@ static void max14577_muic_irq_work(struct work_struct *work)
 	return;
 }
 
-static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
+/*
+ * Sets irq_adc or irq_chg in max14577_muic_info and returns 1.
+ * Returns 0 if irq_type does not match registered IRQ for this device type.
+ */
+static int max14577_parse_irq(struct max14577_muic_info *info, int irq_type)
 {
-	struct max14577_muic_info *info = data;
-	int i, irq_type = -1;
-
-	/*
-	 * We may be called multiple times for different nested IRQ-s.
-	 * Including changes in INT1_ADC and INT2_CGHTYP at once.
-	 * However we only need to know whether it was ADC, charger
-	 * or both interrupts so decode IRQ and turn on proper flags.
-	 */
-	for (i = 0; i < info->muic_irqs_num; i++)
-		if (irq == info->muic_irqs[i].virq)
-			irq_type = info->muic_irqs[i].irq;
-
 	switch (irq_type) {
 	case MAXIM_IRQ_INT1_ADC:
 	case MAXIM_IRQ_INT1_ADCLOW:
@@ -554,7 +559,7 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 		/* Handle all of accessory except for
 		   type of charger accessory */
 		info->irq_adc = true;
-		break;
+		return 1;
 	case MAXIM_IRQ_INT2_CHGTYP:
 	case MAXIM_IRQ_INT2_CHGDETRUN:
 	case MAXIM_IRQ_INT2_DCDTMR:
@@ -562,8 +567,62 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 	case MAXIM_IRQ_INT2_VBVOLT:
 		/* Handle charger accessory */
 		info->irq_chg = true;
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Sets irq_adc or irq_chg in max14577_muic_info and returns 1.
+ * Returns 0 if irq_type does not match registered IRQ for this device type.
+ */
+static int max77836_parse_irq(struct max14577_muic_info *info, int irq_type)
+{
+	/* First check common max14577 interrupts */
+	if (max14577_parse_irq(info, irq_type))
+		return 1;
+
+	switch (irq_type) {
+	case MAX77836_IRQ_INT1_ADC1K:
+		info->irq_adc = true;
+		return 1;
+	case MAX77836_IRQ_INT2_VIDRM:
+		/* Handle charger accessory */
+		info->irq_chg = true;
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
+{
+	struct max14577_muic_info *info = data;
+	int i, irq_type = -1;
+	bool irq_parsed;
+
+	/*
+	 * We may be called multiple times for different nested IRQ-s.
+	 * Including changes in INT1_ADC and INT2_CGHTYP at once.
+	 * However we only need to know whether it was ADC, charger
+	 * or both interrupts so decode IRQ and turn on proper flags.
+	 */
+	for (i = 0; i < info->muic_irqs_num; i++)
+		if (irq == info->muic_irqs[i].virq)
+			irq_type = info->muic_irqs[i].irq;
+
+	switch (info->maxim_core->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		irq_parsed = max77836_parse_irq(info, irq_type);
 		break;
+	case MAXIM_DEVICE_TYPE_MAX14577:
 	default:
+		irq_parsed = max14577_parse_irq(info, irq_type);
+		break;
+	}
+
+	if (!irq_parsed) {
 		dev_err(info->dev, "muic interrupt: irq %d occurred, skipped\n",
 				irq_type);
 		return IRQ_HANDLED;
@@ -649,6 +708,10 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
 	switch (maxim_core->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		info->muic_irqs = max77836_muic_irqs;
+		info->muic_irqs_num = ARRAY_SIZE(max77836_muic_irqs);
+		break;
 	case MAXIM_DEVICE_TYPE_MAX14577:
 	default:
 		info->muic_irqs = max14577_muic_irqs;
@@ -748,6 +811,13 @@ static int max14577_muic_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max14577_muic_id[] = {
+	{ "max14577-muic", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836-muic", MAXIM_DEVICE_TYPE_MAX77836, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max14577_muic_id);
+
 static struct platform_driver max14577_muic_driver = {
 	.driver		= {
 		.name	= "max14577-muic",
@@ -755,11 +825,12 @@ static struct platform_driver max14577_muic_driver = {
 	},
 	.probe		= max14577_muic_probe,
 	.remove		= max14577_muic_remove,
+	.id_table	= max14577_muic_id,
 };
 
 module_platform_driver(max14577_muic_driver);
 
-MODULE_DESCRIPTION("MAXIM 14577 Extcon driver");
-MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_DESCRIPTION("Maxim 14577/77836 Extcon driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:extcon-max14577");
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 1463b17c11c3..08a2ceff3822 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -146,6 +146,7 @@ static const struct regmap_irq max77836_muic_irqs[] = {
 	{ .reg_offset = 0, .mask = MAXIM_INT1_ADC_MASK, },
 	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCLOW_MASK, },
 	{ .reg_offset = 0, .mask = MAXIM_INT1_ADCERR_MASK, },
+	{ .reg_offset = 0, .mask = MAX77836_INT1_ADC1K_MASK, },
 	/* INT2 interrupts */
 	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGTYP_MASK, },
 	{ .reg_offset = 1, .mask = MAXIM_INT2_CHGDETRUN_MASK, },
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 472d5780ca50..aae9382a41cb 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -77,6 +77,7 @@ enum maxim_muic_charger_type {
 #define MAXIM_INT1_ADC_MASK		BIT(0)
 #define MAXIM_INT1_ADCLOW_MASK		BIT(1)
 #define MAXIM_INT1_ADCERR_MASK		BIT(2)
+#define MAX77836_INT1_ADC1K_MASK	BIT(3)
 
 #define MAXIM_INT2_CHGTYP_MASK		BIT(0)
 #define MAXIM_INT2_CHGDETRUN_MASK	BIT(1)
@@ -309,6 +310,7 @@ enum maxim_irq {
 	MAXIM_IRQ_INT1_ADC,
 	MAXIM_IRQ_INT1_ADCLOW,
 	MAXIM_IRQ_INT1_ADCERR,
+	MAX77836_IRQ_INT1_ADC1K,
 
 	/* INT2 */
 	MAXIM_IRQ_INT2_CHGTYP,
@@ -316,6 +318,7 @@ enum maxim_irq {
 	MAXIM_IRQ_INT2_DCDTMR,
 	MAXIM_IRQ_INT2_DBCHG,
 	MAXIM_IRQ_INT2_VBVOLT,
+	MAX77836_IRQ_INT2_VIDRM,
 
 	/* INT3 */
 	MAXIM_IRQ_INT3_EOC,
-- 
1.7.9.5

