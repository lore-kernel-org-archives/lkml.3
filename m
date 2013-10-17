Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3JQWb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:31:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:23818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab3JQWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="420869480"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v10 12/12] intel_mid: move board related codes to their own platform_<device>.* files
Date: Thu, 17 Oct 2013 15:35:36 -0700
Message-Id: <1382049336-21316-13-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Intel rolling out more SoC's after Moorestown, we need to
re-structure the code in a way that is backward compatible and easy to
expand. This patch implements a flexible way to support multiple boards
and devices.

This patch does not add any new functional support. It just refactors
the existing code to increase the modularity and decrease the code
duplication for supporting multiple soc's and boards.

Currently intel-mid.c has both board and soc related code in one file.
This patch moves the board related code to new files and let linker
script to create SFI devite table following this:

1. Move the SFI device specific code to
   arch/x86/platform/intel-mid/device-libs/platform_<device>.*
   A new device file is added for every supported device. This code will
   get conditionally compiled by using corresponding device driver
   CONFIG option.

2. Move the device_ids location to .x86_intel_mid_dev.init section by
   using new sfi_device() macro.

This patch was based on previous code from Sathyanarayanan Kuppuswamy.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h                   |  16 +
 arch/x86/platform/intel-mid/Makefile               |   8 +-
 arch/x86/platform/intel-mid/device_libs/Makefile   |  22 ++
 .../intel-mid/device_libs/platform_bma023.c        |  20 +
 .../intel-mid/device_libs/platform_emc1403.c       |  41 ++
 .../intel-mid/device_libs/platform_gpio_keys.c     |  83 ++++
 .../platform/intel-mid/device_libs/platform_ipc.c  |  68 ++++
 .../platform/intel-mid/device_libs/platform_ipc.h  |  17 +
 .../intel-mid/device_libs/platform_lis331.c        |  39 ++
 .../intel-mid/device_libs/platform_max3111.c       |  35 ++
 .../intel-mid/device_libs/platform_max7315.c       |  79 ++++
 .../intel-mid/device_libs/platform_mpu3050.c       |  36 ++
 .../platform/intel-mid/device_libs/platform_msic.c |  87 +++++
 .../platform/intel-mid/device_libs/platform_msic.h |  19 +
 .../intel-mid/device_libs/platform_msic_audio.c    |  47 +++
 .../intel-mid/device_libs/platform_msic_battery.c  |  37 ++
 .../intel-mid/device_libs/platform_msic_gpio.c     |  48 +++
 .../intel-mid/device_libs/platform_msic_ocd.c      |  49 +++
 .../device_libs/platform_msic_power_btn.c          |  36 ++
 .../intel-mid/device_libs/platform_msic_thermal.c  |  37 ++
 .../intel-mid/device_libs/platform_pmic_gpio.c     |  54 +++
 .../intel-mid/device_libs/platform_tc35876x.c      |  36 ++
 .../intel-mid/device_libs/platform_tca6416.c       |  57 +++
 arch/x86/platform/intel-mid/intel-mid.c            | 419 ---------------------
 arch/x86/platform/intel-mid/sfi.c                  |  14 +-
 include/linux/sfi.h                                |   3 +
 26 files changed, 978 insertions(+), 429 deletions(-)
 create mode 100644 arch/x86/platform/intel-mid/device_libs/Makefile
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_bma023.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_lis331.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max3111.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max7315.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 3b0e7a7..459769d 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -12,8 +12,11 @@
 #define _ASM_X86_INTEL_MID_H
 
 #include <linux/sfi.h>
+#include <linux/platform_device.h>
 
 extern int intel_mid_pci_init(void);
+extern int get_gpio_by_name(const char *name);
+extern void intel_scu_device_register(struct platform_device *pdev);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
 extern int __init sfi_parse_mtmr(struct sfi_table_header *table);
 extern int sfi_mrtc_num;
@@ -34,6 +37,10 @@ struct devs_id {
 				struct devs_id *dev);
 };
 
+#define sfi_device(i)   \
+	static const struct devs_id *const __intel_mid_sfi_##i##_dev __used \
+	__attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
+
 /*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
  * one. Other than that it also added always-on and constant tsc and lapic
@@ -55,9 +62,15 @@ static inline enum intel_mid_cpu_type intel_mid_identify_cpu(void)
 	return __intel_mid_cpu_chip;
 }
 
+static inline bool intel_mid_has_msic(void)
+{
+	return (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_PENWELL);
+}
+
 #else /* !CONFIG_X86_INTEL_MID */
 
 #define intel_mid_identify_cpu()    (0)
