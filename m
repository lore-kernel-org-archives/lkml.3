Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaI0A5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:57:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60304 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaI0A5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:57:44 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Loc Ho <lho@apm.com>
Subject: [PATCH 05/10] power/reset: xgene: Use mdelay instead of jiffies based timeout
Date: Fri, 26 Sep 2014 17:57:13 -0700
Message-Id: <1411779438-23127-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
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

