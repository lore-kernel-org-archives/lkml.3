Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbaHGMNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:13:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41957 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:13:34 -0400
Date: Thu, 7 Aug 2014 17:43:28 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] pcie-gadget-spear: use devm_ functions
Message-ID: <20140807121328.GA2961@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_ functions allocate memory that is released when a
driver detaches. This patch uses these functions for data that is
allocated in the probe function of a platform device and is only freed
in the remove function. Also, the unnecessary labels are removed and
linux/device.h is added to make sure the devm_*() routine declarations
are unambiguously available.

The initial call to platform_get_resource is moved down to the
introduced call to devm_ioremap_resource that uses its result.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested due to incompatible architecture.

To send to: Arnd Bergmann <arnd@arndb.de>,Greg Kroah-Hartman <gregkh@linuxfoundation.org>,linux-kernel@vger.kernel.org

This changes the order of memory deallocation operations with respect to
configfs_unregister_subsystem in the remove function. Will that be fine?

 drivers/misc/spear13xx_pcie_gadget.c | 98 +++++++++---------------------------
 1 file changed, 23 insertions(+), 75 deletions(-)

diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 2e13614..fe3ad0c 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -9,6 +9,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/device.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -743,58 +744,33 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 	struct config_item		*cg_item;
 	struct configfs_subsystem *subsys;
 
-	/* get resource for application registers*/
-
-	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res0) {
-		dev_err(&pdev->dev, "no resource defined\n");
-		return -EBUSY;
-	}
-	if (!request_mem_region(res0->start, resource_size(res0),
-				pdev->name)) {
-		dev_err(&pdev->dev, "pcie gadget region already	claimed\n");
-		return -EBUSY;
-	}
-	/* get resource for dbi registers*/
-
-	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res1) {
-		dev_err(&pdev->dev, "no resource defined\n");
-		goto err_rel_res0;
-	}
-	if (!request_mem_region(res1->start, resource_size(res1),
-				pdev->name)) {
-		dev_err(&pdev->dev, "pcie gadget region already	claimed\n");
-		goto err_rel_res0;
-	}
-
-	target = kzalloc(sizeof(*target), GFP_KERNEL);
+	target = devm_kzalloc(&pdev->dev, sizeof(*target), GFP_KERNEL);
 	if (!target) {
 		dev_err(&pdev->dev, "out of memory\n");
-		status = -ENOMEM;
-		goto err_rel_res;
+		return -ENOMEM;
 	}
 
 	cg_item = &target->subsys.su_group.cg_item;
 	sprintf(cg_item->ci_namebuf, "pcie_gadget.%d", pdev->id);
 	cg_item->ci_type	= &pcie_gadget_target_type;
 	config = &target->config;
-	config->va_app_base = (void __iomem *)ioremap(res0->start,
-			resource_size(res0));
-	if (!config->va_app_base) {
+
+	/* get resource for application registers*/
+	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	config->va_app_base = devm_ioremap_resource(&pdev->dev, res0);
+	if (IS_ERR(config->va_app_base)) {
 		dev_err(&pdev->dev, "ioremap fail\n");
-		status = -ENOMEM;
-		goto err_kzalloc;
+		return PTR_ERR(config->va_app_base);
 	}
 
+	/* get resource for dbi registers*/
+	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	config->base = (void __iomem *)res1->start;
 
-	config->va_dbi_base = (void __iomem *)ioremap(res1->start,
-			resource_size(res1));
-	if (!config->va_dbi_base) {
+	config->va_dbi_base = devm_ioremap_resource(&pdev->dev, res1);
+	if (IS_ERR(config->va_dbi_base)) {
 		dev_err(&pdev->dev, "ioremap fail\n");
-		status = -ENOMEM;
-		goto err_iounmap_app;
+		return PTR_ERR(config->va_dbi_base);
 	}
 
 	platform_set_drvdata(pdev, target);
@@ -802,15 +778,15 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no update irq?\n");
-		status = irq;
-		goto err_iounmap;
+		return irq;
 	}
 
-	status = request_irq(irq, spear_pcie_gadget_irq, 0, pdev->name, NULL);
+	status = devm_request_irq(&pdev->dev, irq, spear_pcie_gadget_irq,
+				  0, pdev->name, NULL);
 	if (status) {
 		dev_err(&pdev->dev,
 			"pcie gadget interrupt IRQ%d already claimed\n", irq);
-		goto err_iounmap;
+		return status;
 	}
 
 	/* Register configfs hooks */
@@ -819,7 +795,7 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 	mutex_init(&subsys->su_mutex);
 	status = configfs_register_subsystem(subsys);
 	if (status)
-		goto err_irq;
+		return status;
 
 	/*
 	 * init basic pcie application registers
@@ -835,13 +811,12 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 		clk = clk_get_sys("pcie1", NULL);
 		if (IS_ERR(clk)) {
 			pr_err("%s:couldn't get clk for pcie1\n", __func__);
-			status = PTR_ERR(clk);
-			goto err_irq;
+			return PTR_ERR(clk);
 		}
 		status = clk_enable(clk);
 		if (status) {
 			pr_err("%s:couldn't enable clk for pcie1\n", __func__);
-			goto err_irq;
+			return status;
 		}
 	} else if (pdev->id == 2) {
 		/*
@@ -851,53 +826,26 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 		clk = clk_get_sys("pcie2", NULL);
 		if (IS_ERR(clk)) {
 			pr_err("%s:couldn't get clk for pcie2\n", __func__);
-			status = PTR_ERR(clk);
-			goto err_irq;
+			return PTR_ERR(clk);
 		}
 		status = clk_enable(clk);
 		if (status) {
 			pr_err("%s:couldn't enable clk for pcie2\n", __func__);
-			goto err_irq;
+			return status;
 		}
 	}
 	spear13xx_pcie_device_init(config);
 
 	return 0;
-err_irq:
-	free_irq(irq, NULL);
-err_iounmap:
-	iounmap(config->va_dbi_base);
-err_iounmap_app:
-	iounmap(config->va_app_base);
-err_kzalloc:
-	kfree(target);
-err_rel_res:
-	release_mem_region(res1->start, resource_size(res1));
-err_rel_res0:
-	release_mem_region(res0->start, resource_size(res0));
-	return status;
 }
 
 static int spear_pcie_gadget_remove(struct platform_device *pdev)
 {
-	struct resource *res0, *res1;
 	static struct pcie_gadget_target *target;
-	struct spear_pcie_gadget_config *config;
-	int irq;
 
-	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	irq = platform_get_irq(pdev, 0);
 	target = platform_get_drvdata(pdev);
-	config = &target->config;
 
-	free_irq(irq, NULL);
-	iounmap(config->va_dbi_base);
-	iounmap(config->va_app_base);
-	release_mem_region(res1->start, resource_size(res1));
-	release_mem_region(res0->start, resource_size(res0));
 	configfs_unregister_subsystem(&target->subsys);
-	kfree(target);
 
 	return 0;
 }
-- 
1.9.1

