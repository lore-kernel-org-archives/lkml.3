Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3LSP4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:56:20 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3345 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3LSP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:56:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Dec 2013 07:57:30 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Joseph Lo <josephl@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH 5/6] ARM: Tegra: remove speedo files
Date: Thu, 19 Dec 2013 17:54:33 +0200
Message-ID: <1387468474-26521-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speedo data is now handled by the fuse driver. Hence these files can be
removed.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile          |    3 -
 arch/arm/mach-tegra/tegra114_speedo.c |  104 ------------
 arch/arm/mach-tegra/tegra20_speedo.c  |  109 ------------
 arch/arm/mach-tegra/tegra30_speedo.c  |  292 ---------------------------------
 4 files changed, 0 insertions(+), 508 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 019bb17..40cf28b 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -13,14 +13,12 @@ obj-y					+= reset-handler.o
 obj-y					+= sleep.o
 obj-y					+= tegra.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= sleep-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= pm-tegra20.o
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= cpuidle-tegra20.o
 endif
-obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= tegra30_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
@@ -29,7 +27,6 @@ endif
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 
-obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= tegra114_speedo.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= sleep-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= pm-tegra30.o
 ifeq ($(CONFIG_CPU_IDLE),y)
diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
deleted file mode 100644
index 5218d48..0000000
--- a/arch/arm/mach-tegra/tegra114_speedo.c
+++ /dev/null
@@ -1,104 +0,0 @@
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
index fa6eb57..0000000
--- a/arch/arm/mach-tegra/tegra20_speedo.c
+++ /dev/null
@@ -1,109 +0,0 @@
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
index 125cb16..0000000
--- a/arch/arm/mach-tegra/tegra30_speedo.c
+++ /dev/null
@@ -1,292 +0,0 @@
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
-- 
1.7.7.rc0.72.g4b5ea.dirty

