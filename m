Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3FMBtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:49:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41145 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab3FMBtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:49:14 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [RFC/PATCH 03/13] clk: Add of_clk_match() for device drivers
Date: Wed, 12 Jun 2013 18:48:59 -0700
Message-Id: <1371088149-22562-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
References: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In similar fashion as of_regulator_match() add an of_clk_match()
function that finds an initializes clock init_data structs from
devicetree. Drivers should use this API to find clocks that their
device is providing and then iterate over their match table
registering the clocks with the init data parsed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h | 10 +++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 282b10e..f40ce9b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2282,4 +2282,68 @@ err:
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(of_init_clk_data);
+
+/**
+ * of_clk_match() - Scan and match clock providers from the DT node of a device
+ * @dev: device initializing clock providers
+ * @matches: match table of clocks
+ * @num_matches: number of entries in @matches
+ *
+ * This function uses a match table specified by the clock driver to parse
+ * clock init data from the device tree. @dev is expected to be a device with
+ * a 'clocks' child node containing a set of child nodes, each providing the
+ * init data for one clock. The data parsed from a child node will be matched
+ * to a clock based on the child node's name. Note that the match table is
+ * modified in place.
+ *
+ * Returns the number of matches found or a negative error code on failure.
+ */
+int of_clk_match(struct device *dev, struct of_clk_match *matches,
+		 int num_matches)
+{
+	int count = 0;
+	int err, i;
+	struct device_node *np, *clocks;
+	struct clk_init_data *init;
+
+	clocks = of_find_node_by_name(dev->of_node, "clocks");
+	if (!clocks)
+		return -EINVAL;
+
+	for (i = 0; i < num_matches; i++) {
+		struct of_clk_match *match = &matches[i];
+		match->init_data = NULL;
+		match->of_node = NULL;
+	}
+
+	for_each_available_child_of_node(clocks, np) {
+		for (i = 0; i < num_matches; i++) {
+			struct of_clk_match *match = &matches[i];
+			if (match->of_node)
+				continue;
+
+			if (strcmp(match->name, np->name))
+				continue;
+
+			init = devm_kzalloc(dev, sizeof(*init), GFP_KERNEL);
+			if (!init)
+				return -ENOMEM;
+
+			err = of_init_clk_data(np, init);
+			if (err) {
+				dev_err(dev,
+					"failed to parse DT for clock %s\n",
+					np->name);
+				return err;
+			}
+			match->of_node = np;
+			match->init_data = init;
+			count++;
+			break;
+		}
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(of_clk_match);
 #endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index bdcc655..3668a76 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -454,6 +454,16 @@ void of_clk_init(const struct of_device_id *matches);
 
 int of_init_clk_data(struct device_node *np, struct clk_init_data *init);
 
+struct of_clk_match {
+	const char *name;
+	void *driver_data;
+	struct clk_init_data *init_data;
+	struct device_node *of_node;
+};
+
+int of_clk_match(struct device *dev, struct of_clk_match *matches,
+		 int num_matches);
+
 #define CLK_OF_DECLARE(name, compat, fn)			\
 	static const struct of_device_id __clk_of_table_##name	\
 		__used __section(__clk_of_table)		\
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

