Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3FDJ7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:59:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55376 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab3FDJ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:58:37 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>, <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v2 1/2] PM / AVS: SmartReflex: use devm_* API to initialize SmartReflex
Date: Tue, 4 Jun 2013 12:58:32 +0300
Message-ID: <1370339913-16135-2-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of of devm_* API for resource allocation provides benefits such
as auto handling of resource free. This reduces possibility have
memory leaks in case of wrong error handling. All direct release
calls should be removed to avoid races.

Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 drivers/power/avs/smartreflex.c |   76 +++++++++++----------------------------
 1 file changed, 21 insertions(+), 55 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 6b2238b..fd71d5a 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -27,7 +27,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/power/smartreflex.h>
 
-#define SMARTREFLEX_NAME_LEN	16
+#define SMARTREFLEX_NAME_LEN	32
 #define NVALUE_NAME_LEN		40
 #define SR_DISABLE_TIMEOUT	200
 
@@ -207,12 +207,11 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
 static int sr_late_init(struct omap_sr *sr_info)
 {
 	struct omap_sr_data *pdata = sr_info->pdev->dev.platform_data;
-	struct resource *mem;
 	int ret = 0;
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
-		ret = request_irq(sr_info->irq, sr_interrupt,
-				  0, sr_info->name, sr_info);
+		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
+				       sr_interrupt, 0, sr_info->name, sr_info);
 		if (ret)
 			goto error;
 		disable_irq(sr_info->irq);
@@ -224,14 +223,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 	return ret;
 
 error:
-	iounmap(sr_info->base);
-	mem = platform_get_resource(sr_info->pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
 	list_del(&sr_info->node);
 	dev_err(&sr_info->pdev->dev, "%s: ERROR in registering"
 		"interrupt handler. Smartreflex will"
 		"not function as desired\n", __func__);
-	kfree(sr_info);
 
 	return ret;
 }
@@ -847,34 +842,33 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	struct dentry *nvalue_dir;
 	int i, ret = 0;
 
-	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
+	sr_info = devm_kzalloc(&pdev->dev, sizeof(struct omap_sr), GFP_KERNEL);
 	if (!sr_info) {
 		dev_err(&pdev->dev, "%s: unable to allocate sr_info\n",
 			__func__);
 		return -ENOMEM;
 	}
 
+	sr_info->name = devm_kzalloc(&pdev->dev,
+				     SMARTREFLEX_NAME_LEN, GFP_KERNEL);
+	if (!sr_info->name) {
+		dev_err(&pdev->dev, "%s: unable to allocate SR instance name\n",
+			__func__);
+		return -ENOMEM;
+	}
+
 	platform_set_drvdata(pdev, sr_info);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
-		ret = -EINVAL;
-		goto err_free_devinfo;
+		return -EINVAL;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
-		ret = -ENODEV;
-		goto err_free_devinfo;
-	}
-
-	mem = request_mem_region(mem->start, resource_size(mem),
-					dev_name(&pdev->dev));
-	if (!mem) {
-		dev_err(&pdev->dev, "%s: no mem region\n", __func__);
-		ret = -EBUSY;
-		goto err_free_devinfo;
+	sr_info->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(sr_info->base)) {
+		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
+		return PTR_ERR(sr_info->base);
 	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -882,13 +876,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_irq_safe(&pdev->dev);
 
-	sr_info->name = kasprintf(GFP_KERNEL, "%s", pdata->name);
-	if (!sr_info->name) {
-		dev_err(&pdev->dev, "%s: Unable to alloc SR instance name\n",
-			__func__);
-		ret = -ENOMEM;
-		goto err_release_region;
-	}
+	snprintf(sr_info->name, SMARTREFLEX_NAME_LEN, "%s", pdata->name);
 
 	sr_info->pdev = pdev;
 	sr_info->srid = pdev->id;
@@ -905,13 +893,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	sr_info->autocomp_active = false;
 	sr_info->ip_type = pdata->ip_type;
 
-	sr_info->base = ioremap(mem->start, resource_size(mem));
-	if (!sr_info->base) {
-		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
-		ret = -ENOMEM;
-		goto err_free_name;
-	}
-
 	if (irq)
 		sr_info->irq = irq->start;
 
@@ -927,7 +908,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 		ret = sr_late_init(sr_info);
 		if (ret) {
 			pr_warning("%s: Error in SR late init\n", __func__);
-			goto err_iounmap;
+			goto err_list_del;
 		}
 	}
 
@@ -938,7 +919,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 			ret = PTR_ERR(sr_dbg_dir);
 			pr_err("%s:sr debugfs dir creation failed(%d)\n",
 				__func__, ret);
-			goto err_iounmap;
+			goto err_list_del;
 		}
 	}
 
@@ -991,16 +972,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
 err_debugfs:
 	debugfs_remove_recursive(sr_info->dbg_dir);
-err_iounmap:
+err_list_del:
 	list_del(&sr_info->node);
-	iounmap(sr_info->base);
-err_free_name:
-	kfree(sr_info->name);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
-err_free_devinfo:
-	kfree(sr_info);
-
 	return ret;
 }
 
@@ -1008,7 +981,6 @@ static int omap_sr_remove(struct platform_device *pdev)
 {
 	struct omap_sr_data *pdata = pdev->dev.platform_data;
 	struct omap_sr *sr_info;
-	struct resource *mem;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
@@ -1028,12 +1000,6 @@ static int omap_sr_remove(struct platform_device *pdev)
 		debugfs_remove_recursive(sr_info->dbg_dir);
 
 	list_del(&sr_info->node);
-	iounmap(sr_info->base);
-	kfree(sr_info->name);
-	kfree(sr_info);
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
-
 	return 0;
 }
 
-- 
1.7.9.5

