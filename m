Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3LJXgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:36:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3LJXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:35:29 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/8] mfd: pm8921: Update for genirq changes
Date: Tue, 10 Dec 2013 15:35:21 -0800
Message-Id: <1386718523-2587-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this code has been marked broken for some time a few genirq
tree wide changes weren't made. set_irq_wake() was renamed to
irq_set_irq_wake() in commit a0cd9ca2b (genirq: Namespace
cleanup, 2011-02-10) and commit 10a8c383 (irq: introduce entry
and exit functions for chained handlers) introduced the chained
irq functions but this driver wasn't updated to use them. Fix
these problems and remove the BROKEN marking on this driver.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/Kconfig       | 1 -
 drivers/mfd/pm8921-core.c | 7 +++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9ee4ce6..35007ed 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -453,7 +453,6 @@ config MFD_PM8XXX
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
 	depends on (ARCH_MSM || HEXAGON)
-	depends on BROKEN
 	select MFD_CORE
 	select MFD_PM8XXX
 	help
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 143f59d..083fab2 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -174,6 +175,8 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
 	u8	root;
 	int	i, ret, masters = 0;
 
+	chained_irq_enter(irq_chip, desc);
+
 	ret = pm8xxx_read_root_irq(chip, &root);
 	if (ret) {
 		pr_err("Can't read root status ret=%d\n", ret);
@@ -188,7 +191,7 @@ static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
 		if (masters & (1 << i))
 			pm8xxx_irq_master_handler(chip, i);
 
-	irq_chip->irq_ack(&desc->irq_data);
+	chained_irq_exit(irq_chip, desc);
 }
 
 static void pm8xxx_irq_mask_ack(struct irq_data *d)
@@ -368,7 +371,7 @@ struct pm_irq_chip *  pm8xxx_irq_init(struct device *dev,
 	irq_set_irq_type(devirq, pdata->irq_trigger_flag);
 	irq_set_handler_data(devirq, chip);
 	irq_set_chained_handler(devirq, pm8xxx_irq_handler);
-	set_irq_wake(devirq, 1);
+	irq_set_irq_wake(devirq, 1);
 
 	return chip;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

