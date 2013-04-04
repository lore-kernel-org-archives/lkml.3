Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037Ab3DDQT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:19:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22308 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762981Ab3DDQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:19:53 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-a7-515da8283bc1
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, m.szyprowski@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 1/3] mfd: Add irq domain support for max8998 interrupts
Date: Thu, 04 Apr 2013 18:19:21 +0200
Message-id: <1365092363-12763-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
References: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAV2NFbGBBueOqFr8m32KzeLA7Ies
	Fr0LrrJZnG16w25xedccNosZ5/cxWTRtn8BusfbIXXaL9TNeszhwepyfsZDR4+XE32wefVtW
	MXocv7GdyePzJrkA1igum5TUnMyy1CJ9uwSujHkzeQr2O1YcmnaKpYHxumkXIyeHhICJxPs1
	jSwQtpjEhXvr2boYuTiEBBYxSrxdNJkFwulikvj4eTkjSBWbgJrE54ZHbCC2iICCxObeZ6wg
	RcwC7xklrjx5CeRwcAgLuEu0/AsDqWERUJV4OKUNrJ5XwEni/K0vrBDb5CWe3u9jAynnFHCW
	ODRZGyQsBFTy7PNtxgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfZM+kdjKsa
	LA4xCnAwKvHwZvTFBgqxJpYVV+YeYpTgYFYS4T3aAhTiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAWMN/PKvviJ1083FFdYbXYfdOfJzDznYrzuP3EfmI
	0maj1dtPX+OpP8nlVRll9XrBsXvJwi8/9axJDGu9aCvexPT74OXHNxaLvDy9U2Jp2tKadxa7
	pqzSYudsVcqVa9dsKc3IOhN+9u6DRcmb6oLk5bJq5Np+8O2Zcfjj9ZsOceUPb9WKPLNxUWIp
	zkg01GIuKk4EAIzHd0MvAgAA
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
 drivers/rtc/rtc-max8998.c           | 15 +++++++--
 include/linux/mfd/max8998-private.h |  4 ++-
 include/linux/mfd/max8998.h         |  2 --
 6 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..3ab3a11 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -585,6 +585,7 @@ config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select IRQ_DOMAIN
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998 and
 	  National Semiconductor LP3974. This is a Power Management IC.
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
index 8f234a0..f854983 100644
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
@@ -263,7 +264,6 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->max8998 = max8998;
 	info->rtc = max8998->rtc;
-	info->irq = max8998->irq_base + MAX8998_IRQ_ALARM0;
 
 	platform_set_drvdata(pdev, info);
 
@@ -276,6 +276,15 @@ static int max8998_rtc_probe(struct platform_device *pdev)
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
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
 
@@ -283,6 +292,7 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->irq, ret);
 
+no_irq:
 	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
 	if (pdata->rtc_delay) {
 		info->lp3974_bug_workaround = true;
@@ -303,7 +313,8 @@ static int max8998_rtc_remove(struct platform_device *pdev)
 	struct max8998_rtc_info *info = platform_get_drvdata(pdev);
 
 	if (info) {
-		free_irq(info->irq, info);
+		if (info->irq)
+			free_irq(info->irq, info);
 		rtc_device_unregister(info->rtc_dev);
 		kfree(info);
 	}
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
1.8.1.5

