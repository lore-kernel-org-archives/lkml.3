Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935832AbaBDXAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:00:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60174 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933109AbaBDXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:00:06 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: respect the clock dependencies in of_clk_init
Date: Tue,  4 Feb 2014 23:59:26 +0100
Message-Id: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the clock providers were initialized in the order found in
the device tree. This led to have the dependencies between the clocks
not respected: children clocks could be initialized before their
parent clocks.

Instead of forcing each platform to manage its own initialization order,
this patch adds this work inside the framework itself.

Using the data of the device tree the of_clk_init function now delayed
the initialization of a clock provider if its parent provider was not
ready yet.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
Mike,

this patch could solve the issues we get on severals mvebu platform
since 3.14-rc1. This is an alternate solution of the patch set sent by
Sebastian. However as it modifies the clock framework itself, it is
more sensible.

I find this solution more elegant than changing the order of the
initialization of the clock at the platform level. However as it
should be tested on more platforms that only the mvebu ones, it would
take some time, and I don't want to still have "broken" platform
during more release candidate. So at the end this patch should be part
of the 3.15 kernel.

Thanks,

Gregory

 drivers/clk/clk.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5517944495d8..beb0f8b0c2a0 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2526,24 +2526,112 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
 }
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 
+struct clock_provider {
+	of_clk_init_cb_t clk_init_cb;
+	struct device_node *np;
+	struct list_head node;
+};
+
+static LIST_HEAD(clk_provider_list);
+
+/*
+ * This function looks for a parent clock. If there is one, then it
+ * checks that the provider for this parent clock was initialized, in
+ * this case the parent clock will be ready.
+ */
+static int parent_ready(struct device_node *np)
+{
+	struct of_phandle_args clkspec;
+	struct of_clk_provider *provider;
+
+	/*
+	 * If there is no clock parent, no need to wait for them, then
+	 * we can consider their absence as being ready
+	 */
+	if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", 0,
+					&clkspec))
+		return 1;
+
+	/* Check if we have such a provider in our array */
+	list_for_each_entry(provider, &of_clk_providers, link) {
+		if (provider->node == clkspec.np)
+			return 1;
+	}
+
+	return 0;
+}
+
 /**
  * of_clk_init() - Scan and init clock providers from the DT
  * @matches: array of compatible values and init functions for providers.
  *
- * This function scans the device tree for matching clock providers and
- * calls their initialization functions
+ * This function scans the device tree for matching clock providers
+ * and calls their initialization functions. It also do it by trying
+ * to follow the dependencies.
  */
 void __init of_clk_init(const struct of_device_id *matches)
 {
 	const struct of_device_id *match;
 	struct device_node *np;
+	struct clock_provider *clk_provider, *next;
+	bool is_init_done;
 
 	if (!matches)
 		matches = &__clk_of_table;
 
 	for_each_matching_node_and_match(np, matches, &match) {
 		of_clk_init_cb_t clk_init_cb = match->data;
-		clk_init_cb(np);
+
+
+		if (parent_ready(np)) {
+			/*
+			 * The parent clock is ready or there is no
+			 * clock parent at all, in this case the
+			 * provider can be initialize immediately.
+			 */
+			clk_init_cb(np);
+		} else {
+			/*
+			 * The parent clock is not ready, this
+			 * provider is moved to a list to be
+			 * initialized later
+			 */
+			struct clock_provider *parent = kzalloc(sizeof(struct clock_provider),
+							GFP_KERNEL);
+
+			parent->clk_init_cb = match->data;
+			parent->np = np;
+			list_add(&parent->node, &clk_provider_list);
+		}
+	}
+
+	while (!list_empty(&clk_provider_list)) {
+		is_init_done = false;
+		list_for_each_entry_safe(clk_provider, next,
+					&clk_provider_list, node) {
+			if (parent_ready(clk_provider->np)) {
+				clk_provider->clk_init_cb(clk_provider->np);
+				list_del(&clk_provider->node);
+				kfree(clk_provider);
+				is_init_done = true;
+			}
+		}
+
+		if (!is_init_done) {
+			/*
+			 * We didn't managed to initialize any of the
+			 * remaining providers during the last loop,
+			 * so now we initialize all the remaining ones
+			 * unconditionally in case the clock parent
+			 * was not mandatory
+			 */
+			list_for_each_entry_safe(clk_provider, next,
+						&clk_provider_list, node) {
+				clk_provider->clk_init_cb(clk_provider->np);
+				list_del(&clk_provider->node);
+				kfree(clk_provider);
+			}
+		}
 	}
 }
 #endif
-- 
1.8.1.2

