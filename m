Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3AUKPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:15:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3AUKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 15/33] memory: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:08 +0100
Message-Id: <1358762966-20791-16-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:NqLtsmX0gH4BY+tk5U5tYbZ0OUItgtRfuO7x2kwJLxy
 HBQ3ewXxYOP/zhecKtJCmxlfDRVonuGHfob6ZP1CXwS3a60AO3
 S1JZWWBV4yqdjiKwzVOnSik3R0/GpjWJr8Ceo7uWDAluNbjj76
 emSJDsu43au/XQoA9JGLBHGbqDyS1g/WLiSywKlfi8hVL1BgEC
 NNGotrcfJUa1fDEL3QMG7FV89c8mcDCdfls1E6y3vRHIJdoyn3
 fKDyULp0AZw2BaGUp1Ev+yPH17HH2iKCaXfUV2Apa7AS3QOQCV
 Es8VB9eKq3brRQmF+YuDUlu1BcghPup1r5H4YrpamxQR5ma7eH
 1DuvHqyjdt7+BNvqKfwHPh+rtNichqvuHdmm5MAFSBiJNGYu38
 fFz/33ifNZ4xufGxPhwqApAQyhSuRIdeWZPBL1rjmLNe4E0fHu
 WDq24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/emif.c       | 8 +++-----
 drivers/memory/tegra20-mc.c | 7 ++++---
 drivers/memory/tegra30-mc.c | 7 ++++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 06d31c9..df08736 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -10,6 +10,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/reboot.h>
 #include <linux/platform_data/emif_plat.h>
@@ -1468,12 +1469,9 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 		goto error;
 	}
 
-	emif->base = devm_request_and_ioremap(emif->dev, res);
-	if (!emif->base) {
-		dev_err(emif->dev, "%s: devm_request_and_ioremap() failed\n",
-			__func__);
+	emif->base = devm_ioremap_resource(emif->dev, res);
+	if (IS_ERR(emif->base))
 		goto error;
-	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 186f27d..2ca5f28 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -17,6 +17,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
@@ -216,9 +217,9 @@ static int tegra20_mc_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			return -ENODEV;
-		mc->regs[i] = devm_request_and_ioremap(&pdev->dev, res);
-		if (!mc->regs[i])
-			return -EBUSY;
+		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(mc->regs[i]))
+			return PTR_ERR(mc->regs[i]);
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 0b7ab93..0b97598 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -17,6 +17,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ratelimit.h>
@@ -336,9 +337,9 @@ static int tegra30_mc_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			return -ENODEV;
-		mc->regs[i] = devm_request_and_ioremap(&pdev->dev, res);
-		if (!mc->regs[i])
-			return -EBUSY;
+		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(mc->regs[i]))
+			return PTR_ERR(mc->regs[i]);
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-- 
1.8.1.1

