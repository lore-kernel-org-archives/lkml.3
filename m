Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab3CVLk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:40:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33939 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932160Ab3CVLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:40:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Don't use system PM operations
Date: Fri, 22 Mar 2013 12:40:22 +0100
Message-Id: <1363952422-27426-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For realistic systems the power management is controlled entirely via
runtime PM - if the device is not runtime suspended then the suspend
will abort without doing anything as functionality such as accessory
detection or audio bypass will require the device to be enabled while
if the device is runtime suspended it is already in the lowest power
state. This means that system suspend is redundant and can be removed
which avoids issues with attempting to double disable the regulators.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 803e93f..8737a47 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -191,7 +191,7 @@ static const char *wm8958_main_supplies[] = {
 	"SPKVDD2",
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_RUNTIME
 static int wm8994_suspend(struct device *dev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(dev);
@@ -724,8 +724,9 @@ static const struct i2c_device_id wm8994_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8994_i2c_id);
 
-static UNIVERSAL_DEV_PM_OPS(wm8994_pm_ops, wm8994_suspend, wm8994_resume,
-			    NULL);
+static const struct dev_pm_ops wm8994_pm_ops = {
+	SET_RUNTIME_PM_OPS(wm8994_suspend, wm8994_resume, NULL)
+};
 
 static struct i2c_driver wm8994_i2c_driver = {
 	.driver = {
-- 
1.7.10.4

