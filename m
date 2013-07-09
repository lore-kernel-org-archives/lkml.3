Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3GIGde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 02:33:34 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:39344
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571Ab3GIGdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 02:33:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzc8kzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Robin Gong <b38343@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>
Subject: [PATCH v1] regulator: pfuze100: add pfuze100 regulator driver
Date: Tue, 9 Jul 2013 14:38:00 +0800
Message-ID: <1373351880-26982-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pfuze100 regulator driver.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/regulator/Kconfig              |    7 +
 drivers/regulator/Makefile             |    2 +
 drivers/regulator/pfuze-regulator.h    |  110 ++++
 drivers/regulator/pfuze100-regulator.c |  993 ++++++++++++++++++++++++++++++++
 include/linux/regulator/pfuze.h        |   50 ++
 5 files changed, 1162 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/pfuze-regulator.h
 create mode 100644 drivers/regulator/pfuze100-regulator.c
 create mode 100644 include/linux/regulator/pfuze.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f1e6ad9..f913172 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -158,6 +158,13 @@ config REGULATOR_MC13892
 	  Say y here to support the regulators found on the Freescale MC13892
 	  PMIC.
 
+config REGULATOR_PFUZE100
+	tristate "Support regulators on Freescale PFUZE100 PMIC"
+	depends on I2C
+	help
+	  Say y here to support the regulators found on the Freescale PFUZE100
+	  PMIC.
+
 config REGULATOR_ISL6271A
 	tristate "Intersil ISL6271A Power regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ba4a3cf..d78eca7 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_REGULATOR_MAX77693) += max77693.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
+obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
 obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
