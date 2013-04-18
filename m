Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257Ab3DRKQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:16:39 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57615 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967883Ab3DRKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 23/32] dmaengine: ste_dma40: Allow driver to be probe()able when DT is enabled
Date: Thu, 18 Apr 2013 11:12:05 +0100
Message-Id: <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting using Device Tree, devices aren't registered in the normal
way. Instead, they need to be provided with a compatible string which is
held in an OF Match Table for comparison during start-up. Here we provide
the compatible string and prepare the driver to not receive a platform
data pointer.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6f9f801..4782ee7 100644
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
@@ -3452,17 +3453,48 @@ failure:
 	return ret;
 }
 
+static int __init d40_of_probe(struct platform_device *pdev,
+			       struct device_node *np)
+{
+	/*
+	 * FIXME: Fill in this routine as more support is added.
+	 * First platform enabled (u8500) doens't need any extra
+	 * properties to run, so this is fairly sparce currently.
+	 */
+	pdev->dev.platform_data =
+		devm_kzalloc(&pdev->dev,
+			     sizeof(struct stedma40_platform_data),
+			     GFP_KERNEL);
+	if (!pdev->dev.platform_data)
+		return -ENOMEM;
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
 
@@ -3636,11 +3668,17 @@ failure:
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

