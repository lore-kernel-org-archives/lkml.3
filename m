Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaI3RvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:51:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48576 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaI3Rsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:48:55 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Loc Ho <lho@apm.com>
Subject: [PATCH v2 05/10] power/reset: xgene: Use mdelay instead of jiffies based timeout
Date: Tue, 30 Sep 2014 10:48:31 -0700
Message-Id: <1412099316-23167-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jiffies are not running at this stage of system shutdown, meaning an
error in the reset function would never be reported. Replace with mdelay().

Cc: Loc Ho <lho@apm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/xgene-reboot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index 1bab003..ae470b8 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -24,6 +24,7 @@
  * For system shutdown, this is board specify. If a board designer
  * implements GPIO shutdown, use the gpio-poweroff.c driver.
  */
+#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -43,15 +44,12 @@ static struct xgene_reboot_context *xgene_restart_ctx;
 static void xgene_restart(char str, const char *cmd)
 {
 	struct xgene_reboot_context *ctx = xgene_restart_ctx;
-	unsigned long timeout;
 
 	/* Issue the reboot */
 	if (ctx)
 		writel(ctx->mask, ctx->csr);
 
-	timeout = jiffies + HZ;
-	while (time_before(jiffies, timeout))
-		cpu_relax();
+	mdelay(1000);
 
 	dev_emerg(ctx->dev, "Unable to restart system\n");
 }
-- 
1.9.1

