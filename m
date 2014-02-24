Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaBXKL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:11:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaBXKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:20 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4b-530b1ac42426
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 07/16] extcon: max14577: Choose muic_irqs according to
 device type
Date: Mon, 24 Feb 2014 11:10:32 +0100
Message-id: <1393236641-14977-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xy7pHpLiDDV6vFLXYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJbnO5mtVg/
	4zWLA6/Hzll32T02r9Dy2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgEcUVw2Kak5mWWp
	Rfp2CVwZZzedZS1YqVCx7eZH9gbGx1JdjJwcEgImEut+X2WHsMUkLtxbz9bFyMUhJLCUUeLm
	rwssEE4fk8S5JdPZQKrYBIwlNi9fAlYlIrCFSaL3wxdGEIdZ4DmjxMdFM8FmCQuES5xvvskK
	YrMIqEr8uHeaCcTmFXCXuPzjD3MXIwfQPgWJOZNsQMKcAh4Sd1segJULAZV8m3edZQIj7wJG
	hlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIYH6ZQfj4mNWhxgFOBiVeHglqrmChVgTy4or
	cw8xSnAwK4nwmvFyBwvxpiRWVqUW5ccXleakFh9iZOLglGpgjFNbc9/3Qvavvf+u/jado2X4
	ymvqqogNYr17HSY7s/p1nrqst/X96Y8WBdsdp29wZU1SPqnwdKqxusOa90VlU5c+UXZ5PqtQ
	7bFmcsMPgf3V6lkz5Y6+N5gx9XJ2Jqsuq2Gxf7HWWr/5oSZWPmvX23w9z2w4V4R77aGIo3LX
	8z48lJgVuyvzjxJLcUaioRZzUXEiANrIIvQyAgAA
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
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c |   65 ++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index fb343f4042d2..e986a9b92b60 100644
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
+	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
+	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
+	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
+	{ MAXIM_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
+	{ MAXIM_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
+	{ MAXIM_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
+	{ MAXIM_IRQ_INT2_DBCHG,		"muic-DBCHG" },
+	{ MAXIM_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
+};
+
 struct max14577_muic_info {
 	struct device *dev;
 	struct maxim_core *maxim_core;
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
-	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
-	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
-	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
-	{ MAXIM_IRQ_INT2_CHGTYP,	"muic-CHGTYP" },
-	{ MAXIM_IRQ_INT2_CHGDETRUN,	"muic-CHGDETRUN" },
-	{ MAXIM_IRQ_INT2_DCDTMR,	"muic-DCDTMR" },
-	{ MAXIM_IRQ_INT2_DBCHG,		"muic-DBCHG" },
-	{ MAXIM_IRQ_INT2_VBVOLT,	"muic-VBVOLT" },
-};
-
 /* Define supported accessory type */
 enum max14577_muic_acc_type {
 	MAX14577_MUIC_ADC_GROUND = 0x0,
@@ -541,9 +543,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
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
 	case MAXIM_IRQ_INT1_ADC:
@@ -646,9 +648,16 @@ static int max14577_muic_probe(struct platform_device *pdev)
 
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
+	switch (maxim_core->dev_type) {
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
 
 		virq = regmap_irq_get_virq(maxim_core->irq_data_muic,
-- 
1.7.9.5

