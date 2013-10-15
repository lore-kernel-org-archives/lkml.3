Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab3JOUlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:41:13 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62140 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab3JOUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:39 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 6/9] of: Add testcases for interrupt parsing
Date: Tue, 15 Oct 2013 21:39:20 +0100
Message-Id: <1381869563-16083-7-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the DT selftest code with some test cases for the
interrupt parsing functions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/testcases/tests-interrupts.dtsi | 41 ++++++++++
 arch/arm/boot/dts/testcases/tests.dtsi            |  1 +
 drivers/of/selftest.c                             | 91 +++++++++++++++++++++--
 3 files changed, 127 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/boot/dts/testcases/tests-interrupts.dtsi

diff --git a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
new file mode 100644
index 0000000..6ecda71
--- /dev/null
+++ b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
@@ -0,0 +1,41 @@
+
+/ {
+	testcase-data {
+		interrupts {
+			#address-cells = <0>;
+			test_intc0: intc0 {
+				interrupt-controller;
+				#interrupt-cells = <1>;
+			};
+
+			test_intc1: intc1 {
+				interrupt-controller;
+				#interrupt-cells = <3>;
+			};
+
+			test_intc2: intc2 {
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			test_intmap0: intmap0 {
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				interrupt-map = <1 &test_intc0 9>,
+						<2 &test_intc1 10 11 12>,
+						<3 &test_intc2 13 14>,
+						<4 &test_intc2 15 16>;
+			};
+
+			interrupts0 {
+				interrupt-parent = <&test_intc0>;
+				interrupts = <1>, <2>, <3>, <4>;
+			};
+
+			interrupts1 {
+				interrupt-parent = <&test_intmap0>;
+				interrupts = <1>, <2>, <3>, <4>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/testcases/tests.dtsi b/arch/arm/boot/dts/testcases/tests.dtsi
index a7c5067..3f123ec 100644
--- a/arch/arm/boot/dts/testcases/tests.dtsi
+++ b/arch/arm/boot/dts/testcases/tests.dtsi
@@ -1 +1,2 @@
 /include/ "tests-phandle.dtsi"
+/include/ "tests-interrupts.dtsi"
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 0eb5c38..9c80f0b 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -9,18 +9,24 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 
-static bool selftest_passed = true;
+static struct selftest_results {
+	int passed;
+	int failed;
+} selftest_results;
+
 #define selftest(result, fmt, ...) { \
 	if (!(result)) { \
-		pr_err("FAIL %s:%i " fmt, __FILE__, __LINE__, ##__VA_ARGS__); \
-		selftest_passed = false; \
+		selftest_results.failed++; \
+		pr_err("FAIL %s():%i " fmt, __func__, __LINE__, ##__VA_ARGS__); \
 	} else { \
-		pr_info("pass %s:%i\n", __FILE__, __LINE__); \
+		selftest_results.passed++; \
+		pr_debug("pass %s():%i\n", __func__, __LINE__); \
 	} \
 }
 
@@ -131,7 +137,6 @@ static void __init of_selftest_property_match_string(void)
 	struct device_node *np;
 	int rc;
 
-	pr_info("start\n");
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	if (!np) {
 		pr_err("No testcase data in device tree\n");
@@ -154,6 +159,78 @@ static void __init of_selftest_property_match_string(void)
 	selftest(rc == -EILSEQ, "unterminated string; rc=%i", rc);
 }
 
+static void __init of_selftest_parse_interrupts(void)
+{
+	struct device_node *np;
+	struct of_phandle_args args;
+	int i, rc;
+
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts0");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	for (i = 0; i < 4; i++) {
+		bool passed = true;
+		args.args_count = 0;
+		rc = of_irq_parse_one(np, i, &args);
+
+		passed &= !rc;
+		passed &= (args.args_count == 1);
+		passed &= (args.args[0] == (i + 1));
+
+		selftest(passed, "index %i - data error on node %s rc=%i\n",
+			 i, args.np->full_name, rc);
+	}
+	of_node_put(np);
+
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts1");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	for (i = 0; i < 4; i++) {
+		bool passed = true;
+		args.args_count = 0;
+		rc = of_irq_parse_one(np, i, &args);
+
+		/* Test the values from tests-phandle.dtsi */
+		switch (i) {
+		case 0:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == 9);
+			break;
+		case 1:
+			passed &= !rc;
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == 10);
+			passed &= (args.args[1] == 11);
+			passed &= (args.args[2] == 12);
+			break;
+		case 2:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == 13);
+			passed &= (args.args[1] == 14);
+			break;
+		case 3:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == 15);
+			passed &= (args.args[1] == 16);
+			break;
+		default:
+			passed = false;
+		}
+		selftest(passed, "index %i - data error on node %s rc=%i\n",
+			 i, args.np->full_name, rc);
+	}
+	of_node_put(np);
+}
+
 static int __init of_selftest(void)
 {
 	struct device_node *np;
@@ -168,7 +245,9 @@ static int __init of_selftest(void)
 	pr_info("start of selftest - you will see error messages\n");
 	of_selftest_parse_phandle_with_args();
 	of_selftest_property_match_string();
-	pr_info("end of selftest - %s\n", selftest_passed ? "PASS" : "FAIL");
+	of_selftest_parse_interrupts();
+	pr_info("end of selftest - %i passed, %i failed\n",
+		selftest_results.passed, selftest_results.failed);
 	return 0;
 }
 late_initcall(of_selftest);
-- 
1.8.1.2

