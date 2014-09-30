Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaI3Rtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:49:33 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:32935 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaI3RtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:49:08 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2 10/10] power/reset: brcmstb: Register with kernel restart handler
Date: Tue, 30 Sep 2014 10:48:36 -0700
Message-Id: <1412099316-23167-11-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel restart handler instead of setting arm_pm_restart directly.

Cc: Marc Carino <marc.ceeeee@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/brcmstb-reboot.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 3f23692..1ad5629 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
+#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -26,8 +27,6 @@
 #include <linux/smp.h>
 #include <linux/mfd/syscon.h>
 
-#include <asm/system_misc.h>
-
 #define RESET_SOURCE_ENABLE_REG 1
 #define SW_MASTER_RESET_REG 2
 
@@ -35,7 +34,8 @@ static struct regmap *regmap;
 static u32 rst_src_en;
 static u32 sw_mstr_rst;
 
-static void brcmstb_reboot(enum reboot_mode mode, const char *cmd)
+static int brcmstb_restart_handler(struct notifier_block *this,
+				   unsigned long mode, void *cmd)
 {
 	int rc;
 	u32 tmp;
@@ -43,31 +43,38 @@ static void brcmstb_reboot(enum reboot_mode mode, const char *cmd)
 	rc = regmap_write(regmap, rst_src_en, 1);
 	if (rc) {
 		pr_err("failed to write rst_src_en (%d)\n", rc);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	rc = regmap_read(regmap, rst_src_en, &tmp);
 	if (rc) {
 		pr_err("failed to read rst_src_en (%d)\n", rc);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	rc = regmap_write(regmap, sw_mstr_rst, 1);
 	if (rc) {
 		pr_err("failed to write sw_mstr_rst (%d)\n", rc);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	rc = regmap_read(regmap, sw_mstr_rst, &tmp);
 	if (rc) {
 		pr_err("failed to read sw_mstr_rst (%d)\n", rc);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	while (1)
 		;
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block brcmstb_restart_nb = {
+	.notifier_call = brcmstb_restart_handler,
+	.priority = 128,
+};
+
 static int brcmstb_reboot_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -93,9 +100,12 @@ static int brcmstb_reboot_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	arm_pm_restart = brcmstb_reboot;
+	rc = register_restart_handler(&brcmstb_restart_nb);
+	if (rc)
+		dev_err(&pdev->dev,
+			"cannot register restart handler (err=%d)\n", rc);
 
-	return 0;
+	return rc;
 }
 
 static const struct of_device_id of_match[] = {
-- 
1.9.1

