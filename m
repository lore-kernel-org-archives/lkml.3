Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbaELQxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:53:03 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58925 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbaELQxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:53:00 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property 'dependencies' which contains a list of referenced phandles
Date: Mon, 12 May 2014 18:47:52 +0200
Message-Id: <1399913280-6915-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the step from .dts to .dtb the information about dependcies contained
in the .dts through phandle references is lost. This makes it impossible to
use the binary blob to create a dependency graph without knowing the semantic
of all cell arrays.

Therefor automatically add a new property called 'dependencies' to all nodes
which have phandle references in one of their properties.

This new property will contain an array of phandles with one value for every
phandle referenced by other properties in the node.

If such a property already exists (e.g. to manually add dependencies through
the .dts), the existing list will be expanded.

Added phandles will be the phandle of either the referenced node itself (if
it has a property named 'compatible', or of the next parent of the referenced
node which as property named 'compatible'. This ensures only dependencies to
drivers will be added.

References to phandles of parent or child nodes will not be added to this
property, because this information is already contained in the blob (in the
form of the tree itself).

No dependencies to disabled nodes will be added.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 scripts/dtc/Makefile       |   3 +-
 scripts/dtc/Makefile.dtc   |   1 +
 scripts/dtc/dependencies.c | 108 +++++++++++++++++++++++++++++++++++++++++++++
 scripts/dtc/dtc.c          |  12 ++++-
 scripts/dtc/dtc.h          |   3 ++
 5 files changed, 125 insertions(+), 2 deletions(-)
 create mode 100644 scripts/dtc/dependencies.c

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 2a48022..1174cf9 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -4,7 +4,7 @@ hostprogs-y	:= dtc
 always		:= $(hostprogs-y)
 
 dtc-objs	:= dtc.o flattree.o fstree.o data.o livetree.o treesource.o \
-		   srcpos.o checks.o util.o
+		   srcpos.o checks.o util.o dependencies.o
 dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
 
 # Source files need to get at the userspace version of libfdt_env.h to compile
@@ -13,6 +13,7 @@ HOSTCFLAGS_DTC := -I$(src) -I$(src)/libfdt
 
 HOSTCFLAGS_checks.o := $(HOSTCFLAGS_DTC)
 HOSTCFLAGS_data.o := $(HOSTCFLAGS_DTC)
+HOSTCFLAGS_dependencies.o := $(HOSTCFLAGS_DTC)
 HOSTCFLAGS_dtc.o := $(HOSTCFLAGS_DTC)
 HOSTCFLAGS_flattree.o := $(HOSTCFLAGS_DTC)
 HOSTCFLAGS_fstree.o := $(HOSTCFLAGS_DTC)
diff --git a/scripts/dtc/Makefile.dtc b/scripts/dtc/Makefile.dtc
index bece49b..5fb5343 100644
--- a/scripts/dtc/Makefile.dtc
+++ b/scripts/dtc/Makefile.dtc
@@ -6,6 +6,7 @@
 DTC_SRCS = \
 	checks.c \
 	data.c \
+	dependencies.c \
 	dtc.c \
 	flattree.c \
 	fstree.c \
diff --git a/scripts/dtc/dependencies.c b/scripts/dtc/dependencies.c
new file mode 100644
index 0000000..dd4658c
--- /dev/null
+++ b/scripts/dtc/dependencies.c
@@ -0,0 +1,108 @@
+/*
+ * Code to add a property which contains dependencies (used phandle references)
+ * to all (driver) nodes which are having phandle references.
+ *
+ * Copyright (C) 2014 Alexander Holler <holler@ahsoftware.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <dtc.h>
+
+/* Searches upwards for a node with a property 'compatible' */
+static struct node *find_compatible_not_disabled(struct node *node)
+{
+	struct property *prop;
+
+	while (node) {
+		prop = get_property(node, "compatible");
+		if (prop) {
+			prop = get_property(node, "status");
+			if (prop)
+				if (!prop->val.len ||
+					(strcmp(prop->val.val, "okay") &&
+						strcmp(prop->val.val, "ok")))
+					return NULL; /* disabled */
+			return node;
+		}
+		node = node->parent;
+	}
+	return NULL;
+}
+
+static bool is_parent_of(struct node *node1, struct node *node2)
+{
+	while (node2) {
+		if (node2->parent == node1)
+			return true;
+		node2 = node2->parent;
+	}
+	return false;
+
+}
+
+static void add_deps(struct node *dt, struct node *node, struct property *prop)
+{
+	struct marker *m = prop->val.markers;
+	struct node *refnode;
+	cell_t phandle;
+	struct property *prop_deps;
+	unsigned i;
+	cell_t *cell;
+	struct node *source;
+	struct node *target;
+
+	for_each_marker_of_type(m, REF_PHANDLE) {
+		assert(m->offset + sizeof(cell_t) <= prop->val.len);
+
+		refnode = get_node_by_ref(dt, m->ref);
+		if (!refnode) {
+			fprintf(stderr,
+				"ERROR: Reference to non-existent node or label \"%s\"\n",
+				m->ref);
+			continue;
+		}
+
+		source = find_compatible_not_disabled(node);
+		target = find_compatible_not_disabled(refnode);
+		if (!source || !target || source == target ||
+				is_parent_of(source, target) ||
+				is_parent_of(target, source))
+			continue;
+		phandle = get_node_phandle(dt, target);
+		prop_deps = get_property(source, "dependencies");
+		if (!prop_deps) {
+			add_property(source,
+			     build_property("dependencies",
+				data_append_cell(empty_data, phandle)));
+			continue;
+		}
+		cell = (cell_t *)prop_deps->val.val;
+		for (i = 0; i < prop_deps->val.len/4; ++i)
+			if (*cell++ == cpu_to_fdt32(phandle))
+				break;
+		if (i < prop_deps->val.len/4)
+			continue; /* avoid duplicates */
+		prop_deps->val = data_append_cell(prop_deps->val, phandle);
+	}
+}
+
+static void process_nodes_props(struct node *dt, struct node *node)
+{
+	struct node *child;
+	struct property *prop;
+
+	for_each_property(node, prop)
+		add_deps(dt, node, prop);
+
+	for_each_child(node, child)
+		process_nodes_props(dt, child);
+}
+
+void add_dependencies(struct boot_info *bi)
+{
+	process_nodes_props(bi->dt, bi->dt);
+}
diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index a375683..fbe49d9 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -86,6 +86,8 @@ static void  __attribute__ ((noreturn)) usage(void)
 	fprintf(stderr, "\t\tAdd a path to search for include files\n");
 	fprintf(stderr, "\t-s\n");
 	fprintf(stderr, "\t\tSort nodes and properties before outputting (only useful for\n\t\tcomparing trees)\n");
+	fprintf(stderr, "\t-D\n");
+	fprintf(stderr, "\t\tDo not automatically add dependencies for phandle references\n");
 	fprintf(stderr, "\t-v\n");
 	fprintf(stderr, "\t\tPrint DTC version and exit\n");
 	fprintf(stderr, "\t-H <phandle format>\n");
@@ -107,6 +109,7 @@ int main(int argc, char *argv[])
 	const char *outname = "-";
 	const char *depname = NULL;
 	int force = 0, sort = 0;
+	int dependencies = 1;
 	const char *arg;
 	int opt;
 	FILE *outf = NULL;
@@ -118,7 +121,7 @@ int main(int argc, char *argv[])
 	minsize    = 0;
 	padsize    = 0;
 
-	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sW:E:"))
+	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sDW:E:"))
 			!= EOF) {
 		switch (opt) {
 		case 'I':
@@ -176,6 +179,10 @@ int main(int argc, char *argv[])
 			sort = 1;
 			break;
 
+		case 'D':
+			dependencies = false;
+			break;
+
 		case 'W':
 			parse_checks_option(true, false, optarg);
 			break;
@@ -235,6 +242,9 @@ int main(int argc, char *argv[])
 	if (sort)
 		sort_tree(bi);
 
+	if (dependencies)
+		add_dependencies(bi);
+
 	if (streq(outname, "-")) {
 		outf = stdout;
 	} else {
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index 3e42a07..c3dbeac 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -267,4 +267,7 @@ struct boot_info *dt_from_source(const char *f);
 
 struct boot_info *dt_from_fs(const char *dirname);
 
+/* Dependencies */
+void add_dependencies(struct boot_info *bi);
+
 #endif /* _DTC_H */
-- 
1.8.3.1

