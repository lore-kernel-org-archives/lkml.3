Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaAHT1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:27:47 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54446 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756921AbaAHT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:27:39 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: sudeep.holla@arm.com, Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 1/3] drivers: base: support cpu cache information interface to userspace via sysfs
Date: Wed,  8 Jan 2014 19:26:06 +0000
Message-Id: <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch adds initial support for providing processor cache information
to userspace through sysfs interface. This is based on x86 implementation
and hence the interface is intended to be fully compatible.

A per-cpu array of cache information maintained is used mainly for
sysfs-related book keeping.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/base/Makefile     |   2 +-
 drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cacheinfo.h |  43 +++++++
 3 files changed, 340 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 94e8a80..76f07c8 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o
+			   topology.o cacheinfo.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
new file mode 100644
index 0000000..f436c31
--- /dev/null
+++ b/drivers/base/cacheinfo.c
@@ -0,0 +1,296 @@
+/*
+ * cacheinfo support - processor cache information via sysfs
+ *
+ * Copyright (C) 2013 ARM Ltd.
+ * All Rights Reserved
+ *
+ * Author: Sudeep Holla <sudeep.holla@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/bitops.h>
+#include <linux/cacheinfo.h>
+#include <linux/compiler.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/sysfs.h>
+
+struct cache_attr {
+	struct attribute attr;
+	 ssize_t(*show) (unsigned int, unsigned short, char *);
+	 ssize_t(*store) (unsigned int, unsigned short, const char *, size_t);
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
+static ssize_t show_##file_name(unsigned int cpu, unsigned short index,	\
+				char *buf)				\
+{									\
+	return sprintf(buf, "%d\n", cacheinfo_##object(cpu, index));	\
+}
+
+show_one_plus(level, level);
+show_one_plus(coherency_line_size, linesize);
+show_one_plus(ways_of_associativity, associativity);
+show_one_plus(number_of_sets, sets);
+
+static ssize_t show_size(unsigned int cpu, unsigned short index, char *buf)
+{
+	return sprintf(buf, "%dK\n", cacheinfo_size(cpu, index) / 1024);
+}
+
+static ssize_t show_shared_cpu_map_func(unsigned int cpu, unsigned short index,
+					int type, char *buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	int n = 0;
+
+	if (len > 1) {
+		const struct cpumask *mask = cacheinfo_cpumap(cpu, index);
+		n = type ?
+		    cpulist_scnprintf(buf, len - 2, mask) :
+		    cpumask_scnprintf(buf, len - 2, mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
+static inline ssize_t show_shared_cpu_map(unsigned int cpu,
+					  unsigned short index, char *buf)
+{
+	return show_shared_cpu_map_func(cpu, index, 0, buf);
+}
+
+static inline ssize_t show_shared_cpu_list(unsigned int cpu,
+					  unsigned short index, char *buf)
+{
+	return show_shared_cpu_map_func(cpu, index, 1, buf);
+}
+
+static ssize_t show_type(unsigned int cpu, unsigned short index, char *buf)
+{
+	return sprintf(buf, cacheinfo_type(cpu, index));
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
+	    fattr->show(this_leaf->cpu, this_leaf->index, buf) : 0;
+	return ret;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct cache_attr *fattr = to_attr(attr);
+	struct index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->store ?
+	    fattr->store(this_leaf->cpu, this_leaf->index, buf, count) : 0;
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
+	if (!cacheinfo_populated(cpu))
+		return -ENOENT;
+
+	/* Allocate all required memory */
+	per_cpu_cache_kobject(cpu) =
+	    kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (unlikely(per_cpu_cache_kobject(cpu) == NULL))
+		goto err_out;
+
+	per_cpu_index_kobject(cpu) = kzalloc(sizeof(struct index_kobject) *
+					cacheinfo_leaf_count(cpu), GFP_KERNEL);
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
+/* Add/Remove cache interface for CPU device */
+static int cache_add_dev(unsigned int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+	struct index_kobject *this_object;
+	unsigned long i, j;
+	int rc;
+
+	rc = cpu_cache_sysfs_init(cpu);
+	if (unlikely(rc < 0))
+		return rc;
+
+	rc = kobject_init_and_add(per_cpu_cache_kobject(cpu),
+				      &ktype_percpu_entry,
+				      &dev->kobj, "%s", "cache");
+	if (rc < 0) {
+		cpu_cache_sysfs_exit(cpu);
+		return rc;
+	}
+
+	for (i = 0; i < cacheinfo_leaf_count(cpu); i++) {
+		this_object = INDEX_KOBJECT_PTR(cpu, i);
+		this_object->cpu = cpu;
+		this_object->index = i;
+
+		rc = kobject_init_and_add(&(this_object->kobj),
+					      &ktype_cache,
+					      per_cpu_cache_kobject(cpu),
+					      "index%1lu", i);
+		if (unlikely(rc)) {
+			for (j = 0; j < i; j++)
+				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
+			kobject_put(per_cpu_cache_kobject(cpu));
+			cpu_cache_sysfs_exit(cpu);
+			return rc;
+		}
+		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
+	}
+	cpumask_set_cpu(cpu, &cache_dev_map);
+
+	kobject_uevent(per_cpu_cache_kobject(cpu), KOBJ_ADD);
+	return 0;
+}
+
+static void cache_remove_dev(unsigned int cpu)
+{
+	unsigned long i;
+
+	if (!cpumask_test_cpu(cpu, &cache_dev_map))
+		return;
+	cpumask_clear_cpu(cpu, &cache_dev_map);
+
+	for (i = 0; i < cacheinfo_leaf_count(cpu); i++)
+		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
+	kobject_put(per_cpu_cache_kobject(cpu));
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
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		rc = cache_add_dev(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cache_remove_dev(cpu);
+		break;
+	}
+	return notifier_from_errno(rc);
+}
+
+static int __init cacheinfo_sysfs_init(void)
+{
+	int cpu;
+	int rc;
+
+	for_each_online_cpu(cpu) {
+		rc = cache_add_dev(cpu);
+		if (rc) {
+			pr_err("error populating cacheinfo..cpu%d\n", cpu);
+			return rc;
+		}
+	}
+	hotcpu_notifier(cacheinfo_cpu_callback, 0);
+	return 0;
+}
+
+device_initcall(cacheinfo_sysfs_init);
diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
new file mode 100644
index 0000000..917eccf
--- /dev/null
+++ b/include/linux/cacheinfo.h
@@ -0,0 +1,43 @@
+#ifndef _LINUX_CACHEINFO_H
+#define _LINUX_CACHEINFO_H
+
+#include <linux/cpumask.h>
+#include <linux/bitops.h>
+#include <linux/mmzone.h>
+#include <linux/smp.h>
+#include <linux/percpu.h>
+
+int __weak cacheinfo_leaf_count(unsigned int cpu) { return 0; }
+bool __weak cacheinfo_populated(unsigned int cpu) { return 0; }
+unsigned int __weak cacheinfo_level(unsigned int cpu, unsigned short idx)
+{
+	return 0;
+}
+unsigned int __weak cacheinfo_linesize(unsigned int cpu, unsigned short idx)
+{
+	return 0;
+}
+unsigned int __weak cacheinfo_associativity(unsigned int cpu,
+					    unsigned short idx)
+{
+	return 0;
+}
+unsigned int __weak cacheinfo_sets(unsigned int cpu, unsigned short idx)
+{
+	return 0;
+}
+unsigned int __weak cacheinfo_size(unsigned int cpu, unsigned short idx)
+{
+	return 0;
+}
+char * __weak cacheinfo_type(unsigned int cpu, unsigned short idx)
+{
+	return "Unknown\n";
+}
+const struct cpumask * __weak cacheinfo_cpumap(unsigned int cpu,
+					       unsigned short idx)
+{
+	return cpumask_of(cpu);
+}
+
+#endif /* _LINUX_CACHEINFO_H */
-- 
1.8.3.2

