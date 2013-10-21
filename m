Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3JUN4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:56:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19473 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3JUN4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:56:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Oct 2013 06:56:37 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 08/15] clk: tegra: add common infra for DT clocks
Date: Mon, 21 Oct 2013 16:53:47 +0300
Message-ID: <1382363634-10870-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common infrastructure for sharing clock initialization between
SoCs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    9 +++++++++
 drivers/clk/tegra/clk.h |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 3a95a87..a0430cd 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -212,6 +212,15 @@ void __init tegra_add_of_provider(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
 
+struct clk ** __init tegra_lookup_dt_id(int clk_id,
+					struct tegra_clk *tegra_clk)
+{
+	if (tegra_clk[clk_id].present)
+		return &clks[tegra_clk[clk_id].dt_id];
+	else
+		return NULL;
+}
+
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
 void __init tegra_clocks_apply_init_table(void)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index c49df4d..489dad5 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -568,6 +568,11 @@ struct tegra_clk_duplicate {
 		},				\
 	}
 
+struct tegra_clk {
+	int			dt_id;
+	bool			present;
+};
+
 void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 		struct clk *clks[], int clk_max);
 
@@ -577,6 +582,8 @@ void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 struct tegra_clk_periph_regs *get_reg_bank(int clkid);
 struct clk **tegra_clk_init(int num, int periph_banks);
 
+struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
+
 void tegra_add_of_provider(struct device_node *np);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

