Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaI0A5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:57:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40502 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaI0A5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:57:48 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Loc Ho <lho@apm.com>
Subject: [PATCH 06/10] power/reset: xgene: Register with kernel restart handler
Date: Fri, 26 Sep 2014 17:57:14 -0700
Message-Id: <1411779438-23127-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel restart handler instead of setting arm_pm_restart directly.

This patch also addresses the following compile warning.

drivers/power/reset/xgene-reboot.c: In function 'xgene_reboot_probe':
drivers/power/reset/xgene-reboot.c:77:17: warning:
	assignment from incompatible pointer type [enabled by default]

The warning was due to a mismatch between the type of arm_pm_restart
and the restart function.

Cc: Loc Ho <lho@apm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/xgene-reboot.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index ae470b8..1e7f5f5 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -26,32 +26,36 @@
  */
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/notifier.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
-#include <asm/system_misc.h>
 
 struct xgene_reboot_context {
 	struct device *dev;
 	void *csr;
 	u32 mask;
+	struct notifier_block restart_handler;
 };
 
-static struct xgene_reboot_context *xgene_restart_ctx;
-
-static void xgene_restart(char str, const char *cmd)
+static int xgene_restart_handler(struct notifier_block *this,
+				 unsigned long mode, void *cmd)
 {
-	struct xgene_reboot_context *ctx = xgene_restart_ctx;
+	struct xgene_reboot_context *ctx =
+		container_of(this, struct xgene_reboot_context,
+			     restart_handler);
 
 	/* Issue the reboot */
-	if (ctx)
-		writel(ctx->mask, ctx->csr);
+	writel(ctx->mask, ctx->csr);
 
 	mdelay(1000);
 
 	dev_emerg(ctx->dev, "Unable to restart system\n");
+
+	return NOTIFY_DONE;
 }
 
 static int xgene_reboot_probe(struct platform_device *pdev)
@@ -73,8 +77,11 @@ static int xgene_reboot_probe(struct platform_device *pdev)
 		ctx->mask = 0xFFFFFFFF;
 
 	ctx->dev = dev;
-	arm_pm_restart = xgene_restart;
-	xgene_restart_ctx = ctx;
+	ctx->restart_handler.notifier_call = xgene_restart_handler;
+	ctx->restart_handler.priority = 128;
+	err = register_restart_handler(&ctx->restart_handler);
+	if (err)
+		dev_err(dev, "cannot register restart handler (err=%d)\n", err);
 
 	return 0;
 }
-- 
1.9.1

