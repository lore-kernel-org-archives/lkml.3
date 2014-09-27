Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaI0A6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:58:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54651 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaI0A54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:57:56 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH 09/10] power/reset: hisi: Register with kernel restart handler
Date: Fri, 26 Sep 2014 17:57:17 -0700
Message-Id: <1411779438-23127-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel restart handler instead of setting arm_pm_restart directly.

Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/hisi-reboot.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/hisi-reboot.c b/drivers/power/reset/hisi-reboot.c
index 0c91d02..e9774b0 100644
--- a/drivers/power/reset/hisi-reboot.c
+++ b/drivers/power/reset/hisi-reboot.c
@@ -14,27 +14,36 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 
 #include <asm/proc-fns.h>
-#include <asm/system_misc.h>
 
 static void __iomem *base;
 static u32 reboot_offset;
 
-static void hisi_restart(enum reboot_mode mode, const char *cmd)
+static int hisi_restart_handler(struct notifier_block *this,
+				unsigned long mode, void *cmd)
 {
 	writel_relaxed(0xdeadbeef, base + reboot_offset);
 
 	while (1)
 		cpu_do_idle();
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block hisi_restart_nb = {
+	.notifier_call = hisi_restart_handler,
+	.priority = 128,
+};
+
 static int hisi_reboot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	int err;
 
 	base = of_iomap(np, 0);
 	if (!base) {
@@ -47,7 +56,10 @@ static int hisi_reboot_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	arm_pm_restart = hisi_restart;
+	err = register_restart_handler(&hisi_restart_nb);
+	if (err)
+		dev_err(&pdev->dev, "cannot register restart handler (err=%d)\n",
+			err);
 
 	return 0;
 }
-- 
1.9.1

