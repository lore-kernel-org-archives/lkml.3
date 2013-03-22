Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118Ab3CVVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:09:28 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40315 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422967Ab3CVVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:09:26 -0400
Date: Fri, 22 Mar 2013 22:09:25 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: [RFC] winbond Super-I/O MFD driver
Message-ID: <20130322210925.GA8418@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net> <20130322205258.GE7867@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130322205258.GE7867@spo001.leaseweb.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As said in previous mail, I would post my old
development code for the winbond super-I/O MFD
device. It's development code and it definitely
can be improved. Goal at this point is to see
which direction we should take (with super-i/o
device drivers in general imho).

Kind regards,
Wim.
---
commit dc8987180ad87da86740448f033b8cfe46ea90dd
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Mar 22 22:02:16 2013 +0100

    Sample Winbond Super-I/O MFD device consisting out of
    a lowel-level driver that does the detection and creates
    the platform-data and a watchdog driver.

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..943399f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1119,6 +1119,14 @@ config MFD_AS3711
 	help
 	  Support for the AS3711 PMIC from AMS
 
+config MFD_SIO_WINBOND
+	tristate "Winbond SuperIO chips"
+	select MFD_CORE
+	depends on X86
+	help
+	  Say yes here to enable support for various functions of the
+	  Winbond Super IO chipsets.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..3c7673b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
+obj-$(CONFIG_MFD_SIO_WINBOND)	+= winbond-superio.o
diff --git a/drivers/mfd/winbond-superio.c b/drivers/mfd/winbond-superio.c
new file mode 100644
index 0000000..dccb633
--- /dev/null
+++ b/drivers/mfd/winbond-superio.c
@@ -0,0 +1,327 @@
+/*
+    winbond_superio.c - Driver for Winbond Super-I/O chipsets.
+
+    (c) Copyright 2013 Wim Van Sebroeck <wim@iguana.be>.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+/*
+    Supports following chips:
+
+	Chip        id      rev
+	w83627hf    0x52    0x??
+	w83627hg    0x52    0x17
+	w83627hj    0x52    0x3A
+	w83627ud-a  0x52    0x41
+	w83627sf    0x59    0x5X
+	w83697hf    0x60    0x1X
+	w83697f     0x60    0x1X
+	w83697sf    0x68    0x0X,0x1X
+	w83697uf    0x68    0x1X
+	w83637hf    0x70    0x8X
+	w83627thf   0x82    0x83
+	w83687thf   0x85    0x??
+	w83627ehf   0x88    0x5X
+	w83627ehf   0x88    0x6X
+	w83627dhg   0xA0    0x2X
+	w83627uhg   0xA2    0x3X
+	w83667hg    0xA5    0x1X
+	w83627dhg-p 0xB0    0x7X
+	w83667hg-b  0xB3    0x5X
+	nct6775f    0xB4    0x7X
+	nct6776f    0xC3    0x3X
+	nct6779f    0xC5    0x6X
+*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/ioport.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/mfd/superio.h>
+#include <linux/mfd/winbond_superio.h>
+
+static struct platform_device *pdev;
+
+enum chips {
+		w83627hf,
+		w83627hg,
+		w83627hj,
+		w83627uda,
+		w83627sf,
+		w83697hf,
+/*		w83697f, */
+		w83697sf,
+		w83697uf,
+		w83637hf,
+		w83687thf,
+		w83627ehf,
+		w83627ehg,
+		w83627thf,
+		w83627dhg,
+		w83627uhg,
+		w83667hg,
+		w83627dhgp,
+		w83667hgb,
+		nct6775,
+		nct6776,
+		nct6779,
+};
+
+static DEFINE_SPINLOCK(iolock);
+
+static unsigned short force_id;
+module_param(force_id, ushort, 0);
+MODULE_PARM_DESC(force_id, "Override the detected device ID");
+
+inline void winbond_superio_enter(int ioreg)
+{
+	spin_lock(&iolock);
+	outb(0x87, ioreg);
+	outb(0x87, ioreg);
+}
+EXPORT_SYMBOL_GPL(winbond_superio_enter);
+
+inline void winbond_superio_exit(int ioreg)
+{
+	outb(0xAA, ioreg);
+	spin_unlock(&iolock);
+}
+EXPORT_SYMBOL_GPL(winbond_superio_exit);
+
+static int __init winbond_add_watchdog(
+				const struct winbond_sio_data *sio_data)
+{
+	struct resource res = {
+		.start	= sio_data->ioreg,
+		.end	= sio_data->ioreg + WINB_REGION_SIZE - 1,
+		.name	= "winbond_wdt",
+		.flags	= IORESOURCE_IO,
+	};
+	struct winbond_wdt_pdata wdt_pdata;
+	int err;
+
+	if (!request_region(res.start, WINB_REGION_SIZE, "winbond_superio")) {
+		pr_err("Failed to request region 0x%lx-0x%lx\n",
+			(unsigned long)res.start,
+			(unsigned long)res.end);
+		err = -EBUSY;
+		goto exit;
+	}
+
+	wdt_pdata.siodata.ioreg = sio_data->ioreg;
+	wdt_pdata.siodata.id = sio_data->id;
+
+	pdev = platform_device_register_resndata(NULL, "winbond_wdt", -1,
+			&res, 1, &wdt_pdata, sizeof(struct winbond_wdt_pdata));
+	if (IS_ERR(pdev)) {
+		err = PTR_ERR(pdev);
+		goto exit_release;
+	}
+
+	return 0;
+
+exit_release:
+	release_region(res.start, WINB_REGION_SIZE);
+exit:
+	return err;
+}
+
+static int __init winbond_sio_find(int sioaddr, 
+					struct winbond_sio_data *sio_data)
+{
+	int err = -ENODEV;
+	enum chips type;
+	u16 val;
+
+	static const __initdata char *names[] = {
+		"W83627HF",
+		"W83627HG",
+		"W83627HJ",
+		"W83627UD-A",
+		"W83627SF",
+		"W83697HF",
+/*		"W83697F",*/
+		"W83697SF",
+		"W83697UF",
+		"W83637HF",
+		"W83687THF",
+		"W83627EHF",
+		"W83627EHF",
+		"W83627THF",
+		"W83627DHG",
+		"W83627UHG",
+		"W83667HG",
+		"W83627DHG-P",
+		"W83667HG-B",
+		"NCT6775",
+		"NCT6776",
+		"NCT6779",
+	};
+
+	winbond_superio_enter(sioaddr);
+	if (force_id)
+		val = force_id;
+	else {
+		val = (superio_inb(sioaddr, SIO_REG_DEVID) << 8)
+			| superio_inb(sioaddr, SIO_REG_DEVID + 1);
+	}
+	sio_data->id = val & SIO_ID_MASK;
+	switch (val & SIO_ID_MASK) {
+	case SIO_W83627SF_ID:	/* 0x595X */
+		type = w83627sf;
+		break;
+	case SIO_W83697HF_ID:	/* 0x601X */
+		type = w83697hf;
+		break;
+	case SIO_W83697SF_ID:	/* 0x680X */
+		type = w83697sf;
+		break;
+	case SIO_W83697UF_ID:	/* 0x681X */
+		type = w83697uf;
+		break;
+	case SIO_W83637HF_ID:	/* 0x708X */
+		type = w83637hf;
+		break;
+	case SIO_W83627THF_ID:	/* 0x8283 */
+		type = w83627thf;
+		break;
+	case SIO_W83627EHF_ID:	/* 0x885X */
+		type = w83627ehf;
+		break;
+	case SIO_W83627EHG_ID:	/* 0x886X */
+		type = w83627ehg;
+		break;
+	case SIO_W83627DHG_ID:	/* 0xA02X */
+		type = w83627dhg;
+		break;
+	case SIO_W83627UHG_ID:	/* 0xA23X */
+		type = w83627uhg;
+		break;
+	case SIO_W83667HG_ID:	/* 0xA51X */
+		type = w83667hg;
+		break;
+	case SIO_W83627DHG_P_ID:/* 0xB07X */
+		type = w83627dhgp;
+		break;
+	case SIO_W83667HG_B_ID:	/* 0xB35X */
+		type = w83667hgb;
+		break;
+	case SIO_NCT6775_ID:	/* 0xB47X */
+		type = nct6775;
+		break;
+	case SIO_NCT6776_ID:	/* 0xC33X */
+		type = nct6776;
+		break;
+	case SIO_NCT6779_ID:	/* 0xC56X */
+		type = nct6779;
+		break;
+	default:
+		switch ((val >> 8) & 0xFF) {
+		case 0x52:	/* 0x52XX */
+			switch (val & 0xFF) {
+			case 0x17:
+				type = w83627hg;
+				sio_data->id = SIO_W83627HG_ID;
+				break;
+			case 0x3A:
+				type = w83627hj;
+				sio_data->id = SIO_W83627HJ_ID;
+				break;
+			case 0x41:
+				type = w83627uda;
+				sio_data->id = SIO_W83627UD_A_ID;
+				break;
+			default:
+				type = w83627hf;
+				sio_data->id = SIO_W83627HF_ID;
+			}
+			break;
+		case 0x85:	/* 0x85XX */
+			type = w83687thf;
+			sio_data->id = SIO_W83687THF_ID;
+			break;
+		case 0xff:	/* No device at all */
+			sio_data->id = 0;
+			goto exit;
+		default:
+			sio_data->id = val;
+			pr_debug("Unsupported chip (ID=0x%04x)\n", val);
+			goto exit;
+		}
+	}
+	sio_data->ioreg = sioaddr;
+	pr_info("Found %s chip\n", names[type]);
+	err = 0;
+ exit:
+	winbond_superio_exit(sioaddr);
+	return err;
+}
+
+static int __init init_winbond_superio(void)
+{
+	int err;
+	struct winbond_sio_data sio_data;
+
+	if (winbond_sio_find(0x2e, &sio_data)
+	 && winbond_sio_find(0x4e, &sio_data))
+		return -ENODEV;
+
+	switch (sio_data.id) {
+	case SIO_W83627HF_ID:
+	case SIO_W83627HG_ID:
+	case SIO_W83627HJ_ID:
+	case SIO_W83627UD_A_ID:
+	case SIO_W83627SF_ID:
+	case SIO_W83697HF_ID:
+	case SIO_W83697SF_ID:
+	case SIO_W83697UF_ID:
+	case SIO_W83637HF_ID:
+	case SIO_W83627THF_ID:
+	case SIO_W83627EHF_ID:
+	case SIO_W83627EHG_ID:
+	case SIO_W83627DHG_ID:
+	case SIO_W83627UHG_ID:
+	case SIO_W83627DHG_P_ID:
+		err = winbond_add_watchdog(&sio_data);
+		if (err)
+			goto exit;
+	}
+
+	return 0;
+
+exit:
+	return err;
+}
+module_init(init_winbond_superio);
+
+static void __exit exit_winbond_superio(void)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+
+	platform_device_unregister(pdev);
+	release_region(res->start, WINB_REGION_SIZE);
+}
+module_exit(exit_winbond_superio);
+
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("Winbond SuperIO Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9fcc70c..6886adb 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -927,6 +927,18 @@ config W83977F_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called w83977f_wdt.
 
+config WINBOND_WDT
+	tristate "Winbond Watchdog Timer"
+	depends on X86
+	select WINBOND_SIO
+	select WATCHDOG_CORE
+	---help---
+	  This is the driver for the hardware watchdog on the Winbond Super I/O
+	  chipsets.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called winbond_wdt.
+
 config MACHZ_WDT
 	tristate "ZF MachZ Watchdog"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index a300b94..fb46d37 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
 obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
 obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
+obj-$(CONFIG_WINBOND_WDT) += winbond_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
diff --git a/drivers/watchdog/winbond_wdt.c b/drivers/watchdog/winbond_wdt.c
new file mode 100644
index 0000000..64487e2
--- /dev/null
+++ b/drivers/watchdog/winbond_wdt.c
@@ -0,0 +1,284 @@
+/*
+ *	Winbond(TM) Watch Dog Timer driver
+ *
+ *	(c) Copyright 2003,2007 Pádraig Brady <P@draigBrady.com>
+ *	(c) Copyright 2013 Wim Van Sebroeck <wim@iguana.be>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/superio.h>
+#include <linux/mfd/winbond_superio.h>
+
+#define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
+static unsigned int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
+static int early_disable = WATCHDOG_EARLY_DISABLE;
+module_param(early_disable, int, 0);
+MODULE_PARM_DESC(early_disable,
+	"Watchdog gets disabled at boot time (default="
+				__MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
+
+static void winbond_wdt_set_timer(struct winbond_wdt_pdata *wdt_pdata,
+							unsigned char timeout)
+{
+	unsigned char val;
+	int ioreg = wdt_pdata->siodata.ioreg;
+
+	winbond_superio_enter(ioreg);
+	superio_select(ioreg, 0x08);
+	superio_outb(ioreg, wdt_pdata->wdt_counter_reg, timeout);
+	winbond_superio_exit(ioreg);
+}
+
+static int winbond_wdt_start(struct watchdog_device *wdd)
+{
+	struct winbond_wdt_pdata *wdt_pdata = watchdog_get_drvdata(wdd);
+
+	winbond_wdt_set_timer(wdt_pdata, wdd->timeout);
+	return 0;
+}
+
+static int winbond_wdt_stop(struct watchdog_device *wdd)
+{
+	struct winbond_wdt_pdata *wdt_pdata = watchdog_get_drvdata(wdd);
+
+	winbond_wdt_set_timer(wdt_pdata, 0x00);
+	return 0;
+}
+
+static int winbond_wdt_set_timeout(struct watchdog_device *wdd,
+							unsigned int t)
+{
+	wdd->timeout = t;
+	return 0;
+}
+
+#define OPTIONS (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE)
+
+static const struct watchdog_info winbond_wdt_ident = {
+	.options =		OPTIONS,
+	.firmware_version =	0,
+	.identity =		"Winbond Watchdog",
+};
+
+static struct watchdog_ops winbond_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	winbond_wdt_start,
+	.stop =		winbond_wdt_stop,
+	.set_timeout =	winbond_wdt_set_timeout,
+};
+
+static struct watchdog_device winbond_wdd = {
+	.info =		&winbond_wdt_ident,
+	.ops =		&winbond_wdt_ops,
+	.timeout =	WATCHDOG_TIMEOUT,
+	.min_timeout =	1,
+	.max_timeout =	255,
+};
+static int winbond_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+	unsigned char val;
+	struct winbond_wdt_pdata *pdata;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data supplied\n");
+		return -ENODEV;
+	}
+
+	/* Set the timeout value from the module parameter */
+	if (watchdog_init_timeout(&winbond_wdd,	timeout, &pdev->dev)) {
+		dev_warn(&pdev->dev,
+			"timout value must be 1<=timeout<=255, using %d\n",
+							WATCHDOG_TIMEOUT);
+	}
+
+	winbond_superio_enter(pdata->siodata.ioreg);
+	/* Multiplex WDTO as the output pin */
+	switch (pdata->siodata.id) {
+	case SIO_W83627HF_ID:
+	case SIO_W83627SF_ID:
+	case SIO_W83637HF_ID:
+		/* WDTO is multiplexed PIN89S. CR2B bit 4 = 0 */
+		val = superio_inb(pdata->siodata.ioreg, 0x2B);
+		val &= ~0x10;
+		superio_outb(pdata->siodata.ioreg, 0x2B, val);
+		break;
+	case SIO_W83627THF_ID:
+		/* WDTO is multiplexed PIN89S1+S0. CR2B Bit 3,2 = 01 */
+		val = superio_inb(pdata->siodata.ioreg, 0x2B);
+		val &= ~0x08;
+		val |= 0x04;
+		superio_outb(pdata->siodata.ioreg, 0x2B, val);
+		break;
+	case SIO_W83627EHF_ID:
+	case SIO_W83627EHG_ID:
+	case SIO_W83627DHG_ID:
+	case SIO_W83627DHG_P_ID:
+		/* WDTO is multiplexed PIN77. CR2D bit 0 = 0 */
+		val = superio_inb(pdata->siodata.ioreg, 0x2D);
+		val &= ~0x01;
+		superio_outb(pdata->siodata.ioreg, 0x2D, val);
+		break;
+	case SIO_W83697HF_ID:
+		/* WDTO is multiplexed PIN119. CR29 bit 6,5 = 01 */
+		val = superio_inb(pdata->siodata.ioreg, 0x29);
+		val &= ~0x40;
+		val |= 0x20;
+		superio_outb(pdata->siodata.ioreg, 0x29, val);
+		break;
+	case SIO_W83697UF_ID:
+		/* WDTO is multiplexed PIN118. CR2B bit 2 = 0 */
+		val = superio_inb(pdata->siodata.ioreg, 0x2B);
+		val &= ~0x04;
+		superio_outb(pdata->siodata.ioreg, 0x2B, val);
+		break;
+	}
+	/* Select Logical Device 8 */
+	superio_select(pdata->siodata.ioreg, 0x08);
+	/* Activate the Logical Device if not already active */
+	val = superio_inb(pdata->siodata.ioreg, WINB_ACT_REG);
+	if (!(val & 0x01)) {
+		dev_warn(&pdev->dev, "Enabling Winbond WDT logical device\n");
+		superio_outb(pdata->siodata.ioreg, WINB_ACT_REG, val | 0x01);
+	}
+	/* Configure Registers for WDTO usage */
+	switch (pdata->siodata.id) {
+	case SIO_W83627HF_ID:
+	case SIO_W83627SF_ID:
+	case SIO_W83637HF_ID:
+	case SIO_W83627THF_ID:
+	case SIO_W83627EHF_ID:
+	case SIO_W83627EHG_ID:
+	case SIO_W83627DHG_ID:
+	case SIO_W83627UHG_ID:
+	case SIO_W83627DHG_P_ID:
+		/* CRF6 = WDTO# Counter Register */
+		pdata->wdt_counter_reg = 0xF6;
+		/*
+		 * CRF5 = PLED mode Register
+		 * 	Bit 3: 0 = WDTO count mode select: Seconds
+		 * 	Bit 2: 0 = Disable Keyboard Reset stopping WDT
+		 * 	Bit 1: 1 = Enable the WDTO# output low pulse to the
+		 * 		KBRST# pin
+		 */
+		val = superio_inb(pdata->siodata.ioreg, 0xF5);
+		val &= ~0x0C;
+		val |= 0x02;
+		superio_outb(pdata->siodata.ioreg, 0xF5, val);
+		/*
+		 * CRF7 = Watchdog Control/Status Register
+		 * 	Bit 7: 0 = Watch Dog Timer not affected by Mouse int.
+		 * 	Bit 7: 0 = Watch Dog Timer not affected by Keyb. int.
+		 */
+		val = superio_inb(pdata->siodata.ioreg, 0xF7);
+		val &= ~0xC0;
+		superio_outb(pdata->siodata.ioreg, 0xF7, val);
+		break;
+	case SIO_W83697HF_ID:
+	case SIO_W83697UF_ID:
+		/* CRF4 = WDTO# Counter Register */
+		pdata->wdt_counter_reg = 0xF4;
+		/*
+		 * CRF3 = PLED mode Register
+		 * 	Bit 2: 0 = WDTO count mode select: Seconds
+		 */
+		val = superio_inb(pdata->siodata.ioreg, 0xF3);
+		val &= ~0x04;
+		superio_outb(pdata->siodata.ioreg, 0xF3, val);
+		break;
+	}
+	/* Take action if watchdog timer is already running */
+	val = superio_inb(pdata->siodata.ioreg, pdata->wdt_counter_reg);
+	if (val)  {
+		if (early_disable) {
+			winbond_wdt_set_timer(pdata, 0x00);
+			dev_info(&pdev->dev, "Stopping running watchdog\n");
+		} else
+			dev_warn(&pdev->dev, "Watchdog is running!\n");
+	}
+	winbond_superio_exit(pdata->siodata.ioreg);
+
+	watchdog_set_nowayout(&winbond_wdd, nowayout);
+	watchdog_set_drvdata(&winbond_wdd, pdata);
+	ret = watchdog_register_device(&winbond_wdd);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register watchdog (%d)\n", ret);
+		goto err;
+	}
+
+	dev_info(&pdev->dev,
+		"initialized. timeout=%d sec (nowayout=%d, early_disable=%d)\n",
+				winbond_wdd.timeout, nowayout, early_disable);
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int winbond_wdt_remove(struct platform_device *pdev)
+{
+	watchdog_unregister_device(&winbond_wdd);
+	return 0;
+}
+
+static void winbond_wdt_shutdown(struct platform_device *pdev)
+{
+	struct winbond_wdt_pdata *pdata = pdev->dev.platform_data;
+
+	winbond_wdt_set_timer(pdata, 0x00);
+}
+
+static struct platform_driver winbond_wdt_driver = {
+	.probe		= winbond_wdt_probe,
+	.remove		= winbond_wdt_remove,
+	.shutdown	= winbond_wdt_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "winbond_wdt",
+	},
+};
+module_platform_driver(winbond_wdt_driver);
+
+MODULE_AUTHOR("Pádraig Brady <P@draigBrady.com>");
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("Winbond Watch Dog Timer driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:winbond_wdt");
diff --git a/include/linux/mfd/superio.h b/include/linux/mfd/superio.h
new file mode 100644
index 0000000..4b6dee5
--- /dev/null
+++ b/include/linux/mfd/superio.h
@@ -0,0 +1,27 @@
+
+#ifndef __SUPERIO_MFD_H
+#define __SUPERIO_MFD_H
+
+#include <linux/io.h>
+
+#define SIO_LD_SEL	0x07	/* Super-I/O Logical Device Select */
+
+inline void superio_outb(int ioreg, int reg, int val)
+{
+	outb(reg, ioreg);
+	outb(val, ioreg + 1);
+}
+
+inline int superio_inb(int ioreg, int reg)
+{
+	outb(reg, ioreg);
+	return inb(ioreg + 1);
+}
+
+inline void superio_select(int ioreg, int ld)
+{
+	outb(SIO_LD_SEL, ioreg);
+	outb(ld, ioreg + 1);
+}
+
+#endif /* __SUPERIO_MFD_H */
diff --git a/include/linux/mfd/winbond_superio.h b/include/linux/mfd/winbond_superio.h
new file mode 100644
index 0000000..745b247
--- /dev/null
+++ b/include/linux/mfd/winbond_superio.h
@@ -0,0 +1,63 @@
+/*
+ * Definitions and platform data for Winbond(tm) Super-I/O
+ * chipsets (HWMON & Watchdog)
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __LINUX_MFD_WINBOND_SUPERIO_H
+#define __LINUX_MFD_WINBOND_SUPERIO_H
+
+#define WINB_REGION_SIZE	2
+
+/* Global Control Registers */
+#define SIO_REG_LDSEL		0x07	/* Logical device select */
+#define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
+#define SIO_REG_ENABLE		0x30	/* Logical device enable */
+#define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
+
+/* Device ID values */
+#define SIO_W83627HF_ID		0x5200	/* w83627hf */
+#define SIO_W83627HG_ID		0x5217	/* w83627hg */
+#define SIO_W83627HJ_ID		0x523a	/* w83627hj */
+#define SIO_W83627UD_A_ID	0x5241	/* w83627ud-a */
+#define SIO_W83627SF_ID		0x5950	/* w83627sf */
+#define SIO_W83697HF_ID		0x6010	/* w83697hf, w83697f */
+#define SIO_W83697SF_ID		0x6800	/* w83697sf */
+#define SIO_W83697UF_ID		0x6810	/* w83697sf, w83697uf */
+#define SIO_W83637HF_ID		0x7080	/* w83637hf */
+#define SIO_W83627THF_ID	0x8283	/* w83627thf */
+#define SIO_W83687THF_ID	0x8500	/* w83687thf */
+#define SIO_W83627EHF_ID	0x8850	/* w83627ehf */
+#define SIO_W83627EHG_ID	0x8860	/* w83627ehf */
+#define SIO_W83627DHG_ID	0xa020	/* w83627dhg */
+#define SIO_W83627UHG_ID	0xa230	/* w83627uhg */
+#define SIO_W83667HG_ID		0xa510	/* w83667hg */
+#define SIO_W83627DHG_P_ID	0xb070	/* w83627dhg-p */
+#define SIO_W83667HG_B_ID	0xb350	/* w83667hg-b */
+#define SIO_NCT6775_ID		0xb470	/* nct6775 */
+#define SIO_NCT6776_ID		0xc330	/* nct6776 */
+#define SIO_NCT6779_ID		0xc560	/* nct6779 */
+#define SIO_ID_MASK		0xFFF0
+
+/* Configuration Registers */
+#define WINB_ACT_REG	0x30	/* Device Activation Register */
+
+struct winbond_sio_data {
+	int ioreg;
+	unsigned short id;
+};
+
+struct winbond_wdt_pdata {
+	struct winbond_sio_data siodata;
+	unsigned char wdt_counter_reg;
+};
+
+/*
+ * Winbond Super-I/O functions
+ */
+
+extern inline void winbond_superio_enter(int ioreg);
+extern inline void winbond_superio_exit(int ioreg);
+
+#endif /* __LINUX_MFD_WINBOND_SUPERIO_H */
