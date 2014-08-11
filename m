Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaHKPLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:11:50 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:53676
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706AbaHKPLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:11:46 -0400
From: <tthayer@opensource.altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <bp@alien8.de>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv10 1/2] edac: altera: Add Altera SDRAM EDAC support.
Date: Mon, 11 Aug 2014 10:18:12 -0500
Message-ID: <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA059.namprd06.prod.outlook.com (10.242.160.49) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009004)(6009001)(199002)(189002)(22564002)(106356001)(50986999)(2201001)(89996001)(92726001)(81156004)(42186005)(105586002)(76176999)(77156001)(101416001)(88136002)(85852003)(229853001)(79102001)(81342001)(77096002)(104166001)(50226001)(83072002)(15975445006)(107046002)(4396001)(53416004)(77982001)(575784001)(93916002)(74502001)(47776003)(66066001)(86362001)(76482001)(21056001)(85306004)(69596002)(48376002)(20776003)(95666004)(74662001)(31966008)(102836001)(83322001)(86152002)(80022001)(92566001)(15202345003)(81542001)(19580395003)(19580405001)(46102001)(99396002)(87976001)(87286001)(62966002)(64706001)(50466002)(33646002)(1121002)(921003)(2004002)(217873001)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:nov;PTR:InfoNoRecords;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

This patch adds support for the CycloneV and ArriaV SDRAM controllers.
Correction and reporting of SBEs, Panic on DBEs.

Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
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

v9: Changes to support a MFD SDRAM controller with nested EDAC.

v10: Revert to version 5 (syscon) and fix errors found in v5.
---
 MAINTAINERS                |    5 +
 drivers/edac/Kconfig       |    9 +
 drivers/edac/Makefile      |    2 +
 drivers/edac/altera_edac.c |  410 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 426 insertions(+)
 create mode 100644 drivers/edac/altera_edac.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 86efa7e..2d0bf75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1340,6 +1340,11 @@ M:	Dinh Nguyen <dinguyen@altera.com>
 S:	Maintained
 F:	drivers/clk/socfpga/
 
+ARM/SOCFPGA EDAC SUPPORT
+M:	Thor Thayer <tthayer@opensource.altera.com>
+S:	Maintained
+F:	drivers/edac/altera_edac.
+
 ARM/STI ARCHITECTURE
 M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
 M:	Maxime Coquelin <maxime.coquelin@st.com>
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
index 4154ed6..70845c4 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
 obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
 obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
