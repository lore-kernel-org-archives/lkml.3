Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaBDQBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:01:23 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:42379 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaBDP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:59 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 15/17] i2c: nomadik: Convert to late and early system PM callbacks
Date: Tue,  4 Feb 2014 16:58:56 +0100
Message-Id: <1391529538-21685-16-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At system suspend_late, runtime PM has been disabled by the PM core
which means we can safely operate on these resources. Consequentially
we no longer have to wait until the noirq phase of the system suspend.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 2d7dbc9..eda4f0d 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -890,9 +890,8 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-
-#ifdef CONFIG_PM
-static int nmk_i2c_suspend(struct device *dev)
+#ifdef CONFIG_PM_SLEEP
+static int nmk_i2c_suspend_late(struct device *dev)
 {
 	struct amba_device *adev = to_amba_device(dev);
 	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
@@ -905,7 +904,7 @@ static int nmk_i2c_suspend(struct device *dev)
 	return 0;
 }
 
-static int nmk_i2c_resume(struct device *dev)
+static int nmk_i2c_resume_early(struct device *dev)
 {
 	/* First go to the default state */
 	pinctrl_pm_select_default_state(dev);
@@ -914,9 +913,6 @@ static int nmk_i2c_resume(struct device *dev)
 
 	return 0;
 }
-#else
-#define nmk_i2c_suspend	NULL
-#define nmk_i2c_resume	NULL
 #endif
 
 #if CONFIG_PM
@@ -942,14 +938,8 @@ static int nmk_i2c_runtime_resume(struct device *dev)
 }
 #endif
 
-/*
- * We use noirq so that we suspend late and resume before the wakeup interrupt
- * to ensure that we do the !pm_runtime_suspended() check in resume before
- * there has been a regular pm runtime resume (via pm_runtime_get_sync()).
- */
 static const struct dev_pm_ops nmk_i2c_pm = {
-	.suspend_noirq	= nmk_i2c_suspend,
-	.resume_noirq	= nmk_i2c_resume,
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(nmk_i2c_suspend_late, nmk_i2c_resume_early)
 	SET_PM_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
 			nmk_i2c_runtime_resume,
 			NULL)
-- 
1.7.9.5

