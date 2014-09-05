Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaIEWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:47:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43522 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIEWrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:39 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 01/15] clk: mux: Add unregistration API
Date: Fri,  5 Sep 2014 15:47:20 -0700
Message-Id: <1409957256-23729-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers want to remove clocks they register with
clk_unregister(). Unfortunately, calling clk_unregister()
directly on the clock returned by clk_register_mux() would result
in a memory leak of the clk_mux struct. Add an API to free that
allocation and unregister the clock.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk-mux.c        | 15 +++++++++++++++
 include/linux/clk-provider.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 4f96ff3ba728..c0cf9db9effa 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -177,3 +177,18 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 				      NULL, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_mux);
+
+void clk_unregister_mux(struct clk *clk)
+{
+	struct clk_hw *hw;
+	struct clk_mux *mux;
+
+	hw = __clk_get_hw(clk);
+	if (!hw)
+		return;
+
+	mux = to_clk_mux(hw);
+	clk_unregister(clk);
+	kfree(mux);
+}
+EXPORT_SYMBOL_GPL(clk_unregister_mux);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 411dd7eb2653..f0744b8de50a 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -401,6 +401,8 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
 
+void clk_unregister_mux(struct clk *clk);
+
 void of_fixed_factor_clk_setup(struct device_node *node);
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

