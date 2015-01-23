Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbbAWQKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:10:22 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:51439 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbbAWQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:10:11 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RFC 2/2] of/unittest: Add reference count tests
Date: Fri, 23 Jan 2015 17:10:05 +0100
Message-Id: <1422029405-9353-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422029405-9353-1-git-send-email-geert+renesas@glider.be>
References: <1422029405-9353-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tests to detect reference count imbalances. The tests use a fixed
list of paths to devices nodes (required device nodes in a minimal DTS,
and device nodes present in unittest-data).

These tests are executed only if CONFIG_OF_DYNAMIC=y.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/unittest.c | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 7aa1d6dae5ba72af..464703c6e7021760 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1383,6 +1383,154 @@ out:
 static inline void __init of_selftest_overlay(void) { }
 #endif
 
+#ifdef CONFIG_OF_DYNAMIC
+static struct {
+	const char *path;
+	int refcnt;
+} refcnt_tests[] __initdata = {
+	/* required nodes */
+	{ "/" },
+	{ "/aliases" },
+	{ "/chosen" },
+	{ "/cpus" },
+	{ "/cpus/cpu@0" },
+	{ "/testcase-data" },
+	/* unittest-data */
+	{ "/testcase-data/interrupts" },
+	{ "/testcase-data/interrupts/intc0" },
+	{ "/testcase-data/interrupts/intc1" },
+	{ "/testcase-data/interrupts/intc2" },
+	{ "/testcase-data/interrupts/interrupts0" },
+	{ "/testcase-data/interrupts/interrupts1" },
+	{ "/testcase-data/interrupts/interrupts-extended0" },
+	{ "/testcase-data/interrupts/intmap0" },
+	{ "/testcase-data/interrupts/intmap1" },
+	{ "/testcase-data/platform-tests" },
+	{ "/testcase-data/platform-tests/test-device@0" },
+	{ "/testcase-data/platform-tests/test-device@0/dev@100" },
+	{ "/testcase-data/platform-tests/test-device@1" },
+	{ "/testcase-data/platform-tests/test-device@1/dev@100" },
+	{ "/testcase-data/phandle-tests" },
+	{ "/testcase-data/phandle-tests/consumer-a" },
+	{ "/testcase-data/phandle-tests/provider0" },
+	{ "/testcase-data/phandle-tests/provider1" },
+	{ "/testcase-data/phandle-tests/provider2" },
+	{ "/testcase-data/phandle-tests/provider3" },
+	{ "/testcase-data/match-node" },
+	{ "/testcase-data/match-node/a" },
+	{ "/testcase-data/match-node/a/name2" },
+	{ "/testcase-data/match-node/b" },
+	{ "/testcase-data/match-node/b/name2" },
+	{ "/testcase-data/match-node/c" },
+	{ "/testcase-data/match-node/c/name2" },
+	{ "/testcase-data/match-node/name0" },
+	{ "/testcase-data/match-node/name1" },
+	{ "/testcase-data/match-node/name3" },
+	{ "/testcase-data/match-node/name4" },
+	{ "/testcase-data/match-node/name5" },
+	{ "/testcase-data/match-node/name6" },
+	{ "/testcase-data/match-node/name7" },
+	{ "/testcase-data/match-node/name8" },
+	{ "/testcase-data/match-node/name9" },
+	{ "/testcase-data/changeset" },
+	{ "/testcase-data/changeset/node-remove" },
+	{ "/testcase-data/overlay-node" },
+	{ "/testcase-data/overlay-node/test-bus" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest100" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest101" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest0" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest1" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest2" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest3" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest5" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest6" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest7" },
+	{ "/testcase-data/overlay-node/test-bus/test-selftest8" },
+	{ "/testcase-data/overlay0" },
+	{ "/testcase-data/overlay0/fragment@0" },
+	{ "/testcase-data/overlay0/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay1" },
+	{ "/testcase-data/overlay1/fragment@0" },
+	{ "/testcase-data/overlay1/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay2" },
+	{ "/testcase-data/overlay2/fragment@0" },
+	{ "/testcase-data/overlay2/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay3" },
+	{ "/testcase-data/overlay3/fragment@0" },
+	{ "/testcase-data/overlay3/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay4" },
+	{ "/testcase-data/overlay4/fragment@0" },
+	{ "/testcase-data/overlay4/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay4/fragment@0/__overlay__/test-selftest4" },
+	{ "/testcase-data/overlay5" },
+	{ "/testcase-data/overlay5/fragment@0" },
+	{ "/testcase-data/overlay5/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay6" },
+	{ "/testcase-data/overlay6/fragment@0" },
+	{ "/testcase-data/overlay6/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay7" },
+	{ "/testcase-data/overlay7/fragment@0" },
+	{ "/testcase-data/overlay7/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay8" },
+	{ "/testcase-data/overlay8/fragment@0" },
+	{ "/testcase-data/overlay8/fragment@0/__overlay__" },
+	{ "/testcase-data/overlay9" },
+	{ "/testcase-data/overlay9/fragment@0" },
+	{ "/testcase-data/overlay9/fragment@0/__overlay__" },
+	{ "/testcase-data/duplicate-name#1" },
+	{ "/testcase-data/testcase-device1" },
+	{ "/testcase-data/testcase-device2" },
+	{ "/__local_fixups__/testcase-data" },
+	{ "/__local_fixups__/testcase-data/interrupts" },
+	{ "/__local_fixups__/testcase-data/interrupts/interrupts0" },
+	{ "/__local_fixups__/testcase-data/interrupts/interrupts1" },
+	{ "/__local_fixups__/testcase-data/interrupts/interrupts-extended0" },
+	{ "/__local_fixups__/testcase-data/interrupts/intmap0" },
+	{ "/__local_fixups__/testcase-data/interrupts/intmap1" },
+	{ "/__local_fixups__/testcase-data/phandle-tests" },
+	{ "/__local_fixups__/testcase-data/phandle-tests/consumer-a" },
+	{ "/__local_fixups__/testcase-data/overlay2" },
+	{ "/__local_fixups__/testcase-data/overlay2/fragment@0" },
+	{ "/__local_fixups__/testcase-data/overlay3" },
+	{ "/__local_fixups__/testcase-data/overlay3/fragment@0" },
+	{ "/__local_fixups__/testcase-data/overlay4" },
+	{ "/__local_fixups__/testcase-data/overlay4/fragment@0" },
+	{ "/__local_fixups__/testcase-data/testcase-device1" },
+	{ "/__local_fixups__/testcase-data/testcase-device2" },
+};
+
+static void __init of_selftest_refcnt(void)
+{
+	static bool called;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(refcnt_tests); i++) {
+		const char *path = refcnt_tests[i].path;
+		struct device_node *np = of_find_node_by_path(path);
+		int refcnt;
+
+		selftest(np, "%s: not found", path);
+		if (!np)
+			continue;
+
+		refcnt = atomic_read(&np->kobj.kref.refcount);
+		if (!called)
+			refcnt_tests[i].refcnt = refcnt;
+		else
+			selftest(refcnt == refcnt_tests[i].refcnt,
+				 "%s: expected:%i got:%i\n", path,
+				 refcnt_tests[i].refcnt, refcnt);
+
+		of_node_put(np);
+	}
+
+	called = true;
+}
+
+#else
+static inline void __init of_selftest_refcnt(void) { }
+#endif
+
 static int __init of_selftest(void)
 {
 	struct device_node *np;
@@ -1403,6 +1551,11 @@ static int __init of_selftest(void)
 	of_node_put(np);
 
 	pr_info("start of selftest - you will see error messages\n");
+
+	/* gather reference counts */
+	of_selftest_refcnt();
+	/* verify reference counts */
+	of_selftest_refcnt();
 	of_selftest_check_tree_linkage();
 	of_selftest_check_phandles();
 	of_selftest_find_node_by_name();
@@ -1420,6 +1573,8 @@ static int __init of_selftest(void)
 	/* Double check linkage after removing testcase data */
 	of_selftest_check_tree_linkage();
 
+	of_selftest_refcnt();
+
 	pr_info("end of selftest - %i passed, %i failed\n",
 		selftest_results.passed, selftest_results.failed);
 
-- 
1.9.1

