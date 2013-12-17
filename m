Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3LQNBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:01:18 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50600 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3LQNA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:57 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/7] ARM: OMAP2+: Remove platform-specific omap-iommu
Date: Tue, 17 Dec 2013 13:53:38 +0100
Message-Id: <1387284818-28739-8-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With full DT boot, the platform specific part of the OMAP iommu
is not useful anymore.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 arch/arm/mach-omap2/Makefile     |  3 --
 arch/arm/mach-omap2/omap-iommu.c | 79 ----------------------------------------
 2 files changed, 82 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/omap-iommu.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 35be79f..4e01b61 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -219,9 +219,6 @@ obj-$(CONFIG_SOC_DRA7XX)		+= omap_hwmod_7xx_data.o
 obj-$(CONFIG_OMAP3_EMU)			+= emu.o
 obj-$(CONFIG_HW_PERF_EVENTS)		+= pmu.o
 
-iommu-$(CONFIG_OMAP_IOMMU)		:= omap-iommu.o
-obj-y					+= $(iommu-m) $(iommu-y)
-
 ifneq ($(CONFIG_TIDSPBRIDGE),)
 obj-y					+= dsp.o
 endif
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
deleted file mode 100644
index f1fab56..0000000
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * omap iommu: omap device registration
- *
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/of.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-
-#include <linux/platform_data/iommu-omap.h>
-#include "soc.h"
-#include "omap_hwmod.h"
-#include "omap_device.h"
-
-static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
-{
-	struct platform_device *pdev;
-	struct iommu_platform_data *pdata;
-	struct omap_mmu_dev_attr *a = (struct omap_mmu_dev_attr *)oh->dev_attr;
-	static int i;
-
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
-
-	pdata->name = oh->name;
-	pdata->nr_tlb_entries = a->nr_tlb_entries;
-	pdata->da_start = a->da_start;
-	pdata->da_end = a->da_end;
-
-	if (oh->rst_lines_cnt == 1) {
-		pdata->reset_name = oh->rst_lines->name;
-		pdata->assert_reset = omap_device_assert_hardreset;
-		pdata->deassert_reset = omap_device_deassert_hardreset;
-	}
-
-	pdev = omap_device_build("omap-iommu", i, oh, pdata, sizeof(*pdata));
-
-	kfree(pdata);
-
-	if (IS_ERR(pdev)) {
-		pr_err("%s: device build err: %ld\n", __func__, PTR_ERR(pdev));
-		return PTR_ERR(pdev);
-	}
-
-	i++;
-
-	return 0;
-}
-
-static int __init omap_iommu_init(void)
-{
-	/* If dtb is there, the devices will be created dynamically */
-	if (of_have_populated_dt())
-		return -ENODEV;
-
-	return omap_hwmod_for_each_by_class("mmu", omap_iommu_dev_init, NULL);
-}
-/* must be ready before omap3isp is probed */
-omap_subsys_initcall(omap_iommu_init);
-
-static void __exit omap_iommu_exit(void)
-{
-	/* Do nothing */
-}
-module_exit(omap_iommu_exit);
-
-MODULE_AUTHOR("Hiroshi DOYU");
-MODULE_DESCRIPTION("omap iommu: omap device registration");
-MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

