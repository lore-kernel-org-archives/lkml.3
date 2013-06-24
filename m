Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FXEHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:07:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:5919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3FXEHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,925,1363158000"; 
   d="scan'208";a="334396273"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH v3 1/4] mfd: Kontron PLD mfd driver
Date: Sun, 23 Jun 2013 21:00:03 -0700
Message-Id: <1372046406-3127-2-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add core MFD driver for the on-board PLD found on some Kontron embedded
modules. The PLD device may provide functions like watchdog, GPIO, UART
and I2C bus.

The following modules are supported:
	* COMe-bIP#
	* COMe-bPC2 (ETXexpress-PC)
	* COMe-bSC# (ETXexpress-SC T#)
	* COMe-cCT6
	* COMe-cDC2 (microETXexpress-DC)
	* COMe-cPC2 (microETXexpress-PC)
	* COMe-mCT10
	* ETX-OH

Originally-From: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/Kconfig        |   21 ++
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/kempld-core.c  |  642 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/kempld.h |  125 +++++++++
 4 files changed, 789 insertions(+)
 create mode 100644 drivers/mfd/kempld-core.c
 create mode 100644 include/linux/mfd/kempld.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..eea3737 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -912,6 +912,27 @@ config MFD_TIMBERDALE
 	The timberdale FPGA can be found on the Intel Atom development board
 	for in-vehicle infontainment, called Russellville.
 
+config MFD_KEMPLD
+	tristate "Support for Kontron module PLD device"
+	select MFD_CORE
+	help
+	  This is the core driver for the PLD (Programmable Logic Device) found
+	  on some Kontron ETX and COMexpress (ETXexpress) modules. The PLD
+	  device may provide functions like watchdog, GPIO, UART and I2C bus.
+
+	  The following modules are supported:
+		* COMe-bIP#
+		* COMe-bPC2 (ETXexpress-PC)
+		* COMe-bSC# (ETXexpress-SC T#)
+		* COMe-cCT6
+		* COMe-cDC2 (microETXexpress-DC)
+		* COMe-cPC2 (microETXexpress-PC)
+		* COMe-mCT10
+		* ETX-OH
+
+	  This driver can also be built as a module. If so, the module
+	  will be called kempld-core.
+
 config LPC_SCH
 	tristate "Intel SCH LPC"
 	depends on PCI && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..a2f6a9f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -123,6 +123,7 @@ obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
