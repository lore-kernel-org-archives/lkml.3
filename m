Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaLWKkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:18 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17937 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaLWKkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Dec 2014 02:35:05 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH 3/11] memory: tegra: add flush operation for Tegra124 memory clients
Date: Tue, 23 Dec 2014 18:39:56 +0800
Message-ID: <1419331204-26679-4-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drivers/memory/tegra/tegra124.c | 82 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/memory/tegra/tegra124.c b/drivers/memory/tegra/tegra124.c
index 278d40b854c1..036935743a0a 100644
--- a/drivers/memory/tegra/tegra124.c
+++ b/drivers/memory/tegra/tegra124.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/mm.h>
 
@@ -959,7 +960,85 @@ static const struct tegra_smmu_swgroup tegra124_swgroups[] = {
 	{ .swgroup = TEGRA_SWGROUP_VI,        .reg = 0x280 },
 };
 
+static const struct tegra_mc_hr tegra124_mc_hr[] = {
+	{TEGRA_SWGROUP_AFI,        0x200, 0x200,  0},
+	{TEGRA_SWGROUP_AVPC,       0x200, 0x200,  1},
+	{TEGRA_SWGROUP_DC,         0x200, 0x200,  2},
+	{TEGRA_SWGROUP_DCB,        0x200, 0x200,  3},
+	{TEGRA_SWGROUP_HC,         0x200, 0x200,  6},
+	{TEGRA_SWGROUP_HDA,        0x200, 0x200,  7},
+	{TEGRA_SWGROUP_ISP2,       0x200, 0x200,  8},
+	{TEGRA_SWGROUP_MPCORE,     0x200, 0x200,  9},
+	{TEGRA_SWGROUP_MPCORELP,   0x200, 0x200, 10},
+	{TEGRA_SWGROUP_MSENC,      0x200, 0x200, 11},
+	{TEGRA_SWGROUP_PPCS,       0x200, 0x200, 14},
+	{TEGRA_SWGROUP_SATA,       0x200, 0x200, 15},
+	{TEGRA_SWGROUP_VDE,        0x200, 0x200, 16},
+	{TEGRA_SWGROUP_VI,         0x200, 0x200, 17},
+	{TEGRA_SWGROUP_VIC,        0x200, 0x200, 18},
+	{TEGRA_SWGROUP_XUSB_HOST,  0x200, 0x200, 19},
+	{TEGRA_SWGROUP_XUSB_DEV,   0x200, 0x200, 20},
+	{TEGRA_SWGROUP_TSEC,       0x200, 0x200, 22},
+	{TEGRA_SWGROUP_SDMMC1A,    0x200, 0x200, 29},
+	{TEGRA_SWGROUP_SDMMC2A,    0x200, 0x200, 30},
+	{TEGRA_SWGROUP_SDMMC3A,    0x200, 0x200, 31},
+	{TEGRA_SWGROUP_SDMMC4A,    0x970, 0x974,  0},
+	{TEGRA_SWGROUP_ISP2B,      0x970, 0x974,  1},
+	{TEGRA_SWGROUP_GPU,        0x970, 0x974,  2},
+};
+
 #ifdef CONFIG_ARCH_TEGRA_124_SOC
+
+static bool tegra124_stable_hotreset_check(struct tegra_mc *mc,
+		u32 reg, u32 *stat)
+{
+	int i;
+	u32 cur_stat;
+	u32 prv_stat;
+
+	prv_stat = mc_readl(mc, reg);
+	for (i = 0; i < 5; i++) {
+		cur_stat = mc_readl(mc, reg);
+		if (cur_stat != prv_stat)
+			return false;
+	}
+	*stat = cur_stat;
+	return true;
+}
+
+static int tegra124_mc_flush(struct tegra_mc *mc,
+		const struct tegra_mc_hr *hr_client, bool enable)
+{
+	u32 val;
+
+	if (!mc || !hr_client)
+		return -EINVAL;
+
+	val = mc_readl(mc, hr_client->ctrl);
+	if (enable)
+		val |= BIT(hr_client->bit);
+	else
+		val &= ~BIT(hr_client->bit);
+	mc_writel(mc, val, hr_client->ctrl);
+	mc_readl(mc, hr_client->ctrl);
+
+	/* poll till the flush is done */
+	if (enable) {
+		do {
+			udelay(10);
+			val = 0;
+			if (!tegra124_stable_hotreset_check(mc, hr_client->status, &val))
+				continue;
+		} while (!(val & BIT(hr_client->bit)));
+	}
+
+	return 0;
+}
+
+static const struct tegra_mc_ops tegra124_mc_ops = {
+	.flush = tegra124_mc_flush,
+};
+
 static void tegra124_flush_dcache(struct page *page, unsigned long offset,
 				  size_t size)
 {
@@ -991,5 +1070,8 @@ const struct tegra_mc_soc tegra124_mc_soc = {
 	.num_address_bits = 34,
 	.atom_size = 32,
 	.smmu = &tegra124_smmu_soc,
+	.hr_clients = tegra124_mc_hr,
+	.num_hr_clients = ARRAY_SIZE(tegra124_mc_hr),
+	.ops = &tegra124_mc_ops,
 };
 #endif /* CONFIG_ARCH_TEGRA_124_SOC */
-- 
1.9.1

