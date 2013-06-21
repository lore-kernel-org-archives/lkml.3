Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161409Ab3FUMes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:34:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62912 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161196Ab3FUMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:34:01 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-98-51c448364b2f
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/3] mfd: Add irq domain support for max8998 interrupts
Date: Fri, 21 Jun 2013 14:33:35 +0200
Message-id: <1371818017-5215-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
In-reply-to: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
References: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xq7pmHkcCDRa3GlgsuXiV3WLqwyds
	Fgf+7GC02D1nMYtF74KrbBZnm96wW3y70sFksenxNVaLy7vmsFnMOL+PyeL2ZV6LwysOMFms
	ezmdxWJ/ZwejxeluVotLM66zW6yf8ZrFQdCjpbmHzWPB5yvsHjtn3WX32DPxJJvHplWdbB6v
	Vs9k9bhzbQ+bx7yTgR6bl9R79G1ZxehxZsERdo/p834yeXzeJBfAG8Vlk5Kak1mWWqRvl8CV
	8ePdIvaCl3YVS/bNY29gPGDcxcjJISFgItGyfBU7hC0mceHeerYuRi4OIYGljBINc64yQTh9
	TBLrZv1hA6liE1CT+NzwCMwWEVCQ2Nz7jBWkiFngGovElis3wBLCAl4SczrmM4HYLAKqEmsX
	/mMFsXkFHCX+/XrNCLFOQeL49m1gNqeAk8SnBUvAzhACqtnzcB/LBEbeBYwMqxhFU0uTC4qT
	0nON9IoTc4tL89L1kvNzNzFCouDrDsalx6wOMQpwMCrx8AYqHQ4UYk0sK67MPcQowcGsJMIb
	fAcoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTF9zQ5rjVqtZ5baSZMuB9+3TF4X6lzUXrLx0Bxm
	U6/o9G6hyBMfu5etN/izd46c1quSPo73pzQn2L3Nyf31JMtv18vNFo6/V9sve/9LKOaGb9SL
	7PpXJuuPZ22ae+vZ1IvcXukHlLY0Bywre+j7t37NtITu56UTpqxSirrw7ZbztvRoje+Bh0OV
	WIozEg21mIuKEwHFuP9sYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds irq domain support for max8998 interrupts.

The reverse mapping method used is linear mapping since the sub-drivers
of max8998 such as regulator and charger drivers can use the max8998
irq_domain to get the virtual irq number for max8998 interrupts.

All uses of irq_base in platform data and max8997 driver private data
are removed.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Kconfig                 |  1 +
 drivers/mfd/max8998-irq.c           | 61 ++++++++++++++++++++++---------------
 drivers/mfd/max8998.c               |  1 -
 drivers/rtc/rtc-max8998.c           | 12 +++++++-
 include/linux/mfd/max8998-private.h |  4 ++-
 include/linux/mfd/max8998.h         |  2 --
 6 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d54e985..360be92 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1002,6 +1002,7 @@ config MFD_TC6393XB
 config MFD_VX855
 	tristate "VIA VX855/VX875 integrated south bridge"
 	depends on PCI && GENERIC_HARDIRQS
+	select IRQ_DOMAIN
 	select MFD_CORE
 	help
 	  Say yes here to enable support for various functions of the
diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index 5919710..f770abf 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/mfd/max8998-private.h>
 
 struct max8998_irq_data {
@@ -99,7 +100,8 @@ static struct max8998_irq_data max8998_irqs[] = {
 static inline struct max8998_irq_data *
 irq_to_max8998_irq(struct max8998_dev *max8998, int irq)
 {
-	return &max8998_irqs[irq - max8998->irq_base];
+	struct irq_data *data = irq_get_irq_data(irq);
+	return &max8998_irqs[data->hwirq];
 }
 
 static void max8998_irq_lock(struct irq_data *data)
@@ -176,8 +178,10 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 
 	/* Report */
 	for (i = 0; i < MAX8998_IRQ_NR; i++) {
-		if (irq_reg[max8998_irqs[i].reg - 1] & max8998_irqs[i].mask)
-			handle_nested_irq(max8998->irq_base + i);
+		if (irq_reg[max8998_irqs[i].reg - 1] & max8998_irqs[i].mask) {
+			irq = irq_linear_revmap(max8998->irq_domain, i);
+			handle_nested_irq(irq);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -185,27 +189,40 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 
 int max8998_irq_resume(struct max8998_dev *max8998)
 {
-	if (max8998->irq && max8998->irq_base)
-		max8998_irq_thread(max8998->irq_base, max8998);
+	if (max8998->irq && max8998->irq_domain)
+		max8998_irq_thread(0, max8998);
+	return 0;
+}
+
+static int max8998_irq_domain_map(struct irq_domain *d, unsigned int irq,
+					irq_hw_number_t hw)
+{
+	struct max8997_dev *max8998 = d->host_data;
+
+	irq_set_chip_data(irq, max8998);
+	irq_set_chip_and_handler(irq, &max8998_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
 	return 0;
 }
 
+static struct irq_domain_ops max8998_irq_domain_ops = {
+	.map = max8998_irq_domain_map,
+};
+
 int max8998_irq_init(struct max8998_dev *max8998)
 {
 	int i;
-	int cur_irq;
 	int ret;
+	struct irq_domain *domain;
 
 	if (!max8998->irq) {
 		dev_warn(max8998->dev,
 			 "No interrupt specified, no interrupts\n");
-		max8998->irq_base = 0;
-		return 0;
-	}
-
-	if (!max8998->irq_base) {
-		dev_err(max8998->dev,
-			"No interrupt base specified, no interrupts\n");
 		return 0;
 	}
 
@@ -221,19 +238,13 @@ int max8998_irq_init(struct max8998_dev *max8998)
 	max8998_write_reg(max8998->i2c, MAX8998_REG_STATUSM1, 0xff);
 	max8998_write_reg(max8998->i2c, MAX8998_REG_STATUSM2, 0xff);
 
-	/* register with genirq */
-	for (i = 0; i < MAX8998_IRQ_NR; i++) {
-		cur_irq = i + max8998->irq_base;
-		irq_set_chip_data(cur_irq, max8998);
-		irq_set_chip_and_handler(cur_irq, &max8998_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
+	domain = irq_domain_add_linear(NULL, MAX8998_IRQ_NR,
+					&max8998_irq_domain_ops, max8998);
+	if (!domain) {
+		dev_err(max8998->dev, "could not create irq domain\n");
+		return -ENODEV;
 	}
+	max8998->irq_domain = domain;
 
 	ret = request_threaded_irq(max8998->irq, NULL, max8998_irq_thread,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index d7218cc..e9bd352 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -146,7 +146,6 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	max8998->type = id->driver_data;
 	if (pdata) {
 		max8998->ono = pdata->ono;
-		max8998->irq_base = pdata->irq_base;
 		max8998->wakeup = pdata->wakeup;
 	}
 	mutex_init(&max8998->iolock);
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index d5af7ba..46f2301 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/bcd.h>
+#include <linux/irqdomain.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/max8998.h>
@@ -264,7 +265,6 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->max8998 = max8998;
 	info->rtc = max8998->rtc;
-	info->irq = max8998->irq_base + MAX8998_IRQ_ALARM0;
 
 	platform_set_drvdata(pdev, info);
 
@@ -277,6 +277,15 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
+	if (!max8998->irq_domain)
+		goto no_irq;
+
+	info->irq = irq_create_mapping(max8998->irq_domain, MAX8998_IRQ_ALARM0);
+	if (!info->irq) {
+		dev_warn(&pdev->dev, "Failed to map alarm IRQ\n");
+		goto no_irq;
+	}
+
 	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
 				max8998_rtc_alarm_irq, 0, "rtc-alarm0", info);
 
@@ -284,6 +293,7 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
 
+no_irq:
 	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
 	if (pdata && pdata->rtc_delay) {
 		info->lp3974_bug_workaround = true;
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index effa5d3..e81077a 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -132,6 +132,8 @@ enum {
 
 #define MAX8998_ENRAMP                  (1 << 4)
 
+struct irq_domain;
+
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
@@ -153,7 +155,7 @@ struct max8998_dev {
 	struct mutex iolock;
 	struct mutex irqlock;
 
-	int irq_base;
+	struct irq_domain *irq_domain;
 	int irq;
 	int ono;
 	u8 irq_masks_cur[MAX8998_NUM_IRQ_REGS];
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 6823548..9df60ba 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -68,7 +68,6 @@ struct max8998_regulator_data {
  * struct max8998_board - packages regulator init data
  * @regulators: array of defined regulators
  * @num_regulators: number of regulators used
- * @irq_base: base IRQ number for max8998, required for IRQs
  * @ono: power onoff IRQ number for max8998
  * @buck_voltage_lock: Do NOT change the values of the following six
  *   registers set by buck?_voltage?. The voltage of BUCK1/2 cannot
@@ -100,7 +99,6 @@ struct max8998_regulator_data {
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
 	int				num_regulators;
-	int				irq_base;
 	int				ono;
 	bool				buck_voltage_lock;
 	int				buck1_voltage1;
-- 
1.8.2.1

