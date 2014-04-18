Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaDRXaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:30:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56797 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaDRX3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:29:47 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiada Wang <jiada_wang@mentor.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] clk: Fix double free due to devm_clk_register()
Date: Fri, 18 Apr 2014 16:29:42 -0700
Message-Id: <1397863783-10728-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1397863783-10728-1-git-send-email-sboyd@codeaurora.org>
References: <1397863783-10728-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that clk_unregister() frees the struct clk we're
unregistering we'll free memory twice: first we'll call kfree()
in __clk_release() with an address kmalloc doesn't know about and
second we'll call kfree() in the devres layer. Remove the
allocation of struct clk in devm_clk_register() and let
clk_release() handle it. This fixes slab errors like:

=============================================================================
BUG kmalloc-128 (Not tainted): Invalid object pointer 0xed08e8d0
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Slab 0xeec503f8 objects=25 used=15 fp=0xed08ea00 flags=0x4081
CPU: 2 PID: 73 Comm: rmmod Tainted: G    B         3.14.0-11032-g526e9c764381 #34
[<c0014be0>] (unwind_backtrace) from [<c0012240>] (show_stack+0x10/0x14)
[<c0012240>] (show_stack) from [<c04b74dc>] (dump_stack+0x70/0xbc)
[<c04b74dc>] (dump_stack) from [<c00f6778>] (slab_err+0x74/0x84)
[<c00f6778>] (slab_err) from [<c04b6278>] (free_debug_processing+0x2cc/0x31c)
[<c04b6278>] (free_debug_processing) from [<c04b6300>] (__slab_free+0x38/0x41c)
[<c04b6300>] (__slab_free) from [<c03931bc>] (clk_unregister+0xd4/0x140)
[<c03931bc>] (clk_unregister) from [<c02fb774>] (release_nodes+0x164/0x1d8)
[<c02fb774>] (release_nodes) from [<c02f8698>] (__device_release_driver+0x60/0xb0)
[<c02f8698>] (__device_release_driver) from [<c02f9080>] (driver_detach+0xb4/0xb8)
[<c02f9080>] (driver_detach) from [<c02f8480>] (bus_remove_driver+0x5c/0xc4)
[<c02f8480>] (bus_remove_driver) from [<c008c9b8>] (SyS_delete_module+0x148/0x1d8)
[<c008c9b8>] (SyS_delete_module) from [<c000ef80>] (ret_fast_syscall+0x0/0x48)
FIX kmalloc-128: Object at 0xed08e8d0 not freed

Fixes: fcb0ee6a3d33 (clk: Implement clk_unregister)
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 71 +++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373f53c1..f71093bf83ab 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1984,9 +1984,28 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
-static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
+/**
+ * clk_register - allocate a new clock, register it and return an opaque cookie
+ * @dev: device that is registering this clock
+ * @hw: link to hardware-specific clock data
+ *
+ * clk_register is the primary interface for populating the clock tree with new
+ * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * cannot be dereferenced by driver code but may be used in conjuction with the
+ * rest of the clock API.  In the event of an error clk_register will return an
+ * error code; drivers must test for an error code after calling clk_register.
+ */
+struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int i, ret;
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk) {
+		pr_err("%s: could not allocate clk\n", __func__);
+		ret = -ENOMEM;
+		goto fail_out;
+	}
 
 	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
@@ -2026,7 +2045,7 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 
 	ret = __clk_init(dev, clk);
 	if (!ret)
-		return 0;
+		return clk;
 
 fail_parent_names_copy:
 	while (--i >= 0)
@@ -2035,36 +2054,6 @@ fail_parent_names_copy:
 fail_parent_names:
 	kfree(clk->name);
 fail_name:
-	return ret;
-}
-
-/**
- * clk_register - allocate a new clock, register it and return an opaque cookie
- * @dev: device that is registering this clock
- * @hw: link to hardware-specific clock data
- *
- * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
- * cannot be dereferenced by driver code but may be used in conjuction with the
- * rest of the clock API.  In the event of an error clk_register will return an
- * error code; drivers must test for an error code after calling clk_register.
- */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw)
-{
-	int ret;
-	struct clk *clk;
-
-	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
-	if (!clk) {
-		pr_err("%s: could not allocate clk\n", __func__);
-		ret = -ENOMEM;
-		goto fail_out;
-	}
-
-	ret = _clk_register(dev, hw, clk);
-	if (!ret)
-		return clk;
-
 	kfree(clk);
 fail_out:
 	return ERR_PTR(ret);
@@ -2173,7 +2162,7 @@ EXPORT_SYMBOL_GPL(clk_unregister);
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_unregister(res);
+	clk_unregister(*(struct clk **)res);
 }
 
 /**
@@ -2188,18 +2177,18 @@ static void devm_clk_release(struct device *dev, void *res)
 struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw)
 {
 	struct clk *clk;
-	int ret;
+	struct clk **clkp;
 
-	clk = devres_alloc(devm_clk_release, sizeof(*clk), GFP_KERNEL);
-	if (!clk)
+	clkp = devres_alloc(devm_clk_release, sizeof(*clkp), GFP_KERNEL);
+	if (!clkp)
 		return ERR_PTR(-ENOMEM);
 
-	ret = _clk_register(dev, hw, clk);
-	if (!ret) {
-		devres_add(dev, clk);
+	clk = clk_register(dev, hw);
+	if (!IS_ERR(clk)) {
+		*clkp = clk;
+		devres_add(dev, clkp);
 	} else {
-		devres_free(clk);
-		clk = ERR_PTR(ret);
+		devres_free(clkp);
 	}
 
 	return clk;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

