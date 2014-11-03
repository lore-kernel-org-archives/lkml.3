Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaKCXie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:38:34 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50896 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKCXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:38:31 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <darren.hart@intel.com>, <stable@vger.kernel.org>
Subject: [PATCH] of: Fix overflow bug in string property parsing functions
Date: Mon,  3 Nov 2014 23:38:24 +0000
Message-Id: <1415057904-6187-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The string property read helpers will run off the end of the buffer if
it is handed a malformed string property. Rework the parsers to make
sure that doesn't happen. At the same time add new test cases to make
sure the functions behave themselves.

The original implementations of of_property_read_string_index() and
of_property_count_strings() both open-coded the same block of parsing
code, each with it's own subtly different bugs. The fix here merges
functions into a single helper and makes the original functions static
inline wrappers around the helper.

One non-bugfix aspect of this patch is the addition of a new wrapper,
of_property_read_string_array(). The new wrapper is needed by the
device_properties feature that Rafael is working on and planning to
merge for v3.19. The implementation is identical both with and without
the new static inline wrapper, so it just got left in to reduce the
churn on the header file.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <darren.hart@intel.com>
Cc: <stable@vger.kernel.org>  # v3.3+: Drop selftest hunks that don't apply
---

I'd like to get this into v3.18 in the next week. Please shout if you
have any objections.

 drivers/of/base.c                           | 88 ++++++++---------------------
 drivers/of/selftest.c                       | 66 ++++++++++++++++++++--
 drivers/of/testcase-data/tests-phandle.dtsi |  2 +
 include/linux/of.h                          | 84 ++++++++++++++++++++++-----
 4 files changed, 154 insertions(+), 86 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2305dc0382bc..3823edf2d012 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1280,52 +1280,6 @@ int of_property_read_string(struct device_node *np, const char *propname,
 EXPORT_SYMBOL_GPL(of_property_read_string);
 
 /**
- * of_property_read_string_index - Find and read a string from a multiple
- * strings property.
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- * @index:	index of the string in the list of strings
- * @out_string:	pointer to null terminated return string, modified only if
- *		return value is 0.
- *
- * Search for a property in a device tree node and retrieve a null
- * terminated string value (pointer to data, not a copy) in the list of strings
- * contained in that property.
- * Returns 0 on success, -EINVAL if the property does not exist, -ENODATA if
- * property does not have a value, and -EILSEQ if the string is not
- * null-terminated within the length of the property data.
- *
- * The out_string pointer is modified only if a valid string can be decoded.
- */
-int of_property_read_string_index(struct device_node *np, const char *propname,
-				  int index, const char **output)
-{
-	struct property *prop = of_find_property(np, propname, NULL);
-	int i = 0;
-	size_t l = 0, total = 0;
-	const char *p;
-
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if (strnlen(prop->value, prop->length) >= prop->length)
-		return -EILSEQ;
-
-	p = prop->value;
-
-	for (i = 0; total < prop->length; total += l, p += l) {
-		l = strlen(p) + 1;
-		if (i++ == index) {
-			*output = p;
-			return 0;
-		}
-	}
-	return -ENODATA;
-}
-EXPORT_SYMBOL_GPL(of_property_read_string_index);
-
-/**
  * of_property_match_string() - Find string in a list and return index
  * @np: pointer to node containing string list property
  * @propname: string list property name
@@ -1351,7 +1305,7 @@ int of_property_match_string(struct device_node *np, const char *propname,
 	end = p + prop->length;
 
 	for (i = 0; p < end; i++, p += l) {
-		l = strlen(p) + 1;
+		l = strnlen(p, end - p) + 1;
 		if (p + l > end)
 			return -EILSEQ;
 		pr_debug("comparing %s with %s\n", string, p);
@@ -1363,39 +1317,41 @@ int of_property_match_string(struct device_node *np, const char *propname,
 EXPORT_SYMBOL_GPL(of_property_match_string);
 
 /**
- * of_property_count_strings - Find and return the number of strings from a
- * multiple strings property.
+ * of_property_read_string_util() - Utility helper for parsing string properties
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
+ * @out_strs:	output array of string pointers.
+ * @sz:		number of array elements to read.
+ * @skip:	Number of strings to skip over at beginning of list.
  *
- * Search for a property in a device tree node and retrieve the number of null
- * terminated string contain in it. Returns the number of strings on
- * success, -EINVAL if the property does not exist, -ENODATA if property
- * does not have a value, and -EILSEQ if the string is not null-terminated
- * within the length of the property data.
+ * Don't call this function directly. It is a utility helper for the
+ * of_property_read_string*() family of functions.
  */
-int of_property_count_strings(struct device_node *np, const char *propname)
+int of_property_read_string_helper(struct device_node *np, const char *propname,
+				   const char **out_strs, size_t sz, int skip)
 {
 	struct property *prop = of_find_property(np, propname, NULL);
-	int i = 0;
-	size_t l = 0, total = 0;
-	const char *p;
+	int l = 0, i = 0;
+	const char *p, *end;
 
 	if (!prop)
 		return -EINVAL;
 	if (!prop->value)
 		return -ENODATA;
-	if (strnlen(prop->value, prop->length) >= prop->length)
-		return -EILSEQ;
-
 	p = prop->value;
+	end = p + prop->length;
 
-	for (i = 0; total < prop->length; total += l, p += l, i++)
-		l = strlen(p) + 1;
-
-	return i;
+	for (i = 0; p < end && (!out_strs || i < skip + sz); i++, p += l) {
+		l = strnlen(p, end - p) + 1;
+		if (p + l > end)
+			return -EILSEQ;
+		if (out_strs && i >= skip)
+			*out_strs++ = p;
+	}
+	i -= skip;
+	return i <= 0 ? -ENODATA : i;
 }
-EXPORT_SYMBOL_GPL(of_property_count_strings);
+EXPORT_SYMBOL_GPL(of_property_read_string_helper);
 
 void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 {
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 78001270a598..11b873c54a77 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -339,8 +339,9 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	selftest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 }
 
-static void __init of_selftest_property_match_string(void)
+static void __init of_selftest_property_string(void)
 {
+	const char *strings[4];
 	struct device_node *np;
 	int rc;
 
@@ -357,13 +358,66 @@ static void __init of_selftest_property_match_string(void)
 	rc = of_property_match_string(np, "phandle-list-names", "third");
 	selftest(rc == 2, "third expected:0 got:%i\n", rc);
 	rc = of_property_match_string(np, "phandle-list-names", "fourth");
-	selftest(rc == -ENODATA, "unmatched string; rc=%i", rc);
+	selftest(rc == -ENODATA, "unmatched string; rc=%i\n", rc);
 	rc = of_property_match_string(np, "missing-property", "blah");
-	selftest(rc == -EINVAL, "missing property; rc=%i", rc);
+	selftest(rc == -EINVAL, "missing property; rc=%i\n", rc);
 	rc = of_property_match_string(np, "empty-property", "blah");
-	selftest(rc == -ENODATA, "empty property; rc=%i", rc);
+	selftest(rc == -ENODATA, "empty property; rc=%i\n", rc);
 	rc = of_property_match_string(np, "unterminated-string", "blah");
-	selftest(rc == -EILSEQ, "unterminated string; rc=%i", rc);
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
 }
 
 #define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
@@ -881,7 +935,7 @@ static int __init of_selftest(void)
 	of_selftest_find_node_by_name();
 	of_selftest_dynamic();
 	of_selftest_parse_phandle_with_args();
-	of_selftest_property_match_string();
+	of_selftest_property_string();
 	of_selftest_property_copy();
 	of_selftest_changeset();
 	of_selftest_parse_interrupts();
diff --git a/drivers/of/testcase-data/tests-phandle.dtsi b/drivers/of/testcase-data/tests-phandle.dtsi
index ce0fe083d406..5b1527e8a7fb 100644
--- a/drivers/of/testcase-data/tests-phandle.dtsi
+++ b/drivers/of/testcase-data/tests-phandle.dtsi
@@ -39,7 +39,9 @@
 				phandle-list-bad-args = <&provider2 1 0>,
 							<&provider3 0>;
 				empty-property;
+				string-property = "foobar";
 				unterminated-string = [40 41 42 43];
+				unterminated-string-list = "first", "second", [40 41 42 43];
 			};
 		};
 	};
