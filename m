Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaCGMRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:17:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44362 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaCGMRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:40 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 5/9] drivers: dma: Add dma crossbar driver
Date: Fri, 7 Mar 2014 17:46:12 +0530
Message-ID: <1394194576-23741-6-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRA7XX dma controller IP's are preceded by a crossbar which
routes the dma requests from the peripherals to the dma
request input lines of the appropriate dma controller.
With this the dma controller's available request lines
are shared between the peripherals.

The driver maintains a list of free dma request lines and
allocates one during the map callback which is invoked as
a part the dma engine driver's device_alloc_chan_resources
callback. The allocated request line is freed during the
device_free_chan_resources.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 .../devicetree/bindings/arm/omap/dma-crossbar.txt  |   26 +++
 drivers/dma/Kconfig                                |    7 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/omap-dma-xbar.c                        |  219 ++++++++++++++++++++
 drivers/dma/omap-dma-xbar.h                        |   32 +++
 drivers/dma/omap-dma.c                             |    1 +
 6 files changed, 286 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/dma-crossbar.txt
 create mode 100644 drivers/dma/omap-dma-xbar.c
 create mode 100644 drivers/dma/omap-dma-xbar.h

diff --git a/Documentation/devicetree/bindings/arm/omap/dma-crossbar.txt b/Documentation/devicetree/bindings/arm/omap/dma-crossbar.txt
new file mode 100644
index 0000000..feac013
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/omap/dma-crossbar.txt
@@ -0,0 +1,26 @@
+Some socs have a crossbar ip which muxes the dma requests
+from the peripherals to the dma request input lines of the
+appropriate dma controller. With this the dma controller's
+available request lines are shared between the peripherals
+
+Required properties:
+- compatible : Should be "ti,dma-crossbar"
+- reg: Base address and the size of the crossbar registers.
+- ti,dma-reqs: Total number of dma request lines available at dma controller.
+- ti,reg-size: Size of a individual register in bytes. Every individual
+	    register is assumed to be of same size. Valid sizes are 1, 2, 4.
+- ti,dmas-reserved: List of the reserved dma lines that are not muxed using
+		 crossbar. These dma lines are reserved in the soc,
+		 so crossbar bar driver should not consider them as free
+		 lines. This is a table of dma request-number and a count of
+		 reserved values from that number.
+
+Examples:
+		crossbar_dma: crossbar@4a020000 {
+			compatible = "ti,dma-crossbar";
+			reg = <0x4a002b78 0x100>;
+			ti,dma-reqs = <160>;
+			ti,reg-size = <2>;
+			ti,dmas-reserved = < 2, 5,
+					     10, 2 >;
+		};
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9bed1a2..7e8d3f4 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -400,4 +400,11 @@ config DMATEST
 config DMA_ENGINE_RAID
 	bool
 
+config OMAP_DMA_CROSSBAR
+	bool "OMAP dma crossbar support"
+	depends on DMA_OMAP
+	help
+	  This enables the dma crossbar ip support to dynamically map the
+	  peripheral dma request lines to the dma controller's input.
+
 endif
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index a029d0f4..d84190e 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -44,3 +44,4 @@ obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
 obj-$(CONFIG_TI_CPPI41) += cppi41.o
 obj-$(CONFIG_K3_DMA) += k3dma.o
 obj-$(CONFIG_MOXART_DMA) += moxart-dma.o