@@ -72,6 +73,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
+obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
 
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/pfuze-regulator.h b/drivers/regulator/pfuze-regulator.h
new file mode 100644
index 0000000..4374422
--- /dev/null
+++ b/drivers/regulator/pfuze-regulator.h
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+#ifndef __LINUX_REGULATOR_PFUZE_H
+#define __LINUX_REGULATOR_PFUZE_H
+
+#include <linux/regulator/driver.h>
+
+struct pfuze_regulator {
+	struct regulator_desc desc;
+	unsigned int reg;
+	unsigned int stby_reg;
+	unsigned char enable_bit;
+	unsigned char stby_bit;
+	unsigned char vsel_shift;
+	unsigned char vsel_mask;
+	unsigned char stby_vsel_shift;
+	unsigned char stby_vsel_mask;
+	int const *voltages;
+};
+
+struct pfuze_regulator_priv {
+	struct pfuze_regulator *pfuze_regulators;
+	int num_regulators;
+	struct regulator_dev *regulators[];
+};
+
+#define PFUZE_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,			\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.enable_bit = prefix ## _reg ## _ ## EN,	\
+		.stby_bit = prefix ## _reg ## _ ## STBY,	\
+		.vsel_shift = prefix ## _reg ## _ ## VSEL,\
+		.vsel_mask = prefix ## _reg ## _ ## VSEL_M,\
+		.voltages =  _voltages,					\
+	}
+#define PFUZE_SW_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,			\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.vsel_shift = prefix ## _reg ## _ ## VSEL,\
+		.vsel_mask = prefix ## _reg ## _ ## VSEL_M,\
+		.stby_reg = prefix ## _reg ## _ ## STBY,		\
+		.stby_vsel_shift = prefix ## _reg ## _ ## STBY_VSEL,\
+		.stby_vsel_mask = prefix ## _reg ## _ ## STBY_VSEL_M,\
+		.voltages =  _voltages,					\
+	}
+
+#define PFUZE_SWBST_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,			\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.vsel_shift = prefix ## _reg ## _ ## VSEL,\
+		.vsel_mask = prefix ## _reg ## _ ## VSEL_M,\
+		.voltages =  _voltages,					\
+	}
+
+#define PFUZE_FIXED_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,		\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.enable_bit = prefix ## _reg ## _ ## EN,	\
+		.voltages =  _voltages,					\
+	}
+
+#endif
+
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
new file mode 100644
index 0000000..ee8d33a
--- /dev/null
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -0,0 +1,993 @@
+/*
+ * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/pfuze.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include "pfuze-regulator.h"
+
+#define PFUZE100_FIXED_VOL_DEFINE(name,	reg, voltages)		\
+	PFUZE_FIXED_DEFINE(PFUZE100_, name, reg, voltages,	\
+			pfuze100_fixed_regulator_ops)
+
+#define PFUZE100_SW_DEFINE(name, reg, voltages)	\
+	PFUZE_SW_DEFINE(PFUZE100_, name, reg, voltages,	\
+			pfuze100_sw_regulator_ops)
+
+#define PFUZE100_SWBST_DEFINE(name, reg, voltages)	\
+	PFUZE_SWBST_DEFINE(PFUZE100_, name, reg, voltages,	\
+			pfuze100_sw_regulator_ops)
+
+#define PFUZE100_VGEN_DEFINE(name, reg, voltages)	\
+	PFUZE_DEFINE(PFUZE100_, name, reg, voltages,	\
+			pfuze100_ldo_regulator_ops)
+
+#define PFUZE100_DEVICEID               (0x0)
+#define PFUZE100_REVID                  (0x3)
+#define PFUZE100_FABID                  (0x3)
+
+/* SW1A */
+#define PFUZE100_SW1AVOL	32
+#define PFUZE100_SW1AVOL_VSEL	0
+#define PFUZE100_SW1AVOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1AVOL_STBY	33
+#define PFUZE100_SW1AVOL_STBY_VSEL	0
+#define PFUZE100_SW1AVOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1AOFF	34
+#define PFUZE100_SW1AOFF_OFF_VAL	(0x0<<0)
+#define PFUZE100_SW1AOFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW1AMODE	35
+#define PFUZE100_SW1AMODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW1AMODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW1AMODE_MODE_VAL	0x7	/*Auto */
+#define PFUZE100_SW1AMODE_MODE_M	(0xf<<0)
+
+#define PFUZE100_SW1ACON		36
+#define PFUZE100_SW1ACON_SPEED_VAL	(0x1<<6)	/*default */
+#define PFUZE100_SW1ACON_SPEED_M	(0x3<<6)
+#define PFUZE100_SW1ACON_PHASE_VAL	(0x1<<4)	/*default */
+#define PFUZE100_SW1ACON_PHASE_M	(0x3<<4)
+#define PFUZE100_SW1ACON_FREQ_VAL	(0x1<<2)	/*1Mhz */
+#define PFUZE100_SW1ACON_FREQ_M	(0x3<<2)
+#define PFUZE100_SW1ACON_LIM_VAL	(0x0<<0)	/*2Imax */
+#define PFUZE100_SW1ACON_LIM_M	(0x3<<0)
+
+/*SW1B*/
+#define PFUZE100_SW1BVOL	39
+#define PFUZE100_SW1BVOL_VSEL	0
+#define PFUZE100_SW1BVOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1BVOL_STBY	40
+#define PFUZE100_SW1BVOL_STBY_VSEL	0
+#define PFUZE100_SW1BVOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1BOFF	41
+#define PFUZE100_SW1BOFF_OFF_VAL	0x0
+#define PFUZE100_SW1BOFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW1BMODE	42
+#define PFUZE100_SW1BMODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW1BMODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW1BMODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW1BMODE_MODE_M	(0xf<<0)
+
+#define PFUZE100_SW1BCON		43
+#define PFUZE100_SW1BCON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW1BCON_SPEED_M	(0x3<<6)
+#define PFUZE100_SW1BCON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW1BCON_PHASE_M	(0x3<<4)
+#define PFUZE100_SW1BCON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW1BCON_FREQ_M	(0x3<<2)
+#define PFUZE100_SW1BCON_LIM_VAL	(0x0<<0)
+#define PFUZE100_SW1BCON_LIM_M	(0x3<<0)
+
+/*SW1C*/
+#define PFUZE100_SW1CVOL	46
+#define PFUZE100_SW1CVOL_VSEL	0
+#define PFUZE100_SW1CVOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1CVOL_STBY	47
+#define PFUZE100_SW1CVOL_STBY_VSEL	0
+#define PFUZE100_SW1CVOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW1COFF	48
+#define PFUZE100_SW1COFF_OFF_VAL	0x0
+#define PFUZE100_SW1COFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW1CMODE	49
+#define PFUZE100_SW1CMODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW1CMODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW1CMODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW1CMODE_MODE_M	(0xf<<0)
+
+#define PFUZE100_SW1CCON		50
+#define PFUZE100_SW1CCON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW1CCON_SPEED_M	(0x3<<6)
+#define PFUZE100_SW1CCON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW1CCON_PHASE_M	(0x3<<4)
+#define PFUZE100_SW1CCON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW1CCON_FREQ_M		(0x3<<2)
+#define PFUZE100_SW1CCON_LIM_VAL	(0x0<<0)
+#define PFUZE100_SW1CCON_LIM_M		(0x3<<0)
+
+/*SW2*/
+#define PFUZE100_SW2VOL		53
+#define PFUZE100_SW2VOL_VSEL	0
+#define PFUZE100_SW2VOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW2VOL_STBY		54
+#define PFUZE100_SW2VOL_STBY_VSEL	0
+#define PFUZE100_SW2VOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW2OFF	55
+#define PFUZE100_SW2OFF_OFF_VAL	0x0
+#define PFUZE100_SW2OFF_OFF_M	(0x7f<<0)
+
+#define PFUZE100_SW2MODE	56
+#define PFUZE100_SW2MODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW2MODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW2MODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW2MODE_MODE_M		(0xf<<0)
+
+#define PFUZE100_SW2CON		57
+#define PFUZE100_SW2CON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW2CON_SPEED_M		(0x3<<6)
+#define PFUZE100_SW2CON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW2CON_PHASE_M		(0x3<<4)
+#define PFUZE100_SW2CON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW2CON_FREQ_M		(0x3<<2)
+#define PFUZE100_SW2CON_LIM_VAL		(0x0<<0)
+#define PFUZE100_SW2CON_LIM_M		(0x3<<0)
+
+/*SW3A*/
+#define PFUZE100_SW3AVOL	60
+#define PFUZE100_SW3AVOL_VSEL	0
+#define PFUZE100_SW3AVOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW3AVOL_STBY	61
+#define PFUZE100_SW3AVOL_STBY_VSEL	0
+#define PFUZE100_SW3AVOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW3AOFF	62
+#define PFUZE100_SW3AOFF_OFF_VAL	0x0
+#define PFUZE100_SW3AOFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW3AMODE	63
+#define PFUZE100_SW3AMODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW3AMODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW3AMODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW3AMODE_MODE_M	(0xf<<0)
+
+#define PFUZE100_SW3ACON		64
+#define PFUZE100_SW3ACON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW3ACON_SPEED_M	(0x3<<6)
+#define PFUZE100_SW3ACON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW3ACON_PHASE_M	(0x3<<4)
+#define PFUZE100_SW3ACON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW3ACON_FREQ_M		(0x3<<2)
+#define PFUZE100_SW3ACON_LIM_VAL	(0x0<<0)
+#define PFUZE100_SW3ACON_LIM_M		(0x3<<0)
+
+/*SW3B*/
+#define PFUZE100_SW3BVOL	67
+#define PFUZE100_SW3BVOL_VSEL	0
+#define PFUZE100_SW3BVOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW3BVOL_STBY	68
+#define PFUZE100_SW3BVOL_STBY_VSEL	0
+#define PFUZE100_SW3BVOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW3BOFF	69
+#define PFUZE100_SW3BOFF_OFF_VAL	0x0
+#define PFUZE100_SW3BOFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW3BMODE	70
+#define PFUZE100_SW3BMODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW3BMODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW3BMODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW3BMODE_MODE_M	(0xf<<0)
+
+#define PFUZE100_SW3BCON		71
+#define PFUZE100_SW3BCON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW3BCON_SPEED_M	(0x3<<6)
+#define PFUZE100_SW3BCON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW3BCON_PHASE_M	(0x3<<4)
+#define PFUZE100_SW3BCON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW3BCON_FREQ_M		(0x3<<2)
+#define PFUZE100_SW3BCON_LIM_VAL	(0x0<<0)
+#define PFUZE100_SW3BCON_LIM_M		(0x3<<0)
+
+/*SW4*/
+#define PFUZE100_SW4VOL		74
+#define PFUZE100_SW4VOL_VSEL	0
+#define PFUZE100_SW4VOL_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW4VOL_STBY		75
+#define PFUZE100_SW4VOL_STBY_VSEL	0
+#define PFUZE100_SW4VOL_STBY_VSEL_M	(0x3f<<0)
+
+#define PFUZE100_SW4OFF		76
+#define PFUZE100_SW4OFF_OFF_VAL	0x0
+#define PFUZE100_SW4OFF_OFF_M	(0x3f<<0)
+
+#define PFUZE100_SW4MODE	77
+#define PFUZE100_SW4MODE_OMODE_VAL	(0x0<<5)
+#define PFUZE100_SW4MODE_OMODE_M	(0x1<<5)
+#define PFUZE100_SW4MODE_MODE_VAL	(0x7<<0)
+#define PFUZE100_SW4MODE_MODE_M		(0xf<<0)
+
+#define PFUZE100_SW4CON		78
+#define PFUZE100_SW4CON_SPEED_VAL	(0x1<<6)
+#define PFUZE100_SW4CON_SPEED_M		(0x3<<6)
+#define PFUZE100_SW4CON_PHASE_VAL	(0x1<<4)
+#define PFUZE100_SW4CON_PHASE_M		(0x3<<4)
+#define PFUZE100_SW4CON_FREQ_VAL	(0x1<<2)
+#define PFUZE100_SW4CON_FREQ_M		(0x3<<2)
+#define PFUZE100_SW4CON_LIM_VAL		(0x0<<0)
+#define PFUZE100_SW4CON_LIM_M		(0x3<<0)
+
+/*SWBST*/
+#define PFUZE100_SWBSTCON1	102
+#define PFUZE100_SWBSTCON1_SWBSTMOD_VAL	(0x1<<2)
+#define PFUZE100_SWBSTCON1_SWBSTMOD_M	(0x3<<2)
+#define PFUZE100_SWBSTCON1_VSEL	0
+#define PFUZE100_SWBSTCON1_VSEL_M	(0x3<<0)
+
+/*VREFDDR*/
+#define PFUZE100_VREFDDRCON	106
+#define PFUZE100_VREFDDRCON_EN	(0x1<<4)
+
+/*VSNVS*/
+#define PFUZE100_VSNVSVOL		107
+#define PFUZE100_VSNVSVOL_VSEL	0
+#define PFUZE100_VSNVSVOL_VSEL_M	(0x3<<0)
+
+/*VGEN1*/
+#define PFUZE100_VGEN1VOL		108
+#define PFUZE100_VGEN1VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN1VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN1VOL_VSEL	0
+#define PFUZE100_VGEN1VOL_VSEL_M	(0xf<<0)
+
+/*VGEN2*/
+#define PFUZE100_VGEN2VOL		109
+#define PFUZE100_VGEN2VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN2VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN2VOL_VSEL	0
+#define PFUZE100_VGEN2VOL_VSEL_M	(0xf<<0)
+
+/*VGEN3*/
+#define PFUZE100_VGEN3VOL		110
+#define PFUZE100_VGEN3VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN3VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN3VOL_VSEL	0
+#define PFUZE100_VGEN3VOL_VSEL_M	(0xf<<0)
+
+/*VGEN4*/
+#define PFUZE100_VGEN4VOL		111
+#define PFUZE100_VGEN4VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN4VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN4VOL_VSEL	0
+#define PFUZE100_VGEN4VOL_VSEL_M	(0xf<<0)
+
+/*VGEN5*/
+#define PFUZE100_VGEN5VOL		112
+#define PFUZE100_VGEN5VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN5VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN5VOL_VSEL	0
+#define PFUZE100_VGEN5VOL_VSEL_M	(0xf<<0)
+
+/*VGEN6*/
+#define PFUZE100_VGEN6VOL		113
+#define PFUZE100_VGEN6VOL_STBY	(0x1<<5)
+#define PFUZE100_VGEN6VOL_EN	(0x1<<4)
+#define PFUZE100_VGEN6VOL_VSEL	0
+#define PFUZE100_VGEN6VOL_VSEL_M	(0xf<<0)
+
+enum pfuze_id {
+	PFUZE_ID_PFUZE100,
+	PFUZE_ID_INVALID,
+};
+struct pfuze_chip {
+	struct pfuze_regulator_priv *priv;
+	struct regmap *regmap;
+	struct device *dev;
+	enum pfuze_id chip;	/*chip type*/
+};
+
+static struct regulator_ops pfuze100_ldo_regulator_ops;
+static struct regulator_ops pfuze100_fixed_regulator_ops;
+static struct regulator_ops pfuze100_sw_regulator_ops;
+
+static const int pfuze100_sw1[] = {
+	300000, 325000, 350000, 375000, 400000, 425000, 450000, 475000,
+	500000, 525000, 550000, 575000, 600000, 625000, 650000, 675000,
+	700000, 725000, 750000, 775000, 800000, 825000, 850000, 875000,
+	900000, 925000, 950000, 975000, 1000000, 1025000, 1050000, 1075000,
+	1100000, 1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000,
+	1300000, 1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000,
+	1500000, 1525000, 1550000, 1575000, 1600000, 1625000, 1650000, 1675000,
+	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
+};
+
+static const int pfuze100_sw2[] = {
+	800000, 850000, 900000, 950000, 1000000, 1050000, 1100000, 1150000,
+	1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000, 1550000,
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000, 3300000, 3300000, 3300000, 3300000, 3300000,
+	3300000, 3300000, 3300000, 3300000, 3300000, 3300000, 3300000, 3950000,
+};
+
+static const int pfuze100_sw3[] = {
+	400000, 425000, 450000, 475000, 500000, 525000, 550000, 575000,
+	600000, 625000, 650000, 675000, 700000, 725000, 750000, 775000,
+	800000, 825000, 850000, 875000, 900000, 925000, 950000, 975000,
+	1000000, 1025000, 1050000, 1075000, 1100000, 1125000, 1150000, 1175000,
+	1200000, 1225000, 1250000, 1275000, 1300000, 1325000, 1350000, 1375000,
+	1400000, 1425000, 1450000, 1475000, 1500000, 1525000, 1550000, 1575000,
+	1600000, 1625000, 1650000, 1675000, 1700000, 1725000, 1750000, 1775000,
+	1800000, 1825000, 1850000, 1875000, 1900000, 1925000, 1950000, 1975000,
+};
+
+static const int pfuze100_sw4[] = {
+	800000, 850000, 900000, 950000, 1000000, 1050000, 1100000, 1150000,
+	1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000, 1550000,
+	1600000, 1650000, 1700000, 1750000, 1800000, 1850000, 1900000, 1950000,
+	2000000, 2050000, 2100000, 2150000, 2200000, 2250000, 2300000, 2350000,
+	2400000, 2450000, 2500000, 2550000, 2600000, 2650000, 2700000, 2750000,
+	2800000, 2850000, 2900000, 2950000, 3000000, 3050000, 3100000, 3150000,
+	3200000, 3250000, 3300000, 3300000, 3300000, 3300000, 3300000, 3300000,
+	3300000, 3300000, 3300000, 3300000, 3300000, 3300000, 3300000, 3950000,
+};
+
+static const int pfuze100_swbst[] = {
+	5000000, 5050000, 5100000, 5150000,
+};
+
+static const int pfuze100_vsnvs[] = {
+	1200000, 1500000, 1800000, 3000000,
+};
+
+static const int pfuze100_vrefddr[] = {
+	750000,
+};
+
+static const int pfuze100_vgen12[] = {
+	800000, 850000, 900000, 950000, 1000000, 1050000, 1100000, 1150000,
+	1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000, 1550000,
+};
+
+static const int pfuze100_vgen36[] = {
+	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
+	2600000, 2700000, 2800000, 2900000, 3000000, 3100000, 3200000, 3300000,
+};
+
+static const struct i2c_device_id pfuze_device_id[] = {
+	{.name = "pfuze100", .driver_data = PFUZE_ID_PFUZE100},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, pfuze_device_id);
+
+
+#if defined(CONFIG_OF)
+static const struct of_device_id pfuze_dt_ids[] = {
+	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE_ID_PFUZE100},
+	{},
+};
+MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
+#endif
+
+static struct pfuze_regulator pfuze100_regulators[] = {
+	PFUZE100_SW_DEFINE(SW1A, SW1AVOL, pfuze100_sw1),
+	PFUZE100_SW_DEFINE(SW1C, SW1CVOL, pfuze100_sw1),
+	PFUZE100_SW_DEFINE(SW2, SW2VOL, pfuze100_sw2),
+	PFUZE100_SW_DEFINE(SW3A, SW3AVOL, pfuze100_sw3),
+	PFUZE100_SW_DEFINE(SW3B, SW3BVOL, pfuze100_sw3),
+	PFUZE100_SW_DEFINE(SW4, SW4VOL, pfuze100_sw4),
+	PFUZE100_SWBST_DEFINE(SWBST, SWBSTCON1, pfuze100_swbst),
+	PFUZE100_SWBST_DEFINE(VSNVS, VSNVSVOL, pfuze100_vsnvs),
+	PFUZE100_FIXED_VOL_DEFINE(VREFDDR, VREFDDRCON, pfuze100_vrefddr),
+	PFUZE100_VGEN_DEFINE(VGEN1, VGEN1VOL, pfuze100_vgen12),
+	PFUZE100_VGEN_DEFINE(VGEN2, VGEN2VOL, pfuze100_vgen12),
+	PFUZE100_VGEN_DEFINE(VGEN3, VGEN3VOL, pfuze100_vgen36),
+	PFUZE100_VGEN_DEFINE(VGEN4, VGEN4VOL, pfuze100_vgen36),
+	PFUZE100_VGEN_DEFINE(VGEN5, VGEN5VOL, pfuze100_vgen36),
+	PFUZE100_VGEN_DEFINE(VGEN6, VGEN6VOL, pfuze100_vgen36),
+};
+
+static int pfuze100_regulator_enable(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].enable_bit,
+				pfuze100_regulators[id].enable_bit);
+	return ret;
+}
+
+static int pfuze100_regulator_disable(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].enable_bit, 0);
+	return ret;
+}
+
+static int pfuze100_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(pfuze->regmap, pfuze100_regulators[id].reg,
+			&val);
+	if (ret)
+		return ret;
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	return (val & pfuze100_regulators[id].enable_bit) != 0;
+}
+
+int pfuze100_regulator_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	int id = rdev_get_id(rdev);
+
+	if (selector >= pfuze100_regulators[id].desc.n_voltages)
+		return -EINVAL;
+	return pfuze100_regulators[id].voltages[selector];
+}
+
+static int pfuze100_get_best_voltage_index(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	int reg_id = rdev_get_id(rdev);
+	int i, bestmatch, bestindex;
+
+	bestmatch = INT_MAX;
+	bestindex = -1;
+	for (i = 0; i < pfuze100_regulators[reg_id].desc.n_voltages; i++) {
+		if (pfuze100_regulators[reg_id].voltages[i] >= min_uV &&
+		    pfuze100_regulators[reg_id].voltages[i] < bestmatch) {
+			bestmatch = pfuze100_regulators[reg_id].voltages[i];
+			bestindex = i;
+		}
+	}
+	if (bestindex < 0 || bestmatch > max_uV) {
+		dev_warn(&rdev->dev, "no possible value for %d<=x<=%d uV\n",
+			 min_uV, max_uV);
+		return -EINVAL;
+	}
+	return bestindex;
+}
+
+static int
+pfuze100_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
+			       int max_uV, unsigned *selector)
+{
+
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int value, id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
+		__func__, id, min_uV, max_uV);
+	/* Find the best index */
+	value = pfuze100_get_best_voltage_index(rdev, min_uV, max_uV);
+	dev_dbg(rdev_get_dev(rdev), "%s best value: %d\n", __func__, value);
+	if (value < 0)
+		return value;
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].vsel_mask,
+				value << pfuze100_regulators[id].vsel_shift);
+	return ret;
+
+}
+
+static int pfuze100_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					      unsigned selector)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int  id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d vol: %d\n",
+		__func__, id, pfuze100_regulators[id].voltages[selector]);
+
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].vsel_mask,
+				selector << pfuze100_regulators[id].vsel_shift);
+
+	return ret;
+}
+
+static int pfuze100_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	ret = regmap_read(pfuze->regmap, pfuze100_regulators[id].reg,
+			&val);
+	if (ret)
+		return ret;
+	val = (val & pfuze100_regulators[id].vsel_mask)
+	    >> pfuze100_regulators[id].vsel_shift;
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
+	BUG_ON(val > pfuze100_regulators[id].desc.n_voltages);
+	return pfuze100_regulators[id].voltages[val];
+}
+
+static int pfuze100_regulator_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(pfuze->regmap, pfuze100_regulators[id].reg,
+			&val);
+	if (ret)
+		return ret;
+
+	val &= pfuze100_regulators[id].vsel_mask;
+	val >>= pfuze100_regulators[id].vsel_shift;
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d, vol=%d\n", __func__, id,
+		pfuze100_regulators[id].voltages[val]);
+	return (int) val;
+}
+
+static int pfuze100_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+					     unsigned int old_sel,
+					     unsigned int new_sel)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	unsigned int step_delay;
+
+	/*read SWxDVSSPEED from SWxCONF,got ramp step value*/
+	ret = regmap_read(pfuze->regmap, pfuze100_regulators[id].reg
+			  + 0x4, &step_delay);
+
+	if (ret)
+		return ret;
+	/*
+	 * one 25mv step
+	 * 00: 2us,
+	 * 01: 4us,
+	 * 02: 8us,
+	 * 03: 16us,
+	 */
+	step_delay >>= 6;
+	step_delay &= 0x3;
+	step_delay = 2  <<  step_delay;
+
+	if (pfuze100_regulators[id].voltages[old_sel] <
+		pfuze100_regulators[id].voltages[new_sel])
+		ret = DIV_ROUND_UP(pfuze100_regulators[id].voltages[new_sel] -
+			pfuze100_regulators[id].voltages[old_sel], 25000)
+			* step_delay;
+	else
+		ret = 0; /* no delay if voltage drop */
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d, new_sel = %d, old_sel = %d,
+		delay = %d\n", __func__, id, new_sel, old_sel, ret);
+	return ret;
+}
+
+static int pfuze100_regulator_ldo_standby_enable(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].stby_bit,
+				0);
+	return ret;
+}
+
+static int pfuze100_regulator_ldo_standby_disable(struct regulator_dev *rdev)
+{
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].reg,
+				pfuze100_regulators[id].stby_bit,
+				pfuze100_regulators[id].stby_bit);
+	return ret;
+}
+
+static struct regulator_ops pfuze100_ldo_regulator_ops = {
+	.enable = pfuze100_regulator_enable,
+	.disable = pfuze100_regulator_disable,
+	.is_enabled = pfuze100_regulator_is_enabled,
+	.list_voltage = pfuze100_regulator_list_voltage,
+	.set_voltage = pfuze100_regulator_set_voltage,
+	.get_voltage = pfuze100_regulator_get_voltage,
+	.set_suspend_enable = pfuze100_regulator_ldo_standby_enable,
+	.set_suspend_disable = pfuze100_regulator_ldo_standby_disable,
+};
+
+static int pfuze100_fixed_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV,
+						unsigned *selector)
+{
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
+		__func__, id, min_uV, max_uV);
+	if (min_uV >= pfuze100_regulators[id].voltages[0] &&
+	    max_uV <= pfuze100_regulators[id].voltages[0])
+		return 0;
+	else
+		return -EINVAL;
+
+}
+
+static int pfuze100_fixed_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+	return pfuze100_regulators[id].voltages[0];
+}
+
+static struct regulator_ops pfuze100_fixed_regulator_ops = {
+	.enable = pfuze100_regulator_enable,
+	.disable = pfuze100_regulator_disable,
+	.is_enabled = pfuze100_regulator_is_enabled,
+	.set_voltage = pfuze100_fixed_regulator_set_voltage,
+	.get_voltage = pfuze100_fixed_regulator_get_voltage,
+};
+
+static int pfuze100_sw_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	return 1;
+}
+
+static int
+pfuze100_regulator_sw_standby_voltage(struct regulator_dev *rdev, int uV)
+{
+
+	struct pfuze_chip *pfuze = rdev_get_drvdata(rdev);
+	int value, id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d set standby: %d\n",
+		__func__, id, uV);
+	/* Find the best index */
+	value = pfuze100_get_best_voltage_index(rdev, uV, uV);
+	if (value < 0)
+		return value;
+	ret = regmap_update_bits(pfuze->regmap,
+				pfuze100_regulators[id].stby_reg,
+				pfuze100_regulators[id].stby_vsel_mask,
+				value <<
+				pfuze100_regulators[id].stby_vsel_shift);
+	return ret;
+
+}
+
+static int pfuze100_regulator_sw_standby_enable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+static int pfuze100_regulator_sw_standby_disable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+static struct regulator_ops pfuze100_sw_regulator_ops = {
+	.is_enabled = pfuze100_sw_regulator_is_enabled,
+	.list_voltage = pfuze100_regulator_list_voltage,
+	.set_voltage_sel = pfuze100_regulator_set_voltage_sel,
+	.get_voltage_sel = pfuze100_regulator_get_voltage_sel,
+	.set_suspend_enable = pfuze100_regulator_sw_standby_enable,
+	.set_suspend_disable = pfuze100_regulator_sw_standby_disable,
+	.set_suspend_voltage = pfuze100_regulator_sw_standby_voltage,
+	.set_voltage_time_sel = pfuze100_regulator_set_voltage_time_sel,
+
+};
+
+#ifdef CONFIG_OF
+
+static int  pfuze_get_num_regulators_dt(struct device *dev)
+{
+	struct device_node *parent, *child;
+	int num = 0;
+
+	of_node_get(dev->parent->of_node);
+	parent = of_find_node_by_name(dev->parent->of_node, "regulators");
+	if (!parent)
+		return -ENODEV;
+
+	for_each_child_of_node(parent, child)
+		num++;
+
+	return num;
+}
+
+static struct pfuze_regulator_init_data *pfuze_parse_regulators_dt(
+	struct pfuze_chip *chip, struct pfuze_regulator *regulators,
+	int num_regulators)
+{
+	struct device *dev = chip->dev;
+	struct pfuze_regulator_priv *priv = chip->priv;
+	struct pfuze_regulator_init_data *data, *p;
+	struct device_node *parent, *child;
+	int i;
+
+	of_node_get(dev->parent->of_node);
+	parent = of_find_node_by_name(dev->parent->of_node, "regulators");
+	if (!parent)
+		return NULL;
+
+	data = devm_kzalloc(dev, sizeof(*data) * priv->num_regulators,
+			    GFP_KERNEL);
+	if (!data)
+		return NULL;
+	p = data;
+	for_each_child_of_node(parent, child) {
+		for (i = 0; i < num_regulators; i++) {
+			if (!of_node_cmp(child->name,
+					 regulators[i].desc.name)) {
+				p->id = i;
+				p->init_data = of_get_regulator_init_data(
+							dev, child);
+				p->node = child;
+				p++;
+				break;
+			}
+		}
+	}
+
+	return data;
+}
+
+#else
+
+static int pfuze_get_num_regulators_dt(struct device *dev)
+{
+		return -ENODEV;
+
+}
+
+static struct pfuze_regulator_init_data *pfuze_parse_regulators_dt(
+	struct pfuze_chip *chip, struct pfuze_regulator *regulators,
+	int num_regulators)
+{
+		return NULL;
+
+}
+#endif
+
+static int pfuze_identify(struct pfuze_chip *pfuze_chip)
+{
+	unsigned int value;
+	int ret;
+	ret = regmap_read(pfuze_chip->regmap, PFUZE100_DEVICEID, &value);
+	if (ret)
+		return ret;
+	switch (value & 0x0f) {
+	case 0x0:
+		pfuze_chip->chip = PFUZE_ID_PFUZE100;
+		break;
+	default:
+		pfuze_chip->chip = PFUZE_ID_INVALID;
+		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
+		break;
+	}
+	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
+	if (ret)
+		return ret;
+	dev_info(pfuze_chip->dev,
+		 "ID: %d,Full lay: %x ,Metal lay: %x\n",
+		 pfuze_chip->chip, (value & 0xf0) >> 4, value & 0x0f);
+	ret = regmap_read(pfuze_chip->regmap, PFUZE100_FABID, &value);
+	if (ret)
+		return ret;
+	dev_info(pfuze_chip->dev, "FAB: %x ,FIN: %x\n",
+		 (value & 0xc) >> 2, value & 0x3);
+	return (pfuze_chip->chip == PFUZE_ID_INVALID) ? -ENODEV : 0;
+}
+
+static struct regmap_config pfuze_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = PFUZE_NUMREGS,
+
+	.cache_type = REGCACHE_NONE,
+};
+
+static int pfuze100_regulator_probe(struct i2c_client *client,
+				    const struct i2c_device_id *id)
+{
+	const struct of_device_id *of_id;
+	struct i2c_driver *idrv = to_i2c_driver(client->dev.driver);
+	struct pfuze_chip *pfuze_chip;
+	struct pfuze_regulator_priv *priv;
+	struct pfuze_regulator_platform_data *pdata =
+	    dev_get_platdata(&client->dev);
+	struct pfuze_regulator_init_data *pfuze_data;
+	struct regulator_config config = { };
+	int i, ret;
+	int num_regulators = 0;
+
+	of_id = of_match_device(pfuze_dt_ids, &client->dev);
+	if (of_id)
+		idrv->id_table = (const struct i2c_device_id *) of_id->data;
+
+	pfuze_chip = devm_kzalloc(&client->dev, sizeof(*pfuze_chip),
+			GFP_KERNEL);
+	if (!pfuze_chip) {
+		dev_err(&client->dev, "%s(): Memory allocation failed\n",
+						__func__);
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(&client->dev, pfuze_chip);
+	pfuze_chip->dev = &client->dev;
+
+	pfuze_chip->regmap = devm_regmap_init_i2c(client, &pfuze_regmap_config);
+	if (IS_ERR(pfuze_chip->regmap)) {
+		ret = PTR_ERR(pfuze_chip->regmap);
+		dev_err(&client->dev,
+			"%s(): regmap allocation failed with err %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	ret = pfuze_identify(pfuze_chip);
+	if (ret) {
+		dev_err(&client->dev, "unrecognized pfuze chip ID!\n");
+		return ret;
+	}
+
+	num_regulators = pfuze_get_num_regulators_dt(&client->dev);
+	if (num_regulators <= 0 && pdata)
+		num_regulators = pdata->num_regulators;
+	if (num_regulators <= 0) {
+		dev_err(&client->dev, "no platform data,please add it!\n");
+		ret = -EINVAL;
+		return ret;
+	}
+
+	priv = devm_kzalloc(&client->dev, sizeof(*priv) +
+		       num_regulators * sizeof(priv->regulators[0]),
+		       GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		return ret;
+	}
+	priv->num_regulators = num_regulators;
+	priv->pfuze_regulators = pfuze100_regulators;
+	pfuze_chip->priv = priv;
+
+	pfuze_data = pfuze_parse_regulators_dt(pfuze_chip, pfuze100_regulators,
+					ARRAY_SIZE(pfuze100_regulators));
+
+	for (i = 0; i < num_regulators; i++) {
+		struct regulator_init_data *init_data;
+		struct regulator_desc *desc;
+		struct device_node *node = NULL;
+		int id;
+
+		if (pfuze_data) {
+			id = pfuze_data[i].id;
+			init_data = pfuze_data[i].init_data;
+			node = pfuze_data[i].node;
+		} else {
+			id = pdata->regulators[i].id;
+			init_data = pdata->regulators[i].init_data;
+		}
+		desc = &pfuze100_regulators[id].desc;
+
+		config.dev = &client->dev;
+		config.init_data = init_data;
+		config.driver_data = pfuze_chip;
+		config.of_node = node;
+
+		priv->regulators[i] = regulator_register(desc, &config);
+		if (IS_ERR(priv->regulators[i])) {
+			dev_err(&client->dev, "register regulator%s failed\n",
+				pfuze100_regulators[i].desc.name);
+			ret = PTR_ERR(priv->regulators[i]);
+			while (--i >= 0)
+				regulator_unregister(priv->regulators[i]);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int pfuze100_regulator_remove(struct i2c_client *client)
+{
+	int i;
+	struct pfuze_chip *pfuze_chip = dev_get_drvdata(&client->dev);
+
+	for (i = 0; i < pfuze_chip->priv->num_regulators; i++)
+		regulator_unregister(pfuze_chip->priv->regulators[i]);
+	kfree(pfuze_chip->priv);
+	kfree(pfuze_chip);
+
+	return 0;
+}
+
+static struct i2c_driver pfuze_driver = {
+	.id_table = pfuze_device_id,
+	.driver = {
+		.name = "pfuze100-regulator",
+		.owner = THIS_MODULE,
+		.of_match_table = pfuze_dt_ids,
+	},
+	.probe = pfuze100_regulator_probe,
+	.remove = pfuze100_regulator_remove,
+};
+
+static int __init pfuze100_regulator_init(void)
+{
+	return i2c_add_driver(&pfuze_driver);
+}
+
+subsys_initcall(pfuze100_regulator_init);
+static void __exit pfuze100_regulator_exit(void)
+{
+	i2c_del_driver(&pfuze_driver);
+}
+
+module_exit(pfuze100_regulator_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
+MODULE_ALIAS("pfuze100-regulator");
diff --git a/include/linux/regulator/pfuze.h b/include/linux/regulator/pfuze.h
new file mode 100644
index 0000000..ac1206c
--- /dev/null
+++ b/include/linux/regulator/pfuze.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#ifndef __LINUX_REG_PFUZE_H
+#define __LINUX_REG_PFUZE_H
+
+#define PFUZE_NUMREGS		128
+#define PFUZE100_SW1A		0
+#define PFUZE100_SW1C		1
+#define PFUZE100_SW2		2
+#define PFUZE100_SW3A		3
+#define PFUZE100_SW3B		4
+#define PFUZE100_SW4		5
+#define PFUZE100_SWBST		6
+#define PFUZE100_VSNVS		7
+#define PFUZE100_VREFDDR	8
+#define PFUZE100_VGEN1		9
+#define PFUZE100_VGEN2		10
+#define PFUZE100_VGEN3		11
+#define PFUZE100_VGEN4		12
+#define PFUZE100_VGEN5		13
+#define PFUZE100_VGEN6		14
+
+
+struct regulator_init_data;
+struct pfuze_regulator_init_data {
+	int id;
+	struct regulator_init_data *init_data;
+	struct device_node *node;
+};
+struct pfuze_regulator_platform_data {
+	int num_regulators;
+	struct pfuze_regulator_init_data *regulators;
+};
+
+#endif
-- 
1.7.5.4