diff --git a/include/linux/of.h b/include/linux/of.h
index 6545e7aec7bb..3b3c6e849ae8 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -267,14 +267,12 @@ extern int of_property_read_u64(const struct device_node *np,
 extern int of_property_read_string(struct device_node *np,
 				   const char *propname,
 				   const char **out_string);
-extern int of_property_read_string_index(struct device_node *np,
-					 const char *propname,
-					 int index, const char **output);
 extern int of_property_match_string(struct device_node *np,
 				    const char *propname,
 				    const char *string);
-extern int of_property_count_strings(struct device_node *np,
-				     const char *propname);
+extern int of_property_read_string_helper(struct device_node *np,
+					      const char *propname,
+					      const char **out_strs, size_t sz, int index);
 extern int of_device_is_compatible(const struct device_node *device,
 				   const char *);
 extern int of_device_is_available(const struct device_node *device);
@@ -486,15 +484,9 @@ static inline int of_property_read_string(struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline int of_property_read_string_index(struct device_node *np,
-						const char *propname, int index,
-						const char **out_string)
-{
-	return -ENOSYS;
-}
-
-static inline int of_property_count_strings(struct device_node *np,
-					    const char *propname)
+static inline int of_property_read_string_helper(struct device_node *np,
+						 const char *propname,
+						 char **out_strs, size_t sz, int index)
 {
 	return -ENOSYS;
 }
@@ -668,6 +660,70 @@ static inline int of_property_count_u64_elems(const struct device_node *np,
 }
 
 /**
+ * of_property_read_string_array() - Read an array of strings from a multiple
+ * strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_strs:	output array of string pointers.
+ * @sz:		number of array elements to read.
+ *
+ * Search for a property in a device tree node and retrieve a list of
+ * terminated string values (pointer to data, not a copy) in that property.
+ *
+ * If @out_strs is NULL, the number of strings in the property is returned.
+ */
+static inline int of_property_read_string_array(struct device_node *np,
+						const char *propname, const char **out_strs,
+						size_t sz)
+{
+	return of_property_read_string_helper(np, propname, out_strs, sz, 0);
+}
+
+/**
+ * of_property_count_strings() - Find and return the number of strings from a
+ * multiple strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device tree node and retrieve the number of null
+ * terminated string contain in it. Returns the number of strings on
+ * success, -EINVAL if the property does not exist, -ENODATA if property
+ * does not have a value, and -EILSEQ if the string is not null-terminated
+ * within the length of the property data.
+ */
+static inline int of_property_count_strings(struct device_node *np,
+					    const char *propname)
+{
+	return of_property_read_string_helper(np, propname, NULL, 0, 0);
+}
+
+/**
+ * of_property_read_string_index() - Find and read a string from a multiple
+ * strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @index:	index of the string in the list of strings
+ * @out_string:	pointer to null terminated return string, modified only if
+ *		return value is 0.
+ *
+ * Search for a property in a device tree node and retrieve a null
+ * terminated string value (pointer to data, not a copy) in the list of strings
+ * contained in that property.
+ * Returns 0 on success, -EINVAL if the property does not exist, -ENODATA if
+ * property does not have a value, and -EILSEQ if the string is not
+ * null-terminated within the length of the property data.
+ *
+ * The out_string pointer is modified only if a valid string can be decoded.
+ */
+static inline int of_property_read_string_index(struct device_node *np,
+						const char *propname,
+						int index, const char **output)
+{
+	int rc = of_property_read_string_helper(np, propname, output, 1, index);
+	return rc < 0 ? rc : 0;
+}
+
+/**
  * of_property_read_bool - Findfrom a property
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
-- 
1.9.1

