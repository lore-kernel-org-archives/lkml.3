Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935067AbaGYQsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:48:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53856 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760696AbaGYQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:44:41 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 4/9] s390: move cacheinfo sysfs to generic cacheinfo infrastructure
Date: Fri, 25 Jul 2014 17:44:47 +0100
Message-Id: <1406306692-7135-5-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com>
 <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch removes the redundant sysfs cacheinfo code by making use of
the newly introduced generic cacheinfo infrastructure.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/kernel/cache.c | 388 +++++++++++------------------------------------
 1 file changed, 92 insertions(+), 296 deletions(-)

diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
index c0b03c28d157..fe21f074cf9f 100644
--- a/arch/s390/kernel/cache.c
+++ b/arch/s390/kernel/cache.c
@@ -5,37 +5,11 @@
  *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
  */
 
-#include <linux/notifier.h>
 #include <linux/seq_file.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/cacheinfo.h>
 #include <asm/facility.h>
 
-struct cache {
-	unsigned long size;
-	unsigned int line_size;
-	unsigned int associativity;
-	unsigned int nr_sets;
-	unsigned int level   : 3;
-	unsigned int type    : 2;
-	unsigned int private : 1;
-	struct list_head list;
-};
-
-struct cache_dir {
-	struct kobject *kobj;
-	struct cache_index_dir *index;
-};
-
-struct cache_index_dir {
-	struct kobject kobj;
-	int cpu;
-	struct cache *cache;
-	struct cache_index_dir *next;
-};
-
 enum {
 	CACHE_SCOPE_NOTEXISTS,
 	CACHE_SCOPE_PRIVATE,
@@ -44,10 +18,10 @@ enum {
 };
 
 enum {
-	CACHE_TYPE_SEPARATE,
-	CACHE_TYPE_DATA,
-	CACHE_TYPE_INSTRUCTION,
-	CACHE_TYPE_UNIFIED,
+	CTYPE_SEPARATE,
+	CTYPE_DATA,
+	CTYPE_INSTRUCTION,
+	CTYPE_UNIFIED,
 };
 
 enum {
@@ -70,39 +44,59 @@ struct cache_info {
 };
 
 #define CACHE_MAX_LEVEL 8
-
 union cache_topology {
 	struct cache_info ci[CACHE_MAX_LEVEL];
 	unsigned long long raw;
 };
 
 static const char * const cache_type_string[] = {
-	"Data",
+	"",
 	"Instruction",
+	"Data",
+	"",
 	"Unified",
 };
 
-static struct cache_dir *cache_dir_cpu[NR_CPUS];
-static LIST_HEAD(cache_list);
+static const enum cache_type cache_type_map[] = {
+	[CTYPE_SEPARATE] = CACHE_TYPE_SEPARATE,
+	[CTYPE_DATA] = CACHE_TYPE_DATA,
+	[CTYPE_INSTRUCTION] = CACHE_TYPE_INST,
+	[CTYPE_UNIFIED] = CACHE_TYPE_UNIFIED,
+};
 
 void show_cacheinfo(struct seq_file *m)
 {
-	struct cache *cache;
-	int index = 0;
+	int cpu = smp_processor_id(), idx;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *cache;
 
-	list_for_each_entry(cache, &cache_list, list) {
-		seq_printf(m, "cache%-11d: ", index);
+	for (idx = 0; idx < this_cpu_ci->num_leaves; idx++) {
+		cache = this_cpu_ci->info_list + idx;
+		seq_printf(m, "cache%-11d: ", idx);
 		seq_printf(m, "level=%d ", cache->level);
 		seq_printf(m, "type=%s ", cache_type_string[cache->type]);
-		seq_printf(m, "scope=%s ", cache->private ? "Private" : "Shared");
-		seq_printf(m, "size=%luK ", cache->size >> 10);
-		seq_printf(m, "line_size=%u ", cache->line_size);
-		seq_printf(m, "associativity=%d", cache->associativity);
+		seq_printf(m, "scope=%s ",
+			   cache->disable_sysfs ? "Shared" : "Private");
+		seq_printf(m, "size=%dK ", cache->size >> 10);
+		seq_printf(m, "line_size=%u ", cache->coherency_line_size);
+		seq_printf(m, "associativity=%d", cache->ways_of_associativity);
 		seq_puts(m, "\n");
-		index++;
 	}
 }
 
+static inline enum cache_type get_cache_type(struct cache_info *ci, int level)
+{
+	if (level >= CACHE_MAX_LEVEL)
+		return CACHE_TYPE_NOCACHE;
+
+	ci += level;
+
+	if (ci->scope != CACHE_SCOPE_SHARED && ci->scope != CACHE_SCOPE_PRIVATE)
+		return CACHE_TYPE_NOCACHE;
+
+	return cache_type_map[ci->type];
+}
+
 static inline unsigned long ecag(int ai, int li, int ti)
 {
 	unsigned long cmd, val;
@@ -113,277 +107,79 @@ static inline unsigned long ecag(int ai, int li, int ti)
 	return val;
 }
 
-static int __init cache_add(int level, int private, int type)
+static void ci_leaf_init(struct cacheinfo *this_leaf, int private,
+			 enum cache_type type, unsigned int level)
 {
-	struct cache *cache;
-	int ti;
+	int ti, num_sets;
+	int cpu = smp_processor_id();
 
-	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
-	if (!cache)
-		return -ENOMEM;
-	if (type == CACHE_TYPE_INSTRUCTION)
+	if (type == CACHE_TYPE_INST)
 		ti = CACHE_TI_INSTRUCTION;
 	else
 		ti = CACHE_TI_UNIFIED;
-	cache->size = ecag(EXTRACT_SIZE, level, ti);
-	cache->line_size = ecag(EXTRACT_LINE_SIZE, level, ti);
-	cache->associativity = ecag(EXTRACT_ASSOCIATIVITY, level, ti);
-	cache->nr_sets = cache->size / cache->associativity;
-	cache->nr_sets /= cache->line_size;
-	cache->private = private;
-	cache->level = level + 1;
-	cache->type = type - 1;
-	list_add_tail(&cache->list, &cache_list);
-	return 0;
-}
-
-static void __init cache_build_info(void)
-{
-	struct cache *cache, *next;
-	union cache_topology ct;
-	int level, private, rc;
-
-	ct.raw = ecag(EXTRACT_TOPOLOGY, 0, 0);
-	for (level = 0; level < CACHE_MAX_LEVEL; level++) {
-		switch (ct.ci[level].scope) {
-		case CACHE_SCOPE_SHARED:
-			private = 0;
-			break;
-		case CACHE_SCOPE_PRIVATE:
-			private = 1;
-			break;
-		default:
-			return;
-		}
-		if (ct.ci[level].type == CACHE_TYPE_SEPARATE) {
-			rc  = cache_add(level, private, CACHE_TYPE_DATA);
-			rc |= cache_add(level, private, CACHE_TYPE_INSTRUCTION);
-		} else {
-			rc = cache_add(level, private, ct.ci[level].type);
-		}
-		if (rc)
-			goto error;
-	}
-	return;
-error:
-	list_for_each_entry_safe(cache, next, &cache_list, list) {
-		list_del(&cache->list);
-		kfree(cache);
-	}
-}
-
-static struct cache_dir *cache_create_cache_dir(int cpu)
-{
-	struct cache_dir *cache_dir;
-	struct kobject *kobj = NULL;
-	struct device *dev;
-
-	dev = get_cpu_device(cpu);
-	if (!dev)
-		goto out;
-	kobj = kobject_create_and_add("cache", &dev->kobj);
-	if (!kobj)
-		goto out;
-	cache_dir = kzalloc(sizeof(*cache_dir), GFP_KERNEL);
-	if (!cache_dir)
-		goto out;
-	cache_dir->kobj = kobj;
-	cache_dir_cpu[cpu] = cache_dir;
-	return cache_dir;
-out:
-	kobject_put(kobj);
-	return NULL;
-}
-
-static struct cache_index_dir *kobj_to_cache_index_dir(struct kobject *kobj)
-{
-	return container_of(kobj, struct cache_index_dir, kobj);
-}
-
-static void cache_index_release(struct kobject *kobj)
-{
-	struct cache_index_dir *index;
-
-	index = kobj_to_cache_index_dir(kobj);
-	kfree(index);
-}
-
-static ssize_t cache_index_show(struct kobject *kobj,
-				struct attribute *attr, char *buf)
-{
-	struct kobj_attribute *kobj_attr;
-
-	kobj_attr = container_of(attr, struct kobj_attribute, attr);
-	return kobj_attr->show(kobj, kobj_attr, buf);
-}
-
-#define DEFINE_CACHE_ATTR(_name, _format, _value)			\
-static ssize_t cache_##_name##_show(struct kobject *kobj,		\
-				    struct kobj_attribute *attr,	\
-				    char *buf)				\
-{									\
-	struct cache_index_dir *index;					\
-									\
-	index = kobj_to_cache_index_dir(kobj);				\
-	return sprintf(buf, _format, _value);				\
-}									\
-static struct kobj_attribute cache_##_name##_attr =			\
-	__ATTR(_name, 0444, cache_##_name##_show, NULL);
 
-DEFINE_CACHE_ATTR(size, "%luK\n", index->cache->size >> 10);
-DEFINE_CACHE_ATTR(coherency_line_size, "%u\n", index->cache->line_size);
-DEFINE_CACHE_ATTR(number_of_sets, "%u\n", index->cache->nr_sets);
-DEFINE_CACHE_ATTR(ways_of_associativity, "%u\n", index->cache->associativity);
-DEFINE_CACHE_ATTR(type, "%s\n", cache_type_string[index->cache->type]);
-DEFINE_CACHE_ATTR(level, "%d\n", index->cache->level);
+	this_leaf->level = level + 1;
+	this_leaf->type = type;
+	this_leaf->coherency_line_size = ecag(EXTRACT_LINE_SIZE, level, ti);
+	this_leaf->ways_of_associativity = ecag(EXTRACT_ASSOCIATIVITY,
+						level, ti);
+	this_leaf->size = ecag(EXTRACT_SIZE, level, ti);
 
-static ssize_t shared_cpu_map_func(struct kobject *kobj, int type, char *buf)
-{
-	struct cache_index_dir *index;
-	int len;
-
-	index = kobj_to_cache_index_dir(kobj);
-	len = type ?
-		cpulist_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu)) :
-		cpumask_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu));
-	len += sprintf(&buf[len], "\n");
-	return len;
-}
-
-static ssize_t shared_cpu_map_show(struct kobject *kobj,
-				   struct kobj_attribute *attr, char *buf)
-{
-	return shared_cpu_map_func(kobj, 0, buf);
+	num_sets = this_leaf->size / this_leaf->coherency_line_size;
+	num_sets /= this_leaf->ways_of_associativity;
+	this_leaf->number_of_sets = num_sets;
+	cpumask_set_cpu(cpu, &this_leaf->shared_cpu_map);
+	if (!private)
+		this_leaf->disable_sysfs = true;
 }
