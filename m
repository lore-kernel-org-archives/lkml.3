Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3CXCSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 22:18:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50266 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3CXCSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 22:18:20 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 23 Mar 2013 10:49:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: mfd: Core driver for Winbond chips
Message-ID: <20130323174914.GA21563@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <20130322205258.GE7867@spo001.leaseweb.com>
 <20130323002810.GA26245@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323002810.GA26245@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD core driver for various variants of Winbond/Nuvoton SuperIO chips.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/Kconfig          |   22 +++
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/w83627hf-core.c  |  324 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/w83627hf.h |  131 +++++++++++++++++
 4 files changed, 478 insertions(+)
 create mode 100644 drivers/mfd/w83627hf-core.c
 create mode 100644 include/linux/mfd/w83627hf.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..a141ef6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1119,6 +1119,28 @@ config MFD_AS3711
 	help
 	  Support for the AS3711 PMIC from AMS
 
+config MFD_W83627HF
+	tristate "Winbond W83627HF and compatibles"
+	select MFD_CORE
+	help
+	  If you say yes here you add support for the Winbond W836X7 and Nuvoton
+	  NCT677X series of super-IO chips. The following chips are supported:
+		W83627F/HF/G/HG/DHG/DHG-P/EHF/EHG/S/SF/THF/UHG/UG
+		W83637HF
+		W83667HG/HG-B
+		W83687THF
+		W83697HF
+		NCT6775
+		NCT6776
+		NCT6779
+
+	  This is a multi functional device and this support defines a new
+	  platform device only. See other configuration submenus in order to
+	  enable the drivers of Winbond chip's functionalities.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called w83627hf-core.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..3e9e830 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
+obj-$(CONFIG_MFD_W83627HF)	+= w83627hf-core.o
 
 obj-$(CONFIG_MCP)		+= mcp-core.o
 obj-$(CONFIG_MCP_SA11X0)	+= mcp-sa11x0.o
