Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaDNJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:18:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52272 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbaDNJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:41 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c7-534ba7b26b56
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 8/9] extcon: max14577: Add support for MAX77836
Date: Mon, 14 Apr 2014 11:17:19 +0200
Message-id: <1397467040-30502-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd1Ny72DDdbt4bLYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXHjyx/GgnduFSf//2Vs
	YDxl1cXIySEhYCLR+38XI4QtJnHh3nq2LkYuDiGBpYwSR17tYYZw+pgkJvaeZAepYhMwlti8
	fAlYlYhAM5NES99ZRhCHWeAoo8T03rdMIFXCAk4SUxdvZAOxWQRUJXZ/WwPWzSvgLjHz3mMW
	iH0KEsu+rGUGsTkFPCRudR8Ds4WAal58us0+gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS9
	5PzcTYyQMPy6g3HpMatDjAIcjEo8vB1zvIOFWBPLiitzDzFKcDArifBuy/AKFuJNSaysSi3K
	jy8qzUktPsTIxMEp1cB49vTXAwd+uk3L0a5w3Rqv63HO4qXKX/OzDrlfQj0l8vee3XHnkSzD
	P+VNjXmiSjwdzUsL5K70b1gmoxZ/Nufxo5jVZ36nnVFNfGslLy12q/vhuaLQww7STj6GPFb3
	xTY3r8rymXplQWtsk7233O7WyOU323OrzGRrOLxun7pobPtIxnyteowSS3FGoqEWc1FxIgCr
	WqZfIQIAAA==
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
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig               |   4 +-
 drivers/extcon/extcon-max14577.c     | 109 +++++++++++++++++++++++++++++------
 drivers/mfd/max14577.c               |   1 +
 include/linux/mfd/max14577-private.h |   3 +
 4 files changed, 96 insertions(+), 21 deletions(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index be56e8ac95e6..aebde489c291 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -28,13 +28,13 @@ config EXTCON_ADC_JACK
 	  Say Y here to enable extcon device driver based on ADC values.
 
 config EXTCON_MAX14577
-	tristate "MAX14577 EXTCON Support"
+	tristate "MAX14577/77836 EXTCON Support"
 	depends on MFD_MAX14577
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the MUIC device of
-	  Maxim MAX14577 PMIC. The MAX14577 MUIC is a USB port accessory
+	  Maxim MAX14577/77836. The MAX14577/77836 MUIC is a USB port accessory
 	  detector and switch.
 
 config EXTCON_MAX77693
diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 1513013a92f1..c76734a70171 100644
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
 	{ MAX14577_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
 };
 
+static struct max14577_muic_irq max77836_muic_irqs[] = {
+	{ MAX14577_IRQ_INT1_ADC,	"muic-ADC" },
+	{ MAX14577_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
+	{ MAX14577_IRQ_INT1_ADCERR,	"muic-ADCError" },
+	{ MAX77836_IRQ_INT1_ADC1K,	"muic-ADC1K" },
+	{ MAX14577_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
+	{ MAX14577_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
+	{ MAX14577_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
+	{ MAX14577_IRQ_INT2_DBCHG,	"muic-DBCHG" },
+	{ MAX14577_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
+	{ MAX77836_IRQ_INT2_VIDRM,	"muic-VIDRM" },
+};
+
 struct max14577_muic_info {
 	struct device *dev;
 	struct max14577 *max14577;
@@ -529,21 +543,12 @@ static void max14577_muic_irq_work(struct work_struct *work)
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
 	case MAX14577_IRQ_INT1_ADC:
 	case MAX14577_IRQ_INT1_ADCLOW:
@@ -551,7 +556,7 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 		/* Handle all of accessory except for
 		   type of charger accessory */
 		info->irq_adc = true;
-		break;
+		return 1;
 	case MAX14577_IRQ_INT2_CHGTYP:
 	case MAX14577_IRQ_INT2_CHGDETRUN:
 	case MAX14577_IRQ_INT2_DCDTMR:
@@ -559,8 +564,62 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 	case MAX14577_IRQ_INT2_VBVOLT:
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
+	switch (info->max14577->dev_type) {
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
@@ -646,6 +705,10 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
 	switch (max14577->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		info->muic_irqs = max77836_muic_irqs;
+		info->muic_irqs_num = ARRAY_SIZE(max77836_muic_irqs);
+		break;
 	case MAXIM_DEVICE_TYPE_MAX14577:
 	default:
 		info->muic_irqs = max14577_muic_irqs;
@@ -744,6 +807,13 @@ static int max14577_muic_remove(struct platform_device *pdev)
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
@@ -751,11 +821,12 @@ static struct platform_driver max14577_muic_driver = {
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
index 20e3b2d81bf0..484d372a4892 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -147,6 +147,7 @@ static const struct regmap_irq max77836_muic_irqs[] = {
 	{ .reg_offset = 0, .mask = MAX14577_INT1_ADC_MASK, },
 	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCLOW_MASK, },
 	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCERR_MASK, },
+	{ .reg_offset = 0, .mask = MAX77836_INT1_ADC1K_MASK, },
 	/* INT2 interrupts */
 	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGTYP_MASK, },
 	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGDETRUN_MASK, },
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index e301bd19b067..a557ae27d8a8 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -87,6 +87,7 @@ enum max14577_muic_charger_type {
 #define MAX14577_INT1_ADC_MASK		BIT(0)
 #define MAX14577_INT1_ADCLOW_MASK	BIT(1)
 #define MAX14577_INT1_ADCERR_MASK	BIT(2)
+#define MAX77836_INT1_ADC1K_MASK	BIT(3)
 
 #define MAX14577_INT2_CHGTYP_MASK	BIT(0)
 #define MAX14577_INT2_CHGDETRUN_MASK	BIT(1)
@@ -332,6 +333,7 @@ enum max14577_irq {
 	MAX14577_IRQ_INT1_ADC,
 	MAX14577_IRQ_INT1_ADCLOW,
 	MAX14577_IRQ_INT1_ADCERR,
+	MAX77836_IRQ_INT1_ADC1K,
 
 	/* INT2 */
 	MAX14577_IRQ_INT2_CHGTYP,
@@ -339,6 +341,7 @@ enum max14577_irq {
 	MAX14577_IRQ_INT2_DCDTMR,
 	MAX14577_IRQ_INT2_DBCHG,
 	MAX14577_IRQ_INT2_VBVOLT,
+	MAX77836_IRQ_INT2_VIDRM,
 
 	/* INT3 */
 	MAX14577_IRQ_INT3_EOC,
-- 
1.8.3.2

