Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaKDNiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:38:13 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44638 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKDNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:38:05 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 2/2] of/unittest: Rename selftest.c to unittest.c
Date: Tue,  4 Nov 2014 13:37:53 +0000
Message-Id: <1415108273-4536-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415108273-4536-1-git-send-email-grant.likely@linaro.org>
References: <1415108273-4536-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is unit testing code. It should use that name because it makes more
sense than 'selftest'. Rename the files to match and rename the config
variable.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/Kconfig                             |   4 +-
 drivers/of/Makefile                            |   4 +-
 drivers/of/selftest.c                          | 969 -------------------------
 drivers/of/testcase-data/testcases.dts         |  50 --
 drivers/of/testcase-data/tests-interrupts.dtsi |  71 --
 drivers/of/testcase-data/tests-match.dtsi      |  19 -
 drivers/of/testcase-data/tests-phandle.dtsi    |  48 --
 drivers/of/testcase-data/tests-platform.dtsi   |  35 -
 drivers/of/unittest-data/testcases.dts         |  50 ++
 drivers/of/unittest-data/tests-interrupts.dtsi |  71 ++
 drivers/of/unittest-data/tests-match.dtsi      |  19 +
 drivers/of/unittest-data/tests-phandle.dtsi    |  48 ++
 drivers/of/unittest-data/tests-platform.dtsi   |  35 +
 drivers/of/unittest.c                          | 969 +++++++++++++++++++++++++
 14 files changed, 1196 insertions(+), 1196 deletions(-)
 delete mode 100644 drivers/of/selftest.c
 delete mode 100644 drivers/of/testcase-data/testcases.dts
 delete mode 100644 drivers/of/testcase-data/tests-interrupts.dtsi
 delete mode 100644 drivers/of/testcase-data/tests-match.dtsi
 delete mode 100644 drivers/of/testcase-data/tests-phandle.dtsi
 delete mode 100644 drivers/of/testcase-data/tests-platform.dtsi
 create mode 100644 drivers/of/unittest-data/testcases.dts
 create mode 100644 drivers/of/unittest-data/tests-interrupts.dtsi
 create mode 100644 drivers/of/unittest-data/tests-match.dtsi
 create mode 100644 drivers/of/unittest-data/tests-phandle.dtsi
 create mode 100644 drivers/of/unittest-data/tests-platform.dtsi
 create mode 100644 drivers/of/unittest.c

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 1a13f5b722c5..be16ce2ffd69 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -7,8 +7,8 @@ config OF
 menu "Device Tree and Open Firmware support"
 	depends on OF
 
