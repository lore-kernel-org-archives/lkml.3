Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3FMMV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31965 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3FMMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:28 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 01/10] metag: init common clk and use "core" clk
Date: Thu, 13 Jun 2013 13:19:32 +0100
Message-ID: <1371125981-5184-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the common clock framework is enabled, call of_clk_init(NULL) in
time_init() to register device tree clocks with the clock framework.

After this time_init() calls a new function init_metag_clocks(), which
looks for a clock named "core" in the node compatible with "img,meta"
(usually the root node). If found the get_core_freq machine callback is
overridden to obtain the core clock frequency using that clock.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 Documentation/devicetree/bindings/metag/meta.txt | 30 +++++++++++++
 arch/metag/include/asm/clock.h                   |  8 ++++
 arch/metag/kernel/clock.c                        | 57 +++++++++++++++++++++++-
 arch/metag/kernel/time.c                         | 14 +++++-
 4 files changed, 106 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta.txt

diff --git a/Documentation/devicetree/bindings/metag/meta.txt b/Documentation/devicetree/bindings/metag/meta.txt
new file mode 100644
index 0000000..f4457f5
--- /dev/null
+++ b/Documentation/devicetree/bindings/metag/meta.txt
@@ -0,0 +1,30 @@
+* Meta Processor Binding
+
+This binding specifies what properties must be available in the device tree
+representation of a Meta Processor Core, which is the root node in the tree.
+
+Required properties:
+
+    - compatible: Specifies the compatibility list for the Meta processor.
+      The type shall be <string> and the value shall include "img,meta".
+
+Optional properties:
+
+    - clocks: Clock consumer specifiers as described in
+      Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+    - clock-names: Clock consumer names as described in
+      Documentation/devicetree/bindings/clock/clock-bindings.txt.
+
+Clocks are identified by name. Valid clocks are:
+
+    - "core": The Meta core clock from which the Meta timers are derived.
+
+* Examples
+
+/ {
+	compatible = "toumaz,tz1090", "img,meta";
+
+	clocks = <&meta_core_clk>;
+	clock-names = "core";
+};
diff --git a/arch/metag/include/asm/clock.h b/arch/metag/include/asm/clock.h
index 3e2915a..ded4ab2 100644
--- a/arch/metag/include/asm/clock.h
+++ b/arch/metag/include/asm/clock.h
@@ -19,6 +19,8 @@
  *			core frequency will be determined like this:
  *			Meta 1: based on loops_per_jiffy.
  *			Meta 2: (EXPAND_TIMER_DIV + 1) MHz.
+ *			If a "core" clock is provided by the device tree, it
+ *			will override this function.
  */
 struct meta_clock_desc {
 	unsigned long		(*get_core_freq)(void);
@@ -27,6 +29,12 @@ struct meta_clock_desc {
 extern struct meta_clock_desc _meta_clock;
 
 /*
+ * Perform platform clock initialisation, reading clocks from device tree etc.
+ * Only accessible during boot.
+ */
+void init_metag_clocks(void);
+
+/*
  * Set up the default clock, ensuring all callbacks are valid - only accessible
  * during boot.
  */
diff --git a/arch/metag/kernel/clock.c b/arch/metag/kernel/clock.c
index defc840..8bfd6a5 100644
--- a/arch/metag/kernel/clock.c
+++ b/arch/metag/kernel/clock.c
@@ -8,8 +8,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/param.h>
 #include <asm/clock.h>
@@ -34,8 +36,61 @@ static unsigned long get_core_freq_default(void)
 #endif
 }
 
+static struct clk *clk_core;
+
+/* Clk based get_core_freq callback. */
+static unsigned long get_core_freq_clk(void)
+{
+	return clk_get_rate(clk_core);
+}
+
+/**
+ * init_metag_core_clock() - Set up core clock from devicetree.
+ *
+ * Checks to see if a "core" clock is provided in the device tree, and overrides
+ * the get_core_freq callback to use it.
+ */
+static void __init init_metag_core_clock(void)
+{
+	/*
+	 * See if a core clock is provided by the devicetree (and
+	 * registered by the init callback above).
+	 */
+	struct device_node *node;
+	node = of_find_compatible_node(NULL, NULL, "img,meta");
+	if (!node) {
+		pr_warn("%s: no compatible img,meta DT node found\n",
+			__func__);
+		return;
+	}
+
+	clk_core = of_clk_get_by_name(node, "core");
+	if (IS_ERR(clk_core)) {
+		pr_warn("%s: no core clock found in DT\n",
+			__func__);
+		return;
+	}
+
+	/*
+	 * Override the core frequency callback to use
+	 * this clk.
+	 */
+	_meta_clock.get_core_freq = get_core_freq_clk;
+}
+
+/**
+ * init_metag_clocks() - Set up clocks from devicetree.
+ *
+ * Set up important clocks from device tree. In particular any needed for clock
+ * sources.
+ */
+void __init init_metag_clocks(void)
+{
+	init_metag_core_clock();
+}
+
 /**
- * setup_meta_clocks() - Set up the Meta clock.
+ * setup_meta_clocks() - Early set up of the Meta clock.
  * @desc:	Clock descriptor usually provided by machine description
  *
  * Ensures all callbacks are valid.
diff --git a/arch/metag/kernel/time.c b/arch/metag/kernel/time.c
index 17dc107..f1c8c53 100644
--- a/arch/metag/kernel/time.c
+++ b/arch/metag/kernel/time.c
@@ -5,11 +5,21 @@
  *
  */
 
-#include <linux/init.h>
-
 #include <clocksource/metag_generic.h>
+#include <linux/clk-provider.h>
+#include <linux/init.h>
+#include <asm/clock.h>
 
 void __init time_init(void)
 {
+#ifdef CONFIG_COMMON_CLK
+	/* Init clocks from device tree */
+	of_clk_init(NULL);
+#endif
+
+	/* Init meta clocks, particularly the core clock */
+	init_metag_clocks();
+
+	/* Set up the timer clock sources */
 	metag_generic_timer_init();
 }
-- 
1.8.1.2


