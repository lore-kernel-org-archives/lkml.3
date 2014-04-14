Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaDNJSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:18:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaDNJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:41 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b9-534ba7b0e589
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
Subject: [PATCH v5 5/9] extcon: max14577: Choose muic_irqs according to device
 type
Date: Mon, 14 Apr 2014 11:17:16 +0200
Message-id: <1397467040-30502-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Fd0Ny72DDTYvkLTYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAldE8dx5jwSqFiu6Dfxkb
	GN9JdTFyckgImEgsfHCDBcIWk7hwbz1bFyMXh5DAUkaJn1/XMkE4fUwSSyY3MINUsQkYS2xe
	vgSsSkSgmUmipe8sI4jDLHCUUWJ671ugFg4OYYFQiU+rK0AaWARUJbrOXQdbwSvgLnGqcTIT
	xDoFiWVf1oIN5RTwkLjVfQzMFgKqefHpNvsERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS
	83M3MUKC8OsOxqXHrA4xCnAwKvHwdszxDhZiTSwrrsw9xCjBwawkwrstwytYiDclsbIqtSg/
	vqg0J7X4ECMTB6dUA2OOie6bW4vf3i2+cdc3purPZDa+t3rKvUcV1jQy7HGRPHjsy4Xju/u3
	/7u88AF7tMr2hsK/gl/ab2zd7PMtLEEnpOziveJFZUqNbvpes+ZN0Vr8UCf+xosKNc4Xnp1R
	8lO09z4QfbjFVaq4w+zHarWob8lHc4pVc9trtkspbAmqnL2i5xjXVHslluKMREMt5qLiRADF
	81ndIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues the preparation for adding support for max77836
device to existing max14577 driver.

During probe choose muic_irqs according to device type. Currently there
are only "max14577_muic_irqs" but later patch will add max77836
interrupts.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 65 +++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 6f921b7c3e5b..1513013a92f1 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -39,6 +39,29 @@ enum max14577_muic_status {
 	MAX14577_MUIC_STATUS_END,
 };
 
+/**
+ * struct max14577_muic_irq
+ * @irq: the index of irq list of MUIC device.
+ * @name: the name of irq.
+ * @virq: the virtual irq to use irq domain
+ */
+struct max14577_muic_irq {
+	unsigned int irq;
+	const char *name;
+	unsigned int virq;
+};
+
+static struct max14577_muic_irq max14577_muic_irqs[] = {
+	{ MAX14577_IRQ_INT1_ADC,	"muic-ADC" },
+	{ MAX14577_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
+	{ MAX14577_IRQ_INT1_ADCERR,	"muic-ADCError" },
+	{ MAX14577_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
+	{ MAX14577_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
+	{ MAX14577_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
+	{ MAX14577_IRQ_INT2_DBCHG,	"muic-DBCHG" },
+	{ MAX14577_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
+};
+
 struct max14577_muic_info {
 	struct device *dev;
 	struct max14577 *max14577;
@@ -47,6 +70,8 @@ struct max14577_muic_info {
 	int prev_chg_type;
 	u8 status[MAX14577_MUIC_STATUS_END];
 
+	struct max14577_muic_irq *muic_irqs;
+	unsigned int muic_irqs_num;
 	bool irq_adc;
 	bool irq_chg;
 	struct work_struct irq_work;
@@ -73,29 +98,6 @@ enum max14577_muic_cable_group {
 	MAX14577_CABLE_GROUP_CHG,
 };
 
-/**
- * struct max14577_muic_irq
- * @irq: the index of irq list of MUIC device.
- * @name: the name of irq.
- * @virq: the virtual irq to use irq domain
- */
-struct max14577_muic_irq {
-	unsigned int irq;
-	const char *name;
-	unsigned int virq;
-};
-
-static struct max14577_muic_irq max14577_muic_irqs[] = {
-	{ MAX14577_IRQ_INT1_ADC,	"muic-ADC" },
-	{ MAX14577_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
-	{ MAX14577_IRQ_INT1_ADCERR,	"muic-ADCError" },
-	{ MAX14577_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
-	{ MAX14577_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
-	{ MAX14577_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
-	{ MAX14577_IRQ_INT2_DBCHG,	"muic-DBCHG" },
-	{ MAX14577_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
-};
-
 /* Define supported accessory type */
 enum max14577_muic_acc_type {
 	MAX14577_MUIC_ADC_GROUND = 0x0,
@@ -538,9 +540,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 	 * However we only need to know whether it was ADC, charger
 	 * or both interrupts so decode IRQ and turn on proper flags.
 	 */
-	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++)
-		if (irq == max14577_muic_irqs[i].virq)
-			irq_type = max14577_muic_irqs[i].irq;
+	for (i = 0; i < info->muic_irqs_num; i++)
+		if (irq == info->muic_irqs[i].virq)
+			irq_type = info->muic_irqs[i].irq;
 
 	switch (irq_type) {
 	case MAX14577_IRQ_INT1_ADC:
@@ -643,9 +645,16 @@ static int max14577_muic_probe(struct platform_device *pdev)
 
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
+	switch (max14577->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		info->muic_irqs = max14577_muic_irqs;
+		info->muic_irqs_num = ARRAY_SIZE(max14577_muic_irqs);
+	}
+
 	/* Support irq domain for max14577 MUIC device */
-	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++) {
-		struct max14577_muic_irq *muic_irq = &max14577_muic_irqs[i];
+	for (i = 0; i < info->muic_irqs_num; i++) {
+		struct max14577_muic_irq *muic_irq = &info->muic_irqs[i];
 		unsigned int virq = 0;
 
 		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
-- 
1.8.3.2

