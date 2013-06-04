Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3FDS47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:56:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8129 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3FDS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:56:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Jun 2013 11:56:31 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>,
        <thierry.reding@avionic-design.de>, <bhelgaas@google.com>,
        <ldewangan@nvidia.com>, <olof@lixom.net>, <hdoyu@nvidia.com>,
        <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <pdeschrijver@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <jtukkinen@nvidia.com>, <kthota@nvidia.com>, <jagarwal@nvidia.com>
Subject: [PATCH V3 1/4] ARM: tegra30: clocks: Fix pciex clock registration
Date: Wed, 5 Jun 2013 00:27:29 +0530
Message-ID: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registering pciex as peripheral clock instead of fixed clock
as tegra_perih_reset_assert(deassert) api of this clock api
gives warning and ultimately does not succeed to assert(deassert).

Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
---
Patch is based on remotes/gitorious_thierryreding_linux/tegra/next and should be applied on top of this.

Changes in V3:
- Avoid removing pciex duplicate clock as per review comment
- Corrected tegra pcie driver name for duplicate clocks

 drivers/clk/tegra/clk-tegra30.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index c6921f5..edb2b9b 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1598,6 +1598,12 @@ static void __init tegra30_periph_clk_init(void)
 	clk_register_clkdev(clk, "afi", "tegra-pcie");
 	clks[afi] = clk;
 
+	/* pciex */
+	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
+				    74, &periph_u_regs, periph_clk_enb_refcnt);
+	clk_register_clkdev(clk, "pciex", "tegra-pcie");
+	clks[pciex] = clk;
+
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
@@ -1716,11 +1722,6 @@ static void __init tegra30_fixed_clk_init(void)
 				1, 0, &cml_lock);
 	clk_register_clkdev(clk, "cml1", NULL);
 	clks[cml1] = clk;
-
-	/* pciex */
-	clk = clk_register_fixed_rate(NULL, "pciex", "pll_e", 0, 100000000);
-	clk_register_clkdev(clk, "pciex", NULL);
-	clks[pciex] = clk;
 }
 
 static void __init tegra30_osc_clk_init(void)
@@ -1942,8 +1943,8 @@ static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
 	TEGRA_CLK_DUPLICATE(bsea, "tegra-aes", "bsea"),
 	TEGRA_CLK_DUPLICATE(bsea, "nvavp", "bsea"),
 	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
-	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
-	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),
+	TEGRA_CLK_DUPLICATE(cml0, "tegra-pcie", "cml"),
+	TEGRA_CLK_DUPLICATE(pciex, "tegra-pcie", "pciex"),
 	TEGRA_CLK_DUPLICATE(vcp, "nvavp", "vcp"),
 	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* MUST be the last entry */
 };
-- 
1.7.0.4

