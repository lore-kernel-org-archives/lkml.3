Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaFQCSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:18:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:32052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbaFQCSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:18:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="355215237"
Message-ID: <539FA55D.2030603@linux.intel.com>
Date: Tue, 17 Jun 2014 10:18:05 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] x86: new Intel Atom SoC power management controller driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Management Controller (PMC) controls many of the power
management features present in the SoC. This driver provides
interface to configure the Power Management Controller (PMC).

This driver exposes PMC device state and sleep state residency
via debugfs:
	/sys/kernel/debugfs/pmc_atom/dev_state
	/sys/kernel/debugfs/pmc_atom/sleep_state

This driver also provides a native power off function via PMC PCI
IO port.

v2:
- Allow pmc_atom and lpc_ich to work at the same time.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Lejun Zhu <Lejun.zhu@linux.intel.com>
Signed-off-by: Kasagar, Srinidhi <srinidhi.kasagar@intel.com>
Reviewed-by: Rudramuni, Vishwesh M <vishwesh.m.rudramuni@intel.com>
Reviewed-by: Joe Perches <joe@perches.com>
---
 arch/x86/Kconfig                |    4 +
 arch/x86/include/asm/pmc_atom.h |  107 +++++++++++++
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/pmc_atom.c      |  323 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 435 insertions(+)
 create mode 100644 arch/x86/include/asm/pmc_atom.h
 create mode 100644 arch/x86/kernel/pmc_atom.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fcefdda..fa9c4b7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2404,6 +2404,10 @@ config IOSF_MBI
 	default m
 	depends on PCI
 
