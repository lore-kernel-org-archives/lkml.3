Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaBQJRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:17:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46322 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaBQJGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-80-5301d1032d39
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
Subject: [PATCH v3 07/15] extcon: max14577: Choose muic_irqs according to
 device type
Date: Mon, 17 Feb 2014 10:05:42 +0100
Message-id: <1392627950-26927-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xa7rMFxmDDRY/UbXYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJb3G5cwWZx
	upvVYv2M1ywOfB47Z91l99i8Qstj06pONo871/awecw7GeixeUm9R9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGWc3XSWtWClQsW2mx/ZGxgfS3UxcnJICJhIPJm3lAXCFpO4cG89WxcjF4eQ
	wFJGiV+df9khnD4miVXNT5hBqtgEjCU2L18CViUi0MIk8X79fkYQh1ngEJPEghs3gKo4OIQF
	wiX6O8tAGlgEVCX2PL3EBGLzCrhL9D5aywJSIiGgIDFnkg1ImFPAQ+Lm0lvsILYQUMmTRztY
	JjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRErBfdjAuPmZ1iFGAg1GJh9egmjFY
	iDWxrLgy9xCjBAezkgiv7TqgEG9KYmVValF+fFFpTmrxIUYmDk6pBsaZmqvCQwMPbgr2eaPb
	rNp3gpfxUzNveO9mfcurm6f0WUkJZWQ8sWmNN7NiMv5W3Ow+Rd+nxOv+3LlcqSsCZ0pxHdqx
	L2jHYq6jDWpxm6d9eizLX7XZXa3345TuxOQJOYbe1hlHqqbeiulqmes8K6dZ6u79nZMav/Qp
	S6voVEWuNa11W+1nosRSnJFoqMVcVJwIANjBsio2AgAA
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

