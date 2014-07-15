Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaGOPZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:25:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19144 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaGOPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:25:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 08:14:27 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/6] clk: tegra: make tegra_clocks_apply_init_table arch_initcall
Date: Tue, 15 Jul 2014 18:24:32 +0300
Message-ID: <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_clocks_apply_init_table needs to be called after the udelay loop has
been calibrated (see 441f199a37cfd66c5dd8dd45490bd3ea6971117d why that is).
On existing Tegra SoCs this was done by calling tegra_clocks_apply_init_table
from tegra_dt_init. To make this also work on ARM64, we need to
change this into an initcall. tegra_dt_init is called from customize_machine
which is an arch_initcall. Therefore this should also work on existing 32bit
Tegra SoCs.

Tested on Tegra20 (ventana), Tegra30 (beaverboard), Tegra124 (jetson TK1) and
Tegra132.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/tegra.c |    3 ---
 drivers/clk/tegra/clk.c     |    7 +++++--
 include/linux/clk/tegra.h   |    2 --
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 15ac9fc..6c5cad5 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
 #include <linux/usb/tegra_usb_phy.h>
-#include <linux/clk/tegra.h>
 #include <linux/irqchip.h>
 
 #include <asm/hardware/cache-l2x0.h>
@@ -96,8 +95,6 @@ static void __init tegra_dt_init(void)
 
 	tegra_pmc_init();
 
-	tegra_clocks_apply_init_table();
-
 	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		goto out;
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index d081732..65cde4e 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -290,10 +290,13 @@ struct clk ** __init tegra_lookup_dt_id(int clk_id,
 
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
-void __init tegra_clocks_apply_init_table(void)
+static int __init tegra_clocks_apply_init_table(void)
 {
 	if (!tegra_clk_apply_init_table)
-		return;
+		return 0;
 
 	tegra_clk_apply_init_table();
+
+	return 0;
 }
+arch_initcall(tegra_clocks_apply_init_table);
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 3ca9fca..19c4208 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -120,6 +120,4 @@ static inline void tegra_cpu_clock_resume(void)
 }
 #endif
 
-void tegra_clocks_apply_init_table(void);
-
 #endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.7.rc0.72.g4b5ea.dirty