+config PMC_ATOM
+	def_bool y
+        depends on PCI
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
new file mode 100644
index 0000000..c5c5d62
--- /dev/null
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -0,0 +1,107 @@
+/*
+ * Intel Atom SOC Power Management Controller Header File
+ * Copyright (c) 2014, Intel Corporation.
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
+ */
+
+#ifndef PMC_ATOM_H
+#define PMC_ATOM_H
+
+/* ValleyView Power Control Unit PCI Device ID */
+#define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
+
+/* PMC Memory mapped IO registers */
+#define	PMC_BASE_ADDR_OFFSET	0x44
+#define	PMC_BASE_ADDR_MASK	0xFFFFFE00
+#define	PMC_MMIO_REG_LEN	0x100
+#define	PMC_REG_BIT_WIDTH	32
+
+/* BIOS uses FUNC_DIS to disable specific function */
+#define	PMC_FUNC_DIS		0x34
+#define	PMC_FUNC_DIS_2		0x38
+
+/* S0ix wake event control */
+#define PMC_S0IX_WAKE_EN       0x3C
+
+#define BIT_LPC_CLOCK_RUN		BIT(4)
+#define	BIT_SHARED_IRQ_GPSC		BIT(5)
+#define	BIT_ORED_DEDICATED_IRQ_GPSS	BIT(18)
+#define	BIT_ORED_DEDICATED_IRQ_GPSC	BIT(19)
+#define	BIT_SHARED_IRQ_GPSS		BIT(20)
+
+#define PMC_WAKE_EN_SETTING	~(BIT_LPC_CLOCK_RUN | \
+				BIT_SHARED_IRQ_GPSC | \
+				BIT_ORED_DEDICATED_IRQ_GPSS | \
+				BIT_ORED_DEDICATED_IRQ_GPSC | \
+				BIT_SHARED_IRQ_GPSS)
+
+/* The timers acumulate time spent in sleep state */
+#define	PMC_S0IR_TMR		0x80
+#define	PMC_S0I1_TMR		0x84
+#define	PMC_S0I2_TMR		0x88
+#define	PMC_S0I3_TMR		0x8C
+#define	PMC_S0_TMR		0x90
+/* Sleep state counter is in units of of 32us */
+#define	PMC_TMR_SHIFT		5
+
+/* These registers reflect D3 status of functions */
+#define	PMC_D3_STS_0		0xA0
+
+#define	BIT_LPSS1_F0_DMA	BIT(0)
+#define	BIT_LPSS1_F1_PWM1	BIT(1)
+#define	BIT_LPSS1_F2_PWM2	BIT(2)
+#define	BIT_LPSS1_F3_HSUART1	BIT(3)
+#define	BIT_LPSS1_F4_HSUART2	BIT(4)
+#define	BIT_LPSS1_F5_SPI	BIT(5)
+#define	BIT_LPSS1_F6_XXX	BIT(6)
+#define	BIT_LPSS1_F7_XXX	BIT(7)
+#define	BIT_SCC_EMMC		BIT(8)
+#define	BIT_SCC_SDIO		BIT(9)
+#define	BIT_SCC_SDCARD		BIT(10)
+#define	BIT_SCC_MIPI		BIT(11)
+#define	BIT_HDA			BIT(12)
+#define	BIT_LPE			BIT(13)
+#define	BIT_OTG			BIT(14)
+#define	BIT_USH			BIT(15)
+#define	BIT_GBE			BIT(16)
+#define	BIT_SATA		BIT(17)
+#define	BIT_USB_EHCI		BIT(18)
+#define	BIT_SEC			BIT(19)
+#define	BIT_PCIE_PORT0		BIT(20)
+#define	BIT_PCIE_PORT1		BIT(21)
+#define	BIT_PCIE_PORT2		BIT(22)
+#define	BIT_PCIE_PORT3		BIT(23)
+#define	BIT_LPSS2_F0_DMA	BIT(24)
+#define	BIT_LPSS2_F1_I2C1	BIT(25)
+#define	BIT_LPSS2_F2_I2C2	BIT(26)
+#define	BIT_LPSS2_F3_I2C3	BIT(27)
+#define	BIT_LPSS2_F4_I2C4	BIT(28)
+#define	BIT_LPSS2_F5_I2C5	BIT(29)
+#define	BIT_LPSS2_F6_I2C6	BIT(30)
+#define	BIT_LPSS2_F7_I2C7	BIT(31)
+
+#define	PMC_D3_STS_1		0xA4
+#define	BIT_SMB			BIT(0)
+#define	BIT_OTG_SS_PHY		BIT(1)
+#define	BIT_USH_SS_PHY		BIT(2)
+#define	BIT_DFX			BIT(3)
+
+/* PMC I/O Registers */
+#define	ACPI_BASE_ADDR_OFFSET	0x40
+#define	ACPI_BASE_ADDR_MASK	0xFFFFFE00
+#define	ACPI_MMIO_REG_LEN	0x100
+
+#define	PM1_CNT			0x4
+#define	SLEEP_TYPE_MASK		0xFFFFECFF
+#define	SLEEP_TYPE_S5		0x1C00
+#define	SLEEP_ENABLE		0x2000
+#endif /* PMC_ATOM_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 047f9ff..bde3993 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
+obj-$(CONFIG_PMC_ATOM)			+= pmc_atom.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
new file mode 100644
index 0000000..1ceef86
--- /dev/null
+++ b/arch/x86/kernel/pmc_atom.c
@@ -0,0 +1,323 @@
+/*
+ * Intel Atom SOC Power Management Controller Driver
+ * Copyright (c) 2014, Intel Corporation.
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
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/io.h>
+
+#include <asm/pmc_atom.h>
+
+#define	DRIVER_NAME	KBUILD_MODNAME
+
+struct pmc_dev {
+	u32 base_addr;
+	void __iomem *regmap;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dbgfs_dir;
+#endif /* CONFIG_DEBUG_FS */
+};
+
+static struct pmc_dev pmc_device;
+static u32 acpi_base_addr;
+
+struct pmc_dev_map {
+	const char *name;
+	u32 bit_mask;
+};
+
+static const struct pmc_dev_map dev_map[] = {
+	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
+	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
+	{"2  - LPSS1_F2_PWM2",		BIT_LPSS1_F2_PWM2},
+	{"3  - LPSS1_F3_HSUART1",	BIT_LPSS1_F3_HSUART1},
+	{"4  - LPSS1_F4_HSUART2",	BIT_LPSS1_F4_HSUART2},
+	{"5  - LPSS1_F5_SPI",		BIT_LPSS1_F5_SPI},
+	{"6  - LPSS1_F6_Reserved",	BIT_LPSS1_F6_XXX},
+	{"7  - LPSS1_F7_Reserved",	BIT_LPSS1_F7_XXX},
+	{"8  - SCC_EMMC",		BIT_SCC_EMMC},
+	{"9  - SCC_SDIO",		BIT_SCC_SDIO},
+	{"10 - SCC_SDCARD",		BIT_SCC_SDCARD},
+	{"11 - SCC_MIPI",		BIT_SCC_MIPI},
+	{"12 - HDA",			BIT_HDA},
+	{"13 - LPE",			BIT_LPE},
+	{"14 - OTG",			BIT_OTG},
+	{"15 - USH",			BIT_USH},
+	{"16 - GBE",			BIT_GBE},
+	{"17 - SATA",			BIT_SATA},
+	{"18 - USB_EHCI",		BIT_USB_EHCI},
+	{"19 - SEC",			BIT_SEC},
+	{"20 - PCIE_PORT0",		BIT_PCIE_PORT0},
+	{"21 - PCIE_PORT1",		BIT_PCIE_PORT1},
+	{"22 - PCIE_PORT2",		BIT_PCIE_PORT2},
+	{"23 - PCIE_PORT3",		BIT_PCIE_PORT3},
+	{"24 - LPSS2_F0_DMA",		BIT_LPSS2_F0_DMA},
+	{"25 - LPSS2_F1_I2C1",		BIT_LPSS2_F1_I2C1},
+	{"26 - LPSS2_F2_I2C2",		BIT_LPSS2_F2_I2C2},
+	{"27 - LPSS2_F3_I2C3",		BIT_LPSS2_F3_I2C3},
+	{"28 - LPSS2_F3_I2C4",		BIT_LPSS2_F4_I2C4},
+	{"29 - LPSS2_F5_I2C5",		BIT_LPSS2_F5_I2C5},
+	{"30 - LPSS2_F6_I2C6",		BIT_LPSS2_F6_I2C6},
+	{"31 - LPSS2_F7_I2C7",		BIT_LPSS2_F7_I2C7},
+	{"32 - SMB",			BIT_SMB},
+	{"33 - OTG_SS_PHY",		BIT_OTG_SS_PHY},
+	{"34 - USH_SS_PHY",		BIT_USH_SS_PHY},
+	{"35 - DFX",			BIT_DFX},
+};
+
+static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
+{
+	return readl(pmc->regmap + reg_offset);
+}
+
+static inline void pmc_reg_write(struct pmc_dev *pmc, int reg_offset, u32 val)
+{
+	writel(val, pmc->regmap + reg_offset);
+}
+
+static void pmc_power_off(void)
+{
+	u16	pm1_cnt_port;
+	u32	pm1_cnt_value;
+
+	pr_info("Preparing to enter system sleep state S5\n");
+
+	pm1_cnt_port = acpi_base_addr + PM1_CNT;
+
+	pm1_cnt_value = inl(pm1_cnt_port);
+	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value |= SLEEP_TYPE_S5;
+	pm1_cnt_value |= SLEEP_ENABLE;
+
+	outl(pm1_cnt_value, pm1_cnt_port);
+}
+
+static void pmc_reg_setup(struct pmc_dev *pmc)
+{
+	/*
+	 * Disable PMC SOIX_WAKE_EN events coming from:
+	 * - LPC clock run
+	 * - GPIO_SUS ored dedicated IRQs
+	 * - GPIO_SCORE ored dedicated IRQs
+	 * - GPIO_SUS shared IRQ
+	 * - GPIO_SCORE shared IRQ
+	 */
+	pmc_reg_write(pmc, PMC_S0IX_WAKE_EN, (u32)PMC_WAKE_EN_SETTING);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int pmc_dev_state_show(struct seq_file *s, void *unused)
+{
+	struct pmc_dev *pmc = s->private;
+	u32 func_dis, func_dis_2, func_dis_index;
+	u32 d3_sts_0, d3_sts_1, d3_sts_index;
+	int dev_num, dev_index, reg_index;
+
+	func_dis = pmc_reg_read(pmc, PMC_FUNC_DIS);
+	func_dis_2 = pmc_reg_read(pmc, PMC_FUNC_DIS_2);
+	d3_sts_0 = pmc_reg_read(pmc, PMC_D3_STS_0);
+	d3_sts_1 = pmc_reg_read(pmc, PMC_D3_STS_1);
+
+	dev_num = ARRAY_SIZE(dev_map);
+
+	for (dev_index = 0; dev_index < dev_num; dev_index++) {
+		reg_index = dev_index / PMC_REG_BIT_WIDTH;
+		if (reg_index) {
+			func_dis_index = func_dis_2;
+			d3_sts_index = d3_sts_1;
+		} else {
+			func_dis_index = func_dis;
+			d3_sts_index = d3_sts_0;
+		}
+
+		seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
+			dev_map[dev_index].name,
+			dev_map[dev_index].bit_mask & func_dis_index ?
+			"Disabled" : "Enabled ",
+			dev_map[dev_index].bit_mask & d3_sts_index ?
+			"D3" : "D0");
+	}
+	return 0;
+}
+
+static int pmc_dev_state_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmc_dev_state_show, inode->i_private);
+}
+
+static const struct file_operations pmc_dev_state_ops = {
+	.open		= pmc_dev_state_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int pmc_sleep_tmr_show(struct seq_file *s, void *unused)
+{
+	struct pmc_dev *pmc = s->private;
+	u64 s0ir_tmr, s0i1_tmr, s0i2_tmr, s0i3_tmr, s0_tmr;
+
+	s0ir_tmr = pmc_reg_read(pmc, PMC_S0IR_TMR) << PMC_TMR_SHIFT;
+	s0i1_tmr = pmc_reg_read(pmc, PMC_S0I1_TMR) << PMC_TMR_SHIFT;
+	s0i2_tmr = pmc_reg_read(pmc, PMC_S0I2_TMR) << PMC_TMR_SHIFT;
+	s0i3_tmr = pmc_reg_read(pmc, PMC_S0I3_TMR) << PMC_TMR_SHIFT;
+	s0_tmr = pmc_reg_read(pmc, PMC_S0_TMR) << PMC_TMR_SHIFT;
+
+	seq_printf(s, "S0IR Residency:\t%lldus\n", s0ir_tmr);
+	seq_printf(s, "S0I1 Residency:\t%lldus\n", s0i1_tmr);
+	seq_printf(s, "S0I2 Residency:\t%lldus\n", s0i2_tmr);
+	seq_printf(s, "S0I3 Residency:\t%lldus\n", s0i3_tmr);
+	seq_printf(s, "S0   Residency:\t%lldus\n", s0_tmr);
+	return 0;
+}
+
+static int pmc_sleep_tmr_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmc_sleep_tmr_show, inode->i_private);
+}
+
+static const struct file_operations pmc_sleep_tmr_ops = {
+	.open		= pmc_sleep_tmr_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void pmc_dbgfs_unregister(struct pmc_dev *pmc)
+{
+	if (!pmc->dbgfs_dir)
+		return;
+
+	debugfs_remove_recursive(pmc->dbgfs_dir);
+	pmc->dbgfs_dir = NULL;
+}
+
+static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
+{
+	struct dentry *dir, *f;
+
+	dir = debugfs_create_dir("pmc_atom", NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	f = debugfs_create_file("dev_state", S_IFREG | S_IRUGO,
+				dir, pmc, &pmc_dev_state_ops);
+	if (!f) {
+		dev_err(&pdev->dev, "dev_states register failed\n");
+		goto err;
+	}
+	f = debugfs_create_file("sleep_state", S_IFREG | S_IRUGO,
+				dir, pmc, &pmc_sleep_tmr_ops);
+	if (!f) {
+		dev_err(&pdev->dev, "sleep_state register failed\n");
+		goto err;
+	}
+	pmc->dbgfs_dir = dir;
+	return 0;
+err:
+	pmc_dbgfs_unregister(pmc);
+	return -ENODEV;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static int pmc_setup_dev(struct pci_dev *pdev)
+{
+	struct pmc_dev *pmc = &pmc_device;
+	int ret;
+
+	pci_read_config_dword(pdev, PMC_BASE_ADDR_OFFSET, &pmc->base_addr);
+	pmc->base_addr &= PMC_BASE_ADDR_MASK;
+
+	pmc->regmap = ioremap_nocache(pmc->base_addr, PMC_MMIO_REG_LEN);
+	if (!pmc->regmap) {
+		dev_err(&pdev->dev, "error: ioremap failed\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+#ifdef CONFIG_DEBUG_FS
+	ret = pmc_dbgfs_register(pmc, pdev);
+	if (ret)
+		goto err_unmap;
+#endif /* CONFIG_DEBUG_FS */
+
+	/* Install power off function */
+	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
+	acpi_base_addr &= ACPI_BASE_ADDR_MASK;
+	if (acpi_base_addr != 0 && pm_power_off == NULL)
+		pm_power_off = pmc_power_off;
+
+	/* PMC hardware registers setup */
+	pmc_reg_setup(pmc);
+	return 0;
+
+err_unmap:
+	iounmap(pmc->regmap);
+err:
+	return ret;
+}
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because lpc_ich will register
+ * a driver on the same PCI id.
+ */
+static const struct pci_device_id pmc_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_VLV_PMC) },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(pci, pmc_pci_ids);
+
+static int __init pmc_atom_init(void)
+{
+	int err = -ENODEV;
+	struct pci_dev *pdev = NULL;
+	const struct pci_device_id *ent;
+
+	/* We look for our device - PCU PMC
+	 * we assume that there is max. one device.
+	 *
+	 * We can't use plain pci_driver mechanism,
+	 * as the device is really a multiple function device,
+	 * main driver that binds to the pci_device is lpc_ich
+	 * and have to find & bind to the device this way.
+	 */
+	for_each_pci_dev(pdev) {
+		ent = pci_match_id(pmc_pci_ids, pdev);
+		if (ent) {
+			err = pmc_setup_dev(pdev);
+			goto out;
+		}
+	}
+	/* Device not found. */
+out:
+	return err;
+}
+
+module_init(pmc_atom_init);
+/* no module_exit, this driver shouldn't be unloaded */
+
+MODULE_AUTHOR("Aubrey Li <aubrey.li@linux.intel.com>");
+MODULE_DESCRIPTION("Intel Atom SOC Power Management Controller Interface");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4