+#define intel_mid_has_msic()    (0)
 
 #endif /* !CONFIG_X86_INTEL_MID */
 
@@ -94,4 +107,7 @@ extern void intel_scu_devices_destroy(void);
 
 extern void intel_mid_rtc_init(void);
 
+/* the offset for the mapping of global gpio pin to irq */
+#define INTEL_MID_IRQ_OFFSET 0x100
+
 #endif /* _ASM_X86_INTEL_MID_H */
diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index b11e5b2..01cc29e 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,5 +1,7 @@
 obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o
-obj-$(CONFIG_X86_INTEL_MID)	+= intel_mid_vrtc.o
-obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_intel_mid.o
+obj-$(CONFIG_X86_INTEL_MID) += intel_mid_vrtc.o
+obj-$(CONFIG_EARLY_PRINTK_INTEL_MID) += early_printk_intel_mid.o
 # SFI specific code
-obj-$(CONFIG_SFI) += sfi.o
+ifdef CONFIG_X86_INTEL_MID
+obj-$(CONFIG_SFI) += sfi.o device_libs/
+endif
diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
new file mode 100644
index 0000000..097e7a7
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/Makefile
@@ -0,0 +1,22 @@
+# IPC Devices
+obj-y += platform_ipc.o
+obj-$(subst m,y,$(CONFIG_MFD_INTEL_MSIC)) += platform_msic.o
+obj-$(subst m,y,$(CONFIG_SND_MFLD_MACHINE)) += platform_msic_audio.o
+obj-$(subst m,y,$(CONFIG_GPIO_MSIC)) += platform_msic_gpio.o
+obj-$(subst m,y,$(CONFIG_MFD_INTEL_MSIC)) += platform_msic_ocd.o
+obj-$(subst m,y,$(CONFIG_MFD_INTEL_MSIC)) += platform_msic_battery.o
+obj-$(subst m,y,$(CONFIG_INTEL_MID_POWER_BUTTON)) += platform_msic_power_btn.o
+obj-$(subst m,y,$(CONFIG_GPIO_INTEL_PMIC)) += platform_pmic_gpio.o
+obj-$(subst m,y,$(CONFIG_INTEL_MFLD_THERMAL)) += platform_msic_thermal.o
+# I2C Devices
+obj-$(subst m,y,$(CONFIG_SENSORS_EMC1403)) += platform_emc1403.o
+obj-$(subst m,y,$(CONFIG_SENSORS_LIS3LV02D)) += platform_lis331.o
+obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_max7315.o
+obj-$(subst m,y,$(CONFIG_INPUT_MPU3050)) += platform_mpu3050.o
+obj-$(subst m,y,$(CONFIG_INPUT_BMA150)) += platform_bma023.o
+obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_tca6416.o
+obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
+# SPI Devices
+obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
+# MISC Devices
+obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_bma023.c b/arch/x86/platform/intel-mid/device_libs/platform_bma023.c
new file mode 100644
index 0000000..0ae7f2a
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_bma023.c
@@ -0,0 +1,20 @@
+/*
+ * platform_bma023.c: bma023 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <asm/intel-mid.h>
+
+static const struct devs_id bma023_dev_id __initconst = {
+	.name = "bma023",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+};
+
+sfi_device(bma023_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
new file mode 100644
index 0000000..0d942c1
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -0,0 +1,41 @@
+/*
+ * platform_emc1403.c: emc1403 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <asm/intel-mid.h>
+
+static void __init *emc1403_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("thermal_int");
+	int intr2nd = get_gpio_by_name("thermal_alert");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static const struct devs_id emc1403_dev_id __initconst = {
+	.name = "emc1403",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+	.get_platform_data = &emc1403_platform_data,
+};
+
+sfi_device(emc1403_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
new file mode 100644
index 0000000..a013a48
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
@@ -0,0 +1,83 @@
+/*
+ * platform_gpio_keys.c: gpio_keys platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/input.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/platform_device.h>
+#include <asm/intel-mid.h>
+
+#define DEVICE_NAME "gpio-keys"
+
+/*
+ * we will search these buttons in SFI GPIO table (by name)
+ * and register them dynamically. Please add all possible
+ * buttons here, we will shrink them if no GPIO found.
+ */
+static struct gpio_keys_button gpio_button[] = {
+	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
+	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
+	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
+	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
+	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
+	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
+	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
+	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
+};
+
+static struct gpio_keys_platform_data gpio_keys = {
+	.buttons	= gpio_button,
+	.rep		= 1,
+	.nbuttons	= -1, /* will fill it after search */
+};
+
+static struct platform_device pb_device = {
+	.name		= DEVICE_NAME,
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &gpio_keys,
+	},
+};
+
+/*
+ * Shrink the non-existent buttons, register the gpio button
+ * device if there is some
+ */
+static int __init pb_keys_init(void)
+{
+	struct gpio_keys_button *gb = gpio_button;
+	int i, num, good = 0;
+
+	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
+	for (i = 0; i < num; i++) {
+		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
+					gb[i].gpio);
+		if (gb[i].gpio == -1)
+			continue;
+
+		if (i != good)
+			gb[good] = gb[i];
+		good++;
+	}
+
+	if (good) {
+		gpio_keys.nbuttons = good;
+		return platform_device_register(&pb_device);
+	}
+	return 0;
+}
+late_initcall(pb_keys_init);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.c b/arch/x86/platform/intel-mid/device_libs/platform_ipc.c
new file mode 100644
index 0000000..a84b73d
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.c
@@ -0,0 +1,68 @@
+/*
+ * platform_ipc.c: IPC platform library file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/sfi.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+#include "platform_ipc.h"
+
+void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev)
+{
+	struct platform_device *pdev;
+	void *pdata = NULL;
+	static struct resource res __initdata = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+
+	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
+		pentry->name, pentry->irq);
+
+	/*
+	 * We need to call platform init of IPC devices to fill misc_pdata
+	 * structure. It will be used in msic_init for initialization.
+	 */
+	if (dev != NULL)
+		pdata = dev->get_platform_data(pentry);
+
+	/*
+	 * On Medfield the platform device creation is handled by the MSIC
+	 * MFD driver so we don't need to do it here.
+	 */
+	if (intel_mid_has_msic())
+		return;
+
+	pdev = platform_device_alloc(pentry->name, 0);
+	if (pdev == NULL) {
+		pr_err("out of memory for SFI platform device '%s'.\n",
+			pentry->name);
+		return;
+	}
+	res.start = pentry->irq;
+	platform_device_add_resources(pdev, &res, 1);
+
+	pdev->dev.platform_data = pdata;
+	intel_scu_device_register(pdev);
+}
+
+static const struct devs_id pmic_audio_dev_id __initconst = {
+	.name = "pmic_audio",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(pmic_audio_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
new file mode 100644
index 0000000..8f568dd
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
@@ -0,0 +1,17 @@
+/*
+ * platform_ipc.h: IPC platform library header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_IPC_H_
+#define _PLATFORM_IPC_H_
+
+extern void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+			struct devs_id *dev) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
new file mode 100644
index 0000000..15278c1
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -0,0 +1,39 @@
+/*
+ * platform_lis331.c:  lis331 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+
+static void __init *lis331dl_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("accel_int");
+	int intr2nd = get_gpio_by_name("accel_2");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static const struct devs_id lis331dl_dev_id __initconst = {
+	.name = "i2c_accel",
+	.type = SFI_DEV_TYPE_I2C,
+	.get_platform_data = &lis331dl_platform_data,
+};
+
+sfi_device(lis331dl_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
new file mode 100644
index 0000000..afd1df9
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
@@ -0,0 +1,35 @@
+/*
+ * platform_max3111.c: max3111 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <asm/intel-mid.h>
+
+static void __init *max3111_platform_data(void *info)
+{
+	struct spi_board_info *spi_info = info;
+	int intr = get_gpio_by_name("max3111_int");
+
+	spi_info->mode = SPI_MODE_0;
+	if (intr == -1)
+		return NULL;
+	spi_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	return NULL;
+}
+
+static const struct devs_id max3111_dev_id __initconst = {
+	.name = "spi_max3111",
+	.type = SFI_DEV_TYPE_SPI,
+	.get_platform_data = &max3111_platform_data,
+};
+
+sfi_device(max3111_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
new file mode 100644
index 0000000..94ade10
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -0,0 +1,79 @@
+/*
+ * platform_max7315.c: max7315 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/platform_data/pca953x.h>
+#include <asm/intel-mid.h>
+
+#define MAX7315_NUM 2
+
+static void __init *max7315_platform_data(void *info)
+{
+	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
+	static int nr;
+	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	if (nr == MAX7315_NUM) {
+		pr_err("too many max7315s, we only support %d\n",
+				MAX7315_NUM);
+		return NULL;
+	}
+	/* we have several max7315 on the board, we only need load several
+	 * instances of the same pca953x driver to cover them
+	 */
+	strcpy(i2c_info->type, "max7315");
+	if (nr++) {
+		sprintf(base_pin_name, "max7315_%d_base", nr);
+		sprintf(intr_pin_name, "max7315_%d_int", nr);
+	} else {
+		strcpy(base_pin_name, "max7315_base");
+		strcpy(intr_pin_name, "max7315_int");
+	}
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	max7315->gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+		max7315->irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		max7315->irq_base = -1;
+	}
+	return max7315;
+}
+
+static const struct devs_id max7315_dev_id __initconst = {
+	.name = "i2c_max7315",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+	.get_platform_data = &max7315_platform_data,
+};
+
+static const struct devs_id max7315_2_dev_id __initconst = {
+	.name = "i2c_max7315_2",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+	.get_platform_data = &max7315_platform_data,
+};
+
+sfi_device(max7315_dev_id);
+sfi_device(max7315_2_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
new file mode 100644
index 0000000..dd28d63
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -0,0 +1,36 @@
+/*
+ * platform_mpu3050.c: mpu3050 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <asm/intel-mid.h>
+
+static void *mpu3050_platform_data(void *info)
+{
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("mpu3050_int");
+
+	if (intr == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	return NULL;
+}
+
+static const struct devs_id mpu3050_dev_id __initconst = {
+	.name = "mpu3050",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+	.get_platform_data = &mpu3050_platform_data,
+};
+
+sfi_device(mpu3050_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.c b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
new file mode 100644
index 0000000..9f4a775
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
@@ -0,0 +1,87 @@
+/*
+ * platform_msic.c: MSIC platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+
+struct intel_msic_platform_data msic_pdata;
+
+static struct resource msic_resources[] = {
+	{
+		.start	= INTEL_MSIC_IRQ_PHYS_BASE,
+		.end	= INTEL_MSIC_IRQ_PHYS_BASE + 64 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device msic_device = {
+	.name		= "intel_msic",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &msic_pdata,
+	},
+	.num_resources	= ARRAY_SIZE(msic_resources),
+	.resource	= msic_resources,
+};
+
+static int msic_scu_status_change(struct notifier_block *nb,
+				  unsigned long code, void *data)
+{
+	if (code == SCU_DOWN) {
+		platform_device_unregister(&msic_device);
+		return 0;
+	}
+
+	return platform_device_register(&msic_device);
+}
+
+static int __init msic_init(void)
+{
+	static struct notifier_block msic_scu_notifier = {
+		.notifier_call	= msic_scu_status_change,
+	};
+
+	/*
+	 * We need to be sure that the SCU IPC is ready before MSIC device
+	 * can be registered.
+	 */
+	if (intel_mid_has_msic())
+		intel_scu_notifier_add(&msic_scu_notifier);
+
+	return 0;
+}
+arch_initcall(msic_init);
+
+/*
+ * msic_generic_platform_data - sets generic platform data for the block
+ * @info: pointer to the SFI device table entry for this block
+ * @block: MSIC block
+ *
+ * Function sets IRQ number from the SFI table entry for given device to
+ * the MSIC platform data.
+ */
+void *msic_generic_platform_data(void *info, enum intel_msic_block block)
+{
+	struct sfi_device_table_entry *entry = info;
+
+	BUG_ON(block < 0 || block >= INTEL_MSIC_BLOCK_LAST);
+	msic_pdata.irq[block] = entry->irq;
+
+	return NULL;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.h b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
new file mode 100644
index 0000000..917eb56
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
@@ -0,0 +1,19 @@
+/*
+ * platform_msic.h: MSIC platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_H_
+#define _PLATFORM_MSIC_H_
+
+extern struct intel_msic_platform_data msic_pdata;
+
+extern void *msic_generic_platform_data(void *info,
+			enum intel_msic_block block) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
new file mode 100644
index 0000000..2962939
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
@@ -0,0 +1,47 @@
+/*
+ * platform_msic_audio.c: MSIC audio platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void *msic_audio_platform_data(void *info)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("sst-platform", -1, NULL, 0);
+
+	if (IS_ERR(pdev)) {
+		pr_err("failed to create audio platform device\n");
+		return NULL;
+	}
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_AUDIO);
+}
+
+static const struct devs_id msic_audio_dev_id __initconst = {
+	.name = "msic_audio",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_audio_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_audio_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
new file mode 100644
index 0000000..f446c33
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
@@ -0,0 +1,37 @@
+/*
+ * platform_msic_battery.c: MSIC battery platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void __init *msic_battery_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
+}
+
+static const struct devs_id msic_battery_dev_id __initconst = {
+	.name = "msic_battery",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_battery_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_battery_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
new file mode 100644
index 0000000..2a4f7b1
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
@@ -0,0 +1,48 @@
+/*
+ * platform_msic_gpio.c: MSIC GPIO platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void __init *msic_gpio_platform_data(void *info)
+{
+	static struct intel_msic_gpio_pdata msic_gpio_pdata;
+
+	int gpio = get_gpio_by_name("msic_gpio_base");
+
+	if (gpio < 0)
+		return NULL;
+
+	msic_gpio_pdata.gpio_base = gpio;
+	msic_pdata.gpio = &msic_gpio_pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_GPIO);
+}
+
+static const struct devs_id msic_gpio_dev_id __initconst = {
+	.name = "msic_gpio",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_gpio_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_gpio_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
new file mode 100644
index 0000000..6497111
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
@@ -0,0 +1,49 @@
+/*
+ * platform_msic_ocd.c: MSIC OCD platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void __init *msic_ocd_platform_data(void *info)
+{
+	static struct intel_msic_ocd_pdata msic_ocd_pdata;
+	int gpio;
+
+	gpio = get_gpio_by_name("ocd_gpio");
+
+	if (gpio < 0)
+		return NULL;
+
+	msic_ocd_pdata.gpio = gpio;
+	msic_pdata.ocd = &msic_ocd_pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
+}
+
+static const struct devs_id msic_ocd_dev_id __initconst = {
+	.name = "msic_ocd",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_ocd_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_ocd_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
new file mode 100644
index 0000000..83a3459
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
@@ -0,0 +1,36 @@
+/*
+ * platform_msic_power_btn.c: MSIC power btn platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void __init *msic_power_btn_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_POWER_BTN);
+}
+
+static const struct devs_id msic_power_btn_dev_id __initconst = {
+	.name = "msic_power_btn",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_power_btn_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_power_btn_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
new file mode 100644
index 0000000..a351878
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
@@ -0,0 +1,37 @@
+/*
+ * platform_msic_thermal.c: msic_thermal platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/input.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+
+#include "platform_msic.h"
+#include "platform_ipc.h"
+
+static void __init *msic_thermal_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
+}
+
+static const struct devs_id msic_thermal_dev_id __initconst = {
+	.name = "msic_thermal",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &msic_thermal_platform_data,
+	.device_handler = &ipc_device_handler,
+};
+
+sfi_device(msic_thermal_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
new file mode 100644
index 0000000..d87182a
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
@@ -0,0 +1,54 @@
+/*
+ * platform_pmic_gpio.c: PMIC GPIO platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/intel_pmic_gpio.h>
+#include <asm/intel-mid.h>
+
+#include "platform_ipc.h"
+
+static void __init *pmic_gpio_platform_data(void *info)
+{
+	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
+	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+
+	if (gpio_base == -1)
+		gpio_base = 64;
+	pmic_gpio_pdata.gpio_base = gpio_base;
+	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	pmic_gpio_pdata.gpiointr = 0xffffeff8;
+
+	return &pmic_gpio_pdata;
+}
+
+static const struct devs_id pmic_gpio_spi_dev_id __initconst = {
+	.name = "pmic_gpio",
+	.type = SFI_DEV_TYPE_SPI,
+	.delay = 1,
+	.get_platform_data = &pmic_gpio_platform_data,
+};
+
+static const struct devs_id pmic_gpio_ipc_dev_id __initconst = {
+	.name = "pmic_gpio",
+	.type = SFI_DEV_TYPE_IPC,
+	.delay = 1,
+	.get_platform_data = &pmic_gpio_platform_data,
+	.device_handler = &ipc_device_handler
+};
+
+sfi_device(pmic_gpio_spi_dev_id);
+sfi_device(pmic_gpio_ipc_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
new file mode 100644
index 0000000..740fc75
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
@@ -0,0 +1,36 @@
+/*
+ * platform_tc35876x.c: tc35876x platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/i2c/tc35876x.h>
+#include <asm/intel-mid.h>
+
+/*tc35876x DSI_LVDS bridge chip and panel platform data*/
+static void *tc35876x_platform_data(void *data)
+{
+	static struct tc35876x_platform_data pdata;
+
+	/* gpio pins set to -1 will not be used by the driver */
+	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
+	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
+	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+
+	return &pdata;
+}
+
+static const struct devs_id tc35876x_dev_id __initconst = {
+	.name = "i2c_disp_brig",
+	.type = SFI_DEV_TYPE_I2C,
+	.get_platform_data = &tc35876x_platform_data,
+};
+
+sfi_device(tc35876x_dev_id);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
new file mode 100644
index 0000000..22881c9
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -0,0 +1,57 @@
+/*
+ * platform_tca6416.c: tca6416 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/platform_data/pca953x.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+
+#define TCA6416_NAME	"tca6416"
+#define TCA6416_BASE	"tca6416_base"
+#define TCA6416_INTR	"tca6416_int"
+
+static void *tca6416_platform_data(void *info)
+{
+	static struct pca953x_platform_data tca6416;
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	strcpy(i2c_info->type, TCA6416_NAME);
+	strcpy(base_pin_name, TCA6416_BASE);
+	strcpy(intr_pin_name, TCA6416_INTR);
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	tca6416.gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		tca6416.irq_base = -1;
+	}
+	return &tca6416;
+}
+
+static const struct devs_id tca6416_dev_id __initconst = {
+	.name = "tca6416",
+	.type = SFI_DEV_TYPE_I2C,
+	.delay = 1,
+	.get_platform_data = &tca6416_platform_data,
+};
+
+sfi_device(tca6416_dev_id);
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 4091569..523a1c8 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -61,8 +61,6 @@ enum intel_mid_timer_options intel_mid_timer_options;
 enum intel_mid_cpu_type __intel_mid_cpu_chip;
 EXPORT_SYMBOL_GPL(__intel_mid_cpu_chip);
 
-static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-			struct devs_id *dev);
 static void intel_mid_power_off(void)
 {
 }
@@ -213,420 +211,3 @@ static inline int __init setup_x86_intel_mid_timer(char *arg)
 }
 __setup("x86_intel_mid_timer=", setup_x86_intel_mid_timer);
 
-/* the offset for the mapping of global gpio pin to irq */
-#define INTEL_MID_IRQ_OFFSET 0x100
-
-static void __init *pmic_gpio_platform_data(void *info)
-{
-	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
-	int gpio_base = get_gpio_by_name("pmic_gpio_base");
-
-	if (gpio_base == -1)
-		gpio_base = 64;
-	pmic_gpio_pdata.gpio_base = gpio_base;
-	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	pmic_gpio_pdata.gpiointr = 0xffffeff8;
-
-	return &pmic_gpio_pdata;
-}
-
-static void __init *max3111_platform_data(void *info)
-{
-	struct spi_board_info *spi_info = info;
-	int intr = get_gpio_by_name("max3111_int");
-
-	spi_info->mode = SPI_MODE_0;
-	if (intr == -1)
-		return NULL;
-	spi_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	return NULL;
-}
-
-/* we have multiple max7315 on the board ... */
-#define MAX7315_NUM 2
-static void __init *max7315_platform_data(void *info)
-{
-	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
-	static int nr;
-	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
-	struct i2c_board_info *i2c_info = info;
-	int gpio_base, intr;
-	char base_pin_name[SFI_NAME_LEN + 1];
-	char intr_pin_name[SFI_NAME_LEN + 1];
-
-	if (nr == MAX7315_NUM) {
-		pr_err("too many max7315s, we only support %d\n",
-				MAX7315_NUM);
-		return NULL;
-	}
-	/* we have several max7315 on the board, we only need load several
-	 * instances of the same pca953x driver to cover them
-	 */
-	strcpy(i2c_info->type, "max7315");
-	if (nr++) {
-		sprintf(base_pin_name, "max7315_%d_base", nr);
-		sprintf(intr_pin_name, "max7315_%d_int", nr);
-	} else {
-		strcpy(base_pin_name, "max7315_base");
-		strcpy(intr_pin_name, "max7315_int");
-	}
-
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
-
-	if (gpio_base == -1)
-		return NULL;
-	max7315->gpio_base = gpio_base;
-	if (intr != -1) {
-		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-		max7315->irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	} else {
-		i2c_info->irq = -1;
-		max7315->irq_base = -1;
-	}
-	return max7315;
-}
-
-static void *tca6416_platform_data(void *info)
-{
-	static struct pca953x_platform_data tca6416;
-	struct i2c_board_info *i2c_info = info;
-	int gpio_base, intr;
-	char base_pin_name[SFI_NAME_LEN + 1];
-	char intr_pin_name[SFI_NAME_LEN + 1];
-
-	strcpy(i2c_info->type, "tca6416");
-	strcpy(base_pin_name, "tca6416_base");
-	strcpy(intr_pin_name, "tca6416_int");
-
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
-
-	if (gpio_base == -1)
-		return NULL;
-	tca6416.gpio_base = gpio_base;
-	if (intr != -1) {
-		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	} else {
-		i2c_info->irq = -1;
-		tca6416.irq_base = -1;
-	}
-	return &tca6416;
-}
-
-static void *mpu3050_platform_data(void *info)
-{
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("mpu3050_int");
-
-	if (intr == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	return NULL;
-}
-
-static void __init *emc1403_platform_data(void *info)
-{
-	static short intr2nd_pdata;
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("thermal_int");
-	int intr2nd = get_gpio_by_name("thermal_alert");
-
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
-
-	return &intr2nd_pdata;
-}
-
-static void __init *lis331dl_platform_data(void *info)
-{
-	static short intr2nd_pdata;
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("accel_int");
-	int intr2nd = get_gpio_by_name("accel_2");
-
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
-
-	return &intr2nd_pdata;
-}
-
-static void __init *no_platform_data(void *info)
-{
-	return NULL;
-}
-
-static struct resource msic_resources[] = {
-	{
-		.start	= INTEL_MSIC_IRQ_PHYS_BASE,
-		.end	= INTEL_MSIC_IRQ_PHYS_BASE + 64 - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct intel_msic_platform_data msic_pdata;
-
-static struct platform_device msic_device = {
-	.name		= "intel_msic",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &msic_pdata,
-	},
-	.num_resources	= ARRAY_SIZE(msic_resources),
-	.resource	= msic_resources,
-};
-
-static inline bool intel_mid_has_msic(void)
-{
-	return intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_PENWELL;
-}
-
-static int msic_scu_status_change(struct notifier_block *nb,
-				  unsigned long code, void *data)
-{
-	if (code == SCU_DOWN) {
-		platform_device_unregister(&msic_device);
-		return 0;
-	}
-
-	return platform_device_register(&msic_device);
-}
-
-static int __init msic_init(void)
-{
-	static struct notifier_block msic_scu_notifier = {
-		.notifier_call	= msic_scu_status_change,
-	};
-
-	/*
-	 * We need to be sure that the SCU IPC is ready before MSIC device
-	 * can be registered.
-	 */
-	if (intel_mid_has_msic())
-		intel_scu_notifier_add(&msic_scu_notifier);
-
-	return 0;
-}
-arch_initcall(msic_init);
-
-/*
- * msic_generic_platform_data - sets generic platform data for the block
- * @info: pointer to the SFI device table entry for this block
- * @block: MSIC block
- *
- * Function sets IRQ number from the SFI table entry for given device to
- * the MSIC platform data.
- */
-static void *msic_generic_platform_data(void *info, enum intel_msic_block block)
-{
-	struct sfi_device_table_entry *entry = info;
-
-	BUG_ON(block < 0 || block >= INTEL_MSIC_BLOCK_LAST);
-	msic_pdata.irq[block] = entry->irq;
-
-	return no_platform_data(info);
-}
-
-static void *msic_battery_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
-}
-
-static void *msic_gpio_platform_data(void *info)
-{
-	static struct intel_msic_gpio_pdata pdata;
-	int gpio = get_gpio_by_name("msic_gpio_base");
-
-	if (gpio < 0)
-		return NULL;
-
-	pdata.gpio_base = gpio;
-	msic_pdata.gpio = &pdata;
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_GPIO);
-}
-
-static void *msic_audio_platform_data(void *info)
-{
-	struct platform_device *pdev;
-
-	pdev = platform_device_register_simple("sst-platform", -1, NULL, 0);
-	if (IS_ERR(pdev)) {
-		pr_err("failed to create audio platform device\n");
-		return NULL;
-	}
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_AUDIO);
-}
-
-static void *msic_power_btn_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_POWER_BTN);
-}
-
-static void *msic_ocd_platform_data(void *info)
-{
-	static struct intel_msic_ocd_pdata pdata;
-	int gpio = get_gpio_by_name("ocd_gpio");
-
-	if (gpio < 0)
-		return NULL;
-
-	pdata.gpio = gpio;
-	msic_pdata.ocd = &pdata;
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
-}
-
-static void *msic_thermal_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
-}
-
-/* tc35876x DSI-LVDS bridge chip and panel platform data */
-static void *tc35876x_platform_data(void *data)
-{
-	static struct tc35876x_platform_data pdata;
-
-	/* gpio pins set to -1 will not be used by the driver */
-	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
-	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
-	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
-
-	return &pdata;
-}
-
-static const struct devs_id __initconst device_ids[] = {
-	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data, &ipc_device_handler},
-	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
-	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
-	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
-	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
-	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
-	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
-	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data, &ipc_device_handler},
-	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
-	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
-
-	/* MSIC subdevices */
-	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data, &ipc_device_handler},
-	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, &ipc_device_handler},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, &ipc_device_handler},
-	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data, &ipc_device_handler},
-	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, &ipc_device_handler},
-	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data, &ipc_device_handler},
-	{ 0 }
-};
-
-static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-				struct devs_id *dev)
-{
-	struct platform_device *pdev;
-	void *pdata = NULL;
-	static struct resource res __initdata = {
-		.name = "IRQ",
-		.flags = IORESOURCE_IRQ,
-	};
-
-	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
-		pentry->name, pentry->irq);
-
-	/*
-	 * We need to call platform init of IPC devices to fill misc_pdata
-	 * structure. It will be used in msic_init for initialization.
-	 */
-	if (dev != NULL)
-		pdata = dev->get_platform_data(pentry);
-
-	/*
-	 * On Medfield the platform device creation is handled by the MSIC
-	 * MFD driver so we don't need to do it here.
-	 */
-	if (intel_mid_has_msic())
-		return;
-
-	pdev = platform_device_alloc(pentry->name, 0);
-	if (pdev == NULL) {
-		pr_err("out of memory for SFI platform device '%s'.\n",
-			pentry->name);
-		return;
-	}
-	res.start = pentry->irq;
-	platform_device_add_resources(pdev, &res, 1);
-
-	pdev->dev.platform_data = pdata;
-	intel_scu_device_register(pdev);
-}
-
-
-/*
- * we will search these buttons in SFI GPIO table (by name)
- * and register them dynamically. Please add all possible
- * buttons here, we will shrink them if no GPIO found.
- */
-static struct gpio_keys_button gpio_button[] = {
-	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
-	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
-	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
-	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
-	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
-	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
-	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
-	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
-	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
-	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
-};
-
-static struct gpio_keys_platform_data intel_mid_gpio_keys = {
-	.buttons	= gpio_button,
-	.rep		= 1,
-	.nbuttons	= -1, /* will fill it after search */
-};
-
-static struct platform_device pb_device = {
-	.name		= "gpio-keys",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &intel_mid_gpio_keys,
-	},
-};
-
-/*
- * Shrink the non-existent buttons, register the gpio button
- * device if there is some
- */
-static int __init pb_keys_init(void)
-{
-	struct gpio_keys_button *gb = gpio_button;
-	int i, num, good = 0;
-
-	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
-	for (i = 0; i < num; i++) {
-		gb[i].gpio = get_gpio_by_name(gb[i].desc);
-		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
-					gb[i].gpio);
-		if (gb[i].gpio == -1)
-			continue;
-
-		if (i != good)
-			gb[good] = gb[i];
-		good++;
-	}
-
-	if (good) {
-		intel_mid_gpio_keys.nbuttons = good;
-		return platform_device_register(&pb_device);
-	}
-	return 0;
-}
-late_initcall(pb_keys_init);
\ No newline at end of file
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 3f1c171..c84c1ca 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -42,7 +42,6 @@
 #include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
 #include <asm/reboot.h>
