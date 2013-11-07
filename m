Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3KGKNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:13:55 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5380 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3KGKMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:12:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Nov 2013 02:07:14 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v10 5/7] ARM: tegra: split setting of CPU reset handler
Date: Thu, 7 Nov 2013 19:11:44 +0900
Message-ID: <1383819106-1400-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/reset.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index fd0bbf8a6c94..e282395b071c 100644
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
1.8.4.2

