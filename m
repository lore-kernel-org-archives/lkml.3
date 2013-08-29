Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3H2J6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:58:55 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19403 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3H2J6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:58:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 29 Aug 2013 02:58:05 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 3/5] ARM: tegra: split setting of CPU reset handler
Date: Thu, 29 Aug 2013 18:57:46 +0900
Message-ID: <1377770268-14014-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all Tegra devices can set the CPU reset handler in the same way.
In particular, devices using a TrustZone secure monitor cannot set the
reset handler directly and need to do it through a firmware operation.

This patch separates the act of setting the reset handler from its
preparation, so the former can be implemented in a different way.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/mach-tegra/reset.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index 1ac434e..6964117 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -33,26 +33,18 @@
 
 static bool is_enabled;
 
-static void __init tegra_cpu_reset_handler_enable(void)
+static void __init tegra_cpu_reset_handler_set(const u32 reset_address)
 {
-	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
 	void __iomem *evp_cpu_reset =
 		IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE + 0x100);
 	void __iomem *sb_ctrl = IO_ADDRESS(TEGRA_SB_BASE);
 	u32 reg;
 
-	BUG_ON(is_enabled);
-	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
-
-	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
-			tegra_cpu_reset_handler_size);
-
 	/*
 	 * NOTE: This must be the one and only write to the EVP CPU reset
 	 *       vector in the entire system.
 	 */
-	writel(TEGRA_IRAM_RESET_BASE + tegra_cpu_reset_handler_offset,
-			evp_cpu_reset);
+	writel(reset_address, evp_cpu_reset);
 	wmb();
 	reg = readl(evp_cpu_reset);
 
@@ -66,6 +58,21 @@ static void __init tegra_cpu_reset_handler_enable(void)
 		writel(reg, sb_ctrl);
 		wmb();
 	}
+}
+
+static void __init tegra_cpu_reset_handler_enable(void)
+{
+	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
+	const u32 reset_address = TEGRA_IRAM_RESET_BASE +
+						tegra_cpu_reset_handler_offset;
+
+	BUG_ON(is_enabled);
+	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
+
+	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+			tegra_cpu_reset_handler_size);
+
+	tegra_cpu_reset_handler_set(reset_address);
 
 	is_enabled = true;
 }
-- 
1.8.4

