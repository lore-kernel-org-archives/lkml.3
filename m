Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3FXMkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:40:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17676 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3FXMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:40:06 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-2e-51c83e23120e
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
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 1/3] mfd: Add irq domain support for max8998 interrupts
Date: Mon, 24 Jun 2013 14:39:52 +0200
Message-id: <1372077594-17052-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
In-reply-to: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7rKdicCDRa9E7ZYcvEqu8XUh0/Y
	LA782cFosXvOYhaL3gVX2Sy+Xelgstj0+BqrxeVdc9gsZpzfx2Rx+zKvxeNZ89gsDq84wGSx
	7uV0Fov9nR2MFqe7WS0uzbjObrF+xmsWB0GPluYeNo8Fn6+we+ycdZfdY8/Ek2wem1Z1snm8
	Wj2T1ePOtT1sHvNOBnpsXlLvcaEr26NvyypGjzMLjrB7TJ/3k8nj8ya5AL4oLpuU1JzMstQi
	fbsErozP6xuYC46bV+yZ2cLawHhUt4uRg0NCwETi6+aELkZOIFNM4sK99WxdjFwcQgJLGSWu
	XZ/NDOH0MUlsmHyEBaSKTUBN4nPDIzYQW0RAQWJz7zNWkCJmgRssEh2Hm9lBEsICXhK3Lyxh
	BrFZBFQllq1+wwRi8wo4Saw5u4YRYp2CxPHt28BsTgFniQc/poLVCwHVPLrXyziBkXcBI8Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBY+LKDcfExq0OMAhyMSjy8Py2PBwqxJpYVV+Ye
	YpTgYFYS4Q0VOREoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXGLuIJ08D3Hc0sv/p38//3izW4c
	gixcAqeMbRfd5Piizf9O78Tua1G502w3bmgOZLjiG3+m99EtndZSx41MU97sS8mSS7A6uGba
	emadn9J24gyrvzktte3NW3iWq2NTa7zP/YZNMfUnW4+vTwic8n4R43+vuH2inPukxM+kVv2a
	e016qnW5p40SS3FGoqEWc1FxIgBEENuKYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds irq domain support for max8998 interrupts.

To keep both non-DT and DT worlds happy, simple domain is used, which is
linear when no explicit IRQ base is specified and legacy, with static
mapping, otherwise.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/mfd/Kconfig                 |  1 +
 drivers/mfd/max8998-irq.c           | 65 +++++++++++++++++++++++--------------
 drivers/rtc/rtc-max8998.c           | 12 ++++++-
 include/linux/mfd/max8998-private.h |  5 ++-
 include/linux/mfd/max8998.h         |  2 +-
 5 files changed, 57 insertions(+), 28 deletions(-)

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
index 5919710..c469477 100644
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
@@ -176,8 +178,14 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 
 	/* Report */
 	for (i = 0; i < MAX8998_IRQ_NR; i++) {
-		if (irq_reg[max8998_irqs[i].reg - 1] & max8998_irqs[i].mask)
-			handle_nested_irq(max8998->irq_base + i);
+		if (irq_reg[max8998_irqs[i].reg - 1] & max8998_irqs[i].mask) {
+			irq = irq_find_mapping(max8998->irq_domain, i);
+			if (WARN_ON(!irq)) {
+				disable_irq_nosync(max8998->irq);
+				return IRQ_NONE;
+			}
+			handle_nested_irq(irq);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -185,27 +193,40 @@ static irqreturn_t max8998_irq_thread(int irq, void *data)
 
 int max8998_irq_resume(struct max8998_dev *max8998)
 {
-	if (max8998->irq && max8998->irq_base)
-		max8998_irq_thread(max8998->irq_base, max8998);
+	if (max8998->irq && max8998->irq_domain)
+		max8998_irq_thread(max8998->irq, max8998);
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
 
@@ -221,19 +242,13 @@ int max8998_irq_init(struct max8998_dev *max8998)
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
+	domain = irq_domain_add_simple(NULL, MAX8998_IRQ_NR,
+			max8998->irq_base, &max8998_irq_domain_ops, max8998);
+	if (!domain) {
+		dev_err(max8998->dev, "could not create irq domain\n");
+		return -ENODEV;
 	}
+	max8998->irq_domain = domain;
 
 	ret = request_threaded_irq(max8998->irq, NULL, max8998_irq_thread,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
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
index effa5d3..bfb48b6 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -132,6 +132,8 @@ enum {
 
 #define MAX8998_ENRAMP                  (1 << 4)
 
+struct irq_domain;
+
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
@@ -153,7 +155,8 @@ struct max8998_dev {
 	struct mutex iolock;
 	struct mutex irqlock;
 
-	int irq_base;
+	unsigned int irq_base;
+	struct irq_domain *irq_domain;
 	int irq;
 	int ono;
 	u8 irq_masks_cur[MAX8998_NUM_IRQ_REGS];
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index 6823548..7547118 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -100,7 +100,7 @@ struct max8998_regulator_data {
 struct max8998_platform_data {
 	struct max8998_regulator_data	*regulators;
 	int				num_regulators;
-	int				irq_base;
+	unsigned int			irq_base;
 	int				ono;
 	bool				buck_voltage_lock;
 	int				buck1_voltage1;
-- 
1.8.2.1

