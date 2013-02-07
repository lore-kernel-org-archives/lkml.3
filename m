Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3BGQZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:25:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6721 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:25:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 07 Feb 2013 08:25:00 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: Implement locking for super clock
Date: Thu, 7 Feb 2013 18:24:14 +0200
Message-ID: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although tegra_clk_register_super_mux() has a lock parameter, the lock is not
actually used by the code. Fixed with this patch.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-super.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
index 7ad48a8..2fd924d 100644
--- a/drivers/clk/tegra/clk-super.c
+++ b/drivers/clk/tegra/clk-super.c
@@ -73,7 +73,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
 	u32 val, state;
+	int err = 0;
 	u8 parent_index, shift;
+	unsigned long flags = 0;
+
+	if (mux->lock)
+		spin_lock_irqsave(mux->lock, flags);
 
 	val = readl_relaxed(mux->reg);
 	state = val & SUPER_STATE_MASK;
@@ -92,8 +97,10 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
 					       (index == mux->pllx_index))) {
 		parent_index = clk_super_get_parent(hw);
 		if ((parent_index == mux->div2_index) ||
-		    (parent_index == mux->pllx_index))
-			return -EINVAL;
+		    (parent_index == mux->pllx_index)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		val ^= SUPER_LP_DIV2_BYPASS;
 		writel_relaxed(val, mux->reg);
@@ -107,7 +114,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
 
 	writel_relaxed(val, mux->reg);
 	udelay(2);
-	return 0;
+
+out:
+	if (mux->lock)
+		spin_unlock_irqrestore(mux->lock, flags);
+
+	return err;
 }
 
 const struct clk_ops tegra_clk_super_ops = {
-- 
1.7.7.rc0.72.g4b5ea.dirty

