Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaF0PVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:21:01 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:47803
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753943AbaF0PUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:20:54 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv8 3/3] edac: altera: Add Altera SDRAM Controller EDAC support.
Date: Fri, 27 Jun 2014 10:26:59 -0500
Message-ID: <1403882819-24929-4-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403882819-24929-1-git-send-email-tthayer@altera.com>
References: <1403882819-24929-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(22564002)(199002)(575784001)(86152002)(21056001)(31966008)(92566001)(86362001)(74502001)(92726001)(2201001)(93916002)(33646001)(48376002)(87286001)(87936001)(74662001)(50466002)(89996001)(88136002)(102836001)(4396001)(107046002)(85852003)(105596002)(83072002)(50226001)(104166001)(36756003)(99396002)(76176999)(95666004)(106466001)(77156001)(97736001)(50986999)(42186005)(85306003)(62966002)(76482001)(46102001)(77982001)(83322001)(44976005)(6806004)(81542001)(20776003)(19580395003)(64706001)(19580405001)(77096002)(68736004)(47776003)(81342001)(80022001)(79102001)(84676001)(921003)(1121002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB136;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

This patch adds support for the CycloneV and ArriaV SDRAM controllers. 
Correction and reporting of SBEs, Panic on DBEs.

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
v2: Use the SDRAM controller registers to calculate memory size
    instead of the Device Tree. Update To & Cc list. Add maintainer
    information.

v3: EDAC driver cleanup based on comments from Mailing list.

v4: Panic on DBE. Add macro around inject-error reads to prevent
    them from being optimized out. Remove of_match_ptr since this
    will always use Device Tree.

v5: Addition of printk to trigger function to ensure read vars
    are not optimized out.

v6: Changes to split out shared SDRAM controller reg (offset 0x00)
    as a syscon device and allocate ECC specific SDRAM registers
    to EDAC.

v7: No changes. Bump for consistency.

v8: Alphabetize headers.
---
 drivers/edac/Kconfig       |    9 +
 drivers/edac/Makefile      |    2 +
 drivers/edac/altera_edac.c |  449 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 460 insertions(+)
 create mode 100644 drivers/edac/altera_edac.c

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..4f4d379 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
 	  Support for error detection and correction on the
 	  Cavium Octeon family of SOCs.
 
+config EDAC_ALTERA_MC
+	bool "Altera SDRAM Memory Controller EDAC"
+	depends on EDAC_MM_EDAC && ARCH_SOCFPGA
+	help
+	  Support for error detection and correction on the
+	  Altera SDRAM memory controller. Note that the
+	  preloader must initialize the SDRAM before loading
+	  the kernel.
+
 endif # EDAC
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 4154ed6..9741336 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
 obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
 obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
+
+obj-$(CONFIG_EDAC_ALTERA_MC)	        += altera_edac.o
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
new file mode 100644
index 0000000..73254f9
--- /dev/null
+++ b/drivers/edac/altera_edac.c
@@ -0,0 +1,449 @@
+/*
+ *  Copyright Altera Corporation (C) 2014. All rights reserved.
+ *  Copyright 2011-2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+
+ *
+ * Adapted from the highbank_mc_edac driver
+ *
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
+#include <linux/uaccess.h>
+
+#include "edac_core.h"
+#include "edac_module.h"
+
+#define EDAC_MOD_STR		"altera_edac"
+#define EDAC_VERSION		"1"
+
+/* SDRAM Controller CtrlCfg Register */
+#define CTLCFG			0x00
+
+/* SDRAM Controller CtrlCfg Register Bit Masks */
+#define CTLCFG_ECC_EN		0x400
+#define CTLCFG_ECC_CORR_EN	0x800
+#define CTLCFG_GEN_SB_ERR	0x2000
+#define CTLCFG_GEN_DB_ERR	0x4000
+
+#define CTLCFG_ECC_AUTO_EN	(CTLCFG_ECC_EN | \
+				 CTLCFG_ECC_CORR_EN)
+
+/* SDRAM Controller ECC Register Offset */
+#define ECC_REG_OFFSET		0x2C
+
+/* SDRAM Controller Address Width Register */
+#define DRAMADDRW		(0x2C-ECC_REG_OFFSET)
+
+/* SDRAM Controller Address Widths Field Register */
+#define DRAMADDRW_COLBIT_MASK	0x001F
+#define DRAMADDRW_COLBIT_LSB	0
+#define DRAMADDRW_ROWBIT_MASK	0x03E0
+#define DRAMADDRW_ROWBIT_LSB	5
+#define DRAMADDRW_BANKBIT_MASK	0x1C00
+#define DRAMADDRW_BANKBIT_LSB	10
+#define DRAMADDRW_CSBIT_MASK	0xE000
+#define DRAMADDRW_CSBIT_LSB	13
+
+/* SDRAM Controller Interface Data Width Register */
+#define DRAMIFWIDTH		(0x30-ECC_REG_OFFSET)
+
+/* SDRAM Controller Interface Data Width Defines */
+#define DRAMIFWIDTH_16B_ECC	24
+#define DRAMIFWIDTH_32B_ECC	40
+
+/* SDRAM Controller DRAM Status Register */
+#define DRAMSTS			(0x38-ECC_REG_OFFSET)
+
+/* SDRAM Controller DRAM Status Register Bit Masks */
+#define DRAMSTS_SBEERR		0x04
+#define DRAMSTS_DBEERR		0x08
+#define DRAMSTS_CORR_DROP	0x10
+
+/* SDRAM Controller DRAM IRQ Register */
+#define DRAMINTR		(0x3C-ECC_REG_OFFSET)
+
+/* SDRAM Controller DRAM IRQ Register Bit Masks */
+#define DRAMINTR_INTREN		0x01
+#define DRAMINTR_SBEMASK	0x02
+#define DRAMINTR_DBEMASK	0x04
+#define DRAMINTR_CORRDROPMASK	0x08
+#define DRAMINTR_INTRCLR	0x10
+
+/* SDRAM Controller Single Bit Error Count Register */
+#define SBECOUNT		(0x40-ECC_REG_OFFSET)
+
+/* SDRAM Controller Single Bit Error Count Register Bit Masks */
+#define SBECOUNT_MASK		0x0F
+
+/* SDRAM Controller Double Bit Error Count Register */
+#define DBECOUNT		(0x44-ECC_REG_OFFSET)
+
+/* SDRAM Controller Double Bit Error Count Register Bit Masks */
+#define DBECOUNT_MASK		0x0F
+
+/* SDRAM Controller ECC Error Address Register */
+#define ERRADDR			(0x48-ECC_REG_OFFSET)
+
+/* SDRAM Controller ECC Error Address Register Bit Masks */
+#define ERRADDR_MASK		0xFFFFFFFF
+
+/* SDRAM Controller ECC Autocorrect Drop Count Register */
+#define DROPCOUNT		(0x4C-ECC_REG_OFFSET)
+
+/* SDRAM Controller ECC Autocorrect Drop Count Register Bit Masks */
+#define DROPCOUNT_MASK		0x0F
+
+/* SDRAM Controller ECC AutoCorrect Address Register */
+#define DROPADDR		(0x50-ECC_REG_OFFSET)
+
+/* SDRAM Controller ECC AutoCorrect Error Address Register Bit Masks */
+#define DROPADDR_MASK		0xFFFFFFFF
+
+/* Altera SDRAM Memory Controller data */
+struct altr_sdram_mc_data {
+	struct regmap *mc_vconfig;
+	void __iomem  *mc_vecc_regs;
+};
+
+static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
+{
+	struct mem_ctl_info *mci = dev_id;
+	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
+	u32 status, err_count, err_addr;
+
+	/* Error Address is shared by both SBE & DBE */
+	err_addr = readl(drvdata->mc_vecc_regs + ERRADDR);
+
+	status = readl(drvdata->mc_vecc_regs + DRAMSTS);
+
+	if (status & DRAMSTS_DBEERR) {
+		err_count = readl(drvdata->mc_vecc_regs + DBECOUNT);
+		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
+		      err_count, err_addr);
+	}
+	if (status & DRAMSTS_SBEERR) {
+		err_count = readl(drvdata->mc_vecc_regs + SBECOUNT);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & ~PAGE_MASK, 0,
+				     0, 0, -1, mci->ctl_name, "");
+	}
+
+	writel((DRAMINTR_INTRCLR | DRAMINTR_INTREN),
+	       drvdata->mc_vecc_regs + DRAMINTR);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_EDAC_DEBUG
+static ssize_t altr_sdr_mc_err_inject_write(struct file *file,
+					    const char __user *data,
+					    size_t count, loff_t *ppos)
+{
+	struct mem_ctl_info *mci = file->private_data;
+	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
+	u32 *ptemp;
+	dma_addr_t dma_handle;
+	u32 reg, read_reg;
+
+	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
+	if (IS_ERR(ptemp)) {
+		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Inject: Buffer Allocation error\n");
+		return -ENOMEM;
+	}
+
+	regmap_read(drvdata->mc_vconfig, CTLCFG, &read_reg);
+	read_reg &= ~(CTLCFG_GEN_SB_ERR | CTLCFG_GEN_DB_ERR);
+
+	if (count == 3) {
+		dev_alert(mci->pdev, "EDAC Inject Double bit error\n");
+		regmap_write(drvdata->mc_vconfig, CTLCFG,
+			     (read_reg | CTLCFG_GEN_DB_ERR));
+	} else {
+		dev_alert(mci->pdev, "EDAC Inject Single bit error\n");
+		regmap_write(drvdata->mc_vconfig,	CTLCFG,
+			     (read_reg | CTLCFG_GEN_SB_ERR));
+	}
+
+	ptemp[0] = 0x5A5A5A5A;
+	ptemp[1] = 0xA5A5A5A5;
+	/* Clear the error injection bits */
+	regmap_write(drvdata->mc_vconfig, CTLCFG, read_reg);
+	/* Ensure it has been written out */
+	wmb();
+
+	/*
+	 * To trigger the error, we need to read the data back
+	 * (the data was written with errors above)
+	 * The ACCESS_ONCE macros are used to prevent the
+	 * compiler optimizing these reads out.
+	 */
+	reg = ACCESS_ONCE(ptemp[0]);
+	read_reg = ACCESS_ONCE(ptemp[1]);
+	/* Force Read */
+	rmb();
+
+	edac_printk(KERN_ALERT, EDAC_MC, "Read Data [0x%X, 0x%X]\n",
+		    reg, read_reg);
+
+	dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
+
+	return count;
+}
+
+static const struct file_operations altr_sdr_mc_debug_inject_fops = {
+	.open = simple_open,
+	.write = altr_sdr_mc_err_inject_write,
+	.llseek = generic_file_llseek,
+};
+
+static void altr_sdr_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
+{
+	if (mci->debugfs)
+		debugfs_create_file("inject_ctrl", S_IWUSR, mci->debugfs, mci,
+				    &altr_sdr_mc_debug_inject_fops);
+}
+#else
+static void altr_sdr_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
+{}
+#endif
+
+/* Get total memory size in bytes */
+static u32 altr_sdram_get_total_mem_size(void __iomem *mc_vbase)
+{
+	u32 size;
+	u32 read_reg, row, bank, col, cs, width;
+
+	read_reg = readl(mc_vbase + DRAMADDRW);
+
+	width = readl(mc_vbase + DRAMIFWIDTH);
+
+	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
+		DRAMADDRW_COLBIT_LSB;
+	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
+		DRAMADDRW_ROWBIT_LSB;
+	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
+		DRAMADDRW_BANKBIT_LSB;
+	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
+		DRAMADDRW_CSBIT_LSB;
+
+	/* Correct for ECC as its not addressible */
+	if (width == DRAMIFWIDTH_32B_ECC)
+		width = 32;
+	if (width == DRAMIFWIDTH_16B_ECC)
+		width = 16;
+
+	/* calculate the SDRAM size base on this info */
+	size = 1 << (row + bank + col);
+	size = size * cs * (width / 8);
+
+	return size;
+}
+
+static int altr_sdram_probe(struct platform_device *pdev)
+{
+	struct edac_mc_layer layers[2];
+	struct mem_ctl_info *mci;
+	struct altr_sdram_mc_data *drvdata;
+	struct regmap *mc_vconfig;
+	void __iomem *mc_vregs;
+	struct dimm_info *dimm;
+	u32 read_reg, mem_size;
+	struct resource *r;
+	int irq;
+	int res = 0;
+
+	/* Validate the SDRAM controller has ECC enabled */
+	/* Grab the register values from the sdr-ctl in device tree */
+	mc_vconfig = syscon_regmap_lookup_by_compatible("altr,sdr-ctl");
+	if (IS_ERR(mc_vconfig)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "regmap for altr,sdr-ctl lookup failed.\n");
+		return -ENODEV;
+	}
+
+	if (regmap_read(mc_vconfig, CTLCFG, &read_reg) ||
+	    ((read_reg & CTLCFG_ECC_AUTO_EN) !=	CTLCFG_ECC_AUTO_EN)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "No ECC/ECC disabled [0x%08X]\n", read_reg);
+		return -ENODEV;
+	}
+
+	/* Allocate the ECC Registers */
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		edac_printk(KERN_ERR, EDAC_MC, "Unable to get mem resource\n");
+		return -ENODEV;
+	}
+
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
+		res = -ENOMEM;
+		goto err;
+	}
+
+	mc_vregs = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(mc_vregs)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Error while requesting mem region\n");
+		res = PTR_ERR(mc_vregs);
+		goto err;
+	}
+
+	edac_printk(KERN_ERR, EDAC_MC,
+		    "Allocated [%p] with [start:0x%X size:%d]\n", mc_vregs,
+		    r->start, resource_size(r));
+
+	/* Grab memory size from SDRAM Controller registers. */
+	mem_size = altr_sdram_get_total_mem_size(mc_vregs);
+	if (mem_size <= 0) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Unable to calculate memory size\n");
+		res = -ENODEV;
+		goto err;
+	}
+
+	edac_printk(KERN_ERR, EDAC_MC,
+		    "SDRAM Memory size %d [0x%X]\n", mem_size, mem_size);
+
+	/* Ensure the SDRAM Interrupt is disabled and cleared */
+	writel(DRAMINTR_INTRCLR, mc_vregs + DRAMINTR);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "No irq %d in DT\n", irq);
+		res = -ENODEV;
+		goto err;
+	}
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 1;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_virt_csrow = false;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    sizeof(struct altr_sdram_mc_data));
+	if (!mci) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Unable to allocate edac mci\n");
+		res = -ENOMEM;
+		goto err;
+	}
+
+	mci->pdev = &pdev->dev;
+	drvdata = mci->pvt_info;
+	drvdata->mc_vconfig = mc_vconfig;
+	drvdata->mc_vecc_regs = mc_vregs;
+	platform_set_drvdata(pdev, mci);
+
+	mci->mtype_cap = MEM_FLAG_DDR3;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
+	mci->edac_cap = EDAC_FLAG_SECDED;
+	mci->mod_name = EDAC_MOD_STR;
+	mci->mod_ver = EDAC_VERSION;
+	mci->ctl_name = dev_name(&pdev->dev);
+	mci->scrub_mode = SCRUB_SW_SRC;
+	mci->dev_name = dev_name(&pdev->dev);
+
+	dimm = *mci->dimms;
+	dimm->nr_pages = ((mem_size - 1) >> PAGE_SHIFT) + 1;
+	dimm->grain = 8;
+	dimm->dtype = DEV_X8;
+	dimm->mtype = MEM_DDR3;
+	dimm->edac_mode = EDAC_SECDED;
+
+	res = edac_mc_add_mc(mci);
+	if (res < 0)
+		goto free;
+
+	res = devm_request_irq(&pdev->dev, irq, altr_sdram_mc_err_handler,
+			       0, dev_name(&pdev->dev), mci);
+	if (res < 0) {
+		edac_mc_printk(mci, KERN_ERR,
+			       "Unable to request irq %d\n", irq);
+		res = -ENODEV;
+		goto err2;
+	}
+
+	writel((DRAMINTR_INTRCLR | DRAMINTR_INTREN), mc_vregs + DRAMINTR);
+	if ((readl(mc_vregs + DRAMINTR) & (DRAMINTR_INTRCLR | DRAMINTR_INTREN))
+		 != DRAMINTR_INTREN) {
+		edac_mc_printk(mci, KERN_ERR,
+			       "Error enabling SDRAM ECC IRQ\n");
+		res = -ENODEV;
+		goto err2;
+	}
+
+	altr_sdr_mc_create_debugfs_nodes(mci);
+
+	devres_close_group(&pdev->dev, NULL);
+
+	return 0;
+
+err2:
+	edac_mc_del_mc(&pdev->dev);
+free:
+	edac_mc_free(mci);
+err:
+	devres_release_group(&pdev->dev, NULL);
+	edac_printk(KERN_ERR, EDAC_MC,
+		    "EDAC Probe Failed; Error %d\n", res);
+
+	return res;
+}
+
+static int altr_sdram_remove(struct platform_device *pdev)
+{
+	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
+
+	edac_mc_del_mc(&pdev->dev);
+	edac_mc_free(mci);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct of_device_id altr_sdram_ctrl_of_match[] = {
+	{ .compatible = "altr,sdram-edac", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, altr_sdram_ctrl_of_match);
+
+static struct platform_driver altr_sdram_edac_driver = {
+	.probe = altr_sdram_probe,
+	.remove = altr_sdram_remove,
+	.driver = {
+		.name = "altr_sdram_edac",
+		.of_match_table = altr_sdram_ctrl_of_match,
+	},
+};
+
+module_platform_driver(altr_sdram_edac_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Altera Corporation");
+MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
-- 
1.7.9.5

