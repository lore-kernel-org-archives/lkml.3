Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3IRQIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:08:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34846 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab3IRQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:08:01 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH RFC 3/3] ARM: kernel: support cpu cache information interface to userspace via sysfs
Date: Wed, 18 Sep 2013 17:07:23 +0100
Message-Id: <1379520443-13857-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379520443-13857-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1379520443-13857-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch adds initial support for providing processor cache information
to userspace through sysfs interface. This is based on x86 implementation
and hence the interface is intended to be fully compatible.

A per-cpu array of cache information maintained is used mainly for
sysfs-related book keeping.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/kernel/cacheinfo.c | 316 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+)

diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index 631f070..4cd97f3 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -1,5 +1,7 @@
 /*
  *  ARM cacheinfo support
+ *  - Processor cache information interface to userspace via sysfs
+ *  - Based on intel cacheinfo implementation
  *
  *  Copyright (C) 2013 ARM Ltd.
  *  All Rights Reserved
@@ -14,10 +16,12 @@
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/kobject.h>
 #include <linux/of.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
+#include <linux/sysfs.h>
 
 #include <asm/outercache.h>
 #include <asm/processor.h>
@@ -369,3 +373,315 @@ static void free_cache_attributes(unsigned int cpu)
 	kfree(per_cpu_cacheinfo(cpu));
 	per_cpu_cacheinfo(cpu) = NULL;
 }
+
+#ifdef CONFIG_SYSFS
+
+struct cache_attr {
+	struct attribute attr;
+	 ssize_t(*show) (struct cpu_cacheinfo *, char *, unsigned int);
+	 ssize_t(*store) (struct cpu_cacheinfo *, const char *, size_t count,
+			  unsigned int);
+};
+
+/* pointer to kobject for cpuX/cache */
+static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
+#define per_cpu_cache_kobject(cpu)     (per_cpu(ci_cache_kobject, cpu))
+
+struct index_kobject {
+	struct kobject kobj;
+	unsigned int cpu;
+	unsigned short index;
+};
+
+static cpumask_t cache_dev_map;
+
+/* pointer to array of kobjects for cpuX/cache/indexY */
+static DEFINE_PER_CPU(struct index_kobject *, ci_index_kobject);
+#define per_cpu_index_kobject(cpu)     (per_cpu(ci_index_kobject, cpu))
+#define INDEX_KOBJECT_PTR(cpu, idx)    (&((per_cpu_index_kobject(cpu))[idx]))
+
+#define show_one_plus(file_name, object)				\
+static ssize_t show_##file_name(struct cpu_cacheinfo *this_leaf,	\
+				char *buf, unsigned int cpu)	    \
+{								      \
+	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object); \
+}
+
+show_one_plus(level, info.level);
+show_one_plus(coherency_line_size, info.coherency_line_size);
+show_one_plus(ways_of_associativity, info.ways_of_associativity);
+show_one_plus(number_of_sets, info.number_of_sets);
+
+static ssize_t show_size(struct cpu_cacheinfo *this_leaf, char *buf,
+			 unsigned int cpu)
+{
+	return sprintf(buf, "%dK\n", this_leaf->info.size / 1024);
+}
+
+static ssize_t show_shared_cpu_map_func(struct cpu_cacheinfo *this_leaf,
+					int type, char *buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	int n = 0;
+
+	if (len > 1) {
+		const struct cpumask *mask = &this_leaf->shared_cpu_map;
+		n = type ?
+		    cpulist_scnprintf(buf, len - 2, mask) :
+		    cpumask_scnprintf(buf, len - 2, mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
+static inline ssize_t show_shared_cpu_map(struct cpu_cacheinfo *leaf, char *buf,
+					  unsigned int cpu)
+{
+	return show_shared_cpu_map_func(leaf, 0, buf);
+}
+
+static inline ssize_t show_shared_cpu_list(struct cpu_cacheinfo *leaf,
+					   char *buf, unsigned int cpu)
+{
+	return show_shared_cpu_map_func(leaf, 1, buf);
+}
+
+static ssize_t show_type(struct cpu_cacheinfo *this_leaf, char *buf,
+			 unsigned int cpu)
+{
+	switch (this_leaf->info.type) {
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
+#define to_object(k)   container_of(k, struct index_kobject, kobj)
+#define to_attr(a)     container_of(a, struct cache_attr, attr)
+
+#define define_one_ro(_name) \
+static struct cache_attr _name = \
+	__ATTR(_name, 0444, show_##_name, NULL)
+
+define_one_ro(level);
+define_one_ro(type);
+define_one_ro(coherency_line_size);
+define_one_ro(ways_of_associativity);
+define_one_ro(number_of_sets);
+define_one_ro(size);
+define_one_ro(shared_cpu_map);
+define_one_ro(shared_cpu_list);
+
+static struct attribute *default_attrs[] = {
+	&type.attr,
+	&level.attr,
+	&coherency_line_size.attr,
+	&ways_of_associativity.attr,
+	&number_of_sets.attr,
+	&size.attr,
+	&shared_cpu_map.attr,
+	&shared_cpu_list.attr,
+	NULL
+};
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct cache_attr *fattr = to_attr(attr);
+	struct index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->show ?
+	    fattr->show(CPU_CACHEINFO_IDX(this_leaf->cpu, this_leaf->index),
+			buf, this_leaf->cpu) : 0;
+	return ret;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct cache_attr *fattr = to_attr(attr);
+	struct index_kobject *leaf_ptr = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->store ?
+	    fattr->store(CPU_CACHEINFO_IDX(leaf_ptr->cpu, leaf_ptr->index),
+			 buf, count, leaf_ptr->cpu) : 0;
+	return ret;
+}
+
+static const struct sysfs_ops sysfs_ops = {
+	.show = show,
+	.store = store,
+};
+
+static struct kobj_type ktype_cache = {
+	.sysfs_ops = &sysfs_ops,
+	.default_attrs = default_attrs,
+};
+
+static struct kobj_type ktype_percpu_entry = {
+	.sysfs_ops = &sysfs_ops,
+};
+
+static void cpu_cache_sysfs_exit(unsigned int cpu)
+{
+	kfree(per_cpu_cache_kobject(cpu));
+	kfree(per_cpu_index_kobject(cpu));
+	per_cpu_cache_kobject(cpu) = NULL;
+	per_cpu_index_kobject(cpu) = NULL;
+}
+
+static int cpu_cache_sysfs_init(unsigned int cpu)
+{
+	if (per_cpu_cacheinfo(cpu) == NULL)
+		return -ENOENT;
+
+	/* Allocate all required memory */
+	per_cpu_cache_kobject(cpu) =
+	    kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (unlikely(per_cpu_cache_kobject(cpu) == NULL))
+		goto err_out;
+
+	per_cpu_index_kobject(cpu) =
+	    kzalloc(sizeof(struct index_kobject) * cache_leaves(cpu),
+		    GFP_KERNEL);
+	if (unlikely(per_cpu_index_kobject(cpu) == NULL))
+		goto err_out;
+
+	return 0;
+
+err_out:
+	cpu_cache_sysfs_exit(cpu);
+	return -ENOMEM;
+}
+
+static void _detect_cache_attributes(void *_retval)
+{
+	int cpu = smp_processor_id();
+	*(int *)_retval = detect_cache_attributes(cpu);
+}
+
+/* Add/Remove cache interface for CPU device */
+static int cache_add_dev(struct device *dev)
+{
+	unsigned int cpu = dev->id;
+	unsigned long i, j;
+	struct index_kobject *this_object;
+	int retval;
+
+	smp_call_function_single(cpu, _detect_cache_attributes, &retval, true);
+	if (retval) {
+		pr_err("error populating cacheinfo..cpu%d\n", cpu);
+		return retval;
+	}
+	retval = cpu_cache_sysfs_init(cpu);
+	if (unlikely(retval < 0))
+		return retval;
+
+	retval = kobject_init_and_add(per_cpu_cache_kobject(cpu),
+				      &ktype_percpu_entry,
+				      &dev->kobj, "%s", "cache");
+	if (retval < 0) {
+		cpu_cache_sysfs_exit(cpu);
+		return retval;
+	}
+
+	for (i = 0; i < cache_leaves(cpu); i++) {
+		this_object = INDEX_KOBJECT_PTR(cpu, i);
+		this_object->cpu = cpu;
+		this_object->index = i;
+
+		retval = kobject_init_and_add(&(this_object->kobj),
+					      &ktype_cache,
+					      per_cpu_cache_kobject(cpu),
+					      "index%1lu", i);
+		if (unlikely(retval)) {
+			for (j = 0; j < i; j++)
+				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
+			kobject_put(per_cpu_cache_kobject(cpu));
+			cpu_cache_sysfs_exit(cpu);
+			return retval;
+		}
+		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
+	}
+	cpumask_set_cpu(cpu, &cache_dev_map);
+
+	kobject_uevent(per_cpu_cache_kobject(cpu), KOBJ_ADD);
+	return 0;
+}
+
+static void cache_remove_dev(struct device *dev)
+{
+	unsigned int cpu = dev->id;
+	unsigned long i;
+
+	if (!cpumask_test_cpu(cpu, &cache_dev_map))
+		return;
+	cpumask_clear_cpu(cpu, &cache_dev_map);
+
+	for (i = 0; i < cache_leaves(cpu); i++)
+		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
+	kobject_put(per_cpu_cache_kobject(cpu));
+	cpu_cache_sysfs_exit(cpu);
+
+	free_cache_attributes(cpu);
+}
+
+static int cacheinfo_cpu_callback(struct notifier_block *nfb,
+				  unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct device *dev = get_cpu_device(cpu);
+	int ret;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		ret = cache_add_dev(dev);
+		if (ret)
+			/* must not fail so can't use NOTIFY_BAD */
+			return NOTIFY_STOP;
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cache_remove_dev(dev);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cacheinfo_cpu_notifier = {
+	.notifier_call = cacheinfo_cpu_callback,
+};
+
+static int __init cache_info_init(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		int ret;
+		struct device *dev = get_cpu_device(cpu);
+		if (!dev) {
+			pr_err("No cpu device for CPU %d..skipping\n", cpu);
+			return -ENODEV;
+		}
+
+		ret = cache_add_dev(dev);
+		if (ret) {
+			pr_err("error populating cacheinfo..cpu%d\n", cpu);
+			return ret;
+		}
+	}
+	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
+	return 0;
+}
+
+device_initcall(cache_info_init);
+
+#endif /* CONFIG_SYSFS */
-- 
1.8.1.2

