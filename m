Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaCNRMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:12:03 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62804 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaCNRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:11:59 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [RFC v3 1/3] of: Add a testcase for of_find_node_by_path()
Date: Fri, 14 Mar 2014 17:11:47 +0000
Message-Id: <1394817109-26199-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
References: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
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
1.8.3.2