+obj-$(CONFIG_OMAP_DMA_CROSSBAR) += omap-dma-xbar.o
diff --git a/drivers/dma/omap-dma-xbar.c b/drivers/dma/omap-dma-xbar.c
new file mode 100644
index 0000000..bed2923
--- /dev/null
+++ b/drivers/dma/omap-dma-xbar.c
@@ -0,0 +1,219 @@
+/*
+ *  Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ *  Author: Sricharan R <r.sricharan@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_dma.h>
+#include <linux/module.h>
+
+#include "omap-dma-xbar.h"
+
+static struct platform_device *pd_xbar;
+
+static void dma_xbar_writeb(int dma_sig, int dma_xbar,
+			    struct dma_xbar_device *xbar)
+{
+	writeb(dma_xbar, xbar->dma_xbar_base + xbar->reg_offs[dma_sig]);
+}
+
+static void dma_xbar_writew(int dma_sig, int dma_xbar,
+			    struct dma_xbar_device *xbar)
+{
+	writew(dma_xbar, xbar->dma_xbar_base + xbar->reg_offs[dma_sig]);
+}
+
+static void dma_xbar_writel(int dma_sig, int dma_xbar,
+			    struct dma_xbar_device *xbar)
+{
+	writel(dma_xbar, xbar->dma_xbar_base + xbar->reg_offs[dma_sig]);
+}
+
+static uint32_t dma_xbar_map(uint32_t dma_xbar, struct dma_xbar_device *xbar)
+{
+	struct dma_req *r;
+	uint32_t dma_sig;
+
+	if (!list_empty(&xbar->free_reqs))
+		r = list_first_entry(&xbar->free_reqs, struct dma_req, node);
+	else
+		return -ENODEV;
+
+	dma_sig = r->req_line;
+	list_del(&r->node);
+
+	xbar->write(dma_sig - 1, dma_xbar, xbar);
+
+	return dma_sig;
+}
+
+static void dma_xbar_unmap(uint32_t dma_sig, struct dma_xbar_device *xbar)
+{
+	struct dma_req *r;
+
+	r = devm_kzalloc(&pd_xbar->dev, sizeof(*r), GFP_KERNEL);
+	r->req_line = dma_sig;
+
+	list_add_tail(&r->node, &xbar->free_reqs);
+}
+
+const struct xbar_ops dma_xbar_ops = {
+	.map = dma_xbar_map,
+	.unmap = dma_xbar_unmap,
+};
+
+static int __init omap_dma_xbar_probe(struct platform_device *pdev)
+{
+	int i, j, reserved = 0;
+	const __be32 *dmar;
+	uint32_t *dma_map, max, size, entry, range;
+	struct dma_req *p;
+	struct resource *res;
+	struct dma_xbar_device *xbar;
+
+	pd_xbar = pdev;
+
+	xbar = devm_kzalloc(&pdev->dev, sizeof(*xbar), GFP_KERNEL);
+	if (!xbar)
+		return -ENOMEM;
+
+	xbar->ops = &dma_xbar_ops;
+
+	INIT_LIST_HEAD(&xbar->free_reqs);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	xbar->dma_xbar_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xbar->dma_xbar_base))
+		return PTR_ERR(xbar->dma_xbar_base);
+
+	of_property_read_u32(pdev->dev.of_node, "ti,dma-reqs", &max);
+	dma_map = kzalloc(max * sizeof(*dma_map), GFP_KERNEL);
+	if (!dma_map)
+		return -ENOMEM;
+
+	/* Get and mark reserved dma req lines */
+	dmar = of_get_property(pdev->dev.of_node, "ti,dmas-reserved", &size);
+	if (dmar) {
+		size /= sizeof(__be32);
+
+		for (i = 0; i < size; i++) {
+			of_property_read_u32_index(pdev->dev.of_node,
+						   "ti,dmas-reserved",
+						   i++, &entry);
+			of_property_read_u32_index(pdev->dev.of_node,
+						   "ti,dmas-reserved",
+						   i, &range);
+			if ((entry + range > max) ||
+			    ((entry + range) <= entry)) {
+				pr_err("Invalid reserved entry\n");
+				return -ENODEV;
+			}
+
+			for (j = entry; j <= range; j++)
+				dma_map[j] = 1;
+
+			/* For a single entry */
+			if (!range)
+				dma_map[entry] = 1;
+		}
+	}
+
+	/* Add the free dma req lines to free list */
+	for (j = 1; j < max; j++) {
+		if (!dma_map[j]) {
+			p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
+			p->req_line = j;
+			list_add_tail(&p->node, &xbar->free_reqs);
+		}
+	}
+
+	xbar->reg_offs = devm_kzalloc(&pdev->dev, max * sizeof(int),
+				      GFP_KERNEL);
+	if (!xbar->reg_offs)
+		return -ENOMEM;
+
+	of_property_read_u32(pdev->dev.of_node, "ti,reg-size", &size);
+
+	switch (size) {
+	case 1:
+		xbar->write = dma_xbar_writeb;
+		break;
+	case 2:
+		xbar->write = dma_xbar_writew;
+		break;
+	case 4:
+		xbar->write = dma_xbar_writel;
+		break;
+	default:
+		pr_err("Invalid reg-size property\n");
+		return -ENODEV;
+		break;
+	}
+
+	/*
+	 * Register offsets are not linear because of the
+	 * reserved lines. so find and store the offsets once.
+	 */
+	for (i = 0; i < max; i++) {
+		if (dma_map[i])
+			continue;
+
+		xbar->reg_offs[i] = reserved;
+		reserved += size;
+	}
+
+	if (of_dma_router_register(pdev->dev.of_node, xbar))
+		return -ENODEV;
+
+	kfree(dma_map);
+	return 0;
+}
+
+static int omap_dma_xbar_remove(struct platform_device *pdev)
+{
+	if (pdev->dev.of_node)
+		of_dma_router_free(pdev->dev.of_node);
+
+	return 0;
+}
+
+static const struct of_device_id dma_xbar_match[] __initconst = {
+	{ .compatible = "ti,dma-xbar" },
+	{},
+};
+
+static struct platform_driver omap_dma_xbar_driver = {
+	.probe	= omap_dma_xbar_probe,
+	.remove	= omap_dma_xbar_remove,
+	.driver = {
+		.name = "omap-dma-xbar",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(dma_xbar_match),
+	},
+};
+
+int __init omap_dmaxbar_init(void)
+{
+	return platform_driver_register(&omap_dma_xbar_driver);
+}
+arch_initcall(omap_dmaxbar_init);
+
+static void __exit omap_dmaxbar_exit(void)
+{
+	platform_driver_unregister(&omap_dma_xbar_driver);
+}
+module_exit(omap_dmaxbar_exit);
+
+MODULE_DESCRIPTION("OMAP DMA XBAR");
+MODULE_AUTHOR("Sricharan R");
+MODULE_LICENSE("GPL");
diff --git a/drivers/dma/omap-dma-xbar.h b/drivers/dma/omap-dma-xbar.h
new file mode 100644
index 0000000..bd0b208
--- /dev/null
+++ b/drivers/dma/omap-dma-xbar.h
@@ -0,0 +1,32 @@
+/*
+ *  Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ *  Author: Sricharan R <r.sricharan@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+struct dma_req {
+	uint32_t req_line;
+	struct list_head node;
+};
+
+/*
+ * @crossbar_base: crossbar base address
+ * @register_offsets: offsets for each dma request number
+ * @write: function to write in to the dma crossbar
+ * @free_reqs: list of free dma request lines
+ */
+struct dma_xbar_device {
+	void __iomem *dma_xbar_base;
+	int *reg_offs;
+	void (*write)(int, int, struct dma_xbar_device *);
+	struct list_head free_reqs;
+	const struct xbar_ops *ops;
+};
+
+struct xbar_ops {
+	uint32_t (*map)(uint32_t, struct dma_xbar_device *);
+	void (*unmap)(uint32_t,  struct dma_xbar_device *);
+};
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 05ac480..b527bed 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 
 #include "virt-dma.h"
+#include "omap-dma-xbar.h"
 
 struct omap_dmadev {
 	struct dma_device ddev;
-- 
1.7.9.5