-static struct kobj_attribute cache_shared_cpu_map_attr =
-	__ATTR(shared_cpu_map, 0444, shared_cpu_map_show, NULL);
 
-static ssize_t shared_cpu_list_show(struct kobject *kobj,
-				    struct kobj_attribute *attr, char *buf)
+int init_cache_level(unsigned int cpu)
 {
-	return shared_cpu_map_func(kobj, 1, buf);
-}
-static struct kobj_attribute cache_shared_cpu_list_attr =
-	__ATTR(shared_cpu_list, 0444, shared_cpu_list_show, NULL);
-
-static struct attribute *cache_index_default_attrs[] = {
-	&cache_type_attr.attr,
-	&cache_size_attr.attr,
-	&cache_number_of_sets_attr.attr,
-	&cache_ways_of_associativity_attr.attr,
-	&cache_level_attr.attr,
-	&cache_coherency_line_size_attr.attr,
-	&cache_shared_cpu_map_attr.attr,
-	&cache_shared_cpu_list_attr.attr,
-	NULL,
-};
-
-static const struct sysfs_ops cache_index_ops = {
-	.show = cache_index_show,
-};
-
-static struct kobj_type cache_index_type = {
-	.sysfs_ops = &cache_index_ops,
-	.release = cache_index_release,
-	.default_attrs = cache_index_default_attrs,
-};
-
-static int cache_create_index_dir(struct cache_dir *cache_dir,
-				  struct cache *cache, int index, int cpu)
-{
-	struct cache_index_dir *index_dir;
-	int rc;
-
-	index_dir = kzalloc(sizeof(*index_dir), GFP_KERNEL);
-	if (!index_dir)
-		return -ENOMEM;
-	index_dir->cache = cache;
-	index_dir->cpu = cpu;
-	rc = kobject_init_and_add(&index_dir->kobj, &cache_index_type,
-				  cache_dir->kobj, "index%d", index);
-	if (rc)
-		goto out;
-	index_dir->next = cache_dir->index;
-	cache_dir->index = index_dir;
-	return 0;
-out:
-	kfree(index_dir);
-	return rc;
-}
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	unsigned int level = 0, leaves = 0;
+	union cache_topology ct;
+	enum cache_type ctype;
 
