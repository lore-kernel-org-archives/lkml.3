Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935105Ab3DHRSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:18:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:50355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934717Ab3DHRSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:18:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291854089"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Strasser <kevin.strasser@linux.intel.com>
Subject: [PATCH 1/4] mfd: Kontron PLD mfd driver
Date: Mon,  8 Apr 2013 10:15:18 -0700
Message-Id: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Brunner <michael.brunner@kontron.com>

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
	* COMe-mSP1 (nanoETXexpress-SP)
	* COMe-mTT10 (nanoETXexpress-TT)
	* ETX-OH

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
---
 drivers/mfd/Kconfig        |   23 +
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/kempld-core.c  | 1088 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/kempld.h |  152 +++++++
 4 files changed, 1264 insertions(+)
 create mode 100644 drivers/mfd/kempld-core.c
 create mode 100644 include/linux/mfd/kempld.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..2491843 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -912,6 +912,29 @@ config MFD_TIMBERDALE
 	The timberdale FPGA can be found on the Intel Atom development board
 	for in-vehicle infontainment, called Russellville.
 
+config MFD_KEMPLD
+	tristate "Support for Kontron module PLD device"
+	select MFD_CORE
+	help
+	  This is the core driver for the PLD device found on some Kontron
+	  ETX and COMexpress (ETXexpress) modules. The PLD device may provide
+	  functions like watchdog, GPIO, UART and I2C bus.
+
+	  The following modules are supported:
+		* COMe-bIP#
+		* COMe-bPC2 (ETXexpress-PC)
+		* COMe-bSC# (ETXexpress-SC T#)
+		* COMe-cCT6
+		* COMe-cDC2 (microETXexpress-DC)
+		* COMe-cPC2 (microETXexpress-PC)
+		* COMe-mCT10
+		* COMe-mSP1 (nanoETXexpress-SP)
+		* COMe-mTT10 (nanoETXexpress-TT)
+		* ETX-OH
+
+	  This driver can also be built as a module. If so, the module
+	  will be called kempld-core.
+
 config LPC_SCH
 	tristate "Intel SCH LPC"
 	depends on PCI && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..cb1cb16 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -123,6 +123,7 @@ obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
