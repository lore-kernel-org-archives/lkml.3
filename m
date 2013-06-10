Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3FJJOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:14:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4041 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3FJJO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:14:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 02:13:05 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 2/2] memory: tegra30-mc: Fix IRQ handler bugs.
Date: Mon, 10 Jun 2013 12:13:44 +0300
Message-ID: <1370855624-30564-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com>
References: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Tegra30 memory controller any MC interrupt would cause an infinite loop in
the IRQ handler. Additionally, a garbage pointer was used to read the MC
status registers, which causes wrong values to be printed if a MC error
occurred.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/memory/tegra30-mc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index f4ae074..a6a05a2 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -218,7 +218,7 @@ static void tegra30_mc_decode(struct tegra30_mc *mc, int n)
 		return;
 	}
 
-	err = readl(mc + MC_ERR_STATUS);
+	err = mc_readl(mc, MC_ERR_STATUS);
 
 	type = (err & MC_ERR_TYPE_MASK) >> MC_ERR_TYPE_SHIFT;
 	perm = (err & MC_ERR_INVALID_SMMU_PAGE_MASK) >>
@@ -235,7 +235,7 @@ static void tegra30_mc_decode(struct tegra30_mc *mc, int n)
 	if (cid < ARRAY_SIZE(tegra30_mc_client))
 		client = tegra30_mc_client[cid];
 
-	addr = readl(mc + MC_ERR_ADR);
+	addr = mc_readl(mc, MC_ERR_ADR);
 
 	dev_err_ratelimited(mc->dev, "%s (0x%08x): 0x%08x %s (%s %s %s %s)\n",
 			   mc_int_err[idx], err, addr, client,
@@ -313,8 +313,11 @@ static irqreturn_t tegra30_mc_isr(int irq, void *data)
 	mask &= stat;
 	if (!mask)
 		return IRQ_NONE;
-	while ((bit = ffs(mask)) != 0)
+	while ((bit = ffs(mask)) != 0) {
 		tegra30_mc_decode(mc, bit - 1);
+		mask &= BIT(bit);
+	}
+
 	mc_writel(mc, stat, MC_INTSTATUS);
 	return IRQ_HANDLED;
 }
-- 
1.8.1.5