-#include "intel_mid_weak_decls.h"
 
 #define	SFI_SIG_OEM0	"OEM0"
 #define MAX_IPCDEVS	24
@@ -403,19 +402,20 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
 }
 
+extern struct devs_id *const __x86_intel_mid_dev_start[],
+		      *const __x86_intel_mid_dev_end[];
+
 static struct devs_id __init *get_device_id(u8 type, char *name)
 {
-	struct devs_id *dev = device_ids;
-
-	if (device_ids == NULL)
-		return NULL;
+	struct devs_id *const *dev_table;
 
-	while (dev->name[0]) {
+	for (dev_table = __x86_intel_mid_dev_start;
+			dev_table < __x86_intel_mid_dev_end; dev_table++) {
+		struct devs_id *dev = *dev_table;
 		if (dev->type == type &&
 			!strncmp(dev->name, name, SFI_NAME_LEN)) {
 			return dev;
 		}
-		dev++;
 	}
 
 	return NULL;
diff --git a/include/linux/sfi.h b/include/linux/sfi.h
index fe81791..d9b436f 100644
--- a/include/linux/sfi.h
+++ b/include/linux/sfi.h
@@ -59,6 +59,9 @@
 #ifndef _LINUX_SFI_H
 #define _LINUX_SFI_H
 
+#include <linux/init.h>
+#include <linux/types.h>
+
 /* Table signatures reserved by the SFI specification */
 #define SFI_SIG_SYST		"SYST"
 #define SFI_SIG_FREQ		"FREQ"
-- 
1.8.4.rc3

