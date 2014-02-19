Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaBSQGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:06:34 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50823 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753836AbaBSQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:06:13 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH RFC/RFT v3 2/9] drivers: base: support cpu cache information interface to userspace via sysfs
Date: Wed, 19 Feb 2014 16:06:09 +0000
Message-Id: <1392825976-17633-3-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch adds initial support for providing processor cache information
to userspace through sysfs interface. This is based on already existing
implementations(x86, ia64, s390 and powerpc) and hence the interface is
intended to be fully compatible.

The main purpose of this generic support is to avoid further code
duplication to support new architectures and also to unify all the existing
different implementations.

This implementation maintains the hierarchy of cache objects which reflects
the system's cache topology. Cache devices are instantiated as needed as
CPUs come online. The cache information is replicated per-cpu even if they are
shared. A per-cpu array of cache information maintained is used mainly for
sysfs-related book keeping.

It also implements the shared_cpu_map attribute, which is essential for
enabling both kernel and user-space to discover the system's overall cache
topology.

This patch also add the missing ABI documentation for the cacheinfo sysfs
interface already, which is well defined and widely used.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh@kernel.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  40 ++
 drivers/base/Makefile                              |   2 +-
 drivers/base/cacheinfo.c                           | 484 +++++++++++++++++++++
 include/linux/cacheinfo.h                          |  55 +++
 4 files changed, 580 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index d5a0d33..dabe03e 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -224,3 +224,43 @@ Description:	Parameters for the Intel P-state driver
 		frequency range.
 
 		More details can be found in Documentation/cpu-freq/intel-pstate.txt
