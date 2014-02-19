Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaBSOPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:15:10 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:51748 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaBSOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:15:06 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v4 4/4] of: Add self test for of_match_node()
Date: Wed, 19 Feb 2014 14:14:50 +0000
Message-Id: <1392819290-1044-5-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a selftest function for the of_match_node function. of_match_node
is supposed to handle precedence for the compatible property as well as
the name and device_type values. This patch adds some test case data and
a function that makes sure each test node matches against the correct
entry of an of_device_id table.

This code was written to verify the new of_match_node() implementation
that is an earlier part of this series.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Kevin Hao <haokexin@gmail.com>
---
 drivers/of/selftest.c                     | 67 +++++++++++++++++++++++++++++++
 drivers/of/testcase-data/testcases.dtsi   |  1 +
 drivers/of/testcase-data/tests-match.dtsi | 19 +++++++++
 3 files changed, 87 insertions(+)
 create mode 100644 drivers/of/testcase-data/tests-match.dtsi

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index e21012bde639..6643d1920985 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -300,6 +300,72 @@ static void __init of_selftest_parse_interrupts_extended(void)
 	of_node_put(np);
 }
 
+static struct of_device_id match_node_table[] = {
+	{ .data = "A", .name = "name0", }, /* Name alone is lowest priority */
+	{ .data = "B", .type = "type1", }, /* followed by type alone */
+
+	{ .data = "Ca", .name = "name2", .type = "type1", }, /* followed by both together */
+	{ .data = "Cb", .name = "name2", }, /* Only match when type doesn't match */
+	{ .data = "Cc", .name = "name2", .type = "type2", },
+
+	{ .data = "E", .compatible = "compat3" },
+	{ .data = "G", .compatible = "compat2", },
+	{ .data = "H", .compatible = "compat2", .name = "name5", },
+	{ .data = "I", .compatible = "compat2", .type = "type1", },
+	{ .data = "J", .compatible = "compat2", .type = "type1", .name = "name8", },
+	{ .data = "K", .compatible = "compat2", .name = "name9", },
+	{}
+};
+
+static struct {
+	const char *path;
+	const char *data;
+} match_node_tests[] = {
+	{ .path = "/testcase-data/match-node/name0", .data = "A", },
+	{ .path = "/testcase-data/match-node/name1", .data = "B", },
+	{ .path = "/testcase-data/match-node/a/name2", .data = "Ca", },
+	{ .path = "/testcase-data/match-node/b/name2", .data = "Cb", },
+	{ .path = "/testcase-data/match-node/c/name2", .data = "Cc", },
+	{ .path = "/testcase-data/match-node/name3", .data = "E", },
+	{ .path = "/testcase-data/match-node/name4", .data = "G", },
+	{ .path = "/testcase-data/match-node/name5", .data = "H", },
+	{ .path = "/testcase-data/match-node/name6", .data = "G", },
+	{ .path = "/testcase-data/match-node/name7", .data = "I", },
+	{ .path = "/testcase-data/match-node/name8", .data = "J", },
+	{ .path = "/testcase-data/match-node/name9", .data = "K", },
+};
+
+static void __init of_selftest_match_node(void)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(match_node_tests); i++) {
+		np = of_find_node_by_path(match_node_tests[i].path);
+		if (!np) {
+			selftest(0, "missing testcase node %s\n",
+				match_node_tests[i].path);
+			continue;
+		}
+
+		match = of_match_node(match_node_table, np);
+		if (!match) {
+			selftest(0, "%s didn't match anything\n",
+				match_node_tests[i].path);
+			continue;
+		}
+
+		if (strcmp(match->data, match_node_tests[i].data) != 0) {
+			selftest(0, "%s got wrong match. expected %s, got %s\n",
+				match_node_tests[i].path, match_node_tests[i].data,
+				(const char *)match->data);
+			continue;
+		}
+		selftest(1, "passed");
+	}
+}
+
 static int __init of_selftest(void)
 {
 	struct device_node *np;
@@ -316,6 +382,7 @@ static int __init of_selftest(void)
 	of_selftest_property_match_string();
 	of_selftest_parse_interrupts();
 	of_selftest_parse_interrupts_extended();
+	of_selftest_match_node();
 	pr_info("end of selftest - %i passed, %i failed\n",
 		selftest_results.passed, selftest_results.failed);
 	return 0;
diff --git a/drivers/of/testcase-data/testcases.dtsi b/drivers/of/testcase-data/testcases.dtsi
index 3cc2f55534ac..3a5b75a8e4d7 100644
--- a/drivers/of/testcase-data/testcases.dtsi
+++ b/drivers/of/testcase-data/testcases.dtsi
@@ -1,2 +1,3 @@
 #include "tests-phandle.dtsi"
 #include "tests-interrupts.dtsi"
+#include "tests-match.dtsi"
diff --git a/drivers/of/testcase-data/tests-match.dtsi b/drivers/of/testcase-data/tests-match.dtsi
new file mode 100644
index 000000000000..c9e541129534
--- /dev/null
+++ b/drivers/of/testcase-data/tests-match.dtsi
@@ -0,0 +1,19 @@
+
+/ {
+	testcase-data {
+		match-node {
+			name0 { };
+			name1 { device_type = "type1"; };
+			a { name2 { device_type = "type1"; }; };
+			b { name2 { }; };
+			c { name2 { device_type = "type2"; }; };
+			name3 { compatible = "compat3"; };
+			name4 { compatible = "compat2", "compat3"; };
+			name5 { compatible = "compat2", "compat3"; };
+			name6 { compatible = "compat1", "compat2", "compat3"; };
+			name7 { compatible = "compat2"; device_type = "type1"; };
+			name8 { compatible = "compat2"; device_type = "type1"; };
+			name9 { compatible = "compat2"; };
+		};
+	};
+};
-- 
1.8.3.2

