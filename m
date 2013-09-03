Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab3ICNc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:32:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17702 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab3ICNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:32:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 06:32:53 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] clk: tegra114: table driven PMC clock init
Date: Tue, 3 Sep 2013 16:31:34 +0300
Message-ID: <1378215105-12145-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the Tegra114 audio clock registration to be table driven
like the periph clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |   58 +++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 35 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 9f8d534..052e6ab 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1583,45 +1583,33 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	}
 }
 
+static struct pmc_clk_init_data tegra_pmc_clk_init_data[] = {
+	TEGRA_INIT_PMC_CLK("clk_out_1", "extern1", clk_out1_parents, 6, 2, TEGRA114_CLK_CLK_OUT_1),
+	TEGRA_INIT_PMC_CLK("clk_out_2", "extern2", clk_out2_parents, 14, 10, TEGRA114_CLK_CLK_OUT_2),
+	TEGRA_INIT_PMC_CLK("clk_out_3", "extern3", clk_out3_parents, 22, 18, TEGRA114_CLK_CLK_OUT_3),
+};
+
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 {
 	struct clk *clk;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_pmc_clk_init_data); i++) {
+		struct pmc_clk_init_data *data;
 
-	/* clk_out_1 */
-	clk = clk_register_mux(NULL, "clk_out_1_mux", clk_out1_parents,
-			       ARRAY_SIZE(clk_out1_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 6, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_1_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
-	clks[TEGRA114_CLK_CLK_OUT_1] = clk;
-
-	/* clk_out_2 */
-	clk = clk_register_mux(NULL, "clk_out_2_mux", clk_out2_parents,
-			       ARRAY_SIZE(clk_out2_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 14, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_2_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
-	clks[TEGRA114_CLK_CLK_OUT_2] = clk;
-
-	/* clk_out_3 */
-	clk = clk_register_mux(NULL, "clk_out_3_mux", clk_out3_parents,
-			       ARRAY_SIZE(clk_out3_parents), 0,
-			       pmc_base + PMC_CLK_OUT_CNTRL, 22, 3, 0,
-			       &clk_out_lock);
-	clks[TEGRA114_CLK_CLK_OUT_3_MUX] = clk;
-	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
-				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
-				&clk_out_lock);
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
-	clks[TEGRA114_CLK_CLK_OUT_3] = clk;
+		data = &tegra_pmc_clk_init_data[i];
+
+		clk = clk_register_mux(NULL, data->mux_name, data->parents,
+				data->num_parents, 0,
+				pmc_base + PMC_CLK_OUT_CNTRL, data->mux_shift,
+				3, 0, &clk_out_lock);
+		clks[data->mux_id] = clk;
+		clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
+					0, pmc_base + PMC_CLK_OUT_CNTRL,
+					data->gate_shift, 0, &clk_out_lock);
+		clks[data->gate_id] = clk;
+		clk_register_clkdev(clk, data->dev_name, data->gate_name);
+	}
 
 	/* blink */
 	/* clear the blink timer register to directly output clk_32k */
-- 
1.7.7.rc0.72.g4b5ea.dirty

