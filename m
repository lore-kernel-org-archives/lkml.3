Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaATOq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:46:28 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55617 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaATOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:46:23 -0500
Date: Mon, 20 Jan 2014 15:46:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/intel-mid changes for v3.14
Message-ID: <20140120144619.GA14469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-intel-mid-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-intel-mid-for-linus

   # HEAD: ee87c751d88f9b03fee7349556817fe80c113b32 x86, intel_mid: Replace memcpy with struct assignment

This tree improves Intel MID (Mobile Internet Device) platform 
support:

  - Merrifield platform support (David Cohen)
  - Clovertrail platform support (Kuppuswamy Sathyanarayanan)
  - Various cleanups and fixes (David Cohen)

 Thanks,

	Ingo

------------------>
David Cohen (6):
      x86, intel-mid: Move Medfield code out of intel-mid.c core file
      x86, intel-mid: Add Merrifield platform support
      x86, intel-mid: Remove deprecated X86_MDFLD and X86_WANT_INTEL_MID configs
      x86, intel-mid: sfi_handle_*_dev() should check for pdata error code
      x86, intel-mid: Check get_gpio_by_name() error code on platform code
      x86, intel-mid: Return proper error code from get_gpio_by_name()

Fengguang Wu (1):
      x86, intel_mid: Replace memcpy with struct assignment

Kuppuswamy Sathyanarayanan (1):
      x86, intel-mid: Add Clovertrail platform support


 arch/x86/Kconfig                                   |  30 ++----
 arch/x86/include/asm/intel-mid.h                   |  48 +++++++++-
 arch/x86/pci/intel_mid_pci.c                       |   6 +-
 arch/x86/platform/intel-mid/Makefile               |   4 +-
 .../intel-mid/device_libs/platform_emc1403.c       |   4 +-
 .../intel-mid/device_libs/platform_gpio_keys.c     |   2 +-
 .../intel-mid/device_libs/platform_lis331.c        |   4 +-
 .../intel-mid/device_libs/platform_max7315.c       |   2 +-
 .../intel-mid/device_libs/platform_mpu3050.c       |   2 +-
 .../intel-mid/device_libs/platform_pmic_gpio.c     |   2 +-
 .../intel-mid/device_libs/platform_tca6416.c       |   4 +-
 arch/x86/platform/intel-mid/intel-mid.c            |  64 +++++++------
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |  19 ++++
 arch/x86/platform/intel-mid/mfld.c                 |  75 +++++++++++++++
 arch/x86/platform/intel-mid/mrfl.c                 | 103 +++++++++++++++++++++
 arch/x86/platform/intel-mid/sfi.c                  |  46 +++++++--
 16 files changed, 340 insertions(+), 75 deletions(-)
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_weak_decls.h
 create mode 100644 arch/x86/platform/intel-mid/mfld.c
 create mode 100644 arch/x86/platform/intel-mid/mrfl.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..edcf80e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -438,42 +438,26 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
-config X86_WANT_INTEL_MID
+config X86_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select to build a kernel capable of supporting Intel MID platform
-	  systems which do not have the PCI legacy interfaces (Moorestown,
-	  Medfield). If you are building for a PC class system say N here.
-
-if X86_WANT_INTEL_MID
-
-config X86_INTEL_MID
-	bool
-
-config X86_MDFLD
-       bool "Medfield MID platform"
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
-	select X86_INTEL_MID
 	select SFI
+	select I2C
 	select DW_APB_TIMER
 	select APB_TIMER
-	select I2C
-	select SPI
 	select INTEL_SCU_IPC
-	select X86_PLATFORM_DEVICES
 	select MFD_INTEL_MSIC
 	---help---
-	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
-	  Internet Device(MID) platform. 
-	  Unlike standard x86 PCs, Medfield does not have many legacy devices
-	  nor standard legacy replacement devices/features. e.g. Medfield does
-	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
+	  Select to build a kernel capable of supporting Intel MID (Mobile
+	  Internet Device) platform systems which do not have the PCI legacy
+	  interfaces. If you are building for a PC class system say N here.
 
