Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3BHHiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:38:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33871 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3BHHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:38:12 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <wim@iguana.be>, <nsekhar@ti.com>, <anilkumar.v@ti.com>
Subject: [PATCH V2] watchdog: davinci_wdt: update to devm_* API
Date: Fri, 8 Feb 2013 13:09:30 +0530
Message-ID: <1360309170-9672-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver
core will manage resources.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
This patch applies on top of v3.8-rc6.

Tested on da850 EVM.

Changes for V2:
 - Use return -EADDRNOTAVAIL in case of devm_request_and_ioremap() fail.
 - Use devm_clk_get() instead of clk_get().
 - Revert back the change for *dev.
 - Removes static type for "wdt_mem" structure as it is used only
   inside the function now. 

:100644 100644 e8e8724... 7df1fdc... M	drivers/watchdog/davinci_wdt.c
 drivers/watchdog/davinci_wdt.c |   29 ++++++-----------------------
 1 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index e8e8724..7df1fdc 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -69,7 +69,6 @@ static unsigned long wdt_status;
 #define WDT_REGION_INITED 2
 #define WDT_DEVICE_INITED 3
 
-static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
 struct clk		*wdt_clk;
 
@@ -201,10 +200,11 @@ static struct miscdevice davinci_wdt_miscdev = {
 
 static int davinci_wdt_probe(struct platform_device *pdev)
 {
-	int ret = 0, size;
+	int ret = 0;
 	struct device *dev = &pdev->dev;
+	struct resource  *wdt_mem;
 
-	wdt_clk = clk_get(dev, NULL);
+	wdt_clk = devm_clk_get(dev, NULL);
 	if (WARN_ON(IS_ERR(wdt_clk)))
 		return PTR_ERR(wdt_clk);
 
@@ -221,43 +221,26 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = resource_size(wdt_mem);
-	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		dev_err(dev, "failed to get memory region\n");
-		return -ENOENT;
-	}
-
-	wdt_base = ioremap(wdt_mem->start, size);
+	wdt_base = devm_request_and_ioremap(dev, wdt_mem);
 	if (!wdt_base) {
-		dev_err(dev, "failed to map memory region\n");
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
-		return -ENOMEM;
+		dev_err(dev, "ioremap failed\n");
+		return -EADDRNOTAVAIL;
 	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
 		dev_err(dev, "cannot register misc device\n");
-		release_mem_region(wdt_mem->start, size);
-		wdt_mem = NULL;
 	} else {
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
 
-	iounmap(wdt_base);
 	return ret;
 }
 
 static int davinci_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&davinci_wdt_miscdev);
-	if (wdt_mem) {
-		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
-		wdt_mem = NULL;
-	}
-
 	clk_disable_unprepare(wdt_clk);
-	clk_put(wdt_clk);
 
 	return 0;
 }
-- 
1.7.4.1

