Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaG3SQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:16:57 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:38486
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755381AbaG3SQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:16:51 -0400
From: <tthayer@opensource.altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <atull@altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv9 2/3] edac: altera: Add Altera EDAC support.
Date: Wed, 30 Jul 2014 13:22:52 -0500
Message-ID: <1406744573-609-3-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0028.namprd02.prod.outlook.com (10.141.56.28) To
 BN1PR03MB123.namprd03.prod.outlook.com (10.255.201.27)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(22564002)(199002)(189002)(50986999)(76176999)(15975445006)(33646002)(77156001)(21056001)(66066001)(104166001)(99396002)(74662001)(31966008)(15202345003)(92566001)(74502001)(86152002)(77096002)(80022001)(76482001)(83072002)(69596002)(85852003)(48376002)(53416004)(107046002)(87976001)(62966002)(47776003)(83322001)(64706001)(88136002)(20776003)(89996001)(46102001)(79102001)(4396001)(92726001)(87286001)(93916002)(105586002)(229853001)(2201001)(77982001)(86362001)(42186005)(102836001)(101416001)(19580395003)(95666004)(19580405001)(85306003)(50226001)(81342001)(81156004)(81542001)(50466002)(106356001)(921003)(1121002)(2004002)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB123;H:dinh-ubuntu.altera.com;FPR:;MLV:nov;PTR:InfoNoRecords;MX:1;LANG:en;
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

v9: Move Altera EDAC driver to use SDRAM MFD device since controller
    registers are shared between different drivers.
---
 MAINTAINERS                |    1 +
 drivers/edac/Kconfig       |   10 ++
 drivers/edac/Makefile      |    2 +
 drivers/edac/altera_edac.c |  293 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 306 insertions(+)
 create mode 100644 drivers/edac/altera_edac.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 48a8923..7fde28b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1344,6 +1344,7 @@ ARM/SOCFPGA SDRAM CONTROLLER SUPPORT
 M:	Thor Thayer <tthayer@altera.com>
 S:	Maintained
 F:	drivers/mfd/altera-sdr.c
+F:	drivers/edac/altera_edac.c
 
 ARM/STI ARCHITECTURE
 M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..429e244 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -368,4 +368,14 @@ config EDAC_OCTEON_PCI
 	  Support for error detection and correction on the
 	  Cavium Octeon family of SOCs.
 
