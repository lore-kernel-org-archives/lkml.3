Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaEMTVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:21:52 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57415 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaEMTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:21:45 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v2] of/selftest: add testcase for nodes with same name and address
Date: Tue, 13 May 2014 14:21:25 -0500
Message-Id: <1400008885-25370-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add a test case for nodes which have the same name and same
non-translatable unit address.

Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Reviewed-by: Frank Rowand <frank.rowand@sonymobile.com>
---
v2:
- Rebase to v3.15-rc5 and deferred probe irq test
- Rework self checking since adding error return to of_platform_populate 
doesn't work.

 drivers/of/selftest.c                        | 20 +++++++++++++++-
 drivers/of/testcase-data/testcases.dtsi      |  1 +
 drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100644 drivers/of/testcase-data/tests-platform.dtsi

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index c1d7d38..2588faa 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -431,8 +431,12 @@ static void __init of_selftest_match_node(void)
 static void __init of_selftest_platform_populate(void)
 {
 	int irq;
-	struct device_node *np;
+	struct device_node *np, *child;
 	struct platform_device *pdev;
+	struct of_device_id match[] = {
+		{ .compatible = "test-device", },
+		{}
+	};
 
 	np = of_find_node_by_path("/testcase-data");
 	of_platform_populate(np, of_default_bus_match_table, NULL, NULL);
@@ -452,6 +456,20 @@ static void __init of_selftest_platform_populate(void)
 	irq = platform_get_irq(pdev, 0);
 	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
 
+	np = of_find_node_by_path("/testcase-data/platform-tests");
+	if (!np) {
+		pr_err("No testcase data in device tree\n");
+		return;
+	}
+
+	for_each_child_of_node(np, child) {
+		struct device_node *grandchild;
+		of_platform_populate(child, match, NULL, NULL);
+		for_each_child_of_node(child, grandchild)
+			selftest(of_find_device_by_node(grandchild),
+				 "Could not create device for node '%s'\n",
+				 grandchild->name);
+	}
 }
 
 static int __init of_selftest(void)
diff --git a/drivers/of/testcase-data/testcases.dtsi b/drivers/of/testcase-data/testcases.dtsi
index 3a5b75a..6d8d980a 100644
--- a/drivers/of/testcase-data/testcases.dtsi
+++ b/drivers/of/testcase-data/testcases.dtsi
@@ -1,3 +1,4 @@
 #include "tests-phandle.dtsi"
 #include "tests-interrupts.dtsi"
 #include "tests-match.dtsi"
+#include "tests-platform.dtsi"
diff --git a/drivers/of/testcase-data/tests-platform.dtsi b/drivers/of/testcase-data/tests-platform.dtsi
new file mode 100644
index 0000000..eb20eeb
--- /dev/null
+++ b/drivers/of/testcase-data/tests-platform.dtsi
@@ -0,0 +1,35 @@
+
+/ {
+	testcase-data {
+		platform-tests {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			test-device@0 {
+				compatible = "test-device";
+				reg = <0x0>;
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				dev@100 {
+					compatible = "test-sub-device";
+					reg = <0x100>;
+				};
+			};
+
+			test-device@1 {
+				compatible = "test-device";
+				reg = <0x1>;
+
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				dev@100 {
+					compatible = "test-sub-device";
+					reg = <0x100>;
+				};
+			};
+		};
+	};
+};
-- 
1.9.1

