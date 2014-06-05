Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaFENKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:10:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10893 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaFENJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:09:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 06:01:26 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 2/5] ARM: tegra: move fuse exports to tegra-soc.h
Date: Thu, 5 Jun 2014 16:09:10 +0300
Message-ID: <1401973754-19701-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All fuse related functionality will move to a driver in the following patches.
To prepare for this, export all the required functionality in a global header
file and move all users of fuse.h to tegra-soc.h. While we're at it, remove
tegra_bct_strapping, as its only user was removed in Commit a7cbe92cef27
("ARM: tegra: remove tegra EMC scaling driver").

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
 arch/arm/mach-tegra/tegra30_speedo.c  |    1 +
 include/linux/tegra-soc.h             |   24 ++++++++++++++++++++++++
 16 files changed, 38 insertions(+), 29 deletions(-)

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
index ce8ab8a..4b31091 100644
--- a/arch/arm/mach-tegra/flowctrl.c
+++ b/arch/arm/mach-tegra/flowctrl.c
@@ -22,10 +22,10 @@
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
index 929d104..d9878ac 100644
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
index f55b05a..d7e6370 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/clk/tegra.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/smp_plat.h>
 #include <asm/cacheflush.h>
@@ -37,7 +38,6 @@
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
index 4cefc5c..50a9af4 100644
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
index 8c1ba4f..0c480d69 100644
--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -20,9 +20,9 @@
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
index 6191603..e48b271 100644
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
index b02d73b..db93b77 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -17,8 +17,29 @@
 #ifndef __LINUX_TEGRA_SOC_H_
 #define __LINUX_TEGRA_SOC_H_
 
+#define TEGRA20		0x20
+#define TEGRA30		0x30
+#define TEGRA114	0x35
+#define TEGRA124	0x40
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
 
 #if defined(CONFIG_TEGRA20_APB_DMA)
 int tegra_apb_readl_using_dma(unsigned long offset, u32 *value);
@@ -33,4 +54,7 @@ static inline int tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 	return -EINVAL;
 }
 #endif
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.7.rc0.72.g4b5ea.dirty