+
+What:		/sys/devices/system/cpu/cpu*/cache/index*/<set_of_attributes_mentioned_below>
+Date:		February 2014
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Parameters for the CPU cache attributes
+
+		attributes:
+			- writethrough: data is written to both the cache line
+					and to the block in the lower-level memory
+			- writeback: data is written only to the cache line and
+				     the modified cache line is written to main
+				     memory only when it is replaced
+			- writeallocate: allocate a memory location to a cache line
+					 on a cache miss because of a write
+			- readallocate: allocate a memory location to a cache line
+					on a cache miss because of a read
+
+		coherency_line_size: the minimum amount of data that gets transferred
+
+		level: the cache hierarcy in the multi-level cache configuration
+
+		number_of_sets: total number of sets in the cache, a set is a
+				collection of cache lines with the same cache index
+
+		physical_line_partition: number of physical cache line per cache tag
+
+		shared_cpu_list: the list of cpus sharing the cache
+
+		shared_cpu_map: logical cpu mask containing the list of cpus sharing
+				the cache
+
+		size: the total cache size in kB
+
+		type:
+			- instruction: cache that only holds instructions
+			- data: cache that only caches data
+			- unified: cache that holds both data and instructions
+
+		ways_of_associativity: degree of freedom in placing a particular block
+					of memory in the cache
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e..bad2ff8 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o cacheinfo.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
new file mode 100644
index 0000000..146acc8
--- /dev/null
+++ b/drivers/base/cacheinfo.c
@@ -0,0 +1,484 @@
+/*
+ * cacheinfo support - processor cache information via sysfs
+ *
+ * Based on arch/x86/kernel/cpu/intel_cacheinfo.c
+ * Author: Sudeep Holla <sudeep.holla@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+#include <linux/bitops.h>
+#include <linux/cacheinfo.h>
+#include <linux/compiler.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/sysfs.h>
+
+/* pointer to cpu_cacheinfo array (for each cache leaf) */
+static DEFINE_PER_CPU(struct cpu_cacheinfo, ci_cpu_cache_info);
+#define ci_cacheinfo(cpu)	(&per_cpu(ci_cpu_cache_info, cpu))
+#define cache_leaves(cpu)	(ci_cacheinfo(cpu)->num_leaves)
+#define per_cpu_cacheinfo(cpu)	(ci_cacheinfo(cpu)->info_list)
+
+struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu)
+{
+	return ci_cacheinfo(cpu);
+}
+
+#ifdef CONFIG_OF
+static int cache_setup_of_node(unsigned int cpu)
+{
+	struct device_node *np;
+	struct cache_info *this_leaf;
+	struct device *cpu_dev = get_cpu_device(cpu);
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	unsigned int index = 0;
+
+	/* skip if of_node is already populated */
+	if (this_cpu_ci->info_list->of_node)
+		return 0;
+
+	if (!cpu_dev) {
+		pr_err("No cpu device for CPU %d\n", cpu);
+		return -ENODEV;
+	}
+	np = cpu_dev->of_node;
+	if (!np) {
+		pr_err("Failed to find cpu%d device node\n", cpu);
+		return -ENOENT;
+	}
+
+	while (np && index < cache_leaves(cpu)) {
+		this_leaf = this_cpu_ci->info_list + index;
+		if (this_leaf->level != 1)
+			np = of_find_next_cache_node(np);
+		else
+			np = of_node_get(np);/* cpu node itself */
+		this_leaf->of_node = np;
+		index++;
+	}
+	return 0;
+}
+
+static inline bool cache_leaves_are_shared(struct cache_info *this_leaf,
+					   struct cache_info *sib_leaf)
+{
+	return sib_leaf->of_node == this_leaf->of_node;
+}
+
+static int of_cache_shared_cpu_map_setup(unsigned int cpu)
+{
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cache_info *this_leaf, *sib_leaf;
+	unsigned int index;
+	int ret;
+
+	ret = cache_setup_of_node(cpu);
+	if (ret)
+		return ret;
+
+	for (index = 0; index < cache_leaves(cpu); index++) {
+		unsigned int i;
+		this_leaf = this_cpu_ci->info_list + index;
+		cpumask_set_cpu(cpu, &this_leaf->shared_cpu_map);
+
+		for_each_online_cpu(i) {
+			struct cpu_cacheinfo *sib_cpu_ci = get_cpu_cacheinfo(i);
+			if (i == cpu || !sib_cpu_ci->info_list)
+				continue;/* skip if itself or no cacheinfo */
+			sib_leaf = sib_cpu_ci->info_list + index;
+			if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+				cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
+				cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+			}
+		}
+	}
+
+	return 0;
+}
+#else
+static inline int of_cache_shared_cpu_map_setup(unsigned int cpu)
+{
+	return 0;
+}
+#endif
+
+static void cache_shared_cpu_map_remove(unsigned int cpu)
+{
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cache_info *this_leaf, *sib_leaf;
+	unsigned int sibling, index;
+
+	for (index = 0; index < cache_leaves(cpu); index++) {
+		this_leaf = this_cpu_ci->info_list + index;
+		for_each_cpu(sibling, &this_leaf->shared_cpu_map) {
+			struct cpu_cacheinfo *sib_cpu_ci;
+			if (sibling == cpu) /* skip itself */
+				continue;
+			sib_cpu_ci = get_cpu_cacheinfo(sibling);
+			sib_leaf = sib_cpu_ci->info_list + index;
+			cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
+			cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+		}
+		of_node_put(this_leaf->of_node);
+	}
+}
+
+int __weak init_cache_level(unsigned int cpu)
+{
+	return -ENOENT;
+}
+
+int __weak populate_cache_leaves(unsigned int cpu)
+{
+	return -ENOENT;
+}
+
+static void free_cache_attributes(unsigned int cpu)
+{
+	cache_shared_cpu_map_remove(cpu);
+
+	kfree(per_cpu_cacheinfo(cpu));
+	per_cpu_cacheinfo(cpu) = NULL;
+}
+
+/* must be executed on the cpu whose cache attributes are being detected */
+static int detect_cache_attributes(unsigned int cpu)
+{
+	int ret;
+
+	if (init_cache_level(cpu))
+		return -ENOENT;
+
+	per_cpu_cacheinfo(cpu) = kzalloc(sizeof(struct cache_info) *
+					 cache_leaves(cpu), GFP_KERNEL);
+	if (per_cpu_cacheinfo(cpu) == NULL)
+		return -ENOMEM;
+
+	ret = populate_cache_leaves(cpu);
+	if (ret)
+		goto free_ci;
+	/*
+	 * For systems using DT for cache hierarcy, of_node and shared_cpu_map
+	 * will be set up here. Otherwise populate_cache_leaves needs to set
+	 * shared_cpu_map and next-level-cache should not be specified in DT
+	 */
+	ret = of_cache_shared_cpu_map_setup(cpu);
+	if (ret)
+		goto free_ci;
+	return 0;
+
+free_ci:
+	free_cache_attributes(cpu);
+	return ret;
+}
+
+#ifdef CONFIG_SYSFS
+
+/* pointer to cpuX/cache device */
+static DEFINE_PER_CPU(struct device *, ci_cache_dev);
+#define per_cpu_cache_dev(cpu)	(per_cpu(ci_cache_dev, cpu))
+
+static cpumask_t cache_dev_map;
+
+/* pointer to array of devices for cpuX/cache/indexY */
+static DEFINE_PER_CPU(struct device **, ci_index_dev);
+#define per_cpu_index_dev(cpu)	(per_cpu(ci_index_dev, cpu))
+#define per_cache_index_dev(cpu, idx)	((per_cpu_index_dev(cpu))[idx])
+
+#define show_one_plus(file_name, object)			\
+static ssize_t file_name##_show(struct device *dev,		\
+		struct device_attribute *attr, char *buf)	\
+{								\
+	struct cache_info *this_leaf = dev_get_drvdata(dev);	\
+	if (!this_leaf->object)					\
+		return sprintf(buf, "Unknown\n");		\
+	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object); \
+}
+
+show_one_plus(level, level);
+show_one_plus(coherency_line_size, coherency_line_size);
+show_one_plus(ways_of_associativity, ways_of_associativity);
+show_one_plus(number_of_sets, number_of_sets);
+show_one_plus(physical_line_partition, physical_line_partition);
+
+static ssize_t size_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct cache_info *this_leaf = dev_get_drvdata(dev);
+	return sprintf(buf, "%dK\n", this_leaf->size >> 10);
+}
+
+static ssize_t shared_cpumap_show_func(struct device *dev, int type, char *buf)
+{
+	struct cache_info *this_leaf = dev_get_drvdata(dev);
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	int n = 0;
+
+	if (len > 1) {
+		const struct cpumask *mask = &this_leaf->shared_cpu_map;
+		n = type ? cpulist_scnprintf(buf, len - 2, mask) :
+			   cpumask_scnprintf(buf, len - 2, mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
+static ssize_t shared_cpu_map_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return shared_cpumap_show_func(dev, 0, buf);
+}
+
+static ssize_t shared_cpu_list_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return shared_cpumap_show_func(dev, 1, buf);
+}
+
+static ssize_t type_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct cache_info *this_leaf = dev_get_drvdata(dev);
+	switch (this_leaf->type) {
+	case CACHE_TYPE_DATA:
+		return sprintf(buf, "Data\n");
+	case CACHE_TYPE_INST:
+		return sprintf(buf, "Instruction\n");
+	case CACHE_TYPE_UNIFIED:
+		return sprintf(buf, "Unified\n");
+	default:
+		return sprintf(buf, "Unknown\n");
+	}
+}
+
+static ssize_t attributes_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct cache_info *this_leaf = dev_get_drvdata(dev);
+	unsigned int ci_attr = this_leaf->attributes;
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
+	int n = 0;
+
+	if (!ci_attr)
+		return sprintf(buf, "Unknown\n");
+
+	if (ci_attr & CACHE_WRITE_THROUGH)
+		n += snprintf(buf + n, len - n, "WriteThrough\n");
+	if (ci_attr & CACHE_WRITE_BACK)
+		n += snprintf(buf + n, len - n, "WriteBack\n");
+	if (ci_attr & CACHE_READ_ALLOCATE)
+		n += snprintf(buf + n, len - n, "ReadAllocate\n");
+	if (ci_attr & CACHE_WRITE_ALLOCATE)
+		n += snprintf(buf + n, len - n, "WriteAllocate\n");
+	buf[n] = '\0';
+	return n;
+}
+
+#define define_one_ro(_name) \
+	static DEVICE_ATTR_RO(_name)
+
+define_one_ro(level);
+define_one_ro(type);
+define_one_ro(coherency_line_size);
+define_one_ro(ways_of_associativity);
+define_one_ro(number_of_sets);
+define_one_ro(size);
+define_one_ro(attributes);
+define_one_ro(shared_cpu_map);
+define_one_ro(shared_cpu_list);
+define_one_ro(physical_line_partition);
+
+static struct attribute *cache_default_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_level.attr,
+	&dev_attr_coherency_line_size.attr,
+	&dev_attr_ways_of_associativity.attr,
+	&dev_attr_number_of_sets.attr,
+	&dev_attr_size.attr,
+	&dev_attr_attributes.attr,
+	&dev_attr_physical_line_partition.attr,
+	&dev_attr_shared_cpu_map.attr,
+	&dev_attr_shared_cpu_list.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(cache_default);
+
+static void cpu_cache_sysfs_exit(unsigned int cpu)
+{
+	int i;
+	if (per_cpu_index_dev(cpu)) {
+		for (i = 0; i < cache_leaves(cpu); i++) {
+			struct device *tmp_dev = per_cache_index_dev(cpu, i);
+			if (!tmp_dev)
+				continue;
+			put_device(tmp_dev);
+			device_unregister(tmp_dev);
+		}
+		kfree(per_cpu_index_dev(cpu));
+		per_cpu_index_dev(cpu) = NULL;
+	}
+	put_device(per_cpu_cache_dev(cpu));
+	device_unregister(per_cpu_cache_dev(cpu));
+	per_cpu_cache_dev(cpu) = NULL;
+}
+
+static int cpu_cache_sysfs_init(unsigned int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+
+	if (per_cpu_cacheinfo(cpu) == NULL)
+		return -ENOENT;
+
+	per_cpu_cache_dev(cpu) = device_create(dev->class, dev, cpu,
+					       NULL, "cache");
+	if (IS_ERR_OR_NULL(per_cpu_cache_dev(cpu)))
+		return PTR_ERR(per_cpu_cache_dev(cpu));
+
+	/* Allocate all required memory */
+	per_cpu_index_dev(cpu) = kzalloc(sizeof(struct device *) *
+					     cache_leaves(cpu), GFP_KERNEL);
+	if (unlikely(per_cpu_index_dev(cpu) == NULL))
+		goto err_out;
+
+	return 0;
+
+err_out:
+	cpu_cache_sysfs_exit(cpu);
+	return -ENOMEM;
+}
+
+int __weak cache_add_private_attributes(struct device *cache_idx_dev)
+{
+	return 0;
+}
+
+/* Add/Remove cache interface for CPU device */
+static int cache_add_dev(unsigned int cpu)
+{
+	struct device *tmp_dev, *parent;
+	struct cache_info *this_leaf;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	unsigned short i;
+	int rc;
+
+	rc = cpu_cache_sysfs_init(cpu);
+	if (unlikely(rc < 0))
+		return rc;
+
+	parent = per_cpu_cache_dev(cpu);
+	for (i = 0; i < cache_leaves(cpu); i++) {
+		this_leaf = this_cpu_ci->info_list + i;
+		if (this_leaf->disable_sysfs)
+			continue;
+		tmp_dev = device_create_with_groups(parent->class, parent, i,
+						    this_leaf,
+						    cache_default_groups,
+						    "index%1u", i);
+		if (IS_ERR_OR_NULL(tmp_dev)) {
+			rc = PTR_ERR(tmp_dev);
+			goto err;
+		}
+
+		rc = cache_add_private_attributes(tmp_dev);
+		if (unlikely(rc))
+			goto err;
+
+		per_cache_index_dev(cpu, i) = tmp_dev;
+	}
+	cpumask_set_cpu(cpu, &cache_dev_map);
+
+	return 0;
+err:
+	cpu_cache_sysfs_exit(cpu);
+	return rc;
+}
+
+static void cache_remove_dev(unsigned int cpu)
+{
+	if (!cpumask_test_cpu(cpu, &cache_dev_map))
+		return;
+	cpumask_clear_cpu(cpu, &cache_dev_map);
+
+	cpu_cache_sysfs_exit(cpu);
+}
+
+static int cacheinfo_cpu_callback(struct notifier_block *nfb,
+				  unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	int rc = 0;
+
+	switch (action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		rc = detect_cache_attributes(cpu);
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		rc = cache_add_dev(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cache_remove_dev(cpu);
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		if (per_cpu_cacheinfo(cpu))
+			free_cache_attributes(cpu);
+		break;
+	}
+	return notifier_from_errno(rc);
+}
+
+/* Helpers to make sure detect_cache_attributes is called on right cpu */
+static void _detect_cache_attributes(void *retval)
+{
+	int cpu = smp_processor_id();
+	*(int *)retval = detect_cache_attributes(cpu);
+}
+
+static int __detect_cache_attributes(unsigned int cpu)
+{
+	int retval;
+	smp_call_function_single(cpu, _detect_cache_attributes, &retval, true);
+	return retval;
+}
+
+static int __init cacheinfo_sysfs_init(void)
+{
+	int cpu;
+	int rc;
+
+	for_each_online_cpu(cpu) {
+		rc = __detect_cache_attributes(cpu);
+		if (rc) {
+			pr_err("error detecting cacheinfo..cpu%d\n", cpu);
+			return rc;
+		}
+		rc = cache_add_dev(cpu);
+		if (rc) {
+			free_cache_attributes(cpu);
+			pr_err("error populating cacheinfo..cpu%d\n", cpu);
+			return rc;
+		}
+	}
+	hotcpu_notifier(cacheinfo_cpu_callback, 0);
+	return 0;
+}
+
+device_initcall(cacheinfo_sysfs_init);
+
+#endif	/* CONFIG_SYSFS */
diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
new file mode 100644
index 0000000..fa61d83
--- /dev/null
+++ b/include/linux/cacheinfo.h
@@ -0,0 +1,55 @@
+#ifndef _LINUX_CACHEINFO_H
+#define _LINUX_CACHEINFO_H
+
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <linux/cpumask.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/sysfs.h>
+
+enum cache_type {
+	CACHE_TYPE_NOCACHE = 0,
+	CACHE_TYPE_INST = BIT(0),
+	CACHE_TYPE_DATA = BIT(1),
+	CACHE_TYPE_SEPARATE = CACHE_TYPE_INST | CACHE_TYPE_DATA,
+	CACHE_TYPE_UNIFIED = BIT(2),
+};
+
+struct cache_info {
+	/* core properties */
+	enum cache_type type; /* data, inst or unified */
+	unsigned int level;
+	unsigned int coherency_line_size; /* cache line size  */
+	unsigned int number_of_sets; /* no. of sets per way */
+	unsigned int ways_of_associativity; /* no. of ways */
+	unsigned int physical_line_partition; /* no. of lines per tag */
+	unsigned int size; /* total cache size */
+	cpumask_t shared_cpu_map;
+	unsigned int attributes;
+#define CACHE_WRITE_THROUGH	BIT(0)
+#define CACHE_WRITE_BACK	BIT(1)
+#define CACHE_READ_ALLOCATE	BIT(2)
+#define CACHE_WRITE_ALLOCATE	BIT(3)
+
+	/* book keeping */
+	struct device_node *of_node;	/* cpu if no explicit cache node */
+	bool disable_sysfs; /* don't expose this leaf through sysfs */
+	void *priv;
+};
+
+struct cpu_cacheinfo {
+	struct cache_info *info_list;
+	unsigned int num_levels;
+	unsigned int num_leaves;
+};
+
+struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu);
+int init_cache_level(unsigned int cpu);
+int populate_cache_leaves(unsigned int cpu);
+
+#ifdef CONFIG_SYSFS
+int cache_add_private_attributes(struct device *cache_idx_dev);
+#endif
+
+#endif /* _LINUX_CACHEINFO_H */
-- 
1.8.3.2