+obj-$(CONFIG_MFD_KEMPLD)    += kempld-core.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
new file mode 100644
index 0000000..778e26b
--- /dev/null
+++ b/drivers/mfd/kempld-core.c
@@ -0,0 +1,1088 @@
+/*
+ *  kempld-core.c - Kontron PLD MFD core driver
+ *
+ *  Copyright (c) 2010-2013 Kontron Europe GmbH
+ *  Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/dmi.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/kempld.h>
+
+#define KEMPLD_MAINTAIN_EFT_COMPATIBILITY	1
+
+static int kempld_platform_device_register(const struct dmi_system_id *id);
+static int kempld_get_mutex_set_index_generic(struct kempld_device_data *pld,
+					u8 index, unsigned int timeout);
+static void kempld_release_mutex_generic(struct kempld_device_data *pld);
+
+static int kempld_get_info(struct kempld_device_data *pld);
+static int kempld_get_info_NOW1(struct kempld_device_data *pld);
+static int kempld_get_info_generic(struct kempld_device_data *pld);
+static int kempld_get_features(struct kempld_device_data *pld);
+static int kempld_register_cells_generic(struct kempld_device_data *pld);
+static int kempld_register_cells_NOW1(struct kempld_device_data *pld);
+
+#define MAX_IDENT_LEN 4
+static char force_ident[MAX_IDENT_LEN + 1] = "";
+module_param_string(force_ident, force_ident, sizeof(force_ident), 0);
+MODULE_PARM_DESC(force_ident, "Force detection of specific product");
+
+/* this option is only here for debugging and should never be needed in
+ * production environments */
+static bool force_unlock;
+module_param(force_unlock, bool, 0);
+MODULE_PARM_DESC(force_unlock, "Force breaking the semaphore on driver load");
+
+/* this is the default CPLD configuration unless something else is defined */
+static const struct kempld_platform_data kempld_platform_data_generic = {
+	.pld_clock		= 33333333,
+	.ioport			= 0xa80,
+	.force_index_write	= 0,
+	.get_mutex_set_index	= kempld_get_mutex_set_index_generic,
+	.release_mutex		= kempld_release_mutex_generic,
+	.get_info		= kempld_get_info_generic,
+	.register_cells		= kempld_register_cells_generic,
+};
+
+/* the COMe-mSP1 (nanoETXexpress-SP) has an earlier version of the CPLD that
+ * works a bit different */
+static const struct kempld_platform_data kempld_platform_data_NOW1 = {
+	.pld_clock		= 33333333,
+	.ioport			= 0xa80,
+	.force_index_write	= 1,
+	.get_mutex_set_index	= NULL,
+	.release_mutex		= NULL,
+	.get_info		= kempld_get_info_NOW1,
+	.register_cells		= kempld_register_cells_NOW1,
+};
+
+static const struct dmi_system_id kempld_boardids[] = {
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CCR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bIP2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CCR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bIP6"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-SC T2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXe-SC T2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bSC2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-SC T6"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXe-SC T6"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CHR6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bSC6"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETXexpress-PC"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-bPC2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "CNTX",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "PXT"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "FRI2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BIOS_VERSION, "FRI2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "FRI2",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Fish River Island II"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "MBR1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "ETX-OH"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NOW1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-SP"),
+		},
+		.driver_data = (void *)&kempld_platform_data_NOW1,
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NOW1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mSP1"),
+		},
+		.driver_data = (void *)&kempld_platform_data_NOW1,
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "nanoETXexpress-TT"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "nETXe-TT"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NTC1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mTT"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "NUP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-mCT"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "UNP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "microETXexpress-DC"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "UNP1",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cDC2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "UNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "microETXexpress-PC"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "UNTG",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cPC2"),
+		},
+	},
+	{
+		.callback = kempld_platform_device_register,
+		.ident = "UUP6",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Kontron"),
+			DMI_MATCH(DMI_BOARD_NAME, "COMe-cCT6"),
+		},
+	},
+	{}
+};
+
+static struct kempld_platform_data kempld_platform_data;
+
+static struct mfd_cell kempld_cell_i2c = {
+	.name = "kempld-i2c",
+};
+
+static struct mfd_cell kempld_cell_wdt = {
+	.name = "kempld-wdt",
+};
+
+static struct mfd_cell kempld_cell_NOW1_wdt = {
+	.name = "kempld_now1-wdt",
+};
+
+static struct mfd_cell kempld_cell_gpio = {
+	.name = "kempld-gpio",
+};
+
+static struct mfd_cell kempld_cell_uart = {
+	.name = "kempld-uart",
+};
+
+static struct mfd_cell kempld_cell_NOW1_gpio = {
+	.name = "kempld_now1-gpio",
+};
+
+static struct platform_device *kempld_pdev;
+
+/**
+ * kempld_read8 - read 8 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * This function reads an 8 bit register of the PLD and returns its value.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+u8 kempld_read8(struct kempld_device_data *pld, u8 index)
+{
+	kempld_set_index(pld, index);
+
+	return ioread8(pld->io_data);
+}
+EXPORT_SYMBOL(kempld_read8);
+
+/**
+ * kempld_write8 - write 8 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * This function writes an 8 bit register of the PLD.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+void kempld_write8(struct kempld_device_data *pld, u8 index, u8 data)
+{
+	kempld_set_index(pld, index);
+
+	iowrite8(data, pld->io_data);
+}
+EXPORT_SYMBOL(kempld_write8);
+
+/**
+ * kempld_read16 - read 16 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * This function reads a 16 bit register of the PLD and returns its value.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+u16 kempld_read16(struct kempld_device_data *pld, u8 index)
+{
+	BUG_ON(index+1 < index);
+
+	return kempld_read8(pld, index) | kempld_read8(pld, index+1) << 8;
+}
+EXPORT_SYMBOL(kempld_read16);
+
+/**
+ * kempld_write16 - write 16 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * This function writes a 16 bit register of the PLD.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data)
+{
+	BUG_ON(index+1 < index);
+
+	kempld_write8(pld, index, (u8)data);
+	kempld_write8(pld, index+1, (u8)(data>>8));
+}
+EXPORT_SYMBOL(kempld_write16);
+
+/**
+ * kempld_read32 - read 32 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * This function reads a 32 bit register of the PLD and returns its value.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+u32 kempld_read32(struct kempld_device_data *pld, u8 index)
+{
+	BUG_ON(index+3 < index);
+
+	return kempld_read16(pld, index) | kempld_read16(pld, index+2) << 16;
+}
+EXPORT_SYMBOL(kempld_read32);
+
+/**
+ * kempld_write32 - write 32 bit register
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @data: new register value
+ *
+ * This function writes a 32 bit register of the PLD.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+void kempld_write32(struct kempld_device_data *pld, u8 index, u32 data)
+{
+	BUG_ON(index+3 < index);
+
+	kempld_write16(pld, index, (u16)data);
+	kempld_write16(pld, index+2, (u16)(data>>16));
+}
+EXPORT_SYMBOL(kempld_write32);
+
+/**
+ * kempld_set_index - change the current register index of the PLD
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * This function changes the register index of the PLD.
+ *
+ * If the PLD mutex has been acquired the whole time and the desired index is
+ * already set there might be no actual hardware access done in this function.
+ *
+ * In order for this function to work correctly, kempld_try_get_mutex_set_index
+ * or kempld_get_mutex_set_index has to be called before calling the function
+ * to acquire the mutex. Afterwards the mutex has to be released with
+ * kempld_release_mutex.
+ */
+void kempld_set_index(struct kempld_device_data *pld, u8 index)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	BUG_ON(pld->have_mutex == 0);
+
+	if (pld->last_index != index || pdata->force_index_write) {
+		iowrite8(index, pld->io_index);
+		pld->last_index = index;
+	}
+}
+EXPORT_SYMBOL(kempld_set_index);
+
+static int kempld_get_mutex_set_index_generic(struct kempld_device_data *pld,
+					u8 index, unsigned int timeout)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	int data;
+
+	if (!pld->have_mutex) {
+		unsigned long loop_timeout = jiffies + (HZ*timeout)/1000;
+
+		while ((((data = ioread8(pld->io_index)) & KEMPLD_MUTEX_KEY)
+				== KEMPLD_MUTEX_KEY)) {
+			if (timeout != KEMPLD_MUTEX_NOTIMEOUT)
+				if (!time_before(jiffies, loop_timeout))
+					return -ETIMEDOUT;
+
+			/* we will have to wait until mutex is free */
+			spin_unlock_irqrestore(&pld->lock, pld->lock_flags);
+
+			/* give other tasks a chance to release the mutex */
+			schedule_timeout_interruptible(0);
+
+			spin_lock_irqsave(&pld->lock, pld->lock_flags);
+		}
+	} else
+		data = ioread8(pld->io_index);
+
+	if (KEMPLD_MAINTAIN_EFT_COMPATIBILITY
+		 || ((pld->last_index != (data & ~KEMPLD_MUTEX_KEY))
+		 || pdata->force_index_write)) {
+		iowrite8(index, pld->io_index);
+		pld->last_index = index;
+	}
+
+	return 0;
+}
+
+/**
+ * kempld_get_mutex_set_index - acquire the PLD mutex and set register index
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ *
+ * This function acquires a PLD spinlock and the PLD mutex, additionally it
+ * also changes the register index. In order to do no unnecessary write cycles
+ * the index provided to this function should be the same that will be used
+ * with the first PLD access that is done afterwards.
+ *
+ * The function will block for at least 10 seconds if the mutex can't be
+ * acquired and issue a warning in that case. In order to not lock the device,
+ * the function assumes that the mutex has been acquired in that case.
+ *
+ * To release the spinlock and mutex kempld_release_mutex can be called.
+ * The spinlock and mutex should only be kept for a few milliseconds, in order
+ * to give other drivers a chance to work with the PLD.
+ */
+inline void kempld_get_mutex_set_index(struct kempld_device_data *pld,
+					u8 index)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	spin_lock_irqsave(&pld->lock, pld->lock_flags);
+
+	if (pdata->get_mutex_set_index) {
+		/* use a long timeout here as this shouldn't fail */
+		if (pdata->get_mutex_set_index(pld, index, 10000))
+			dev_warn(pld->dev, "semaphore broken!\n");
+
+		pld->have_mutex = 1;
+	} else {
+		pld->have_mutex = 1;
+		kempld_set_index(pld, index);
+	}
+}
+EXPORT_SYMBOL(kempld_get_mutex_set_index);
+
+/**
+ * kempld_try_get_mutex_set_index - try to acquire the PLD mutex and set
+ *                                   register index
+ * @pld: kempld_device_data structure describing the PLD
+ * @index: register index on the chip
+ * @timeout: timeout value
+ *
+ * This function tries to acquire a PLD spinlock and the PLD mutex,
+ * additionally it also changes the register index. In order to do no
+ * unnecessary write cycles the index provided to this function should be the
+ * same that will be used with the first PLD access that is done afterwards.
+ *
+ * The function will try to get the mutex for the time defined with the timeout
+ * parameter until it returns with -ETIMEDOUT. When the mutex is successfully
+ * acquired the function returns immediately with the return value 0.
+ *
+ * To release the spinlock and mutex kempld_release_mutex can be called.
+ * The spinlock and mutex should only be kept for a few milliseconds, in order
+ * to give other drivers a chance to work with the PLD.
+ */
+inline int kempld_try_get_mutex_set_index(struct kempld_device_data *pld,
+					u8 index, unsigned int timeout)
+{
+	int ret;
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	spin_lock_irqsave(&pld->lock, pld->lock_flags);
+
+	if (pdata->get_mutex_set_index) {
+		ret = pdata->get_mutex_set_index(pld, index, timeout);
+		if (ret == 0)
+			pld->have_mutex = 1;
+	} else {
+		pld->have_mutex = 1;
+		kempld_set_index(pld, index);
+		ret = 0;
+	}
+
+	if (ret != 0)
+		spin_unlock_irqrestore(&pld->lock, pld->lock_flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(kempld_try_get_mutex_set_index);
+
+static void kempld_release_mutex_generic(struct kempld_device_data *pld)
+{
+	iowrite8(pld->last_index | KEMPLD_MUTEX_KEY, pld->io_index);
+}
+
+/**
+ * kempld_release_mutex - release PLD mutex
+ * @pld: kempld_device_data structure describing the PLD
+ *
+ * This function releases the spinlock und mutex previously acquired with the
+ * kempld_get_mutex_set_index or kempld_try_get_mutex_set_index functions.
+ */
+inline void kempld_release_mutex(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+
+	BUG_ON(pld->have_mutex == 0);
+
+	if (pdata->release_mutex)
+		pdata->release_mutex(pld);
+
+	pld->have_mutex = 0;
+
+	spin_unlock_irqrestore(&pld->lock, pld->lock_flags);
+}
+EXPORT_SYMBOL(kempld_release_mutex);
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
+	BUG_ON(pdata->get_info == NULL);
+
+	if (pdata->get_info)
+		return pdata->get_info(pld);
+
+	return -EIO;
+}
+
+static int kempld_get_info_NOW1(struct kempld_device_data *pld)
+{
+	kempld_get_mutex_set_index(pld, KEMPLD_VERSION_NOW1);
+
+	pld->info.major = kempld_read8(pld, KEMPLD_VERSION_NOW1);
+	pld->info.minor = 0;
+
+	pld->info.buildnr = kempld_read8(pld, KEMPLD_BUILDNR_NOW1);
+
+	pld->info.number = 0;
+	pld->info.type = 0x0;
+
+	pld->info.spec_major = 0;
+	pld->info.spec_minor = 0;
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_get_info_generic(struct kempld_device_data *pld)
+{
+	u16 data;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_VERSION);
+
+	data = kempld_read16(pld, KEMPLD_VERSION);
+	pld->info.minor = KEMPLD_VERSION_GET_MINOR(data);
+	pld->info.major = KEMPLD_VERSION_GET_MAJOR(data);
+	pld->info.number = KEMPLD_VERSION_GET_NUMBER(data);
+	pld->info.type = KEMPLD_VERSION_GET_TYPE(data);
+	pld->info.buildnr = kempld_read16(pld, KEMPLD_BUILDNR);
+
+	data = kempld_read8(pld, KEMPLD_SPEC);
+	if (data == 0xff) {
+		pld->info.spec_minor = 0;
+		pld->info.spec_major = 1;
+	} else {
+		pld->info.spec_minor = KEMPLD_SPEC_GET_MINOR(data);
+		pld->info.spec_major = KEMPLD_SPEC_GET_MAJOR(data);
+	}
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+/**
+ * kempld_get_features - retrieve features supported by device
+ * @pld: kempld_device_data structure describing the PLD
+ *
+ * This function tries to detect the features supported by the PLD device
+ */
+static int kempld_get_features(struct kempld_device_data *pld)
+{
+	if (pld->info.spec_major > 0) {
+		kempld_get_mutex_set_index(pld, KEMPLD_FEATURE);
+
+		pld->feature_mask = kempld_read16(pld, KEMPLD_FEATURE);
+
+		kempld_release_mutex(pld);
+	} else {
+		/* No way to automatically detect the features, they have to
+		 * be specified during cell registration */
+		pld->feature_mask = 0;
+	}
+
+	return 0;
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
+	if (pdata->register_cells)
+		return pdata->register_cells(pld);
+
+	dev_warn(pld->dev, "no subdevices are supported\n");
+
+	return -ENODEV;
+}
+
+static int kempld_register_cells_NOW1(struct kempld_device_data *pld)
+{
+
+	/* The NOW1 has a fixed feature set that cannot be detected */
+
+	pld->feature_mask = KEMPLD_FEATURE_BIT_WATCHDOG
+		| KEMPLD_FEATURE_BIT_GPIO;
+
+	mfd_add_devices(pld->dev, -1, &kempld_cell_NOW1_wdt,
+		1, NULL, 0, NULL);
+	dev_info(pld->dev, "registered watchdog support\n");
+
+	mfd_add_devices(pld->dev, -1, &kempld_cell_NOW1_gpio,
+		1, NULL, 0, NULL);
+	dev_info(pld->dev, "registered GPIO support\n");
+
+	return 0;
+}
+
+static int kempld_register_cells_generic(struct kempld_device_data *pld)
+{
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_I2C) {
+		mfd_add_devices(pld->dev, -1, &kempld_cell_i2c,
+			1, NULL, 0, NULL);
+		dev_info(pld->dev, "registered I2C support\n");
+	}
+
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_WATCHDOG) {
+		mfd_add_devices(pld->dev, -1, &kempld_cell_wdt,
+			1, NULL, 0, NULL);
+		dev_info(pld->dev, "registered watchdog support\n");
+	}
+
+	if (pld->feature_mask & KEMPLD_FEATURE_BIT_GPIO) {
+		mfd_add_devices(pld->dev, -1, &kempld_cell_gpio,
+			1, NULL, 0, NULL);
+		dev_info(pld->dev, "registered GPIO support\n");
+	}
+
+	if (pld->feature_mask & KEMPLD_FEATURE_MASK_UART) {
+		mfd_add_devices(pld->dev, -1, &kempld_cell_uart,
+			1, NULL, 0, NULL);
+		dev_info(pld->dev, "registered UART support\n");
+	}
+
+	return 0;
+}
+
+static int kempld_detect_device(struct kempld_device_data *pld)
+{
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	int ret;
+	u8 index_reg;
+	int lock_broken = 0;
+	char *typestring;
+
+	spin_lock_irqsave(&pld->lock, pld->lock_flags);
+
+	/* Check for empty IO space */
+	index_reg = ioread8(pld->io_index);
+	if ((index_reg == 0xff) && (ioread8(pld->io_data) == 0xff)) {
+		ret = -ENODEV;
+		spin_unlock_irqrestore(&pld->lock, pld->lock_flags);
+		goto err_empty_io;
+	}
+
+	pld->last_index = index_reg & ~KEMPLD_MUTEX_KEY;
+
+	if ((index_reg & KEMPLD_MUTEX_KEY) == 0x00) {
+		/* lock is currently not acquired by anyone else */
+		/* on some PLD revisions we now already have acquired the
+		 * mutex, so release it before continuing */
+
+		/* We have to set the index first, to be sure to have the
+		 * lock in all HW revisions */
+		iowrite8(pld->last_index, pld->io_index);
+
+		if (pdata->release_mutex)
+			pdata->release_mutex(pld);
+	}
+
+	spin_unlock_irqrestore(&pld->lock, pld->lock_flags);
+
+	/* Now really try to get the mutex, but use a timeout for the case it
+	 * doesn't work */
+	ret = kempld_try_get_mutex_set_index(pld, pld->last_index, 1000);
+	if (ret) {
+		dev_warn(pld->dev,
+			 "timeout while waiting for device semaphore\n");
+		if (force_unlock) {
+			/* We pretend to have aqcuired the lock and go on in
+			 * the hope that it was only a single error */
+			dev_warn(pld->dev,
+				 "force_unlock enabled - ignoring semaphore\n");
+			spin_lock_irqsave(&pld->lock, pld->lock_flags);
+			pld->have_mutex = 1;
+			lock_broken = 1;
+		} else
+			goto err_get_mutex;
+	}
+
+	/* Check if the mutex works as expected */
+	/* This check is left out if the lock has been broken, as it may fail
+	 * if the lock gets released in the meantime by a parallel process */
+	if (pdata->get_mutex_set_index && !lock_broken) {
+		/* pretend to not have the mutex and try to get it, which
+		 * should fail if everything works */
+		pld->have_mutex = 0;
+		if (pdata->get_mutex_set_index(pld, pld->last_index, 0)
+			!= -ETIMEDOUT) {
+			dev_err(pld->dev, "semaphore function check failed\n");
+			ret = -EIO;
+
+			/* release the mutex anyway to be sure everything is
+			 * cleaned up */
+			kempld_release_mutex(pld);
+
+			goto err_check_mutex;
+		}
+		pld->have_mutex = 1;
+	}
+
+	kempld_release_mutex(pld);
+
+	/* from here on it should be save to rely on the device semaphore */
+
+	ret = kempld_get_info(pld);
+	if (ret)
+		goto err_get_info;
+
+	switch (pld->info.type) {
+	case 0:
+		typestring = "release";
+		break;
+	case 1:
+		typestring = "debug";
+		break;
+	case 2:
+		typestring = "custom";
+		break;
+	default:
+		dev_warn(pld->dev, "PLD type not specified");
+		typestring = "unspecified";
+	}
+
+	ret = kempld_get_features(pld);
+	if (ret)
+		goto err_get_features;
+
+	dev_info(pld->dev, "found Kontron PLD %d\n", pld->info.number);
+	dev_info(pld->dev, "%s version %d.%d build %d, specification %d.%d\n",
+		 typestring, pld->info.major, pld->info.minor,
+		 pld->info.buildnr, pld->info.spec_major,
+		 pld->info.spec_minor);
+
+	ret = kempld_register_cells(pld);
+	if (ret)
+		goto err_register_functions;
+
+	return 0;
+
+err_register_functions:
+err_get_features:
+err_get_info:
+err_check_mutex:
+err_get_mutex:
+err_empty_io:
+	return ret;
+}
+
+static int kempld_probe(struct platform_device *pdev)
+{
+	struct kempld_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *ioport;
+	struct kempld_device_data *pld;
+	int ret;
+
+	dev_dbg(&pdev->dev, "probing for Kontron PLD on %s\n",
+		 pdata->board_id->ident);
+
+	pld = kzalloc(sizeof(struct kempld_device_data), GFP_KERNEL);
+	if (pld == NULL) {
+		dev_err(&pdev->dev, "unable to get memory for device data\n");
+		ret = -ENOMEM;
+		goto err_alloc_dev_data;
+	}
+
+	ioport = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!ioport) {
+		ret = -EINVAL;
+		goto err_get_resource;
+	}
+
+	pld->io_base = ioport_map(ioport->start, ioport->end - ioport->start);
+	if (!pld->io_base) {
+		ret = -ENOMEM;
+		goto err_iomap;
+	}
+
+	pld->io_index = pld->io_base;
+	pld->io_data = pld->io_base + 1;
+
+	pld->pld_clock = pdata->pld_clock;
+
+	spin_lock_init(&pld->lock);
+
+	pld->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, pld);
+
+	ret = kempld_detect_device(pld);
+	if (ret)
+		goto err_detect_device;
+
+	return 0;
+
+err_detect_device:
+	ioport_unmap(pld->io_base);
+err_iomap:
+err_get_resource:
+	kfree(pld);
+err_alloc_dev_data:
+	return ret;
+}
+
+static int kempld_remove(struct platform_device *pdev)
+{
+	struct kempld_device_data *pld = platform_get_drvdata(pdev);
+
+	if (pld->have_mutex)
+		kempld_release_mutex(pld);
+
+	mfd_remove_devices(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+
+	ioport_unmap(pld->io_base);
+
+	kfree(pld);
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
+static int kempld_platform_device_register(const struct dmi_system_id *id)
+{
+	struct platform_device *pdev;
+	static struct resource resource[1];
+	int ret = 0;
+
+	/* check if we already registered a kempld platform device,
+	 * there can only be one */
+	if (kempld_pdev != NULL) {
+		ret = -EINVAL;
+		goto err_device_already_registered;
+	}
+
+	/* use the generic platform data unless something else is specified */
+	if (id->driver_data != NULL)
+		memcpy(&kempld_platform_data, id->driver_data,
+			sizeof(kempld_platform_data));
+	else
+		memcpy(&kempld_platform_data, &kempld_platform_data_generic,
+			sizeof(kempld_platform_data));
+
+
+	pdev = platform_device_alloc("kempld", -1);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto err_device_alloc_failed;
+	}
+
+	kempld_platform_data.board_id = id;
+
+	ret = platform_device_add_data(pdev, &kempld_platform_data,
+					sizeof(kempld_platform_data));
+	if (ret)
+		goto err_add_data_failed;
+
+	resource[0].start = kempld_platform_data.ioport;
+	resource[0].end   = kempld_platform_data.ioport + 1;
+	resource[0].flags = IORESOURCE_IO;
+
+	ret = platform_device_add_resources(pdev, resource, 1);
+	if (ret)
+		goto err_device_add_resources;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto err_device_register_failed;
+
+	kempld_pdev = pdev;
+
+	return 0;
+
+err_device_register_failed:
+err_device_add_resources:
+err_add_data_failed:
+	platform_device_put(pdev);
+err_device_alloc_failed:
+err_device_already_registered:
+	return ret;
+}
+
+static int __init kempld_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&kempld_driver);
+	if (ret)
+		goto err_platform_driver_register;
+
+	/* check force parameter if a specific implementation should be
+	 * probed */
+	if (force_ident[0]) {
+		int found = 0;
+		const struct dmi_system_id *d;
+		for (d = kempld_boardids; d->matches[0].slot != DMI_NONE; d++)
+			if (strstr(d->ident, force_ident)) {
+				found++;
+				if (d->callback && d->callback(d))
+					break;
+			}
+
+		if (!found)
+			goto err_device_not_found;
+
+		return 0;
+	}
+
+	/* try to autodetect the board */
+	if (dmi_check_system(kempld_boardids))
+		return 0;
+
+err_device_not_found:
+	platform_driver_unregister(&kempld_driver);
+	ret = -ENODEV;
+err_platform_driver_register:
+	return ret;
+}
+
+static void __exit kempld_exit(void)
+{
+	/* unregister device first */
+	if (kempld_pdev) {
+		platform_device_unregister(kempld_pdev);
+		kempld_pdev = NULL;
+	}
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
index 0000000..58ebba5
--- /dev/null
+++ b/include/linux/mfd/kempld.h
@@ -0,0 +1,152 @@
+/*
+ *  linux/mfd/kempld.h - Kontron PLD driver definitions
+ *
+ *  Copyright (c) 2010-2012 Kontron Europe GmbH
+ *  Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _LINUX_MFD_KEMPLD_H_
+#define _LINUX_MFD_KEMPLD_H_
+
+/* COMe-mSP1 (nanoETXexpress) specific definitions */
+#define KEMPLD_VERSION_NOW1	0x00
+#define KEMPLD_BUILDNR_NOW1	0x02
+
+/* generic register definitions */
+#define KEMPLD_MUTEX_KEY	0x80
+#define KEMPLD_VERSION		0x00
+#define		KEMPLD_VERSION_LSB		0x00
+#define		KEMPLD_VERSION_MSB		0x01
+#define		KEMPLD_VERSION_GET_MINOR(x)	(x & 0x1f)
+#define		KEMPLD_VERSION_GET_MAJOR(x)	((x >> 5) & 0x1f)
+#define		KEMPLD_VERSION_GET_NUMBER(x)	((x >> 10) & 0xf)
+#define		KEMPLD_VERSION_GET_TYPE(x)	((x >> 14) & 0x3)
+#define KEMPLD_BUILDNR		0x02
+#define		KEMPLD_BUILDNR_LSB		0x02
+#define		KEMPLD_BUILDNR_MSB		0x03
+#define KEMPLD_FEATURE		0x04
+#define		KEMPLD_FEATURE_LSB		0x04
+#define		KEMPLD_FEATURE_MSB		0x05
+#define		KEMPLD_FEATURE_BIT_I2C		(1 << 0)
+#define		KEMPLD_FEATURE_BIT_WATCHDOG	(1 << 1)
+#define		KEMPLD_FEATURE_BIT_GPIO		(1 << 2)
+#define		KEMPLD_FEATURE_MASK_UART	(7 << 3)
+#define		KEMPLD_FEATURE_BIT_NMI		(1 << 8)
+#define		KEMPLD_FEATURE_BIT_SMI		(1 << 9)
+#define		KEMPLD_FEATURE_BIT_SCI		(1 << 10)
+#define KEMPLD_SPEC		0x06
+#define		KEMPLD_SPEC_GET_MINOR(x)	(x & 0x0f)
+#define		KEMPLD_SPEC_GET_MAJOR(x)	((x >> 4) & 0x0f)
+#define KEMPLD_IRQ_GPIO				0x35
+#define KEMPLD_IRQ_I2C				0x36
+#define KEMPLD_CFG				0x37
+#define		KEMPLD_CFG_GPIO_I2C_MUX		(1<<0)
+#define		KEMPLD_CFG_BIOS_WP		(1<<7)
+
+#define	KEMPLD_TYPE_RELEASE	0x0
+#define	KEMPLD_TYPE_DEBUG	0x1
+#define	KEMPLD_TYPE_CUSTOM	0x2
+
+#define KEMPLD_MUTEX_NOTIMEOUT			((unsigned int)~0)
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
+ * @lock:		PLD spin-lock
+ * @lock_flags:		PLD spin-lock flags
+ * @have_mutex:		Bool value that indicates if mutex is aquired
+ * @last_index:		Last written index value
+ * @dev:		Pointer to kernel device structure
+ * @info:		KEMPLD info structure
+ */
+struct kempld_device_data {
+	void __iomem		*io_base;
+	void __iomem		*io_index;
+	void __iomem		*io_data;
+	u32			pld_clock;
+	u32			feature_mask;
+	spinlock_t		lock;
+	unsigned long		lock_flags;
+	int			have_mutex;
+	u8			last_index;
+	struct device		*dev;
+	struct kempld_info	info;
+};
+
+/**
+ * struct kempld_platform_data - PLD hardware configuration structure
+ * @pld_clock:		 PLD clock frequency
+ * @ioport:		 IO address of the PLD
+ * @force_index_write:	 Force writing the index register on every access
+ * @board_id:		 Board system ID structure
+ * @release_mutex:	 Pointer to PLD specific release_mutex function
+ * @get_mutex_set_index: Pointer to PLD specific get_mutex_set_index function
+ * @get_info:		 Pointer to PLD specific get_info function
+ * @register_cells:	 Pointer to PLD specific register_cells function
+ *
+ * This structure configures the PLD settings for a specific hardware platform.
+ */
+struct kempld_platform_data {
+	u32				pld_clock;
+	u32				ioport;
+	int				force_index_write;
+	const struct dmi_system_id	*board_id;
+	void (*release_mutex)(struct kempld_device_data *);
+	int (*get_mutex_set_index)(struct kempld_device_data *, u8,
+					unsigned int);
+	int (*get_info)(struct kempld_device_data *);
+	int (*register_cells)(struct kempld_device_data *);
+};
+
+extern void kempld_set_index(struct kempld_device_data *pld, u8 index);
+extern void kempld_get_mutex_set_index(struct kempld_device_data *pld,
+					u8 index);
+extern int kempld_try_get_mutex_set_index(struct kempld_device_data *pld,
+					u8 index, unsigned int timeout);
+extern void kempld_release_mutex(struct kempld_device_data *pld);
+
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