+obj-$(CONFIG_MFD_KEMPLD)	+= kempld-core.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
new file mode 100644
index 0000000..85b437e
--- /dev/null
+++ b/drivers/mfd/kempld-core.c
@@ -0,0 +1,642 @@
+/*
+ * Kontron PLD MFD core driver
+ *
+ * Copyright (c) 2010-2013 Kontron Europe GmbH
+ * Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/kempld.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#define MAX_ID_LEN 4
+static char force_device_id[MAX_ID_LEN + 1] = "";
+module_param_string(force_device_id, force_device_id, sizeof(force_device_id), 0);
+MODULE_PARM_DESC(force_device_id, "Override detected product");
+
+/*
+ * Get hardware mutex to block firmware from accessing the pld.
+ * It is possible for the firmware may hold the mutex for an extended length of
+ * time. This function will block until access has been granted.
+ */
+static void kempld_get_hardware_mutex(struct kempld_device_data *pld)
+{
+	/* The mutex bit will read 1 until access has been granted */
+	while (ioread8(pld->io_index) & KEMPLD_MUTEX_KEY)
+		msleep(1);
+}
+
+static void kempld_release_hardware_mutex(struct kempld_device_data *pld)
+{
+	/* The harware mutex is released when 1 is written to the mutex bit. */
+	iowrite8(KEMPLD_MUTEX_KEY, pld->io_index);
+}
+
+static int kempld_get_info_generic(struct kempld_device_data *pld)
+{
+	u16 version;
+	u8 spec;
+
+	kempld_get_mutex(pld);
+
+	version = kempld_read16(pld, KEMPLD_VERSION);
+	spec = kempld_read8(pld, KEMPLD_SPEC);
+	pld->info.buildnr = kempld_read16(pld, KEMPLD_BUILDNR);
+
+	pld->info.minor = KEMPLD_VERSION_GET_MINOR(version);
+	pld->info.major = KEMPLD_VERSION_GET_MAJOR(version);
+	pld->info.number = KEMPLD_VERSION_GET_NUMBER(version);
+	pld->info.type = KEMPLD_VERSION_GET_TYPE(version);
+
+	if (spec == 0xff) {
+		pld->info.spec_minor = 0;
+		pld->info.spec_major = 1;
+	} else {
+		pld->info.spec_minor = KEMPLD_SPEC_GET_MINOR(spec);
+		pld->info.spec_major = KEMPLD_SPEC_GET_MAJOR(spec);
+	}
+
+	if (pld->info.spec_major > 0)
+		pld->feature_mask = kempld_read16(pld, KEMPLD_FEATURE);
+	else
+		pld->feature_mask = 0;
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+enum kempld_cells {
+	KEMPLD_I2C = 0,
+	KEMPLD_WDT,
+	KEMPLD_GPIO,
+	KEMPLD_UART,
+};
+
+static struct mfd_cell kempld_devs[] = {
+	[KEMPLD_I2C] = {
+		.name = "kempld-i2c",
+	},
+	[KEMPLD_WDT] = {
+		.name = "kempld-wdt",
+	},
+	[KEMPLD_GPIO] = {
+		.name = "kempld-gpio",
+	},
+	[KEMPLD_UART] = {
+		.name = "kempld-uart",
+	},
+};
+
+#define KEMPLD_MAX_DEVS	ARRAY_SIZE(kempld_devs)
+
+static int kempld_register_cells_generic(struct kempld_device_data *pld)
+{
+	struct mfd_cell devs[KEMPLD_MAX_DEVS];
+	int i = 0;
+
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_I2C)
+		devs[i++] = kempld_devs[KEMPLD_I2C];
+
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_WATCHDOG)
+		devs[i++] = kempld_devs[KEMPLD_WDT];
+
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_GPIO)
+		devs[i++] = kempld_devs[KEMPLD_GPIO];
+
+	if (pld->feature_mask & KEMPLD_FEATURE_MASK_UART)
+		devs[i++] = kempld_devs[KEMPLD_UART];
+
+	return mfd_add_devices(pld->dev, -1, devs, i, NULL, 0, NULL);
+}
+
+static struct resource kempld_ioresource = {
+	.start	= KEMPLD_IOINDEX,
+	.end	= KEMPLD_IODATA,
+	.flags	= IORESOURCE_IO,
+};
+
+static const struct kempld_platform_data kempld_platform_data_generic = {
+	.pld_clock		= KEMPLD_CLK,
+	.ioresource		= &kempld_ioresource,
+	.get_hardware_mutex	= kempld_get_hardware_mutex,
+	.release_hardware_mutex	= kempld_release_hardware_mutex,
+	.get_info		= kempld_get_info_generic,
+	.register_cells		= kempld_register_cells_generic,
+};
+
+static struct platform_device *kempld_pdev;
+
+static int kempld_create_platform_device(const struct dmi_system_id *id)
+{
+	struct kempld_platform_data *pdata = id->driver_data;
+	int ret;
+
+	kempld_pdev = platform_device_alloc("kempld", -1);
+	if (!kempld_pdev)
+		return -ENOMEM;
+
+	ret = platform_device_add_data(kempld_pdev, pdata, sizeof(*pdata));
+	if (ret)
+		goto err;
+
+	ret = platform_device_add_resources(kempld_pdev, pdata->ioresource, 1);
+	if (ret)
+		goto err;
+
+	ret = platform_device_add(kempld_pdev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	platform_device_put(kempld_pdev);
+	return ret;
+}
+
+/**
+ * kempld_read8 - read 8 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+u8 kempld_read8(struct kempld_device_data *pld, u8 index)
+{
+	iowrite8(index, pld->io_index);
+	return ioread8(pld->io_data);
+}
+EXPORT_SYMBOL_GPL(kempld_read8);
+
+/**
+ * kempld_write8 - write 8 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+void kempld_write8(struct kempld_device_data *pld, u8 index, u8 data)
+{
+	iowrite8(index, pld->io_index);
+	iowrite8(data, pld->io_data);
+}
+EXPORT_SYMBOL_GPL(kempld_write8);
+
+/**
+ * kempld_read16 - read 16 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+u16 kempld_read16(struct kempld_device_data *pld, u8 index)
+{
+	return kempld_read8(pld, index) | kempld_read8(pld, index + 1) << 8;
+}
+EXPORT_SYMBOL_GPL(kempld_read16);
+
+/**
+ * kempld_write16 - write 16 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data)
+{
+	kempld_write8(pld, index, (u8)data);
+	kempld_write8(pld, index + 1, (u8)(data >> 8));
+}
+EXPORT_SYMBOL_GPL(kempld_write16);
+
+/**
+ * kempld_read32 - read 32 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+u32 kempld_read32(struct kempld_device_data *pld, u8 index)
+{
+	return kempld_read16(pld, index) | kempld_read16(pld, index + 2) << 16;
+}
+EXPORT_SYMBOL_GPL(kempld_read32);
+
+/**
+ * kempld_write32 - write 32 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+void kempld_write32(struct kempld_device_data *pld, u8 index, u32 data)
+{
+	kempld_write16(pld, index, (u16)data);
+	kempld_write16(pld, index + 2, (u16)(data >> 16));
+}
+EXPORT_SYMBOL_GPL(kempld_write32);
+
+/**
+ * kempld_get_mutex - acquire PLD mutex
+ * @pld: kempld_device_data structure describing the PLD
+ */
+void kempld_get_mutex(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	mutex_lock(&pld->lock);
+	pdata->get_hardware_mutex(pld);
+}
+EXPORT_SYMBOL_GPL(kempld_get_mutex);
+
+/**
+ * kempld_release_mutex - release PLD mutex
+ * @pld: kempld_device_data structure describing the PLD
+ */
+void kempld_release_mutex(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	pdata->release_hardware_mutex(pld);
+	mutex_unlock(&pld->lock);
+}
+EXPORT_SYMBOL_GPL(kempld_release_mutex);
+
+/**
+ * kempld_get_info - update device specific information
+ * @pld: kempld_device_data structure describing the PLD
+ *
+ * This function calls the configured board specific kempld_get_info_XXXX
+ * function which is responsible for gathering information about the specific
+ * hardware. The information is then stored within the pld structure.
+ */
+static int kempld_get_info(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	return pdata->get_info(pld);
+}
+
+/*
+ * kempld_register_cells - register cell drivers
+ *
+ * This function registers cell drivers for the detected hardware by calling
+ * the configured kempld_register_cells_XXXX function which is responsible
+ * to detect and register the needed cell drivers.
+ */
+static int kempld_register_cells(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	return pdata->register_cells(pld);
+}
+
+static int kempld_detect_device(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	char *version_type;
+	u8 index_reg;
+	int ret;
+
+	mutex_lock(&pld->lock);
+
+	/* Check for empty IO space */
+	index_reg = ioread8(pld->io_index);
+	if (index_reg == 0xff && ioread8(pld->io_data) == 0xff) {
+		mutex_unlock(&pld->lock);
+		return -ENODEV;
+	}
+
+	/* Release hardware mutex if aquired */
+	if (!(index_reg & KEMPLD_MUTEX_KEY))
+		iowrite8(KEMPLD_MUTEX_KEY, pld->io_index);
+
+	mutex_unlock(&pld->lock);
+
+	ret = kempld_get_info(pld);
+	if (ret)
+		return ret;
+
+	switch (pld->info.type) {
+	case 0:
+		version_type = "release";
+		break;
+	case 1:
+		version_type = "debug";
+		break;
+	case 2:
+		version_type = "custom";
+		break;
+	default:
+		version_type = "unspecified";
+	}
+
+	dev_info(pld->dev, "Found Kontron PLD %d\n", pld->info.number);
+	dev_info(pld->dev, "%s version %d.%d build %d, specification %d.%d\n",
+		 version_type, pld->info.major, pld->info.minor,
+		 pld->info.buildnr, pld->info.spec_major,
+		 pld->info.spec_minor);
+
+	return kempld_register_cells(pld);
+}
+
+static int kempld_probe(struct platform_device *pdev)
+{
+	struct kempld_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct kempld_device_data *pld;
+	struct resource *ioport;
+	int ret;
+
+	pld = devm_kzalloc(dev, sizeof(*pld), GFP_KERNEL);
+	if (!pld)
+		return -ENOMEM;
+
+	ioport = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!ioport)
+		return -EINVAL;
+
+	pld->io_base = devm_ioport_map(dev, ioport->start,
+					ioport->end - ioport->start);
+	if (!pld->io_base)
+		return -ENOMEM;
+
+	pld->io_index = pld->io_base;
+	pld->io_data = pld->io_base + 1;
+	pld->pld_clock = pdata->pld_clock;
+	pld->dev = dev;
+
+	mutex_init(&pld->lock);
+	platform_set_drvdata(pdev, pld);
+
+	ret = kempld_detect_device(pld);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int kempld_remove(struct platform_device *pdev)
+{
+	struct kempld_device_data *pld = platform_get_drvdata(pdev);
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	mfd_remove_devices(&pdev->dev);
+	pdata->release_hardware_mutex(pld);
+
+	return 0;
+}
+
+static struct platform_driver kempld_driver = {
+	.driver		= {
+		.name	= "kempld",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= kempld_probe,
+	.remove		= kempld_remove,
+};
+
+static struct dmi_system_id __initdata kempld_dmi_table[] = {
+	{
+		.ident = "CCR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bIP2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CCR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bIP6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-SC T2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXe-SC T2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bSC2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-SC T6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXe-SC T6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bSC6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-PC"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bPC2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "CNTX",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "PXT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "FRI2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BIOS_VERSION, "FRI2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "FRI2",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Fish River Island II"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "MBR1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETX-OH"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-TT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "nETXe-TT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mTT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "NUP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mCT"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "UNP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "microETXexpress-DC"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "UNP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cDC2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "UNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "microETXexpress-PC"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "UNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cPC2"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	}, {
+		.ident = "UUP6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cCT6"),
+		},
+		.driver_data = (void *)&kempld_platform_data_generic,
+		.callback = kempld_create_platform_device,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(dmi, kempld_dmi_table);
+
+static int __init kempld_init(void)
+{
+	const struct dmi_system_id *id;
+	int ret;
+
+	if (force_device_id[0]) {
+		for (id = kempld_dmi_table; id->matches[0].slot != DMI_NONE; id++)
+			if (strstr(id->ident, force_device_id))
+				if (id->callback && id->callback(id))
+					break;
+		if (id->matches[0].slot == DMI_NONE)
+			return -ENODEV;
+	} else {
+		if (!dmi_check_system(kempld_dmi_table))
+			return -ENODEV;
+	}
+
+	ret = platform_driver_register(&kempld_driver);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void __exit kempld_exit(void)
+{
+	if (kempld_pdev)
+		platform_device_unregister(kempld_pdev);
+
+	platform_driver_unregister(&kempld_driver);
+}
+
+module_init(kempld_init);
+module_exit(kempld_exit);
+
+MODULE_DESCRIPTION("KEM PLD Core Driver");
+MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kempld-core");
diff --git a/include/linux/mfd/kempld.h b/include/linux/mfd/kempld.h
new file mode 100644
index 0000000..b911ef3
--- /dev/null
+++ b/include/linux/mfd/kempld.h
@@ -0,0 +1,125 @@
+/*
+ * Kontron PLD driver definitions
+ *
+ * Copyright (c) 2010-2012 Kontron Europe GmbH
+ * Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_MFD_KEMPLD_H_
+#define _LINUX_MFD_KEMPLD_H_
+
+/* kempld register definitions */
+#define KEMPLD_IOINDEX			0xa80
+#define KEMPLD_IODATA			0xa81
+#define KEMPLD_MUTEX_KEY		0x80
+#define KEMPLD_VERSION			0x00
+#define KEMPLD_VERSION_LSB		0x00
+#define KEMPLD_VERSION_MSB		0x01
+#define KEMPLD_VERSION_GET_MINOR(x)	(x & 0x1f)
+#define KEMPLD_VERSION_GET_MAJOR(x)	((x >> 5) & 0x1f)
+#define KEMPLD_VERSION_GET_NUMBER(x)	((x >> 10) & 0xf)
+#define KEMPLD_VERSION_GET_TYPE(x)	((x >> 14) & 0x3)
+#define KEMPLD_BUILDNR			0x02
+#define KEMPLD_BUILDNR_LSB		0x02
+#define KEMPLD_BUILDNR_MSB		0x03
+#define KEMPLD_FEATURE			0x04
+#define KEMPLD_FEATURE_LSB		0x04
+#define KEMPLD_FEATURE_MSB		0x05
+#define KEMPLD_FEATURE_BIT_I2C		(1 << 0)
+#define KEMPLD_FEATURE_BIT_WATCHDOG	(1 << 1)
+#define KEMPLD_FEATURE_BIT_GPIO		(1 << 2)
+#define KEMPLD_FEATURE_MASK_UART	(7 << 3)
+#define KEMPLD_FEATURE_BIT_NMI		(1 << 8)
+#define KEMPLD_FEATURE_BIT_SMI		(1 << 9)
+#define KEMPLD_FEATURE_BIT_SCI		(1 << 10)
+#define KEMPLD_SPEC			0x06
+#define KEMPLD_SPEC_GET_MINOR(x)	(x & 0x0f)
+#define KEMPLD_SPEC_GET_MAJOR(x)	((x >> 4) & 0x0f)
+#define KEMPLD_IRQ_GPIO			0x35
+#define KEMPLD_IRQ_I2C			0x36
+#define KEMPLD_CFG			0x37
+#define KEMPLD_CFG_GPIO_I2C_MUX		(1 << 0)
+#define KEMPLD_CFG_BIOS_WP		(1 << 7)
+
+#define KEMPLD_CLK			33333333
+
+#define	KEMPLD_TYPE_RELEASE		0x0
+#define	KEMPLD_TYPE_DEBUG		0x1
+#define	KEMPLD_TYPE_CUSTOM		0x2
+
+/**
+ * struct kempld_info - PLD device information structure
+ * @major:	PLD major revision
+ * @minor:	PLD minor revision
+ * @buildnr:	PLD build number
+ * @number:	PLD board specific index
+ * @type:	PLD type
+ * @spec_major:	PLD FW specification major revision
+ * @spec_minor:	PLD FW specification minor revision
+ */
+struct kempld_info {
+	unsigned int major;
+	unsigned int minor;
+	unsigned int buildnr;
+	unsigned int number;
+	unsigned int type;
+	unsigned int spec_major;
+	unsigned int spec_minor;
+};
+
+/**
+ * struct kempld_device_data - Internal representation of the PLD device
+ * @io_base:		Pointer to the IO memory
+ * @io_index:		Pointer to the IO index register
+ * @io_data:		Pointer to the IO data register
+ * @pld_clock:		PLD clock frequency
+ * @feature_mask:	PLD feature mask
+ * @dev:		Pointer to kernel device structure
+ * @info:		KEMPLD info structure
+ * @lock:		PLD mutex
+ */
+struct kempld_device_data {
+	void __iomem		*io_base;
+	void __iomem		*io_index;
+	void __iomem		*io_data;
+	u32			pld_clock;
+	u32			feature_mask;
+	struct device		*dev;
+	struct kempld_info	info;
+	struct mutex		lock;
+};
+
+/**
+ * struct kempld_platform_data - PLD hardware configuration structure
+ * @pld_clock:			PLD clock frequency
+ * @gpio_base			GPIO base pin number
+ * @ioresource:			IO addresses of the PLD
+ * @get_mutex:			PLD specific get_mutex callback
+ * @release_mutex:		PLD specific release_mutex callback
+ * @get_info:			PLD specific get_info callback
+ * @register_cells:		PLD specific register_cells callback
+ */
+struct kempld_platform_data {
+	u32				pld_clock;
+	int				gpio_base;
+	struct resource			*ioresource;
+	void (*get_hardware_mutex)	(struct kempld_device_data *);
+	void (*release_hardware_mutex)	(struct kempld_device_data *);
+	int (*get_info)			(struct kempld_device_data *);
+	int (*register_cells)		(struct kempld_device_data *);
+};
+
+extern void kempld_get_mutex(struct kempld_device_data *pld);
+extern void kempld_release_mutex(struct kempld_device_data *pld);
+extern u8 kempld_read8(struct kempld_device_data *pld, u8 index);
+extern void kempld_write8(struct kempld_device_data *pld, u8 index, u8 data);
+extern u16 kempld_read16(struct kempld_device_data *pld, u8 index);
+extern void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data);
+extern u32 kempld_read32(struct kempld_device_data *pld, u8 index);
+extern void kempld_write32(struct kempld_device_data *pld, u8 index, u32 data);
+
+#endif /* _LINUX_MFD_KEMPLD_H_ */
-- 
1.7.9.5

