Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab3GWQJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:09:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54043 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab3GWQJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:09:15 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 3/4] mfd: twl6030-irq: convert to use linear irq_domain
Date: Tue, 23 Jul 2013 19:07:03 +0300
Message-ID: <1374595624-15054-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com>
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the TWL6030 PMIC is used with OMAP4 SoCs only and OMAP4 legacy
boot is dropped there are no needs to allocate the range of IRQ
descriptors during system boot to support TWL6030 IRQs.

Hence, convert it to use linear irq_domain and move IRQ configuration in
.map()/.unmap() callbacks of irq_domain. So, IRQ mapping and descriptors
allocation will be performed dynamically basing on DT configuration.

The error message will be reported in case if unmapped IRQ is received by
TWL6030 (virq==0).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/mfd/twl6030-irq.c |  114 ++++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 53 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 790cc28..89f130b 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -138,6 +138,7 @@ static struct notifier_block twl6030_irq_pm_notifier_block = {
 static irqreturn_t twl6030_irq_thread(int irq, void *data)
 {
 	int i, ret;
+	struct irq_domain *irq_domain = (struct irq_domain *)data;
 	union {
 		u8 bytes[4];
 		u32 int_sts;
@@ -161,9 +162,14 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 
 	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
 		if (sts.int_sts & 0x1) {
-			int module_irq = twl6030_irq_base +
-					twl6030_interrupt_mapping[i];
-			handle_nested_irq(module_irq);
+			int module_irq =
+				irq_find_mapping(irq_domain,
+						 twl6030_interrupt_mapping[i]);
+			if (module_irq)
+				handle_nested_irq(module_irq);
+			else
+				pr_err("%s: Unmapped PIH ISR %u detected\n",
+				       __func__, i);
 			pr_debug("%s: PIH ISR %u, virq%u\n",
 				 __func__, i, module_irq);
 		}
@@ -186,19 +192,6 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 
 /*----------------------------------------------------------------------*/
 
-static inline void activate_irq(int irq)
-{
-#ifdef CONFIG_ARM
-	/* ARM requires an extra step to clear IRQ_NOREQUEST, which it
-	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
-	 */
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	/* same effect on other architectures */
-	irq_set_noprobe(irq);
-#endif
-}
-
 static int twl6030_irq_set_wake(struct irq_data *d, unsigned int on)
 {
 	if (on)
@@ -308,28 +301,54 @@ int twl6030_mmc_card_detect(struct device *dev, int slot)
 }
 EXPORT_SYMBOL(twl6030_mmc_card_detect);
 
+static struct irq_chip twl6030_irq_chip;
+
+static int twl6030_irq_map(struct irq_domain *d, unsigned int virq,
+			      irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(virq, &twl6030_irq_chip);
+	irq_set_chip_and_handler(virq,  &twl6030_irq_chip, handle_simple_irq);
+	irq_set_nested_thread(virq, true);
+
+#ifdef CONFIG_ARM
+	/*
+	 * ARM requires an extra step to clear IRQ_NOREQUEST, which it
+	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
+	 */
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	/* same effect on other architectures */
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static void twl6030_irq_unmap(struct irq_domain *d, unsigned int virq)
+{
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, 0);
+#endif
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	irq_set_chip_data(virq, NULL);
+}
+
+static struct irq_domain_ops twl6030_irq_domain_ops = {
+	.map	= twl6030_irq_map,
+	.unmap	= twl6030_irq_unmap,
+	.xlate	= irq_domain_xlate_onetwocell,
+};
+
 int twl6030_init_irq(struct device *dev, int irq_num)
 {
 	struct			device_node *node = dev->of_node;
-	int			nr_irqs, irq_base, irq_end;
-	static struct irq_chip  twl6030_irq_chip;
+	int			nr_irqs;
 	int			status;
-	int			i;
 	u8			mask[3];
+	struct irq_domain	*irq_domain;
 
 	nr_irqs = TWL6030_NR_IRQS;
 
-	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
-	if (IS_ERR_VALUE(irq_base)) {
-		dev_err(dev, "Fail to allocate IRQ descs\n");
-		return irq_base;
-	}
-
-	irq_domain_add_legacy(node, nr_irqs, irq_base, 0,
-			      &irq_domain_simple_ops, NULL);
-
-	irq_end = irq_base + nr_irqs;
-
 	mask[0] = 0xFF;
 	mask[1] = 0xFF;
 	mask[2] = 0xFF;
@@ -346,8 +365,6 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 		return status;
 	}
 
-	twl6030_irq_base = irq_base;
-
 	/*
 	 * install an irq handler for each of the modules;
 	 * clone dummy irq_chip since PIH can't *do* anything
@@ -357,20 +374,18 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	twl6030_irq_chip.irq_set_type = NULL;
 	twl6030_irq_chip.irq_set_wake = twl6030_irq_set_wake;
 
-	for (i = irq_base; i < irq_end; i++) {
-		irq_set_chip_and_handler(i, &twl6030_irq_chip,
-					 handle_simple_irq);
-		irq_set_chip_data(i, (void *)irq_num);
-		irq_set_nested_thread(i, true);
-		activate_irq(i);
+	irq_domain = irq_domain_add_linear(node, nr_irqs,
+					   &twl6030_irq_domain_ops, NULL);
+	if (!irq_domain) {
+		dev_err(dev, "Can't add irq_domain\n");
+		return -ENOMEM;
 	}
 
-	dev_info(dev, "PIH (irq %d) nested IRQs %d..%d\n",
-		 irq_num, irq_base, irq_end);
+	dev_info(dev, "PIH (irq %d) nested IRQs\n", irq_num);
 
 	/* install an irq handler to demultiplex the TWL6030 interrupt */
 	status = request_threaded_irq(irq_num, NULL, twl6030_irq_thread,
-				      IRQF_ONESHOT, "TWL6030-PIH", NULL);
+				      IRQF_ONESHOT, "TWL6030-PIH", irq_domain);
 	if (status < 0) {
 		dev_err(dev, "could not claim irq %d: %d\n", irq_num, status);
 		goto fail_irq;
@@ -378,26 +393,19 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 
 	twl_irq = irq_num;
 	register_pm_notifier(&twl6030_irq_pm_notifier_block);
-	return irq_base;
+	return irq_num;
 
 fail_irq:
-	for (i = irq_base; i < irq_end; i++)
-		irq_set_chip_and_handler(i, NULL, NULL);
-
+	irq_domain_remove(irq_domain);
 	return status;
 }
 
 int twl6030_exit_irq(void)
 {
-	unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
-
-	if (!twl6030_irq_base) {
-		pr_err("twl6030: can't yet clean up IRQs?\n");
-		return -ENOSYS;
+	if (twl_irq) {
+		unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
+		free_irq(twl_irq, NULL);
 	}
-
-	free_irq(twl_irq, NULL);
-
 	return 0;
 }
 
-- 
1.7.9.5