-endif
+	  Intel MID platforms are based on an Intel processor and chipset which
+	  consume less power than most of the x86 derivatives.
 
 config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 459769d..e34e097 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -51,10 +51,41 @@ struct devs_id {
 enum intel_mid_cpu_type {
 	/* 1 was Moorestown */
 	INTEL_MID_CPU_CHIP_PENWELL = 2,
+	INTEL_MID_CPU_CHIP_CLOVERVIEW,
+	INTEL_MID_CPU_CHIP_TANGIER,
 };
 
 extern enum intel_mid_cpu_type __intel_mid_cpu_chip;
 
+/**
+ * struct intel_mid_ops - Interface between intel-mid & sub archs
+ * @arch_setup: arch_setup function to re-initialize platform
+ *             structures (x86_init, x86_platform_init)
+ *
+ * This structure can be extended if any new interface is required
+ * between intel-mid & its sub arch files.
+ */
+struct intel_mid_ops {
+	void (*arch_setup)(void);
+};
+
+/* Helper API's for INTEL_MID_OPS_INIT */
+#define DECLARE_INTEL_MID_OPS_INIT(cpuname, cpuid)	\
+				[cpuid] = get_##cpuname##_ops
+
+/* Maximum number of CPU ops */
+#define MAX_CPU_OPS(a) (sizeof(a)/sizeof(void *))
+
+/*
+ * For every new cpu addition, a weak get_<cpuname>_ops() function needs be
+ * declared in arch/x86/platform/intel_mid/intel_mid_weak_decls.h.
+ */
+#define INTEL_MID_OPS_INIT {\
+	DECLARE_INTEL_MID_OPS_INIT(penwell, INTEL_MID_CPU_CHIP_PENWELL), \
+	DECLARE_INTEL_MID_OPS_INIT(cloverview, INTEL_MID_CPU_CHIP_CLOVERVIEW), \
+	DECLARE_INTEL_MID_OPS_INIT(tangier, INTEL_MID_CPU_CHIP_TANGIER) \
+};
+
 #ifdef CONFIG_X86_INTEL_MID
 
 static inline enum intel_mid_cpu_type intel_mid_identify_cpu(void)
@@ -86,8 +117,21 @@ extern enum intel_mid_timer_options intel_mid_timer_options;
  * Penwell uses spread spectrum clock, so the freq number is not exactly
  * the same as reported by MSR based on SDM.
  */
-#define PENWELL_FSB_FREQ_83SKU         83200
-#define PENWELL_FSB_FREQ_100SKU        99840
+#define FSB_FREQ_83SKU	83200
+#define FSB_FREQ_100SKU	99840
+#define FSB_FREQ_133SKU	133000
+
+#define FSB_FREQ_167SKU	167000
+#define FSB_FREQ_200SKU	200000
+#define FSB_FREQ_267SKU	267000
+#define FSB_FREQ_333SKU	333000
+#define FSB_FREQ_400SKU	400000
+
+/* Bus Select SoC Fuse value */
+#define BSEL_SOC_FUSE_MASK	0x7
+#define BSEL_SOC_FUSE_001	0x1 /* FSB 133MHz */
+#define BSEL_SOC_FUSE_101	0x5 /* FSB 100MHz */
+#define BSEL_SOC_FUSE_111	0x7 /* FSB 83MHz */
 
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 51384ca..84b9d67 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -31,6 +31,7 @@
 #include <asm/pci_x86.h>
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
+#include <asm/intel-mid.h>
 
 #define PCIE_CAP_OFFSET	0x100
 
@@ -219,7 +220,10 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	irq_attr.ioapic = mp_find_ioapic(dev->irq);
 	irq_attr.ioapic_pin = dev->irq;
 	irq_attr.trigger = 1; /* level */
-	irq_attr.polarity = 1; /* active low */
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
+		irq_attr.polarity = 0; /* active high */
+	else
+		irq_attr.polarity = 1; /* active low */
 	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
 
 	return 0;
diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index 01cc29e..0a8ee70 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,6 +1,6 @@
-obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o
-obj-$(CONFIG_X86_INTEL_MID) += intel_mid_vrtc.o
+obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o intel_mid_vrtc.o mfld.o mrfl.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID) += early_printk_intel_mid.o
+
 # SFI specific code
 ifdef CONFIG_X86_INTEL_MID
 obj-$(CONFIG_SFI) += sfi.o device_libs/
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
index 0d942c1..69a7836 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -22,7 +22,9 @@ static void __init *emc1403_platform_data(void *info)
 	int intr = get_gpio_by_name("thermal_int");
 	int intr2nd = get_gpio_by_name("thermal_alert");
 
-	if (intr == -1 || intr2nd == -1)
+	if (intr < 0)
+		return NULL;
+	if (intr2nd < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
index a013a48..dccae6b 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
@@ -66,7 +66,7 @@ static int __init pb_keys_init(void)
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
 		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
 					gb[i].gpio);
