Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3EILIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:08:44 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:36488 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3EILIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:08:43 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] mfd: ab8500-sysctrl: Always enable pm_power_off handler
Date: Thu,  9 May 2013 13:08:08 +0200
Message-Id: <1368097688-17858-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AB8500 sysctrl driver implements a pm_power_off handler, but that is
currently not registered until a specific platform data field is
enabled.

This patch drops the platform data field and always registers
ab8500_power_off if no other pm_power_off handler was defined before,
and also introduces the necessary cleanup code in the driver's remove
function.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c      | 6 +++++-
 include/linux/mfd/abx500/ab8500.h | 2 --
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index eadae4d..8e0dae5 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -193,7 +193,7 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 
 	sysctrl_dev = &pdev->dev;
 
-	if (plat->pm_power_off)
+	if (!pm_power_off)
 		pm_power_off = ab8500_power_off;
 
 	pdata = plat->sysctrl;
@@ -227,6 +227,10 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 static int ab8500_sysctrl_remove(struct platform_device *pdev)
 {
 	sysctrl_dev = NULL;
+
+	if (pm_power_off == ab8500_power_off)
+		pm_power_off = NULL;
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index b5780fd..6c119b5 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -374,7 +374,6 @@ struct ab8500_sysctrl_platform_data;
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
- * @pm_power_off: Should machine pm power off hook be registered or not
  * @init: board-specific initialization after detection of ab8500
  * @num_regulator_reg_init: number of regulator init registers
  * @regulator_reg_init: regulator init registers
@@ -383,7 +382,6 @@ struct ab8500_sysctrl_platform_data;
  */
 struct ab8500_platform_data {
 	int irq_base;
-	bool pm_power_off;
 	void (*init) (struct ab8500 *);
 	int num_regulator_reg_init;
 	struct ab8500_regulator_reg_init *regulator_reg_init;
-- 
1.8.2

