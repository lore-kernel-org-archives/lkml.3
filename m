Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3JBTHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:07:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40931 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3JBTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:07:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v2 1/9] clk: Allow drivers to pass in a regmap
Date: Wed,  2 Oct 2013 12:06:58 -0700
Message-Id: <1380740826-29457-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
References: <1380740826-29457-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the clock core so that drivers can pass in a
regmap. If no regmap is specified try to query the device that's
registering the clock for its regmap. This should allow drivers
to use the core regmap helpers.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 8 ++++++++
 include/linux/clk-provider.h | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a004769..6107daa 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/regmap.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
@@ -1829,6 +1830,13 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 	clk->num_parents = hw->init->num_parents;
 	hw->clk = clk;
 
+	if (hw->init->regmap)
+		hw->regmap = hw->init->regmap;
+	else if (dev && dev_get_regmap(dev, NULL))
+		hw->regmap = dev_get_regmap(dev, NULL);
+	else if (dev->parent)
+		hw->regmap = dev_get_regmap(dev->parent, NULL);
+
 	/* allocate local copy in case parent_names is __initdata */
 	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
 			GFP_KERNEL);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 73bdb69..6ed62f1 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -142,6 +142,8 @@ struct clk_ops {
 	void		(*init)(struct clk_hw *hw);
 };
 
+struct regmap;
+
 /**
  * struct clk_init_data - holds init data that's common to all clocks and is
  * shared between the clock provider and the common clock framework.
@@ -151,6 +153,7 @@ struct clk_ops {
  * @parent_names: array of string names for all possible parents
  * @num_parents: number of possible parents
  * @flags: framework-level hints and quirks
+ * @regmap: regmap to use for regmap helpers and/or by providers
  */
 struct clk_init_data {
 	const char		*name;
@@ -158,6 +161,7 @@ struct clk_init_data {
 	const char		**parent_names;
 	u8			num_parents;
 	unsigned long		flags;
+	struct regmap		*regmap;
 };
 
 /**
@@ -171,10 +175,13 @@ struct clk_init_data {
  *
  * @init: pointer to struct clk_init_data that contains the init data shared
  * with the common clock framework.
+ *
+ * @regmap: regmap to use for regmap helpers and/or by providers
  */
 struct clk_hw {
 	struct clk *clk;
 	const struct clk_init_data *init;
+	struct regmap *regmap;
 };
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

