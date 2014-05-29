Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbaE2HUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:20:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:42065 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbaE2HU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:20:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="548236216"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v4 2/3] mfd: intel_soc_pmic: Crystal Cove support
Date: Thu, 29 May 2014 15:19:27 +0800
Message-Id: <1401347968-24410-3-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides chip-specific support for Crystal Cove. Crystal
Cove is the PMIC in Baytrail-T platform.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
v2:
- Add regmap_config for Crystal Cove.
v3:
- Convert IRQ config to regmap_irq_chip.
v4:
- Cleanup include files.
- Remove useless init() function.
- Remove useless .label and .init from struct intel_soc_pmic_config.
- Fix various coding style issues.
---
 drivers/mfd/intel_soc_pmic_crc.c | 160 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 160 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c

diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
new file mode 100644
index 0000000..43dbfcd
--- /dev/null
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -0,0 +1,160 @@
+/*
+ * intel_soc_pmic_crc.c - Device access for Crystal Cove PMIC
+ *
+ * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Author: Yang, Bin <bin.yang@intel.com>
+ * Author: Zhu, Lejun <lejun.zhu@linux.intel.com>
+ */
+
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/mfd/intel_soc_pmic.h>
+#include "intel_soc_pmic_core.h"
+
+#define CRYSTAL_COVE_MAX_REGISTER	0xC6
+
+#define REG_IRQLVL1			0x02
+#define REG_MIRQLVL1			0x0E
+
+enum crystal_cove_irq {
+	PWRSRC_IRQ = 0,
+	THRM_IRQ,
+	BCU_IRQ,
+	ADC_IRQ,
+	CHGR_IRQ,
+	GPIO_IRQ,
+	VHDMIOCP_IRQ
+};
+
+static struct resource gpio_resources[] = {
+	{
+		.name	= "GPIO",
+		.start	= GPIO_IRQ,
+		.end	= GPIO_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource pwrsrc_resources[] = {
+	{
+		.name  = "PWRSRC",
+		.start = PWRSRC_IRQ,
+		.end   = PWRSRC_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource adc_resources[] = {
+	{
+		.name  = "ADC",
+		.start = ADC_IRQ,
+		.end   = ADC_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource thermal_resources[] = {
+	{
+		.name  = "THERMAL",
+		.start = THRM_IRQ,
+		.end   = THRM_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource bcu_resources[] = {
+	{
+		.name  = "BCU",
+		.start = BCU_IRQ,
+		.end   = BCU_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell crystal_cove_dev[] = {
+	{
+		.name = "crystal_cove_pwrsrc",
+		.num_resources = ARRAY_SIZE(pwrsrc_resources),
+		.resources = pwrsrc_resources,
+	},
+	{
+		.name = "crystal_cove_adc",
+		.num_resources = ARRAY_SIZE(adc_resources),
+		.resources = adc_resources,
+	},
+	{
+		.name = "crystal_cove_thermal",
+		.num_resources = ARRAY_SIZE(thermal_resources),
+		.resources = thermal_resources,
+	},
+	{
+		.name = "crystal_cove_bcu",
+		.num_resources = ARRAY_SIZE(bcu_resources),
+		.resources = bcu_resources,
+	},
+	{
+		.name = "crystal_cove_gpio",
+		.num_resources = ARRAY_SIZE(gpio_resources),
+		.resources = gpio_resources,
+	},
+};
+
+static struct regmap_config crystal_cove_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = CRYSTAL_COVE_MAX_REGISTER,
+	.cache_type = REGCACHE_NONE,
+};
+
+static const struct regmap_irq crystal_cove_irqs[] = {
+	[PWRSRC_IRQ] = {
+		.mask = BIT(PWRSRC_IRQ),
+	},
+	[THRM_IRQ] = {
+		.mask = BIT(THRM_IRQ),
+	},
+	[BCU_IRQ] = {
+		.mask = BIT(BCU_IRQ),
+	},
+	[ADC_IRQ] = {
+		.mask = BIT(ADC_IRQ),
+	},
+	[CHGR_IRQ] = {
+		.mask = BIT(CHGR_IRQ),
+	},
+	[GPIO_IRQ] = {
+		.mask = BIT(GPIO_IRQ),
+	},
+	[VHDMIOCP_IRQ] = {
+		.mask = BIT(VHDMIOCP_IRQ),
+	},
+};
+
+static struct regmap_irq_chip crystal_cove_irq_chip = {
+	.name = "Crystal Cove",
+	.irqs = crystal_cove_irqs,
+	.num_irqs = ARRAY_SIZE(crystal_cove_irqs),
+	.num_regs = 1,
+	.status_base = REG_IRQLVL1,
+	.mask_base = REG_MIRQLVL1,
+};
+
+struct intel_soc_pmic_config intel_soc_pmic_config_crc = {
+	.irq_flags = IRQF_TRIGGER_RISING,
+	.cell_dev = crystal_cove_dev,
+	.n_cell_devs = ARRAY_SIZE(crystal_cove_dev),
+	.regmap_config = &crystal_cove_regmap_config,
+	.irq_chip = &crystal_cove_irq_chip,
+};
-- 
1.8.3.2

