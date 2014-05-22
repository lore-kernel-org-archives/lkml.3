Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaEVGkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:40:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:20886 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaEVGkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="543163489"
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
To: lee.jones@linaro.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com, lejun.zhu@linux.intel.com
Subject: [PATCH v2 3/4] mfd: intel_soc_pmic: Crystal Cove support
Date: Thu, 22 May 2014 14:38:41 +0800
Message-Id: <1400740722-8320-4-git-send-email-lejun.zhu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400740722-8320-1-git-send-email-lejun.zhu@linux.intel.com>
References: <1400740722-8320-1-git-send-email-lejun.zhu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crystal Cove is the PMIC in Baytrail-T platform. This patch provides
chip-specific support for Crystal Cove.

v2:
- Add regmap_config for Crystal Cove.

Signed-off-by: Yang, Bin <bin.yang@intel.com>
Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
---
 drivers/mfd/intel_soc_pmic_crc.c | 165 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c

diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
new file mode 100644
index 0000000..6ab4cbf
--- /dev/null
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -0,0 +1,165 @@
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
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/acpi.h>
+#include <linux/version.h>
+#include <linux/regmap.h>
+#include <linux/mfd/intel_soc_pmic.h>
+#include "intel_soc_pmic_core.h"
+
+#define CRYSTAL_COVE_IRQ_NUM		7
+#define CRYSTAL_COVE_MAX_REGISTER	0xBD
+
+#define CHIPID		0x00
+#define CHIPVER		0x01
+#define IRQLVL1		0x02
+#define MIRQLVL1	0x0E
+enum {
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
+static struct resource bcu_resources[] = {
+	{
+		.name  = "BCU",
+		.start = BCU_IRQ,
+		.end   = BCU_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+static struct mfd_cell crystal_cove_dev[] = {
+	{
+		.name = "crystal_cove_pwrsrc",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(pwrsrc_resources),
+		.resources = pwrsrc_resources,
+	},
+	{
+		.name = "crystal_cove_adc",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(adc_resources),
+		.resources = adc_resources,
+	},
+	{
+		.name = "crystal_cove_thermal",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(thermal_resources),
+		.resources = thermal_resources,
+	},
+	{
+		.name = "crystal_cove_bcu",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(bcu_resources),
+		.resources = bcu_resources,
+	},
+	{
+		.name = "crystal_cove_gpio",
+		.id = 0,
+		.num_resources = ARRAY_SIZE(gpio_resources),
+		.resources = gpio_resources,
+	},
+	{NULL, },
+};
+
+#define	CRC_IRQREGMAP_VALUE(irq)	{	\
+		{MIRQLVL1, irq, 1, 0},		\
+		{IRQLVL1,  irq, 1, 0},		\
+		INTEL_PMIC_REG_NULL,		\
+	}
+
+static struct intel_pmic_irqregmap crystal_cove_irqregmap[] = {
+	[PWRSRC_IRQ]	= CRC_IRQREGMAP_VALUE(PWRSRC_IRQ),
+	[THRM_IRQ]	= CRC_IRQREGMAP_VALUE(THRM_IRQ),
+	[BCU_IRQ]	= CRC_IRQREGMAP_VALUE(BCU_IRQ),
+	[ADC_IRQ]	= CRC_IRQREGMAP_VALUE(ADC_IRQ),
+	[CHGR_IRQ]	= CRC_IRQREGMAP_VALUE(CHGR_IRQ),
+	[GPIO_IRQ]	= CRC_IRQREGMAP_VALUE(GPIO_IRQ),
+	[VHDMIOCP_IRQ]	= CRC_IRQREGMAP_VALUE(VHDMIOCP_IRQ),
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
+static int crystal_cove_init(void)
+{
+	pr_debug("Crystal Cove: ID 0x%02X, VERSION 0x%02X\n",
+		 intel_soc_pmic_readb(CHIPID), intel_soc_pmic_readb(CHIPVER));
+	return 0;
+}
+
+struct intel_soc_pmic crystal_cove_pmic = {
+	.label		= "crystal cove",
+	.irq_flags	= IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+	.init		= crystal_cove_init,
+	.cell_dev	= crystal_cove_dev,
+	.irq_regmap	= crystal_cove_irqregmap,
+	.irq_num	= CRYSTAL_COVE_IRQ_NUM,
+	.regmap_cfg	= &crystal_cove_regmap_config,
+};
-- 
1.8.3.2

