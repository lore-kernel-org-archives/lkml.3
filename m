Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaELQzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:55:42 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59559 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaELQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:55:40 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 4/9] dt: deps: dtc: Add option to print dependency graph as dot (Graphviz)
Date: Mon, 12 May 2014 18:47:55 +0200
Message-Id: <1399913280-6915-5-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add option -T do print a dependency graph in dot format for
generating a picture with Graphviz.

E.g.

	dtc -T foo.dts | dot -T svg -o foo.svg

would generate the picture foo.png with the dependency graph.

Convential dependencies (those based on the tree structure) are having
black arrows, dependencies based on the property 'dependencies' are
having cyan arrows.

Option -D to not automatically add dependencies does still work, so
you could build a classic dependency graph with

	dtc -D -T foo.dts | dot -T png -o foo_no_auto_deps.png

This works with binary blobs as input too. E.g.

	CROSS_COMPILE=gcc-foo ARCH=arm make foo.dtb
	scripts/dtc/dtc -I dtb -T arch/arm/boot/dts/foo.dtb

would print the dot file.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 scripts/dtc/dependencies.c | 48 ++++++++++++++++++++++++++++++++++++++++------
 scripts/dtc/dtc.c          | 19 +++++++++++++++---
 scripts/dtc/dtc.h          |  2 +-
 3 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/scripts/dtc/dependencies.c b/scripts/dtc/dependencies.c
index 8fe1a8c..4579f6f 100644
--- a/scripts/dtc/dependencies.c
+++ b/scripts/dtc/dependencies.c
@@ -298,7 +298,7 @@ static void __init topological_sort(void)
 			depth_first_search(i);
 }
 
-static int __init add_dep_list(struct device_node *node)
+static int __init add_dep_list(struct device_node *node, bool print_dot)
 {
 	const __be32 *list, *list_end;
 	uint32_t ph;
@@ -328,6 +328,9 @@ static int __init add_dep_list(struct device_node *node)
 		rc = insert_edge(node->phandle, ph);
 		if (rc)
 			break;
+		if (print_dot)
+			printf("      node0x%x -> node0x%x [color=cyan]\n",
+				node->phandle, ph);
 	}
 
 	return rc;
@@ -352,9 +355,10 @@ static const char *of_prop_next_string(struct property *prop, const char *cur)
 }
 
 static int __init add_deps_lnx(struct device_node *parent,
-				struct device_node *node)
+				struct device_node *node, bool print_dot)
 {
 	struct device_node *child;
+	const char *cp;
 	int rc = 0;
 
 	if (!__of_device_is_available(node))
@@ -375,13 +379,33 @@ static int __init add_deps_lnx(struct device_node *parent,
 			return -EINVAL;
 		}
 		order.parent_by_phandle[node->phandle] = parent->phandle;
-		rc = add_dep_list(node);
+		if (print_dot) {
+			struct property *prop;
+			printf("    node0x%x [label=\"0x%x %s", node->phandle,
+						node->phandle, node->name);
+			if (node->full_name)
+				printf(" (%s)", node->full_name);
+			prop = get_property(node, "compatible");
+			if (prop) {
+				printf("\\n");
+				for (cp = of_prop_next_string(prop, NULL); cp;
+				     cp = of_prop_next_string(prop, cp)) {
+					if (cp != prop->val.val)
+						putchar(' ');
+					printf("%s", cp);
+				}
+			}
+			printf("\"];\n");
+			printf("      node0x%x -> node0x%x\n", node->phandle,
+							parent->phandle);
+		}
+		rc = add_dep_list(node, print_dot);
 		if (unlikely(rc))
 			return rc;
 		parent = node; /* change the parent only if node is a driver */
 	}
 	for_each_child_of_node(node, child) {
-		rc = add_deps_lnx(parent, child);
+		rc = add_deps_lnx(parent, child, print_dot);
 		if (unlikely(rc))
 			break;
 	}
