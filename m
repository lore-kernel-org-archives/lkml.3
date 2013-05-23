Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3EWMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:17:16 -0400
Received: from mail1.ams.com ([212.166.112.31]:8702 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432Ab3EWMRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:17:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,728,1363129200"; 
   d="scan'208";a="2797470"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 14:07:42 +0200
Subject: [PATCH 04/07] regulator patch of ams AS3722 PMIC against linux_3.8.8
Thread-Topic: [PATCH 04/07] regulator patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Index: Ac5XrRYqFd+0pT4ZR6ucHzXkyGTlWg==
Message-ID: <EB31996D403C2C48A47628A08DCCFD29018405708C@SUX2182.office.amsiag.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Lobmaier <florian.lobmaier@ams.com>

Added multi-function device driver support for ams AS3722 PMIC
Includes modules gpio, regulator, rtc, and watchdog

Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

---
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/regulator/as3722-regulator.c ./drivers/regulator/as3722-regulator.c
--- ../kernel_3.8.8/linux-kernel/drivers/regulator/as3722-regulator.c   1970-01-01 01:00:00.000000000 +0100
+++ ./drivers/regulator/as3722-regulator.c      2013-05-23 13:12:37.000000000 +0200
@@ -0,0 +1,1338 @@
+/*
+ * as3722-regulator.c - voltage regulator support for AS3722
+ *
+ * Copyright (C) 2013 ams
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
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
+ *
+ */
+
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/regulator/driver.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/mfd/as3722-reg.h>
+#include <linux/mfd/as3722-plat.h>
+
+struct as3722_register_mapping {
+       u8 reg_id;
+       u8 reg_vsel;
+       u32 reg_enable;
+       u8 enable_bit;
+       u8 reg_stby_enable;
+};
+
+struct as3722_register_mapping as3722_reg_lookup[] = {
+       {
+               .reg_id = AS3722_LDO0,
+               .reg_vsel = AS3722_LDO0_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO0_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO1,
+               .reg_vsel = AS3722_LDO1_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO1_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO2,
+               .reg_vsel = AS3722_LDO2_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO2_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO3,
+               .reg_vsel = AS3722_LDO3_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO3_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO4,
+               .reg_vsel = AS3722_LDO4_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO4_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO5,
+               .reg_vsel = AS3722_LDO5_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO5_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO6,
+               .reg_vsel = AS3722_LDO6_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO6_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO7,
+               .reg_vsel = AS3722_LDO7_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL0_REG,
+               .enable_bit = AS3722_LDO7_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD2_REG,
+       },
+       {
+               .reg_id = AS3722_LDO9,
+               .reg_vsel = AS3722_LDO9_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL1_REG,
+               .enable_bit = AS3722_LDO9_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD3_REG,
+       },
+       {
+               .reg_id = AS3722_LDO10,
+               .reg_vsel = AS3722_LDO10_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL1_REG,
+               .enable_bit = AS3722_LDO10_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD3_REG,
+       },
+       {
+               .reg_id = AS3722_LDO11,
+               .reg_vsel = AS3722_LDO11_VOLTAGE_REG,
+               .reg_enable = AS3722_LDOCONTROL1_REG,
+               .enable_bit = AS3722_LDO11_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD3_REG,
+       },
+       {
+               .reg_id = AS3722_SD0,
+               .reg_vsel = AS3722_SD0_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD0_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD1,
+               .reg_vsel = AS3722_SD1_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD1_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD2,
+               .reg_vsel = AS3722_SD2_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD2_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD3,
+               .reg_vsel = AS3722_SD3_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD3_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD4,
+               .reg_vsel = AS3722_SD4_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD4_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD5,
+               .reg_vsel = AS3722_SD5_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD5_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+       {
+               .reg_id = AS3722_SD6,
+               .reg_vsel = AS3722_SD6_VOLTAGE_REG,
+               .reg_enable = AS3722_SD_CONTROL_REG,
+               .enable_bit = AS3722_SD6_ON,
+               .reg_stby_enable = AS3722_REG_STANDBY_MOD1_REG,
+       },
+};
+
+/*
+ * as3722 ldo0 extended input range (0.825-1.25V)  */
+static int as3722_ldo0_is_enabled(struct regulator_dev *dev)
+{
+       u32 val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, AS3722_LDOCONTROL0_REG, &val);
+       return (val & AS3722_LDO0_CTRL_MASK) != 0;
+}
+
+static int as3722_ldo0_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_enable,
+                       AS3722_LDO0_CTRL_MASK, AS3722_LDO0_ON);
+}
+
+static int as3722_ldo0_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_enable,
+                       AS3722_LDO0_CTRL_MASK, 0);
+}
+
+static int as3722_ldo0_list_voltage(struct regulator_dev *dev,
+               unsigned selector)
+{
+       if (selector >= AS3722_LDO0_VSEL_MAX)
+               return -EINVAL;
+
+       return 800000 + (selector + 1) * 25000;
+}
+
+static int as3722_ldo0_map_voltage(struct regulator_dev *dev,
+                                       int min_uV, int max_uV)
+{
+       int val, sel;
+
+       if (min_uV > 1250000 || max_uV < 825000)
+               return -EINVAL;
+
+       /* 25mV steps from 0.825V-1.25V */
+       val = (min_uV - 800001) / 25000 + 1;
+       if (val < 1)
+               val = 1;
+
+       sel = (u8) val;
+       if (sel * 25000 + 800000 > max_uV)
+               return -EINVAL;
+
+       BUG_ON(sel * 25000 + 800000 < min_uV);
+       BUG_ON(sel > AS3722_LDO0_VSEL_MAX);
+
+       return sel;
+}
+
+static int as3722_ldo0_get_voltage(struct regulator_dev *dev)
+{
+       u32 val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_vsel, &val);
+       val &= AS3722_LDO_VSEL_MASK;
+       if (val > 0)
+               val--;  /* ldo vsel has min value of 1, selector starts
+                          at 0 */
+
+       return as3722_ldo0_list_voltage(dev, val);
+}
+
+static int as3722_ldo0_set_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV, unsigned *selector)
+{
+       u8 reg_val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       reg_val = as3722_ldo0_map_voltage(dev, min_uV, max_uV);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_vsel,
+                       AS3722_LDO_VSEL_MASK, reg_val);
+}
+
+static int as3722_ldo0_get_current_limit(struct regulator_dev *dev)
+{
+       u32 val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[rdev_get_id(dev)].reg_vsel,
+                       &val);
+       val &= AS3722_LDO_ILIMIT_MASK;
+
+       /* return ldo specific values */
+       if (val)
+               return 300000;
+
+       return 150000;
+}
+
+static int as3722_ldo0_set_current_limit(struct regulator_dev *dev,
+               int min_uA, int max_uA)
+{
+       u8 val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       /* we check the values in case the constraints are wrong */
+       if (min_uA <= 150000 && max_uA >= 150000)
+               val = 0;
+       else if (min_uA > 150000 && max_uA >= 300000)
+               val = AS3722_LDO_ILIMIT_BIT;
+       else
+               return -EINVAL;
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_vsel,
+                       AS3722_LDO_ILIMIT_MASK, val);
+}
+
+static int as3722_ldo0_set_suspend_voltage(struct regulator_dev *dev, int uV)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+       int sel;
+
+       if (as3722->reg_stby_counter > (AS3722_MAX_REG_STBY_COUNT-1))
+               return -EINVAL;
+
+       sel = as3722_ldo0_map_voltage(dev, uV, uV);
+       if (sel < 0)
+               return -EINVAL;
+
+       /* regulator select */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_CONTROL_REG + as3722->reg_stby_counter,
+                       AS3722_REG_SELECT_STBY_MASK,
+                       as3722_reg_lookup[id].reg_vsel);
+       /* apply voltage */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_VOLTAGE_REG + as3722->reg_stby_counter,
+                       AS3722_REG_VOLTAGE_STBY_MASK,
+                       sel);
+       as3722->reg_stby_counter++;
+
+       return 0;
+}
+
+static int as3722_ldo0_set_suspend_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+
+       return 0;
+}
+
+static int as3722_ldo0_set_suspend_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       0);
+
+       return 0;
+}
+
+static struct regulator_ops as3722_ldo0_ops = {
+       .is_enabled = as3722_ldo0_is_enabled,
+       .enable = as3722_ldo0_enable,
+       .disable = as3722_ldo0_disable,
+       .list_voltage = as3722_ldo0_list_voltage,
+       .map_voltage = as3722_ldo0_map_voltage,
+       .get_voltage = as3722_ldo0_get_voltage,
+       .set_voltage = as3722_ldo0_set_voltage,
+       .get_current_limit = as3722_ldo0_get_current_limit,
+       .set_current_limit = as3722_ldo0_set_current_limit,
+       .set_suspend_voltage = as3722_ldo0_set_suspend_voltage,
+       .set_suspend_enable = as3722_ldo0_set_suspend_enable,
+       .set_suspend_disable = as3722_ldo0_set_suspend_disable,
+};
+
+/*
+ * as3722 ldo3 low output range (0.61V-1.5V)  */
+static int as3722_ldo3_is_enabled(struct regulator_dev *dev)
+{
+       u32 val = 0;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[rdev_get_id(dev)].reg_enable,
+                       &val);
+       return (val & AS3722_LDO3_CTRL_MASK) != 0;
+}
+
+static int as3722_ldo3_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_enable,
+                       AS3722_LDO3_CTRL_MASK, AS3722_LDO3_ON);
+}
+
+static int as3722_ldo3_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_enable,
+                       AS3722_LDO3_CTRL_MASK, 0);
+}
+
+static int as3722_ldo3_list_voltage(struct regulator_dev *dev,
+               unsigned selector)
+{
+       if (selector >= AS3722_LDO3_VSEL_MAX)
+               return -EINVAL;
+
+       return 600000 + (selector + 1) * 20000;
+}
+
+static int as3722_ldo3_map_voltage(struct regulator_dev *dev,
+                                       int min_uV, int max_uV)
+{
+       int val, sel;
+
+       if (min_uV > 1500000 || max_uV < 620000)
+               return -EINVAL;
+
+       /* 20mV steps from 0.62V to 1.5V */
+       val = (min_uV - 600001) / 20000 + 1;
+       if (val < 1)
+               val = 1;
+
+       sel = (u8) val;
+       if (sel * 20000 + 600000 > max_uV)
+               return -EINVAL;
+
+       BUG_ON(sel * 20000 + 600000 < min_uV);
+       BUG_ON(sel > AS3722_LDO3_VSEL_MAX);
+
+       return sel;
+}
+
+static int as3722_ldo3_get_voltage(struct regulator_dev *dev)
+{
+       u32 val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_vsel, &val);
+       val &= AS3722_LDO3_VSEL_MASK;
+       if (val > 0)
+               val--;  /* ldo vsel has min value 1, selector starts at
+                          0 */
+
+       return as3722_ldo3_list_voltage(dev, val);
+}
+
+static int as3722_ldo3_set_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV, unsigned *selector)
+{
+       u8 reg_val;
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       reg_val = as3722_ldo3_map_voltage(dev, min_uV, max_uV);
+
+       return as3722_set_bits(as3722,
+                       as3722_reg_lookup[rdev_get_id(dev)].reg_vsel,
+                       AS3722_LDO3_VSEL_MASK, reg_val);
+}
+
+static int as3722_ldo3_get_current_limit(struct regulator_dev *dev)
+{
+       return 150000;
+}
+
+static int as3722_ldo3_set_suspend_voltage(struct regulator_dev *dev, int uV)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+       int sel;
+
+       if (as3722->reg_stby_counter > (AS3722_MAX_REG_STBY_COUNT-1))
+               return -EINVAL;
+
+       sel = as3722_ldo3_map_voltage(dev, uV, uV);
+       if (sel < 0)
+               return -EINVAL;
+
+       /* regulator select */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_CONTROL_REG + as3722->reg_stby_counter,
+                       AS3722_REG_SELECT_STBY_MASK,
+                       as3722_reg_lookup[id].reg_vsel);
+       /* apply voltage */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_VOLTAGE_REG + as3722->reg_stby_counter,
+                       AS3722_REG_VOLTAGE_STBY_MASK,
+                       sel);
+       as3722->reg_stby_counter++;
+
+       return 0;
+}
+
+static int as3722_ldo3_set_suspend_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+
+       return 0;
+}
+
+static int as3722_ldo3_set_suspend_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       0);
+
+       return 0;
+}
+
+static struct regulator_ops as3722_ldo3_ops = {
+       .is_enabled = as3722_ldo3_is_enabled,
+       .enable = as3722_ldo3_enable,
+       .disable = as3722_ldo3_disable,
+       .list_voltage = as3722_ldo3_list_voltage,
+       .map_voltage = as3722_ldo3_map_voltage,
+       .get_voltage = as3722_ldo3_get_voltage,
+       .set_voltage = as3722_ldo3_set_voltage,
+       .get_current_limit = as3722_ldo3_get_current_limit,
+       .set_suspend_voltage = as3722_ldo3_set_suspend_voltage,
+       .set_suspend_enable = as3722_ldo3_set_suspend_enable,
+       .set_suspend_disable = as3722_ldo3_set_suspend_disable,
+};
+
+/*
+ * as3722 ldo 1-2 and 4-11 (0.8V-3.3V)
+ */
+static int as3722_ldo_is_enabled(struct regulator_dev *dev)
+{
+       u32 val = 0;
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[id].reg_enable, &val);
+       return (val & as3722_reg_lookup[id].enable_bit) != 0;
+}
+
+static int as3722_ldo_enable(struct regulator_dev *dev)
+{
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+}
+
+static int as3722_ldo_disable(struct regulator_dev *dev)
+{
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_enable,
+                       as3722_reg_lookup[id].enable_bit, 0);
+}
+
+static int as3722_ldo_list_voltage(struct regulator_dev *dev,
+               unsigned selector)
+{
+       if (selector >= AS3722_LDO_NUM_VOLT)
+               return -EINVAL;
+
+       selector++;     /* ldo vsel min value is 1, selector starts at 0. */
+       return 800000 + selector * 25000;
+}
+
+static int as3722_ldo_map_voltage(struct regulator_dev *dev,
+                                       int min_uV, int max_uV)
+{
+       int val, sel;
+
+       if (min_uV > 3300000 || max_uV < 825000)
+               return -EINVAL;
+
+       if (min_uV <= 1700000) {
+               /* 25mV steps from 0.825V to 1.7V */
+               val = (min_uV - 800001) / 25000 + 1;
+               if (val < 1)
+                       val = 1;
+               sel = (u8) val;
+               if (sel * 25000 + 800000 > max_uV)
+                       return -EINVAL;
+               BUG_ON(sel * 25000 + 800000 < min_uV);
+       } else {
+               /* 25mV steps from 1.725V to 3.3V */
+               sel = (min_uV - 1700001) / 25000 + 0x40;
+               if ((sel - 0x40) * 25000 + 1725000 > max_uV)
+                       return -EINVAL;
+               BUG_ON((sel - 0x40) * 25000 + 1725000 < min_uV);
+       }
+
+       BUG_ON(sel > AS3722_LDO_VSEL_MAX);
+
+       return sel;
+}
+
+static int as3722_ldo_get_voltage(struct regulator_dev *dev)
+{
+       u32 val;
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[id].reg_vsel, &val);
+       val &= AS3722_LDO_VSEL_MASK;
+       /* ldo vsel has a gap from 0x25 to 0x3F (27 values). */
+       if (val > AS3722_LDO_VSEL_DNU_MAX)
+               val -= 27;
+       /* ldo vsel min value is 1, selector starts at 0. */
+       if (val > 0)
+               val--;
+
+       return as3722_ldo_list_voltage(dev, val);
+}
+
+static int as3722_ldo_set_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV, unsigned *selector)
+{
+       u8 reg_val;
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       reg_val = as3722_ldo_map_voltage(dev, min_uV, max_uV);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_vsel,
+                       AS3722_LDO_VSEL_MASK, reg_val);
+}
+
+static int as3722_ldo_get_current_limit(struct regulator_dev *dev)
+{
+       u32 val;
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[id].reg_vsel, &val);
+       val &= AS3722_LDO_ILIMIT_MASK;
+
+       /* return ldo specific values */
+       if (val)
+               return 300000;
+
+       return 150000;
+}
+
+static int as3722_ldo_set_current_limit(struct regulator_dev *dev,
+               int min_uA, int max_uA)
+{
+       u8 val;
+       int loweruA = 150000;
+       int id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       /* we check the values in case the constraints are wrong */
+       if (min_uA <= loweruA && max_uA >= loweruA)
+               val = 0;
+       else if (min_uA > loweruA && max_uA >= 300000)
+               val = AS3722_LDO_ILIMIT_BIT;
+       else
+               return -EINVAL;
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_vsel,
+                       AS3722_LDO_ILIMIT_MASK, val);
+}
+
+static int as3722_ldo_set_suspend_voltage(struct regulator_dev *dev, int uV)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+       int sel;
+
+       if (as3722->reg_stby_counter > (AS3722_MAX_REG_STBY_COUNT-1))
+               return -EINVAL;
+
+       sel = as3722_ldo_map_voltage(dev, uV, uV);
+       if (sel < 0)
+               return -EINVAL;
+
+       /* regulator select */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_CONTROL_REG + as3722->reg_stby_counter,
+                       AS3722_REG_SELECT_STBY_MASK,
+                       as3722_reg_lookup[id].reg_vsel);
+       /* apply voltage */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_VOLTAGE_REG + as3722->reg_stby_counter,
+                       AS3722_REG_VOLTAGE_STBY_MASK,
+                       sel);
+       as3722->reg_stby_counter++;
+
+       return 0;
+}
+
+static int as3722_ldo_set_suspend_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+
+       return 0;
+}
+
+static int as3722_ldo_set_suspend_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       0);
+
+       return 0;
+}
+
+static struct regulator_ops as3722_ldo_ops = {
+       .is_enabled = as3722_ldo_is_enabled,
+       .enable = as3722_ldo_enable,
+       .disable = as3722_ldo_disable,
+       .list_voltage = as3722_ldo_list_voltage,
+       .map_voltage = as3722_ldo_map_voltage,
+       .get_voltage = as3722_ldo_get_voltage,
+       .set_voltage = as3722_ldo_set_voltage,
+       .get_current_limit = as3722_ldo_get_current_limit,
+       .set_current_limit = as3722_ldo_set_current_limit,
+       .set_suspend_voltage = as3722_ldo_set_suspend_voltage,
+       .set_suspend_enable = as3722_ldo_set_suspend_enable,
+       .set_suspend_disable = as3722_ldo_set_suspend_disable,
+};
+
+/*
+ * as3722 step down
+ */
+static int as3722_sd_is_enabled(struct regulator_dev *dev)
+{
+       u32 val;
+       u8 id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[id].reg_enable, &val);
+
+       return (val & as3722_reg_lookup[id].enable_bit) != 0;
+}
+
+static int as3722_sd_enable(struct regulator_dev *dev)
+{
+       u8 id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+}
+
+static int as3722_sd_disable(struct regulator_dev *dev)
+{
+       u8 id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_enable,
+                       as3722_reg_lookup[id].enable_bit, 0);
+}
+
+static unsigned int as3722_sd_get_mode(struct regulator_dev *dev)
+{
+       u32 val;
+       u8 reg_id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, AS3722_SD_CONTROL_REG, &val);
+
+       switch (rdev_get_id(dev)) {
+       case AS3722_SD0:
+               as3722_reg_read(as3722, AS3722_SD0_CONTROL_REG, &val);
+               if ((val & AS3722_SD0_MODE_MASK) == AS3722_SD0_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD1:
+               as3722_reg_read(as3722, AS3722_SD1_CONTROL_REG, &val);
+               if ((val & AS3722_SD1_MODE_MASK) == AS3722_SD1_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD2:
+               as3722_reg_read(as3722, AS3722_SD23_CONTROL_REG, &val);
+               if ((val & AS3722_SD2_MODE_MASK) == AS3722_SD2_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD3:
+               as3722_reg_read(as3722, AS3722_SD23_CONTROL_REG, &val);
+               if ((val & AS3722_SD3_MODE_MASK) == AS3722_SD3_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD4:
+               as3722_reg_read(as3722, AS3722_SD4_CONTROL_REG, &val);
+               if ((val & AS3722_SD1_MODE_MASK) == AS3722_SD1_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD5:
+               as3722_reg_read(as3722, AS3722_SD5_CONTROL_REG, &val);
+               if ((val & AS3722_SD1_MODE_MASK) == AS3722_SD1_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       case AS3722_SD6:
+               as3722_reg_read(as3722, AS3722_SD6_CONTROL_REG, &val);
+               if ((val & AS3722_SD1_MODE_MASK) == AS3722_SD1_MODE_FAST)
+                       return REGULATOR_MODE_FAST;
+               else
+                       return REGULATOR_MODE_NORMAL;
+       default:
+               dev_err(as3722->dev, "regulator id %d invalid.\n",
+                               reg_id);
+       }
+
+       return -ERANGE;
+}
+
+static int as3722_sd_set_mode(struct regulator_dev *dev,
+               unsigned int mode)
+{
+       u8 val, mask, reg;
+       u8 id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       if (mode != REGULATOR_MODE_FAST && mode != REGULATOR_MODE_NORMAL)
+               return -EINVAL;
+
+       switch (id) {
+       case AS3722_SD0:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD0_MODE_FAST;
+               else
+                       val = AS3722_SD0_MODE_NORMAL;
+
+               reg = AS3722_SD0_CONTROL_REG;
+               mask = AS3722_SD0_MODE_MASK;
+               break;
+       case AS3722_SD1:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD1_MODE_FAST;
+               else
+                       val = AS3722_SD1_MODE_NORMAL;
+
+               reg = AS3722_SD1_CONTROL_REG;
+               mask = AS3722_SD1_MODE_MASK;
+               break;
+       case AS3722_SD2:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD2_MODE_FAST;
+               else
+                       val = AS3722_SD2_MODE_NORMAL;
+
+               reg = AS3722_SD23_CONTROL_REG;
+               mask = AS3722_SD2_MODE_MASK;
+               break;
+       case AS3722_SD3:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD3_MODE_FAST;
+               else
+                       val = AS3722_SD3_MODE_NORMAL;
+
+               reg = AS3722_SD23_CONTROL_REG;
+               mask = AS3722_SD3_MODE_MASK;
+               break;
+       case AS3722_SD4:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD4_MODE_FAST;
+               else
+                       val = AS3722_SD4_MODE_NORMAL;
+
+               reg = AS3722_SD4_CONTROL_REG;
+               mask = AS3722_SD4_MODE_MASK;
+               break;
+       case AS3722_SD5:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD5_MODE_FAST;
+               else
+                       val = AS3722_SD5_MODE_NORMAL;
+
+               reg = AS3722_SD5_CONTROL_REG;
+               mask = AS3722_SD5_MODE_MASK;
+               break;
+       case AS3722_SD6:
+               if (mode == REGULATOR_MODE_FAST)
+                       val = AS3722_SD6_MODE_FAST;
+               else
+                       val = AS3722_SD6_MODE_NORMAL;
+
+               reg = AS3722_SD6_CONTROL_REG;
+               mask = AS3722_SD6_MODE_MASK;
+               break;
+       default:
+               dev_err(as3722->dev, "regulator id %d invalid.\n",
+                               id);
+               return -EINVAL;
+       }
+
+       return as3722_set_bits(as3722, reg, mask, val);
+}
+
+static int as3722_sd_list_voltage(struct regulator_dev *dev, unsigned
+               selector) {
+       u8 id = rdev_get_id(dev);
+
+       if (id == AS3722_SD0 || id == AS3722_SD1 || id == AS3722_SD6) {
+               if (selector >= AS3722_SD0_VSEL_MAX)
+                       return -EINVAL;
+
+               return 600000 + (selector + 1) * 10000;
+       } else {
+               if (selector > AS3722_SD2_VSEL_MAX)
+                       return -EINVAL;
+
+               /* ldo vsel min value is 1, selector starts at 0. */
+               selector++;
+               if (selector <= 0x40)
+                       return 600000 + selector * 12500;
+               if (selector <= 0x70)
+                       return 1400000 + (selector - 0x40) * 25000;
+               if (selector <= 0x7F)
+                       return 2600000 + (selector - 0x70) * 50000;
+
+               return -ERANGE;
+       }
+       return -EINVAL;
+}
+
+static int as3722_sd_lowpower_map_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV)
+{
+       int val, sel;
+
+       /*       0 ... 0        0x00 : not allowed as voltage setting
+        *  610000 ... 1500000: 0x01 - 0x40, 10mV steps */
+
+       if (min_uV > 1500000 || max_uV < 610000)
+               return -EINVAL;
+
+       val = (min_uV - 600001) / 10000 + 1;
+       if (val < 1)
+               val = 1;
+
+       sel = (u8) val;
+       if (sel * 10000 + 600000 > max_uV)
+               return -EINVAL;
+       BUG_ON(sel * 10000 + 600000 < min_uV);
+
+       return sel;
+}
+
+static int as3722_sd_nom_map_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV)
+{
+       int val, sel;
+
+       /*       0 ... 0        0x00 : not allowed as voltage setting
+        *  612500 ... 1400000: 0x01 - 0x40, 12.5mV steps
+        * 1425000 ... 2600000: 0x41 - 0x70, 25mV steps
+        * 2650000 ... 3350000: 0x41 - 0x70, 50mV steps */
+
+       if (min_uV > 3350000 || max_uV < 612500)
+               return -EINVAL;
+
+       if (min_uV <= 1400000) {
+               val = (min_uV - 600001) / 12500 + 1;
+               if (val < 1)
+                       val = 1;
+
+               sel = (u8) val;
+               if ((sel * 12500) + 600000 > max_uV)
+                       return -EINVAL;
+
+               BUG_ON((sel * 12500) + 600000 < min_uV);
+
+       } else if (min_uV <= 2600000) {
+               sel = (min_uV - 1400001) / 25000 + 1;
+
+               if ((sel * 25000) + 1400000 > max_uV)
+                       return -EINVAL;
+
+               BUG_ON((sel * 25000) + 1400000 < min_uV);
+
+               sel += 0x40;
+
+       } else {
+
+               sel = (min_uV - 2600001) / 50000 + 1;
+
+               if ((sel * 50000) + 2600000 > max_uV)
+                       return -EINVAL;
+
+               BUG_ON((sel * 50000) + 2600000 < min_uV);
+
+               sel += 0x70;
+       }
+
+       return sel;
+}
+static int as3722_sd_map_voltage(struct regulator_dev *dev,
+                                       int min_uV, int max_uV)
+{
+       int id = rdev_get_id(dev);
+
+       if (id == AS3722_SD0 || id == AS3722_SD1 || id == AS3722_SD6)
+               return as3722_sd_lowpower_map_voltage(dev, min_uV, max_uV);
+       else
+               return as3722_sd_nom_map_voltage(dev, min_uV, max_uV);
+}
+
+static int as3722_sd_get_voltage(struct regulator_dev *dev)
+{
+       u32 val;
+       u8 id = rdev_get_id(dev);
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+
+       as3722_reg_read(as3722, as3722_reg_lookup[id].reg_vsel, &val);
+       val &= AS3722_SD_VSEL_MASK;
+       if (val > 0)
+               val--;  /* ldo vsel min value is 1, selector starts at
+                          0. */
+
+       return as3722_sd_list_voltage(dev, val);
+}
+
+static int as3722_sd_set_voltage(struct regulator_dev *dev,
+               int min_uV, int max_uV, unsigned *selector)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       u8 id = rdev_get_id(dev);
+       int sel;
+
+       sel = as3722_sd_map_voltage(dev, min_uV, max_uV);
+
+       return as3722_set_bits(as3722, as3722_reg_lookup[id].reg_vsel,
+                               AS3722_SD_VSEL_MASK, sel);
+}
+
+static int as3722_sd_set_suspend_voltage(struct regulator_dev *dev, int uV)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+       int sel;
+
+       if (as3722->reg_stby_counter > (AS3722_MAX_REG_STBY_COUNT-1))
+               return -EINVAL;
+
+       sel = as3722_sd_map_voltage(dev, uV, uV);
+       if (sel < 0)
+               return -EINVAL;
+
+       /* regulator select */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_CONTROL_REG + as3722->reg_stby_counter,
+                       AS3722_REG_SELECT_STBY_MASK,
+                       as3722_reg_lookup[id].reg_vsel);
+       /* apply voltage */
+       as3722_set_bits(as3722,
+                       AS3722_REG0_VOLTAGE_REG + as3722->reg_stby_counter,
+                       AS3722_REG_VOLTAGE_STBY_MASK,
+                       sel);
+       as3722->reg_stby_counter++;
+
+       return 0;
+}
+
+static int as3722_sd_set_suspend_enable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       as3722_reg_lookup[id].enable_bit);
+
+       return 0;
+}
+
+static int as3722_sd_set_suspend_disable(struct regulator_dev *dev)
+{
+       struct as3722 *as3722 = rdev_get_drvdata(dev);
+       int id = rdev_get_id(dev);
+
+       as3722_set_bits(as3722,
+                       as3722_reg_lookup[id].reg_stby_enable,
+                       as3722_reg_lookup[id].enable_bit,
+                       0);
+
+       return 0;
+}
+
+static struct regulator_ops as3722_sd_ops = {
+       .is_enabled = as3722_sd_is_enabled,
+       .enable = as3722_sd_enable,
+       .disable = as3722_sd_disable,
+       .list_voltage = as3722_sd_list_voltage,
+       .map_voltage = as3722_sd_map_voltage,
+       .get_voltage = as3722_sd_get_voltage,
+       .set_voltage = as3722_sd_set_voltage,
+       .get_mode = as3722_sd_get_mode,
+       .set_mode = as3722_sd_set_mode,
+       .set_suspend_voltage = as3722_sd_set_suspend_voltage,
+       .set_suspend_enable = as3722_sd_set_suspend_enable,
+       .set_suspend_disable = as3722_sd_set_suspend_disable,
+};
+
+static struct regulator_desc regulators[] = {
+       {
+               .name = "as3722-ldo0",
+               .id = AS3722_LDO0,
+               .ops = &as3722_ldo0_ops,
+               .n_voltages = AS3722_LDO0_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo1",
+               .id = AS3722_LDO1,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo2",
+               .id = AS3722_LDO2,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo3",
+               .id = AS3722_LDO3,
+               .ops = &as3722_ldo3_ops,
+               .n_voltages = AS3722_LDO3_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo4",
+               .id = AS3722_LDO4,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo5",
+               .id = AS3722_LDO5,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo6",
+               .id = AS3722_LDO6,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo7",
+               .id = AS3722_LDO7,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo9",
+               .id = AS3722_LDO9,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo10",
+               .id = AS3722_LDO10,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-ldo11",
+               .id = AS3722_LDO11,
+               .ops = &as3722_ldo_ops,
+               .n_voltages = AS3722_LDO_NUM_VOLT,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd0",
+               .id = AS3722_SD0,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD0_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd1",
+               .id = AS3722_SD1,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD0_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd2",
+               .id = AS3722_SD2,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD2_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd3",
+               .id = AS3722_SD3,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD2_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd4",
+               .id = AS3722_SD4,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD2_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd5",
+               .id = AS3722_SD5,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD2_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+       {
+               .name = "as3722-sd6",
+               .id = AS3722_SD6,
+               .ops = &as3722_sd_ops,
+               .n_voltages = AS3722_SD0_VSEL_MAX,
+               .type = REGULATOR_VOLTAGE,
+               .owner = THIS_MODULE,
+       },
+};
+
+static int as3722_regulator_probe(struct platform_device *pdev)
+{
+       struct regulator_dev *rdev;
+       struct regulator_config config = { };
+       struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+       struct as3722_platform_data *pdata = as3722->dev->platform_data;
+       int regulator;
+
+       if (WARN_ON(pdev->id < 0 || pdev->id >= AS3722_NUM_REGULATORS))
+               return -EINVAL;
+
+       config.dev = pdev->dev.parent;
+       config.driver_data = as3722;
+       config.regmap = as3722->regmap;
+
+       for (regulator = 0; regulator < AS3722_NUM_REGULATORS; regulator++) {
+               if (pdata->reg_init[regulator]) {
+                       config.init_data = pdata->reg_init[regulator];
+                       rdev = regulator_register(&regulators[regulator],
+                                       &config);
+                       if (IS_ERR(rdev)) {
+                               dev_err(&pdev->dev,
+                                       "as3722 register"
+                                       "regulator nr %d err\n",
+                                       regulator);
+                               return PTR_ERR(rdev);
+                       }
+                       as3722->rdevs[regulator] = rdev;
+               }
+       }
+       return 0;
+}
+
+static int as3722_regulator_remove(struct platform_device *pdev)
+{
+       struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
+       int regulator;
+
+       if (WARN_ON(pdev->id < 0 || pdev->id >= AS3722_NUM_REGULATORS))
+               return -EINVAL;
+
+       for (regulator = 0; regulator < AS3722_NUM_REGULATORS; regulator++) {
+               if (as3722->rdevs[regulator]) {
+                       regulator_unregister(as3722->rdevs[regulator]);
+                       as3722->rdevs[regulator] = NULL;
+               }
+       }
+       return 0;
+}
+
+static struct platform_driver as3722_regulator_driver = {
+       .driver = {
+               .name = "as3722-regulator",
+               .owner = THIS_MODULE,
+       },
+       .probe = as3722_regulator_probe,
+       .remove = as3722_regulator_remove,
+};
+
+static int __init as3722_regulator_init(void)
+{
+       return platform_driver_register(&as3722_regulator_driver);
+}
+
+subsys_initcall(as3722_regulator_init);
+
+static void __exit as3722_regulator_exit(void)
+{
+       platform_driver_unregister(&as3722_regulator_driver);
+}
+
+module_exit(as3722_regulator_exit);
+
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_DESCRIPTION("AS3722 regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:as3722-regulator");
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/regulator/Kconfig ./drivers/regulator/Kconfig
--- ../kernel_3.8.8/linux-kernel/drivers/regulator/Kconfig      2013-05-15 14:55:55.000000000 +0200
+++ ./drivers/regulator/Kconfig 2013-05-23 13:12:37.000000000 +0200
@@ -95,6 +95,13 @@ config REGULATOR_ARIZONA
          Support for the regulators found on Wolfson Arizona class
          devices.

+config REGULATOR_AS3722
+       tristate "ams AS3722 PMIC regulators"
+       depends on MFD_AS3722
+       help
+         This driver provides support for the voltage regulators of the
+         ams AS3722 PMIC.
+
 config REGULATOR_DA903X
        tristate "Dialog Semiconductor DA9030/DA9034 regulators"
        depends on PMIC_DA903X
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/regulator/Makefile ./drivers/regulator/Makefile
--- ../kernel_3.8.8/linux-kernel/drivers/regulator/Makefile     2013-05-15 14:55:55.000000000 +0200
+++ ./drivers/regulator/Makefile        2013-05-23 13:12:37.000000000 +0200
@@ -17,6 +17,7 @@ obj-$(CONFIG_REGULATOR_AD5398) += ad5398
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
 obj-$(CONFIG_REGULATOR_AS3711) += as3711-regulator.o
+obj-$(CONFIG_REGULATOR_AS3722) += as3722-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X) += da903x.o
 obj-$(CONFIG_REGULATOR_DA9052) += da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055) += da9055-regulator.o
