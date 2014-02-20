Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaBTN7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:59:08 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:57941 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaBTN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:59:06 -0500
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND AGAIN] clk: support hardware-specific debugfs entries
Date: Thu, 20 Feb 2014 07:58:55 -0600
Message-Id: <1392904735-23026-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new clk_ops->debug_init method to allow a clock hardware
driver to populate the clock's debugfs directory with entries
beyond those common for every clock.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/clk.c            |    4 ++++
 include/linux/clk-provider.h |    8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5517944..64b579a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -277,6 +277,10 @@ static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 	if (!d)
 		goto err_out;
 
+	if (clk->ops->debug_init)
+		if (clk->ops->debug_init(clk->hw, clk->dentry))
+			goto err_out;
+
 	ret = 0;
 	goto out;
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 939533d..5119174 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -32,6 +32,7 @@
 #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
 
 struct clk_hw;
+struct dentry;
 
 /**
  * struct clk_ops -  Callback operations for hardware clocks; these are to
@@ -127,6 +128,12 @@ struct clk_hw;
  *		separately via calls to .set_parent and .set_rate.
  *		Returns 0 on success, -EERROR otherwise.
  *
+ * @debug_init:	Set up type-specific debugfs entries for this clock.  This
+ *		is called once, after the debugfs directory entry for this
+ *		clock has been created.  The dentry pointer representing that
+ *		directory is provided as an argument.  Called with
+ *		prepare_lock held.  Returns 0 on success, -EERROR otherwise.
+ *
  *
  * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
  * implementations to split any work between atomic (enable) and sleepable
@@ -165,6 +172,7 @@ struct clk_ops {
 	unsigned long	(*recalc_accuracy)(struct clk_hw *hw,
 					   unsigned long parent_accuracy);
 	void		(*init)(struct clk_hw *hw);
+	int		(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
 };
 
 /**
-- 
1.7.9.5

