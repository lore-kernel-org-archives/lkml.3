Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3EUSOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:14:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46895 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3EUSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:14:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:18 -0500
Message-Id: <1369160001-4019-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 4/7] mfd: arizona: Disable interrupts during suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We aren't able to handle interrupts after the device has suspended since
we need to runtime resume it in order to do so but the controller may not
be available any more. Handle this in the same way as we handle a similar
issue on resume.

Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 8002e2d..549db0a 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -409,6 +409,26 @@ static int arizona_runtime_suspend(struct device *dev)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
+static int arizona_suspend(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Suspend, disabling IRQ\n");
+	disable_irq(arizona->irq);
+
+	return 0;
+}
+
+static int arizona_suspend_late(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	dev_dbg(arizona->dev, "Late suspend, reenabling IRQ\n");
+	enable_irq(arizona->irq);
+
+	return 0;
+}
+
 static int arizona_resume_noirq(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
@@ -434,8 +454,9 @@ const struct dev_pm_ops arizona_pm_ops = {
 	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
 			   arizona_runtime_resume,
 			   NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, arizona_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(arizona_suspend, arizona_resume)
 #ifdef CONFIG_PM_SLEEP
+	.suspend_late = arizona_suspend_late,
 	.resume_noirq = arizona_resume_noirq,
 #endif
 };
-- 
1.7.10.4

