Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaA1Xhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:37:42 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15467 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaA1Xhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:37:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Jan 2014 15:36:19 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Joseph Lo <josephl@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Danny Huang <dahuang@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Will Deacon <will.deacon@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Dave Martin <dave.martin@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH v3 2/6] ARM: tegra: Add chipid, revision and fuse init
Date: Wed, 29 Jan 2014 01:36:12 +0200
Message-ID: <1390952176-30402-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All fuse related functionality will move to a driver in the following patches.
To prepare for this, export all the required functionality in a global header
file and move all users of fuse.h to tegra-soc.h

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/cpuidle.c         |    2 +-
 arch/arm/mach-tegra/flowctrl.c        |    2 +-
 arch/arm/mach-tegra/fuse.h            |   18 ------------------
 arch/arm/mach-tegra/hotplug.c         |    2 +-
 arch/arm/mach-tegra/platsmp.c         |    2 +-
 arch/arm/mach-tegra/pm.c              |    2 +-
 arch/arm/mach-tegra/pmc.c             |    2 +-
 arch/arm/mach-tegra/powergate.c       |    2 +-
 arch/arm/mach-tegra/reset-handler.S   |    2 +-
 arch/arm/mach-tegra/reset.c           |    2 +-
 arch/arm/mach-tegra/sleep-tegra30.S   |    2 +-
 arch/arm/mach-tegra/tegra.c           |    2 +-
 arch/arm/mach-tegra/tegra114_speedo.c |    1 +
 arch/arm/mach-tegra/tegra20_speedo.c  |    1 +
 arch/arm/mach-tegra/tegra2_emc.c      |    2 +-
 arch/arm/mach-tegra/tegra30_speedo.c  |    1 +
 include/linux/tegra-soc.h             |   25 +++++++++++++++++++++++++
 17 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-tegra/cpuidle.c b/arch/arm/mach-tegra/cpuidle.c
index 7bc5d8d..ff0a10b 100644
--- a/arch/arm/mach-tegra/cpuidle.c
+++ b/arch/arm/mach-tegra/cpuidle.c
@@ -23,8 +23,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/tegra-soc.h>
 
-#include "fuse.h"
 #include "cpuidle.h"
 
 void __init tegra_cpuidle_init(void)
diff --git a/arch/arm/mach-tegra/flowctrl.c b/arch/arm/mach-tegra/flowctrl.c
index 43ae750..d2e0197 100644
--- a/arch/arm/mach-tegra/flowctrl.c
+++ b/arch/arm/mach-tegra/flowctrl.c
@@ -21,10 +21,10 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/cpumask.h>
+#include <linux/tegra-soc.h>
 
 #include "flowctrl.h"
 #include "iomap.h"
-#include "fuse.h"
 
 static u8 flowctrl_offset_halt_cpu[] = {
 	FLOW_CTRL_HALT_CPU0_EVENTS,
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index c01d047..b17c4ba 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -26,21 +26,7 @@
 #define SKU_ID_AP25E	27
 #define SKU_ID_T25E	28
 
-#define TEGRA20		0x20
-#define TEGRA30		0x30
-#define TEGRA114	0x35
-#define TEGRA124	0x40
-
 #ifndef __ASSEMBLY__
-enum tegra_revision {
-	TEGRA_REVISION_UNKNOWN = 0,
-	TEGRA_REVISION_A01,
-	TEGRA_REVISION_A02,
-	TEGRA_REVISION_A03,
-	TEGRA_REVISION_A03p,
-	TEGRA_REVISION_A04,
-	TEGRA_REVISION_MAX,
-};
 
 extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
@@ -48,12 +34,8 @@ extern int tegra_core_process_id;
 extern int tegra_chip_id;
 extern int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
 extern int tegra_soc_speedo_id;
-extern enum tegra_revision tegra_revision;
-
-extern int tegra_bct_strapping;
 
 unsigned long long tegra_chip_uid(void);
-void tegra_init_fuse(void);
 bool tegra_spare_fuse(int bit);
 u32 tegra_fuse_readl(unsigned long offset);
 
diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
index ff26af2..38c5170 100644
--- a/arch/arm/mach-tegra/hotplug.c
+++ b/arch/arm/mach-tegra/hotplug.c
@@ -10,10 +10,10 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/clk/tegra.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/smp_plat.h>
 
-#include "fuse.h"
 #include "sleep.h"
 
 static void (*tegra_hotplug_shutdown)(void);
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index eb72ae7..44409fd 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -19,13 +19,13 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/clk/tegra.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/mach-types.h>
 #include <asm/smp_scu.h>
 #include <asm/smp_plat.h>
 
-#include "fuse.h"
 #include "flowctrl.h"
 #include "reset.h"
 #include "pmc.h"
diff --git a/arch/arm/mach-tegra/pm.c b/arch/arm/mach-tegra/pm.c
index 4ae0286..b444ce7 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -25,6 +25,7 @@
 #include <linux/suspend.h>
 #include <linux/err.h>
 #include <linux/clk/tegra.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/smp_plat.h>
 #include <asm/cacheflush.h>
@@ -36,7 +37,6 @@
 #include "iomap.h"
 #include "reset.h"
 #include "flowctrl.h"
-#include "fuse.h"
 #include "pm.h"
 #include "pmc.h"
 #include "sleep.h"
diff --git a/arch/arm/mach-tegra/pmc.c b/arch/arm/mach-tegra/pmc.c
index fb79202..d8fe587 100644
--- a/arch/arm/mach-tegra/pmc.c
+++ b/arch/arm/mach-tegra/pmc.c
@@ -21,9 +21,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/tegra-powergate.h>
+#include <linux/tegra-soc.h>
 
 #include "flowctrl.h"
-#include "fuse.h"
 #include "pm.h"
 #include "pmc.h"
 #include "sleep.h"
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 3d0c537..e5c6d0f 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -30,8 +30,8 @@
 #include <linux/spinlock.h>
 #include <linux/clk/tegra.h>
 #include <linux/tegra-powergate.h>
+#include <linux/tegra-soc.h>
 
-#include "fuse.h"
 #include "iomap.h"
 
 #define DPD_SAMPLE		0x020
diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/reset-handler.S
index 9aa6cd3..f427466 100644
--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -19,9 +19,9 @@
 #include <asm/cache.h>
 #include <asm/asm-offsets.h>
 #include <asm/hardware/cache-l2x0.h>
+#include <linux/tegra-soc.h>
 
 #include "flowctrl.h"
-#include "fuse.h"
 #include "iomap.h"
 #include "reset.h"
 #include "sleep.h"
diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index 146fe8e..203bac5 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -22,12 +22,12 @@
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/firmware.h>
+#include <linux/tegra-soc.h>
 
 #include "iomap.h"
 #include "irammap.h"
 #include "reset.h"
 #include "sleep.h"
-#include "fuse.h"
 
 #define TEGRA_IRAM_RESET_BASE (TEGRA_IRAM_BASE + \
 				TEGRA_IRAM_RESET_HANDLER_OFFSET)
diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
index b16d4a57..f808c2c 100644
--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -15,13 +15,13 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
 
 #include "irammap.h"
-#include "fuse.h"
 #include "sleep.h"
 #include "flowctrl.h"
 
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 303a285..3cfca20 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -34,6 +34,7 @@
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/clk/tegra.h>
 #include <linux/irqchip.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach-types.h>
@@ -46,7 +47,6 @@
 #include "board.h"
 #include "common.h"
 #include "cpuidle.h"
-#include "fuse.h"
 #include "iomap.h"
 #include "irq.h"
 #include "pmc.h"
diff --git a/arch/arm/mach-tegra/tegra114_speedo.c b/arch/arm/mach-tegra/tegra114_speedo.c
index 5218d48..7c73716 100644
--- a/arch/arm/mach-tegra/tegra114_speedo.c
+++ b/arch/arm/mach-tegra/tegra114_speedo.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bug.h>
+#include <linux/tegra-soc.h>
 
 #include "fuse.h"
 
diff --git a/arch/arm/mach-tegra/tegra20_speedo.c b/arch/arm/mach-tegra/tegra20_speedo.c
index fa6eb57..3b1bb53 100644
--- a/arch/arm/mach-tegra/tegra20_speedo.c
+++ b/arch/arm/mach-tegra/tegra20_speedo.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bug.h>
+#include <linux/tegra-soc.h>
 
 #include "fuse.h"
 
diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
index 3ae4a7f..26e4edb 100644
--- a/arch/arm/mach-tegra/tegra2_emc.c
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -24,9 +24,9 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/tegra_emc.h>
+#include <linux/tegra-soc.h>
 
 #include "tegra2_emc.h"
-#include "fuse.h"
 
 #ifdef CONFIG_TEGRA_EMC_SCALING_ENABLE
 static bool emc_enable = true;
diff --git a/arch/arm/mach-tegra/tegra30_speedo.c b/arch/arm/mach-tegra/tegra30_speedo.c
index 125cb16..81a958d 100644
--- a/arch/arm/mach-tegra/tegra30_speedo.c
+++ b/arch/arm/mach-tegra/tegra30_speedo.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bug.h>
+#include <linux/tegra-soc.h>
 
 #include "fuse.h"
 
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index b02d73b..ccf42ee 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -17,8 +17,30 @@
 #ifndef __LINUX_TEGRA_SOC_H_
 #define __LINUX_TEGRA_SOC_H_
 
+#define TEGRA20         0x20
+#define TEGRA30         0x30
+#define TEGRA114        0x35
+#define TEGRA124        0x40
+
+#ifndef __ASSEMBLY__
+
+enum tegra_revision {
+	TEGRA_REVISION_UNKNOWN = 0,
+	TEGRA_REVISION_A01,
+	TEGRA_REVISION_A02,
+	TEGRA_REVISION_A03,
+	TEGRA_REVISION_A03p,
+	TEGRA_REVISION_A04,
+	TEGRA_REVISION_MAX,
+};
+
+u32 tegra_read_straps(void);
 u32 tegra_read_chipid(void);
+void tegra_init_fuse(void);
 
+extern int tegra_chip_id;
+extern enum tegra_revision tegra_revision;
+extern int tegra_bct_strapping;
 
 #if defined(CONFIG_TEGRA20_APB_DMA)
 int tegra_apb_readl_using_dma(unsigned long offset, u32 *value);
@@ -33,4 +55,7 @@ static inline int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 	return -EINVAL;
 }
 #endif
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.7.rc0.72.g4b5ea.dirty