-config OF_SELFTEST
-	bool "Device Tree Runtime self tests"
+config OF_UNITTEST
+	bool "Device Tree runtime unit tests"
 	depends on OF_IRQ && OF_EARLY_FLATTREE
 	select OF_DYNAMIC
 	select OF_RESOLVE
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ca9209ce50cd..d90553fcd37f 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -6,8 +6,8 @@ obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
-obj-$(CONFIG_OF_SELFTEST) += of_selftest.o
-of_selftest-objs := selftest.o testcase-data/testcases.dtb.o
+obj-$(CONFIG_OF_UNITTEST) += of_unittest.o
+of_unittest-objs := unittest.o unittest-data/testcases.dtb.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
deleted file mode 100644
index 082bb2b6a5ad..000000000000
--- a/drivers/of/selftest.c
+++ /dev/null
@@ -1,969 +0,0 @@
-/*
- * Self tests for device tree subsystem
- */
-
-#define pr_fmt(fmt) "### dt-test ### " fmt
-
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/hashtable.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-
-#include "of_private.h"
-
-static struct selftest_results {
-	int passed;
-	int failed;
-} selftest_results;
-
-#define NO_OF_NODES 3
-static struct device_node *nodes[NO_OF_NODES];
-static int last_node_index;
-static bool selftest_live_tree;
-
-#define selftest(result, fmt, ...) ({ \
-	bool failed = !(result); \
-	if (failed) { \
-		selftest_results.failed++; \
-		pr_err("FAIL %s():%i " fmt, __func__, __LINE__, ##__VA_ARGS__); \
-	} else { \
-		selftest_results.passed++; \
-		pr_debug("pass %s():%i\n", __func__, __LINE__); \
-	} \
-	failed; \
-})
-
-static void __init of_selftest_find_node_by_name(void)
-{
-	struct device_node *np;
-
-	np = of_find_node_by_path("/testcase-data");
-	selftest(np && !strcmp("/testcase-data", np->full_name),
-		"find /testcase-data failed\n");
-	of_node_put(np);
-
-	/* Test if trailing '/' works */
-	np = of_find_node_by_path("/testcase-data/");
-	selftest(!np, "trailing '/' on /testcase-data/ should fail\n");
-
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
-	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
-		"find /testcase-data/phandle-tests/consumer-a failed\n");
-	of_node_put(np);
-
-	np = of_find_node_by_path("testcase-alias");
-	selftest(np && !strcmp("/testcase-data", np->full_name),
-		"find testcase-alias failed\n");
-	of_node_put(np);
-
-	/* Test if trailing '/' works on aliases */
-	np = of_find_node_by_path("testcase-alias/");
-	selftest(!np, "trailing '/' on testcase-alias/ should fail\n");
-
-	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
-	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
-		"find testcase-alias/phandle-tests/consumer-a failed\n");
-	of_node_put(np);
-
-	np = of_find_node_by_path("/testcase-data/missing-path");
-	selftest(!np, "non-existent path returned node %s\n", np->full_name);
-	of_node_put(np);
-
-	np = of_find_node_by_path("missing-alias");
-	selftest(!np, "non-existent alias returned node %s\n", np->full_name);
-	of_node_put(np);
-
-	np = of_find_node_by_path("testcase-alias/missing-path");
-	selftest(!np, "non-existent alias with relative path returned node %s\n", np->full_name);
-	of_node_put(np);
-}
-
-static void __init of_selftest_dynamic(void)
-{
-	struct device_node *np;
-	struct property *prop;
-
-	np = of_find_node_by_path("/testcase-data");
-	if (!np) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	/* Array of 4 properties for the purpose of testing */
-	prop = kzalloc(sizeof(*prop) * 4, GFP_KERNEL);
-	if (!prop) {
-		selftest(0, "kzalloc() failed\n");
-		return;
-	}
-
-	/* Add a new property - should pass*/
-	prop->name = "new-property";
-	prop->value = "new-property-data";
-	prop->length = strlen(prop->value);
-	selftest(of_add_property(np, prop) == 0, "Adding a new property failed\n");
-
-	/* Try to add an existing property - should fail */
-	prop++;
-	prop->name = "new-property";
-	prop->value = "new-property-data-should-fail";
-	prop->length = strlen(prop->value);
-	selftest(of_add_property(np, prop) != 0,
-		 "Adding an existing property should have failed\n");
-
-	/* Try to modify an existing property - should pass */
-	prop->value = "modify-property-data-should-pass";
-	prop->length = strlen(prop->value);
-	selftest(of_update_property(np, prop) == 0,
-		 "Updating an existing property should have passed\n");
-
-	/* Try to modify non-existent property - should pass*/
-	prop++;
-	prop->name = "modify-property";
-	prop->value = "modify-missing-property-data-should-pass";
-	prop->length = strlen(prop->value);
-	selftest(of_update_property(np, prop) == 0,
-		 "Updating a missing property should have passed\n");
-
-	/* Remove property - should pass */
-	selftest(of_remove_property(np, prop) == 0,
-		 "Removing a property should have passed\n");
-
-	/* Adding very large property - should pass */
-	prop++;
-	prop->name = "large-property-PAGE_SIZEx8";
-	prop->length = PAGE_SIZE * 8;
-	prop->value = kzalloc(prop->length, GFP_KERNEL);
-	selftest(prop->value != NULL, "Unable to allocate large buffer\n");
-	if (prop->value)
-		selftest(of_add_property(np, prop) == 0,
-			 "Adding a large property should have passed\n");
-}
-
-static int __init of_selftest_check_node_linkage(struct device_node *np)
-{
-	struct device_node *child;
-	int count = 0, rc;
-
-	for_each_child_of_node(np, child) {
-		if (child->parent != np) {
-			pr_err("Child node %s links to wrong parent %s\n",
-				 child->name, np->name);
-			return -EINVAL;
-		}
-
-		rc = of_selftest_check_node_linkage(child);
-		if (rc < 0)
-			return rc;
-		count += rc;
-	}
-
-	return count + 1;
-}
-
-static void __init of_selftest_check_tree_linkage(void)
-{
-	struct device_node *np;
-	int allnode_count = 0, child_count;
-
-	if (!of_root)
-		return;
-
-	for_each_of_allnodes(np)
-		allnode_count++;
-	child_count = of_selftest_check_node_linkage(of_root);
-
-	selftest(child_count > 0, "Device node data structure is corrupted\n");
-	selftest(child_count == allnode_count, "allnodes list size (%i) doesn't match"
-		 "sibling lists size (%i)\n", allnode_count, child_count);
-	pr_debug("allnodes list size (%i); sibling lists size (%i)\n", allnode_count, child_count);
-}
-
-struct node_hash {
-	struct hlist_node node;
-	struct device_node *np;
-};
-
-static DEFINE_HASHTABLE(phandle_ht, 8);
-static void __init of_selftest_check_phandles(void)
-{
-	struct device_node *np;
-	struct node_hash *nh;
-	struct hlist_node *tmp;
-	int i, dup_count = 0, phandle_count = 0;
-
-	for_each_of_allnodes(np) {
-		if (!np->phandle)
-			continue;
-
-		hash_for_each_possible(phandle_ht, nh, node, np->phandle) {
-			if (nh->np->phandle == np->phandle) {
-				pr_info("Duplicate phandle! %i used by %s and %s\n",
-					np->phandle, nh->np->full_name, np->full_name);
-				dup_count++;
-				break;
-			}
-		}
-
-		nh = kzalloc(sizeof(*nh), GFP_KERNEL);
-		if (WARN_ON(!nh))
-			return;
-
-		nh->np = np;
-		hash_add(phandle_ht, &nh->node, np->phandle);
-		phandle_count++;
-	}
-	selftest(dup_count == 0, "Found %i duplicates in %i phandles\n",
-		 dup_count, phandle_count);
-
-	/* Clean up */
-	hash_for_each_safe(phandle_ht, i, tmp, nh, node) {
-		hash_del(&nh->node);
-		kfree(nh);
-	}
-}
-
-static void __init of_selftest_parse_phandle_with_args(void)
-{
-	struct device_node *np;
-	struct of_phandle_args args;
-	int i, rc;
-
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
-	if (!np) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
-	selftest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
-
-	for (i = 0; i < 8; i++) {
-		bool passed = true;
-		rc = of_parse_phandle_with_args(np, "phandle-list",
-						"#phandle-cells", i, &args);
-
-		/* Test the values from tests-phandle.dtsi */
-		switch (i) {
-		case 0:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == (i + 1));
-			break;
-		case 1:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == (i + 1));
-			passed &= (args.args[1] == 0);
-			break;
-		case 2:
-			passed &= (rc == -ENOENT);
-			break;
-		case 3:
-			passed &= !rc;
-			passed &= (args.args_count == 3);
-			passed &= (args.args[0] == (i + 1));
-			passed &= (args.args[1] == 4);
-			passed &= (args.args[2] == 3);
-			break;
-		case 4:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == (i + 1));
-			passed &= (args.args[1] == 100);
-			break;
-		case 5:
-			passed &= !rc;
-			passed &= (args.args_count == 0);
-			break;
-		case 6:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == (i + 1));
-			break;
-		case 7:
-			passed &= (rc == -ENOENT);
-			break;
-		default:
-			passed = false;
-		}
-
-		selftest(passed, "index %i - data error on node %s rc=%i\n",
-			 i, args.np->full_name, rc);
-	}
-
-	/* Check for missing list property */
-	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
-					"#phandle-cells", 0, &args);
-	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
-	rc = of_count_phandle_with_args(np, "phandle-list-missing",
-					"#phandle-cells");
-	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
-
-	/* Check for missing cells property */
-	rc = of_parse_phandle_with_args(np, "phandle-list",
-					"#phandle-cells-missing", 0, &args);
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-	rc = of_count_phandle_with_args(np, "phandle-list",
-					"#phandle-cells-missing");
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-
-	/* Check for bad phandle in list */
-	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
-					"#phandle-cells", 0, &args);
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
-					"#phandle-cells");
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-
-	/* Check for incorrectly formed argument list */
-	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
-					"#phandle-cells", 1, &args);
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
-					"#phandle-cells");
-	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
-}
-
-static void __init of_selftest_property_string(void)
-{
-	const char *strings[4];
-	struct device_node *np;
-	int rc;
-
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
-	if (!np) {
-		pr_err("No testcase data in device tree\n");
-		return;
-	}
-
-	rc = of_property_match_string(np, "phandle-list-names", "first");
-	selftest(rc == 0, "first expected:0 got:%i\n", rc);
-	rc = of_property_match_string(np, "phandle-list-names", "second");
-	selftest(rc == 1, "second expected:0 got:%i\n", rc);
-	rc = of_property_match_string(np, "phandle-list-names", "third");
-	selftest(rc == 2, "third expected:0 got:%i\n", rc);
-	rc = of_property_match_string(np, "phandle-list-names", "fourth");
-	selftest(rc == -ENODATA, "unmatched string; rc=%i\n", rc);
-	rc = of_property_match_string(np, "missing-property", "blah");
-	selftest(rc == -EINVAL, "missing property; rc=%i\n", rc);
-	rc = of_property_match_string(np, "empty-property", "blah");
-	selftest(rc == -ENODATA, "empty property; rc=%i\n", rc);
-	rc = of_property_match_string(np, "unterminated-string", "blah");
-	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
-
-	/* of_property_count_strings() tests */
-	rc = of_property_count_strings(np, "string-property");
-	selftest(rc == 1, "Incorrect string count; rc=%i\n", rc);
-	rc = of_property_count_strings(np, "phandle-list-names");
-	selftest(rc == 3, "Incorrect string count; rc=%i\n", rc);
-	rc = of_property_count_strings(np, "unterminated-string");
-	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
-	rc = of_property_count_strings(np, "unterminated-string-list");
-	selftest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
-
-	/* of_property_read_string_index() tests */
-	rc = of_property_read_string_index(np, "string-property", 0, strings);
-	selftest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);
-	strings[0] = NULL;
-	rc = of_property_read_string_index(np, "string-property", 1, strings);
-	selftest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
-	rc = of_property_read_string_index(np, "phandle-list-names", 0, strings);
-	selftest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
-	rc = of_property_read_string_index(np, "phandle-list-names", 1, strings);
-	selftest(rc == 0 && !strcmp(strings[0], "second"), "of_property_read_string_index() failure; rc=%i\n", rc);
-	rc = of_property_read_string_index(np, "phandle-list-names", 2, strings);
-	selftest(rc == 0 && !strcmp(strings[0], "third"), "of_property_read_string_index() failure; rc=%i\n", rc);
-	strings[0] = NULL;
-	rc = of_property_read_string_index(np, "phandle-list-names", 3, strings);
-	selftest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
-	strings[0] = NULL;
-	rc = of_property_read_string_index(np, "unterminated-string", 0, strings);
-	selftest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
-	rc = of_property_read_string_index(np, "unterminated-string-list", 0, strings);
-	selftest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
-	strings[0] = NULL;
-	rc = of_property_read_string_index(np, "unterminated-string-list", 2, strings); /* should fail */
-	selftest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
-	strings[1] = NULL;
-
-	/* of_property_read_string_array() tests */
-	rc = of_property_read_string_array(np, "string-property", strings, 4);
-	selftest(rc == 1, "Incorrect string count; rc=%i\n", rc);
-	rc = of_property_read_string_array(np, "phandle-list-names", strings, 4);
-	selftest(rc == 3, "Incorrect string count; rc=%i\n", rc);
-	rc = of_property_read_string_array(np, "unterminated-string", strings, 4);
-	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
-	/* -- An incorrectly formed string should cause a failure */
-	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 4);
-	selftest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
-	/* -- parsing the correctly formed strings should still work: */
-	strings[2] = NULL;
-	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 2);
-	selftest(rc == 2 && strings[2] == NULL, "of_property_read_string_array() failure; rc=%i\n", rc);
-	strings[1] = NULL;
-	rc = of_property_read_string_array(np, "phandle-list-names", strings, 1);
-	selftest(rc == 1 && strings[1] == NULL, "Overwrote end of string array; rc=%i, str='%s'\n", rc, strings[1]);
-}
-
-#define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
-			(p1)->value && (p2)->value && \
-			!memcmp((p1)->value, (p2)->value, (p1)->length) && \
-			!strcmp((p1)->name, (p2)->name))
-static void __init of_selftest_property_copy(void)
-{
-#ifdef CONFIG_OF_DYNAMIC
-	struct property p1 = { .name = "p1", .length = 0, .value = "" };
-	struct property p2 = { .name = "p2", .length = 5, .value = "abcd" };
-	struct property *new;
-
-	new = __of_prop_dup(&p1, GFP_KERNEL);
-	selftest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	kfree(new->value);
-	kfree(new->name);
-	kfree(new);
-
-	new = __of_prop_dup(&p2, GFP_KERNEL);
-	selftest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	kfree(new->value);
-	kfree(new->name);
-	kfree(new);
-#endif
-}
-
-static void __init of_selftest_changeset(void)
-{
-#ifdef CONFIG_OF_DYNAMIC
-	struct property *ppadd, padd = { .name = "prop-add", .length = 0, .value = "" };
-	struct property *ppupdate, pupdate = { .name = "prop-update", .length = 5, .value = "abcd" };
-	struct property *ppremove;
-	struct device_node *n1, *n2, *n21, *nremove, *parent;
-	struct of_changeset chgset;
-
-	of_changeset_init(&chgset);
-	n1 = __of_node_alloc("/testcase-data/changeset/n1", GFP_KERNEL);
-	selftest(n1, "testcase setup failure\n");
-	n2 = __of_node_alloc("/testcase-data/changeset/n2", GFP_KERNEL);
-	selftest(n2, "testcase setup failure\n");
-	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21", GFP_KERNEL);
-	selftest(n21, "testcase setup failure %p\n", n21);
-	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove");
-	selftest(nremove, "testcase setup failure\n");
-	ppadd = __of_prop_dup(&padd, GFP_KERNEL);
-	selftest(ppadd, "testcase setup failure\n");
-	ppupdate = __of_prop_dup(&pupdate, GFP_KERNEL);
-	selftest(ppupdate, "testcase setup failure\n");
-	parent = nremove->parent;
-	n1->parent = parent;
-	n2->parent = parent;
-	n21->parent = n2;
-	n2->child = n21;
-	ppremove = of_find_property(parent, "prop-remove", NULL);
-	selftest(ppremove, "failed to find removal prop");
-
-	of_changeset_init(&chgset);
-	selftest(!of_changeset_attach_node(&chgset, n1), "fail attach n1\n");
-	selftest(!of_changeset_attach_node(&chgset, n2), "fail attach n2\n");
-	selftest(!of_changeset_detach_node(&chgset, nremove), "fail remove node\n");
-	selftest(!of_changeset_attach_node(&chgset, n21), "fail attach n21\n");
-	selftest(!of_changeset_add_property(&chgset, parent, ppadd), "fail add prop\n");
-	selftest(!of_changeset_update_property(&chgset, parent, ppupdate), "fail update prop\n");
-	selftest(!of_changeset_remove_property(&chgset, parent, ppremove), "fail remove prop\n");
-	mutex_lock(&of_mutex);
-	selftest(!of_changeset_apply(&chgset), "apply failed\n");
-	mutex_unlock(&of_mutex);
-
-	mutex_lock(&of_mutex);
-	selftest(!of_changeset_revert(&chgset), "revert failed\n");
-	mutex_unlock(&of_mutex);
-
-	of_changeset_destroy(&chgset);
-#endif
-}
-
-static void __init of_selftest_parse_interrupts(void)
-{
-	struct device_node *np;
-	struct of_phandle_args args;
-	int i, rc;
-
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts0");
-	if (!np) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	for (i = 0; i < 4; i++) {
-		bool passed = true;
-		args.args_count = 0;
-		rc = of_irq_parse_one(np, i, &args);
-
-		passed &= !rc;
-		passed &= (args.args_count == 1);
-		passed &= (args.args[0] == (i + 1));
-
-		selftest(passed, "index %i - data error on node %s rc=%i\n",
-			 i, args.np->full_name, rc);
-	}
-	of_node_put(np);
-
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts1");
-	if (!np) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	for (i = 0; i < 4; i++) {
-		bool passed = true;
-		args.args_count = 0;
-		rc = of_irq_parse_one(np, i, &args);
-
-		/* Test the values from tests-phandle.dtsi */
-		switch (i) {
-		case 0:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == 9);
-			break;
-		case 1:
-			passed &= !rc;
-			passed &= (args.args_count == 3);
-			passed &= (args.args[0] == 10);
-			passed &= (args.args[1] == 11);
-			passed &= (args.args[2] == 12);
-			break;
-		case 2:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == 13);
-			passed &= (args.args[1] == 14);
-			break;
-		case 3:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == 15);
-			passed &= (args.args[1] == 16);
-			break;
-		default:
-			passed = false;
-		}
-		selftest(passed, "index %i - data error on node %s rc=%i\n",
-			 i, args.np->full_name, rc);
-	}
-	of_node_put(np);
-}
-
-static void __init of_selftest_parse_interrupts_extended(void)
-{
-	struct device_node *np;
-	struct of_phandle_args args;
-	int i, rc;
-
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0");
-	if (!np) {
-		pr_err("missing testcase data\n");
-		return;
-	}
-
-	for (i = 0; i < 7; i++) {
-		bool passed = true;
-		rc = of_irq_parse_one(np, i, &args);
-
-		/* Test the values from tests-phandle.dtsi */
-		switch (i) {
-		case 0:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == 1);
-			break;
-		case 1:
-			passed &= !rc;
-			passed &= (args.args_count == 3);
-			passed &= (args.args[0] == 2);
-			passed &= (args.args[1] == 3);
-			passed &= (args.args[2] == 4);
-			break;
-		case 2:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == 5);
-			passed &= (args.args[1] == 6);
-			break;
-		case 3:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == 9);
-			break;
-		case 4:
-			passed &= !rc;
-			passed &= (args.args_count == 3);
-			passed &= (args.args[0] == 10);
-			passed &= (args.args[1] == 11);
-			passed &= (args.args[2] == 12);
-			break;
-		case 5:
-			passed &= !rc;
-			passed &= (args.args_count == 2);
-			passed &= (args.args[0] == 13);
-			passed &= (args.args[1] == 14);
-			break;
-		case 6:
-			passed &= !rc;
-			passed &= (args.args_count == 1);
-			passed &= (args.args[0] == 15);
-			break;
-		default:
-			passed = false;
-		}
-
-		selftest(passed, "index %i - data error on node %s rc=%i\n",
-			 i, args.np->full_name, rc);
-	}
-	of_node_put(np);
-}
-
-static struct of_device_id match_node_table[] = {
-	{ .data = "A", .name = "name0", }, /* Name alone is lowest priority */
-	{ .data = "B", .type = "type1", }, /* followed by type alone */
-
-	{ .data = "Ca", .name = "name2", .type = "type1", }, /* followed by both together */
-	{ .data = "Cb", .name = "name2", }, /* Only match when type doesn't match */
-	{ .data = "Cc", .name = "name2", .type = "type2", },
-
-	{ .data = "E", .compatible = "compat3" },
-	{ .data = "G", .compatible = "compat2", },
-	{ .data = "H", .compatible = "compat2", .name = "name5", },
-	{ .data = "I", .compatible = "compat2", .type = "type1", },
-	{ .data = "J", .compatible = "compat2", .type = "type1", .name = "name8", },
-	{ .data = "K", .compatible = "compat2", .name = "name9", },
-	{}
-};
-
-static struct {
-	const char *path;
-	const char *data;
-} match_node_tests[] = {
-	{ .path = "/testcase-data/match-node/name0", .data = "A", },
-	{ .path = "/testcase-data/match-node/name1", .data = "B", },
-	{ .path = "/testcase-data/match-node/a/name2", .data = "Ca", },
-	{ .path = "/testcase-data/match-node/b/name2", .data = "Cb", },
-	{ .path = "/testcase-data/match-node/c/name2", .data = "Cc", },
-	{ .path = "/testcase-data/match-node/name3", .data = "E", },
-	{ .path = "/testcase-data/match-node/name4", .data = "G", },
-	{ .path = "/testcase-data/match-node/name5", .data = "H", },
-	{ .path = "/testcase-data/match-node/name6", .data = "G", },
-	{ .path = "/testcase-data/match-node/name7", .data = "I", },
-	{ .path = "/testcase-data/match-node/name8", .data = "J", },
-	{ .path = "/testcase-data/match-node/name9", .data = "K", },
-};
-
-static void __init of_selftest_match_node(void)
-{
-	struct device_node *np;
-	const struct of_device_id *match;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(match_node_tests); i++) {
-		np = of_find_node_by_path(match_node_tests[i].path);
-		if (!np) {
-			selftest(0, "missing testcase node %s\n",
-				match_node_tests[i].path);
-			continue;
-		}
-
-		match = of_match_node(match_node_table, np);
-		if (!match) {
-			selftest(0, "%s didn't match anything\n",
-				match_node_tests[i].path);
-			continue;
-		}
-
-		if (strcmp(match->data, match_node_tests[i].data) != 0) {
-			selftest(0, "%s got wrong match. expected %s, got %s\n",
-				match_node_tests[i].path, match_node_tests[i].data,
-				(const char *)match->data);
-			continue;
-		}
-		selftest(1, "passed");
-	}
-}
-
-struct device test_bus = {
-	.init_name = "unittest-bus",
-};
-static void __init of_selftest_platform_populate(void)
-{
-	int irq, rc;
-	struct device_node *np, *child, *grandchild;
-	struct platform_device *pdev;
-	struct of_device_id match[] = {
-		{ .compatible = "test-device", },
-		{}
-	};
-
-	np = of_find_node_by_path("/testcase-data");
-	of_platform_populate(np, of_default_bus_match_table, NULL, NULL);
-
-	/* Test that a missing irq domain returns -EPROBE_DEFER */
-	np = of_find_node_by_path("/testcase-data/testcase-device1");
-	pdev = of_find_device_by_node(np);
-	selftest(pdev, "device 1 creation failed\n");
-
-	irq = platform_get_irq(pdev, 0);
-	selftest(irq == -EPROBE_DEFER, "device deferred probe failed - %d\n", irq);
-
-	/* Test that a parsing failure does not return -EPROBE_DEFER */
-	np = of_find_node_by_path("/testcase-data/testcase-device2");
-	pdev = of_find_device_by_node(np);
-	selftest(pdev, "device 2 creation failed\n");
-	irq = platform_get_irq(pdev, 0);
-	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
-
-	if (selftest(np = of_find_node_by_path("/testcase-data/platform-tests"),
-		     "No testcase data in device tree\n"));
-		return;
-
-	if (selftest(!(rc = device_register(&test_bus)),
-		     "testbus registration failed; rc=%i\n", rc));
-		return;
-
-	for_each_child_of_node(np, child) {
-		of_platform_populate(child, match, NULL, &test_bus);
-		for_each_child_of_node(child, grandchild)
-			selftest(of_find_device_by_node(grandchild),
-				 "Could not create device for node '%s'\n",
-				 grandchild->name);
-	}
-
-	of_platform_depopulate(&test_bus);
-	for_each_child_of_node(np, child) {
-		for_each_child_of_node(child, grandchild)
-			selftest(!of_find_device_by_node(grandchild),
-				 "device didn't get destroyed '%s'\n",
-				 grandchild->name);
-	}
-
-	device_unregister(&test_bus);
-	of_node_put(np);
-}
-
-/**
- *	update_node_properties - adds the properties
- *	of np into dup node (present in live tree) and
- *	updates parent of children of np to dup.
- *
- *	@np:	node already present in live tree
- *	@dup:	node present in live tree to be updated
- */
-static void update_node_properties(struct device_node *np,
-					struct device_node *dup)
-{
-	struct property *prop;
-	struct device_node *child;
-
-	for_each_property_of_node(np, prop)
-		of_add_property(dup, prop);
-
-	for_each_child_of_node(np, child)
-		child->parent = dup;
-}
-
-/**
- *	attach_node_and_children - attaches nodes
- *	and its children to live tree
- *
- *	@np:	Node to attach to live tree
- */
-static int attach_node_and_children(struct device_node *np)
-{
-	struct device_node *next, *dup, *child;
-
-	dup = of_find_node_by_path(np->full_name);
-	if (dup) {
-		update_node_properties(np, dup);
-		return 0;
-	}
-
-	/* Children of the root need to be remembered for removal */
-	if (np->parent == of_root) {
-		if (WARN_ON(last_node_index >= NO_OF_NODES))
-			return -EINVAL;
-		nodes[last_node_index++] = np;
-	}
-
-	child = np->child;
-	np->child = NULL;
-	np->sibling = NULL;
-	of_attach_node(np);
-	while (child) {
-		next = child->sibling;
-		attach_node_and_children(child);
-		child = next;
-	}
-
-	return 0;
-}
-
-/**
- *	selftest_data_add - Reads, copies data from
- *	linked tree and attaches it to the live tree
- */
-static int __init selftest_data_add(void)
-{
-	void *selftest_data;
-	struct device_node *selftest_data_node, *np;
-	extern uint8_t __dtb_testcases_begin[];
-	extern uint8_t __dtb_testcases_end[];
-	const int size = __dtb_testcases_end - __dtb_testcases_begin;
-	int rc;
-
-	if (!size) {
-		pr_warn("%s: No testcase data to attach; not running tests\n",
-			__func__);
-		return -ENODATA;
-	}
-
-	/* creating copy */
-	selftest_data = kmemdup(__dtb_testcases_begin, size, GFP_KERNEL);
-
-	if (!selftest_data) {
-		pr_warn("%s: Failed to allocate memory for selftest_data; "
-			"not running tests\n", __func__);
-		return -ENOMEM;
-	}
-	of_fdt_unflatten_tree(selftest_data, &selftest_data_node);
-	if (!selftest_data_node) {
-		pr_warn("%s: No tree to attach; not running tests\n", __func__);
-		return -ENODATA;
-	}
-	of_node_set_flag(selftest_data_node, OF_DETACHED);
-	rc = of_resolve_phandles(selftest_data_node);
-	if (rc) {
-		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
-		return -EINVAL;
-	}
-
-	if (!of_root) {
-		/* enabling flag for removing nodes */
-		selftest_live_tree = true;
-		of_root = selftest_data_node;
-
-		for_each_of_allnodes(np)
-			__of_attach_node_sysfs(np);
-		of_aliases = of_find_node_by_path("/aliases");
-		of_chosen = of_find_node_by_path("/chosen");
-		return 0;
-	}
-
-	/* attach the sub-tree to live tree */
-	np = selftest_data_node->child;
-	while (np) {
-		struct device_node *next = np->sibling;
-		np->parent = of_root;
-		attach_node_and_children(np);
-		np = next;
-	}
-	return 0;
-}
-
-/**
- *	detach_node_and_children - detaches node
- *	and its children from live tree
- *
- *	@np:	Node to detach from live tree
- */
-static void detach_node_and_children(struct device_node *np)
-{
-	while (np->child)
-		detach_node_and_children(np->child);
-	of_detach_node(np);
-}
-
-/**
- *	selftest_data_remove - removes the selftest data
- *	nodes from the live tree
- */
-static void selftest_data_remove(void)
-{
-	struct device_node *np;
-	struct property *prop;
-
-	if (selftest_live_tree) {
-		of_node_put(of_aliases);
-		of_node_put(of_chosen);
-		of_aliases = NULL;
-		of_chosen = NULL;
-		for_each_child_of_node(of_root, np)
-			detach_node_and_children(np);
-		__of_detach_node_sysfs(of_root);
-		of_root = NULL;
-		return;
-	}
-
-	while (last_node_index >= 0) {
-		if (nodes[last_node_index]) {
-			np = of_find_node_by_path(nodes[last_node_index]->full_name);
-			if (strcmp(np->full_name, "/aliases") != 0) {
-				detach_node_and_children(np);
-			} else {
-				for_each_property_of_node(np, prop) {
-					if (strcmp(prop->name, "testcase-alias") == 0)
-						of_remove_property(np, prop);
-				}
-			}
-		}
-		last_node_index--;
-	}
-}
-
-static int __init of_selftest(void)
-{
-	struct device_node *np;
-	int res;
-
-	/* adding data for selftest */
-	res = selftest_data_add();
-	if (res)
-		return res;
-
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
-	if (!np) {
-		pr_info("No testcase data in device tree; not running tests\n");
-		return 0;
-	}
-	of_node_put(np);
-
-	pr_info("start of selftest - you will see error messages\n");
-	of_selftest_check_tree_linkage();
-	of_selftest_check_phandles();
-	of_selftest_find_node_by_name();
-	of_selftest_dynamic();
-	of_selftest_parse_phandle_with_args();
-	of_selftest_property_string();
-	of_selftest_property_copy();
-	of_selftest_changeset();
-	of_selftest_parse_interrupts();
-	of_selftest_parse_interrupts_extended();
-	of_selftest_match_node();
-	of_selftest_platform_populate();
-
-	/* removing selftest data from live tree */
-	selftest_data_remove();
-
-	/* Double check linkage after removing testcase data */
-	of_selftest_check_tree_linkage();
-
-	pr_info("end of selftest - %i passed, %i failed\n",
-		selftest_results.passed, selftest_results.failed);
-
-	return 0;
-}
-late_initcall(of_selftest);
diff --git a/drivers/of/testcase-data/testcases.dts b/drivers/of/testcase-data/testcases.dts
deleted file mode 100644
index 6994e15c24bf..000000000000
--- a/drivers/of/testcase-data/testcases.dts
+++ /dev/null
@@ -1,50 +0,0 @@
-/dts-v1/;
-/ {
-	testcase-data {
-		changeset {
-			prop-update = "hello";
-			prop-remove = "world";
-			node-remove {
-			};
-		};
-	};
-};
-#include "tests-phandle.dtsi"
-#include "tests-interrupts.dtsi"
-#include "tests-match.dtsi"
-#include "tests-platform.dtsi"
-
-/*
- * phandle fixup data - generated by dtc patches that aren't upstream.
- * This data must be regenerated whenever phandle references are modified in
- * the testdata tree.
- *
- * The format of this data may be subject to change. For the time being consider
- * this a kernel-internal data format.
- */
-/ { __local_fixups__ {
-	fixup = "/testcase-data/testcase-device2:interrupt-parent:0",
-		"/testcase-data/testcase-device1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:60",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:52",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:44",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:36",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:24",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:8",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:0",
-		"/testcase-data/interrupts/interrupts1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts0:interrupt-parent:0",
-		"/testcase-data/interrupts/intmap1:interrupt-map:12",
-		"/testcase-data/interrupts/intmap0:interrupt-map:52",
-		"/testcase-data/interrupts/intmap0:interrupt-map:36",
-		"/testcase-data/interrupts/intmap0:interrupt-map:16",
-		"/testcase-data/interrupts/intmap0:interrupt-map:4",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:12",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:0",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:56",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:52",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:40",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:24",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:8",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:0";
-}; };
diff --git a/drivers/of/testcase-data/tests-interrupts.dtsi b/drivers/of/testcase-data/tests-interrupts.dtsi
deleted file mode 100644
index da4695f60351..000000000000
--- a/drivers/of/testcase-data/tests-interrupts.dtsi
+++ /dev/null
@@ -1,71 +0,0 @@
-
-/ {
-	testcase-data {
-		interrupts {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			test_intc0: intc0 {
-				interrupt-controller;
-				#interrupt-cells = <1>;
-			};
-
-			test_intc1: intc1 {
-				interrupt-controller;
-				#interrupt-cells = <3>;
-			};
-
-			test_intc2: intc2 {
-				interrupt-controller;
-				#interrupt-cells = <2>;
-			};
-
-			test_intmap0: intmap0 {
-				#interrupt-cells = <1>;
-				#address-cells = <0>;
-				interrupt-map = <1 &test_intc0 9>,
-						<2 &test_intc1 10 11 12>,
-						<3 &test_intc2 13 14>,
-						<4 &test_intc2 15 16>;
-			};
-
-			test_intmap1: intmap1 {
-				#interrupt-cells = <2>;
-				interrupt-map = <0x5000 1 2 &test_intc0 15>;
-			};
-
-			interrupts0 {
-				interrupt-parent = <&test_intc0>;
-				interrupts = <1>, <2>, <3>, <4>;
-			};
-
-			interrupts1 {
-				interrupt-parent = <&test_intmap0>;
-				interrupts = <1>, <2>, <3>, <4>;
-			};
-
-			interrupts-extended0 {
-				reg = <0x5000 0x100>;
-				interrupts-extended = <&test_intc0 1>,
-						      <&test_intc1 2 3 4>,
-						      <&test_intc2 5 6>,
-						      <&test_intmap0 1>,
-						      <&test_intmap0 2>,
-						      <&test_intmap0 3>,
-						      <&test_intmap1 1 2>;
-			};
-		};
-
-		testcase-device1 {
-			compatible = "testcase-device";
-			interrupt-parent = <&test_intc0>;
-			interrupts = <1>;
-		};
-
-		testcase-device2 {
-			compatible = "testcase-device";
-			interrupt-parent = <&test_intc2>;
-			interrupts = <1>; /* invalid specifier - too short */
-		};
-	};
-
-};
diff --git a/drivers/of/testcase-data/tests-match.dtsi b/drivers/of/testcase-data/tests-match.dtsi
deleted file mode 100644
index c9e541129534..000000000000
--- a/drivers/of/testcase-data/tests-match.dtsi
+++ /dev/null
@@ -1,19 +0,0 @@
-
-/ {
-	testcase-data {
-		match-node {
-			name0 { };
-			name1 { device_type = "type1"; };
-			a { name2 { device_type = "type1"; }; };
-			b { name2 { }; };
-			c { name2 { device_type = "type2"; }; };
-			name3 { compatible = "compat3"; };
-			name4 { compatible = "compat2", "compat3"; };
-			name5 { compatible = "compat2", "compat3"; };
-			name6 { compatible = "compat1", "compat2", "compat3"; };
-			name7 { compatible = "compat2"; device_type = "type1"; };
-			name8 { compatible = "compat2"; device_type = "type1"; };
-			name9 { compatible = "compat2"; };
-		};
-	};
-};
diff --git a/drivers/of/testcase-data/tests-phandle.dtsi b/drivers/of/testcase-data/tests-phandle.dtsi
deleted file mode 100644
index 5b1527e8a7fb..000000000000
--- a/drivers/of/testcase-data/tests-phandle.dtsi
+++ /dev/null
@@ -1,48 +0,0 @@
-
-/ {
-	aliases {
-		testcase-alias = &testcase;
-	};
-
-	testcase: testcase-data {
-		security-password = "password";
-		duplicate-name = "duplicate";
-		duplicate-name { };
-		phandle-tests {
-			provider0: provider0 {
-				#phandle-cells = <0>;
-			};
-
-			provider1: provider1 {
-				#phandle-cells = <1>;
-			};
-
-			provider2: provider2 {
-				#phandle-cells = <2>;
-			};
-
-			provider3: provider3 {
-				#phandle-cells = <3>;
-			};
-
-			consumer-a {
-				phandle-list =	<&provider1 1>,
-						<&provider2 2 0>,
-						<0>,
-						<&provider3 4 4 3>,
-						<&provider2 5 100>,
-						<&provider0>,
-						<&provider1 7>;
-				phandle-list-names = "first", "second", "third";
-
-				phandle-list-bad-phandle = <12345678 0 0>;
-				phandle-list-bad-args = <&provider2 1 0>,
-							<&provider3 0>;
-				empty-property;
-				string-property = "foobar";
-				unterminated-string = [40 41 42 43];
-				unterminated-string-list = "first", "second", [40 41 42 43];
-			};
-		};
-	};
-};
diff --git a/drivers/of/testcase-data/tests-platform.dtsi b/drivers/of/testcase-data/tests-platform.dtsi
deleted file mode 100644
index eb20eeb2b062..000000000000
--- a/drivers/of/testcase-data/tests-platform.dtsi
+++ /dev/null
@@ -1,35 +0,0 @@
-
-/ {
-	testcase-data {
-		platform-tests {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			test-device@0 {
-				compatible = "test-device";
-				reg = <0x0>;
-
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				dev@100 {
-					compatible = "test-sub-device";
-					reg = <0x100>;
-				};
-			};
-
-			test-device@1 {
-				compatible = "test-device";
-				reg = <0x1>;
-
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				dev@100 {
-					compatible = "test-sub-device";
-					reg = <0x100>;
-				};
-			};
-		};
-	};
-};
diff --git a/drivers/of/unittest-data/testcases.dts b/drivers/of/unittest-data/testcases.dts
new file mode 100644
index 000000000000..6994e15c24bf
--- /dev/null
+++ b/drivers/of/unittest-data/testcases.dts
@@ -0,0 +1,50 @@
+/dts-v1/;
+/ {
+	testcase-data {
+		changeset {
+			prop-update = "hello";
+			prop-remove = "world";
+			node-remove {
+			};
+		};
+	};
+};
+#include "tests-phandle.dtsi"
+#include "tests-interrupts.dtsi"
+#include "tests-match.dtsi"
+#include "tests-platform.dtsi"
+
+/*
+ * phandle fixup data - generated by dtc patches that aren't upstream.
+ * This data must be regenerated whenever phandle references are modified in
+ * the testdata tree.
+ *
+ * The format of this data may be subject to change. For the time being consider
+ * this a kernel-internal data format.
+ */
+/ { __local_fixups__ {
+	fixup = "/testcase-data/testcase-device2:interrupt-parent:0",
+		"/testcase-data/testcase-device1:interrupt-parent:0",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:60",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:52",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:44",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:36",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:24",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:8",
+		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:0",
+		"/testcase-data/interrupts/interrupts1:interrupt-parent:0",
+		"/testcase-data/interrupts/interrupts0:interrupt-parent:0",
+		"/testcase-data/interrupts/intmap1:interrupt-map:12",
+		"/testcase-data/interrupts/intmap0:interrupt-map:52",
+		"/testcase-data/interrupts/intmap0:interrupt-map:36",
+		"/testcase-data/interrupts/intmap0:interrupt-map:16",
+		"/testcase-data/interrupts/intmap0:interrupt-map:4",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:12",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:0",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:56",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:52",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:40",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:24",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:8",
+		"/testcase-data/phandle-tests/consumer-a:phandle-list:0";
+}; };
diff --git a/drivers/of/unittest-data/tests-interrupts.dtsi b/drivers/of/unittest-data/tests-interrupts.dtsi
new file mode 100644
index 000000000000..da4695f60351
--- /dev/null
+++ b/drivers/of/unittest-data/tests-interrupts.dtsi
@@ -0,0 +1,71 @@
+
+/ {
+	testcase-data {
+		interrupts {
+			#address-cells = <1>;
+			#size-cells = <1>;
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
+			test_intmap1: intmap1 {
+				#interrupt-cells = <2>;
+				interrupt-map = <0x5000 1 2 &test_intc0 15>;
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
+
+			interrupts-extended0 {
+				reg = <0x5000 0x100>;
+				interrupts-extended = <&test_intc0 1>,
+						      <&test_intc1 2 3 4>,
+						      <&test_intc2 5 6>,
+						      <&test_intmap0 1>,
+						      <&test_intmap0 2>,
+						      <&test_intmap0 3>,
+						      <&test_intmap1 1 2>;
+			};
+		};
+
+		testcase-device1 {
+			compatible = "testcase-device";
+			interrupt-parent = <&test_intc0>;
+			interrupts = <1>;
+		};
+
+		testcase-device2 {
+			compatible = "testcase-device";
+			interrupt-parent = <&test_intc2>;
+			interrupts = <1>; /* invalid specifier - too short */
+		};
+	};
+
+};
diff --git a/drivers/of/unittest-data/tests-match.dtsi b/drivers/of/unittest-data/tests-match.dtsi
new file mode 100644
index 000000000000..c9e541129534
--- /dev/null
+++ b/drivers/of/unittest-data/tests-match.dtsi
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
diff --git a/drivers/of/unittest-data/tests-phandle.dtsi b/drivers/of/unittest-data/tests-phandle.dtsi
new file mode 100644
index 000000000000..5b1527e8a7fb
--- /dev/null
+++ b/drivers/of/unittest-data/tests-phandle.dtsi
@@ -0,0 +1,48 @@
+
+/ {
+	aliases {
+		testcase-alias = &testcase;
+	};
+
+	testcase: testcase-data {
+		security-password = "password";
+		duplicate-name = "duplicate";
+		duplicate-name { };
+		phandle-tests {
+			provider0: provider0 {
+				#phandle-cells = <0>;
+			};
+
+			provider1: provider1 {
+				#phandle-cells = <1>;
+			};
+
+			provider2: provider2 {
+				#phandle-cells = <2>;
+			};
+
+			provider3: provider3 {
+				#phandle-cells = <3>;
+			};
+
+			consumer-a {
+				phandle-list =	<&provider1 1>,
+						<&provider2 2 0>,
+						<0>,
+						<&provider3 4 4 3>,
+						<&provider2 5 100>,
+						<&provider0>,
+						<&provider1 7>;
+				phandle-list-names = "first", "second", "third";
+
+				phandle-list-bad-phandle = <12345678 0 0>;
+				phandle-list-bad-args = <&provider2 1 0>,
+							<&provider3 0>;
+				empty-property;
+				string-property = "foobar";
+				unterminated-string = [40 41 42 43];
+				unterminated-string-list = "first", "second", [40 41 42 43];
+			};
+		};
+	};
+};
diff --git a/drivers/of/unittest-data/tests-platform.dtsi b/drivers/of/unittest-data/tests-platform.dtsi
new file mode 100644
index 000000000000..eb20eeb2b062
--- /dev/null
+++ b/drivers/of/unittest-data/tests-platform.dtsi
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
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
new file mode 100644
index 000000000000..082bb2b6a5ad
--- /dev/null
+++ b/drivers/of/unittest.c
@@ -0,0 +1,969 @@
+/*
+ * Self tests for device tree subsystem
+ */
+
+#define pr_fmt(fmt) "### dt-test ### " fmt
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/hashtable.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+#include "of_private.h"
+
+static struct selftest_results {
+	int passed;
+	int failed;
+} selftest_results;
+
+#define NO_OF_NODES 3
+static struct device_node *nodes[NO_OF_NODES];
+static int last_node_index;
+static bool selftest_live_tree;
+
+#define selftest(result, fmt, ...) ({ \
+	bool failed = !(result); \
+	if (failed) { \
+		selftest_results.failed++; \
+		pr_err("FAIL %s():%i " fmt, __func__, __LINE__, ##__VA_ARGS__); \
+	} else { \
+		selftest_results.passed++; \
+		pr_debug("pass %s():%i\n", __func__, __LINE__); \
+	} \
+	failed; \
+})
+
+static void __init of_selftest_find_node_by_name(void)
+{
+	struct device_node *np;
+
+	np = of_find_node_by_path("/testcase-data");
+	selftest(np && !strcmp("/testcase-data", np->full_name),
+		"find /testcase-data failed\n");
+	of_node_put(np);
+
+	/* Test if trailing '/' works */
+	np = of_find_node_by_path("/testcase-data/");
+	selftest(!np, "trailing '/' on /testcase-data/ should fail\n");
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
+	/* Test if trailing '/' works on aliases */
+	np = of_find_node_by_path("testcase-alias/");
+	selftest(!np, "trailing '/' on testcase-alias/ should fail\n");
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
+static void __init of_selftest_dynamic(void)
+{
+	struct device_node *np;
+	struct property *prop;
+
+	np = of_find_node_by_path("/testcase-data");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	/* Array of 4 properties for the purpose of testing */
+	prop = kzalloc(sizeof(*prop) * 4, GFP_KERNEL);
+	if (!prop) {
+		selftest(0, "kzalloc() failed\n");
+		return;
+	}
+
+	/* Add a new property - should pass*/
+	prop->name = "new-property";
+	prop->value = "new-property-data";
+	prop->length = strlen(prop->value);
+	selftest(of_add_property(np, prop) == 0, "Adding a new property failed\n");
+
+	/* Try to add an existing property - should fail */
+	prop++;
+	prop->name = "new-property";
+	prop->value = "new-property-data-should-fail";
+	prop->length = strlen(prop->value);
+	selftest(of_add_property(np, prop) != 0,
+		 "Adding an existing property should have failed\n");
+
+	/* Try to modify an existing property - should pass */
+	prop->value = "modify-property-data-should-pass";
+	prop->length = strlen(prop->value);
+	selftest(of_update_property(np, prop) == 0,
+		 "Updating an existing property should have passed\n");
+
+	/* Try to modify non-existent property - should pass*/
+	prop++;
+	prop->name = "modify-property";
+	prop->value = "modify-missing-property-data-should-pass";
+	prop->length = strlen(prop->value);
+	selftest(of_update_property(np, prop) == 0,
+		 "Updating a missing property should have passed\n");
+
+	/* Remove property - should pass */
+	selftest(of_remove_property(np, prop) == 0,
+		 "Removing a property should have passed\n");
+
+	/* Adding very large property - should pass */
+	prop++;
+	prop->name = "large-property-PAGE_SIZEx8";
+	prop->length = PAGE_SIZE * 8;
+	prop->value = kzalloc(prop->length, GFP_KERNEL);
+	selftest(prop->value != NULL, "Unable to allocate large buffer\n");
+	if (prop->value)
+		selftest(of_add_property(np, prop) == 0,
+			 "Adding a large property should have passed\n");
+}
+
+static int __init of_selftest_check_node_linkage(struct device_node *np)
+{
+	struct device_node *child;
+	int count = 0, rc;
+
+	for_each_child_of_node(np, child) {
+		if (child->parent != np) {
+			pr_err("Child node %s links to wrong parent %s\n",
+				 child->name, np->name);
+			return -EINVAL;
+		}
+
+		rc = of_selftest_check_node_linkage(child);
+		if (rc < 0)
+			return rc;
+		count += rc;
+	}
+
+	return count + 1;
+}
+
+static void __init of_selftest_check_tree_linkage(void)
+{
+	struct device_node *np;
+	int allnode_count = 0, child_count;
+
+	if (!of_root)
+		return;
+
+	for_each_of_allnodes(np)
+		allnode_count++;
+	child_count = of_selftest_check_node_linkage(of_root);
+
+	selftest(child_count > 0, "Device node data structure is corrupted\n");
+	selftest(child_count == allnode_count, "allnodes list size (%i) doesn't match"
+		 "sibling lists size (%i)\n", allnode_count, child_count);
+	pr_debug("allnodes list size (%i); sibling lists size (%i)\n", allnode_count, child_count);
+}
+
+struct node_hash {
+	struct hlist_node node;
+	struct device_node *np;
+};
+
+static DEFINE_HASHTABLE(phandle_ht, 8);
+static void __init of_selftest_check_phandles(void)
+{
+	struct device_node *np;
+	struct node_hash *nh;
+	struct hlist_node *tmp;
+	int i, dup_count = 0, phandle_count = 0;
+
+	for_each_of_allnodes(np) {
+		if (!np->phandle)
+			continue;
+
+		hash_for_each_possible(phandle_ht, nh, node, np->phandle) {
+			if (nh->np->phandle == np->phandle) {
+				pr_info("Duplicate phandle! %i used by %s and %s\n",
+					np->phandle, nh->np->full_name, np->full_name);
+				dup_count++;
+				break;
+			}
+		}
+
+		nh = kzalloc(sizeof(*nh), GFP_KERNEL);
+		if (WARN_ON(!nh))
+			return;
+
+		nh->np = np;
+		hash_add(phandle_ht, &nh->node, np->phandle);
+		phandle_count++;
+	}
+	selftest(dup_count == 0, "Found %i duplicates in %i phandles\n",
+		 dup_count, phandle_count);
+
+	/* Clean up */
+	hash_for_each_safe(phandle_ht, i, tmp, nh, node) {
+		hash_del(&nh->node);
+		kfree(nh);
+	}
+}
+
+static void __init of_selftest_parse_phandle_with_args(void)
+{
+	struct device_node *np;
+	struct of_phandle_args args;
+	int i, rc;
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
+	selftest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+
+	for (i = 0; i < 8; i++) {
+		bool passed = true;
+		rc = of_parse_phandle_with_args(np, "phandle-list",
+						"#phandle-cells", i, &args);
+
+		/* Test the values from tests-phandle.dtsi */
+		switch (i) {
+		case 0:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == (i + 1));
+			break;
+		case 1:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 0);
+			break;
+		case 2:
+			passed &= (rc == -ENOENT);
+			break;
+		case 3:
+			passed &= !rc;
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 4);
+			passed &= (args.args[2] == 3);
+			break;
+		case 4:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 100);
+			break;
+		case 5:
+			passed &= !rc;
+			passed &= (args.args_count == 0);
+			break;
+		case 6:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == (i + 1));
+			break;
+		case 7:
+			passed &= (rc == -ENOENT);
+			break;
+		default:
+			passed = false;
+		}
+
+		selftest(passed, "index %i - data error on node %s rc=%i\n",
+			 i, args.np->full_name, rc);
+	}
+
+	/* Check for missing list property */
+	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells", 0, &args);
+	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells");
+	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
+
+	/* Check for missing cells property */
+	rc = of_parse_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing", 0, &args);
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+
+	/* Check for bad phandle in list */
+	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells", 0, &args);
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+
+	/* Check for incorrectly formed argument list */
+	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells", 1, &args);
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+}
+
+static void __init of_selftest_property_string(void)
+{
+	const char *strings[4];
+	struct device_node *np;
+	int rc;
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_err("No testcase data in device tree\n");
+		return;
+	}
+
+	rc = of_property_match_string(np, "phandle-list-names", "first");
+	selftest(rc == 0, "first expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "second");
+	selftest(rc == 1, "second expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "third");
+	selftest(rc == 2, "third expected:0 got:%i\n", rc);
+	rc = of_property_match_string(np, "phandle-list-names", "fourth");
+	selftest(rc == -ENODATA, "unmatched string; rc=%i\n", rc);
+	rc = of_property_match_string(np, "missing-property", "blah");
+	selftest(rc == -EINVAL, "missing property; rc=%i\n", rc);
+	rc = of_property_match_string(np, "empty-property", "blah");
+	selftest(rc == -ENODATA, "empty property; rc=%i\n", rc);
+	rc = of_property_match_string(np, "unterminated-string", "blah");
+	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
+
+	/* of_property_count_strings() tests */
+	rc = of_property_count_strings(np, "string-property");
+	selftest(rc == 1, "Incorrect string count; rc=%i\n", rc);
+	rc = of_property_count_strings(np, "phandle-list-names");
+	selftest(rc == 3, "Incorrect string count; rc=%i\n", rc);
+	rc = of_property_count_strings(np, "unterminated-string");
+	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
+	rc = of_property_count_strings(np, "unterminated-string-list");
+	selftest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
+
+	/* of_property_read_string_index() tests */
+	rc = of_property_read_string_index(np, "string-property", 0, strings);
+	selftest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);
+	strings[0] = NULL;
+	rc = of_property_read_string_index(np, "string-property", 1, strings);
+	selftest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
+	rc = of_property_read_string_index(np, "phandle-list-names", 0, strings);
+	selftest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
+	rc = of_property_read_string_index(np, "phandle-list-names", 1, strings);
+	selftest(rc == 0 && !strcmp(strings[0], "second"), "of_property_read_string_index() failure; rc=%i\n", rc);
+	rc = of_property_read_string_index(np, "phandle-list-names", 2, strings);
+	selftest(rc == 0 && !strcmp(strings[0], "third"), "of_property_read_string_index() failure; rc=%i\n", rc);
+	strings[0] = NULL;
+	rc = of_property_read_string_index(np, "phandle-list-names", 3, strings);
+	selftest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
+	strings[0] = NULL;
+	rc = of_property_read_string_index(np, "unterminated-string", 0, strings);
+	selftest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
+	rc = of_property_read_string_index(np, "unterminated-string-list", 0, strings);
+	selftest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
+	strings[0] = NULL;
+	rc = of_property_read_string_index(np, "unterminated-string-list", 2, strings); /* should fail */
+	selftest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
+	strings[1] = NULL;
+
+	/* of_property_read_string_array() tests */
+	rc = of_property_read_string_array(np, "string-property", strings, 4);
+	selftest(rc == 1, "Incorrect string count; rc=%i\n", rc);
+	rc = of_property_read_string_array(np, "phandle-list-names", strings, 4);
+	selftest(rc == 3, "Incorrect string count; rc=%i\n", rc);
+	rc = of_property_read_string_array(np, "unterminated-string", strings, 4);
+	selftest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
+	/* -- An incorrectly formed string should cause a failure */
+	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 4);
+	selftest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
+	/* -- parsing the correctly formed strings should still work: */
+	strings[2] = NULL;
+	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 2);
+	selftest(rc == 2 && strings[2] == NULL, "of_property_read_string_array() failure; rc=%i\n", rc);
+	strings[1] = NULL;
+	rc = of_property_read_string_array(np, "phandle-list-names", strings, 1);
+	selftest(rc == 1 && strings[1] == NULL, "Overwrote end of string array; rc=%i, str='%s'\n", rc, strings[1]);
+}
+
+#define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
+			(p1)->value && (p2)->value && \
+			!memcmp((p1)->value, (p2)->value, (p1)->length) && \
+			!strcmp((p1)->name, (p2)->name))
+static void __init of_selftest_property_copy(void)
+{
+#ifdef CONFIG_OF_DYNAMIC
+	struct property p1 = { .name = "p1", .length = 0, .value = "" };
+	struct property p2 = { .name = "p2", .length = 5, .value = "abcd" };
+	struct property *new;
+
+	new = __of_prop_dup(&p1, GFP_KERNEL);
+	selftest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
+	kfree(new->value);
+	kfree(new->name);
+	kfree(new);
+
+	new = __of_prop_dup(&p2, GFP_KERNEL);
+	selftest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
+	kfree(new->value);
+	kfree(new->name);
+	kfree(new);
+#endif
+}
+
+static void __init of_selftest_changeset(void)
+{
+#ifdef CONFIG_OF_DYNAMIC
+	struct property *ppadd, padd = { .name = "prop-add", .length = 0, .value = "" };
+	struct property *ppupdate, pupdate = { .name = "prop-update", .length = 5, .value = "abcd" };
+	struct property *ppremove;
+	struct device_node *n1, *n2, *n21, *nremove, *parent;
+	struct of_changeset chgset;
+
+	of_changeset_init(&chgset);
+	n1 = __of_node_alloc("/testcase-data/changeset/n1", GFP_KERNEL);
+	selftest(n1, "testcase setup failure\n");
+	n2 = __of_node_alloc("/testcase-data/changeset/n2", GFP_KERNEL);
+	selftest(n2, "testcase setup failure\n");
+	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21", GFP_KERNEL);
+	selftest(n21, "testcase setup failure %p\n", n21);
+	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove");
+	selftest(nremove, "testcase setup failure\n");
+	ppadd = __of_prop_dup(&padd, GFP_KERNEL);
+	selftest(ppadd, "testcase setup failure\n");
+	ppupdate = __of_prop_dup(&pupdate, GFP_KERNEL);
+	selftest(ppupdate, "testcase setup failure\n");
+	parent = nremove->parent;
+	n1->parent = parent;
+	n2->parent = parent;
+	n21->parent = n2;
+	n2->child = n21;
+	ppremove = of_find_property(parent, "prop-remove", NULL);
+	selftest(ppremove, "failed to find removal prop");
+
+	of_changeset_init(&chgset);
+	selftest(!of_changeset_attach_node(&chgset, n1), "fail attach n1\n");
+	selftest(!of_changeset_attach_node(&chgset, n2), "fail attach n2\n");
+	selftest(!of_changeset_detach_node(&chgset, nremove), "fail remove node\n");
+	selftest(!of_changeset_attach_node(&chgset, n21), "fail attach n21\n");
+	selftest(!of_changeset_add_property(&chgset, parent, ppadd), "fail add prop\n");
+	selftest(!of_changeset_update_property(&chgset, parent, ppupdate), "fail update prop\n");
+	selftest(!of_changeset_remove_property(&chgset, parent, ppremove), "fail remove prop\n");
+	mutex_lock(&of_mutex);
+	selftest(!of_changeset_apply(&chgset), "apply failed\n");
+	mutex_unlock(&of_mutex);
+
+	mutex_lock(&of_mutex);
+	selftest(!of_changeset_revert(&chgset), "revert failed\n");
+	mutex_unlock(&of_mutex);
+
+	of_changeset_destroy(&chgset);
+#endif
+}
+
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
+static void __init of_selftest_parse_interrupts_extended(void)
+{
+	struct device_node *np;
+	struct of_phandle_args args;
+	int i, rc;
+
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	for (i = 0; i < 7; i++) {
+		bool passed = true;
+		rc = of_irq_parse_one(np, i, &args);
+
+		/* Test the values from tests-phandle.dtsi */
+		switch (i) {
+		case 0:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == 1);
+			break;
+		case 1:
+			passed &= !rc;
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == 2);
+			passed &= (args.args[1] == 3);
+			passed &= (args.args[2] == 4);
+			break;
+		case 2:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == 5);
+			passed &= (args.args[1] == 6);
+			break;
+		case 3:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == 9);
+			break;
+		case 4:
+			passed &= !rc;
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == 10);
+			passed &= (args.args[1] == 11);
+			passed &= (args.args[2] == 12);
+			break;
+		case 5:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == 13);
+			passed &= (args.args[1] == 14);
+			break;
+		case 6:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == 15);
+			break;
+		default:
+			passed = false;
+		}
+
+		selftest(passed, "index %i - data error on node %s rc=%i\n",
+			 i, args.np->full_name, rc);
+	}
+	of_node_put(np);
+}
+
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
+struct device test_bus = {
+	.init_name = "unittest-bus",
+};
+static void __init of_selftest_platform_populate(void)
+{
+	int irq, rc;
+	struct device_node *np, *child, *grandchild;
+	struct platform_device *pdev;
+	struct of_device_id match[] = {
+		{ .compatible = "test-device", },
+		{}
+	};
+
+	np = of_find_node_by_path("/testcase-data");
+	of_platform_populate(np, of_default_bus_match_table, NULL, NULL);
+
+	/* Test that a missing irq domain returns -EPROBE_DEFER */
+	np = of_find_node_by_path("/testcase-data/testcase-device1");
+	pdev = of_find_device_by_node(np);
+	selftest(pdev, "device 1 creation failed\n");
+
+	irq = platform_get_irq(pdev, 0);
+	selftest(irq == -EPROBE_DEFER, "device deferred probe failed - %d\n", irq);
+
+	/* Test that a parsing failure does not return -EPROBE_DEFER */
+	np = of_find_node_by_path("/testcase-data/testcase-device2");
+	pdev = of_find_device_by_node(np);
+	selftest(pdev, "device 2 creation failed\n");
+	irq = platform_get_irq(pdev, 0);
+	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
+
+	if (selftest(np = of_find_node_by_path("/testcase-data/platform-tests"),
+		     "No testcase data in device tree\n"));
+		return;
+
+	if (selftest(!(rc = device_register(&test_bus)),
+		     "testbus registration failed; rc=%i\n", rc));
+		return;
+
+	for_each_child_of_node(np, child) {
+		of_platform_populate(child, match, NULL, &test_bus);
+		for_each_child_of_node(child, grandchild)
+			selftest(of_find_device_by_node(grandchild),
+				 "Could not create device for node '%s'\n",
+				 grandchild->name);
+	}
+
+	of_platform_depopulate(&test_bus);
+	for_each_child_of_node(np, child) {
+		for_each_child_of_node(child, grandchild)
+			selftest(!of_find_device_by_node(grandchild),
+				 "device didn't get destroyed '%s'\n",
+				 grandchild->name);
+	}
+
+	device_unregister(&test_bus);
+	of_node_put(np);
+}
+
+/**
+ *	update_node_properties - adds the properties
+ *	of np into dup node (present in live tree) and
+ *	updates parent of children of np to dup.
+ *
+ *	@np:	node already present in live tree
+ *	@dup:	node present in live tree to be updated
+ */
+static void update_node_properties(struct device_node *np,
+					struct device_node *dup)
+{
+	struct property *prop;
+	struct device_node *child;
+
+	for_each_property_of_node(np, prop)
+		of_add_property(dup, prop);
+
+	for_each_child_of_node(np, child)
+		child->parent = dup;
+}
+
+/**
+ *	attach_node_and_children - attaches nodes
+ *	and its children to live tree
+ *
+ *	@np:	Node to attach to live tree
+ */
+static int attach_node_and_children(struct device_node *np)
+{
+	struct device_node *next, *dup, *child;
+
+	dup = of_find_node_by_path(np->full_name);
+	if (dup) {
+		update_node_properties(np, dup);
+		return 0;
+	}
+
+	/* Children of the root need to be remembered for removal */
+	if (np->parent == of_root) {
+		if (WARN_ON(last_node_index >= NO_OF_NODES))
+			return -EINVAL;
+		nodes[last_node_index++] = np;
+	}
+
+	child = np->child;
+	np->child = NULL;
+	np->sibling = NULL;
+	of_attach_node(np);
+	while (child) {
+		next = child->sibling;
+		attach_node_and_children(child);
+		child = next;
+	}
+
+	return 0;
+}
+
+/**
+ *	selftest_data_add - Reads, copies data from
+ *	linked tree and attaches it to the live tree
+ */
+static int __init selftest_data_add(void)
+{
+	void *selftest_data;
+	struct device_node *selftest_data_node, *np;
+	extern uint8_t __dtb_testcases_begin[];
+	extern uint8_t __dtb_testcases_end[];
+	const int size = __dtb_testcases_end - __dtb_testcases_begin;
+	int rc;
+
+	if (!size) {
+		pr_warn("%s: No testcase data to attach; not running tests\n",
+			__func__);
+		return -ENODATA;
+	}
+
+	/* creating copy */
+	selftest_data = kmemdup(__dtb_testcases_begin, size, GFP_KERNEL);
+
+	if (!selftest_data) {
+		pr_warn("%s: Failed to allocate memory for selftest_data; "
+			"not running tests\n", __func__);
+		return -ENOMEM;
+	}
+	of_fdt_unflatten_tree(selftest_data, &selftest_data_node);
+	if (!selftest_data_node) {
+		pr_warn("%s: No tree to attach; not running tests\n", __func__);
+		return -ENODATA;
+	}
+	of_node_set_flag(selftest_data_node, OF_DETACHED);
+	rc = of_resolve_phandles(selftest_data_node);
+	if (rc) {
+		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
+		return -EINVAL;
+	}
+
+	if (!of_root) {
+		/* enabling flag for removing nodes */
+		selftest_live_tree = true;
+		of_root = selftest_data_node;
+
+		for_each_of_allnodes(np)
+			__of_attach_node_sysfs(np);
+		of_aliases = of_find_node_by_path("/aliases");
+		of_chosen = of_find_node_by_path("/chosen");
+		return 0;
+	}
+
+	/* attach the sub-tree to live tree */
+	np = selftest_data_node->child;
+	while (np) {
+		struct device_node *next = np->sibling;
+		np->parent = of_root;
+		attach_node_and_children(np);
+		np = next;
+	}
+	return 0;
+}
+
+/**
+ *	detach_node_and_children - detaches node
+ *	and its children from live tree
+ *
+ *	@np:	Node to detach from live tree
+ */
+static void detach_node_and_children(struct device_node *np)
+{
+	while (np->child)
+		detach_node_and_children(np->child);
+	of_detach_node(np);
+}
+
+/**
+ *	selftest_data_remove - removes the selftest data
+ *	nodes from the live tree
+ */
+static void selftest_data_remove(void)
+{
+	struct device_node *np;
+	struct property *prop;
+
+	if (selftest_live_tree) {
+		of_node_put(of_aliases);
+		of_node_put(of_chosen);
+		of_aliases = NULL;
+		of_chosen = NULL;
+		for_each_child_of_node(of_root, np)
+			detach_node_and_children(np);
+		__of_detach_node_sysfs(of_root);
+		of_root = NULL;
+		return;
+	}
+
+	while (last_node_index >= 0) {
+		if (nodes[last_node_index]) {
+			np = of_find_node_by_path(nodes[last_node_index]->full_name);
+			if (strcmp(np->full_name, "/aliases") != 0) {
+				detach_node_and_children(np);
+			} else {
+				for_each_property_of_node(np, prop) {
+					if (strcmp(prop->name, "testcase-alias") == 0)
+						of_remove_property(np, prop);
+				}
+			}
+		}
+		last_node_index--;
+	}
+}
+
+static int __init of_selftest(void)
+{
+	struct device_node *np;
+	int res;
+
+	/* adding data for selftest */
+	res = selftest_data_add();
+	if (res)
+		return res;
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_info("No testcase data in device tree; not running tests\n");
+		return 0;
+	}
+	of_node_put(np);
+
+	pr_info("start of selftest - you will see error messages\n");
+	of_selftest_check_tree_linkage();
+	of_selftest_check_phandles();
+	of_selftest_find_node_by_name();
+	of_selftest_dynamic();
+	of_selftest_parse_phandle_with_args();
+	of_selftest_property_string();
+	of_selftest_property_copy();
+	of_selftest_changeset();
+	of_selftest_parse_interrupts();
+	of_selftest_parse_interrupts_extended();
+	of_selftest_match_node();
+	of_selftest_platform_populate();
+
+	/* removing selftest data from live tree */
+	selftest_data_remove();
+
+	/* Double check linkage after removing testcase data */
+	of_selftest_check_tree_linkage();
+
+	pr_info("end of selftest - %i passed, %i failed\n",
+		selftest_results.passed, selftest_results.failed);
+
+	return 0;
+}
+late_initcall(of_selftest);
-- 
1.9.1

