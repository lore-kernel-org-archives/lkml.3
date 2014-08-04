Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaHDMX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:23:28 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37361 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaHDMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:23:27 -0400
Date: Mon, 4 Aug 2014 14:23:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.17
Message-ID: <20140804122319.GA27162@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: 4c51cb005b29e6329d7e598bf835689b230817c9 x86/pmc_atom: Silence shift wrapping warnings in pmc_sleep_tmr_show()

The main changes in this cycle are:

  * Intel SOC driver updates, by Aubrey Li.

  * TS5500 platform updates, by Vivien Didelot.

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      x86/pmc_atom: Silence shift wrapping warnings in pmc_sleep_tmr_show()

Li, Aubrey (3):
      x86/platform: New Intel Atom SOC power management controller driver
      x86/pmc_atom: Eisable a few S0ix wake up events for S0ix residency
      x86/pmc_atom: Expose PMC device state and platform sleep state

Vivien Didelot (3):
      x86/platform/ts5500: Use the DEVICE_ATTR_RO() macro
      x86/platform/ts5500: Add a 'name' sysfs attribute
      x86/platform/ts5500: Add support for TS-5400 boards


 Documentation/ABI/testing/sysfs-platform-ts5500 |   7 +
 arch/x86/Kconfig                                |   4 +
 arch/x86/include/asm/pmc_atom.h                 | 107 ++++++++
 arch/x86/kernel/Makefile                        |   1 +
 arch/x86/kernel/pmc_atom.c                      | 321 ++++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500.c               |  94 ++++---
 6 files changed, 493 insertions(+), 41 deletions(-)
 create mode 100644 arch/x86/include/asm/pmc_atom.h
 create mode 100644 arch/x86/kernel/pmc_atom.c

diff --git a/Documentation/ABI/testing/sysfs-platform-ts5500 b/Documentation/ABI/testing/sysfs-platform-ts5500
index c88375a..e685957 100644
--- a/Documentation/ABI/testing/sysfs-platform-ts5500
+++ b/Documentation/ABI/testing/sysfs-platform-ts5500
@@ -30,6 +30,13 @@ Description:
 		the corresponding bit is set. For instance, 0x0e means jumpers
 		2, 3 and 4 are set.
 
