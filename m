Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaDVNLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:11:53 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:36324 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaDVNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:11:48 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mike Turquette <mturquette@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] clk: Improve clk_ops documentation
Date: Tue, 22 Apr 2014 15:11:42 +0200
Message-Id: <1398172302-24379-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398172302-24379-1-git-send-email-geert+renesas@glider.be>
References: <1398172302-24379-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

General:
  - Add parameter names to .round_rate() and .set_rate().

Documentation/clk.txt:
  - Add missing parameter for .set_rate(),
  - Add missing .debug_init().

include/linux/clk-provider.h:
  - Add parent rate documentation for .round_rate(),
  - Reorder documentation to match implementation order,
  - Add missing documentation for .init().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/clk.txt        |   16 ++++++++++-----
 include/linux/clk-provider.h |   44 ++++++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index c9c399af7c08..1fee72f4d331 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -68,21 +68,27 @@ the operations defined in clk.h:
 		int		(*is_enabled)(struct clk_hw *hw);
 		unsigned long	(*recalc_rate)(struct clk_hw *hw,
 						unsigned long parent_rate);
-		long		(*round_rate)(struct clk_hw *hw, unsigned long,
-						unsigned long *);
+		long		(*round_rate)(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long *parent_rate);
 		long		(*determine_rate)(struct clk_hw *hw,
 						unsigned long rate,
 						unsigned long *best_parent_rate,
 						struct clk **best_parent_clk);
 		int		(*set_parent)(struct clk_hw *hw, u8 index);
 		u8		(*get_parent)(struct clk_hw *hw);
-		int		(*set_rate)(struct clk_hw *hw, unsigned long);
+		int		(*set_rate)(struct clk_hw *hw,
+					    unsigned long rate,
+					    unsigned long parent_rate);
 		int		(*set_rate_and_parent)(struct clk_hw *hw,
 					    unsigned long rate,
-					    unsigned long parent_rate, u8 index);
+					    unsigned long parent_rate,
+					    u8 index);
 		unsigned long	(*recalc_accuracy)(struct clk_hw *hw,
-						   unsigned long parent_accuracy);
+						unsigned long parent_accuracy);
 		void		(*init)(struct clk_hw *hw);
+		int		(*debug_init)(struct clk_hw *hw,
+					      struct dentry *dentry);
 	};
 
 	Part 3 - hardware clk implementations
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index ec90b8a7806f..24c8ba4fa6ae 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -81,12 +81,20 @@ struct dentry;
  *		this op is not set then clock rate will be initialized to 0.
  *
  * @round_rate:	Given a target rate as input, returns the closest rate actually
- *		supported by the clock.
+ *		supported by the clock. The parent rate is an input/output
+ *		parameter.
  *
  * @determine_rate: Given a target rate as input, returns the closest rate
  *		actually supported by the clock, and optionally the parent clock
  *		that should be used to provide the clock rate.
  *
+ * @set_parent:	Change the input source of this clock; for clocks with multiple
+ *		possible parents specify a new parent by passing in the index
+ *		as a u8 corresponding to the parent in either the .parent_names
+ *		or .parents arrays.  This function in affect translates an
+ *		array index into the value programmed into the hardware.
+ *		Returns 0 on success, -EERROR otherwise.
+ *
  * @get_parent:	Queries the hardware to determine the parent of a clock.  The
  *		return value is a u8 which specifies the index corresponding to
  *		the parent clock.  This index can be applied to either the
@@ -97,26 +105,12 @@ struct dentry;
  *		multiple parents.  It is optional (and unnecessary) for clocks
  *		with 0 or 1 parents.
  *
- * @set_parent:	Change the input source of this clock; for clocks with multiple
- *		possible parents specify a new parent by passing in the index
- *		as a u8 corresponding to the parent in either the .parent_names
- *		or .parents arrays.  This function in affect translates an
- *		array index into the value programmed into the hardware.
- *		Returns 0 on success, -EERROR otherwise.
- *
  * @set_rate:	Change the rate of this clock. The requested rate is specified
  *		by the second argument, which should typically be the return
  *		of .round_rate call.  The third argument gives the parent rate
  *		which is likely helpful for most .set_rate implementation.
  *		Returns 0 on success, -EERROR otherwise.
  *
- * @recalc_accuracy: Recalculate the accuracy of this clock. The clock accuracy
- *		is expressed in ppb (parts per billion). The parent accuracy is
- *		an input parameter.
- *		Returns the calculated accuracy.  Optional - if	this op is not
- *		set then clock accuracy will be initialized to parent accuracy
- *		or 0 (perfect clock) if clock has no parent.
- *
  * @set_rate_and_parent: Change the rate and the parent of this clock. The
  *		requested rate is specified by the second argument, which
  *		should typically be the return of .round_rate call.  The
@@ -128,6 +122,18 @@ struct dentry;
  *		separately via calls to .set_parent and .set_rate.
  *		Returns 0 on success, -EERROR otherwise.
  *
+ * @recalc_accuracy: Recalculate the accuracy of this clock. The clock accuracy
+ *		is expressed in ppb (parts per billion). The parent accuracy is
+ *		an input parameter.
+ *		Returns the calculated accuracy.  Optional - if	this op is not
+ *		set then clock accuracy will be initialized to parent accuracy
+ *		or 0 (perfect clock) if clock has no parent.
+ *
+ * @init:	Perform platform-specific initialization magic.
+ *		This is not not used by any of the basic clock types.
+ *		Please consider other ways of solving initialization problems
+ *		before using this callback, as its use is discouraged.
+ *
  * @debug_init:	Set up type-specific debugfs entries for this clock.  This
  *		is called once, after the debugfs directory entry for this
  *		clock has been created.  The dentry pointer representing that
@@ -157,15 +163,15 @@ struct clk_ops {
 	void		(*disable_unused)(struct clk_hw *hw);
 	unsigned long	(*recalc_rate)(struct clk_hw *hw,
 					unsigned long parent_rate);
-	long		(*round_rate)(struct clk_hw *hw, unsigned long,
-					unsigned long *);
+	long		(*round_rate)(struct clk_hw *hw, unsigned long rate,
+					unsigned long *parent_rate);
 	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
 					struct clk **best_parent_clk);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
-	int		(*set_rate)(struct clk_hw *hw, unsigned long,
-				    unsigned long);
+	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
+				    unsigned long parent_rate);
 	int		(*set_rate_and_parent)(struct clk_hw *hw,
 				    unsigned long rate,
 				    unsigned long parent_rate, u8 index);
-- 
1.7.9.5

