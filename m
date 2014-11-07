Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaKGQ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48318 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbaKGQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:26 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@kernel.org>
Subject: [PATCH 08/11] arm: perf: add functions to parse affinity from dt
Date: Fri,  7 Nov 2014 16:25:33 +0000
Message-Id: <1415377536-12841-9-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on hardware configuration, some devices may only be accessible
from certain CPUs, may have interrupts wired up to a subset of CPUs, or
may have operations which affect subsets of CPUs. To handle these
devices it is necessary to describe this affinity information in
devicetree.

This patch adds functions to handle parsing the CPU affinity of
properties from devicetree, based on Lorenzo's topology binding,
allowing subsets of CPUs to be associated with interrupts, hardware
ports, etc. The functions can be used to build cpumasks and also to test
whether an affinity property only targets one CPU independent of the
current configuration (e.g. when the kernel supports fewer CPUs than are
physically present). This is useful for dealing with mixed SPI/PPI
devices.

A device may have an arbitrary number of affinity properties, the
meaning of which is device-specific and should be specified in a given
device's binding document.

For example, an affinity property describing interrupt routing may
consist of a phandle pointing to a subtree of the topology nodes,
indicating the set of CPUs an interrupt originates from or may be taken
on. Bindings may have restrictions on the topology nodes referenced -
for describing coherency controls an affinity property may indicate a
whole cluster (including any non-CPU logic it contains) is affected by
some configuration.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@kernel.org>
---
 arch/arm/kernel/perf_event_cpu.c | 127 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index ce35149..dfcaba5 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -294,6 +295,132 @@ static int probe_current_pmu(struct arm_pmu *pmu)
 	return ret;
 }
 
+/*
+ * Test if the node is within the topology tree.
+ * Walk up to the root, keeping refcounts balanced.
+ */
+static bool is_topology_node(struct device_node *node)
+{
+	struct device_node *np, *cpu_map;
+	bool ret = false;
+
+	cpu_map = of_find_node_by_path("/cpus/cpu-map");
+	if (!cpu_map)
+		return false;
+
+	/*
+	 * of_get_next_parent decrements the refcount of the provided node.
+	 * Increment it first to keep things balanced.
+	 */
+	for (np = of_node_get(node); np; np = of_get_next_parent(np)) {
+		if (np != cpu_map)
+			continue;
+
+		ret = true;
+		break;
+	}
+
+	of_node_put(np);
+	of_node_put(cpu_map);
+	return ret;
+}
+
+static int cpu_node_to_id(struct device_node *node)
+{
+	int cpu;
+	for_each_possible_cpu(cpu)
+		if (of_cpu_device_node_get(cpu) == node)
+			return cpu;
+
+	return -EINVAL;
+}
+
+static int arm_dt_affine_build_mask(struct device_node *affine,
+				    cpumask_t *mask)
+{
+	struct device_node *child, *parent = NULL;
+	int ret = -EINVAL;
+
+	if (!is_topology_node(affine))
+		return -EINVAL;
+
+	child = of_node_get(affine);
+	if (!child)
+		goto out_invalid;
+
+	parent = of_get_parent(child);
+	if (!parent)
+		goto out_invalid;
+
+	if (!cpumask_empty(mask))
+		goto out_invalid;
+
+	/*
+	 * Depth-first search over the topology tree, iterating over leaf nodes
+	 * and adding all referenced CPUs to the cpumask. Almost all of the
+	 * of_* iterators are built for breadth-first search, which means we
+	 * have to do a little more work to ensure refcounts are balanced.
+	 */
+	do {
+		struct device_node *tmp, *cpu_node;
+		int cpu;
+
+		/* head down to the leaf */
+		while ((tmp = of_get_next_child(child, NULL))) {
+			of_node_put(parent);
+			parent = child;
+			child = tmp;
+		}
+
+		/*
+		 * In some cases cpu_node might be NULL, but cpu_node_to_id
+		 * will handle this (albeit slowly) and we don't need another
+		 * error path.
+		 */
+		cpu_node = of_parse_phandle(child, "cpu", 0);
+		cpu = cpu_node_to_id(cpu_node);
+
+		if (cpu < 0)
+			pr_warn("Invalid or unused node in topology description '%s', skipping\n",
+				child->full_name);
+		else
+			cpumask_set_cpu(cpu, mask);
+
+		of_node_put(cpu_node);
+
+		/*
+		 * Find the next sibling, or transitively a parent's sibling.
+		 * Don't go further up the tree than the affine node we were
+		 * handed.
+		 */
+		while (child != affine &&
+			!(child = of_get_next_child(parent, child))) {
+			child = parent;
+			parent = of_get_parent(parent);
+		}
+
+	} while (child != affine); /* all children covered. Time to stop */
+
+	ret = 0;
+
+out_invalid:
+	of_node_put(child);
+	of_node_put(parent);
+	return ret;
+}
+
+static int arm_dt_affine_get_mask(struct device_node *node, char *prop,
+				  int idx, cpumask_t *mask)
+{
+	int ret = -EINVAL;
+	struct device_node *affine = of_parse_phandle(node, prop, idx);
+
+	ret = arm_dt_affine_build_mask(affine, mask);
+
+	of_node_put(affine);
+	return ret;
+}
+
 static int cpu_pmu_device_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
-- 
1.9.1

