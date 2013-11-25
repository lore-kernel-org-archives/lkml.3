Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3KYNVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:21:36 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1780 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3KYNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:20:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Nov 2013 05:14:31 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] clk: tegra: fix vi clk for Terga124
Date: Mon, 25 Nov 2013 15:20:22 +0200
Message-ID: <1385385623-8952-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1385385623-8952-1-git-send-email-pdeschrijver@nvidia.com>
References: <1385385623-8952-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vi clk on Tegra124 has an extra possible parent: pll_c4. Fix the code
to allow for this.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-id.h           |    1 +
 drivers/clk/tegra/clk-tegra-periph.c |    8 ++++++++
 drivers/clk/tegra/clk-tegra124.c     |    2 +-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index 836b054..c5aba5c 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -212,6 +212,7 @@ enum clk_id {
 	tegra_clk_vfir,
 	tegra_clk_vi,
 	tegra_clk_vi_8,
+	tegra_clk_vi_9,
 	tegra_clk_vic03,
 	tegra_clk_vim2_clk,
 	tegra_clk_vimclk_sync,
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 9125d02..fb84f60 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -359,6 +359,13 @@ static u32 mux_pllm_pllc_pllp_plla_pllc2_c3_clkm_idx[] = {
 	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6,
 };
 
+static const char *mux_pllm_pllc2_c_c3_pllp_plla_pllc4[] = {
+	"pll_m", "pll_c2", "pll_c", "pll_c3", "pll_p", "pll_a_out0", "pll_c4",
+};
+static u32 mux_pllm_pllc2_c_c3_pllp_plla_pllc4_idx[] = {
+	[0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 6, [6] = 7,
+};
+
 static struct tegra_periph_init_data periph_clks[] = {
 	AUDIO("d_audio", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, tegra_clk_d_audio),
 	AUDIO("dam0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, tegra_clk_dam0),
@@ -378,6 +385,7 @@ static struct tegra_periph_init_data periph_clks[] = {
 	INT("3d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d),
 	INT8("vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, tegra_clk_vde_8),
 	INT8("vi", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, tegra_clk_vi_8),
+	INT8("vi", mux_pllm_pllc2_c_c3_pllp_plla_pllc4, CLK_SOURCE_VI, 20, 0, tegra_clk_vi_9),
 	INT8("epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, tegra_clk_epp_8),
 	INT8("msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, tegra_clk_msenc),
 	INT8("tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, tegra_clk_tsec),
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 3584138..54af043 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -861,7 +861,7 @@ static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_vfir] = { .dt_id = TEGRA124_CLK_VFIR, .present = true },
 	[tegra_clk_spdif_in] = { .dt_id = TEGRA124_CLK_SPDIF_IN, .present = true },
 	[tegra_clk_spdif_out] = { .dt_id = TEGRA124_CLK_SPDIF_OUT, .present = true },
-	[tegra_clk_vi] = { .dt_id = TEGRA124_CLK_VI, .present = true },
+	[tegra_clk_vi_9] = { .dt_id = TEGRA124_CLK_VI, .present = true },
 	[tegra_clk_vi_sensor] = { .dt_id = TEGRA124_CLK_VI_SENSOR, .present = true },
 	[tegra_clk_fuse] = { .dt_id = TEGRA124_CLK_FUSE, .present = true },
 	[tegra_clk_fuse_burn] = { .dt_id = TEGRA124_CLK_FUSE_BURN, .present = true },
-- 
1.7.7.rc0.72.g4b5ea.dirty

