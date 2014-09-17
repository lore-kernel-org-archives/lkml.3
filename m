Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaIQJev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:34:51 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57644 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaIQJeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:34:50 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH] clk: tegra: Make clock initialization more robust
Date: Wed, 17 Sep 2014 11:34:17 +0200
Message-Id: <1410946457-24669-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't abort clock initialization if we cannot match an entry in
tegra_clk_init_table to a valid entry in the clk array.

Also log a corresponding error message.

This was discovered when testing a patch that removed the EMC clock from
tegra124_clks but left a mention in tegra_clk_init_table.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/tegra/clk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index d5963f6..562c911 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -206,8 +206,13 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 
 	for (; tbl->clk_id < clk_max; tbl++) {
 		clk = clks[tbl->clk_id];
-		if (IS_ERR_OR_NULL(clk))
-			return;
+		if (IS_ERR_OR_NULL(clk)) {
+			pr_err("%s: invalid entry %ld in clks array for id %d\n",
+			       __func__, PTR_ERR(clk), tbl->clk_id);
+			WARN_ON(1);
+
+			continue;
+		}
 
 		if (tbl->parent_id < clk_max) {
 			struct clk_core *parent = clks[tbl->parent_id];
-- 
1.9.3

