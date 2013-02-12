Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab3BLXGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:06:54 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41244 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778Ab3BLXGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:06:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 2/5] of/selftest: Use selftest() macro throughout
Date: Tue, 12 Feb 2013 23:06:38 +0000
Message-Id: <1360710401-16757-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
References: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the selftests are open-coded. Others use the selftest() macro
defined in drivers/of/selftest.c. The macro makes for cleaner selftest
code, so refactor the of_parse_phandle_with_args() tests to use it.

Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/selftest.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 9f62eb5..01b4174 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -2,7 +2,7 @@
  * Self tests for device tree subsystem
  */
 
-#define pr_fmt(fmt) "### %s(): " fmt, __func__
+#define pr_fmt(fmt) "### dt-test ### " fmt
 
 #include <linux/clk.h>
 #include <linux/err.h>
@@ -16,19 +16,20 @@
 
 static bool selftest_passed = true;
 #define selftest(result, fmt, ...) { \
-	selftest_passed &= (result); \
-	if (!(result)) \
+	if (!(result)) { \
 		pr_err("FAIL %s:%i " fmt, __FILE__, __LINE__, ##__VA_ARGS__); \
+		selftest_passed = false; \
+	} else { \
+		pr_info("pass %s:%i\n", __FILE__, __LINE__); \
+	} \
 }
 
 static void __init of_selftest_parse_phandle_with_args(void)
 {
 	struct device_node *np;
 	struct of_phandle_args args;
-	int rc, i;
-	bool passed_all = true;
+	int i, rc;
 
-	pr_info("start\n");
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	if (!np) {
 		pr_err("missing testcase data\n");
@@ -79,45 +80,35 @@ static void __init of_selftest_parse_phandle_with_args(void)
 			passed &= (args.args[0] == (i + 1));
 			break;
 		case 7:
-			passed &= (rc == -EINVAL);
+			passed &= (rc == -ENOENT);
 			break;
 		default:
 			passed = false;
 		}
 
-		if (!passed) {
-			int j;
-			pr_err("index %i - data error on node %s rc=%i regs=[",
-				i, args.np->full_name, rc);
-			for (j = 0; j < args.args_count; j++)
-				printk(" %i", args.args[j]);
-			printk(" ]\n");
-
-			passed_all = false;
-		}
+		selftest(passed, "index %i - data error on node %s rc=%i\n",
+			 i, args.np->full_name, rc);
 	}
 
 	/* Check for missing list property */
 	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
 					"#phandle-cells", 0, &args);
-	passed_all &= (rc == -EINVAL);
+	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
 
 	/* Check for missing cells property */
 	rc = of_parse_phandle_with_args(np, "phandle-list",
 					"#phandle-cells-missing", 0, &args);
-	passed_all &= (rc == -EINVAL);
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for bad phandle in list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
 					"#phandle-cells", 0, &args);
-	passed_all &= (rc == -EINVAL);
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for incorrectly formed argument list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
 					"#phandle-cells", 1, &args);
-	passed_all &= (rc == -EINVAL);
-
-	pr_info("end - %s\n", passed_all ? "PASS" : "FAIL");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 }
 
 static void __init of_selftest_property_match_string(void)
-- 
1.7.10.4

