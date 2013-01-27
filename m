Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3A0EIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 23:08:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47889 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796Ab3A0EIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 23:08:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/10] mfd: arizona: Disable interrupts during resume
Date: Sun, 27 Jan 2013 12:07:32 +0800
Message-Id: <1359259652-8565-10-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime power management does not function during system suspend but the
Arizona devices need to use runtime power management to power up the device
in order to handle interrupts. Try to avoid interrupts firing during
resume by disabling the primary IRQ before interrupts are reenabled on
resume and only reenabling it again during main resume.

The goal is to avoid issues in the situation where an interrupt is asserted
during resume (eg, due to it being the wake source) and the interrupt
handling gets scheduled prior to the device being able to handle runtime
PM.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5f0de90..0bb79c8 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -263,10 +263,36 @@ static int arizona_runtime_suspend(struct device *dev)
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int arizona_resume_noirq(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Early resume, disabling IRQ\n");
+	disable_irq(arizona->irq);
+
+	return 0;
+}
+
+static int arizona_resume(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Late resume, reenabling IRQ\n");
+	enable_irq(arizona->irq);
+
+	return 0;
+}
+#endif
+
 const struct dev_pm_ops arizona_pm_ops = {
 	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
 			   arizona_runtime_resume,
 			   NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(NULL, arizona_resume)
+#ifdef CONFIG_PM_SLEEP
+	.resume_noirq = arizona_resume_noirq,
+#endif
 };
 EXPORT_SYMBOL_GPL(arizona_pm_ops);
 
-- 
1.7.10.4