-		if (gb[i].gpio == -1)
+		if (gb[i].gpio < 0)
 			continue;
 
 		if (i != good)
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
index 15278c1..54226de 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -21,7 +21,9 @@ static void __init *lis331dl_platform_data(void *info)
 	int intr = get_gpio_by_name("accel_int");
 	int intr2nd = get_gpio_by_name("accel_2");
 
-	if (intr == -1 || intr2nd == -1)
+	if (intr < 0)
+		return NULL;
+	if (intr2nd < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
index 94ade10..2c8acbc 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -48,7 +48,7 @@ static void __init *max7315_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		return NULL;
 	max7315->gpio_base = gpio_base;
 	if (intr != -1) {
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
index dd28d63..cfe9a47 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -19,7 +19,7 @@ static void *mpu3050_platform_data(void *info)
 	struct i2c_board_info *i2c_info = info;
 	int intr = get_gpio_by_name("mpu3050_int");
 
-	if (intr == -1)
+	if (intr < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
index d87182a..65c2a9a 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
@@ -26,7 +26,7 @@ static void __init *pmic_gpio_platform_data(void *info)
 	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
 	int gpio_base = get_gpio_by_name("pmic_gpio_base");
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		gpio_base = 64;
 	pmic_gpio_pdata.gpio_base = gpio_base;
 	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
index 22881c9..33be0b3 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -34,10 +34,10 @@ static void *tca6416_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		return NULL;
 	tca6416.gpio_base = gpio_base;
-	if (intr != -1) {
+	if (intr >= 0) {
 		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
 	} else {
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index f90e290..1bbedc4 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -35,6 +35,8 @@
 #include <asm/apb_timer.h>
 #include <asm/reboot.h>
 
+#include "intel_mid_weak_decls.h"
+
 /*
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
  * cmdline option x86_intel_mid_timer can be used to override the configuration
@@ -58,12 +60,16 @@
 
 enum intel_mid_timer_options intel_mid_timer_options;
 
+/* intel_mid_ops to store sub arch ops */
+struct intel_mid_ops *intel_mid_ops;
+/* getter function for sub arch ops*/
+static void *(*get_intel_mid_ops[])(void) = INTEL_MID_OPS_INIT;
 enum intel_mid_cpu_type __intel_mid_cpu_chip;
 EXPORT_SYMBOL_GPL(__intel_mid_cpu_chip);
 
 static void intel_mid_power_off(void)
 {
-}
+};
 
 static void intel_mid_reboot(void)
 {
@@ -72,32 +78,6 @@ static void intel_mid_reboot(void)
 
 static unsigned long __init intel_mid_calibrate_tsc(void)
 {
-	unsigned long fast_calibrate;
-	u32 lo, hi, ratio, fsb;
-
-	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-	pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
-	ratio = (hi >> 8) & 0x1f;
-	pr_debug("ratio is %d\n", ratio);
-	if (!ratio) {
-		pr_err("read a zero ratio, should be incorrect!\n");
-		pr_err("force tsc ratio to 16 ...\n");
-		ratio = 16;
-	}
-	rdmsr(MSR_FSB_FREQ, lo, hi);
-	if ((lo & 0x7) == 0x7)
-		fsb = PENWELL_FSB_FREQ_83SKU;
-	else
-		fsb = PENWELL_FSB_FREQ_100SKU;
-	fast_calibrate = ratio * fsb;
-	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
-	lapic_timer_frequency = fsb * 1000 / HZ;
-	/* mark tsc clocksource as reliable */
-	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
-
-	if (fast_calibrate)
-		return fast_calibrate;
-
 	return 0;
 }
 
@@ -125,13 +105,37 @@ static void __init intel_mid_time_init(void)
 
 static void intel_mid_arch_setup(void)
 {
-	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
-		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
-	else {
+	if (boot_cpu_data.x86 != 6) {
 		pr_err("Unknown Intel MID CPU (%d:%d), default to Penwell\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
 		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
+		goto out;
 	}
+
+	switch (boot_cpu_data.x86_model) {
+	case 0x35:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_CLOVERVIEW;
+		break;
+	case 0x3C:
+	case 0x4A:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_TANGIER;
+		break;
+	case 0x27:
+	default:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
+		break;
+	}
+
+	if (__intel_mid_cpu_chip < MAX_CPU_OPS(get_intel_mid_ops))
+		intel_mid_ops = get_intel_mid_ops[__intel_mid_cpu_chip]();
+	else {
+		intel_mid_ops = get_intel_mid_ops[INTEL_MID_CPU_CHIP_PENWELL]();
+		pr_info("ARCH: Uknown SoC, assuming PENWELL!\n");
+	}
+
+out:
+	if (intel_mid_ops->arch_setup)
+		intel_mid_ops->arch_setup();
 }
 
 /* MID systems don't have i8042 controller */
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
new file mode 100644
index 0000000..a537ffc
--- /dev/null
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -0,0 +1,19 @@
+/*
+ * intel_mid_weak_decls.h: Weak declarations of intel-mid.c
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
+/* __attribute__((weak)) makes these declarations overridable */
+/* For every CPU addition a new get_<cpuname>_ops interface needs
+ * to be added.
+ */
+extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
+extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
+extern void * __init get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
new file mode 100644
index 0000000..4f7884e
--- /dev/null
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -0,0 +1,75 @@
+/*
+ * mfld.c: Intel Medfield platform setup code
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+
+#include <asm/apic.h>
+#include <asm/intel-mid.h>
+#include <asm/intel_mid_vrtc.h>
+
+#include "intel_mid_weak_decls.h"
+
+static void penwell_arch_setup(void);
+/* penwell arch ops */
+static struct intel_mid_ops penwell_ops = {
+	.arch_setup = penwell_arch_setup,
+};
+
+static void mfld_power_off(void)
+{
+}
+
+static unsigned long __init mfld_calibrate_tsc(void)
+{
+	unsigned long fast_calibrate;
+	u32 lo, hi, ratio, fsb;
+
+	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+	pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
+	ratio = (hi >> 8) & 0x1f;
+	pr_debug("ratio is %d\n", ratio);
+	if (!ratio) {
+		pr_err("read a zero ratio, should be incorrect!\n");
+		pr_err("force tsc ratio to 16 ...\n");
+		ratio = 16;
+	}
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	if ((lo & 0x7) == 0x7)
+		fsb = FSB_FREQ_83SKU;
+	else
+		fsb = FSB_FREQ_100SKU;
+	fast_calibrate = ratio * fsb;
+	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
+	lapic_timer_frequency = fsb * 1000 / HZ;
+	/* mark tsc clocksource as reliable */
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
+
+static void __init penwell_arch_setup()
+{
+	x86_platform.calibrate_tsc = mfld_calibrate_tsc;
+	pm_power_off = mfld_power_off;
+}
+
+void * __cpuinit get_penwell_ops()
+{
+	return &penwell_ops;
+}
+
+void * __cpuinit get_cloverview_ops()
+{
+	return &penwell_ops;
+}
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
new file mode 100644
index 0000000..09d1015
--- /dev/null
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -0,0 +1,103 @@
+/*
+ * mrfl.c: Intel Merrifield platform specific setup code
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+
+#include <asm/apic.h>
+#include <asm/intel-mid.h>
+
+#include "intel_mid_weak_decls.h"
+
+static unsigned long __init tangier_calibrate_tsc(void)
+{
+	unsigned long fast_calibrate;
+	u32 lo, hi, ratio, fsb, bus_freq;
+
+	/* *********************** */
+	/* Compute TSC:Ratio * FSB */
+	/* *********************** */
+
+	/* Compute Ratio */
+	rdmsr(MSR_PLATFORM_INFO, lo, hi);
+	pr_debug("IA32 PLATFORM_INFO is 0x%x : %x\n", hi, lo);
+
+	ratio = (lo >> 8) & 0xFF;
+	pr_debug("ratio is %d\n", ratio);
+	if (!ratio) {
+		pr_err("Read a zero ratio, force tsc ratio to 4 ...\n");
+		ratio = 4;
+	}
+
+	/* Compute FSB */
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	pr_debug("Actual FSB frequency detected by SOC 0x%x : %x\n",
+			hi, lo);
+
+	bus_freq = lo & 0x7;
+	pr_debug("bus_freq = 0x%x\n", bus_freq);
+
+	if (bus_freq == 0)
+		fsb = FSB_FREQ_100SKU;
+	else if (bus_freq == 1)
+		fsb = FSB_FREQ_100SKU;
+	else if (bus_freq == 2)
+		fsb = FSB_FREQ_133SKU;
+	else if (bus_freq == 3)
+		fsb = FSB_FREQ_167SKU;
+	else if (bus_freq == 4)
+		fsb = FSB_FREQ_83SKU;
+	else if (bus_freq == 5)
+		fsb = FSB_FREQ_400SKU;
+	else if (bus_freq == 6)
+		fsb = FSB_FREQ_267SKU;
+	else if (bus_freq == 7)
+		fsb = FSB_FREQ_333SKU;
+	else {
+		BUG();
+		pr_err("Invalid bus_freq! Setting to minimal value!\n");
+		fsb = FSB_FREQ_100SKU;
+	}
+
+	/* TSC = FSB Freq * Resolved HFM Ratio */
+	fast_calibrate = ratio * fsb;
+	pr_debug("calculate tangier tsc %lu KHz\n", fast_calibrate);
+
+	/* ************************************ */
+	/* Calculate Local APIC Timer Frequency */
+	/* ************************************ */
+	lapic_timer_frequency = (fsb * 1000) / HZ;
+
+	pr_debug("Setting lapic_timer_frequency = %d\n",
+			lapic_timer_frequency);
+
+	/* mark tsc clocksource as reliable */
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
+
+static void __init tangier_arch_setup(void)
+{
+	x86_platform.calibrate_tsc = tangier_calibrate_tsc;
+}
+
+/* tangier arch ops */
+static struct intel_mid_ops tangier_ops = {
+	.arch_setup = tangier_arch_setup,
+};
+
+void * __cpuinit get_tangier_ops()
+{
+	return &tangier_ops;
+}
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index c84c1ca..994c40b 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -224,7 +224,7 @@ int get_gpio_by_name(const char *name)
 		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
 			return pentry->pin_no;
 	}
-	return -1;
+	return -EINVAL;
 }
 
 void __init intel_scu_device_register(struct platform_device *pdev)
@@ -250,7 +250,7 @@ static void __init intel_scu_spi_device_register(struct spi_board_info *sdev)
 			sdev->modalias);
 		return;
 	}
-	memcpy(new_dev, sdev, sizeof(*sdev));
+	*new_dev = *sdev;
 
 	spi_devs[spi_next_dev++] = new_dev;
 }
@@ -271,7 +271,7 @@ static void __init intel_scu_i2c_device_register(int bus,
 			idev->type);
 		return;
 	}
-	memcpy(new_dev, idev, sizeof(*idev));
+	*new_dev = *idev;
 
 	i2c_bus[i2c_next_dev] = bus;
 	i2c_devs[i2c_next_dev++] = new_dev;
@@ -337,6 +337,8 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
 		pentry->name, pentry->irq);
 	pdata = intel_mid_sfi_get_pdata(dev, pentry);
+	if (IS_ERR(pdata))
+		return;
 
 	pdev = platform_device_alloc(pentry->name, 0);
 	if (pdev == NULL) {
@@ -370,6 +372,8 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
 		spi_info.chip_select);
 
 	pdata = intel_mid_sfi_get_pdata(dev, &spi_info);
+	if (IS_ERR(pdata))
+		return;
 
 	spi_info.platform_data = pdata;
 	if (dev->delay)
@@ -395,6 +399,8 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_info.addr);
 	pdata = intel_mid_sfi_get_pdata(dev, &i2c_info);
 	i2c_info.platform_data = pdata;
