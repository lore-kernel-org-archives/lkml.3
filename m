Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaFLPll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:41:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19308 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbaFLPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:41:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jun 2014 08:36:18 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Lo <josephl@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 5/6] ARM: tegra: build new fuse driver in drivers/misc
Date: Thu, 12 Jun 2014 18:36:39 +0300
Message-ID: <1402587400-1544-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1402587400-1544-1-git-send-email-pdeschrijver@nvidia.com>
References: <1402587400-1544-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra fuse code has moved to drivers/misc/fuse/tegra. Enable the
building of that code, and disable the building of the old fuse code in
arch/arm/mach-tegra/. Also move the only user of tegra_revision over to
tegra_sku_info.revision and export tegra_fuse_readl to allow drivers to read
calibration fuses.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile          |    4 -
 arch/arm/mach-tegra/fuse.c            |  252 ----------------------------
 arch/arm/mach-tegra/fuse.h            |   61 -------
 arch/arm/mach-tegra/tegra.c           |    3 +-
 arch/arm/mach-tegra/tegra114_speedo.c |  105 ------------
 arch/arm/mach-tegra/tegra20_speedo.c  |  110 ------------
 arch/arm/mach-tegra/tegra30_speedo.c  |  293 ---------------------------------
 drivers/misc/Makefile                 |    1 +
 drivers/misc/fuse/tegra/fuse-tegra.c  |   10 +
 include/linux/tegra-soc.h             |    2 +-
 10 files changed, 14 insertions(+), 827 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/fuse.c
 delete mode 100644 arch/arm/mach-tegra/fuse.h
 delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 6fbfbb7..e8601bb 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -2,7 +2,6 @@ asflags-y				+= -march=armv7-a
 
 obj-y                                   += io.o
 obj-y                                   += irq.o
-obj-y					+= fuse.o
 obj-y					+= pmc.o
 obj-y					+= flowctrl.o
 obj-y					+= powergate.o
@@ -13,13 +12,11 @@ obj-y					+= reset-handler.o
 obj-y					+= sleep.o
 obj-y					+= tegra.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pm-tegra20.o
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= cpuidle-tegra20.o
 endif
-obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
@@ -28,7 +25,6 @@ endif
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 
-obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= tegra114_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
deleted file mode 100644
index c9ac23b..0000000
--- a/arch/arm/mach-tegra/fuse.c
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- * arch/arm/mach-tegra/fuse.c
- *
- * Copyright (C) 2010 Google, Inc.
- * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
- *
- * Author:
- *	Colin Cross <ccross@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/export.h>
-#include <linux/random.h>
-#include <linux/clk.h>
-#include <linux/tegra-soc.h>
-
-#include "fuse.h"
-#include "iomap.h"
-#include "apbio.h"
-
-/* Tegra20 only */
-#define FUSE_UID_LOW		0x108
-#define FUSE_UID_HIGH		0x10c
-
-/* Tegra30 and later */
-#define FUSE_VENDOR_CODE	0x200
-#define FUSE_FAB_CODE		0x204
-#define FUSE_LOT_CODE_0		0x208
-#define FUSE_LOT_CODE_1		0x20c
-#define FUSE_WAFER_ID		0x210
-#define FUSE_X_COORDINATE	0x214
-#define FUSE_Y_COORDINATE	0x218
-
-#define FUSE_SKU_INFO		0x110
-
-#define TEGRA20_FUSE_SPARE_BIT		0x200
-#define TEGRA30_FUSE_SPARE_BIT		0x244
-
-int tegra_sku_id;
-int tegra_cpu_process_id;
-int tegra_core_process_id;
-int tegra_chip_id;
-int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
-int tegra_soc_speedo_id;
-enum tegra_revision tegra_revision;
-
-static struct clk *fuse_clk;
-static int tegra_fuse_spare_bit;
-static void (*tegra_init_speedo_data)(void);
-
-/* The BCT to use at boot is specified by board straps that can be read
- * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
- */
-int tegra_bct_strapping;
-
-#define STRAP_OPT 0x008
-#define GMI_AD0 (1 << 4)
-#define GMI_AD1 (1 << 5)
-#define RAM_ID_MASK (GMI_AD0 | GMI_AD1)
-#define RAM_CODE_SHIFT 4
-
-static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
-	[TEGRA_REVISION_UNKNOWN] = "unknown",
-	[TEGRA_REVISION_A01]     = "A01",
-	[TEGRA_REVISION_A02]     = "A02",
-	[TEGRA_REVISION_A03]     = "A03",
-	[TEGRA_REVISION_A03p]    = "A03 prime",
-	[TEGRA_REVISION_A04]     = "A04",
-};
-
-static void tegra_fuse_enable_clk(void)
-{
-	if (IS_ERR(fuse_clk))
-		fuse_clk = clk_get_sys(NULL, "fuse");
-	if (IS_ERR(fuse_clk))
-		return;
-	clk_prepare_enable(fuse_clk);
-}
-
-static void tegra_fuse_disable_clk(void)
-{
-	if (IS_ERR(fuse_clk))
-		return;
-	clk_disable_unprepare(fuse_clk);
-}
-
-u32 tegra_fuse_readl(unsigned long offset)
-{
-	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
-}
-
-bool tegra_spare_fuse(int bit)
-{
-	bool ret;
-
-	tegra_fuse_enable_clk();
-
-	ret = tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
-
-	tegra_fuse_disable_clk();
-
-	return ret;
-}
-
-static enum tegra_revision tegra_get_revision(u32 id)
-{
-	u32 minor_rev = (id >> 16) & 0xf;
-
-	switch (minor_rev) {
-	case 1:
-		return TEGRA_REVISION_A01;
-	case 2:
-		return TEGRA_REVISION_A02;
-	case 3:
-		if (tegra_chip_id == TEGRA20 &&
-			(tegra_spare_fuse(18) || tegra_spare_fuse(19)))
-			return TEGRA_REVISION_A03p;
-		else
-			return TEGRA_REVISION_A03;
-	case 4:
-		return TEGRA_REVISION_A04;
-	default:
-		return TEGRA_REVISION_UNKNOWN;
-	}
-}
-
-static void tegra_get_process_id(void)
-{
-	u32 reg;
-
-	tegra_fuse_enable_clk();
-
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_cpu_process_id = (reg >> 6) & 3;
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_core_process_id = (reg >> 12) & 3;
-
-	tegra_fuse_disable_clk();
-}
-
-u32 tegra_read_chipid(void)
-{
-	return readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
-}
-
-static void __init tegra20_fuse_init_randomness(void)
-{
-	u32 randomness[2];
-
-	randomness[0] = tegra_fuse_readl(FUSE_UID_LOW);
-	randomness[1] = tegra_fuse_readl(FUSE_UID_HIGH);
-
-	add_device_randomness(randomness, sizeof(randomness));
-}
-
-/* Applies to Tegra30 or later */
-static void __init tegra30_fuse_init_randomness(void)
-{
-	u32 randomness[7];
-
-	randomness[0] = tegra_fuse_readl(FUSE_VENDOR_CODE);
-	randomness[1] = tegra_fuse_readl(FUSE_FAB_CODE);
-	randomness[2] = tegra_fuse_readl(FUSE_LOT_CODE_0);
-	randomness[3] = tegra_fuse_readl(FUSE_LOT_CODE_1);
-	randomness[4] = tegra_fuse_readl(FUSE_WAFER_ID);
-	randomness[5] = tegra_fuse_readl(FUSE_X_COORDINATE);
-	randomness[6] = tegra_fuse_readl(FUSE_Y_COORDINATE);
-
-	add_device_randomness(randomness, sizeof(randomness));
-}
-
-void __init tegra_init_fuse(void)
-{
-	u32 id;
-	u32 randomness[5];
-
-	u32 reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
-	reg |= 1 << 28;
-	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
-
-	/*
-	 * Enable FUSE clock. This needs to be hardcoded because the clock
-	 * subsystem is not active during early boot.
-	 */
-	reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
-	reg |= 1 << 7;
-	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
-	fuse_clk = ERR_PTR(-EINVAL);
-
-	reg = tegra_fuse_readl(FUSE_SKU_INFO);
-	randomness[0] = reg;
-	tegra_sku_id = reg & 0xFF;
-
-	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
-	randomness[1] = reg;
-	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
-
-	id = tegra_read_chipid();
-	randomness[2] = id;
-	tegra_chip_id = (id >> 8) & 0xff;
-
-	switch (tegra_chip_id) {
-	case TEGRA20:
-		tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
-		tegra_init_speedo_data = &tegra20_init_speedo_data;
-		break;
-	case TEGRA30:
-		tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
-		tegra_init_speedo_data = &tegra30_init_speedo_data;
-		break;
-	case TEGRA114:
-		tegra_init_speedo_data = &tegra114_init_speedo_data;
-		break;
-	default:
-		pr_warn("Tegra: unknown chip id %d\n", tegra_chip_id);
-		tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
-		tegra_init_speedo_data = &tegra_get_process_id;
-	}
-
-	tegra_revision = tegra_get_revision(id);
-	tegra_init_speedo_data();
-	randomness[3] = (tegra_cpu_process_id << 16) | tegra_core_process_id;
-	randomness[4] = (tegra_cpu_speedo_id << 16) | tegra_soc_speedo_id;
-
-	add_device_randomness(randomness, sizeof(randomness));
-	switch (tegra_chip_id) {
-	case TEGRA20:
-		tegra20_fuse_init_randomness();
-		break;
-	case TEGRA30:
-	case TEGRA114:
-	default:
-		tegra30_fuse_init_randomness();
-		break;
-	}
-
-	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
-		tegra_revision_name[tegra_revision],
-		tegra_sku_id, tegra_cpu_process_id,
-		tegra_core_process_id);
-}
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
deleted file mode 100644
index b17c4ba..0000000
--- a/arch/arm/mach-tegra/fuse.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Copyright (C) 2010 Google, Inc.
- * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
- *
- * Author:
- *	Colin Cross <ccross@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __MACH_TEGRA_FUSE_H
-#define __MACH_TEGRA_FUSE_H
-
-#define SKU_ID_T20	8
-#define SKU_ID_T25SE	20
-#define SKU_ID_AP25	23
-#define SKU_ID_T25	24
-#define SKU_ID_AP25E	27
-#define SKU_ID_T25E	28
-
-#ifndef __ASSEMBLY__
-
-extern int tegra_sku_id;
-extern int tegra_cpu_process_id;
-extern int tegra_core_process_id;
-extern int tegra_chip_id;
-extern int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
-extern int tegra_soc_speedo_id;
-
-unsigned long long tegra_chip_uid(void);
-bool tegra_spare_fuse(int bit);
-u32 tegra_fuse_readl(unsigned long offset);
-
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-void tegra20_init_speedo_data(void);
-#else
-static inline void tegra20_init_speedo_data(void) {}
-#endif
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-void tegra30_init_speedo_data(void);
-#else
-static inline void tegra30_init_speedo_data(void) {}
-#endif
-
-#ifdef CONFIG_ARCH_TEGRA_114_SOC
-void tegra114_init_speedo_data(void);
-#else
-static inline void tegra114_init_speedo_data(void) {}
-#endif
-#endif /* __ASSEMBLY__ */
-
-#endif
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index e48b271..093d5f4 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -131,7 +131,8 @@ static void __init tegra_dt_init(void)
 		goto out;
 
 	soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