diff --git a/drivers/mfd/w83627hf-core.c b/drivers/mfd/w83627hf-core.c
new file mode 100644
index 0000000..d0be5b9
--- /dev/null
+++ b/drivers/mfd/w83627hf-core.c
@@ -0,0 +1,324 @@
+/*
+ *  w83627hf.c - platform device support
+ *
+ *  Copyright (c) 2013 Guenter Roeck <linux@roeck-us.net>
+ *
+ *  Based on earlier work by Rodolfo Giometti
+ *
+ *  Copyright (c) 2009-2011 Rodolfo Giometti <giometti@linux.it>
+ *
+ *  Based on drivers/hwmon/w83627hf.c
+ *
+ *  Original copyright note:
+ *    Copyright (c) 1998 - 2003  Frodo Looijaard <frodol@dds.nl>,
+ *    Philip Edelbrock <phil@netroedge.com>,
+ *    and Mark Studebaker <mdsxyz123@yahoo.com>
+ *    Ported to 2.6 by Bernhard C. Schrenk <clemy@clemy.org>
+ *    Copyright (c) 2007  Jean Delvare <khali@linux-fr.org>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/ioport.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/w83627hf.h>
+
+static unsigned short force_id;
+module_param(force_id, ushort, 0);
+MODULE_PARM_DESC(force_id, "Override the detected device ID");
+
+/*
+ * Devices definitions
+ */
+
+static struct platform_device *pdev;
+
+struct w83627hf_chip_data {
+	const char * const name;
+	const char * const chip;
+	const char * const hwmon_drvname;
+};
+
+static const struct w83627hf_chip_data w83627hf_chip_data[] = {
+	[w83627hf] = {
+		.name = __stringify(w83627hf),
+		.chip = "W83627HF",
+		.hwmon_drvname = W83627HF_HWMON_DRVNAME,
+	},
+	[w83627s] = {
+		.name = __stringify(w83627s),
+		.chip = "W83627S",
+	},
+	[w83627thf] = {
+		.name = __stringify(w83627thf),
+		.chip = "W83627THF",
+		.hwmon_drvname = W83627HF_HWMON_DRVNAME,
+	},
+	[w83697hf] = {
+		.name = __stringify(w83697hf),
+		.chip = "W83697HF",
+		.hwmon_drvname = W83627HF_HWMON_DRVNAME,
+	},
+	[w83697ug] = {
+		.name = __stringify(w83697ug),
+		.chip = "W83697SF/UG",
+	},
+	[w83637hf] = {
+		.name = __stringify(w83637hf),
+		.chip = "W83637HF",
+		.hwmon_drvname = W83627HF_HWMON_DRVNAME,
+	},
+	[w83687thf] = {
+		.name = __stringify(w83687thf),
+		.chip = "W83687THF",
+		.hwmon_drvname = W83627HF_HWMON_DRVNAME,
+	},
+	[w83627ehf] = {
+		.name = __stringify(w83627ehf),
+		.chip = "W83627EHF",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[w83627dhg] = {
+		.name = __stringify(w83627dhg),
+		.chip = "W83627DHG",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[w83627dhg_p] = {
+		.name = __stringify(w83627dhg),
+		.chip = "W83627DHG-P",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[w83627uhg] = {
+		.name = __stringify(w83627uhg),
+		.chip = "W83627UHG",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[w83667hg] = {
+		.name = __stringify(w83667hg),
+		.chip = "W83667HG",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[w83667hg_b] = {
+		.name = __stringify(w83667hg),
+		.chip = "W83667HG-B",
+		.hwmon_drvname = W83627EHF_HWMON_DRVNAME,
+	},
+	[nct6775] = {
+		.name = __stringify(nct6775),
+		.chip = "NCT6775",
+		.hwmon_drvname = NCT6775_HWMON_DRVNAME,
+	},
+	[nct6776] = {
+		.name = __stringify(nct6776),
+		.chip = "NCT6776",
+		.hwmon_drvname = NCT6775_HWMON_DRVNAME,
+	},
+	[nct6779] = {
+		.name = __stringify(nct6779),
+		.chip = "NCT6779",
+		.hwmon_drvname = NCT6775_HWMON_DRVNAME,
+	},
+};
+
+#define MFD_NUM_CELLS	2
+
+static struct mfd_cell mfd_cells[MFD_NUM_CELLS];
+
+#define W83627HF_CR_DEVID	0x20
+
+#define W83627HF_G_DEVID	0x5210
+#define W83627HF_J_DEVID	0x5230
+#define W83627HF_UD_DEVID	0x5240
+#define W83627S_DEVID		0x5950
+#define W83627THF_DEVID		0x8280
+#define W83697HF_DEVID		0x6010
+#define W83697SF_DEVID		0x6800
+#define W83697UG_DEVID		0x6810
+#define W83637HF_DEVID		0x7080
+#define W83687THF_DEVID		0x8540
+#define W83627EHF_DEVID		0x8850
+#define W83627EHG_DEVID		0x8860
+#define W83627DHG_DEVID		0xa020
+#define W83627DHG_P_DEVID	0xb070
+#define W83627UHG_DEVID		0xa230
+#define W83667HG_DEVID		0xa510
+#define W83667HG_B_DEVID	0xb350
+#define NCT6775_DEVID		0xb470
+#define NCT6776_DEVID		0xc330
+#define NCT6779_DEVID		0xc560
+
+#define DEVID_MASK		0xfff0
+
+static int __init w83627hf_find(int sioaddr,
+				struct w83627hf_platform_data *pdata)
+{
+	int err = 0;
+	u16 val;
+
+	err = superio_enter(sioaddr);
+	if (err)
+		return err;
+
+	val = force_id ? : ((superio_inb(sioaddr, W83627HF_CR_DEVID) << 8) |
+			    superio_inb(sioaddr, W83627HF_CR_DEVID + 1));
+
+	switch (val & DEVID_MASK) {
+	case W83627HF_G_DEVID:
+	case W83627HF_J_DEVID:
+	case W83627HF_UD_DEVID:
+		pdata->type = w83627hf;
+		break;
+	case W83627S_DEVID:
+		pdata->type = w83627s;
+		break;
+	case W83627THF_DEVID:
+		pdata->type = w83627thf;
+		break;
+	case W83697HF_DEVID:
+		pdata->type = w83697hf;
+		break;
+	case W83697SF_DEVID:
+	case W83697UG_DEVID:
+		pdata->type = w83697ug;
+		break;
+	case W83637HF_DEVID:
+		pdata->type = w83637hf;
+		break;
+	case W83687THF_DEVID:
+		pdata->type = w83687thf;
+		break;
+	case W83627EHF_DEVID:
+	case W83627EHG_DEVID:
+		pdata->type = w83627ehf;
+		break;
+	case W83627DHG_DEVID:
+		pdata->type = w83627dhg;
+		break;
+	case W83627DHG_P_DEVID:
+		pdata->type = w83627dhg_p;
+		break;
+	case W83627UHG_DEVID:
+		pdata->type = w83627uhg;
+		break;
+	case W83667HG_DEVID:
+		pdata->type = w83667hg;
+		break;
+	case W83667HG_B_DEVID:
+		pdata->type = w83667hg_b;
+		break;
+	case NCT6775_DEVID:
+		pdata->type = nct6775;
+		break;
+	case NCT6776_DEVID:
+		pdata->type = nct6776;
+		break;
+	case NCT6779_DEVID:
+		pdata->type = nct6779;
+		break;
+	case 0xfff0:	/* No device at all */
+		err = -ENODEV;
+		goto exit;
+	default:
+		err = -ENODEV;
+		pr_debug("Unsupported chip (DEVID=0x%04x)\n", val);
+		goto exit;
+	}
+	pdata->sioaddr = sioaddr;
+	pdata->name = w83627hf_chip_data[pdata->type].name;
+	pr_info("Found %s at %#x\n", w83627hf_chip_data[pdata->type].chip,
+		sioaddr);
+exit:
+	superio_exit(sioaddr);
+	return err;
+}
+
+static int __init w83627hf_device_add(struct w83627hf_platform_data *pdata)
+{
+	int err;
+	int cells = 0;
+
+	pdev = platform_device_alloc(W83627HF_CORE_DRVNAME, 0);
+	if (!pdev)
+		return -ENOMEM;
+
+	err = platform_device_add_data(pdev, pdata,
+				       sizeof(struct w83627hf_platform_data));
+	if (err)
+		goto exit_device_put;
+
+	if (w83627hf_chip_data[pdata->type].hwmon_drvname) {
+		mfd_cells[cells].name =
+		  w83627hf_chip_data[pdata->type].hwmon_drvname;
+		cells++;
+	}
+
+	mfd_cells[cells].name = W83627HF_WDT_DRVNAME;
+	cells++;
+
+	err = platform_device_add(pdev);
+	if (err)
+		goto exit_device_put;
+
+	err = mfd_add_devices(&pdev->dev, pdev->id, mfd_cells, cells,
+			      NULL, -1, NULL);
+	if (err)
+		goto exit_device_unregister;
+
+	return 0;
+
+exit_device_unregister:
+	platform_device_unregister(pdev);
+exit_device_put:
+	platform_device_put(pdev);
+	return err;
+}
+
+static int __init w83627hf_init(void)
+{
+	struct w83627hf_platform_data pdata;
+	int ret;
+
+	ret = w83627hf_find(0x2e, &pdata);
+	if (ret) {
+		ret = w83627hf_find(0x4e, &pdata);
+		if (ret)
+			return -ENODEV;
+	}
+
+	/* Sets global pdev as a side effect */
+	return w83627hf_device_add(&pdata);
+}
+
+static void __exit w83627hf_exit(void)
+{
+	mfd_remove_devices(&pdev->dev);
+	platform_device_unregister(pdev);
+}
+
+MODULE_AUTHOR("Guenter Roeck <linux@roeck-us.net>");
+MODULE_DESCRIPTION("W83627HF multi-function core driver");
+MODULE_LICENSE("GPL");
+
+module_init(w83627hf_init);
+module_exit(w83627hf_exit);
diff --git a/include/linux/mfd/w83627hf.h b/include/linux/mfd/w83627hf.h
new file mode 100644
index 0000000..6379126
--- /dev/null
+++ b/include/linux/mfd/w83627hf.h
@@ -0,0 +1,131 @@
+/*
+ *  w83627hf.h - platform device support, header file
+ *  Copyright (c) 2009 Rodolfo Giometti <giometti@linux.it>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/mutex.h>
+#include <linux/io.h>
+
+#define W83627HF_CORE_DRVNAME "w83627hf_core"
+#define W83627HF_HWMON_DRVNAME "w83627hf_hwmon"
+#define W83627EHF_HWMON_DRVNAME "w83627ehf_hwmon"
+#define NCT6775_HWMON_DRVNAME "nct6775_hwmon"
+
+#define W83627HF_WDT_DRVNAME	"w83627hf_wdt"
+
+enum chips {
+	w83627hf,
+	w83627s,
+	w83627thf,
+	w83697hf,
+	w83697ug,
+	w83637hf,
+	w83687thf,
+	w83627ehf,
+	w83627dhg,
+	w83627dhg_p,
+	w83627uhg,
+	w83667hg,
+	w83667hg_b,
+	nct6775,
+	nct6776,
+	nct6779,
+};
+
+struct w83627hf_platform_data {
+	int sioaddr;
+	enum chips type;
+	const char *name;
+};
+
+#define W83627HF_SELECT		0x07
+
+/* logical device numbers for superio_select */
+#define W83627HF_LD_FDC		0x00
+#define W83627HF_LD_PRT		0x01
+#define W83627HF_LD_UART1	0x02
+#define W83627HF_LD_UART2	0x03
+#define W83627HF_LD_KBC		0x05
+#define W83627HF_LD_CIR		0x06 /* w83627hf only */
+#define W83627HF_LD_GAME	0x07
+#define W83627HF_LD_MIDI	0x07
+#define W83627HF_LD_GPIO1	0x07
+#define W83627HF_LD_GPIO5	0x07 /* w83627thf only */
+#define W83627HF_LD_GPIO2	0x08
+#define W83627HF_LD_WDT		0x08
+#define W83627HF_LD_GPIO3	0x09
+#define W83627HF_LD_GPIO4	0x09 /* w83627thf only */
+#define W83627HF_LD_ACPI	0x0a
+#define W83627HF_LD_HWM		0x0b
+
+#define W83627HF_CR_ENABLE	0x30	/* Logical device enable register */
+
+#define W83627THF_GPIO5_IOSR	0xf3 /* w83627thf only */
+#define W83627THF_GPIO5_DR	0xf4 /* w83627thf only */
+
+#define W83687THF_VID_EN	0x29 /* w83687thf only */
+#define W83687THF_VID_CFG	0xF0 /* w83687thf only */
+#define W83687THF_VID_DATA	0xF1 /* w83687thf only */
+
+/*
+ * Common configuration registers access functions.
+ *
+ * These registers are special and they must me accessed by using a well
+ * specified protocol. Client drivers __must__ do as follow in order to
+ * get access correctly to these registers:
+ *
+ *	superio_enter()
+ *	superio_select()/superio_outb()/superio_inb()
+ *	suprio_exit();
+ *
+ */
+
+static inline int superio_enter(int sioaddr)
+{
+	if (!request_muxed_region(sioaddr, 2, KBUILD_MODNAME))
+		return -EBUSY;
+
+	outb(0x87, sioaddr);
+	outb(0x87, sioaddr);
+
+	return 0;
+}
+
+static inline void superio_select(int sioaddr, int ld)
+{
+	outb(W83627HF_SELECT, sioaddr);
+	outb(ld, sioaddr + 1);
+}
+
+static inline void superio_outb(int sioaddr, int reg, int val)
+{
+	outb(reg, sioaddr);
+	outb(val, sioaddr + 1);
+}
+
+static inline int superio_inb(int sioaddr, int reg)
+{
+	outb(reg, sioaddr);
+	return inb(sioaddr + 1);
+}
+
+static inline void superio_exit(int sioaddr)
+{
+	outb(0xAA, sioaddr);
+
+	release_region(sioaddr, 2);
+}
-- 
1.7.9.7