-static int cache_add_cpu(int cpu)
-{
-	struct cache_dir *cache_dir;
-	struct cache *cache;
-	int rc, index = 0;
+	if (!this_cpu_ci)
+		return -EINVAL;
 
-	if (list_empty(&cache_list))
-		return 0;
-	cache_dir = cache_create_cache_dir(cpu);
-	if (!cache_dir)
-		return -ENOMEM;
-	list_for_each_entry(cache, &cache_list, list) {
-		if (!cache->private)
+	ct.raw = ecag(EXTRACT_TOPOLOGY, 0, 0);
+	do {
+		ctype = get_cache_type(&ct.ci[0], level);
+		if (ctype == CACHE_TYPE_NOCACHE)
 			break;
-		rc = cache_create_index_dir(cache_dir, cache, index, cpu);
-		if (rc)
-			return rc;
-		index++;
-	}
-	return 0;
-}
+		/* Separate instruction and data caches */
+		leaves += (ctype == CACHE_TYPE_SEPARATE) ? 2 : 1;
+	} while (++level < CACHE_MAX_LEVEL);
 
-static void cache_remove_cpu(int cpu)
-{
-	struct cache_index_dir *index, *next;
-	struct cache_dir *cache_dir;
+	this_cpu_ci->num_levels = level;
+	this_cpu_ci->num_leaves = leaves;
 
-	cache_dir = cache_dir_cpu[cpu];
-	if (!cache_dir)
-		return;
-	index = cache_dir->index;
-	while (index) {
-		next = index->next;
-		kobject_put(&index->kobj);
-		index = next;
-	}
-	kobject_put(cache_dir->kobj);
-	kfree(cache_dir);
-	cache_dir_cpu[cpu] = NULL;
+	return 0;
 }
 