@@ -426,7 +450,7 @@ void __init of_init_print_order(const char *name)
 	}
 }
 
-int __init of_init_build_order(struct device_node *root)
+int __init of_init_build_order(struct device_node *root, const char *print_dot)
 {
 	struct device_node *child;
 	int rc = 0;
@@ -438,12 +462,24 @@ int __init of_init_build_order(struct device_node *root)
 	calc_max_phandle(root);
 	order.old_max_phandle = order.max_phandle;
 
+	if (print_dot) {
+		printf("digraph G {\n");
+		printf("    node0x%x [label=\"0x%x root (/)\"];\n",
+			order.max_phandle+1 , order.max_phandle+1);
+	}
+
 	for_each_child_of_node(root, child) {
-		rc = add_deps_lnx(root, child);
+		rc = add_deps_lnx(root, child, print_dot);
 		if (unlikely(rc))
 			break;
 	}
 
+	if (print_dot) {
+		printf("  graph [label=\"Dependency Graph for %s (%u nodes, %u edges)\"];\n",
+			print_dot, graph.nvertices, graph.nedges);
+		printf("}\n");
+	}
+
 	of_node_put(root);
 	topological_sort();
 
diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index ac9858c..ff09fc44 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -90,6 +90,8 @@ static void  __attribute__ ((noreturn)) usage(void)
 	fprintf(stderr, "\t\tDo not automatically add dependencies for phandle references\n");
 	fprintf(stderr, "\t-t\n");
 	fprintf(stderr, "\t\tPrint (default) initialization order\n");
+	fprintf(stderr, "\t-T\n");
+	fprintf(stderr, "\t\tPrint dot with dependency graph (for use with Graphviz)\n");
 	fprintf(stderr, "\t-v\n");
 	fprintf(stderr, "\t\tPrint DTC version and exit\n");
 	fprintf(stderr, "\t-H <phandle format>\n");
@@ -113,6 +115,7 @@ int main(int argc, char *argv[])
 	int force = 0, sort = 0;
 	int dependencies = 1;
 	int init_order = 0;
+	int print_dot = 0;
 	const char *arg;
 	int opt;
 	FILE *outf = NULL;
@@ -124,7 +127,7 @@ int main(int argc, char *argv[])
 	minsize    = 0;
 	padsize    = 0;
 
-	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sDtW:E:"))
+	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sDtTW:E:"))
 			!= EOF) {
 		switch (opt) {
 		case 'I':
@@ -190,6 +193,10 @@ int main(int argc, char *argv[])
 			init_order = true;
 			break;
 
+		case 'T':
+			print_dot = true;
+			break;
+
 		case 'W':
 			parse_checks_option(true, false, optarg);
 			break;
@@ -253,12 +260,18 @@ int main(int argc, char *argv[])
 		add_dependencies(bi);
 
 	if (init_order) {
-		if (of_init_build_order(bi->dt))
+		if (of_init_build_order(bi->dt, 0))
 			exit(2);
 		of_init_print_order(arg);
 		exit(0);
 	}
 
+	if (print_dot) {
+		if (of_init_build_order(bi->dt, arg))
+			exit(2);
+		exit(0);
+	}
+
 	if (streq(outname, "-")) {
 		outf = stdout;
 	} else {
@@ -285,7 +298,7 @@ int main(int argc, char *argv[])
 	 * This is done after the output was saved because it
 	 * changes the tree slightly.
 	 */
-	if (of_init_build_order(bi->dt))
+	if (of_init_build_order(bi->dt, 0))
 		exit(2);
 
 	exit(0);
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index b89e08a..b65afc2 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -270,6 +270,6 @@ struct boot_info *dt_from_fs(const char *dirname);
 /* Dependencies */
 void add_dependencies(struct boot_info *bi);
 void of_init_print_order(const char *name);
-int of_init_build_order(struct node *root);
+int of_init_build_order(struct node *root, const char *print_dot);
 
 #endif /* _DTC_H */
-- 
1.8.3.1

