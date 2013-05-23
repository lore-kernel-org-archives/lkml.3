Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3EWPZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:40 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57687 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EWPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/16] mfd: ab8500-debug: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:05 +0100
Message-Id: <1369322717-30429-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 37b7ce4..7e80a0e 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2937,7 +2937,6 @@ static struct dentry *ab8500_gpadc_dir;
 static int ab8500_debug_probe(struct platform_device *plf)
 {
 	struct dentry *file;
-	int ret = -ENOMEM;
 	struct ab8500 *ab8500;
 	struct resource *res;
 	debug_bank = AB8500_MISC;
@@ -2946,24 +2945,26 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	ab8500 = dev_get_drvdata(plf->dev.parent);
 	num_irqs = ab8500->mask_size;
 
-	irq_count = kzalloc(sizeof(*irq_count)*num_irqs, GFP_KERNEL);
+	irq_count = devm_kzalloc(&plf->dev,
+				 sizeof(*irq_count)*num_irqs, GFP_KERNEL);
 	if (!irq_count)
 		return -ENOMEM;
 
-	dev_attr = kzalloc(sizeof(*dev_attr)*num_irqs,GFP_KERNEL);
+	dev_attr = devm_kzalloc(&plf->dev,
+				sizeof(*dev_attr)*num_irqs,GFP_KERNEL);
 	if (!dev_attr)
-		goto out_freeirq_count;
+		return -ENOMEM;
 
-	event_name = kzalloc(sizeof(*event_name)*num_irqs, GFP_KERNEL);
+	event_name = devm_kzalloc(&plf->dev,
+				  sizeof(*event_name)*num_irqs, GFP_KERNEL);
 	if (!event_name)
-		goto out_freedev_attr;
+		return -ENOMEM;
 
 	res = platform_get_resource_byname(plf, 0, "IRQ_AB8500");
 	if (!res) {
 		dev_err(&plf->dev, "AB8500 irq not found, err %d\n",
 			irq_first);
-		ret = -ENXIO;
-		goto out_freeevent_name;
+		return ENXIO;
 	}
 	irq_ab8500 = res->start;
 
@@ -2971,16 +2972,14 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (irq_first < 0) {
 		dev_err(&plf->dev, "First irq not found, err %d\n",
 			irq_first);
-		ret = irq_first;
-		goto out_freeevent_name;
+		return irq_first;
 	}
 
 	irq_last = platform_get_irq_byname(plf, "IRQ_LAST");
 	if (irq_last < 0) {
 		dev_err(&plf->dev, "Last irq not found, err %d\n",
 			irq_last);
-		ret = irq_last;
-		goto out_freeevent_name;
+		return irq_last;
 	}
 
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
@@ -3189,22 +3188,13 @@ err:
 	if (ab8500_dir)
 		debugfs_remove_recursive(ab8500_dir);
 	dev_err(&plf->dev, "failed to create debugfs entries.\n");
-out_freeevent_name:
-	kfree(event_name);
-out_freedev_attr:
-	kfree(dev_attr);
-out_freeirq_count:
-	kfree(irq_count);
 
-	return ret;
+	return -ENOMEM;
 }
 
 static int ab8500_debug_remove(struct platform_device *plf)
 {
 	debugfs_remove_recursive(ab8500_dir);
-	kfree(event_name);
-	kfree(dev_attr);
-	kfree(irq_count);
 
 	return 0;
 }
-- 
1.7.10.4

