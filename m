Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3DJDTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:19:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:27655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab3DJDTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,443,1363158000"; 
   d="scan'208";a="225345126"
Subject: mfd, arizona: Fix the deadlock between interrupt handler and
 dpm_suspend
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Apr 2013 20:39:09 +0800
Message-ID: <1365597549.12565.4.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When system try to do the suspend:
T1:suspend_thread                         T2: interrupt thread handler
enter_state()                             arizona_irq_thread()
 suspend_devices_and_enter()                regmap_read()
  __device_suspend()
                                              regmap_spi_read()
                                               spi_write_then_read()
                                                spi_sync()
                                                 __spi_sync()
                                                  wait_for_completion()
                                          T2 <== Blocked here due to spi suspended
 suspend_enter()
  dpm_suspend_end()
   dpm_suspend_noirq()
    suspend_device_irqs()
     synchronize_irq()
T1 <== Blocked here due waiting for T2 finished

Then T1 and T2 is deadlocked there.

Here the arizona irq is not NOSUSPEND irq, so when doing device suspend,
we can disable the arizona irq, and enable it until devices resuming finished.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/mfd/arizona-core.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index b562c7b..b11bd01 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -264,11 +264,11 @@ static int arizona_runtime_suspend(struct device *dev)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
-static int arizona_resume_noirq(struct device *dev)
+static int arizona_suspend(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
 
-	dev_dbg(arizona->dev, "Early resume, disabling IRQ\n");
+	dev_dbg(arizona->dev, "Suspend, disabling IRQ\n");
 	disable_irq(arizona->irq);
 
 	return 0;
@@ -278,7 +278,7 @@ static int arizona_resume(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
 
-	dev_dbg(arizona->dev, "Late resume, reenabling IRQ\n");
+	dev_dbg(arizona->dev, "Resume, reenabling IRQ\n");
 	enable_irq(arizona->irq);
 
 	return 0;
@@ -289,10 +289,7 @@ const struct dev_pm_ops arizona_pm_ops = {
 	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
 			   arizona_runtime_resume,
 			   NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, arizona_resume)
-#ifdef CONFIG_PM_SLEEP
-	.resume_noirq = arizona_resume_noirq,
-#endif
+	SET_SYSTEM_SLEEP_PM_OPS(arizona_suspend, arizona_resume)
 };
 EXPORT_SYMBOL_GPL(arizona_pm_ops);
 
-- 
1.7.0.4



