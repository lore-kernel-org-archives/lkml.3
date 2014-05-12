Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbaELQyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:54:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59245 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbaELQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:54:15 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 2/9] dt: deps: dependency based device creation
Date: Mon, 12 May 2014 18:47:53 +0200
Message-Id: <1399913280-6915-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the properties named 'dependencies' in binary device tree blobs to build
a dependency based initialization order for platform devices and drivers.

This is done by building a directed acyclic graph using an adjacency list
and doing a topological sort to retrieve the order in which devices/drivers
should be created/initialized.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/kernel/setup.c         |  20 +-
 drivers/of/Kconfig              |  10 +
 drivers/of/Makefile             |   1 +
 drivers/of/of_dependencies.c    | 403 ++++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c           |  32 +++-
 include/linux/of.h              |  15 ++
 include/linux/of_dependencies.h |  61 ++++++
 include/linux/of_platform.h     |   5 +
 8 files changed, 543 insertions(+), 4 deletions(-)
 create mode 100644 drivers/of/of_dependencies.c
 create mode 100644 include/linux/of_dependencies.h

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 1e8b030..f67387d 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
 #include <linux/of_platform.h>
+#include <linux/of_dependencies.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/of_fdt.h>
@@ -787,10 +788,19 @@ static int __init customize_machine(void)
 	if (machine_desc->init_machine)
 		machine_desc->init_machine();
 #ifdef CONFIG_OF
-	else
+	else {
+#ifdef CONFIG_OF_DEPENDENCIES
+		if (!of_init_build_order(NULL, NULL))
+			of_init_create_devices(NULL, NULL);
+		else
+			of_init_free_order();
+#else
 		of_platform_populate(NULL, of_default_bus_match_table,
 					NULL, NULL);
 #endif
+	}
+#endif
+
 	return 0;
 }
 arch_initcall(customize_machine);
@@ -914,7 +924,13 @@ void __init setup_arch(char **cmdline_p)
 		arm_pm_restart = mdesc->restart;
 
 	unflatten_device_tree();
