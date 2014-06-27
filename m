Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaF0DDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:03:17 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:28147
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbaF0DC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:02:59 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v3 2/2] memory: pl353: Add driver for arm pl353 static memory controller
Date: Fri, 27 Jun 2014 08:32:42 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1403838162-18756-1-git-send-email-punnaia@xilinx.com>
References: <1403838162-18756-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <4e814a4c-64f9-4dc0-abbb-0f8e87d94a94@BY2FFO11FD003.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(88136002)(21056001)(79102001)(87936001)(83072002)(93916002)(85852003)(99396002)(92566001)(44976005)(76482001)(47776003)(20776003)(31696002)(89996001)(77156001)(77982001)(2201001)(87286001)(92726001)(76176999)(104166001)(86362001)(83322001)(46102001)(31966008)(48376002)(74662001)(6806004)(1496007)(74502001)(50466002)(80022001)(74316001)(106466001)(95666004)(70736001)(85306003)(33646001)(81542001)(77096002)(50986999)(19580405001)(19580395003)(50226001)(104016002)(62966002)(53416004)(102836001)(4396001)(81342001)(107046002)(1121002)(921003)(2004002)(83996005)(217873001)(23106004)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB052;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for arm pl353 static memory controller. This controller is
used in xilinx zynq soc for interfacing the nand and nor/sram memory
devices.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v2:
 - Since now the timing parameters are in nano seconds, added logic to convert
   them to the cycles
---
 drivers/memory/Kconfig           |    6 +
 drivers/memory/Makefile          |    1 +
 drivers/memory/pl353-smc.c       |  569 ++++++++++++++++++++++++++++++++++++++
 include/linux/memory/pl353-smc.h |   34 +++
 4 files changed, 610 insertions(+), 0 deletions(-)
 create mode 100644 drivers/memory/pl353-smc.c
 create mode 100644 include/linux/memory/pl353-smc.h

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c9..58c29a2 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -65,4 +65,10 @@ config FSL_IFC
 	bool
 	depends on FSL_SOC
 
