Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaI3Rup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:50:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45471 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaI3RtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:49:05 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH v2 09/10] power/reset: hisi: Register with kernel restart handler
Date: Tue, 30 Sep 2014 10:48:35 -0700
Message-Id: <1412099316-23167-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel restart handler instead of setting arm_pm_restart directly.

Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/hisi-reboot.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/power/reset/hisi-reboot.c b/drivers/power/reset/hisi-reboot.c
index 0c91d02..5385460 100644
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
@@ -47,9 +56,12 @@ static int hisi_reboot_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	arm_pm_restart = hisi_restart;
+	err = register_restart_handler(&hisi_restart_nb);
+	if (err)
+		dev_err(&pdev->dev, "cannot register restart handler (err=%d)\n",
+			err);
 
-	return 0;
+	return err;
 }
 
 static struct of_device_id hisi_reboot_of_match[] = {
-- 
1.9.1

