Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbbAPMhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:37:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:58189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbbAPMhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:37:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="441361092"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clk: fractional-divider: prevent division by zero
Date: Fri, 16 Jan 2015 14:37:50 +0200
Message-Id: <1421411870-115195-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preventing division by zero condition by making sure that
the initial n and m values are not 0.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/clk/clk-fractional-divider.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index 82a59d0..dc91da7 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -104,6 +104,7 @@ struct clk *clk_register_fractional_divider(struct device *dev,
 	struct clk_fractional_divider *fd;
 	struct clk_init_data init;
 	struct clk *clk;
+	u32 val;
 
 	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
 	if (!fd) {
@@ -126,6 +127,14 @@ struct clk *clk_register_fractional_divider(struct device *dev,
 	fd->lock = lock;
 	fd->hw.init = &init;
 
+	/* Prevent division by zero */
+	val = clk_readl(fd->reg);
+	if (!(val & fd->nmask))
+		val |= 1 << fd->nshift;
+	if (!(val & fd->mmask))
+		val |= 1 << fd->mshift;
+	clk_writel(val, fd->reg);
+
 	clk = clk_register(dev, &fd->hw);
 	if (IS_ERR(clk))
 		kfree(fd);
-- 
2.1.4

