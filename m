Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab3BLXH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:07:56 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:64808 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893Ab3BLXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:06:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH v3 4/5] of: Create function for counting number of phandles in a property
Date: Tue, 12 Feb 2013 23:06:40 +0000
Message-Id: <1360710401-16757-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
References: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates of_count_phandle_with_args(), a new function for
counting the number of phandle+argument tuples in a given property. This
is better than the existing method of parsing each phandle individually
until parsing fails which is a horribly slow way to do the count.

Tested on ARM using the selftest code.

v3: - Rebased on top of selftest code cleanup patch
v2: - fix bug where of_parse_phandle_with_args() could behave like _count_.
    - made of_gpio_named_count() into a static inline regardless of CONFIG_OF_GPIO

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andreas Larsson <andreas@gaisler.com>
---
 drivers/of/base.c     |   41 +++++++++++++++++++++++++++++++++++++----
 drivers/of/selftest.c |   15 +++++++++++++++
 include/linux/of.h    |    9 +++++++++
 3 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c4538ab..f21794c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1082,9 +1082,10 @@ EXPORT_SYMBOL(of_parse_phandle);
  * To get a device_node of the `node2' node you may call this:
  * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
  */
-int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
-				const char *cells_name, int index,
-				struct of_phandle_args *out_args)
+static int __of_parse_phandle_with_args(const struct device_node *np,
+					const char *list_name,
+					const char *cells_name, int index,
+					struct of_phandle_args *out_args)
 {
 	const __be32 *list, *list_end;
 	int rc = 0, size, cur_index = 0;
@@ -1174,15 +1175,47 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 	 * Unlock node before returning result; will be one of:
 	 * -ENOENT : index is for empty phandle
 	 * -EINVAL : parsing error on data
+	 * [1..n]  : Number of phandle (count mode; when index = -1)
 	 */
-	rc = -ENOENT;
+	rc = index < 0 ? cur_index : -ENOENT;
  err:
 	if (node)
 		of_node_put(node);
 	return rc;
 }
+
+int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
+				const char *cells_name, int index,
+				struct of_phandle_args *out_args)
+{
+	if (index < 0)
+		return -EINVAL;
+	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args);
+}
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
+/**
+ * of_count_phandle_with_args() - Find the number of phandles references in a property
+ * @np:		pointer to a device tree node containing a list
+ * @list_name:	property name that contains a list
+ * @cells_name:	property name that specifies phandles' arguments count
+ *
+ * Returns the number of phandle + argument tuples within a property. It
+ * is a typical pattern to encode a list of phandle and variable
+ * arguments into a single property. The number of arguments is encoded
+ * by a property in the phandle-target node. For example, a gpios
+ * property would contain a list of GPIO specifies consisting of a
+ * phandle and 1 or more arguments. The number of arguments are
+ * determined by the #gpio-cells property in the node pointed to by the
+ * phandle.
+ */
+int of_count_phandle_with_args(const struct device_node *np, const char *list_name,
+				const char *cells_name)
+{
+	return __of_parse_phandle_with_args(np, list_name, cells_name, -1, NULL);
+}
+EXPORT_SYMBOL(of_count_phandle_with_args);
+
 #if defined(CONFIG_OF_DYNAMIC)
 static int of_property_notify(int action, struct device_node *np,
 			      struct property *prop)
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 01b4174..0eb5c38 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -36,6 +36,9 @@ static void __init of_selftest_parse_phandle_with_args(void)
 		return;
 	}
 
+	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
+	selftest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
+
 	for (i = 0; i < 8; i++) {
 		bool passed = true;
 		rc = of_parse_phandle_with_args(np, "phandle-list",
@@ -94,21 +97,33 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
 					"#phandle-cells", 0, &args);
 	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells");
+	selftest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
 
 	/* Check for missing cells property */
 	rc = of_parse_phandle_with_args(np, "phandle-list",
 					"#phandle-cells-missing", 0, &args);
 	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for bad phandle in list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
 					"#phandle-cells", 0, &args);
 	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	/* Check for incorrectly formed argument list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
 					"#phandle-cells", 1, &args);
 	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells");
+	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 }
 
 static void __init of_selftest_property_match_string(void)
diff --git a/include/linux/of.h b/include/linux/of.h
index b9e1b91..a0f1292 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -277,6 +277,8 @@ extern struct device_node *of_parse_phandle(const struct device_node *np,
 extern int of_parse_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
+extern int of_count_phandle_with_args(const struct device_node *np,
+	const char *list_name, const char *cells_name);
 
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
@@ -467,6 +469,13 @@ static inline int of_parse_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_count_phandle_with_args(struct device_node *np,
+					     const char *list_name,
+					     const char *cells_name)
+{
+	return -ENOSYS;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
-- 
1.7.10.4

