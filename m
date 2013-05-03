Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab3ECOe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:34:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65249 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab3ECOeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/63] dmaengine: ste_dma40: Allow driver to be probe()able when DT is enabled
Date: Fri,  3 May 2013 15:32:11 +0100
Message-Id: <1367591569-32197-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting using Device Tree, devices aren't registered in the normal
way. Instead, they need to be provided with a compatible string which is
held in an OF Match Table for comparison during start-up. Here we provide
the compatible string and prepare the driver to not receive a platform
data pointer.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ba50561..d7c2397 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -17,6 +17,7 @@
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/amba/bus.h>
 #include <linux/regulator/consumer.h>
 #include <linux/platform_data/dma-ste-dma40.h>
@@ -3465,17 +3466,52 @@ failure:
 	return ret;
 }
 
+static int __init d40_of_probe(struct platform_device *pdev,
+			       struct device_node *np)
+{
+	struct stedma40_platform_data *pdata;
+ 
+	/*
+	 * FIXME: Fill in this routine as more support is added.
+	 * First platform enabled (u8500) doens't need any extra
+	 * properties to run, so this is fairly sparce currently.
+	 */
+
+	pdata = devm_kzalloc(&pdev->dev,
+			     sizeof(struct stedma40_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdev->dev.platform_data = pdata;
+
+	return 0;
+}
+
 static int __init d40_probe(struct platform_device *pdev)
 {
+	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	int err;
 	int ret = -ENOENT;
-	struct d40_base *base;
+	struct d40_base *base = NULL;
 	struct resource *res = NULL;
 	int num_reserved_chans;
 	u32 val;
 
-	base = d40_hw_detect_init(pdev);
+	if (!plat_data) {
+		if (np) {
+			if(d40_of_probe(pdev, np)) {
+				ret = -ENOMEM;
+				goto failure;
+			}
+		} else {
+			d40_err(&pdev->dev, "No pdata or Device Tree provided\n");
+			goto failure;
+		}
+	}
 
+	base = d40_hw_detect_init(pdev);
 	if (!base)
 		goto failure;
 
@@ -3649,11 +3685,17 @@ failure:
 	return ret;
 }
 
+static const struct of_device_id d40_match[] = {
+        { .compatible = "stericsson,dma40", },
+        {}
+};
+
 static struct platform_driver d40_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name  = D40_NAME,
 		.pm = DMA40_PM_OPS,
+		.of_match_table = d40_match,
 	},
 };
 
-- 
1.7.10.4

