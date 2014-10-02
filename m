Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJBSYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:24:15 -0400
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:46821 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751066AbaJBSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:24:14 -0400
From: Feng Kan <fkan@apm.com>
To: linux@roeck-us.net, dbaryshkov@gmail.com, linux-kernel@vger.kernel.org,
        patches@apm.com, linux-pm@vger.kernel.org, ser@kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 1/1] power: reset: corrections for simple syscon reboot driver
Date: Thu,  2 Oct 2014 11:24:15 -0700
Message-Id: <1412274255-1315-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix some bugs in reboot driver. Which includes auto selection
of the MFD_SYSCON for the driver, use of container to locate restart handler,
correction of the count down failure timer and ordering of the header file.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/power/reset/Kconfig         |  3 ++-
 drivers/power/reset/syscon-reboot.c | 25 ++++++++++---------------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index addb26a..3b451e1 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -120,6 +120,7 @@ config POWER_RESET_KEYSTONE
 
 config POWER_RESET_SYSCON
 	bool "Generic SYSCON regmap reset driver"
-	depends on POWER_RESET && MFD_SYSCON && OF
+	depends on POWER_RESET && OF
+	select MFD_SYSCON
 	help
 	  Reboot support for generic SYSCON mapped register reset.
diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
index 948e0ee..90dfdbf 100644
--- a/drivers/power/reset/syscon-reboot.c
+++ b/drivers/power/reset/syscon-reboot.c
@@ -14,14 +14,15 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+#include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/of_device.h>
-#include <linux/of_address.h>
-#include <linux/platform_device.h>
 #include <linux/notifier.h>
 #include <linux/mfd/syscon.h>
-#include <linux/regmap.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
 #include <linux/reboot.h>
+#include <linux/regmap.h>
 
 struct syscon_reboot_context {
 	struct regmap *map;
@@ -30,21 +31,17 @@ struct syscon_reboot_context {
 	struct notifier_block restart_handler;
 };
 
-static struct syscon_reboot_context *syscon_reboot_ctx;
-
 static int syscon_restart_handle(struct notifier_block *this,
 					unsigned long mode, void *cmd)
 {
-	struct syscon_reboot_context *ctx = syscon_reboot_ctx;
-	unsigned long timeout;
+	struct syscon_reboot_context *ctx =
+			container_of(this, struct syscon_reboot_context,
+					restart_handler);
 
 	/* Issue the reboot */
-	if (ctx->map)
-		regmap_write(ctx->map, ctx->offset, ctx->mask);
+	regmap_write(ctx->map, ctx->offset, ctx->mask);
 
-	timeout = jiffies + HZ;
-	while (time_before(jiffies, timeout))
-		cpu_relax();
+	mdelay(1000);
 
 	pr_emerg("Unable to restart system\n");
 	return NOTIFY_DONE;
@@ -76,8 +73,6 @@ static int syscon_reboot_probe(struct platform_device *pdev)
 	if (err)
 		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
 
-	syscon_reboot_ctx = ctx;
-
 	return 0;
 }
 
-- 
1.9.1

