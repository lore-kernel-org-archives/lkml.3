Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3GYRxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:53:53 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:46059 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3GYRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:53:45 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 01/16] ARM: tegra: Move tegra_pcie_xclk_clamp() to PMC
Date: Thu, 25 Jul 2013 10:53:15 -0700
Message-Id: <1374774810-18459-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>

The PMC code already accesses to PMC registers so it makes sense to
move this function there as well. While at it, rename the function to
tegra_pmc_pcie_xclk_clamp() for consistency.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-tegra/pcie.c | 30 ++++--------------------------
 arch/arm/mach-tegra/pmc.c  | 16 ++++++++++++++++
 arch/arm/mach-tegra/pmc.h  |  1 +
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index 46144a1..6c1989b 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -41,6 +41,7 @@
 
 #include "board.h"
 #include "iomap.h"
+#include "pmc.h"
 
 /* Hack - need to parse this from DT */
 #define INT_PCIE_INTR 130
@@ -147,17 +148,6 @@
 #define  PADS_PLL_CTL_TXCLKREF_DIV10		(0 << 20)
 #define  PADS_PLL_CTL_TXCLKREF_DIV5		(1 << 20)
 
-/* PMC access is required for PCIE xclk (un)clamping */
-#define PMC_SCRATCH42		0x144
-#define PMC_SCRATCH42_PCX_CLAMP	(1 << 0)
-
-static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
-
-#define pmc_writel(value, reg) \
-	__raw_writel(value, reg_pmc_base + (reg))
-#define pmc_readl(reg) \
-	__raw_readl(reg_pmc_base + (reg))
-
 /*
  * Tegra2 defines 1GB in the AXI address map for PCIe.
  *
@@ -639,18 +629,6 @@ static int tegra_pcie_enable_controller(void)
 	return 0;
 }
 
-static void tegra_pcie_xclk_clamp(bool clamp)
-{
-	u32 reg;
-
-	reg = pmc_readl(PMC_SCRATCH42) & ~PMC_SCRATCH42_PCX_CLAMP;
-
-	if (clamp)
-		reg |= PMC_SCRATCH42_PCX_CLAMP;
-
-	pmc_writel(reg, PMC_SCRATCH42);
-}
-
 static void tegra_pcie_power_off(void)
 {
 	tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
@@ -658,7 +636,7 @@ static void tegra_pcie_power_off(void)
 	tegra_periph_reset_assert(tegra_pcie.pex_clk);
 
 	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
-	tegra_pcie_xclk_clamp(true);
+	tegra_pmc_pcie_xclk_clamp(true);
 }
 
 static int tegra_pcie_power_regate(void)
@@ -667,7 +645,7 @@ static int tegra_pcie_power_regate(void)
 
 	tegra_pcie_power_off();
 
-	tegra_pcie_xclk_clamp(true);
+	tegra_pmc_pcie_xclk_clamp(true);
 
 	tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
 	tegra_periph_reset_assert(tegra_pcie.afi_clk);
@@ -681,7 +659,7 @@ static int tegra_pcie_power_regate(void)
 
 	tegra_periph_reset_deassert(tegra_pcie.afi_clk);
 
-	tegra_pcie_xclk_clamp(false);
+	tegra_pmc_pcie_xclk_clamp(false);
 
 	clk_prepare_enable(tegra_pcie.afi_clk);
 	clk_prepare_enable(tegra_pcie.pex_clk);
diff --git a/arch/arm/mach-tegra/pmc.c b/arch/arm/mach-tegra/pmc.c
index 8345fcd..db72297 100644
--- a/arch/arm/mach-tegra/pmc.c
+++ b/arch/arm/mach-tegra/pmc.c
@@ -75,6 +75,10 @@ struct pmc_pm_data {
 };
 static struct pmc_pm_data pmc_pm_data;
 
+/* PMC access is required for PCIE xclk (un)clamping */
+#define PMC_SCRATCH42		0x144
+#define PMC_SCRATCH42_PCX_CLAMP	(1 << 0)
+
 static inline u32 tegra_pmc_readl(u32 reg)
 {
 	return readl(tegra_pmc_base + reg);
@@ -342,3 +346,15 @@ void __init tegra_pmc_init(void)
 		val &= ~PMC_CTRL_INTR_LOW;
 	tegra_pmc_writel(val, PMC_CTRL);
 }
+
+void tegra_pmc_pcie_xclk_clamp(bool clamp)
+{
+	u32 reg;
+
+	reg = tegra_pmc_readl(PMC_SCRATCH42) & ~PMC_SCRATCH42_PCX_CLAMP;
+
+	if (clamp)
+		reg |= PMC_SCRATCH42_PCX_CLAMP;
+
+	tegra_pmc_writel(reg, PMC_SCRATCH42);
+}
diff --git a/arch/arm/mach-tegra/pmc.h b/arch/arm/mach-tegra/pmc.h
index e1c2df2..cdb08a1 100644
--- a/arch/arm/mach-tegra/pmc.h
+++ b/arch/arm/mach-tegra/pmc.h
@@ -37,5 +37,6 @@ int tegra_pmc_cpu_power_on(int cpuid);
 int tegra_pmc_cpu_remove_clamping(int cpuid);
 
 void tegra_pmc_init(void);
+void tegra_pmc_pcie_xclk_clamp(bool clamp);
 
 #endif
-- 
1.8.1.5