+config EDAC_ALTERA_MC
+       bool "Altera SDRAM Memory Controller EDAC"
+       depends on EDAC_MM_EDAC && ARCH_SOCFPGA
+       select MFD_ALTERA_SDR
+       help
+         Support for error detection and correction on the
+         Altera SDRAM memory controller. Note that the
+         preloader must initialize the SDRAM before loading
+         the kernel.
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
index 0000000..602ae62
--- /dev/null
+++ b/drivers/edac/altera_edac.c
@@ -0,0 +1,293 @@
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
+#include <linux/mfd/altera-sdr.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include "edac_core.h"
+#include "edac_module.h"
+
+#define EDAC_MOD_STR		"altera_edac"
+#define EDAC_VERSION		"1"
+
+/* Altera SDRAM Memory Controller data */
+struct altr_sdram_mc_data {
+	struct altera_sdr *sdr;
+};
+
+static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
+{
+	struct mem_ctl_info *mci = dev_id;
+	struct altr_sdram_mc_data *drvdata = mci->pvt_info;
+	u32 status, err_count, err_addr;
+
+	/* Error Address is shared by both SBE & DBE */
+	err_addr = altera_sdr_readl(drvdata->sdr, SDR_ERRADDR_OFST);
+	status = altera_sdr_readl(drvdata->sdr, SDR_DRAMSTS_OFST);
+
+	if (status & SDR_DRAMSTS_DBEERR) {
+		err_count = altera_sdr_readl(drvdata->sdr, SDR_DBECOUNT_OFST);
+		panic("\nEDAC: [%d Uncorrectable errors @ 0x%08X]\n",
+		      err_count, err_addr);
+	}
+	if (status & SDR_DRAMSTS_SBEERR) {
+		err_count = altera_sdr_readl(drvdata->sdr, SDR_SBECOUNT_OFST);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & ~PAGE_MASK, 0,
+				     0, 0, -1, mci->ctl_name, "");
+	}
+
+	altera_sdr_writel(drvdata->sdr,
+			  SDR_DRAMINTR_OFST,
+			  SDR_DRAMINTR_INTRCLR | SDR_DRAMINTR_INTREN);
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
+	mci->pdev->coherent_dma_mask = ~0;
+	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
+
+	if (!ptemp) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Inject: Buffer Allocation error\n");
+		return -ENOMEM;
+	}
+
+	read_reg = altera_sdr_readl(drvdata->sdr, SDR_CTLCFG_OFST);
+	read_reg &= ~(SDR_CTLCFG_GEN_SB_ERR | SDR_CTLCFG_GEN_DB_ERR);
+
+	/* Error are injected by writing a word while the SBE or DBE
+	 * bit in the CTLCFG register is set. Reading the word will
+	 * trigger the SBE or DBE error and the corresponding IRQ.
+	 */
+	if (count == 3) {
+		edac_printk(KERN_ALERT, EDAC_MC,
+			    "Inject Double bit error\n");
+		altera_sdr_writel(drvdata->sdr, SDR_CTLCFG_OFST,
+				  (read_reg | SDR_CTLCFG_GEN_DB_ERR));
+	} else {
+		edac_printk(KERN_ALERT, EDAC_MC,
+			    "Inject Single bit error\n");
+		altera_sdr_writel(drvdata->sdr, SDR_CTLCFG_OFST,
+				  (read_reg | SDR_CTLCFG_GEN_SB_ERR));
+	}
+
+	ptemp[0] = 0x5A5A5A5A;
+	ptemp[1] = 0xA5A5A5A5;
+
+	/* Clear the error injection bits */
+	altera_sdr_writel(drvdata->sdr, SDR_CTLCFG_OFST, read_reg);
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
+static int altr_sdram_probe(struct platform_device *pdev)
+{
+	struct altera_sdr *sdr = dev_get_drvdata(pdev->dev.parent);
+	struct edac_mc_layer layers[2];
+	struct mem_ctl_info *mci;
+	struct altr_sdram_mc_data *drvdata;
+	struct dimm_info *dimm;
+	u32 read_reg, mem_size;
+	int irq;
+	int res = 0;
+
+	/* Validate the SDRAM controller has ECC enabled */
+	read_reg = altera_sdr_readl(sdr, SDR_CTLCFG_OFST);
+	if ((read_reg & SDR_CTLCFG_ECC_AUTO_EN) != SDR_CTLCFG_ECC_AUTO_EN) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "No ECC/ECC disabled [0x%08X]\n", read_reg);
+		return -ENODEV;
+	}
+
+	/* Grab memory size from device tree. */
+	mem_size = altera_sdr_mem_size(sdr);
+	edac_printk(KERN_DEBUG, EDAC_MC, "Memory Size = 0x%08x\n", mem_size);
+	if (mem_size <= 0) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			    "Unable to calculate memory size\n");
+		return -ENODEV;
+	}
+
+	/* Ensure the SDRAM Interrupt is disabled and cleared */
+	altera_sdr_writel(sdr, SDR_DRAMINTR_OFST, SDR_DRAMINTR_INTRCLR);
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
+	drvdata->sdr = sdr;
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
+	altera_sdr_writel(drvdata->sdr,
+			  SDR_DRAMINTR_OFST,
+			  SDR_DRAMINTR_INTRCLR | SDR_DRAMINTR_INTREN);
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
+MODULE_AUTHOR("Altera Corporation");
+MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
-- 
1.7.9.5

