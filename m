Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3LQNCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:02:36 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50569 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab3LQNAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:53 -0500
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
Subject: [PATCH 3/7] iommu/omap: Convert to devicetree
Date: Tue, 17 Dec 2013 13:53:34 +0100
Message-Id: <1387284818-28739-4-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As OMAP2+ is moving to a full DT boot for 3.14, commit 7ce93f3
"ARM: OMAP2+: Fix more missing data for omap3.dtsi file" adds
basic DT bits. But the driver is not yet converted, so this will
not work and driver will not be probed. Convert it!

Apart from standard bindings, this patch uses 'dma-window' (already
used by Tegra SMMU) and adds a custom 'ti,#tlb-entries' binding.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 .../devicetree/bindings/iommu/ti,omap-iommu.txt    | 19 ++++++++++++
 arch/arm/mach-omap2/omap-iommu.c                   |  5 +++
 drivers/iommu/omap-iommu.c                         | 36 +++++++++++++++++++---
 3 files changed, 55 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt

diff --git a/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
new file mode 100644
index 0000000..4e5027c
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
@@ -0,0 +1,19 @@
+OMAP3 IOMMU used by camera subsystem
+
+Required properties:
+- compatible : "ti,omap3-mmu-isp"
+- ti,hwmods : "mmu_isp"
+- reg : address space for the configuration registers
+- interrupts : interrupt line
+- dma-window : IOVA start address and length.
+- ti,#tlb-entries : number of entries in the translation look-aside buffer
+
+Example:
+	mmu_isp: mmu_isp@480bd400 {
+		compatible = "ti,omap3-mmu-isp";
+		ti,hwmods = "mmu_isp";
+		reg = <0x480bd400 0x80>;
+		interrupts = <8>;
+		dma-window = <0 0xfffff000>;
+		ti,#tlb-entries = <8>;
+	};
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index f6daae8..f1fab56 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/of.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
@@ -58,6 +59,10 @@ static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
 
 static int __init omap_iommu_init(void)
 {
+	/* If dtb is there, the devices will be created dynamically */
+	if (of_have_populated_dt())
+		return -ENODEV;
+
 	return omap_hwmod_for_each_by_class("mmu", omap_iommu_dev_init, NULL);
 }
 /* must be ready before omap3isp is probed */
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 385bf5e..51efcc4 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -23,6 +23,9 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_iommu.h>
+#include <linux/of_irq.h>
 
 #include <asm/cacheflush.h>
 
@@ -1171,20 +1174,30 @@ static int omap_iommu_probe(struct platform_device *pdev)
 {
 	int err = -ENODEV;
 	int irq;
+	size_t len;
 	struct omap_iommu *obj;
 	struct resource *res;
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *of = pdev->dev.of_node;
 
 	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
 
-	obj->nr_tlb_entries = pdata->nr_tlb_entries;
-	obj->name = pdata->name;
+	if (of) {
+		obj->name = of->name;
+		of_property_read_u32(of, "ti,#tlb-entries",
+				     &obj->nr_tlb_entries);
+		of_get_dma_window(of, NULL, 0, NULL, &obj->da_start, &len);
+		obj->da_end = obj->da_start + len;
+	} else {
+		obj->nr_tlb_entries = pdata->nr_tlb_entries;
+		obj->name = pdata->name;
+		obj->da_start = pdata->da_start;
+		obj->da_end = pdata->da_end;
+	}
 	obj->dev = &pdev->dev;
 	obj->ctx = (void *)obj + sizeof(*obj);
-	obj->da_start = pdata->da_start;
-	obj->da_end = pdata->da_end;
 
 	spin_lock_init(&obj->iommu_lock);
 	mutex_init(&obj->mmap_lock);
@@ -1210,7 +1223,11 @@ static int omap_iommu_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	irq = platform_get_irq(pdev, 0);
+	if (of)
+		irq = irq_of_parse_and_map(of, 0);
+	else
+		irq = platform_get_irq(pdev, 0);
+
 	if (irq < 0) {
 		err = -ENODEV;
 		goto err_irq;
@@ -1260,11 +1277,20 @@ static int omap_iommu_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static struct of_device_id omap_iommu_of_match[] = {
+	{ .compatible = "ti,omap3-mmu-isp" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_iommu_of_match);
+#endif
+
 static struct platform_driver omap_iommu_driver = {
 	.probe	= omap_iommu_probe,
 	.remove	= omap_iommu_remove,
 	.driver	= {
 		.name	= "omap-iommu",
+		.of_match_table = omap_iommu_of_match,
 	},
 };
 
-- 
1.8.1.2

