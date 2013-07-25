Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3GYAq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:46:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34900 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3GYAns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:43:48 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v1 02/14] clk: Add of_init_clk_data() to parse common clock bindings
Date: Wed, 24 Jul 2013 17:43:30 -0700
Message-Id: <1374713022-6049-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate DT parsing for the common bits of a clock binding in
one place to simplify clock drivers. This also has the added
benefit of standardizing how the clock names used by the common
clock framework are generated from the DT bindings. We always use
the first clock-output-names string if it exists, otherwise we
fall back to the node name.

To be slightly more efficient and make the caller's life easier,
we introduce a shallow copy flag so that the clock core knows to
just copy the pointers to the strings and not the string
contents. Otherwise the callers of this function would have to
free the strings allocated here which could be cumbersome.

Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 59 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/clk-provider.h |  7 ++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1ed9bdd..ea8e951b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1809,6 +1809,10 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 {
 	int i, ret;
 
+	hw->clk = clk;
+	if (hw->init->flags & CLK_SHALLOW_COPY)
+		return PTR_RET(__clk_register(dev, hw));
+
 	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
 		pr_err("%s: could not allocate clk->name\n", __func__);
@@ -1819,7 +1823,6 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
-	hw->clk = clk;
 
 	/* allocate local copy in case parent_names is __initdata */
 	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
@@ -2232,4 +2235,58 @@ void __init of_clk_init(const struct of_device_id *matches)
 		clk_init_cb(np);
 	}
 }
+
+/**
+ * of_init_clk_data() - Initialize a clk_init_data struct from a DT node
+ * @np: node to initialize struct from
+ * @init: struct to initialize
+ *
+ * Populates the clk_init_data struct by parsing the device node for
+ * properties matching the common clock binding. Returns 0 on success
+ * and a negative error code on failure.
+ */
+int of_init_clk_data(struct device_node *np, struct clk_init_data *init)
+{
+	struct of_phandle_args s;
+	const char **names = NULL, **p;
+	const char *name;
+	int i;
+
+	if (of_property_read_string(np, "clock-output-names", &name) < 0)
+		name = np->name;
+	init->name = kstrdup(name, GFP_KERNEL);
+	if (!init->name)
+		return -ENOMEM;
+
+	for (i = 0; of_parse_phandle_with_args(np, "clocks", "#clock-cells",
+				i, &s) == 0; i++) {
+		p = krealloc(names, sizeof(*names) * (i + 1), GFP_KERNEL);
+		if (!p)
+			goto err;
+		names = p;
+
+		if (of_property_read_string(s.np, "clock-output-names",
+					&name) < 0)
+			name = s.np->name;
+		names[i] = kstrdup(name, GFP_KERNEL);
+		if (!names[i])
+			goto err;
+		of_node_put(s.np);
+	}
+
+	init->parent_names = names;
+	init->num_parents = i;
+	init->flags = init->num_parents ? 0 : CLK_IS_ROOT;
+	init->flags |= CLK_SHALLOW_COPY;
+
+	return 0;
+err:
+	of_node_put(s.np);
+	while (--i >= 0)
+		kfree(names[i]);
+	kfree(names);
+	kfree(init->name);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(of_init_clk_data);
 #endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 9861cee..18d6362 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -28,6 +28,7 @@
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
+#define CLK_SHALLOW_COPY	BIT(8) /* don't copy the initdata strings */
 
 struct clk_hw;
 
@@ -472,6 +473,7 @@ struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
+int of_init_clk_data(struct device_node *np, struct clk_init_data *init);
 
 #else /* !CONFIG_OF */
 
@@ -501,6 +503,11 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
 }
 #define of_clk_init(matches) \
 	{ while (0); }
+static inline int
+of_init_clk_data(struct device_node *np, struct clk_init_data *init)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

