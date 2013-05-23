Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3EWP3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:29:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43974 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab3EWPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/16] mfd: asic3: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:09 +0100
Message-Id: <1369322717-30429-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/asic3.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 1b15986..9532f74 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -958,7 +958,8 @@ static int __init asic3_probe(struct platform_device *pdev)
 	unsigned long clksel;
 	int ret = 0;
 
-	asic = kzalloc(sizeof(struct asic3), GFP_KERNEL);
+	asic = devm_kzalloc(&pdev->dev,
+			    sizeof(struct asic3), GFP_KERNEL);
 	if (asic == NULL) {
 		printk(KERN_ERR "kzalloc failed\n");
 		return -ENOMEM;
@@ -970,16 +971,14 @@ static int __init asic3_probe(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
-		ret = -ENOMEM;
 		dev_err(asic->dev, "no MEM resource\n");
-		goto out_free;
+		return -ENOMEM;
 	}
 
 	asic->mapping = ioremap(mem->start, resource_size(mem));
 	if (!asic->mapping) {
-		ret = -ENOMEM;
 		dev_err(asic->dev, "Couldn't ioremap\n");
-		goto out_free;
+		return -ENOMEM;
 	}
 
 	asic->irq_base = pdata->irq_base;
@@ -1033,9 +1032,6 @@ static int __init asic3_probe(struct platform_device *pdev)
  out_unmap:
 	iounmap(asic->mapping);
 
- out_free:
-	kfree(asic);
-
 	return ret;
 }
 
@@ -1058,8 +1054,6 @@ static int asic3_remove(struct platform_device *pdev)
 
 	iounmap(asic->mapping);
 
-	kfree(asic);
-
 	return 0;
 }
 
-- 
1.7.10.4

