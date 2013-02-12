Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab3BLSVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:21:36 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52321 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab3BLSTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH V2 2/3] of: Create function for counting number of phandles in a property
Date: Tue, 12 Feb 2013 17:59:40 +0000
Message-Id: <1360691981-21837-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360691981-21837-1-git-send-email-grant.likely@secretlab.ca>
References: <1360691981-21837-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates of_count_phandle_with_args(), a new function for
counting the number of phandle+argument tuples in a given property. This
is better than the existing method of parsing each phandle individually
until parsing fails which is a horribly slow way to do the count.

It also converts of_gpio_named_count() to use the new function instead
of using the above described horrible method.

This also requires the return value of of_gpio_count() &
of_gpio_named_count() from 'unsigned int' to 'int' so that it can return
an error code. All the users of that function are fixed up to correctly
handle a negative return value.

Tested on ARM using the selftest code.

v2: - fix bug where of_parse_phandle_with_args() could behave like _count_.
    - made of_gpio_named_count() into a static inline regardless of CONFIG_OF_GPIO

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andreas Larsson <andreas@gaisler.com>
---
 drivers/of/base.c     |   56 ++++++++++++++++++++++++++++++++++++++++++-------
 drivers/of/selftest.c |   25 ++++++++++++++++++++--
 include/linux/of.h    |    9 ++++++++
 3 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e2d44e0..adaa815 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1082,12 +1082,13 @@ EXPORT_SYMBOL(of_parse_phandle);
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
-	int size, cur_index = 0;
+	int rc = 0, size, cur_index = 0;
 	uint32_t count = 0;
 	struct device_node *node = NULL;
 	phandle phandle;
@@ -1116,12 +1117,14 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 			if (!node) {
 				pr_err("%s: could not find phandle\n",
 					 np->full_name);
+				rc = -EINVAL;
 				break;
 			}
 			if (of_property_read_u32(node, cells_name, &count)) {
 				pr_err("%s: could not get %s for %s\n",
 					 np->full_name, cells_name,
 					 node->full_name);
+				rc = -EINVAL;
 				break;
 			}
 
@@ -1132,6 +1135,7 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 			if (list + count > list_end) {
 				pr_err("%s: arguments longer than property\n",
 					 np->full_name);
+				rc = -EINVAL;
 				break;
 			}
 		}
@@ -1143,8 +1147,10 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 		 * or return -ENOENT for an empty entry.
 		 */
 		if (cur_index == index) {
-			if (!phandle)
-				return -ENOENT;
+			if (!phandle) {
+				rc = -ENOENT;
+				break;
+			}
 
 			if (out_args) {
 				int i;
@@ -1155,22 +1161,56 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 				for (i = 0; i < count; i++)
 					out_args->args[i] = be32_to_cpup(list++);
 			}
-			return 0;
+
+			rc = 0;
+			break;
 		}
 
 		of_node_put(node);
 		node = NULL;
 		list += count;
 		cur_index++;
+		rc = cur_index;
 	}
 
 	/* Loop exited without finding a valid entry; return an error */
 	if (node)
 		of_node_put(node);
-	return -EINVAL;
+	return index < 0 ? rc : -ENOENT;
+}
+
+int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
+				const char *cells_name, int index,
+				struct of_phandle_args *out_args)
+{
+	if (index < 0)
+		return -EINVAL;
+	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args);
 }
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
index 9f62eb5..9c44491 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -35,6 +35,11 @@ static void __init of_selftest_parse_phandle_with_args(void)
 		return;
 	}
 
+	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
+	if (rc != 7)
+		pr_err("of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	passed_all &= (rc == 7);
+
 	for (i = 0; i < 8; i++) {
 		bool passed = true;
 		rc = of_parse_phandle_with_args(np, "phandle-list",
@@ -79,7 +84,7 @@ static void __init of_selftest_parse_phandle_with_args(void)
 			passed &= (args.args[0] == (i + 1));
 			break;
 		case 7:
-			passed &= (rc == -EINVAL);
+			passed &= (rc == -ENOENT);
 			break;
 		default:
 			passed = false;
@@ -100,22 +105,38 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	/* Check for missing list property */
 	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
 					"#phandle-cells", 0, &args);
-	passed_all &= (rc == -EINVAL);
+	passed_all &= (rc == -ENOENT);
+	rc = of_count_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells");
+	passed_all &= (rc == -ENOENT);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for missing cells property */
 	rc = of_parse_phandle_with_args(np, "phandle-list",
 					"#phandle-cells-missing", 0, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for bad phandle in list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
 					"#phandle-cells", 0, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for incorrectly formed argument list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
 					"#phandle-cells", 1, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	pr_info("end - %s\n", passed_all ? "PASS" : "FAIL");
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index b9e1b91..f8a088c 100644
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
 
+static inline int of_parse_count_with_args(struct device_node *np,
+					   const char *list_name,
+					   const char *cells_name)
+{
+	return -ENOSYS;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
-- 
1.7.10.4

