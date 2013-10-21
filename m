Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3JUNzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:55:40 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19452 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3JUNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:55:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 06:50:59 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 04/15] clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
Date: Mon, 21 Oct 2013 16:53:43 +0300
Message-ID: <1382363634-10870-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag indicates the peripheral clock does not have a divider. It will
simplify the initialization tables and avoids some very similar code.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-periph.c |   11 ++++++++---
 drivers/clk/tegra/clk.h        |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 5102d5e..b5feccc 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -173,12 +173,16 @@ const struct clk_ops tegra_clk_periph_nodiv_ops = {
 static struct clk *_tegra_clk_register_periph(const char *name,
 			const char **parent_names, int num_parents,
 			struct tegra_clk_periph *periph,
-			void __iomem *clk_base, u32 offset, bool div,
+			void __iomem *clk_base, u32 offset,
 			unsigned long flags)
 {
 	struct clk *clk;
 	struct clk_init_data init;
 	struct tegra_clk_periph_regs *bank;
+	bool div = !(periph->gate.flags & TEGRA_PERIPH_NO_DIV);
+
+	flags |= periph->gate.flags & TEGRA_PERIPH_NO_DIV ?
+			CLK_SET_RATE_PARENT : 0;
 
 	init.name = name;
 	init.ops = div ? &tegra_clk_periph_ops : &tegra_clk_periph_nodiv_ops;
@@ -216,7 +220,7 @@ struct clk *tegra_clk_register_periph(const char *name,
 		u32 offset, unsigned long flags)
 {
 	return _tegra_clk_register_periph(name, parent_names, num_parents,
-			periph, clk_base, offset, true, flags);
+			periph, clk_base, offset, flags);
 }
 
 struct clk *tegra_clk_register_periph_nodiv(const char *name,
@@ -224,6 +228,7 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset)
 {
+	periph->gate.flags |= TEGRA_PERIPH_NO_DIV;
 	return _tegra_clk_register_periph(name, parent_names, num_parents,
-			periph, clk_base, offset, false, CLK_SET_RATE_PARENT);
+			periph, clk_base, offset, CLK_SET_RATE_PARENT);
 }
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 997357e..a826720 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -397,6 +397,7 @@ struct tegra_clk_periph_gate {
 #define TEGRA_PERIPH_MANUAL_RESET BIT(1)
 #define TEGRA_PERIPH_ON_APB BIT(2)
 #define TEGRA_PERIPH_WAR_1005168 BIT(3)
+#define TEGRA_PERIPH_NO_DIV BIT(4)
 
 void tegra_periph_reset(struct tegra_clk_periph_gate *gate, bool assert);
 extern const struct clk_ops tegra_clk_periph_gate_ops;
-- 
1.7.7.rc0.72.g4b5ea.dirty

