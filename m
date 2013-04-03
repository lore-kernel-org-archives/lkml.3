Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442Ab3DCOuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:50:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761556Ab3DCOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:58 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 05/12] ARM: tegra: Move tegra_pcie_xclk_clamp() to PMC
Date: Wed,  3 Apr 2013 16:45:11 +0200
Message-Id: <1365000318-28256-6-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:iVRR/1F2fpD9TGh+FnV9TgeLSqQ8uWgAoRZk5GbHWYB
 Eaos6LnJ2mc965tuuZpe0XfKMf5KPidPd68Khx/07IRZu3GGms
 /LIV0fT1VF456PhjCe8NgAZjfq5/iI+TBIrbr1SQs2iKRxIcsz
 Yxnjdh2iKpxw+ssqFUZMLT+MWOyf5U02ti30G4CNHpu/o0wI3a
 nyNCZGpn86xbHLU+UQEfMrZvH9Air/1BgLx6uK/PljitcBukGq
 xua11nH5AICIi92ZYSk9tNoiy3lETw5c/NGddGR8ZXw56GMMfx
 ef6wslw7wIqVEzZT/PVUq/k4PwSaRBXGrRqtjYZFosT+vYoMah
 gOxiL/uJg0xSn+tjvSLQa1St2kgnI0zVHE7KuGd0avbRGze5VR
 PF5OFpVMoiLXJIXkMd1b2Nw86+UHt4daZHCMQcXtbT98YcuZyV
 a+Zoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMC code already accesses to PMC registers so it makes sense to
move this function there as well. While at it, rename the function to
tegra_pmc_pcie_xclk_clamp() for consistency.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
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
index b30e921..f82284c 100644
--- a/arch/arm/mach-tegra/pmc.c
+++ b/arch/arm/mach-tegra/pmc.c
@@ -44,6 +44,10 @@ static DEFINE_SPINLOCK(tegra_powergate_lock);
 static void __iomem *tegra_pmc_base;
 static bool tegra_pmc_invert_interrupt;
 
+/* PMC access is required for PCIE xclk (un)clamping */
+#define PMC_SCRATCH42		0x144
+#define PMC_SCRATCH42_PCX_CLAMP	(1 << 0)
+
 static inline u32 tegra_pmc_readl(u32 reg)
 {
 	return readl(tegra_pmc_base + reg);
@@ -166,3 +170,15 @@ void __init tegra_pmc_init(void)
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
index 7d44710..c778451 100644
--- a/arch/arm/mach-tegra/pmc.h
+++ b/arch/arm/mach-tegra/pmc.h
@@ -23,5 +23,6 @@ int tegra_pmc_cpu_power_on(int cpuid);
 int tegra_pmc_cpu_remove_clamping(int cpuid);
 
 void tegra_pmc_init(void);
+void tegra_pmc_pcie_xclk_clamp(bool clamp);
 
 #endif
-- 
1.8.2