-	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d",
+					tegra_sku_info.revision);
 	soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
 
 	soc_dev = soc_device_register(soc_dev_attr);
diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
deleted file mode 100644
index 7c73716..0000000
--- a/arch/arm/mach-tegra/tegra114_speedo.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/kernel.h>
-#include <linux/bug.h>
-#include <linux/tegra-soc.h>
-
-#include "fuse.h"
-
-#define CORE_PROCESS_CORNERS_NUM	2
-#define CPU_PROCESS_CORNERS_NUM		2
-
-enum {
-	THRESHOLD_INDEX_0,
-	THRESHOLD_INDEX_1,
-	THRESHOLD_INDEX_COUNT,
-};
-
-static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
-	{1123,     UINT_MAX},
-	{0,        UINT_MAX},
-};
-
-static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
-	{1695,     UINT_MAX},
-	{0,        UINT_MAX},
-};
-
-static void rev_sku_to_speedo_ids(int rev, int sku, int *threshold)
-{
-	u32 tmp;
-
-	switch (sku) {
-	case 0x00:
-	case 0x10:
-	case 0x05:
-	case 0x06:
-		tegra_cpu_speedo_id = 1;
-		tegra_soc_speedo_id = 0;
-		*threshold = THRESHOLD_INDEX_0;
-		break;
-
-	case 0x03:
-	case 0x04:
-		tegra_cpu_speedo_id = 2;
-		tegra_soc_speedo_id = 1;
-		*threshold = THRESHOLD_INDEX_1;
-		break;
-
-	default:
-		pr_err("Tegra114 Unknown SKU %d\n", sku);
-		tegra_cpu_speedo_id = 0;
-		tegra_soc_speedo_id = 0;
-		*threshold = THRESHOLD_INDEX_0;
-		break;
-	}
-
-	if (rev == TEGRA_REVISION_A01) {
-		tmp = tegra_fuse_readl(0x270) << 1;
-		tmp |= tegra_fuse_readl(0x26c);
-		if (!tmp)
-			tegra_cpu_speedo_id = 0;
-	}
-}
-
-void tegra114_init_speedo_data(void)
-{
-	u32 cpu_speedo_val;
-	u32 core_speedo_val;
-	int threshold;
-	int i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
-			THRESHOLD_INDEX_COUNT);
-	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
-			THRESHOLD_INDEX_COUNT);
-
-	rev_sku_to_speedo_ids(tegra_revision, tegra_sku_id, &threshold);
-
-	cpu_speedo_val = tegra_fuse_readl(0x12c) + 1024;
-	core_speedo_val = tegra_fuse_readl(0x134);
-
-	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++)
-		if (cpu_speedo_val < cpu_process_speedos[threshold][i])
-			break;
-	tegra_cpu_process_id = i;
-
-	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++)
-		if (core_speedo_val < core_process_speedos[threshold][i])
-			break;
-	tegra_core_process_id = i;
-}
diff --git a/arch/arm/mach-tegra/tegra20_speedo.c b/arch/arm/mach-tegra/tegra20_speedo.c
deleted file mode 100644
index 3b1bb53..0000000
--- a/arch/arm/mach-tegra/tegra20_speedo.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/kernel.h>
-#include <linux/bug.h>
-#include <linux/tegra-soc.h>
-
-#include "fuse.h"
-
-#define CPU_SPEEDO_LSBIT		20
-#define CPU_SPEEDO_MSBIT		29
-#define CPU_SPEEDO_REDUND_LSBIT		30
-#define CPU_SPEEDO_REDUND_MSBIT		39
-#define CPU_SPEEDO_REDUND_OFFS	(CPU_SPEEDO_REDUND_MSBIT - CPU_SPEEDO_MSBIT)
-
-#define CORE_SPEEDO_LSBIT		40
-#define CORE_SPEEDO_MSBIT		47
-#define CORE_SPEEDO_REDUND_LSBIT	48
-#define CORE_SPEEDO_REDUND_MSBIT	55
-#define CORE_SPEEDO_REDUND_OFFS	(CORE_SPEEDO_REDUND_MSBIT - CORE_SPEEDO_MSBIT)
-
-#define SPEEDO_MULT			4
-
-#define PROCESS_CORNERS_NUM		4
-
-#define SPEEDO_ID_SELECT_0(rev)		((rev) <= 2)
-#define SPEEDO_ID_SELECT_1(sku)		\
-	(((sku) != 20) && ((sku) != 23) && ((sku) != 24) && \
-	 ((sku) != 27) && ((sku) != 28))
-
-enum {
-	SPEEDO_ID_0,
-	SPEEDO_ID_1,
-	SPEEDO_ID_2,
-	SPEEDO_ID_COUNT,
-};
-
-static const u32 cpu_process_speedos[][PROCESS_CORNERS_NUM] = {
-	{315, 366, 420, UINT_MAX},
-	{303, 368, 419, UINT_MAX},
-	{316, 331, 383, UINT_MAX},
-};
-
-static const u32 core_process_speedos[][PROCESS_CORNERS_NUM] = {
-	{165, 195, 224, UINT_MAX},
-	{165, 195, 224, UINT_MAX},
-	{165, 195, 224, UINT_MAX},
-};
-
-void tegra20_init_speedo_data(void)
-{
-	u32 reg;
-	u32 val;
-	int i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) != SPEEDO_ID_COUNT);
-	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) != SPEEDO_ID_COUNT);
-
-	if (SPEEDO_ID_SELECT_0(tegra_revision))
-		tegra_soc_speedo_id = SPEEDO_ID_0;
-	else if (SPEEDO_ID_SELECT_1(tegra_sku_id))
-		tegra_soc_speedo_id = SPEEDO_ID_1;
-	else
-		tegra_soc_speedo_id = SPEEDO_ID_2;
-
-	val = 0;
-	for (i = CPU_SPEEDO_MSBIT; i >= CPU_SPEEDO_LSBIT; i--) {
-		reg = tegra_spare_fuse(i) |
-			tegra_spare_fuse(i + CPU_SPEEDO_REDUND_OFFS);
-		val = (val << 1) | (reg & 0x1);
-	}
-	val = val * SPEEDO_MULT;
-	pr_debug("%s CPU speedo value %u\n", __func__, val);
-
-	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
-		if (val <= cpu_process_speedos[tegra_soc_speedo_id][i])
-			break;
-	}
-	tegra_cpu_process_id = i;
-
-	val = 0;
-	for (i = CORE_SPEEDO_MSBIT; i >= CORE_SPEEDO_LSBIT; i--) {
-		reg = tegra_spare_fuse(i) |
-			tegra_spare_fuse(i + CORE_SPEEDO_REDUND_OFFS);
-		val = (val << 1) | (reg & 0x1);
-	}
-	val = val * SPEEDO_MULT;
-	pr_debug("%s Core speedo value %u\n", __func__, val);
-
-	for (i = 0; i < (PROCESS_CORNERS_NUM - 1); i++) {
-		if (val <= core_process_speedos[tegra_soc_speedo_id][i])
-			break;
-	}
-	tegra_core_process_id = i;
-
-	pr_info("Tegra20 Soc Speedo ID %d", tegra_soc_speedo_id);
-}
diff --git a/arch/arm/mach-tegra/tegra30_speedo.c b/arch/arm/mach-tegra/tegra30_speedo.c
deleted file mode 100644
index 81a958d..0000000
--- a/arch/arm/mach-tegra/tegra30_speedo.c
+++ /dev/null
@@ -1,293 +0,0 @@
-/*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/kernel.h>
-#include <linux/bug.h>
-#include <linux/tegra-soc.h>
-
-#include "fuse.h"
-
-#define CORE_PROCESS_CORNERS_NUM	1
-#define CPU_PROCESS_CORNERS_NUM		6
-
-#define FUSE_SPEEDO_CALIB_0	0x114
-#define FUSE_PACKAGE_INFO	0X1FC
-#define FUSE_TEST_PROG_VER	0X128
-
-#define G_SPEEDO_BIT_MINUS1	58
-#define G_SPEEDO_BIT_MINUS1_R	59
-#define G_SPEEDO_BIT_MINUS2	60
-#define G_SPEEDO_BIT_MINUS2_R	61
-#define LP_SPEEDO_BIT_MINUS1	62
-#define LP_SPEEDO_BIT_MINUS1_R	63
-#define LP_SPEEDO_BIT_MINUS2	64
-#define LP_SPEEDO_BIT_MINUS2_R	65
-
-enum {
-	THRESHOLD_INDEX_0,
-	THRESHOLD_INDEX_1,
-	THRESHOLD_INDEX_2,
-	THRESHOLD_INDEX_3,
-	THRESHOLD_INDEX_4,
-	THRESHOLD_INDEX_5,
-	THRESHOLD_INDEX_6,
-	THRESHOLD_INDEX_7,
-	THRESHOLD_INDEX_8,
-	THRESHOLD_INDEX_9,
-	THRESHOLD_INDEX_10,
-	THRESHOLD_INDEX_11,
-	THRESHOLD_INDEX_COUNT,
-};
-
-static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
-	{180},
-	{170},
-	{195},
-	{180},
-	{168},
-	{192},
-	{180},
-	{170},
-	{195},
-	{180},
-	{180},
-	{180},
-};
-
-static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
-	{306, 338, 360, 376, UINT_MAX},
-	{295, 336, 358, 375, UINT_MAX},
-	{325, 325, 358, 375, UINT_MAX},
-	{325, 325, 358, 375, UINT_MAX},
-	{292, 324, 348, 364, UINT_MAX},
-	{324, 324, 348, 364, UINT_MAX},
-	{324, 324, 348, 364, UINT_MAX},
-	{295, 336, 358, 375, UINT_MAX},
-	{358, 358, 358, 358, 397, UINT_MAX},
-	{364, 364, 364, 364, 397, UINT_MAX},
-	{295, 336, 358, 375, 391, UINT_MAX},
-	{295, 336, 358, 375, 391, UINT_MAX},
-};
-
-static int threshold_index;
-static int package_id;
-
-static void fuse_speedo_calib(u32 *speedo_g, u32 *speedo_lp)
-{
-	u32 reg;
-	int ate_ver;
-	int bit_minus1;
-	int bit_minus2;
-
-	reg = tegra_fuse_readl(FUSE_SPEEDO_CALIB_0);
-
-	*speedo_lp = (reg & 0xFFFF) * 4;
-	*speedo_g = ((reg >> 16) & 0xFFFF) * 4;
-
-	ate_ver = tegra_fuse_readl(FUSE_TEST_PROG_VER);
-	pr_info("%s: ATE prog ver %d.%d\n", __func__, ate_ver/10, ate_ver%10);
-
-	if (ate_ver >= 26) {
-		bit_minus1 = tegra_spare_fuse(LP_SPEEDO_BIT_MINUS1);
-		bit_minus1 |= tegra_spare_fuse(LP_SPEEDO_BIT_MINUS1_R);
-		bit_minus2 = tegra_spare_fuse(LP_SPEEDO_BIT_MINUS2);
-		bit_minus2 |= tegra_spare_fuse(LP_SPEEDO_BIT_MINUS2_R);
-		*speedo_lp |= (bit_minus1 << 1) | bit_minus2;
-
-		bit_minus1 = tegra_spare_fuse(G_SPEEDO_BIT_MINUS1);
-		bit_minus1 |= tegra_spare_fuse(G_SPEEDO_BIT_MINUS1_R);
-		bit_minus2 = tegra_spare_fuse(G_SPEEDO_BIT_MINUS2);
-		bit_minus2 |= tegra_spare_fuse(G_SPEEDO_BIT_MINUS2_R);
-		*speedo_g |= (bit_minus1 << 1) | bit_minus2;
-	} else {
-		*speedo_lp |= 0x3;
-		*speedo_g |= 0x3;
-	}
-}
-
-static void rev_sku_to_speedo_ids(int rev, int sku)
-{
-	switch (rev) {
-	case TEGRA_REVISION_A01:
-		tegra_cpu_speedo_id = 0;
-		tegra_soc_speedo_id = 0;
-		threshold_index = THRESHOLD_INDEX_0;
-		break;
-	case TEGRA_REVISION_A02:
-	case TEGRA_REVISION_A03:
-		switch (sku) {
-		case 0x87:
-		case 0x82:
-			tegra_cpu_speedo_id = 1;
-			tegra_soc_speedo_id = 1;
-			threshold_index = THRESHOLD_INDEX_1;
-			break;
-		case 0x81:
-			switch (package_id) {
-			case 1:
-				tegra_cpu_speedo_id = 2;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_2;
-				break;
-			case 2:
-				tegra_cpu_speedo_id = 4;
-				tegra_soc_speedo_id = 1;
-				threshold_index = THRESHOLD_INDEX_7;
-				break;
-			default:
-				pr_err("Tegra30: Unknown pkg %d\n", package_id);
-				BUG();
-				break;
-			}
-			break;
-		case 0x80:
-			switch (package_id) {
-			case 1:
-				tegra_cpu_speedo_id = 5;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_8;
-				break;
-			case 2:
-				tegra_cpu_speedo_id = 6;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_9;
-				break;
-			default:
-				pr_err("Tegra30: Unknown pkg %d\n", package_id);
-				BUG();
-				break;
-			}
-			break;
-		case 0x83:
-			switch (package_id) {
-			case 1:
-				tegra_cpu_speedo_id = 7;
-				tegra_soc_speedo_id = 1;
-				threshold_index = THRESHOLD_INDEX_10;
-				break;
-			case 2:
-				tegra_cpu_speedo_id = 3;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_3;
-				break;
-			default:
-				pr_err("Tegra30: Unknown pkg %d\n", package_id);
-				BUG();
-				break;
-			}
-			break;
-		case 0x8F:
-			tegra_cpu_speedo_id = 8;
-			tegra_soc_speedo_id = 1;
-			threshold_index = THRESHOLD_INDEX_11;
-			break;
-		case 0x08:
-			tegra_cpu_speedo_id = 1;
-			tegra_soc_speedo_id = 1;
-			threshold_index = THRESHOLD_INDEX_4;
-			break;
-		case 0x02:
-			tegra_cpu_speedo_id = 2;
-			tegra_soc_speedo_id = 2;
-			threshold_index = THRESHOLD_INDEX_5;
-			break;
-		case 0x04:
-			tegra_cpu_speedo_id = 3;
-			tegra_soc_speedo_id = 2;
-			threshold_index = THRESHOLD_INDEX_6;
-			break;
-		case 0:
-			switch (package_id) {
-			case 1:
-				tegra_cpu_speedo_id = 2;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_2;
-				break;
-			case 2:
-				tegra_cpu_speedo_id = 3;
-				tegra_soc_speedo_id = 2;
-				threshold_index = THRESHOLD_INDEX_3;
-				break;
-			default:
-				pr_err("Tegra30: Unknown pkg %d\n", package_id);
-				BUG();
-				break;
-			}
-			break;
-		default:
-			pr_warn("Tegra30: Unknown SKU %d\n", sku);
-			tegra_cpu_speedo_id = 0;
-			tegra_soc_speedo_id = 0;
-			threshold_index = THRESHOLD_INDEX_0;
-			break;
-		}
-		break;
-	default:
-		pr_warn("Tegra30: Unknown chip rev %d\n", rev);
-		tegra_cpu_speedo_id = 0;
-		tegra_soc_speedo_id = 0;
-		threshold_index = THRESHOLD_INDEX_0;
-		break;
-	}
-}
-
-void tegra30_init_speedo_data(void)
-{
-	u32 cpu_speedo_val;
-	u32 core_speedo_val;
-	int i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
-			THRESHOLD_INDEX_COUNT);
-	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
-			THRESHOLD_INDEX_COUNT);
-
-	package_id = tegra_fuse_readl(FUSE_PACKAGE_INFO) & 0x0F;
-
-	rev_sku_to_speedo_ids(tegra_revision, tegra_sku_id);
-	fuse_speedo_calib(&cpu_speedo_val, &core_speedo_val);
-	pr_debug("%s CPU speedo value %u\n", __func__, cpu_speedo_val);
-	pr_debug("%s Core speedo value %u\n", __func__, core_speedo_val);
-
-	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++) {
-		if (cpu_speedo_val < cpu_process_speedos[threshold_index][i])
-			break;
-	}
-	tegra_cpu_process_id = i - 1;
-
-	if (tegra_cpu_process_id == -1) {
-		pr_warn("Tegra30: CPU speedo value %3d out of range",
-		       cpu_speedo_val);
-		tegra_cpu_process_id = 0;
-		tegra_cpu_speedo_id = 1;
-	}
-
-	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++) {
-		if (core_speedo_val < core_process_speedos[threshold_index][i])
-			break;
-	}
-	tegra_core_process_id = i - 1;
-
-	if (tegra_core_process_id == -1) {
-		pr_warn("Tegra30: CORE speedo value %3d out of range",
-		       core_speedo_val);
-		tegra_core_process_id = 0;
-		tegra_soc_speedo_id = 1;
-	}
-
-	pr_info("Tegra30: CPU Speedo ID %d, Soc Speedo ID %d",
-		tegra_cpu_speedo_id, tegra_soc_speedo_id);
-}
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7eb4b69..ecb9349 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
+obj-y				+= fuse/
diff --git a/drivers/misc/fuse/tegra/fuse-tegra.c b/drivers/misc/fuse/tegra/fuse-tegra.c
index 3fa6f74..934073e 100644
--- a/drivers/misc/fuse/tegra/fuse-tegra.c
+++ b/drivers/misc/fuse/tegra/fuse-tegra.c
@@ -98,6 +98,16 @@ static void tegra_enable_fuse_clk(void __iomem *base)
 	writel(reg, base + 0x14);
 }
 
+int tegra_fuse_readl(u32 offset, u32 *val)
+{
+	if (!fuse_readl)
+		return -EPROBE_DEFER;
+
+	*val = fuse_readl(offset);
+
+	return 0;
+}
+
 int tegra_fuse_create_sysfs(struct device *dev, int size,
 		     u32 (*readl)(const unsigned int offset))
 {
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 5c33b16..1ca3756 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -54,9 +54,9 @@ struct tegra_sku_info {
 u32 tegra_read_straps(void);
 u32 tegra_read_chipid(void);
 void tegra_init_fuse(void);
+int tegra_fuse_readl(u32 offset, u32 *val);
 
 extern int tegra_chip_id;
-extern enum tegra_revision tegra_revision;
 extern struct tegra_sku_info tegra_sku_info;
 
 #if defined(CONFIG_TEGRA20_APB_DMA)
-- 
1.7.7.rc0.72.g4b5ea.dirty

