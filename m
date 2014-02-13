Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaBMOJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:09:40 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:40418 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaBMOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:09:22 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 17/17] i2c: nomadik: Fixup system suspend
Date: Thu, 13 Feb 2014 15:09:07 +0100
Message-Id: <1392300547-23365-6-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
References: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For !CONFIG_PM_RUNTIME, the device were never put back into active
state while resuming.

For CONFIG_PM_RUNTIME, we blindly trusted the device to be inactive
while we were about to handle it at suspend late, which is just too
optimistic.

Even if the driver uses pm_runtime_put_sync() after each tranfer to
return it's runtime PM resources, there are no guarantees this will
actually mean the device will inactivated. The reason is that the PM
core will prevent runtime suspend during system suspend, and thus when
a transfer occurs during the early phases of system suspend the device
will be kept active after the transfer.

To handle both issues above, we need to re-use the runtime PM callbacks
and check the runtime PM state of the device before proceeding with our
operations for system suspend.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

Changes in v2:
	Rebased on top of latest i2c-nomadik branch.

---
 drivers/i2c/busses/i2c-nomadik.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 8a5dc57b..21539f2 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -879,21 +879,36 @@ static irqreturn_t i2c_irq_handler(int irq, void *arg)
 #ifdef CONFIG_PM_SLEEP
 static int nmk_i2c_suspend_late(struct device *dev)
 {
-	struct amba_device *adev = to_amba_device(dev);
-	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
+	if (!pm_runtime_status_suspended(dev)) {
+		int ret = 0;
+		if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
+			ret = dev->pm_domain->ops.runtime_suspend(dev);
+		else
+			ret = dev->bus->pm->runtime_suspend(dev);
+		if (ret)
+			return ret;
+
+		pm_runtime_set_suspended(dev);
+	}
 
 	pinctrl_pm_select_sleep_state(dev);
-
 	return 0;
 }
 
 static int nmk_i2c_resume_early(struct device *dev)
 {
-	/* First go to the default state */
-	pinctrl_pm_select_default_state(dev);
-	/* Then let's idle the pins until the next transfer happens */
-	pinctrl_pm_select_idle_state(dev);
+	int ret = 0;
+
+	if (dev->pm_domain && dev->pm_domain->ops.runtime_resume)
+		ret = dev->pm_domain->ops.runtime_resume(dev);
+	else
+		ret = dev->bus->pm->runtime_resume(dev);
+	if (ret) {
+		dev_err(dev, "problem resuming\n");
+		return ret;
+	}
 
+	pm_runtime_set_active(dev);
 	return 0;
 }
 #endif
-- 
1.7.9.5

