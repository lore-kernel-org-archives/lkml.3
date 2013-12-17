Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3LQNCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:02:53 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50539 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LQNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:52 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] iommu/omap: Do bus_set_iommu() only if probe() succeeds
Date: Tue, 17 Dec 2013 13:53:32 +0100
Message-Id: <1387284818-28739-2-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, bus_set_iommu() is done in omap_iommu_init(). However,
omap_iommu_probe() can fail in a number of ways, leaving the platform
bus with a dangling reference to a non-initialized iommu. Perform
bus_set_iommu() only if omap_iommu_probe() succeed.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/iommu/omap-iommu.c | 207 +++++++++++++++++++++++----------------------
 1 file changed, 104 insertions(+), 103 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bcd78a7..ee83bcc 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -930,107 +930,6 @@ static void omap_iommu_detach(struct omap_iommu *obj)
 	dev_dbg(obj->dev, "%s: %s\n", __func__, obj->name);
 }
 
-/*
- *	OMAP Device MMU(IOMMU) detection
- */
-static int omap_iommu_probe(struct platform_device *pdev)
-{
-	int err = -ENODEV;
-	int irq;
-	struct omap_iommu *obj;
-	struct resource *res;
-	struct iommu_platform_data *pdata = pdev->dev.platform_data;
-
-	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-
-	obj->nr_tlb_entries = pdata->nr_tlb_entries;
-	obj->name = pdata->name;
-	obj->dev = &pdev->dev;
-	obj->ctx = (void *)obj + sizeof(*obj);
-	obj->da_start = pdata->da_start;
-	obj->da_end = pdata->da_end;
-
-	spin_lock_init(&obj->iommu_lock);
-	mutex_init(&obj->mmap_lock);
-	spin_lock_init(&obj->page_table_lock);
-	INIT_LIST_HEAD(&obj->mmap);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -ENODEV;
-		goto err_mem;
-	}
-
-	res = request_mem_region(res->start, resource_size(res),
-				 dev_name(&pdev->dev));
-	if (!res) {
-		err = -EIO;
-		goto err_mem;
-	}
-
-	obj->regbase = ioremap(res->start, resource_size(res));
-	if (!obj->regbase) {
-		err = -ENOMEM;
-		goto err_ioremap;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		err = -ENODEV;
-		goto err_irq;
-	}
-	err = request_irq(irq, iommu_fault_handler, IRQF_SHARED,
-			  dev_name(&pdev->dev), obj);
-	if (err < 0)
-		goto err_irq;
-	platform_set_drvdata(pdev, obj);
-
-	pm_runtime_irq_safe(obj->dev);
-	pm_runtime_enable(obj->dev);
-
-	dev_info(&pdev->dev, "%s registered\n", obj->name);
-	return 0;
-
-err_irq:
-	iounmap(obj->regbase);
-err_ioremap:
-	release_mem_region(res->start, resource_size(res));
-err_mem:
-	kfree(obj);
-	return err;
-}
-
-static int omap_iommu_remove(struct platform_device *pdev)
-{
-	int irq;
-	struct resource *res;
-	struct omap_iommu *obj = platform_get_drvdata(pdev);
-
-	iopgtable_clear_entry_all(obj);
-
-	irq = platform_get_irq(pdev, 0);
-	free_irq(irq, obj);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-	iounmap(obj->regbase);
-
-	pm_runtime_disable(obj->dev);
-
-	dev_info(&pdev->dev, "%s removed\n", obj->name);
-	kfree(obj);
-	return 0;
-}
-
-static struct platform_driver omap_iommu_driver = {
-	.probe	= omap_iommu_probe,
-	.remove	= omap_iommu_remove,
-	.driver	= {
-		.name	= "omap-iommu",
-	},
-};
-
 static void iopte_cachep_ctor(void *iopte)
 {
 	clean_dcache_area(iopte, IOPTE_TABLE_SIZE);
@@ -1265,6 +1164,110 @@ static struct iommu_ops omap_iommu_ops = {
 	.pgsize_bitmap	= OMAP_IOMMU_PGSIZES,
 };
 
+/*
+ *	OMAP Device MMU(IOMMU) detection
+ */
+static int omap_iommu_probe(struct platform_device *pdev)
+{
+	int err = -ENODEV;
+	int irq;
+	struct omap_iommu *obj;
+	struct resource *res;
+	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+
+	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	obj->nr_tlb_entries = pdata->nr_tlb_entries;
+	obj->name = pdata->name;
+	obj->dev = &pdev->dev;
+	obj->ctx = (void *)obj + sizeof(*obj);
+	obj->da_start = pdata->da_start;
+	obj->da_end = pdata->da_end;
+
+	spin_lock_init(&obj->iommu_lock);
+	mutex_init(&obj->mmap_lock);
+	spin_lock_init(&obj->page_table_lock);
+	INIT_LIST_HEAD(&obj->mmap);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto err_mem;
+	}
+
+	res = request_mem_region(res->start, resource_size(res),
+				 dev_name(&pdev->dev));
+	if (!res) {
+		err = -EIO;
+		goto err_mem;
+	}
+
+	obj->regbase = ioremap(res->start, resource_size(res));
+	if (!obj->regbase) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		err = -ENODEV;
+		goto err_irq;
+	}
+
+	err = request_irq(irq, iommu_fault_handler, IRQF_SHARED,
+			  dev_name(&pdev->dev), obj);
+	if (err < 0)
+		goto err_irq;
+	platform_set_drvdata(pdev, obj);
+
+	bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
+
+	pm_runtime_irq_safe(obj->dev);
+	pm_runtime_enable(obj->dev);
+
+	dev_info(&pdev->dev, "%s registered\n", obj->name);
+	return 0;
+
+err_irq:
+	iounmap(obj->regbase);
+err_ioremap:
+	release_mem_region(res->start, resource_size(res));
+err_mem:
+	kfree(obj);
+	return err;
+}
+
+static int omap_iommu_remove(struct platform_device *pdev)
+{
+	int irq;
+	struct resource *res;
+	struct omap_iommu *obj = platform_get_drvdata(pdev);
+
+	iopgtable_clear_entry_all(obj);
+
+	irq = platform_get_irq(pdev, 0);
+	free_irq(irq, obj);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+	iounmap(obj->regbase);
+
+	pm_runtime_disable(obj->dev);
+
+	dev_info(&pdev->dev, "%s removed\n", obj->name);
+	kfree(obj);
+	return 0;
+}
+
+static struct platform_driver omap_iommu_driver = {
+	.probe	= omap_iommu_probe,
+	.remove	= omap_iommu_remove,
+	.driver	= {
+		.name	= "omap-iommu",
+	},
+};
+
 static int __init omap_iommu_init(void)
 {
 	struct kmem_cache *p;
@@ -1277,8 +1280,6 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
-	bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
-
 	return platform_driver_register(&omap_iommu_driver);
 }
 /* must be ready before omap3isp is probed */
-- 
1.8.1.2

