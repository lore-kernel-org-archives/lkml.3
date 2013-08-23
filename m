Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3HWPFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:05:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3HWPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:05:15 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-c4-52177a2a8b1f
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 4/5] clk: Assign module owner of a clock being registered
Date: Fri, 23 Aug 2013 17:03:46 +0200
Message-id: <1377270227-1030-5-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jAV2tKvEgg/Y1GhZTHz5hs3i/cR6T
	Rc+fSouzTW/YLTonLmG32PT4GqvF5V1z2CwmTJ3EbjHnzxRmi9uXeS0OPFnOZvF0wkU2i9uN
	K9gsLu1RsTj8pp3V4v1PR4un65YwW6yf8ZrFYmHDF3aLmxN+MDuIeLQ097B5rJzu7XH5+xtm
	j52z7rJ7fPgY5zG7Yyarx/zpj5g9Nq3qZPO4c20Pm8fRlWuZPDYvqffY/bWJ0aNvyypGj8+b
	5AL4orhsUlJzMstSi/TtErgy/mxfwFywXqBiwuNulgbGI7xdjBwcEgImEntuRHcxcgKZYhIX
	7q1nA7GFBBYxSmxfYNvFyAVkdzBJXO9+xgySYBMwlOg92scIYosIaEhM6XrMDlLELNDLIjFl
	8k0WkISwgI/EhLY7TCA2i4CqxMwvB1lBbF4BV4mTTxcxQyxWkJgzyQYkzCngJtG85iwTSFgI
	qOTvFs0JjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTHxzPpHYyrGiwOMQpwMCrx
	8E5wFgsSYk0sK67MPcQowcGsJMK7M088SIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB
	9MSS1OzU1ILUIpgsEwenVANjnjeTcXzTsm0t36WZ7uyw6Ph2pE808ef7O6FsvzSfrDfXeRtw
	uOFTm/fTw6blBSosZ71dsr7+tL9RcsNt8qfc5fJiN2YvZJTJ+D8/hNF7GRdjv+3L3olHZM4u
	Xr+t7979mcsXxq453vOxypXd4H9x3wqxhoY25Qg+0ehNF1dt71Dwyyl1FPFWYinOSDTUYi4q
	TgQAdOuzxosCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign module owner of a driver of a device passed to _clk_register()
and __clk_register() functions so the module_{get,put} calls in
__clk_get(), __clk_put() can have required effect.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Initially I had an 'owner' field added to struct clk_init_data so it can
be set explicitly in clock providers.  But this required modifications
of all users of (devm_)clk_register() as struct clk_init_data instance
was in most cases an unitialized stack variable.  This would also require
adding yet another argument to various clk_register_* functions
registering the standard clocks.  So I went for assigning clk->owner from
dev->driver->owner.  The disadvantages are that dereferencing dev->driver
may be potentially unsafe when not holding struct device::mutex.  And
there might be cases where clk->owner will need to be NULL.  One option
is to set dev argument of clk_register_*() to NULL for that, but it
predates devm_*.

Presumably a requirement could be added that callers of clk_register*()
must ensure dev->driver won't change during a call to these functions ?
---
 drivers/clk/clk.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c173f30..272d68d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1692,6 +1692,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	clk->flags = hw->init->flags;
 	clk->parent_names = hw->init->parent_names;
 	clk->num_parents = hw->init->num_parents;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
+	else
+		clk->owner = NULL;

 	ret = __clk_init(dev, clk);
 	if (ret)
@@ -1712,6 +1716,8 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 		goto fail_name;
 	}
 	clk->ops = hw->init->ops;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
--
1.7.9.5

