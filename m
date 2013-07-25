Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3GYNR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:17:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51298 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3GYNRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:17:50 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, Ruslan Bilovol <ruslan.bilovol@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 4/5] mfd: twl6030-irq: create struct twl6030_irq
Date: Thu, 25 Jul 2013 16:15:50 +0300
Message-ID: <1374758151-12097-5-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
References: <1374758151-12097-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create "struct twl6030_irq" and place all local variables inside it.
Also allocate twl6030_irq structure dynamically during initialization.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/mfd/twl6030-irq.c |  101 ++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 42 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 1b03ce9..e3c54f8 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -86,36 +86,44 @@ static int twl6030_interrupt_mapping[24] = {
 };
 /*----------------------------------------------------------------------*/
 
-static int twl_irq;
-static bool twl_irq_wake_enabled;
+struct twl6030_irq {
+	unsigned int		irq_base;
+	int			twl_irq;
+	bool			irq_wake_enabled;
+	atomic_t		wakeirqs;
+	struct notifier_block	pm_nb;
+	struct irq_chip		irq_chip;
+	struct irq_domain	*irq_domain;
+};
 
-static atomic_t twl6030_wakeirqs = ATOMIC_INIT(0);
-struct irq_domain	*irq_domain;
+static struct twl6030_irq *twl6030_irq;
 
 static int twl6030_irq_pm_notifier(struct notifier_block *notifier,
 				   unsigned long pm_event, void *unused)
 {
 	int chained_wakeups;
+	struct twl6030_irq *pdata = container_of(notifier, struct twl6030_irq,
+						  pm_nb);
 
 	switch (pm_event) {
 	case PM_SUSPEND_PREPARE:
-		chained_wakeups = atomic_read(&twl6030_wakeirqs);
+		chained_wakeups = atomic_read(&pdata->wakeirqs);
 
-		if (chained_wakeups && !twl_irq_wake_enabled) {
-			if (enable_irq_wake(twl_irq))
+		if (chained_wakeups && !pdata->irq_wake_enabled) {
+			if (enable_irq_wake(pdata->twl_irq))
 				pr_err("twl6030 IRQ wake enable failed\n");
 			else
-				twl_irq_wake_enabled = true;
-		} else if (!chained_wakeups && twl_irq_wake_enabled) {
-			disable_irq_wake(twl_irq);
-			twl_irq_wake_enabled = false;
+				pdata->irq_wake_enabled = true;
+		} else if (!chained_wakeups && pdata->irq_wake_enabled) {
+			disable_irq_wake(pdata->twl_irq);
+			pdata->irq_wake_enabled = false;
 		}
 
-		disable_irq(twl_irq);
+		disable_irq(pdata->twl_irq);
 		break;
 
 	case PM_POST_SUSPEND:
-		enable_irq(twl_irq);
+		enable_irq(pdata->twl_irq);
 		break;
 
 	default:
@@ -125,10 +133,6 @@ static int twl6030_irq_pm_notifier(struct notifier_block *notifier,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block twl6030_irq_pm_notifier_block = {
-	.notifier_call = twl6030_irq_pm_notifier,
-};
-
 /*
 * Threaded irq handler for the twl6030 interrupt.
 * We query the interrupt controller in the twl6030 to determine
@@ -138,11 +142,11 @@ static struct notifier_block twl6030_irq_pm_notifier_block = {
 static irqreturn_t twl6030_irq_thread(int irq, void *data)
 {
 	int i, ret;
-	struct irq_domain *irq_domain = (struct irq_domain *)data;
 	union {
 		u8 bytes[4];
 		u32 int_sts;
 	} sts;
+	struct twl6030_irq *pdata = data;
 
 	/* read INT_STS_A, B and C in one shot using a burst read */
 	ret = twl_i2c_read(TWL_MODULE_PIH, sts.bytes, REG_INT_STS_A, 3);
@@ -163,7 +167,7 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
 		if (sts.int_sts & 0x1) {
 			int module_irq =
-				irq_find_mapping(irq_domain,
+				irq_find_mapping(pdata->irq_domain,
 						 twl6030_interrupt_mapping[i]);
 			if (module_irq)
 				handle_nested_irq(module_irq);
@@ -194,10 +198,12 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 
 static int twl6030_irq_set_wake(struct irq_data *d, unsigned int on)
 {
+	struct twl6030_irq *pdata = irq_get_chip_data(d->irq);
+
 	if (on)
-		atomic_inc(&twl6030_wakeirqs);
+		atomic_inc(&pdata->wakeirqs);
 	else
-		atomic_dec(&twl6030_wakeirqs);
+		atomic_dec(&pdata->wakeirqs);
 
 	return 0;
 }
@@ -272,7 +278,8 @@ int twl6030_mmc_card_detect_config(void)
 		return ret;
 	}
 
-	return irq_find_mapping(irq_domain, MMCDETECT_INTR_OFFSET);
+	return irq_find_mapping(twl6030_irq->irq_domain,
+				 MMCDETECT_INTR_OFFSET);
 }
 EXPORT_SYMBOL(twl6030_mmc_card_detect_config);
 
@@ -301,15 +308,15 @@ int twl6030_mmc_card_detect(struct device *dev, int slot)
 }
 EXPORT_SYMBOL(twl6030_mmc_card_detect);
 
-static struct irq_chip twl6030_irq_chip;
-
 static int twl6030_irq_map(struct irq_domain *d, unsigned int virq,
 			      irq_hw_number_t hwirq)
 {
-	irq_set_chip_data(virq, &twl6030_irq_chip);
-	irq_set_chip_and_handler(virq,  &twl6030_irq_chip, handle_simple_irq);
+	struct twl6030_irq *pdata = d->host_data;
+
+	irq_set_chip_data(virq, pdata);
+	irq_set_chip_and_handler(virq,  &pdata->irq_chip, handle_simple_irq);
 	irq_set_nested_thread(virq, true);
-	irq_set_parent(virq, twl_irq);
+	irq_set_parent(virq, pdata->twl_irq);
 
 #ifdef CONFIG_ARM
 	/*
@@ -349,6 +356,12 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 
 	nr_irqs = TWL6030_NR_IRQS;
 
+	twl6030_irq = devm_kzalloc(dev, sizeof(*twl6030_irq), GFP_KERNEL);
+	if (!twl6030_irq) {
+		dev_err(dev, "twl6030_irq: Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
 	mask[0] = 0xFF;
 	mask[1] = 0xFF;
 	mask[2] = 0xFF;
@@ -369,14 +382,18 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	 * install an irq handler for each of the modules;
 	 * clone dummy irq_chip since PIH can't *do* anything
 	 */
-	twl6030_irq_chip = dummy_irq_chip;
-	twl6030_irq_chip.name = "twl6030";
-	twl6030_irq_chip.irq_set_type = NULL;
-	twl6030_irq_chip.irq_set_wake = twl6030_irq_set_wake;
-
-	irq_domain = irq_domain_add_linear(node, nr_irqs,
-					   &twl6030_irq_domain_ops, NULL);
-	if (!irq_domain) {
+	twl6030_irq->irq_chip = dummy_irq_chip;
+	twl6030_irq->irq_chip.name = "twl6030";
+	twl6030_irq->irq_chip.irq_set_type = NULL;
+	twl6030_irq->irq_chip.irq_set_wake = twl6030_irq_set_wake;
+
+	twl6030_irq->pm_nb.notifier_call = twl6030_irq_pm_notifier;
+	atomic_set(&twl6030_irq->wakeirqs, 0);
+
+	twl6030_irq->irq_domain =
+		irq_domain_add_linear(node, nr_irqs,
+				      &twl6030_irq_domain_ops, twl6030_irq);
+	if (!twl6030_irq->irq_domain) {
 		dev_err(dev, "Can't add irq_domain\n");
 		return -ENOMEM;
 	}
@@ -385,26 +402,26 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 
 	/* install an irq handler to demultiplex the TWL6030 interrupt */
 	status = request_threaded_irq(irq_num, NULL, twl6030_irq_thread,
-				      IRQF_ONESHOT, "TWL6030-PIH", irq_domain);
+				      IRQF_ONESHOT, "TWL6030-PIH", twl6030_irq);
 	if (status < 0) {
 		dev_err(dev, "could not claim irq %d: %d\n", irq_num, status);
 		goto fail_irq;
 	}
 
-	twl_irq = irq_num;
-	register_pm_notifier(&twl6030_irq_pm_notifier_block);
+	twl6030_irq->twl_irq = irq_num;
+	register_pm_notifier(&twl6030_irq->pm_nb);
 	return 0;
 
 fail_irq:
-	irq_domain_remove(irq_domain);
+	irq_domain_remove(twl6030_irq->irq_domain);
 	return status;
 }
 
 int twl6030_exit_irq(void)
 {
-	if (twl_irq) {
-		unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
-		free_irq(twl_irq, NULL);
+	if (twl6030_irq && twl6030_irq->twl_irq) {
+		unregister_pm_notifier(&twl6030_irq->pm_nb);
+		free_irq(twl6030_irq->twl_irq, NULL);
 		/*
 		 * TODO: IRQ domain and allocated nested IRQ descriptors
 		 * should be freed somehow here. Now It can't be done, because
-- 
1.7.9.5

