Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaI3Rs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:48:56 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32927 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaI3Rsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:48:52 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Loc Ho <lho@apm.com>
Subject: [PATCH v2 04/10] power/reset: xgene: Use local variable dev instead of pdev->dev
Date: Tue, 30 Sep 2014 10:48:30 -0700
Message-Id: <1412099316-23167-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
References: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a local variable dev to point to the device is simpler then repeatedly
dereferencing pdev->dev.

Cc: Loc Ho <lho@apm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/xgene-reboot.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index aac0287..1bab003 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -33,7 +33,7 @@
 #include <asm/system_misc.h>
 
 struct xgene_reboot_context {
-	struct platform_device *pdev;
+	struct device *dev;
 	void *csr;
 	u32 mask;
 };
@@ -53,27 +53,28 @@ static void xgene_restart(char str, const char *cmd)
 	while (time_before(jiffies, timeout))
 		cpu_relax();
 
-	dev_emerg(&ctx->pdev->dev, "Unable to restart system\n");
+	dev_emerg(ctx->dev, "Unable to restart system\n");
 }
 
 static int xgene_reboot_probe(struct platform_device *pdev)
 {
 	struct xgene_reboot_context *ctx;
+	struct device *dev = &pdev->dev;
 
-	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->csr = of_iomap(pdev->dev.of_node, 0);
+	ctx->csr = of_iomap(dev->of_node, 0);
 	if (!ctx->csr) {
-		dev_err(&pdev->dev, "can not map resource\n");
+		dev_err(dev, "can not map resource\n");
 		return -ENODEV;
 	}
 
-	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
+	if (of_property_read_u32(dev->of_node, "mask", &ctx->mask))
 		ctx->mask = 0xFFFFFFFF;
 
-	ctx->pdev = pdev;
+	ctx->dev = dev;
 	arm_pm_restart = xgene_restart;
 	xgene_restart_ctx = ctx;
 
-- 
1.9.1