-
+#ifdef CONFIG_OF_DEPENDENCIES
+	/*
+	 * No alloc used in of_init_build_order(), therefor it would work
+	 * already here too.
+	 */
+	/* of_init_build_order(NULL, NULL); */
+#endif
 	arm_dt_init_cpu_maps();
 	psci_init();
 #ifdef CONFIG_SMP
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f1..a7e1614 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -75,4 +75,14 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_DEPENDENCIES
+	bool "Device Tree dependency based initialization order (EXPERIMENTAL)"
+	help
+	  Enables dependency based initialization order of platform drivers.
+
+	  For correct operation the binary DT blob should have been
+	  populated with properties of type "dependencies".
+
+	  If unsure, say N here.
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index efd0510..3888d9c 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_DEPENDENCIES)	+= of_dependencies.o
diff --git a/drivers/of/of_dependencies.c b/drivers/of/of_dependencies.c
new file mode 100644
index 0000000..7905172
--- /dev/null
+++ b/drivers/of/of_dependencies.c
@@ -0,0 +1,403 @@
+/*
+ * Code for building a deterministic initialization order based on dependencies
+ * defined in the device tree.
+ *
+ * Copyright (C) 2014 Alexander Holler <holler@ahsoftware.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/of_dependencies.h>
+
+#define MAX_DT_NODES 1000 /* maximum number of vertices */
+#define MAX_EDGES (MAX_DT_NODES*2) /* maximum number of edges (dependencies) */
+
+struct edgenode {
+	uint32_t y; /* phandle */
+	struct edgenode *next; /* next edge in list */
+};
+
+/*
+ * Vertex numbers do correspond to phandle numbers. That means the graph
+ * does contain as much vertices as the maximum of all phandles.
+ * Or in other words, we assume that for all phandles in the device tree
+ * 0 < phandle < MAX_DT_NODES+1 is true.
+ */
+struct dep_graph {
+	struct edgenode edge_slots[MAX_EDGES]; /* used to avoid kmalloc */
+	struct edgenode *edges[MAX_DT_NODES+1]; /* adjacency info */
+	unsigned nvertices; /* number of vertices in graph */
+	unsigned nedges; /* number of edges in graph */
+	bool processed[MAX_DT_NODES+1]; /* which vertices have been processed */
+	bool include_node[MAX_DT_NODES+1]; /* which nodes to consider */
+	bool discovered[MAX_DT_NODES+1]; /* which vertices have been found */
+	bool finished; /* if true, cut off search immediately */
+};
+static struct dep_graph graph __initdata;
+
+struct init_order {
+	uint32_t max_phandle; /* the max used phandle */
+	uint32_t old_max_phandle; /* used to keep track of added phandles */
+	struct device_node *order[MAX_DT_NODES+1];
+	unsigned count;
+	/* Used to keep track of parent devices in regard to the DT */
+	uint32_t parent_by_phandle[MAX_DT_NODES+1];
+	struct device *device_by_phandle[MAX_DT_NODES+1];
+};
+static struct init_order order __initdata;
+
+
+/* Copied from drivers/of/base.c (because it's lockless). */
+static struct property * __init __of_find_property(const struct device_node *np,
+					   const char *name, int *lenp)
+{
+	struct property *pp;
+
+	if (!np)
+		return NULL;
+
+	for (pp = np->properties; pp; pp = pp->next) {
+		if (of_prop_cmp(pp->name, name) == 0) {
+			if (lenp)
+				*lenp = pp->length;
+			break;
+		}
+	}
+
+	return pp;
+}
+
+/* Copied from drivers/of/base.c (because it's lockless). */
+static const void * __init __of_get_property(const struct device_node *np,
+				     const char *name, int *lenp)
+{
+	struct property *pp = __of_find_property(np, name, lenp);
+
+	return pp ? pp->value : NULL;
+}
+
+/* Copied from drivers/of/base.c (because it's lockless). */
+static int __init __of_device_is_available(const struct device_node *device)
+{
+	const char *status;
+	int statlen;
+
+	if (!device)
+		return 0;
+
+	status = __of_get_property(device, "status", &statlen);
+	if (status == NULL)
+		return 1;
+
+	if (statlen > 0) {
+		if (!strcmp(status, "okay") || !strcmp(status, "ok"))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * x is a dependant of y or in other words
+ * y will be initialized before x.
+ */
+static int __init insert_edge(uint32_t x, uint32_t y)
+{
+	struct edgenode *p; /* temporary pointer */
+
+	if (unlikely(x > MAX_DT_NODES || y > MAX_DT_NODES)) {
+		pr_err("Node found with phandle 0x%x > MAX_DT_NODES (%d)!\n",
+			x > MAX_DT_NODES ? x : y, MAX_DT_NODES);
+		return -EINVAL;
+	}
+	if (unlikely(!x || !y))
+		return 0;
+	if (unlikely(graph.nedges >= MAX_EDGES)) {
+		pr_err("Maximum number of edges (%d) reached!\n", MAX_EDGES);
+		return -EINVAL;
+	}
+	p = &graph.edge_slots[graph.nedges++];
+	graph.include_node[x] = 1;
+	graph.include_node[y] = 1;
+	p->y = y;
+	p->next = graph.edges[x];
+	graph.edges[x] = p; /* insert at head of list */
+
+	graph.nvertices = (x > graph.nvertices) ? x : graph.nvertices;
+	graph.nvertices = (y > graph.nvertices) ? y : graph.nvertices;
+	return 0;
+}
+
+static void __init print_node_name(uint32_t v)
+{
+	struct device_node *node;
+
+	node = of_find_node_by_phandle(v);
+	if (!node) {
+		pr_cont("Node for phandle 0x%x not found", v);
+		return;
+	}
+	if (node->name)
+		pr_cont("%s", node->name);
+	if (node->full_name)
+		pr_cont(" (%s)", node->full_name);
+	of_node_put(node);
+}
+
+/*
+ * I would prefer to use the BGL (Boost Graph Library), but as I can't use it
+ * here (for obvious reasons), the next four functions below are based on
+ * code of Steven Skiena's book 'The Algorithm Design Manual'.
+ */
+
+static void __init process_edge(uint32_t x, uint32_t y)
+{
+	if (unlikely(graph.discovered[y] && !graph.processed[y])) {
+		pr_err("Cycle found 0x%x ", x);
+		print_node_name(x);
+		pr_cont(" <-> 0x%x ", y);
+		print_node_name(y);
+		pr_cont("!\n");
+		graph.finished = 1;
+	}
+}
+
+static void __init process_vertex_late(uint32_t v)
+{
+	struct device_node *node;
+
+	node = of_find_node_by_phandle(v);
+	if (!node) {
+		pr_err("No node for phandle 0x%x not found", v);
+		return;
+	}
+	order.order[order.count++] = node;
+}
+
+static void __init depth_first_search(uint32_t v)
+{
+	struct edgenode *p;
+	uint32_t y; /* successor vertex */
+
+	if (graph.finished)
+		return;
+	graph.discovered[v] = 1;
+	p = graph.edges[v];
+	while (p) {
+		y = p->y;
+		if (!graph.discovered[y]) {
+			process_edge(v, y);
+			depth_first_search(y);
+		} else
+			process_edge(v, y);
+		if (graph.finished)
+			return;
+		p = p->next;
+	}
+	process_vertex_late(v);
+	graph.processed[v] = 1;
+}
+
+static void __init topological_sort(void)
+{
+	unsigned i;
+
+	for (i = 1; i <= graph.nvertices; ++i)
+		if (!graph.discovered[i] && graph.include_node[i])
+			depth_first_search(i);
+}
+
+static int __init add_dep_list(struct device_node *node,
+				const struct of_device_id *matches)
+{
+	const __be32 *list, *list_end;
+	uint32_t ph;
+	int size;
+	int rc = 0;
+	struct device_node *dep;
+
+	list = __of_get_property(node, "dependencies", &size);
+	if (!list || !size || size%sizeof(*list))
+		return 0;
+	list_end = list + size / sizeof(*list);
+	while (list < list_end) {
+		ph = be32_to_cpup(list++);
+		if (unlikely(!ph)) {
+			/* Should never happen */
+			if (node->name)
+				pr_warn("phandle == 0 for %s\n", node->name);
+			continue;
+		}
+		dep = of_find_node_by_phandle(ph);
+		if (unlikely(!dep)) {
+			pr_err("No DT node for dependency with phandle 0x%x found\n",
+				ph);
+			continue;
+		}
+		if (unlikely(matches && !of_match_node(matches, dep)))
+			continue;
+		rc = insert_edge(node->phandle, ph);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
+static int __init add_deps(struct device_node *parent, struct device_node *node,
+				const struct of_device_id *matches)
+{
+	struct device_node *child;
+	int rc = 0;
+
+	if (!__of_device_is_available(node))
+		return 0;
+	if (__of_get_property(node, "compatible", NULL)) {
+		if (!parent->phandle) {
+			if (__of_get_property(parent, "compatible", NULL))
+				parent->phandle = 1 + order.max_phandle++;
+		}
+		if (!node->phandle)
+			node->phandle = 1 + order.max_phandle++;
+		rc = insert_edge(node->phandle, parent->phandle);
+		if (rc)
+			return rc;
+		if (unlikely(order.parent_by_phandle[node->phandle])) {
+			/* sanity check */
+			pr_err("0x%x already has a parent!\n", node->phandle);
+			return -EINVAL;
+		}
+		order.parent_by_phandle[node->phandle] = parent->phandle;
+		rc = add_dep_list(node, matches);
+		if (unlikely(rc))
+			return rc;
+		parent = node; /* change the parent only if node is a driver */
+	}
+	if (unlikely(matches && !of_match_node(matches, node)))
+		return rc;
+	for_each_child_of_node(node, child) {
+		rc = add_deps(parent, child, matches);
+		if (unlikely(rc))
+			break;
+	}
+
+	return rc;
+}
+
+static void __init calc_max_phandle(void)
+{
+	struct device_node *np;
+	uint32_t t = 0;
+
+	for (np = of_allnodes; np; np = np->allnext)
+		if (np->phandle > t)
+			t = np->phandle;
+	order.max_phandle = t;
+	return;
+}
+
+/*
+static void __init remove_new_phandles(void)
+{
+	struct device_node *np;
+
+	for (np = of_allnodes; np; np = np->allnext)
+		if (np->phandle > order.old_max_phandle)
+			np->phandle = 0;
+}
+
+static void __init of_init_print_order(void)
+{
+	unsigned i;
+	struct property *prop;
+	const char *cp;
+
+	pr_info("Initialization order:\n");
+	for (i = 0; i < order.count; ++i) {
+		pr_info("init %u 0x%x", i, order.order[i]->phandle);
+		if (order.order[i]->name)
+			pr_cont(" %s", order.order[i]->name);
+		if (order.order[i]->full_name)
+			pr_cont(" (%s)", order.order[i]->full_name);
+		prop = __of_find_property(order.order[i], "compatible", NULL);
+		for (cp = of_prop_next_string(prop, NULL); cp;
+		     cp = of_prop_next_string(prop, cp))
+			pr_cont(" %s", cp);
+		pr_cont(" (parent 0x%x)\n",
+			order.parent_by_phandle[order.order[i]->phandle]);
+	}
+}
+*/
+
+int __init of_init_build_order(struct device_node *root,
+			const struct of_device_id *matches)
+{
+	struct device_node *child;
+	int rc = 0;
+
+	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	if (unlikely(!root))
+		return -EINVAL;
+
+	calc_max_phandle();
+	order.old_max_phandle = order.max_phandle;
+
+	for_each_child_of_node(root, child) {
+		rc = add_deps(root, child, matches);
+		if (unlikely(rc))
+			break;
+	}
+
+	of_node_put(root);
+	topological_sort();
+
+	if (graph.finished)
+		return -EINVAL; /* cycle found */
+
+	/* of_init_print_order(); */
+
+	return rc;
+}
+
+void __init of_init_create_devices(const struct of_device_id *blacklist,
+			const struct of_dev_auxdata *lookup)
+{
+	unsigned i;
+	struct platform_device *dev;
+
+	for (i = 0; i < order.count; ++i) {
+		struct device_node *node = order.order[i];
+		uint32_t parent_ph = order.parent_by_phandle[node->phandle];
+
+		if (unlikely(blacklist &&
+				of_match_node(blacklist, node))) {
+			of_node_put(node);
+			continue;
+		}
+		if (unlikely(parent_ph &&
+			!order.device_by_phandle[parent_ph])) {
+			/* init of parent failed */
+			of_node_put(node);
+			continue;
+		}
+		dev = of_dependencies_device_create(node, lookup,
+			order.device_by_phandle[parent_ph]);
+		if (dev)
+			order.device_by_phandle[node->phandle] = &dev->dev;
+		of_node_put(node);
+	}
+	/* remove_new_phandles(); */
+}
+
+void __init of_init_free_order(void)
+{
+	unsigned i;
+
+	for (i = 0; i < order.count; ++i)
+		of_node_put(order.order[i]);
+	order.count = 0;
+	/* remove_new_phandles(); */
+}
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..0fe03ad 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -204,9 +204,13 @@ static struct platform_device *of_platform_device_create_pdata(
 {
 	struct platform_device *dev;
 
+#ifdef CONFIG_OF_DEPENDENCIES
+	/* WARN_ON(np->dev_created); */
+	if (np->dev_created)
+		return np->dev_created;
+#endif
 	if (!of_device_is_available(np))
 		return NULL;
-
 	dev = of_device_alloc(np, bus_id, parent);
 	if (!dev)
 		return NULL;
@@ -229,7 +233,9 @@ static struct platform_device *of_platform_device_create_pdata(
 		platform_device_put(dev);
 		return NULL;
 	}
-
+#ifdef CONFIG_OF_DEPENDENCIES
+	np->dev_created = dev;
+#endif
 	return dev;
 }
 
@@ -486,3 +492,25 @@ int of_platform_populate(struct device_node *root,
 }
 EXPORT_SYMBOL_GPL(of_platform_populate);
 #endif /* CONFIG_OF_ADDRESS */
+
+#ifdef CONFIG_OF_DEPENDENCIES
+struct platform_device * __init of_dependencies_device_create(
+				struct device_node *bus,
+				const struct of_dev_auxdata *lookup,
+				struct device *parent)
+{
+	const struct of_dev_auxdata *auxdata;
+	const char *bus_id = NULL;
+	void *platform_data = NULL;
+
+	if (lookup) {
+		auxdata = of_dev_lookup(lookup, bus);
+		if (auxdata) {
+			bus_id = auxdata->name;
+			platform_data = auxdata->platform_data;
+		}
+	}
+	return of_platform_device_create_pdata(bus, bus_id, platform_data,
+						parent);
+}
+#endif
diff --git a/include/linux/of.h b/include/linux/of.h
index 435cb99..0bf0341 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -65,6 +65,21 @@ struct device_node {
 	unsigned int unique_id;
 	struct of_irq_controller *irq_trans;
 #endif
+#ifdef CONFIG_OF_DEPENDENCIES
+	/*
+	 * This is needed to keep track of already created devices.
+	 * The reason is that some drivers call of_platform_populate()
+	 * themself to populate e.g. their subtree. This would end up
+	 * that some devices would be initialzed twice with a dependency
+	 * based initialization. So instead of registering a device a second
+	 * time, the second call to of_platform_device_create_pdata() just
+	 * returns this pointer.
+	 * If the feature of dependency based initialization will end up
+	 * in mainline (and drivers will have fixed), this helper could
+	 * be removed.
+	 */
+	struct platform_device *dev_created;
+#endif
 };
 
 #define MAX_PHANDLE_ARGS 8
diff --git a/include/linux/of_dependencies.h b/include/linux/of_dependencies.h
new file mode 100644
index 0000000..e046ce2
--- /dev/null
+++ b/include/linux/of_dependencies.h
@@ -0,0 +1,61 @@
+#ifndef _LINUX_OF_DEPENDENCIES_H
+#define _LINUX_OF_DEPENDENCIES_H
+/*
+ * Definitions for building a deterministic initialization order based on
+ * dependencies defined in the device tree.
+ *
+ * Copyright (C) 2014 Alexander Holler <holler@ahsoftware.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/of_platform.h>
+
+/*
+ * Builds the initialization order.
+ *
+ * In favor of speed this function doesn't lock anything, so make sure nothing
+ * modifies the device tree while this functions runs.
+ *
+ * Will raise the refcount of all device tree nodes which ended up in the final
+ * initialization order by one.
+ *
+ * The phandle of some nodes will be modified (from 0 to a number) without
+ * adding a phandle property. But as this should not disturb anything, this
+ * change is not reversed after building the init order (for which the new
+ * phandles are temporarily necessary).
+ *
+ * This function is meant to be called only once.
+ */
+extern int of_init_build_order(struct device_node *root,
+			const struct of_device_id *matches);
+
+/*
+ * Replacement for of_platform_populate(). Creates all devices.
+ *
+ * By default it should be called with matches = NULL in order to create
+ * all devices. Reasoning is that every device contained in the DT which
+ * isn't disabled actually does exist (regardless if a driver is available
+ * or not).
+ *
+ * Decreases the node count of all nodes contained in the initialization order
+ * by one.
+ *
+ * This function is meant to be called only once.
+ */
+extern void of_init_create_devices(const struct of_device_id *matches,
+			const struct of_dev_auxdata *lookup);
+
+/*
+ * Decreases the node count of all nodes contained in the initialization order
+ * by one.
+ *
+ * This function is meant to be called only once instead of
+ * of_init_create_devices().
+ */
+extern void of_init_free_order(void);
+
+#endif	/* _LINUX_OF_DEPENDENCIES_H */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..04357ac 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -82,4 +82,9 @@ static inline int of_platform_populate(struct device_node *root,
 }
 #endif
 
+extern struct platform_device *of_dependencies_device_create(
+					struct device_node *bus,
+					const struct of_dev_auxdata *lookup,
+					struct device *parent);
+
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.8.3.1

