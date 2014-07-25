Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbaGYQo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:44:58 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53975 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934398AbaGYQo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:44:56 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 6/9] powerpc: move cacheinfo sysfs to generic cacheinfo infrastructure
Date: Fri, 25 Jul 2014 17:44:49 +0100
Message-Id: <1406306692-7135-7-git-send-email-sudeep.holla@arm.com>
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/cacheinfo.c | 813 +++++-----------------------------------
 arch/powerpc/kernel/cacheinfo.h |   8 -
 arch/powerpc/kernel/sysfs.c     |  12 +-
 3 files changed, 91 insertions(+), 742 deletions(-)
 delete mode 100644 arch/powerpc/kernel/cacheinfo.h

diff --git a/arch/powerpc/kernel/cacheinfo.c b/arch/powerpc/kernel/cacheinfo.c
index 40198d50b4c2..b871c246d945 100644
--- a/arch/powerpc/kernel/cacheinfo.c
+++ b/arch/powerpc/kernel/cacheinfo.c
@@ -10,38 +10,10 @@
  * 2 as published by the Free Software Foundation.
  */
 
+#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
-#include <linux/cpumask.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
-#include <linux/list.h>
-#include <linux/notifier.h>
 #include <linux/of.h>
-#include <linux/percpu.h>
-#include <linux/slab.h>
-#include <asm/prom.h>
-
-#include "cacheinfo.h"
-
-/* per-cpu object for tracking:
- * - a "cache" kobject for the top-level directory
- * - a list of "index" objects representing the cpu's local cache hierarchy
- */
-struct cache_dir {
-	struct kobject *kobj; /* bare (not embedded) kobject for cache
-			       * directory */
-	struct cache_index_dir *index; /* list of index objects */
-};
-
-/* "index" object: each cpu's cache directory has an index
- * subdirectory corresponding to a cache object associated with the
- * cpu.  This object's lifetime is managed via the embedded kobject.
- */
-struct cache_index_dir {
-	struct kobject kobj;
-	struct cache_index_dir *next; /* next index in parent directory */
-	struct cache *cache;
-};
 
 /* Template for determining which OF properties to query for a given
  * cache type */
@@ -60,11 +32,6 @@ struct cache_type_info {
 	const char *nr_sets_prop;
 };
 
