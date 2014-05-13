Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096AbaEMPIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:08:13 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60174 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982AbaEMO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:49 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3/3] of: Add a testcase for of_find_node_by_path()
Date: Tue, 13 May 2014 15:58:35 +0100
Message-Id: <1399993115-21552-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a testcase for the find_node_by_path() function to make sure it
handles all the valid scenarios.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/selftest.c                       | 39 +++++++++++++++++++++++++++++
 drivers/of/testcase-data/tests-phandle.dtsi |  6 ++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index ae4450070503..f5b4dcffbe32 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -30,6 +30,43 @@ static struct selftest_results {
 	} \
 }
 
+static void __init of_selftest_find_node_by_name(void)
+{
+	struct device_node *np;
+
+	np = of_find_node_by_path("/testcase-data");
+	selftest(np && !strcmp("/testcase-data", np->full_name),
+		"find /testcase-data failed\n");
+	of_node_put(np);
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
+		"find /testcase-data/phandle-tests/consumer-a failed\n");
+	of_node_put(np);
+
+	np = of_find_node_by_path("testcase-alias");
+	selftest(np && !strcmp("/testcase-data", np->full_name),
+		"find testcase-alias failed\n");
+	of_node_put(np);
+
+	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
+	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
+		"find testcase-alias/phandle-tests/consumer-a failed\n");
+	of_node_put(np);
+
+	np = of_find_node_by_path("/testcase-data/missing-path");
+	selftest(!np, "non-existent path returned node %s\n", np->full_name);
+	of_node_put(np);
+
+	np = of_find_node_by_path("missing-alias");
+	selftest(!np, "non-existent alias returned node %s\n", np->full_name);
+	of_node_put(np);
+
+	np = of_find_node_by_path("testcase-alias/missing-path");
+	selftest(!np, "non-existent alias with relative path returned node %s\n", np->full_name);
+	of_node_put(np);
+}
+
 static void __init of_selftest_dynamic(void)
 {
 	struct device_node *np;
@@ -89,6 +126,7 @@ static void __init of_selftest_dynamic(void)
 	if (prop->value)
 		selftest(of_add_property(np, prop) == 0,
 			 "Adding a large property should have passed\n");
+
 }
 
 static void __init of_selftest_parse_phandle_with_args(void)
@@ -439,6 +477,7 @@ static int __init of_selftest(void)
 	of_node_put(np);
 
 	pr_info("start of selftest - you will see error messages\n");
+	of_selftest_find_node_by_name();
 	of_selftest_dynamic();
 	of_selftest_parse_phandle_with_args();
 	of_selftest_property_match_string();
diff --git a/drivers/of/testcase-data/tests-phandle.dtsi b/drivers/of/testcase-data/tests-phandle.dtsi
index 788a4c24b8f5..ce0fe083d406 100644
--- a/drivers/of/testcase-data/tests-phandle.dtsi
+++ b/drivers/of/testcase-data/tests-phandle.dtsi
@@ -1,6 +1,10 @@
 
 / {
-	testcase-data {
+	aliases {
+		testcase-alias = &testcase;
+	};
+
+	testcase: testcase-data {
 		security-password = "password";
 		duplicate-name = "duplicate";
 		duplicate-name { };
-- 
1.9.1