+config PL353_SMC
+	bool "ARM PL353 Static Memory Controller(SMC) driver"
+	default y
+	depends on ARM
+	help
+	  This driver is for the ARM PL353 Static Memory Controller(SMC) module.
 endif
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 71160a2..5040977 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_MVEBU_DEVBUS)	+= mvebu-devbus.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
+obj-$(CONFIG_PL353_SMC)		+= pl353-smc.o
diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
new file mode 100644
index 0000000..02221ba
--- /dev/null
+++ b/drivers/memory/pl353-smc.c
@@ -0,0 +1,569 @@
+/*
+ * ARM PL353 SMC Driver
+ *
+ * Copyright (C) 2012 - 2014 Xilinx, Inc.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Currently only a single SMC instance is supported.
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/memory/pl353-smc.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* Register definitions */
+#define PL353_SMC_MEMC_STATUS_OFFS	0	/* Controller status reg, RO */
+#define PL353_SMC_CFG_CLR_OFFS		0xC	/* Clear config reg, WO */
+#define PL353_SMC_DIRECT_CMD_OFFS	0x10	/* Direct command reg, WO */
+#define PL353_SMC_SET_CYCLES_OFFS	0x14	/* Set cycles register, WO */
+#define PL353_SMC_SET_OPMODE_OFFS	0x18	/* Set opmode register, WO */
+#define PL353_SMC_ECC_STATUS_OFFS	0x400	/* ECC status register */
+#define PL353_SMC_ECC_MEMCFG_OFFS	0x404	/* ECC mem config reg */
+#define PL353_SMC_ECC_MEMCMD1_OFFS	0x408	/* ECC mem cmd1 reg */
+#define PL353_SMC_ECC_MEMCMD2_OFFS	0x40C	/* ECC mem cmd2 reg */
+#define PL353_SMC_ECC_VALUE0_OFFS	0x418	/* ECC value 0 reg */
+
+/* Controller status register specifc constants */
+#define PL353_SMC_MEMC_STATUS_RAW_INT_1_SHIFT	6
+
+/* Clear configuration register specific constants */
+#define PL353_SMC_CFG_CLR_INT_CLR_1	0x10
+#define PL353_SMC_CFG_CLR_ECC_INT_DIS_1	0x40
+#define PL353_SMC_CFG_CLR_INT_DIS_1	0x2
+#define PL353_SMC_CFG_CLR_DEFAULT_MASK	(PL353_SMC_CFG_CLR_INT_CLR_1 | \
+					 PL353_SMC_CFG_CLR_ECC_INT_DIS_1 | \
+					 PL353_SMC_CFG_CLR_INT_DIS_1)
+
+/* Set cycles register specific constants */
+#define PL353_SMC_SET_CYCLES_T0_MASK	0xF
+#define PL353_SMC_SET_CYCLES_T0_SHIFT	0
+#define PL353_SMC_SET_CYCLES_T1_MASK	0xF
+#define PL353_SMC_SET_CYCLES_T1_SHIFT	4
+#define PL353_SMC_SET_CYCLES_T2_MASK	0x7
+#define PL353_SMC_SET_CYCLES_T2_SHIFT	8
+#define PL353_SMC_SET_CYCLES_T3_MASK	0x7
+#define PL353_SMC_SET_CYCLES_T3_SHIFT	11
+#define PL353_SMC_SET_CYCLES_T4_MASK	0x7
+#define PL353_SMC_SET_CYCLES_T4_SHIFT	14
+#define PL353_SMC_SET_CYCLES_T5_MASK	0x7
+#define PL353_SMC_SET_CYCLES_T5_SHIFT	17
+#define PL353_SMC_SET_CYCLES_T6_MASK	0xF
+#define PL353_SMC_SET_CYCLES_T6_SHIFT	20
+
+/* ECC status register specific constants */
+#define PL353_SMC_ECC_STATUS_BUSY	(1 << 6)
+
+/* ECC memory config register specific constants */
+#define PL353_SMC_ECC_MEMCFG_MODE_MASK	0xC
+#define PL353_SMC_ECC_MEMCFG_MODE_SHIFT	2
+#define PL353_SMC_ECC_MEMCFG_PGSIZE_MASK	0xC
+
+#define PL353_SMC_DC_UPT_NAND_REGS	((4 << 23) |	/* CS: NAND chip */ \
+				 (2 << 21))	/* UpdateRegs operation */
+
+#define PL353_NAND_ECC_CMD1	((0x80)       |	/* Write command */ \
+				 (0 << 8)     |	/* Read command */ \
+				 (0x30 << 16) |	/* Read End command */ \
+				 (1 << 24))	/* Read End command calid */
+
+#define PL353_NAND_ECC_CMD2	((0x85)	      |	/* Write col change cmd */ \
+				 (5 << 8)     |	/* Read col change cmd */ \
+				 (0xE0 << 16) |	/* Read col change end cmd */ \
+				 (1 << 24)) /* Read col change end cmd valid */
+#define PL353_NAND_ECC_BUSY_TIMEOUT	(1 * HZ)
+#define NS2CYCLE(clk, ns)	(int)((ns) * ((clk) / 1000000) / 1000)
+
+/**
+ * struct pl353_smc_data - Private smc driver structure
+ * @devclk:		Pointer to the peripheral clock
+ * @aperclk:		Pointer to the APER clock
+ */
+struct pl353_smc_data {
+	struct clk		*memclk;
+	struct clk		*aclk;
+};
+
+/* SMC virtual register base */
+static void __iomem *pl353_smc_base;
+
+/**
+ * pl353_smc_set_buswidth - Set memory buswidth
+ * @bw:	Memory buswidth (8 | 16)
+ * Return: 0 on success or negative errno.
+ */
+int pl353_smc_set_buswidth(unsigned int bw)
+{
+
+	if (bw != PL353_SMC_MEM_WIDTH_8  && bw != PL353_SMC_MEM_WIDTH_16)
+		return -EINVAL;
+
+	writel(bw, pl353_smc_base + PL353_SMC_SET_OPMODE_OFFS);
+	writel(PL353_SMC_DC_UPT_NAND_REGS, pl353_smc_base +
+	       PL353_SMC_DIRECT_CMD_OFFS);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_set_buswidth);
+
+/**
+ * pl353_smc_set_cycles - Set memory timing parameters
+ * @t0:	t_rc		read cycle time
+ * @t1:	t_wc		write cycle time
+ * @t2:	t_rea/t_ceoe	output enable assertion delay
+ * @t3:	t_wp		write enable deassertion delay
+ * @t4:	t_clr/t_pc	page cycle time
+ * @t5:	t_ar/t_ta	ID read time/turnaround time
+ * @t6:	t_rr		busy to RE timing
+ *
+ * Sets NAND chip specific timing parameters.
+ */
+static void pl353_smc_set_cycles(u32 t0, u32 t1, u32 t2, u32 t3, u32
+			      t4, u32 t5, u32 t6)
+{
+	t0 &= PL353_SMC_SET_CYCLES_T0_MASK;
+	t1 = (t1 & PL353_SMC_SET_CYCLES_T1_MASK) <<
+			PL353_SMC_SET_CYCLES_T1_SHIFT;
+	t2 = (t2 & PL353_SMC_SET_CYCLES_T2_MASK) <<
+			PL353_SMC_SET_CYCLES_T2_SHIFT;
+	t3 = (t3 & PL353_SMC_SET_CYCLES_T3_MASK) <<
+			PL353_SMC_SET_CYCLES_T3_SHIFT;
+	t4 = (t4 & PL353_SMC_SET_CYCLES_T4_MASK) <<
+			PL353_SMC_SET_CYCLES_T4_SHIFT;
+	t5 = (t5 & PL353_SMC_SET_CYCLES_T5_MASK) <<
+			PL353_SMC_SET_CYCLES_T5_SHIFT;
+	t6 = (t6 & PL353_SMC_SET_CYCLES_T6_MASK) <<
+			PL353_SMC_SET_CYCLES_T6_SHIFT;
+
+	t0 |= t1 | t2 | t3 | t4 | t5 | t6;
+
+	writel(t0, pl353_smc_base + PL353_SMC_SET_CYCLES_OFFS);
+	writel(PL353_SMC_DC_UPT_NAND_REGS, pl353_smc_base +
+	       PL353_SMC_DIRECT_CMD_OFFS);
+}
+
+/**
+ * pl353_smc_ecc_is_busy_noirq - Read ecc busy flag
+ * Return: the ecc_status bit from the ecc_status register. 1 = busy, 0 = idle
+ */
+static int pl353_smc_ecc_is_busy_noirq(void)
+{
+	return !!(readl(pl353_smc_base + PL353_SMC_ECC_STATUS_OFFS) &
+		  PL353_SMC_ECC_STATUS_BUSY);
+}
+
+/**
+ * pl353_smc_ecc_is_busy - Read ecc busy flag
+ * Return: the ecc_status bit from the ecc_status register. 1 = busy, 0 = idle
+ */
+int pl353_smc_ecc_is_busy(void)
+{
+	int ret;
+
+	ret = pl353_smc_ecc_is_busy_noirq();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_ecc_is_busy);
+
+/**
+ * pl353_smc_get_ecc_val - Read ecc_valueN registers
+ * @ecc_reg:	Index of the ecc_value reg (0..3)
+ * Return: the content of the requested ecc_value register.
+ *
+ * There are four valid ecc_value registers. The argument is truncated to stay
+ * within this valid boundary.
+ */
+u32 pl353_smc_get_ecc_val(int ecc_reg)
+{
+	u32 addr, reg;
+
+	ecc_reg &= 3;
+	addr = PL353_SMC_ECC_VALUE0_OFFS + (ecc_reg << 2);
+	reg = readl(pl353_smc_base + addr);
+
+	return reg;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_get_ecc_val);
+
+/**
+ * pl353_smc_get_nand_int_status_raw - Get NAND interrupt status bit
+ * Return: the raw_int_status1 bit from the memc_status register
+ */
+int pl353_smc_get_nand_int_status_raw(void)
+{
+	u32 reg;
+
+	reg = readl(pl353_smc_base + PL353_SMC_MEMC_STATUS_OFFS);
+	reg >>= PL353_SMC_MEMC_STATUS_RAW_INT_1_SHIFT;
+	reg &= 1;
+
+	return reg;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_get_nand_int_status_raw);
+
+/**
+ * pl353_smc_clr_nand_int - Clear NAND interrupt
+ */
+void pl353_smc_clr_nand_int(void)
+{
+	writel(PL353_SMC_CFG_CLR_INT_CLR_1,
+		pl353_smc_base + PL353_SMC_CFG_CLR_OFFS);
+}
+EXPORT_SYMBOL_GPL(pl353_smc_clr_nand_int);
+
+/**
+ * pl353_smc_set_ecc_mode - Set SMC ECC mode
+ * @mode:	ECC mode (BYPASS, APB, MEM)
+ * Return: 0 on success or negative errno.
+ */
+int pl353_smc_set_ecc_mode(enum pl353_smc_ecc_mode mode)
+{
+	u32 reg;
+	int ret = 0;
+
+	switch (mode) {
+	case PL353_SMC_ECCMODE_BYPASS:
+	case PL353_SMC_ECCMODE_APB:
+	case PL353_SMC_ECCMODE_MEM:
+
+		reg = readl(pl353_smc_base + PL353_SMC_ECC_MEMCFG_OFFS);
+		reg &= ~PL353_SMC_ECC_MEMCFG_MODE_MASK;
+		reg |= mode << PL353_SMC_ECC_MEMCFG_MODE_SHIFT;
+		writel(reg, pl353_smc_base + PL353_SMC_ECC_MEMCFG_OFFS);
+
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_set_ecc_mode);
+
+/**
+ * pl353_smc_set_ecc_pg_size - Set SMC ECC page size
+ * @pg_sz:	ECC page size
+ * Return: 0 on success or negative errno.
+ */
+int pl353_smc_set_ecc_pg_size(unsigned int pg_sz)
+{
+	u32 reg, sz;
+
+	switch (pg_sz) {
+	case 0:
+		sz = 0;
+		break;
+	case 512:
+		sz = 1;
+		break;
+	case 1024:
+		sz = 2;
+		break;
+	case 2048:
+		sz = 3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg = readl(pl353_smc_base + PL353_SMC_ECC_MEMCFG_OFFS);
+	reg &= ~PL353_SMC_ECC_MEMCFG_PGSIZE_MASK;
+	reg |= sz;
+	writel(reg, pl353_smc_base + PL353_SMC_ECC_MEMCFG_OFFS);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pl353_smc_set_ecc_pg_size);
+
+static int __maybe_unused pl353_smc_suspend(struct device *dev)
+{
+	struct pl353_smc_data *pl353_smc = dev_get_drvdata(dev);
+
+	clk_disable(pl353_smc->memclk);
+	clk_disable(pl353_smc->aclk);
+
+	return 0;
+}
+
+static int __maybe_unused pl353_smc_resume(struct device *dev)
+{
+	int ret;
+	struct pl353_smc_data *pl353_smc = dev_get_drvdata(dev);
+
+	ret = clk_enable(pl353_smc->aclk);
+	if (ret) {
+		dev_err(dev, "Cannot enable axi domain clock.\n");
+		return ret;
+	}
+
+	ret = clk_enable(pl353_smc->memclk);
+	if (ret) {
+		dev_err(dev, "Cannot enable memory clock.\n");
+		clk_disable(pl353_smc->aclk);
+		return ret;
+	}
+	return ret;
+}
+
+static SIMPLE_DEV_PM_OPS(pl353_smc_dev_pm_ops, pl353_smc_suspend,
+			 pl353_smc_resume);
+
+/**
+ * pl353_smc_init_nand_interface - Initialize the NAND interface
+ * @pdev:	Pointer to the platform_device struct
+ * @nand_node:	Pointer to the pl353_nand device_node struct
+ */
+static void pl353_smc_init_nand_interface(struct platform_device *pdev,
+				       struct device_node *nand_node)
+{
+	u32 t_rc, t_wc, t_rea, t_wp, t_clr, t_ar, t_rr;
+	int err;
+	unsigned long timeout = jiffies + PL353_NAND_ECC_BUSY_TIMEOUT;
+	int clkrate;
+	struct pl353_smc_data *pl353_smc = platform_get_drvdata(pdev);
+
+	clkrate = clk_get_rate(pl353_smc->memclk);
+	/* nand-cycle-<X> property is refer to the NAND flash timing
+	 * mapping between dts and the NAND flash AC timing
+	 *  X  : AC timing name
+	 *  t0 : t_rc
+	 *  t1 : t_wc
+	 *  t2 : t_rea
+	 *  t3 : t_wp
+	 *  t4 : t_clr
+	 *  t5 : t_ar
+	 *  t6 : t_rr
+	 */
+	err = of_property_read_u32(nand_node, "nand-tRC-ns", &t_rc);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tRC-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_rc = NS2CYCLE(clkrate, t_rc);
+	err = of_property_read_u32(nand_node, "nand-tWC-ns", &t_wc);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tWC-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_wc = NS2CYCLE(clkrate, t_wc);
+	err = of_property_read_u32(nand_node, "nand-tREA-ns", &t_rea);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tREA-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_rea = NS2CYCLE(clkrate, t_rea);
+	err = of_property_read_u32(nand_node, "nand-tWP-ns", &t_wp);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tWP-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_wp = NS2CYCLE(clkrate, t_wp);
+	err = of_property_read_u32(nand_node, "nand-tCLR-ns", &t_clr);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tCLR-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_clr = NS2CYCLE(clkrate, t_clr);
+	err = of_property_read_u32(nand_node, "nand-tAR-ns", &t_ar);
+	if (err) {
+		dev_warn(&pdev->dev, "nand,tAR-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_ar = NS2CYCLE(clkrate, t_ar);
+	err = of_property_read_u32(nand_node, "nand-tRR-ns", &t_rr);
+	if (err) {
+		dev_warn(&pdev->dev, "arm,tRR-ns not in device tree");
+		goto default_nand_timing;
+	}
+	t_rr = NS2CYCLE(clkrate, t_rr);
+
+default_nand_timing:
+	if (err) {
+		/* set default NAND flash timing property */
+		dev_warn(&pdev->dev, "Using default timing for");
+		dev_warn(&pdev->dev, "2Gb Numonyx MT29F2G08ABAEAWP NAND flash");
+		dev_warn(&pdev->dev, "tWP, tCLR, tAR are set to 4");
+		dev_warn(&pdev->dev, "tRC, tWC, tRR are set to 2");
+		dev_warn(&pdev->dev, "tREA is set to 1");
+		t_rc = t_wc = t_rr = 4;
+		t_rea = 1;
+		t_wp = t_clr = t_ar = 2;
+	}
+
+	pl353_smc_set_buswidth(PL353_SMC_MEM_WIDTH_8);
+
+	/*
+	 * Default assume 50MHz clock (20ns cycle time) and 3V operation
+	 * The SET_CYCLES_REG register value depends on the flash device.
+	 * Look in to the device datasheet and change its value, This value
+	 * is for 2Gb Numonyx flash.
+	 */
+	pl353_smc_set_cycles(t_rc, t_wc, t_rea, t_wp, t_clr, t_ar, t_rr);
+	writel(PL353_SMC_CFG_CLR_INT_CLR_1,
+		pl353_smc_base + PL353_SMC_CFG_CLR_OFFS);
+	writel(PL353_SMC_DC_UPT_NAND_REGS, pl353_smc_base +
+	       PL353_SMC_DIRECT_CMD_OFFS);
+	/* Wait till the ECC operation is complete */
+	do {
+		if (pl353_smc_ecc_is_busy_noirq())
+			cpu_relax();
+		else
+			break;
+	} while (!time_after_eq(jiffies, timeout));
+
+	if (time_after_eq(jiffies, timeout))
+		dev_err(&pdev->dev, "nand ecc busy status timed out");
+	/* Set the command1 and command2 register */
+	writel(PL353_NAND_ECC_CMD1,
+			pl353_smc_base + PL353_SMC_ECC_MEMCMD1_OFFS);
+	writel(PL353_NAND_ECC_CMD2,
+			pl353_smc_base + PL353_SMC_ECC_MEMCMD2_OFFS);
+}
+
+static const struct of_device_id matches_nor[] = {
+	{ .compatible = "cfi-flash" },
+	{}
+};
+
+static const struct of_device_id matches_nand[] = {
+	{ .compatible = "arm,pl353-nand-r2p1" },
+	{}
+};
+
+static int pl353_smc_probe(struct platform_device *pdev)
+{
+	struct pl353_smc_data *pl353_smc;
+	struct device_node *child;
+	struct resource *res;
+	int err;
+	struct device_node *of_node = pdev->dev.of_node;
+	const struct of_device_id *matches = NULL;
+
+	pl353_smc = devm_kzalloc(&pdev->dev, sizeof(*pl353_smc), GFP_KERNEL);
+	if (!pl353_smc)
+		return -ENOMEM;
+
+	/* Get the NAND controller virtual address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pl353_smc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pl353_smc_base))
+		return PTR_ERR(pl353_smc_base);
+
+	pl353_smc->aclk = devm_clk_get(&pdev->dev, "aclk");
+	if (IS_ERR(pl353_smc->aclk)) {
+		dev_err(&pdev->dev, "aclk clock not found.\n");
+		return PTR_ERR(pl353_smc->aclk);
+	}
+
+	pl353_smc->memclk = devm_clk_get(&pdev->dev, "memclk");
+	if (IS_ERR(pl353_smc->memclk)) {
+		dev_err(&pdev->dev, "memclk clock not found.\n");
+		return PTR_ERR(pl353_smc->memclk);
+	}
+
+	err = clk_prepare_enable(pl353_smc->aclk);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to enable AXI clock.\n");
+		return err;
+	}
+
+	err = clk_prepare_enable(pl353_smc->memclk);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to enable memory clock.\n");
+		goto out_clk_dis_aper;
+	}
+
+	platform_set_drvdata(pdev, pl353_smc);
+
+	/* clear interrupts */
+	writel(PL353_SMC_CFG_CLR_DEFAULT_MASK,
+		pl353_smc_base + PL353_SMC_CFG_CLR_OFFS);
+
+	/* Find compatible children. Only a single child is supported */
+	for_each_available_child_of_node(of_node, child) {
+		if (of_match_node(matches_nand, child)) {
+			pl353_smc_init_nand_interface(pdev, child);
+			if (!matches) {
+				matches = matches_nand;
+			} else {
+				dev_err(&pdev->dev,
+					"incompatible configuration\n");
+				goto out_clk_disable;
+			}
+		}
+
+		if (of_match_node(matches_nor, child)) {
+			static int counts;
+			if (!matches) {
+				matches = matches_nor;
+			} else {
+				if (matches != matches_nor || counts > 1) {
+					dev_err(&pdev->dev,
+						"incompatible configuration\n");
+					goto out_clk_disable;
+				}
+			}
+			counts++;
+		}
+	}
+
+	if (matches)
+		of_platform_populate(of_node, matches, NULL, &pdev->dev);
+
+	return 0;
+
+out_clk_disable:
+	clk_disable_unprepare(pl353_smc->memclk);
+out_clk_dis_aper:
+	clk_disable_unprepare(pl353_smc->aclk);
+
+	return err;
+}
+
+static int pl353_smc_remove(struct platform_device *pdev)
+{
+	struct pl353_smc_data *pl353_smc = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(pl353_smc->memclk);
+	clk_disable_unprepare(pl353_smc->aclk);
+
+	return 0;
+}
+
+/* Match table for device tree binding */
+static const struct of_device_id pl353_smc_of_match[] = {
+	{ .compatible = "arm,pl353-smc-r2p1" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pl353_smc_of_match);
+
+static struct platform_driver pl353_smc_driver = {
+	.probe		= pl353_smc_probe,
+	.remove		= pl353_smc_remove,
+	.driver		= {
+		.name	= "pl353-smc",
+		.owner	= THIS_MODULE,
+		.pm	= &pl353_smc_dev_pm_ops,
+		.of_match_table = pl353_smc_of_match,
+	},
+};
+
+module_platform_driver(pl353_smc_driver);
+
+MODULE_AUTHOR("Xilinx, Inc.");
+MODULE_DESCRIPTION("ARM PL353 SMC Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/memory/pl353-smc.h b/include/linux/memory/pl353-smc.h
new file mode 100644
index 0000000..a37ec18
--- /dev/null
+++ b/include/linux/memory/pl353-smc.h
@@ -0,0 +1,34 @@
+/*
+ * ARM PL353 SMC Driver Header
+ *
+ * Copyright (C) 2012 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MEMORY_PL353_SMC_H
+#define __LINUX_MEMORY_PL353_SMC_H
+
+enum pl353_smc_ecc_mode {
+	PL353_SMC_ECCMODE_BYPASS = 0,
+	PL353_SMC_ECCMODE_APB = 1,
+	PL353_SMC_ECCMODE_MEM = 2
+};
+
+enum pl353_smc_mem_width {
+	PL353_SMC_MEM_WIDTH_8 = 0,
+	PL353_SMC_MEM_WIDTH_16 = 1
+};
+
+u32 pl353_smc_get_ecc_val(int ecc_reg);
+int pl353_smc_ecc_is_busy(void);
+int pl353_smc_get_nand_int_status_raw(void);
+void pl353_smc_clr_nand_int(void);
+int pl353_smc_set_ecc_mode(enum pl353_smc_ecc_mode mode);
+int pl353_smc_set_ecc_pg_size(unsigned int pg_sz);
+int pl353_smc_set_buswidth(unsigned int bw);
+
+#endif
-- 
1.7.4


