Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161570Ab3BOM50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:26 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55610 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab3BOM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
Date: Fri, 15 Feb 2013 12:56:32 +0000
Message-Id: <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel WILLERUD <daniel.willerud@stericsson.com>

suspend/resume methods implemented to prevent suspend while the gpadc
driver is busy.

Signed-off-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Ulf HANSSON <ulf.hansson@stericsson.com>
---
 drivers/mfd/ab8500-gpadc.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index b1f3561..9ed3afc 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -605,6 +605,31 @@ static int ab8500_gpadc_runtime_idle(struct device *dev)
 	return 0;
 }
 
+static int ab8500_gpadc_suspend(struct device *dev)
+{
+	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+
+	mutex_lock(&gpadc->ab8500_gpadc_lock);
+
+	pm_runtime_get_sync(dev);
+
+	regulator_disable(gpadc->regu);
+	return 0;
+}
+
+static int ab8500_gpadc_resume(struct device *dev)
+{
+	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+
+	regulator_enable(gpadc->regu);
+
+	pm_runtime_mark_last_busy(gpadc->dev);
+	pm_runtime_put_autosuspend(gpadc->dev);
+
+	mutex_unlock(&gpadc->ab8500_gpadc_lock);
+	return 0;
+}
+
 static int ab8500_gpadc_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -698,6 +723,9 @@ static const struct dev_pm_ops ab8500_gpadc_pm_ops = {
 	SET_RUNTIME_PM_OPS(ab8500_gpadc_runtime_suspend,
 			   ab8500_gpadc_runtime_resume,
 			   ab8500_gpadc_runtime_idle)
+	SET_SYSTEM_SLEEP_PM_OPS(ab8500_gpadc_suspend,
+				ab8500_gpadc_resume)
+
 };
 
 static struct platform_driver ab8500_gpadc_driver = {
-- 
1.7.10.4

