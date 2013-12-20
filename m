Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3LTWJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:09:32 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54968 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3LTWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:09:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 2/2] clk: implement generic DT preset clock frequency
Date: Fri, 20 Dec 2013 22:08:47 +0000
Message-Id: <1387577327-5007-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387577327-5007-1-git-send-email-james.hogan@imgtec.com>
References: <1387577327-5007-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the clock-N-frequency clock consumer property to preset a
clock to a particular frequency when it is requested by a driver.

This adds a new of_clk_setup_preset() which is called from the end of
of_clk_get(). It simply looks in the consumer node for a property named
"clock-<index>-frequency" and attempts to set the clock frequency if
found.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/clk/clk.c    | 34 ++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |  3 +++
 include/linux/clk.h  |  5 +++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2cf2ea6..3f518a2 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2252,4 +2252,38 @@ void __init of_clk_init(const struct of_device_id *matches)
 		clk_init_cb(np);
 	}
 }
+
+/**
+ * of_clk_setup_preset() - Set up a clock from device tree when it is requested
+ * @np:		pointer to clock consumer node
+ * @index:	consumer index of clock that has been requested
+ * @clk:	struct clk *
+ *
+ * This function is called when a clock is requested by a driver. It scans the
+ * clock consumer node for properties which indicate defaults for how the clock
+ * should be set up.
+ *
+ * Properties looked for are:
+ * - clock-N-frequency
+ */
+void of_clk_setup_preset(struct device_node *np, int index, struct clk *clk)
+{
+	u32 rate;
+	int ret;
+	char prop_name[24];
+
+	/* look for a clock-N-frequency property */
+	snprintf(prop_name, sizeof(prop_name),
+		 "clock-%d-frequency", index);
+	if (!of_property_read_u32(np, prop_name, &rate)) {
+		/* try to set the frequency to that specified in DT */
+		ret = clk_set_rate(clk, rate);
+		if (ret)
+			pr_err("Failed to preset clock %d (%s) of %s to %u Hz\n",
+				 index, clk->name, np->full_name, rate);
+		else
+			pr_debug("Preset clock %d (%s) of %s to %u Hz\n",
+				 index, clk->name, np->full_name, rate);
+	}
+}
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..edcd67f 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -41,6 +41,9 @@ struct clk *of_clk_get(struct device_node *np, int index)
 
 	clk = of_clk_get_from_provider(&clkspec);
 	of_node_put(clkspec.np);
+
+	if (!IS_ERR(clk))
+		of_clk_setup_preset(np, index, clk);
 	return clk;
 }
 EXPORT_SYMBOL(of_clk_get);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d045..3e112ea 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -368,6 +368,7 @@ struct of_phandle_args;
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+void of_clk_setup_preset(struct device_node *np, int index, struct clk *clk);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
@@ -378,6 +379,10 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+static inline void of_clk_setup_preset(struct device_node *np, int index,
+				       struct clk *clk)
+{
+}
 #endif
 
 #endif
-- 
1.8.3.2

