Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3CRLRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:17:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1183 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3CRLRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:17:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Mar 2013 04:10:43 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>, <josephl@nvidia.com>,
        <pgaikwad@nvidia.com>, <ldewangan@nvidia.com>, <dahuang@nvidia.com>,
        <hdoyu@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ARM: tegra114: add speedo-based process identification
Date: Mon, 18 Mar 2013 19:17:34 +0800
Message-ID: <1363605454-24176-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add speedo-based process identifictaion for Tegra114.

Based on the work by:
Alex Frid <afrid@nvidia.com>

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/mach-tegra/Makefile          |   1 +
 arch/arm/mach-tegra/fuse.c            |   4 ++
 arch/arm/mach-tegra/fuse.h            |   7 +++
 arch/arm/mach-tegra/tegra114_speedo.c | 103 ++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)
 create mode 100644 arch/arm/mach-tegra/tegra114_speedo.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 92703f9..e40326d 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
+obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= tegra114_speedo.o
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= cpuidle-tegra114.o
 endif
diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index f7db078..e035cd2 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -2,6 +2,7 @@
  * arch/arm/mach-tegra/fuse.c
  *
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * Author:
  *	Colin Cross <ccross@android.com>
@@ -137,6 +138,9 @@ void tegra_init_fuse(void)
 		tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
 		tegra_init_speedo_data = &tegra30_init_speedo_data;
 		break;
+	case TEGRA114:
+		tegra_init_speedo_data = &tegra114_init_speedo_data;
+		break;
 	default:
 		pr_warn("Tegra: unknown chip id %d\n", tegra_chip_id);
 		tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index da78434..aacc00d 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * Author:
  *	Colin Cross <ccross@android.com>
@@ -66,4 +67,10 @@ void tegra30_init_speedo_data(void);
 static inline void tegra30_init_speedo_data(void) {}
 #endif
 
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+void tegra114_init_speedo_data(void);
+#else
+static inline void tegra114_init_speedo_data(void) {}
+#endif
+
 #endif
diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
new file mode 100644
index 0000000..a49de85
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra114_speedo.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+
+#include "fuse.h"
+
+#define CORE_PROCESS_CORNERS_NUM	2
+#define CPU_PROCESS_CORNERS_NUM		2
+
+enum {
+	THRESHOLD_INDEX_0,
+	THRESHOLD_INDEX_1,
+	THRESHOLD_INDEX_COUNT,
+};
+
+static const u32 core_process_speedos[][CORE_PROCESS_CORNERS_NUM] = {
+	{1123,     UINT_MAX},
+	{0,        UINT_MAX},
+};
+
+static const u32 cpu_process_speedos[][CPU_PROCESS_CORNERS_NUM] = {
+	{1695,     UINT_MAX},
+	{0,        UINT_MAX},
+};
+
+static void rev_sku_to_speedo_ids(int rev, int sku, int *threshold)
+{
+	u32 tmp;
+
+	switch (sku) {
+	case 0x00:
+	case 0x10:
+	case 0x05:
+	case 0x06:
+		tegra_cpu_speedo_id = 1;
+		tegra_soc_speedo_id = 0;
+		*threshold = THRESHOLD_INDEX_0;
+		break;
+
+	case 0x03:
+	case 0x04:
+		tegra_cpu_speedo_id = 2;
+		tegra_soc_speedo_id = 1;
+		*threshold = THRESHOLD_INDEX_1;
+		break;
+
+	default:
+		pr_err("Tegra114 Unknown SKU %d\n", sku);
+		tegra_cpu_speedo_id = 0;
+		tegra_soc_speedo_id = 0;
+		*threshold = THRESHOLD_INDEX_0;
+		break;
+	}
+
+	if (rev == TEGRA_REVISION_A01) {
+		tmp = tegra_fuse_readl(0x270) << 1;
+		tmp |= tegra_fuse_readl(0x26c);
+		if (!tmp)
+			tegra_cpu_speedo_id = 0;
+	}
+}
+
+void tegra114_init_speedo_data(void)
+{
+	u32 cpu_speedo_val;
+	u32 core_speedo_val;
+	int threshold;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) !=
+			THRESHOLD_INDEX_COUNT);
+
+	rev_sku_to_speedo_ids(tegra_revision, tegra_sku_id, &threshold);
+
+	cpu_speedo_val = tegra_fuse_readl(0x12c) + 1024;
+	core_speedo_val = tegra_fuse_readl(0x134);
+
+	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++)
+		if (cpu_speedo_val < cpu_process_speedos[threshold][i])
+			break;
+	tegra_cpu_process_id = i;
+
+	for (i = 0; i < CORE_PROCESS_CORNERS_NUM; i++)
+		if (core_speedo_val < core_process_speedos[threshold][i])
+			break;
+	tegra_core_process_id = i;
+}
-- 
1.8.2

