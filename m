Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3LSP4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:56:03 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2977 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3LSPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Dec 2013 07:57:13 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Danny Huang <dahuang@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 4/6] ARM: tegra: rework fuse.c
Date: Thu, 19 Dec 2013 17:54:32 +0200
Message-ID: <1387468474-26521-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
References: <1387468474-26521-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce fuse.c to the minimum functionality required for the early bootstages.
Also export tegra_read_straps() for use by the fuse driver.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c |  121 +++++---------------------------------------
 include/linux/tegra-soc.h  |    1 +
 2 files changed, 14 insertions(+), 108 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index d4639c5..2b42037 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -28,35 +28,14 @@
 #include "iomap.h"
 #include "apbio.h"
 
-/* Tegra20 only */
 #define FUSE_UID_LOW		0x108
 #define FUSE_UID_HIGH		0x10c
 
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
 #define TEGRA20_FUSE_SPARE_BIT		0x200
-#define TEGRA30_FUSE_SPARE_BIT		0x244
 
-int tegra_sku_id;
-int tegra_cpu_process_id;
-int tegra_core_process_id;
 int tegra_chip_id;
-int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
-int tegra_soc_speedo_id;
 enum tegra_revision tegra_revision;
 
-static int tegra_fuse_spare_bit;
-static void (*tegra_init_speedo_data)(void);
-
 /* The BCT to use at boot is specified by board straps that can be read
  * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
  */
@@ -68,15 +47,6 @@ int tegra_bct_strapping;
 #define RAM_ID_MASK (GMI_AD0 | GMI_AD1)
 #define RAM_CODE_SHIFT 4
 
-static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
-	[TEGRA_REVISION_UNKNOWN] = "unknown",
-	[TEGRA_REVISION_A01]     = "A01",
-	[TEGRA_REVISION_A02]     = "A02",
-	[TEGRA_REVISION_A03]     = "A03",
-	[TEGRA_REVISION_A03p]    = "A03 prime",
-	[TEGRA_REVISION_A04]     = "A04",
-};
-
 u32 tegra_fuse_readl(unsigned long offset)
 {
 	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
@@ -84,7 +54,7 @@ u32 tegra_fuse_readl(unsigned long offset)
 
 bool tegra_spare_fuse(int bit)
 {
-	return tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
+	return tegra_fuse_readl(TEGRA20_FUSE_SPARE_BIT + bit * 4);
 }
 
 static enum tegra_revision tegra_get_revision(u32 id)
@@ -109,14 +79,9 @@ static enum tegra_revision tegra_get_revision(u32 id)
 	}
 }
 
-static void tegra_get_process_id(void)
+u32 tegra_read_straps(void)
 {
-	u32 reg;
-
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_cpu_process_id = (reg >> 6) & 3;
-	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
-	tegra_core_process_id = (reg >> 12) & 3;
+	return tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
 }
 
 u32 tegra_read_chipid(void)
@@ -124,90 +89,30 @@ u32 tegra_read_chipid(void)
 	return readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
 }
 
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
 void __init tegra_init_fuse(void)
 {
 	u32 id;
-	u32 randomness[5];
+	u32 reg;
 
-	u32 reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
+	reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
 	reg |= 1 << 28;
 	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
 
-	reg = tegra_fuse_readl(FUSE_SKU_INFO);
-	randomness[0] = reg;
-	tegra_sku_id = reg & 0xFF;
+	/*
+	 * Enable FUSE clock. This needs to be hardcoded because the clock
+	 * subsystem is not active during early boot.
+	 */
+	reg = readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
+	reg |= 1 << 7;
+	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
 
-	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
-	randomness[1] = reg;
+	reg = tegra_read_straps();
 	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
 
 	id = tegra_read_chipid();
-	randomness[2] = id;
 	tegra_chip_id = (id >> 8) & 0xff;
 
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
 	tegra_revision = tegra_get_revision(id);
-	tegra_init_speedo_data();
-	randomness[3] = (tegra_cpu_process_id << 16) | tegra_core_process_id;
-	randomness[4] = (tegra_cpu_speedo_id << 16) | tegra_soc_speedo_id;
-
-	add_device_randomness(randomness, sizeof(randomness));
-	switch (tegra_chip_id) {
-	case TEGRA20:
-		tegra20_fuse_init_randomness();
-	case TEGRA30:
-	case TEGRA114:
-	default:
-		tegra30_fuse_init_randomness();
-	}
-
-	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
-		tegra_revision_name[tegra_revision],
-		tegra_sku_id, tegra_cpu_process_id,
-		tegra_core_process_id);
 }
 
 unsigned long long tegra_chip_uid(void)
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index f53fe9c..8805f3f 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -17,6 +17,7 @@
 #ifndef __LINUX_TEGRA_SOC_H_
 #define __LINUX_TEGRA_SOC_H_
 
+u32 tegra_read_straps(void);
 u32 tegra_read_chipid(void);
 
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

