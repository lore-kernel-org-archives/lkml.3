Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaI3Rsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:48:47 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64155 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaI3Rsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:48:45 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 01/10] power/reset: vexpress: Register with kernel restart handler
Date: Tue, 30 Sep 2014 10:48:27 -0700
Message-Id: <1412099316-23167-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel restart handler instead of setting arm_pm_restart directly.
This allows for more than one restart handler in the system.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/vexpress-poweroff.c | 40 ++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index 4dc102e2..9dfc9ce 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -12,14 +12,14 @@
  */
 
 #include <linux/delay.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/stat.h>
 #include <linux/vexpress.h>
 
-#include <asm/system_misc.h>
-
 static void vexpress_reset_do(struct device *dev, const char *what)
 {
 	int err = -ENOENT;
@@ -43,11 +43,19 @@ static void vexpress_power_off(void)
 
 static struct device *vexpress_restart_device;
 
-static void vexpress_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int vexpress_restart(struct notifier_block *this, unsigned long mode,
+			     void *cmd)
 {
 	vexpress_reset_do(vexpress_restart_device, "restart");
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block vexpress_restart_nb = {
+	.notifier_call = vexpress_restart,
+	.priority = 128,
+};
+
 static ssize_t vexpress_reset_active_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -86,12 +94,28 @@ static struct of_device_id vexpress_reset_of_match[] = {
 	{}
 };
 
+static int _vexpress_register_restart_handler(struct device *dev)
+{
+	int err;
+
+	vexpress_restart_device = dev;
+	err = register_restart_handler(&vexpress_restart_nb);
+	if (err) {
+		dev_err(dev, "cannot register restart handler (err=%d)\n", err);
+		return err;
+	}
+	device_create_file(dev, &dev_attr_active);
+
+	return 0;
+}
+
 static int vexpress_reset_probe(struct platform_device *pdev)
 {
 	enum vexpress_reset_func func;
 	const struct of_device_id *match =
 			of_match_device(vexpress_reset_of_match, &pdev->dev);
 	struct regmap *regmap;
+	int ret = 0;
 
 	if (match)
 		func = (enum vexpress_reset_func)match->data;
@@ -110,18 +134,14 @@ static int vexpress_reset_probe(struct platform_device *pdev)
 		break;
 	case FUNC_RESET:
 		if (!vexpress_restart_device)
-			vexpress_restart_device = &pdev->dev;
-		arm_pm_restart = vexpress_restart;
-		device_create_file(&pdev->dev, &dev_attr_active);
+			ret = _vexpress_register_restart_handler(&pdev->dev);
 		break;
 	case FUNC_REBOOT:
-		vexpress_restart_device = &pdev->dev;
-		arm_pm_restart = vexpress_restart;
-		device_create_file(&pdev->dev, &dev_attr_active);
+		ret = _vexpress_register_restart_handler(&pdev->dev);
 		break;
 	};
 
-	return 0;
+	return ret;
 }
 
 static const struct platform_device_id vexpress_reset_id_table[] = {
-- 
1.9.1