+	if (IS_ERR(pdata))
+		return;
 
 	if (dev->delay)
 		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
@@ -443,13 +449,35 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			 * so we have to enable them one by one here
 			 */
 			ioapic = mp_find_ioapic(irq);
-			irq_attr.ioapic = ioapic;
-			irq_attr.ioapic_pin = irq;
-			irq_attr.trigger = 1;
-			irq_attr.polarity = 1;
-			io_apic_set_pci_routing(NULL, irq, &irq_attr);
-		} else
+			if (ioapic >= 0) {
+				irq_attr.ioapic = ioapic;
+				irq_attr.ioapic_pin = irq;
+				irq_attr.trigger = 1;
+				if (intel_mid_identify_cpu() ==
+						INTEL_MID_CPU_CHIP_TANGIER) {
+					if (!strncmp(pentry->name,
+							"r69001-ts-i2c", 13))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (!strncmp(pentry->name,
+							"synaptics_3202", 14))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (irq == 41)
+						/* fast_int_1 */
+						irq_attr.polarity = 1;
+					else
+						/* active high */
+						irq_attr.polarity = 0;
+				} else {
+					/* PNW and CLV go with active low */
+					irq_attr.polarity = 1;
+				}
+				io_apic_set_pci_routing(NULL, irq, &irq_attr);
+			}
+		} else {
 			irq = 0; /* No irq */
+		}
 
 		dev = get_device_id(pentry->type, pentry->name);
 
