Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3LZO0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:26:46 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38829 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3LZO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:26:43 -0500
Message-ID: <52BC3CA1.7000701@linaro.org>
Date: Thu, 26 Dec 2013 08:26:41 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: support hardware-specific debugfs entries
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new clk_ops->debug_init method to allow a clock hardware
driver to populate the clock's debugfs directory with entries
beyond those common for every clock.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/clk.c            |    4 ++++
 include/linux/clk-provider.h |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2cf2ea6..c82a1bc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -268,6 +268,10 @@ static int clk_debug_create_one(struct clk *clk,
struct dentry *pdentry)
 	if (!d)
 		goto err_out;

+	if (clk->ops->debug_init)
+		if (clk->ops->debug_init(clk->hw, clk->dentry))
+			goto err_out;
+
 	ret = 0;
 	goto out;

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7e59253..4812512 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -31,6 +31,7 @@
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate
change */

 struct clk_hw;
+struct dentry;

 /**
  * struct clk_ops -  Callback operations for hardware clocks; these are to
@@ -108,6 +109,12 @@ struct clk_hw;
  *		which is likely helpful for most .set_rate implementation.
  *		Returns 0 on success, -EERROR otherwise.
  *
+ * @debug_init:	Set up type-specific debugfs entries for this clock.  This
+ *		is called once, after the debugfs directory entry for this
+ *		clock has been created.  The dentry pointer representing that
+ *		directory is provided as an argument.  Called with
+ *		prepare_lock held.  Returns 0 on success, -EERROR otherwise.
+ *
  * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
  * implementations to split any work between atomic (enable) and sleepable
  * (prepare) contexts.  If enabling a clock requires code that might sleep,
@@ -140,6 +147,9 @@ struct clk_ops {
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,
 				    unsigned long);
 	void		(*init)(struct clk_hw *hw);
+#ifdef CONFIG_COMMON_CLK_DEBUG
+	int		(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
+#endif
 };

 /**
-- 
1.7.9.5

