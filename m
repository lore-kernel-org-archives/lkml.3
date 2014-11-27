Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK0Rzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:55:55 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56953 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaK0Rzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:55:52 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v3 2/3] of: add optional options parameter to of_find_node_by_path()
Date: Thu, 27 Nov 2014 17:56:06 +0000
Message-Id: <1417110967-16284-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update of_find_node_by_path():
1) Rename function to of_find_node_opts_by_path(), adding an optional
   pointer argument. Provide a static inline wrapper version of
   of_find_node_by_path() which calls the new function with NULL as
   the optional argument.
2) Ignore any part of the path beyond and including the ':' separator.
3) Set the new provided pointer argument to the beginning of the string
   following the ':' separator.
4: Add tests.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/of/base.c     |   21 +++++++++++++++++----
 drivers/of/selftest.c |   12 ++++++++++++
 include/linux/of.h    |   14 +++++++++++++-
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3823edf..7f0e5f7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -699,10 +699,15 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 {
 	struct device_node *child;
 	int len = strchrnul(path, '/') - path;
+	int term;
 
 	if (!len)
 		return NULL;
 
+	term = strchrnul(path, ':') - path;
+	if (term < len)
+		len = term;
+
 	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
 		if (WARN(!name, "malformed device_node %s\n", child->full_name))
@@ -715,11 +720,14 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 }
 
 /**
- *	of_find_node_by_path - Find a node matching a full OF path
+ *	of_find_node_opts_by_path - Find a node matching a full OF path
  *	@path: Either the full path to match, or if the path does not
  *	       start with '/', the name of a property of the /aliases
  *	       node (an alias).  In the case of an alias, the node
  *	       matching the alias' value will be returned.
+ *	@opts: Address of a pointer into which to store the start of
+ *	       an options string appended to the end of the path with
+ *	       a ':' separator.
  *
  *	Valid paths:
  *		/foo/bar	Full path
@@ -729,19 +737,24 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
  */
-struct device_node *of_find_node_by_path(const char *path)
+struct device_node *of_find_node_opts_by_path(const char *path, const char **opts)
 {
 	struct device_node *np = NULL;
 	struct property *pp;
 	unsigned long flags;
+	char *separator;
 
 	if (strcmp(path, "/") == 0)
 		return of_node_get(of_allnodes);
 
+	separator = strchr(path, ':');
+	if (separator && opts)
+		*opts = separator + 1;
+
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		char *p = strchrnul(path, '/');
-		int len = p - path;
+		int len = separator ? separator - path : p - path;
 
 		/* of_aliases must not be NULL */
 		if (!of_aliases)
@@ -770,7 +783,7 @@ struct device_node *of_find_node_by_path(const char *path)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
-EXPORT_SYMBOL(of_find_node_by_path);
+EXPORT_SYMBOL(of_find_node_opts_by_path);
 
 /**
  *	of_find_node_by_name - Find a node by its "name" property
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index e2d79af..c298065 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -43,6 +43,7 @@ static bool selftest_live_tree;
 static void __init of_selftest_find_node_by_name(void)
 {
 	struct device_node *np;
+	const char *options;
 
 	np = of_find_node_by_path("/testcase-data");
 	selftest(np && !strcmp("/testcase-data", np->full_name),
@@ -83,6 +84,17 @@ static void __init of_selftest_find_node_by_name(void)
 	np = of_find_node_by_path("testcase-alias/missing-path");
 	selftest(!np, "non-existent alias with relative path returned node %s\n", np->full_name);
 	of_node_put(np);
+
+	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
+	selftest(np && !strcmp("testoption", options),
+		 "option path test failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
+				       &options);
+	selftest(np && !strcmp("testaliasoption", options),
+		 "option alias path test failed\n");
+	of_node_put(np);
 }
 
 static void __init of_selftest_dynamic(void)
diff --git a/include/linux/of.h b/include/linux/of.h
index 29f0adc..a36be70 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -228,7 +228,13 @@ extern struct device_node *of_find_matching_node_and_match(
 	const struct of_device_id *matches,
 	const struct of_device_id **match);
 
-extern struct device_node *of_find_node_by_path(const char *path);
+extern struct device_node *of_find_node_opts_by_path(const char *path,
+	const char **opts);
+static inline struct device_node *of_find_node_by_path(const char *path)
+{
+	return of_find_node_opts_by_path(path, NULL);
+}
+
 extern struct device_node *of_find_node_by_phandle(phandle handle);
 extern struct device_node *of_get_parent(const struct device_node *node);
 extern struct device_node *of_get_next_parent(struct device_node *node);
@@ -385,6 +391,12 @@ static inline struct device_node *of_find_node_by_path(const char *path)
 	return NULL;
 }
 
+static inline struct device_node *of_find_node_opts_by_path(const char *path,
+	const char **opts)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_get_parent(const struct device_node *node)
 {
 	return NULL;
-- 
1.7.10.4

