Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3FQIkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:40:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35275 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab3FQIkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:40:21 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V2 1/3] clk: fix clk_mux_get_parent return's signed value
Date: Mon, 17 Jun 2013 14:09:42 +0530
Message-ID: <1371458384-23936-2-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371458384-23936-1-git-send-email-ambresh@ti.com>
References: <1371458384-23936-1-git-send-email-ambresh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

clk_mux_get_parent should return an error if the value read
from the register is erroneous.

Currently if the value read is greater than the number of
available parents clk_mux_get_parent return's signed error
which will result in NULL pointer dereferencing in the
calling functions.

Signed-off-by: Ambresh K <ambresh@ti.com>
---
 drivers/clk/clk-mux.c        |    2 +-
 drivers/clk/clk.c            |   12 +++++++++++-
 include/linux/clk-provider.h |    6 +++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 614444c..001b4df 100644
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
index edf3fe1..2842450 100644
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
+		pr_err("%s: clk(%s) invalid parent index(%d)\n",
+				__func__, clk->name, index);
+		goto out;
+	}
 
 	if (!clk->parents)
 		clk->parents =
@@ -1630,6 +1635,11 @@ int __clk_init(struct device *dev, struct clk *clk)
 	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
 		if (orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
+			if (i < 0) {
+				pr_err_once("%s: clk(%s) has invalid parent\n",
+						__func__, orphan->name);
+				continue;
+			}
 			if (!strcmp(clk->name, orphan->parent_names[i]))
 				__clk_reparent(orphan, clk);
 			continue;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1ec14a7..b01cbdb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -79,8 +79,8 @@ struct clk_hw;
  * @round_rate:	Given a target rate as input, returns the closest rate actually
  * 		supported by the clock.
  *
- * @get_parent:	Queries the hardware to determine the parent of a clock.  The
- * 		return value is a u8 which specifies the index corresponding to
+ * @get_parent:	Queries the hardware to determine the parent of a clock. The
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

