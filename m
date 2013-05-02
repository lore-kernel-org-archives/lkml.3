Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3EBG0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:26:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42001 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3EBG0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:26:03 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [Patch 1/3] clk: fix clk_mux_get_parent return's signed value
Date: Thu, 2 May 2013 11:55:27 +0530
Message-ID: <1367475929-32166-2-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367475929-32166-1-git-send-email-ambresh@ti.com>
References: <1367475929-32166-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

If for some reason, the value read from clksel field return
erroneous due to HW bug or improper configuration, then
clk_mux_get_parent should return appropriate error's.

Currently if the value read is greater than the number of
available parents clk_mux_get_parent return's signed error
which will result in NULL pointer dereferencing in the
calling functions.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/clk/clk-mux.c        |    2 +-
 drivers/clk/clk.c            |   12 +++++++++++-
 include/linux/clk-provider.h |    4 ++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 25b1734..be0857e 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -29,7 +29,7 @@
 
 #define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)
 
-static u8 clk_mux_get_parent(struct clk_hw *hw)
+static int clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct clk_mux *mux = to_clk_mux(hw);
 	int num_parents = __clk_get_num_parents(hw->clk);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 934cfd1..c187321 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1281,7 +1281,7 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
 static struct clk *__clk_init_parent(struct clk *clk)
 {
 	struct clk *ret = NULL;
-	u8 index;
+	int index;
 
 	/* handle the trivial cases */
 
@@ -1309,6 +1309,11 @@ static struct clk *__clk_init_parent(struct clk *clk)
 	 */
 
 	index = clk->ops->get_parent(clk->hw);
+	if (index < 0) {
+		pr_err("%s: clk(%s) invalid parent clk_sel index(%d)\n",
+				__func__, clk->name, index);
+		goto out;
+	}
 
 	if (!clk->parents)
 		clk->parents =
@@ -1632,6 +1637,11 @@ int __clk_init(struct device *dev, struct clk *clk)
 	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
 		if (orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
+			if (i < 0) {
+				pr_err("%s: orphan clk(%s) invalid parent\n",
+						__func__, orphan->name);
+				continue;
+			}
 			if (!strcmp(clk->name, orphan->parent_names[i]))
 				__clk_reparent(orphan, clk);
 			continue;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1186098..96337a1 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -80,7 +80,7 @@ struct clk_hw;
  * 		supported by the clock.
  *
  * @get_parent:	Queries the hardware to determine the parent of a clock.  The
- * 		return value is a u8 which specifies the index corresponding to
+ * 		return value which specifies the index corresponding to
  * 		the parent clock.  This index can be applied to either the
  * 		.parent_names or .parents arrays.  In short, this function
  * 		translates the parent value read from hardware into an array
@@ -127,7 +127,7 @@ struct clk_ops {
 	long		(*round_rate)(struct clk_hw *hw, unsigned long,
 					unsigned long *);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
-	u8		(*get_parent)(struct clk_hw *hw);
+	int		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,
 				    unsigned long);
 	void		(*init)(struct clk_hw *hw);
-- 
1.7.4.1