-/* These are used to index the cache_type_info array. */
-#define CACHE_TYPE_UNIFIED     0
-#define CACHE_TYPE_INSTRUCTION 1
-#define CACHE_TYPE_DATA        2
-
 static const struct cache_type_info cache_type_info[] = {
 	{
 		/* PowerPC Processor binding says the [di]-cache-*
@@ -92,231 +59,83 @@ static const struct cache_type_info cache_type_info[] = {
 	},
 };
 
-/* Cache object: each instance of this corresponds to a distinct cache
- * in the system.  There are separate objects for Harvard caches: one
- * each for instruction and data, and each refers to the same OF node.
- * The refcount of the OF node is elevated for the lifetime of the
- * cache object.  A cache object is released when its shared_cpu_map
- * is cleared (see cache_cpu_clear).
- *
- * A cache object is on two lists: an unsorted global list
- * (cache_list) of cache objects; and a singly-linked list
- * representing the local cache hierarchy, which is ordered by level
- * (e.g. L1d -> L1i -> L2 -> L3).
- */
-struct cache {
-	struct device_node *ofnode;    /* OF node for this cache, may be cpu */
-	struct cpumask shared_cpu_map; /* online CPUs using this cache */
-	int type;                      /* split cache disambiguation */
-	int level;                     /* level not explicit in device tree */
-	struct list_head list;         /* global list of cache objects */
-	struct cache *next_local;      /* next cache of >= level */
-};
-
-static DEFINE_PER_CPU(struct cache_dir *, cache_dir_pcpu);
-
-/* traversal/modification of this list occurs only at cpu hotplug time;
- * access is serialized by cpu hotplug locking
- */
-static LIST_HEAD(cache_list);
-
-static struct cache_index_dir *kobj_to_cache_index_dir(struct kobject *k)
-{
-	return container_of(k, struct cache_index_dir, kobj);
-}
-
-static const char *cache_type_string(const struct cache *cache)
+static inline int get_cacheinfo_idx(enum cache_type type)
 {
-	return cache_type_info[cache->type].name;
-}
-
-static void cache_init(struct cache *cache, int type, int level,
-		       struct device_node *ofnode)
-{
-	cache->type = type;
-	cache->level = level;
-	cache->ofnode = of_node_get(ofnode);
-	INIT_LIST_HEAD(&cache->list);
-	list_add(&cache->list, &cache_list);
-}
-
-static struct cache *new_cache(int type, int level, struct device_node *ofnode)
-{
-	struct cache *cache;
-
-	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
-	if (cache)
-		cache_init(cache, type, level, ofnode);
-
-	return cache;
-}
-
-static void release_cache_debugcheck(struct cache *cache)
-{
-	struct cache *iter;
-
-	list_for_each_entry(iter, &cache_list, list)
-		WARN_ONCE(iter->next_local == cache,
-			  "cache for %s(%s) refers to cache for %s(%s)\n",
-			  iter->ofnode->full_name,
-			  cache_type_string(iter),
-			  cache->ofnode->full_name,
-			  cache_type_string(cache));
-}
-
-static void release_cache(struct cache *cache)
-{
-	if (!cache)
-		return;
-
-	pr_debug("freeing L%d %s cache for %s\n", cache->level,
-		 cache_type_string(cache), cache->ofnode->full_name);
-
-	release_cache_debugcheck(cache);
-	list_del(&cache->list);
-	of_node_put(cache->ofnode);
-	kfree(cache);
-}
-
-static void cache_cpu_set(struct cache *cache, int cpu)
-{
-	struct cache *next = cache;
-
-	while (next) {
-		WARN_ONCE(cpumask_test_cpu(cpu, &next->shared_cpu_map),
-			  "CPU %i already accounted in %s(%s)\n",
-			  cpu, next->ofnode->full_name,
-			  cache_type_string(next));
-		cpumask_set_cpu(cpu, &next->shared_cpu_map);
-		next = next->next_local;
-	}
+	if (type == CACHE_TYPE_UNIFIED)
+		return 0;
+	else
+		return type;
 }
 
-static int cache_size(const struct cache *cache, unsigned int *ret)
+static void cache_size(struct cacheinfo *this_leaf)
 {
 	const char *propname;
 	const __be32 *cache_size;
+	int ct_idx;
 
-	propname = cache_type_info[cache->type].size_prop;
+	ct_idx = get_cacheinfo_idx(this_leaf->type);
+	propname = cache_type_info[ct_idx].size_prop;
 
-	cache_size = of_get_property(cache->ofnode, propname, NULL);
+	cache_size = of_get_property(this_leaf->of_node, propname, NULL);
 	if (!cache_size)
-		return -ENODEV;
-
-	*ret = of_read_number(cache_size, 1);
-	return 0;
-}
-
-static int cache_size_kb(const struct cache *cache, unsigned int *ret)
-{
-	unsigned int size;
-
-	if (cache_size(cache, &size))
-		return -ENODEV;
-
-	*ret = size / 1024;
-	return 0;
+		this_leaf->size = 0;
+	else
+		this_leaf->size = of_read_number(cache_size, 1);
 }
 
 /* not cache_line_size() because that's a macro in include/linux/cache.h */
-static int cache_get_line_size(const struct cache *cache, unsigned int *ret)
+static void cache_get_line_size(struct cacheinfo *this_leaf)
 {
 	const __be32 *line_size;
-	int i, lim;
+	int i, lim, ct_idx;
 
-	lim = ARRAY_SIZE(cache_type_info[cache->type].line_size_props);
+	ct_idx = get_cacheinfo_idx(this_leaf->type);
+	lim = ARRAY_SIZE(cache_type_info[ct_idx].line_size_props);
 
 	for (i = 0; i < lim; i++) {
 		const char *propname;
 
-		propname = cache_type_info[cache->type].line_size_props[i];
-		line_size = of_get_property(cache->ofnode, propname, NULL);
+		propname = cache_type_info[ct_idx].line_size_props[i];
+		line_size = of_get_property(this_leaf->of_node, propname, NULL);
 		if (line_size)
 			break;
 	}
 
 	if (!line_size)
-		return -ENODEV;
-
-	*ret = of_read_number(line_size, 1);
-	return 0;
+		this_leaf->coherency_line_size = 0;
+	else
+		this_leaf->coherency_line_size = of_read_number(line_size, 1);
 }
 
-static int cache_nr_sets(const struct cache *cache, unsigned int *ret)
+static void cache_nr_sets(struct cacheinfo *this_leaf)
 {
 	const char *propname;
 	const __be32 *nr_sets;
+	int ct_idx;
 
-	propname = cache_type_info[cache->type].nr_sets_prop;
+	ct_idx = get_cacheinfo_idx(this_leaf->type);
+	propname = cache_type_info[ct_idx].nr_sets_prop;
 
-	nr_sets = of_get_property(cache->ofnode, propname, NULL);
+	nr_sets = of_get_property(this_leaf->of_node, propname, NULL);
 	if (!nr_sets)
-		return -ENODEV;
-
-	*ret = of_read_number(nr_sets, 1);
-	return 0;
+		this_leaf->number_of_sets = 0;
+	else
+		this_leaf->number_of_sets = of_read_number(nr_sets, 1);
 }
 
-static int cache_associativity(const struct cache *cache, unsigned int *ret)
+static void cache_associativity(struct cacheinfo *this_leaf)
 {
-	unsigned int line_size;
-	unsigned int nr_sets;
-	unsigned int size;
-
-	if (cache_nr_sets(cache, &nr_sets))
-		goto err;
+	unsigned int line_size = this_leaf->coherency_line_size;
+	unsigned int nr_sets = this_leaf->number_of_sets;
+	unsigned int size = this_leaf->size;
 
 	/* If the cache is fully associative, there is no need to
 	 * check the other properties.
 	 */
-	if (nr_sets == 1) {
-		*ret = 0;
-		return 0;
-	}
-
-	if (cache_get_line_size(cache, &line_size))
-		goto err;
-	if (cache_size(cache, &size))
-		goto err;
-
-	if (!(nr_sets > 0 && size > 0 && line_size > 0))
-		goto err;
-
-	*ret = (size / nr_sets) / line_size;
-	return 0;
-err:
-	return -ENODEV;
-}
-
-/* helper for dealing with split caches */
-static struct cache *cache_find_first_sibling(struct cache *cache)
-{
-	struct cache *iter;
-
-	if (cache->type == CACHE_TYPE_UNIFIED)
-		return cache;
-
-	list_for_each_entry(iter, &cache_list, list)
-		if (iter->ofnode == cache->ofnode && iter->next_local == cache)
-			return iter;
-
-	return cache;
-}
-
-/* return the first cache on a local list matching node */
-static struct cache *cache_lookup_by_node(const struct device_node *node)
-{
-	struct cache *cache = NULL;
-	struct cache *iter;
-
-	list_for_each_entry(iter, &cache_list, list) {
-		if (iter->ofnode != node)
-			continue;
-		cache = cache_find_first_sibling(iter);
-		break;
-	}
-
-	return cache;
+	if ((nr_sets == 1) || !(nr_sets > 0 && size > 0 && line_size > 0))
+		this_leaf->ways_of_associativity = 0;
+	else
+		this_leaf->ways_of_associativity = (size / nr_sets) / line_size;
 }
 
 static bool cache_node_is_unified(const struct device_node *np)
@@ -324,526 +143,74 @@ static bool cache_node_is_unified(const struct device_node *np)
 	return of_get_property(np, "cache-unified", NULL);
 }
 
-static struct cache *cache_do_one_devnode_unified(struct device_node *node,
-						  int level)
-{
-	struct cache *cache;
-
-	pr_debug("creating L%d ucache for %s\n", level, node->full_name);
-
-	cache = new_cache(CACHE_TYPE_UNIFIED, level, node);
-
-	return cache;
-}
-
-static struct cache *cache_do_one_devnode_split(struct device_node *node,
-						int level)
-{
-	struct cache *dcache, *icache;
-
-	pr_debug("creating L%d dcache and icache for %s\n", level,
-		 node->full_name);
-
-	dcache = new_cache(CACHE_TYPE_DATA, level, node);
-	icache = new_cache(CACHE_TYPE_INSTRUCTION, level, node);
-
-	if (!dcache || !icache)
-		goto err;
-
-	dcache->next_local = icache;
-
-	return dcache;
-err:
-	release_cache(dcache);
-	release_cache(icache);
-	return NULL;
-}
-
-static struct cache *cache_do_one_devnode(struct device_node *node, int level)
-{
-	struct cache *cache;
-
-	if (cache_node_is_unified(node))
-		cache = cache_do_one_devnode_unified(node, level);
-	else
-		cache = cache_do_one_devnode_split(node, level);
-
-	return cache;
-}
-
-static struct cache *cache_lookup_or_instantiate(struct device_node *node,
-						 int level)
-{
-	struct cache *cache;
-
-	cache = cache_lookup_by_node(node);
-
-	WARN_ONCE(cache && cache->level != level,
-		  "cache level mismatch on lookup (got %d, expected %d)\n",
-		  cache->level, level);
-
-	if (!cache)
-		cache = cache_do_one_devnode(node, level);
-
-	return cache;
-}
-
-static void link_cache_lists(struct cache *smaller, struct cache *bigger)
-{
-	while (smaller->next_local) {
-		if (smaller->next_local == bigger)
-			return; /* already linked */
-		smaller = smaller->next_local;
-	}
-
-	smaller->next_local = bigger;
-}
-
-static void do_subsidiary_caches_debugcheck(struct cache *cache)
-{
-	WARN_ON_ONCE(cache->level != 1);
-	WARN_ON_ONCE(strcmp(cache->ofnode->type, "cpu"));
-}
-
-static void do_subsidiary_caches(struct cache *cache)
-{
-	struct device_node *subcache_node;
-	int level = cache->level;
-
-	do_subsidiary_caches_debugcheck(cache);
-
-	while ((subcache_node = of_find_next_cache_node(cache->ofnode))) {
-		struct cache *subcache;
-
-		level++;
-		subcache = cache_lookup_or_instantiate(subcache_node, level);
-		of_node_put(subcache_node);
-		if (!subcache)
-			break;
-
-		link_cache_lists(cache, subcache);
-		cache = subcache;
-	}
-}
-
-static struct cache *cache_chain_instantiate(unsigned int cpu_id)
-{
-	struct device_node *cpu_node;
-	struct cache *cpu_cache = NULL;
-
-	pr_debug("creating cache object(s) for CPU %i\n", cpu_id);
-
-	cpu_node = of_get_cpu_node(cpu_id, NULL);
-	WARN_ONCE(!cpu_node, "no OF node found for CPU %i\n", cpu_id);
-	if (!cpu_node)
-		goto out;
-
-	cpu_cache = cache_lookup_or_instantiate(cpu_node, 1);
-	if (!cpu_cache)
-		goto out;
-
-	do_subsidiary_caches(cpu_cache);
-
-	cache_cpu_set(cpu_cache, cpu_id);
-out:
-	of_node_put(cpu_node);
-
-	return cpu_cache;
-}
-
-static struct cache_dir *cacheinfo_create_cache_dir(unsigned int cpu_id)
-{
-	struct cache_dir *cache_dir;
-	struct device *dev;
-	struct kobject *kobj = NULL;
-
-	dev = get_cpu_device(cpu_id);
-	WARN_ONCE(!dev, "no dev for CPU %i\n", cpu_id);
-	if (!dev)
-		goto err;
-
-	kobj = kobject_create_and_add("cache", &dev->kobj);
-	if (!kobj)
-		goto err;
-
-	cache_dir = kzalloc(sizeof(*cache_dir), GFP_KERNEL);
-	if (!cache_dir)
-		goto err;
-
-	cache_dir->kobj = kobj;
-
-	WARN_ON_ONCE(per_cpu(cache_dir_pcpu, cpu_id) != NULL);
-
-	per_cpu(cache_dir_pcpu, cpu_id) = cache_dir;
-
-	return cache_dir;
-err:
-	kobject_put(kobj);
-	return NULL;
-}
-
-static void cache_index_release(struct kobject *kobj)
-{
-	struct cache_index_dir *index;
-
-	index = kobj_to_cache_index_dir(kobj);
-
-	pr_debug("freeing index directory for L%d %s cache\n",
-		 index->cache->level, cache_type_string(index->cache));
-
-	kfree(index);
-}
-
-static ssize_t cache_index_show(struct kobject *k, struct attribute *attr, char *buf)
+static void ci_leaf_init(struct cacheinfo *this_leaf,
+			 enum cache_type type, unsigned int level)
 {
-	struct kobj_attribute *kobj_attr;
-
-	kobj_attr = container_of(attr, struct kobj_attribute, attr);
-
-	return kobj_attr->show(k, kobj_attr, buf);
+	this_leaf->level = level;
+	this_leaf->type = type;
+	cache_size(this_leaf);
+	cache_get_line_size(this_leaf);
+	cache_nr_sets(this_leaf);
+	cache_associativity(this_leaf);
 }
 
-static struct cache *index_kobj_to_cache(struct kobject *k)
+int init_cache_level(unsigned int cpu)
 {
-	struct cache_index_dir *index;
+	struct device_node *np;
+	struct device *cpu_dev = get_cpu_device(cpu);
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	unsigned int level = 0, leaves = 0;
 
-	index = kobj_to_cache_index_dir(k);
-
-	return index->cache;
-}
-
-static ssize_t size_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	unsigned int size_kb;
-	struct cache *cache;
-
-	cache = index_kobj_to_cache(k);
-
-	if (cache_size_kb(cache, &size_kb))
+	if (!cpu_dev) {
+		pr_err("No cpu device for CPU %d\n", cpu);
 		return -ENODEV;
-
-	return sprintf(buf, "%uK\n", size_kb);
-}
-
-static struct kobj_attribute cache_size_attr =
-	__ATTR(size, 0444, size_show, NULL);
-
-
-static ssize_t line_size_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	unsigned int line_size;
-	struct cache *cache;
-
-	cache = index_kobj_to_cache(k);
-
-	if (cache_get_line_size(cache, &line_size))
-		return -ENODEV;
-
-	return sprintf(buf, "%u\n", line_size);
-}
-
-static struct kobj_attribute cache_line_size_attr =
-	__ATTR(coherency_line_size, 0444, line_size_show, NULL);
-
-static ssize_t nr_sets_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	unsigned int nr_sets;
-	struct cache *cache;
-
-	cache = index_kobj_to_cache(k);
-
-	if (cache_nr_sets(cache, &nr_sets))
-		return -ENODEV;
-
-	return sprintf(buf, "%u\n", nr_sets);
-}
-
-static struct kobj_attribute cache_nr_sets_attr =
-	__ATTR(number_of_sets, 0444, nr_sets_show, NULL);
-
-static ssize_t associativity_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	unsigned int associativity;
-	struct cache *cache;
-
-	cache = index_kobj_to_cache(k);
-
-	if (cache_associativity(cache, &associativity))
-		return -ENODEV;
-
-	return sprintf(buf, "%u\n", associativity);
-}
-
-static struct kobj_attribute cache_assoc_attr =
-	__ATTR(ways_of_associativity, 0444, associativity_show, NULL);
-
-static ssize_t type_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	struct cache *cache;
-
-	cache = index_kobj_to_cache(k);
-
-	return sprintf(buf, "%s\n", cache_type_string(cache));
-}
-
-static struct kobj_attribute cache_type_attr =
-	__ATTR(type, 0444, type_show, NULL);
-
-static ssize_t level_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	struct cache_index_dir *index;
-	struct cache *cache;
-
-	index = kobj_to_cache_index_dir(k);
-	cache = index->cache;
-
-	return sprintf(buf, "%d\n", cache->level);
-}
-
-static struct kobj_attribute cache_level_attr =
-	__ATTR(level, 0444, level_show, NULL);
-
-static ssize_t shared_cpu_map_show(struct kobject *k, struct kobj_attribute *attr, char *buf)
-{
-	struct cache_index_dir *index;
-	struct cache *cache;
-	int len;
-	int n = 0;
-
-	index = kobj_to_cache_index_dir(k);
-	cache = index->cache;
-	len = PAGE_SIZE - 2;
-
-	if (len > 1) {
-		n = cpumask_scnprintf(buf, len, &cache->shared_cpu_map);
-		buf[n++] = '\n';
-		buf[n] = '\0';
 	}
-	return n;
-}
-
-static struct kobj_attribute cache_shared_cpu_map_attr =
-	__ATTR(shared_cpu_map, 0444, shared_cpu_map_show, NULL);
-
-/* Attributes which should always be created -- the kobject/sysfs core
- * does this automatically via kobj_type->default_attrs.  This is the
- * minimum data required to uniquely identify a cache.
- */
-static struct attribute *cache_index_default_attrs[] = {
-	&cache_type_attr.attr,
-	&cache_level_attr.attr,
-	&cache_shared_cpu_map_attr.attr,
-	NULL,
-};
-
-/* Attributes which should be created if the cache device node has the
- * right properties -- see cacheinfo_create_index_opt_attrs
- */
-static struct kobj_attribute *cache_index_opt_attrs[] = {
-	&cache_size_attr,
-	&cache_line_size_attr,
-	&cache_nr_sets_attr,
-	&cache_assoc_attr,
-};
-
-static const struct sysfs_ops cache_index_ops = {
-	.show = cache_index_show,
-};
-
-static struct kobj_type cache_index_type = {
-	.release = cache_index_release,
-	.sysfs_ops = &cache_index_ops,
-	.default_attrs = cache_index_default_attrs,
-};
-
-static void cacheinfo_create_index_opt_attrs(struct cache_index_dir *dir)
-{
-	const char *cache_name;
-	const char *cache_type;
-	struct cache *cache;
-	char *buf;
-	int i;
-
-	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!buf)
-		return;
-
-	cache = dir->cache;
-	cache_name = cache->ofnode->full_name;
-	cache_type = cache_type_string(cache);
-
-	/* We don't want to create an attribute that can't provide a
-	 * meaningful value.  Check the return value of each optional
-	 * attribute's ->show method before registering the
-	 * attribute.
-	 */
-	for (i = 0; i < ARRAY_SIZE(cache_index_opt_attrs); i++) {
-		struct kobj_attribute *attr;
-		ssize_t rc;
-
-		attr = cache_index_opt_attrs[i];
-
-		rc = attr->show(&dir->kobj, attr, buf);
-		if (rc <= 0) {
-			pr_debug("not creating %s attribute for "
-				 "%s(%s) (rc = %zd)\n",
-				 attr->attr.name, cache_name,
-				 cache_type, rc);
-			continue;
-		}
-		if (sysfs_create_file(&dir->kobj, &attr->attr))
-			pr_debug("could not create %s attribute for %s(%s)\n",
-				 attr->attr.name, cache_name, cache_type);
+	np = cpu_dev->of_node;
+	if (!np) {
+		pr_err("Failed to find cpu%d device node\n", cpu);
+		return -ENOENT;
 	}
 
-	kfree(buf);
-}
-
-static void cacheinfo_create_index_dir(struct cache *cache, int index,
-				       struct cache_dir *cache_dir)
-{
-	struct cache_index_dir *index_dir;
-	int rc;
-
-	index_dir = kzalloc(sizeof(*index_dir), GFP_KERNEL);
-	if (!index_dir)
-		goto err;
-
-	index_dir->cache = cache;
-
-	rc = kobject_init_and_add(&index_dir->kobj, &cache_index_type,
-				  cache_dir->kobj, "index%d", index);
-	if (rc)
-		goto err;
-
-	index_dir->next = cache_dir->index;
-	cache_dir->index = index_dir;
-
-	cacheinfo_create_index_opt_attrs(index_dir);
-
-	return;
-err:
-	kfree(index_dir);
-}
-
-static void cacheinfo_sysfs_populate(unsigned int cpu_id,
-				     struct cache *cache_list)
-{
-	struct cache_dir *cache_dir;
-	struct cache *cache;
-	int index = 0;
-
-	cache_dir = cacheinfo_create_cache_dir(cpu_id);
-	if (!cache_dir)
-		return;
-
-	cache = cache_list;
-	while (cache) {
-		cacheinfo_create_index_dir(cache, index, cache_dir);
-		index++;
-		cache = cache->next_local;
+	while (np) {
+		leaves += cache_node_is_unified(np) ? 1 : 2;
+		level++;
+		of_node_put(np);
+		np = of_find_next_cache_node(np);
 	}
-}
+	this_cpu_ci->num_levels = level;
+	this_cpu_ci->num_leaves = leaves;
 
-void cacheinfo_cpu_online(unsigned int cpu_id)
-{
-	struct cache *cache;
-
-	cache = cache_chain_instantiate(cpu_id);
-	if (!cache)
-		return;
-
-	cacheinfo_sysfs_populate(cpu_id, cache);
-}
-
-/* functions needed to remove cache entry for cpu offline or suspend/resume */
-
-#if (defined(CONFIG_PPC_PSERIES) && defined(CONFIG_SUSPEND)) || \
-    defined(CONFIG_HOTPLUG_CPU)
-
-static struct cache *cache_lookup_by_cpu(unsigned int cpu_id)
-{
-	struct device_node *cpu_node;
-	struct cache *cache;
-
-	cpu_node = of_get_cpu_node(cpu_id, NULL);
-	WARN_ONCE(!cpu_node, "no OF node found for CPU %i\n", cpu_id);
-	if (!cpu_node)
-		return NULL;
-
-	cache = cache_lookup_by_node(cpu_node);
-	of_node_put(cpu_node);
-
-	return cache;
+	return 0;
 }
 
-static void remove_index_dirs(struct cache_dir *cache_dir)
+int populate_cache_leaves(unsigned int cpu)
 {
-	struct cache_index_dir *index;
-
-	index = cache_dir->index;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+	struct device *cpu_dev = get_cpu_device(cpu);
+	struct device_node *np;
+	unsigned int level, idx;
 
-	while (index) {
-		struct cache_index_dir *next;
-
-		next = index->next;
-		kobject_put(&index->kobj);
-		index = next;
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		pr_err("Failed to find cpu%d device node\n", cpu);
+		return -ENOENT;
 	}
-}
-
-static void remove_cache_dir(struct cache_dir *cache_dir)
-{
-	remove_index_dirs(cache_dir);
 
-	/* Remove cache dir from sysfs */
-	kobject_del(cache_dir->kobj);
-
-	kobject_put(cache_dir->kobj);
-
-	kfree(cache_dir);
-}
-
-static void cache_cpu_clear(struct cache *cache, int cpu)
-{
-	while (cache) {
-		struct cache *next = cache->next_local;
-
-		WARN_ONCE(!cpumask_test_cpu(cpu, &cache->shared_cpu_map),
-			  "CPU %i not accounted in %s(%s)\n",
-			  cpu, cache->ofnode->full_name,
-			  cache_type_string(cache));
-
-		cpumask_clear_cpu(cpu, &cache->shared_cpu_map);
-
-		/* Release the cache object if all the cpus using it
-		 * are offline */
-		if (cpumask_empty(&cache->shared_cpu_map))
-			release_cache(cache);
-
-		cache = next;
+	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
+	     idx < this_cpu_ci->num_leaves; idx++, level++) {
+		if (!this_leaf)
+			return -EINVAL;
+
+		this_leaf->of_node = np;
+		if (cache_node_is_unified(np)) {
+			ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
+		} else {
+			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
+			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
+		}
+		np = of_find_next_cache_node(np);
 	}
+	return 0;
 }
 
-void cacheinfo_cpu_offline(unsigned int cpu_id)
-{
-	struct cache_dir *cache_dir;
-	struct cache *cache;
-
-	/* Prevent userspace from seeing inconsistent state - remove
-	 * the sysfs hierarchy first */
-	cache_dir = per_cpu(cache_dir_pcpu, cpu_id);
-
-	/* careful, sysfs population may have failed */
-	if (cache_dir)
-		remove_cache_dir(cache_dir);
-
-	per_cpu(cache_dir_pcpu, cpu_id) = NULL;
-
-	/* clear the CPU's bit in its cache chain, possibly freeing
-	 * cache objects */
-	cache = cache_lookup_by_cpu(cpu_id);
-	if (cache)
-		cache_cpu_clear(cache, cpu_id);
-}
-#endif /* (CONFIG_PPC_PSERIES && CONFIG_SUSPEND) || CONFIG_HOTPLUG_CPU */
diff --git a/arch/powerpc/kernel/cacheinfo.h b/arch/powerpc/kernel/cacheinfo.h
deleted file mode 100644
index a7b74d36acd7..000000000000
--- a/arch/powerpc/kernel/cacheinfo.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _PPC_CACHEINFO_H
-#define _PPC_CACHEINFO_H
-
-/* These are just hooks for sysfs.c to use. */
-extern void cacheinfo_cpu_online(unsigned int cpu_id);
-extern void cacheinfo_cpu_offline(unsigned int cpu_id);
-
-#endif /* _PPC_CACHEINFO_H */
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 67fd2fd2620a..6e9c5a8141bb 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -19,8 +19,6 @@
 #include <asm/pmc.h>
 #include <asm/firmware.h>
 
-#include "cacheinfo.h"
-
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #include <asm/lppaca.h>
@@ -743,7 +741,6 @@ static void register_cpu_online(unsigned int cpu)
 		device_create_file(s, &dev_attr_altivec_idle_wait_time);
 	}
 #endif
-	cacheinfo_cpu_online(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -824,7 +821,6 @@ static void unregister_cpu_online(unsigned int cpu)
 		device_remove_file(s, &dev_attr_altivec_idle_wait_time);
 	}
 #endif
-	cacheinfo_cpu_offline(cpu);
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
@@ -988,8 +984,7 @@ static int __init topology_init(void)
 	int cpu;
 
 	register_nodes();
-
-	cpu_notifier_register_begin();
+	register_cpu_notifier(&sysfs_cpu_nb);
 
 	for_each_possible_cpu(cpu) {
 		struct cpu *c = &per_cpu(cpu_devices, cpu);
@@ -1013,11 +1008,6 @@ static int __init topology_init(void)
 		if (cpu_online(cpu))
 			register_cpu_online(cpu);
 	}
-
-	__register_cpu_notifier(&sysfs_cpu_nb);
-
-	cpu_notifier_register_done();
-
 #ifdef CONFIG_PPC64
 	sysfs_create_dscr_default();
 #endif /* CONFIG_PPC64 */
-- 
1.8.3.2