-static int cache_hotplug(struct notifier_block *nfb, unsigned long action,
-			 void *hcpu)
+int populate_cache_leaves(unsigned int cpu)
 {
-	int cpu = (long)hcpu;
-	int rc = 0;
+	unsigned int level, idx, pvt;
+	union cache_topology ct;
+	enum cache_type ctype;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
-		rc = cache_add_cpu(cpu);
-		if (rc)
-			cache_remove_cpu(cpu);
-		break;
-	case CPU_DEAD:
-		cache_remove_cpu(cpu);
-		break;
+	ct.raw = ecag(EXTRACT_TOPOLOGY, 0, 0);
+	for (idx = 0, level = 0; level < this_cpu_ci->num_levels &&
+	     idx < this_cpu_ci->num_leaves; idx++, level++) {
+		if (!this_leaf)
+			return -EINVAL;
+
+		pvt = (ct.ci[level].scope == CACHE_SCOPE_PRIVATE) ? 1 : 0;
+		ctype = get_cache_type(&ct.ci[0], level);
+		if (ctype == CACHE_TYPE_SEPARATE) {
+			ci_leaf_init(this_leaf++, pvt, CACHE_TYPE_DATA, level);
+			ci_leaf_init(this_leaf++, pvt, CACHE_TYPE_INST, level);
+		} else {
+			ci_leaf_init(this_leaf++, pvt, ctype, level);
+		}
 	}
-	return rc ? NOTIFY_BAD : NOTIFY_OK;
-}
-
-static int __init cache_init(void)
-{
-	int cpu;
-
-	if (!test_facility(34))
-		return 0;
-	cache_build_info();
-
-	cpu_notifier_register_begin();
-	for_each_online_cpu(cpu)
-		cache_add_cpu(cpu);
-	__hotcpu_notifier(cache_hotplug, 0);
-	cpu_notifier_register_done();
 	return 0;
 }
-device_initcall(cache_init);
-- 
1.8.3.2