+What:		/sys/devices/platform/ts5500/name
+Date:		July 2014
+KernelVersion:	3.16
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Model name of the TS board, e.g. "TS-5500".
+
 What:		/sys/devices/platform/ts5500/rs485
 Date:		January 2013
 KernelVersion:	3.7
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..6295a21 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2403,6 +2403,10 @@ config IOSF_MBI
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
index 0000000..fc7a17c
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
+#define	PMC_S0IX_WAKE_EN	0x3C
+
+#define	BIT_LPC_CLOCK_RUN		BIT(4)
+#define	BIT_SHARED_IRQ_GPSC		BIT(5)
+#define	BIT_ORED_DEDICATED_IRQ_GPSS	BIT(18)
+#define	BIT_ORED_DEDICATED_IRQ_GPSC	BIT(19)
+#define	BIT_SHARED_IRQ_GPSS		BIT(20)
+
+#define	PMC_WAKE_EN_SETTING	~(BIT_LPC_CLOCK_RUN | \
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
index 0000000..0c424a6
--- /dev/null
+++ b/arch/x86/kernel/pmc_atom.c
@@ -0,0 +1,321 @@
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
+static void pmc_hw_reg_setup(struct pmc_dev *pmc)
+{
+	/*
+	 * Disable PMC S0IX_WAKE_EN events coming from:
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
+	s0ir_tmr = (u64)pmc_reg_read(pmc, PMC_S0IR_TMR) << PMC_TMR_SHIFT;
+	s0i1_tmr = (u64)pmc_reg_read(pmc, PMC_S0I1_TMR) << PMC_TMR_SHIFT;
+	s0i2_tmr = (u64)pmc_reg_read(pmc, PMC_S0I2_TMR) << PMC_TMR_SHIFT;
+	s0i3_tmr = (u64)pmc_reg_read(pmc, PMC_S0I3_TMR) << PMC_TMR_SHIFT;
+	s0_tmr = (u64)pmc_reg_read(pmc, PMC_S0_TMR) << PMC_TMR_SHIFT;
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
+	/* Obtain ACPI base address */
+	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
+	acpi_base_addr &= ACPI_BASE_ADDR_MASK;
+
+	/* Install power off function */
+	if (acpi_base_addr != 0 && pm_power_off == NULL)
+		pm_power_off = pmc_power_off;
+
+	pci_read_config_dword(pdev, PMC_BASE_ADDR_OFFSET, &pmc->base_addr);
+	pmc->base_addr &= PMC_BASE_ADDR_MASK;
+
+	pmc->regmap = ioremap_nocache(pmc->base_addr, PMC_MMIO_REG_LEN);
+	if (!pmc->regmap) {
+		dev_err(&pdev->dev, "error: ioremap failed\n");
+		return -ENOMEM;
+	}
+
+	/* PMC hardware registers setup */
+	pmc_hw_reg_setup(pmc);
+
+#ifdef CONFIG_DEBUG_FS
+	ret = pmc_dbgfs_register(pmc, pdev);
+	if (ret) {
+		iounmap(pmc->regmap);
+		return ret;
+	}
+#endif /* CONFIG_DEBUG_FS */
+	return 0;
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
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 9471b94..baf16e7 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -1,7 +1,7 @@
 /*
  * Technologic Systems TS-5500 Single Board Computer support
  *
- * Copyright (C) 2013 Savoir-faire Linux Inc.
+ * Copyright (C) 2013-2014 Savoir-faire Linux Inc.
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  *
  * This program is free software; you can redistribute it and/or modify it under
@@ -15,8 +15,8 @@
  * state or available options. For further information about sysfs entries, see
  * Documentation/ABI/testing/sysfs-platform-ts5500.
  *
- * This code actually supports the TS-5500 platform, but it may be extended to
- * support similar Technologic Systems x86-based platforms, such as the TS-5600.
+ * This code may be extended to support similar x86-based platforms.
+ * Actually, the TS-5500 and TS-5400 are supported.
  */
 
 #include <linux/delay.h>
@@ -32,6 +32,7 @@
 /* Product code register */
 #define TS5500_PRODUCT_CODE_ADDR	0x74
 #define TS5500_PRODUCT_CODE		0x60	/* TS-5500 product code */
+#define TS5400_PRODUCT_CODE		0x40	/* TS-5400 product code */
 
 /* SRAM/RS-485/ADC options, and RS-485 RTS/Automatic RS-485 flags register */
 #define TS5500_SRAM_RS485_ADC_ADDR	0x75
@@ -66,6 +67,7 @@
 
 /**
  * struct ts5500_sbc - TS-5500 board description
+ * @name:	Board model name.
  * @id:		Board product ID.
  * @sram:	Flag for SRAM option.
  * @rs485:	Flag for RS-485 option.
@@ -75,6 +77,7 @@
  * @jumpers:	Bitfield for jumpers' state.
  */
 struct ts5500_sbc {
+	const char *name;
 	int	id;
 	bool	sram;
 	bool	rs485;
@@ -122,13 +125,16 @@ static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
 	if (!request_region(TS5500_PRODUCT_CODE_ADDR, 4, "ts5500"))
 		return -EBUSY;
 
-	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
-	if (tmp != TS5500_PRODUCT_CODE) {
-		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
+	sbc->id = inb(TS5500_PRODUCT_CODE_ADDR);
+	if (sbc->id == TS5500_PRODUCT_CODE) {
+		sbc->name = "TS-5500";
+	} else if (sbc->id == TS5400_PRODUCT_CODE) {
+		sbc->name = "TS-5400";
+	} else {
+		pr_err("ts5500: unknown product code 0x%x\n", sbc->id);
 		ret = -ENODEV;
 		goto cleanup;
 	}
-	sbc->id = tmp;
 
 	tmp = inb(TS5500_SRAM_RS485_ADC_ADDR);
 	sbc->sram = tmp & TS5500_SRAM;
@@ -147,48 +153,52 @@ cleanup:
 	return ret;
 }
 
-static ssize_t ts5500_show_id(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
-	return sprintf(buf, "0x%.2x\n", sbc->id);
+	return sprintf(buf, "%s\n", sbc->name);
 }
+static DEVICE_ATTR_RO(name);
 
-static ssize_t ts5500_show_jumpers(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+static ssize_t id_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
 {
 	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
-	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
+	return sprintf(buf, "0x%.2x\n", sbc->id);
 }
+static DEVICE_ATTR_RO(id);
 
-#define TS5500_SHOW(field)					\
-	static ssize_t ts5500_show_##field(struct device *dev,	\
-			struct device_attribute *attr,		\
-			char *buf)				\
-	{							\
-		struct ts5500_sbc *sbc = dev_get_drvdata(dev);	\
-		return sprintf(buf, "%d\n", sbc->field);	\
-	}
-
-TS5500_SHOW(sram)
-TS5500_SHOW(rs485)
-TS5500_SHOW(adc)
-TS5500_SHOW(ereset)
-TS5500_SHOW(itr)
+static ssize_t jumpers_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
 
-static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
-static DEVICE_ATTR(jumpers, S_IRUGO, ts5500_show_jumpers, NULL);
-static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
-static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
-static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
-static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
-static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
+}
+static DEVICE_ATTR_RO(jumpers);
+
+#define TS5500_ATTR_BOOL(_field)					\
+	static ssize_t _field##_show(struct device *dev,		\
+			struct device_attribute *attr, char *buf)	\
+	{								\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);		\
+									\
+		return sprintf(buf, "%d\n", sbc->_field);		\
+	}								\
+	static DEVICE_ATTR_RO(_field)
+
+TS5500_ATTR_BOOL(sram);
+TS5500_ATTR_BOOL(rs485);
+TS5500_ATTR_BOOL(adc);
+TS5500_ATTR_BOOL(ereset);
+TS5500_ATTR_BOOL(itr);
 
 static struct attribute *ts5500_attributes[] = {
 	&dev_attr_id.attr,
+	&dev_attr_name.attr,
 	&dev_attr_jumpers.attr,
 	&dev_attr_sram.attr,
 	&dev_attr_rs485.attr,
@@ -311,12 +321,14 @@ static int __init ts5500_init(void)
 	if (err)
 		goto error;
 
-	ts5500_dio1_pdev.dev.parent = &pdev->dev;
-	if (platform_device_register(&ts5500_dio1_pdev))
-		dev_warn(&pdev->dev, "DIO1 block registration failed\n");
-	ts5500_dio2_pdev.dev.parent = &pdev->dev;
-	if (platform_device_register(&ts5500_dio2_pdev))
-		dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+	if (sbc->id == TS5500_PRODUCT_CODE) {
+		ts5500_dio1_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_dio1_pdev))
+			dev_warn(&pdev->dev, "DIO1 block registration failed\n");
+		ts5500_dio2_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_dio2_pdev))
+			dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+	}
 
 	if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
 		dev_warn(&pdev->dev, "LED registration failed\n");
