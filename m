Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab3D3Mqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:46:36 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48722 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760482Ab3D3Mqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:46:35 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] clk: ux500: clk-sysctrl: handle clocks with no parents
Date: Tue, 30 Apr 2013 14:45:06 +0200
Message-Id: <1367325906-23045-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix clk_reg_sysctrl() to set main clock registers of new struct
clk_sysctrl even if the registered clock has no parents.

This fixes an issue where "ulpclk" was registered with all clk->reg_*
fields uninitialized, causing a -EINVAL error from clk_prepare().

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/clk/ux500/clk-sysctrl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ux500/clk-sysctrl.c b/drivers/clk/ux500/clk-sysctrl.c
index bc7e9bd..e364c9d 100644
--- a/drivers/clk/ux500/clk-sysctrl.c
+++ b/drivers/clk/ux500/clk-sysctrl.c
@@ -145,7 +145,13 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	for (i = 0; i < num_parents; i++) {
+	/* set main clock registers */
+	clk->reg_sel[0] = reg_sel[0];
+	clk->reg_bits[0] = reg_bits[0];
+	clk->reg_mask[0] = reg_mask[0];
+
+	/* handle clocks with more than one parent */
+	for (i = 1; i < num_parents; i++) {
 		clk->reg_sel[i] = reg_sel[i];
 		clk->reg_bits[i] = reg_bits[i];
 		clk->reg_mask[i] = reg_mask[i];
-- 
1.8.2

