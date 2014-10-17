Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaJQVHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:07:20 -0400
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:17664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbaJQVHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:07:17 -0400
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@altera.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>, <tthayer@altera.com>
Subject: [PATCHv2 3/4] edac: altera: Add Altera L2 and OCRAM EDAC support
Date: Fri, 17 Oct 2014 15:33:47 -0500
Message-ID: <1413578029-13205-4-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR00CA0029.namprd00.prod.outlook.com (25.160.243.39) To
 BN1PR03MB124.namprd03.prod.outlook.com (10.255.201.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB124;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(22564002)(199003)(106356001)(81156004)(48376002)(87976001)(76482002)(77156001)(88136002)(62966002)(87286001)(66066001)(64706001)(95666004)(53416004)(229853001)(33646002)(47776003)(107046002)(85306004)(20776003)(31966008)(89996001)(85852003)(50466002)(105586002)(42186005)(102836001)(104166001)(46102003)(15975445006)(80022003)(40100003)(97736003)(19580405001)(122386002)(19580395003)(77096002)(93916002)(99396003)(76176999)(86152002)(86362001)(92566001)(4396001)(50986999)(2201001)(69596002)(101416001)(15202345003)(21056001)(92726001)(50226001)(120916001)(921003)(1121002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB124;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

Adding L2 Cache and On-Chip RAM EDAC support for the Altera SoCs using 
the EDAC_DEVICE framework. The EDAC manager abstracts the common probe 
functionality and test triggers. The L2 Cache and OCRAM files handle
the specific memory functions (alloc & free) for the testing triggers.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
---
v2: Fix L2 dependency comments.
---
 MAINTAINERS                      |    2 +-
 drivers/edac/Kconfig             |   14 ++
 drivers/edac/Makefile            |    3 +
 drivers/edac/altera_edac_mgr.c   |  261 ++++++++++++++++++++++++++++++++++++++
 drivers/edac/altera_edac_mgr.h   |   56 ++++++++
 drivers/edac/altera_l2_edac.c    |  130 +++++++++++++++++++
 drivers/edac/altera_ocram_edac.c |  107 ++++++++++++++++
 7 files changed, 572 insertions(+), 1 deletion(-)
 create mode 100644 drivers/edac/altera_edac_mgr.c
 create mode 100644 drivers/edac/altera_edac_mgr.h
 create mode 100644 drivers/edac/altera_l2_edac.c
 create mode 100644 drivers/edac/altera_ocram_edac.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c6d390e..f5a0692 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1406,7 +1406,7 @@ F:	drivers/clk/socfpga/
 ARM/SOCFPGA EDAC SUPPORT
 M:	Thor Thayer <tthayer@opensource.altera.com>
 S:	Maintained
-F:	drivers/edac/altera_edac.
+F:	drivers/edac/altera_*
 F:	arch/arm/mach-socfpga/l2_cache.*
 F:	arch/arm/mach-socfpga/ocram.*
 
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c28..a9f98c2 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -385,4 +385,18 @@ config EDAC_ALTERA_MC
 	  preloader must initialize the SDRAM before loading
 	  the kernel.
 
+config EDAC_ALTERA_L2C
+	bool "Altera L2 Cache EDAC"
+	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && CACHE_L2X0
+	help
+	  Support for error detection and correction on the
+	  Altera L2 cache Memory for Altera SoCs.
+
+config EDAC_ALTERA_OCRAM
+	bool "Altera On-Chip RAM EDAC"
+	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && SRAM && GENERIC_ALLOCATOR
+	help
+	  Support for error detection and correction on the
+	  Altera On-Chip RAM Memory for Altera SoCs.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 359aa49..4e3889b 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -67,3 +67,6 @@ obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
 
 obj-$(CONFIG_EDAC_ALTERA_MC)		+= altera_edac.o
+alt_edac_mgr-y				:= altera_edac_mgr.o
+obj-$(CONFIG_EDAC_ALTERA_L2C)		+= alt_edac_mgr.o altera_l2_edac.o
+obj-$(CONFIG_EDAC_ALTERA_OCRAM)		+= alt_edac_mgr.o altera_ocram_edac.o
diff --git a/drivers/edac/altera_edac_mgr.c b/drivers/edac/altera_edac_mgr.c
new file mode 100644
index 0000000..676ccbe
--- /dev/null
+++ b/drivers/edac/altera_edac_mgr.c
@@ -0,0 +1,261 @@
+/*
+ *  Copyright Altera Corporation (C) 2014. All rights reserved.
+ *  Copyright 2011-2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Adapted from the highbank_l2_edac driver
+ */
+
+#include <linux/ctype.h>
+#include <linux/edac.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include "altera_edac_mgr.h"
+#include "edac_core.h"
+#include "edac_module.h"
+
+static irqreturn_t altr_edac_mgr_handler(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *dci = dev_id;
+	struct altr_edac_mgr_dev *drvdata = dci->pvt_info;
+	const struct ecc_mgr_prv_data *priv = drvdata->data;
+
+	if (irq == drvdata->sb_irq) {
+		if (priv->ce_clear_mask)
+			writel(priv->ce_clear_mask, drvdata->base);
+		edac_device_handle_ce(dci, 0, 0, drvdata->edac_dev_name);
+	}
+	if (irq == drvdata->db_irq) {
+		if (priv->ue_clear_mask)
+			writel(priv->ue_clear_mask, drvdata->base);
+		edac_device_handle_ue(dci, 0, 0, drvdata->edac_dev_name);
+		panic("\nEDAC:ECC_MGR[Uncorrectable errors]\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_EDAC_DEBUG
+ssize_t altr_edac_mgr_trig(struct edac_device_ctl_info *edac_dci,
+			   const char *buffer, size_t count)
+{
+	u32 *ptemp, i, error_mask;
+	int result = 0;
+	unsigned long flags;
+	struct altr_edac_mgr_dev *drvdata = edac_dci->pvt_info;
+	const struct ecc_mgr_prv_data *priv = drvdata->data;
+	void *generic_ptr = edac_dci->dev;
+
+	if (!priv->alloc_mem)
+		return -ENOMEM;
+
+	/* Note that generic_ptr is initialized to the device * but in
+	 * some init_functions, this is overridden and returns data    */
+	ptemp = priv->alloc_mem(priv->trig_alloc_sz, &generic_ptr);
+	if (!ptemp) {
+		edac_printk(KERN_ERR, EDAC_MGR,
+			    "Inject: Buffer Allocation error\n");
+		return -ENOMEM;
+	}
+
+	if (count == 3)
+		error_mask = priv->ue_set_mask;
+	else
+		error_mask = priv->ce_set_mask;
+
+	edac_printk(KERN_ALERT, EDAC_MGR,
+		    "Trigger Error Mask (0x%X)\n", error_mask);
+
+	local_irq_save(flags);
+	/* write ECC corrupted data out. */
+	for (i = 0; i < (priv->trig_alloc_sz/sizeof(*ptemp)); i++) {
+		/* Read data so we're in the correct state */
+		rmb();
+		if (ACCESS_ONCE(ptemp[i]))
+			result = -1;
+		/* Toggle Error bit (it is latched), leave ECC enabled */
+		writel(error_mask, drvdata->base);
+		writel(priv->ecc_enable_mask, drvdata->base);
+		ptemp[i] = i;
+	}
+	/* Ensure it has been written out */
+	wmb();
+	local_irq_restore(flags);
+
+	if (result)
+		edac_printk(KERN_ERR, EDAC_MGR, "Mem Not Cleared\n");
+
+	/* Read out written data. ECC error caused here */
+	for (i = 0; i < 16; i++)
+		if (ACCESS_ONCE(ptemp[i]) != i)
+			edac_printk(KERN_ERR, EDAC_MGR, "Mem Doesn't match\n");
+
+	if (priv->free_mem)
+		priv->free_mem(ptemp, priv->trig_alloc_sz, generic_ptr);
+
+	return count;
+}
+
+static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
+				const struct ecc_mgr_prv_data *priv)
+{
+	struct edac_dev_sysfs_attribute *ecc_attr = priv->eccmgr_sysfs_attr;
+
+	if (ecc_attr) {
+		edac_dci->sysfs_attributes =  ecc_attr;
+		edac_printk(KERN_ERR, EDAC_MGR, "Set SysFS trigger\n");
+	}
+}
+#else
+static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
+				const struct ecc_mgr_prv_data *priv)
+{}
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+static const struct of_device_id altr_edac_mgr_of_match[] = {
+#ifdef CONFIG_EDAC_ALTERA_L2C
+	{ .compatible = "altr,l2-edac", .data = (void *)&l2ecc_data },
+#endif
+#ifdef CONFIG_EDAC_ALTERA_OCRAM
+	{ .compatible = "altr,ocram-edac", .data = (void *)&ocramecc_data },
+#endif
+	{},
+};
+MODULE_DEVICE_TABLE(of, altr_edac_mgr_of_match);
+
+/*
+ * altr_edac_mgr_probe()
+ *	This is a generic EDAC device driver that will support
+ *	various Altera memory devices such as the L2 cache ECC and
+ *	OCRAM ECC as well as the memories for other peripherals.
+ *	Module specific initialization is done by passing the
+ *	function index in the device tree.
+ */
+static int altr_edac_mgr_probe(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci;
+	struct altr_edac_mgr_dev *drvdata;
+	struct resource *r;
+	int res = 0;
+	struct device_node *np = pdev->dev.of_node;
+	char *ecc_name = (char *)np->name;
+	static int dev_instance;
+
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		edac_printk(KERN_ERR, EDAC_MGR,
+			    "Unable to get mem resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, r->start, resource_size(r),
+				     dev_name(&pdev->dev))) {
+		edac_printk(KERN_ERR, EDAC_MGR,
+			    "%s:Error requesting mem region\n", ecc_name);
+		return -EBUSY;
+	}
+
+	dci = edac_device_alloc_ctl_info(sizeof(*drvdata), ecc_name,
+					 1, ecc_name, 1, 0, NULL, 0,
+					 dev_instance++);
+
+	if (!dci)
+		return -ENOMEM;
+
+	drvdata = dci->pvt_info;
+	dci->dev = &pdev->dev;
+	platform_set_drvdata(pdev, dci);
+	drvdata->edac_dev_name = ecc_name;
+
+	drvdata->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!drvdata->base) {
+		edac_printk(KERN_ERR, EDAC_MGR,
+			    "%s:Unable to map regs\n", ecc_name);
+		return -ENOMEM;
+	}
+
+	/* Get driver specific data for this EDAC device */
+	drvdata->data = of_match_node(altr_edac_mgr_of_match, np)->data;
+
+	/* Check specific dependencies for the module */
+	if (drvdata->data->setup) {
+		res = drvdata->data->setup(pdev, drvdata->base);
+		if (res < 0)
+			goto err;
+	}
+
+	drvdata->sb_irq = platform_get_irq(pdev, 0);
+	res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
+			       altr_edac_mgr_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	drvdata->db_irq = platform_get_irq(pdev, 1);
+	res = devm_request_irq(&pdev->dev, drvdata->db_irq,
+			       altr_edac_mgr_handler,
+			       0, dev_name(&pdev->dev), dci);
+	if (res < 0)
+		goto err;
+
+	dci->mod_name = "ECC_MGR";
+	dci->dev_name = drvdata->edac_dev_name;
+
+	altr_set_sysfs_attr(dci, drvdata->data);
+
+	if (edac_device_add_device(dci))
+		goto err;
+
+	devres_close_group(&pdev->dev, NULL);
+
+	return 0;
+err:
+	devres_release_group(&pdev->dev, NULL);
+	edac_device_free_ctl_info(dci);
+
+	return res;
+}
+
+static int altr_edac_mgr_remove(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
+
+	edac_device_del_device(&pdev->dev);
+	edac_device_free_ctl_info(dci);
+
+	return 0;
+}
+
+static struct platform_driver altr_edac_mgr_driver = {
+	.probe =  altr_edac_mgr_probe,
+	.remove = altr_edac_mgr_remove,
+	.driver = {
+		.name = "altr_edac_mgr",
+		.of_match_table = altr_edac_mgr_of_match,
+	},
+};
+module_platform_driver(altr_edac_mgr_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Thor Thayer");
+MODULE_DESCRIPTION("EDAC Driver for Altera SoC ECC Manager");
diff --git a/drivers/edac/altera_edac_mgr.h b/drivers/edac/altera_edac_mgr.h
new file mode 100644
index 0000000..791037c
--- /dev/null
+++ b/drivers/edac/altera_edac_mgr.h
@@ -0,0 +1,56 @@
+/*
+ *  Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef ALTERA_EDAC_MGR_H
+#define ALTERA_EDAC_MGR_H
+
+#include <linux/edac.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include "edac_core.h"
+
+#define EDAC_MGR "MGR"
+
+struct ecc_mgr_prv_data {
+	int (*setup)(struct platform_device *pdev, void __iomem *base);
+	int ce_clear_mask;
+	int ue_clear_mask;
+#ifdef CONFIG_EDAC_DEBUG
+	struct edac_dev_sysfs_attribute *eccmgr_sysfs_attr;
+	void * (*alloc_mem)(size_t size, void **other);
+	void (*free_mem)(void *p, size_t size, void *other);
+	int ecc_enable_mask;
+	int ce_set_mask;
+	int ue_set_mask;
+	int trig_alloc_sz;
+#endif
+};
+
+struct altr_edac_mgr_dev {
+	void __iomem *base;
+	int sb_irq;
+	int db_irq;
+	const struct ecc_mgr_prv_data *data;
+	char *edac_dev_name;
+};
+
+extern const struct ecc_mgr_prv_data l2ecc_data;
+extern const struct ecc_mgr_prv_data ocramecc_data;
+
+ssize_t altr_edac_mgr_trig(struct edac_device_ctl_info *edac_dci,
+			   const char *buffer, size_t count);
+
+#endif	/* #ifndef ALTERA_EDAC_MGR_H */
diff --git a/drivers/edac/altera_l2_edac.c b/drivers/edac/altera_l2_edac.c
new file mode 100644
index 0000000..2397fef
--- /dev/null
+++ b/drivers/edac/altera_l2_edac.c
@@ -0,0 +1,130 @@
+/*
+ *  Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/edac.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include "altera_edac_mgr.h"
+#include "edac_module.h"
+
+/* MPU L2 Register Defines */
+#define ALTR_MPUL2_CONTROL_OFFSET       0x100
+#define ALTR_MPUL2_CTL_CACHE_EN_MASK    0x00000001
+
+/* L2 ECC Management Group Defines */
+#define ALTR_MAN_GRP_L2_ECC_OFFSET      0x00
+#define ALTR_L2_ECC_EN_MASK             0x00000001
+#define ALTR_L2_ECC_INJS_MASK           0x00000002
+#define ALTR_L2_ECC_INJD_MASK           0x00000004
+
+#ifdef CONFIG_EDAC_DEBUG
+static void *l2_alloc_mem(size_t size, void **other)
+{
+	struct device *dev = *other;
+	void *ptemp = devm_kzalloc(dev, size, GFP_KERNEL);
+
+	if (!ptemp)
+		return NULL;
+
+	/* Make sure everything is written out */
+	wmb();
+	flush_cache_all();
+
+	return ptemp;
+}
+
+static void l2_free_mem(void *p, size_t size, void *other)
+{
+	struct device *dev = other;
+
+	if (dev && p)
+		devm_kfree(dev, p);
+}
+
+static struct edac_dev_sysfs_attribute altr_l2_sysfs_attributes[] = {
+	{
+		.attr = { .name = "altr_l2_trigger",
+			  .mode = (S_IRUGO | S_IWUSR) },
+		.show = NULL,
+		.store = altr_edac_mgr_trig
+	},
+	{
+		.attr = {.name = NULL }
+	}
+};
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+/*
+ * altr_l2_dependencies()
+ *	Test for L2 cache ECC dependencies upon entry because
+ *	platform specific startup should have initialized the L2
+ *	memory and enabled the ECC.
+ *	Can't turn on ECC here because accessing un-initialized
+ *	memory will cause CE/UE errors possibly causing an ABORT.
+ *	Bail if ECC is not on.
+ *	Test For 1) L2 ECC is enabled and 2) L2 Cache is enabled.
+ */
+static int altr_l2_dependencies(struct platform_device *pdev,
+				void __iomem *base)
+{
+	u32 control;
+	struct regmap *l2_vbase;
+
+	control = readl(base) & ALTR_L2_ECC_EN_MASK;
+	if (!control) {
+		dev_err(&pdev->dev, "L2: No ECC present, or ECC disabled\n");
+		return -ENODEV;
+	}
+
+	l2_vbase = syscon_regmap_lookup_by_compatible("arm,pl310-cache");
+	if (IS_ERR(l2_vbase)) {
+		dev_err(&pdev->dev,
+			"L2 ECC:regmap for arm,pl310-cache lookup failed.\n");
+		return -ENODEV;
+	}
+
+	regmap_read(l2_vbase, ALTR_MPUL2_CONTROL_OFFSET, &control);
+	if (!(control & ALTR_MPUL2_CTL_CACHE_EN_MASK)) {
+		dev_err(&pdev->dev, "L2: Cache disabled\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+const struct ecc_mgr_prv_data l2ecc_data = {
+	.setup = altr_l2_dependencies,
+	.ce_clear_mask = 0,
+	.ue_clear_mask = 0,
+#ifdef CONFIG_EDAC_DEBUG
+	.eccmgr_sysfs_attr = altr_l2_sysfs_attributes,
+	.alloc_mem = l2_alloc_mem,
+	.free_mem = l2_free_mem,
+	.ecc_enable_mask = ALTR_L2_ECC_EN_MASK,
+	.ce_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJS_MASK),
+	.ue_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJD_MASK),
+	.trig_alloc_sz = 4 * 1024,
+#endif
+};
+
diff --git a/drivers/edac/altera_ocram_edac.c b/drivers/edac/altera_ocram_edac.c
new file mode 100644
index 0000000..799b22b
--- /dev/null
+++ b/drivers/edac/altera_ocram_edac.c
@@ -0,0 +1,107 @@
+/*
+ *  Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/ctype.h>
+#include <linux/edac.h>
+#include <linux/genalloc.h>
+#include <linux/of.h>
+#include "altera_edac_mgr.h"
+
+/* OCRAM ECC Management Group Defines */
+#define ALTR_MAN_GRP_OCRAM_ECC_OFFSET   0x04
+#define ALTR_OCR_ECC_EN_MASK            0x00000001
+#define ALTR_OCR_ECC_INJS_MASK          0x00000002
+#define ALTR_OCR_ECC_INJD_MASK          0x00000004
+#define ALTR_OCR_ECC_SERR_MASK          0x00000008
+#define ALTR_OCR_ECC_DERR_MASK          0x00000010
+
+#ifdef CONFIG_EDAC_DEBUG
+static void *ocram_alloc_mem(size_t size, void **other)
+{
+	struct device_node *np;
+	struct gen_pool *gp;
+	void *sram_addr;
+
+	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
+	if (!np)
+		return NULL;
+
+	gp = of_get_named_gen_pool(np, "iram", 0);
+	if (!gp)
+		return NULL;
+	*other = gp;
+
+	sram_addr = (void *)gen_pool_alloc(gp, size);
+	if (!sram_addr)
+		return NULL;
+
+	memset(sram_addr, 0, size);
+	wmb();	/* Ensure data is written out */
+
+	return sram_addr;
+}
+
+static void ocram_free_mem(void *p, size_t size, void *other)
+{
+	gen_pool_free((struct gen_pool *)other, (u32)p, size);
+}
+
+static struct edac_dev_sysfs_attribute altr_ocr_sysfs_attributes[] = {
+	{
+		.attr = { .name = "altr_ocram_trigger",
+			  .mode = (S_IRUGO | S_IWUSR) },
+		.show = NULL,
+		.store = altr_edac_mgr_trig
+	},
+	{
+		.attr = {.name = NULL }
+	}
+};
+#endif	/* #ifdef CONFIG_EDAC_DEBUG */
+
+/*
+ * altr_ocram_dependencies()
+ *	Test for OCRAM cache ECC dependencies upon entry because
+ *	ECC must be enabled.
+ */
+static int altr_ocram_dependencies(struct platform_device *pdev,
+				   void __iomem *base)
+{
+	u32 control;
+
+	control = readl(base) & ALTR_OCR_ECC_EN_MASK;
+	if (!control) {
+		dev_err(&pdev->dev, "OCRAM: No ECC present, or ECC disabled.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+const struct ecc_mgr_prv_data ocramecc_data = {
+	.setup = altr_ocram_dependencies,
+	.ce_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_SERR_MASK),
+	.ue_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_DERR_MASK),
+#ifdef CONFIG_EDAC_DEBUG
+	.eccmgr_sysfs_attr = altr_ocr_sysfs_attributes,
+	.alloc_mem = ocram_alloc_mem,
+	.free_mem = ocram_free_mem,
+	.ecc_enable_mask = ALTR_OCR_ECC_EN_MASK,
+	.ce_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJS_MASK),
+	.ue_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJD_MASK),
+	.trig_alloc_sz = (32 * sizeof(u32)),
+#endif
+};
-- 
1.7.9.5