+
+obj-$(CONFIG_EDAC_ALTERA_MC)		+= altera_edac.o
diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
new file mode 100644
index 0000000..3c4929f
--- /dev/null
+++ b/drivers/edac/altera_edac.c
@@ -0,0 +1,410 @@
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
+ * Adapted from the highbank_mc_edac driver.
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
+#define CTLCFG_OFST             0x00
+
+/* SDRAM Controller CtrlCfg Register Bit Masks */
+#define CTLCFG_ECC_EN           0x400
+#define CTLCFG_ECC_CORR_EN      0x800
+#define CTLCFG_GEN_SB_ERR       0x2000
+#define CTLCFG_GEN_DB_ERR       0x4000
+
+#define CTLCFG_ECC_AUTO_EN	(CTLCFG_ECC_EN | \
+				 CTLCFG_ECC_CORR_EN)
+
+/* SDRAM Controller Address Width Register */
+#define DRAMADDRW_OFST          0x2C
+
+/* SDRAM Controller Address Widths Field Register */
+#define DRAMADDRW_COLBIT_MASK   0x001F
+#define DRAMADDRW_COLBIT_SHIFT  0
+#define DRAMADDRW_ROWBIT_MASK   0x03E0
+#define DRAMADDRW_ROWBIT_SHIFT  5
+#define DRAMADDRW_BANKBIT_MASK	0x1C00
+#define DRAMADDRW_BANKBIT_SHIFT 10
+#define DRAMADDRW_CSBIT_MASK	0xE000
+#define DRAMADDRW_CSBIT_SHIFT   13
+
+/* SDRAM Controller Interface Data Width Register */
+#define DRAMIFWIDTH_OFST        0x30
+
+/* SDRAM Controller Interface Data Width Defines */
+#define DRAMIFWIDTH_16B_ECC     24
+#define DRAMIFWIDTH_32B_ECC     40
+
+/* SDRAM Controller DRAM Status Register */
+#define DRAMSTS_OFST            0x38
+
+/* SDRAM Controller DRAM Status Register Bit Masks */
+#define DRAMSTS_SBEERR          0x04
+#define DRAMSTS_DBEERR          0x08
+#define DRAMSTS_CORR_DROP       0x10
+
+/* SDRAM Controller DRAM IRQ Register */
+#define DRAMINTR_OFST           0x3C
+
+/* SDRAM Controller DRAM IRQ Register Bit Masks */
+#define DRAMINTR_INTREN         0x01
+#define DRAMINTR_SBEMASK        0x02
+#define DRAMINTR_DBEMASK        0x04
+#define DRAMINTR_CORRDROPMASK   0x08
+#define DRAMINTR_INTRCLR        0x10
+
+/* SDRAM Controller Single Bit Error Count Register */
+#define SBECOUNT_OFST           0x40
+
+/* SDRAM Controller Single Bit Error Count Register Bit Masks */
+#define SBECOUNT_MASK           0x0F
+
+/* SDRAM Controller Double Bit Error Count Register */
+#define DBECOUNT_OFST           0x44
+
+/* SDRAM Controller Double Bit Error Count Register Bit Masks */
+#define DBECOUNT_MASK           0x0F
+
+/* SDRAM Controller ECC Error Address Register */
+#define ERRADDR_OFST            0x48
+
+/* SDRAM Controller ECC Error Address Register Bit Masks */
+#define ERRADDR_MASK            0xFFFFFFFF
+
+/* Altera SDRAM Memory Controller data */
+struct altr_sdram_mc_data {
+	struct regmap *mc_vbase;
+};
+
+static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
+{
+	struct mem_ctl_info *mci = dev_id;
+	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
+	u32 status, err_count, err_addr;
+
+	/* Error Address is shared by both SBE & DBE */
+	regmap_read(drvdata->mc_vbase, ERRADDR_OFST, &err_addr);
+
+	regmap_read(drvdata->mc_vbase, DRAMSTS_OFST, &status);
+
+	if (status & DRAMSTS_DBEERR) {
+		regmap_read(drvdata->mc_vbase, DBECOUNT_OFST, &err_count);
+		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
+		      err_count, err_addr);
+	}
+	if (status & DRAMSTS_SBEERR) {
+		regmap_read(drvdata->mc_vbase, SBECOUNT_OFST, &err_count);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & ~PAGE_MASK, 0,
+				     0, 0, -1, mci->ctl_name, "");
+	}
+
+	regmap_write(drvdata->mc_vbase,	DRAMINTR_OFST,
+		     (DRAMINTR_INTRCLR | DRAMINTR_INTREN));
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
+	if (!ptemp) {
+		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Inject: Buffer Allocation error\n");
+		return -ENOMEM;
+	}
+
+	regmap_read(drvdata->mc_vbase, CTLCFG_OFST, &read_reg);
+	read_reg &= ~(CTLCFG_GEN_SB_ERR | CTLCFG_GEN_DB_ERR);
+
+	/* Error are injected by writing a word while the SBE or DBE
+	 * bit in the CTLCFG register is set. Reading the word will
+	 * trigger the SBE or DBE error and the corresponding IRQ.
+	 */
+	if (count == 3) {
+		edac_printk(KERN_ALERT, EDAC_MC,
+			    "Inject Double bit error\n");
+		regmap_write(drvdata->mc_vbase, CTLCFG_OFST,
+			     (read_reg | CTLCFG_GEN_DB_ERR));
+	} else {
+		edac_printk(KERN_ALERT, EDAC_MC,
+			    "Inject Single bit error\n");
+		regmap_write(drvdata->mc_vbase,	CTLCFG_OFST,
+			     (read_reg | CTLCFG_GEN_SB_ERR));
+	}
+
+	ptemp[0] = 0x5A5A5A5A;
+	ptemp[1] = 0xA5A5A5A5;
+
+	/* Clear the error injection bits */
+	regmap_write(drvdata->mc_vbase,	CTLCFG_OFST, read_reg);
+	/* Ensure it has been written out */
+	wmb();
+
+	/*
+	 * To trigger the error, we need to read the data back
+	 * (the data was written with errors above).
+	 * The ACCESS_ONCE macros and printk are used to prevent the
+	 * the compiler optimizing these reads out.
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
+static u32 altr_sdram_get_total_mem_size(struct regmap *mc_vbase)
+{
+	u32 size, read_reg, row, bank, col, cs, width;
+
+	if (regmap_read(mc_vbase, DRAMADDRW_OFST, &read_reg) < 0)
+		return 0;
+
+	if (regmap_read(mc_vbase, DRAMIFWIDTH_OFST, &width) < 0)
+		return 0;
+
+	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
+		DRAMADDRW_COLBIT_SHIFT;
+	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
+		DRAMADDRW_ROWBIT_SHIFT;
+	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
+		DRAMADDRW_BANKBIT_SHIFT;
+	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
+		DRAMADDRW_CSBIT_SHIFT;
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
+	return size;
+}
+
+static int altr_sdram_probe(struct platform_device *pdev)
+{
+	struct edac_mc_layer layers[2];
+	struct mem_ctl_info *mci;
+	struct altr_sdram_mc_data *drvdata;
+	struct regmap *mc_vbase;
+	struct dimm_info *dimm;
+	u32 read_reg, mem_size;
+	int irq;
+	int res = 0;
+
+	/* Validate the SDRAM controller has ECC enabled */
+	/* Grab the register range from the sdr controller in device tree */
+	mc_vbase = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+						   "altr,sdr-syscon");
+	if (IS_ERR(mc_vbase)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "regmap for altr,sdr-syscon lookup failed.\n");
+		return -ENODEV;
+	}
+
+	if (regmap_read(mc_vbase, CTLCFG_OFST, &read_reg) ||
+	    ((read_reg & CTLCFG_ECC_AUTO_EN) !=	CTLCFG_ECC_AUTO_EN)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "No ECC/ECC disabled [0x%08X]\n", read_reg);
+		return -ENODEV;
+	}
+
+	/* Grab memory size from device tree. */
+	mem_size = altr_sdram_get_total_mem_size(mc_vbase);
+	if (!mem_size) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Unable to calculate memory size\n");
+		return -ENODEV;
+	}
+
+	/* Ensure the SDRAM Interrupt is disabled and cleared */
+	if (regmap_write(mc_vbase, DRAMINTR_OFST, DRAMINTR_INTRCLR)) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Error clearing SDRAM ECC IRQ\n");
+		return -ENODEV;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "No irq %d in DT\n", irq);
+		return -ENODEV;
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
+	if (!mci)
+		return -ENOMEM;
+
+	mci->pdev = &pdev->dev;
+	drvdata = mci->pvt_info;
+	drvdata->mc_vbase = mc_vbase;
+	platform_set_drvdata(pdev, mci);
+
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
+		res = -ENOMEM;
+		goto free;
+	}
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
+		goto err;
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
+	if (regmap_write(drvdata->mc_vbase, DRAMINTR_OFST,
+			 (DRAMINTR_INTRCLR | DRAMINTR_INTREN))) {
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
+err:
+	devres_release_group(&pdev->dev, NULL);
+free:
+	edac_mc_free(mci);
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
+MODULE_AUTHOR("Thor Thayer");
+MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
-- 
1.7.9.5

