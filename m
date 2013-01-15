Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3AOM4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:32 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49654 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3AOM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/26] mfd: ab8500-sysctrl: Provide a platform specific pm_power_off() call-back
Date: Tue, 15 Jan 2013 12:55:41 +0000
Message-Id: <1358254566-12419-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel allows us to specify a function call-back which will be
invoked when a system power-off request has been received. Here we
provide one which is to be used when shutting down AB8500 based
platforms.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c      |   22 ++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500.h |    2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index c28d4eb..799fb5e 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -7,12 +7,29 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/signal.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-sysctrl.h>
 
 static struct device *sysctrl_dev;
 
+void ab8500_power_off(void)
+{
+	sigset_t old;
+	sigset_t all;
+
+	sigfillset(&all);
+
+	if (!sigprocmask(SIG_BLOCK, &all, &old)) {
+		(void)ab8500_sysctrl_set(AB8500_STW4500CTRL1,
+					 AB8500_STW4500CTRL1_SWOFF |
+					 AB8500_STW4500CTRL1_SWRESET4500N);
+		(void)sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+}
+
 static inline bool valid_bank(u8 bank)
 {
 	return ((bank == AB8500_SYS_CTRL1_BLOCK) ||
@@ -51,7 +68,12 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 
 static int __devinit ab8500_sysctrl_probe(struct platform_device *pdev)
 {
+	struct ab8500_platform_data *plat;
+
 	sysctrl_dev = &pdev->dev;
+	plat = dev_get_platdata(pdev->dev.parent);
+	if (plat->pm_power_off)
+		pm_power_off = ab8500_power_off;
 	return 0;
 }
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 1491044..96840c4 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -274,6 +274,7 @@ struct ab8500_codec_platform_data;
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
+ * @pm_power_off: Should machine pm power off hook be registered or not
  * @init: board-specific initialization after detection of ab8500
  * @num_regulator_reg_init: number of regulator init registers
  * @regulator_reg_init: regulator init registers
@@ -282,6 +283,7 @@ struct ab8500_codec_platform_data;
  */
 struct ab8500_platform_data {
 	int irq_base;
+	bool pm_power_off;
 	void (*init) (struct ab8500 *);
 	int num_regulator_reg_init;
 	struct ab8500_regulator_reg_init *regulator_reg_init;
-- 
1.7.9.5

