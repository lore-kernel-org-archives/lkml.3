Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaA1MVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:21:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30713 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaA1MTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:10 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-6a-52e7a03b8b67
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 12/18] extcon: max14577: Choose muic_irqs according to device
 type
Date: Tue, 28 Jan 2014 13:18:36 +0100
Message-id: <1390911522-28209-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4NV2bBc+DDKZFW0x9+ITN4vqX56wW
	r18YWpxtesNucf/rUUaLb1c6mCw2Pb7GanF51xw2i7VH7rJb3G5cwWZxupvVgdtj56y77B6b
	VnWyedy5tofNY97JQI/NS+o9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK+PX18VMBSfkK04t
	n8rSwNgj1cXIySEhYCJxZ/MEZghbTOLCvfVsXYxcHEICSxklvn1uZoZw+pgkXrw+xAZSxSZg
	LLF5+RKwKhGB1UwSaxZMZQFJMAv0Mkrc3O3RxcjBISwQIrFtpgRImEVAVeL99QawXl4BD4k/
	a56xg5RICChIzJlkAxLmBAq/utrIBGILCbhLnDr+jmUCI+8CRoZVjKKppckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGCFh+GUH4+JjVocYBTgYlXh4OzqfBQmxJpYVV+YeYpTgYFYS4U2c/TxIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA+Nq663PDp9Pj25XLN41x9h7y6Yra/ZN8XSY3/ImXvX6Jb4G
	foOA9mdzntiW83/7E5I8ffK608dFPbYucZi/6XoclzLXn4y/+xq0nr74EX73evj893sltMRP
	l029ohaZ4Mp6ZvXMZuXyiFNhNY2TQtK36bUGXxPbySuf/WPi9tSg3Q+4/vpeslylxFKckWio
	xVxUnAgA2VKFkSECAAA=
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

