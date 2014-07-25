Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864AbaGYQrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:47:19 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53959 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760894AbaGYQox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:44:53 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH v2 5/9] x86: move cacheinfo sysfs to generic cacheinfo infrastructure
Date: Fri, 25 Jul 2014 17:44:48 +0100
Message-Id: <1406306692-7135-6-git-send-email-sudeep.holla@arm.com>
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

The private pointer provided by the cacheinfo is used to implement
the AMD L3 cache specific attributes.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 680 +++++++++-------------------------
 1 file changed, 166 insertions(+), 514 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a952e9c85b6f..7aa9c2a7e320 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -7,16 +7,14 @@
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
 
-#include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/compiler.h>
+#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/sysfs.h>
 #include <linux/pci.h>
 
 #include <asm/processor.h>
-#include <linux/smp.h>
 #include <asm/amd_nb.h>
 #include <asm/smp.h>
 
@@ -116,10 +114,10 @@ static const struct _cache_table cache_table[] =
 
 
 enum _cache_type {
-	CACHE_TYPE_NULL	= 0,
-	CACHE_TYPE_DATA = 1,
-	CACHE_TYPE_INST = 2,
-	CACHE_TYPE_UNIFIED = 3
+	CTYPE_NULL = 0,
+	CTYPE_DATA = 1,
+	CTYPE_INST = 2,
+	CTYPE_UNIFIED = 3
 };
 
 union _cpuid4_leaf_eax {
@@ -159,11 +157,6 @@ struct _cpuid4_info_regs {
 	struct amd_northbridge *nb;
 };
 
-struct _cpuid4_info {
-	struct _cpuid4_info_regs base;
-	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
-};
-
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -220,6 +213,13 @@ static const unsigned short assocs[] = {
 static const unsigned char levels[] = { 1, 1, 2, 3 };
 static const unsigned char types[] = { 1, 2, 3, 3 };
 
+static const enum cache_type cache_type_map[] = {
+	[CTYPE_NULL] = CACHE_TYPE_NOCACHE,
+	[CTYPE_DATA] = CACHE_TYPE_DATA,
+	[CTYPE_INST] = CACHE_TYPE_INST,
+	[CTYPE_UNIFIED] = CACHE_TYPE_UNIFIED,
+};
+
 static void
 amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		     union _cpuid4_leaf_ebx *ebx,
@@ -291,14 +291,9 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
-struct _cache_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *, unsigned int);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count,
-			 unsigned int);
-};
-
 #if defined(CONFIG_AMD_NB) && defined(CONFIG_SYSFS)
+
+static struct attribute **amd_l3_attrs;
 /*
  * L3 cache descriptors
  */
@@ -325,20 +320,6 @@ static void amd_calc_l3_indices(struct amd_northbridge *nb)
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static void amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
-{
-	int node;
-
-	/* only for L3, and not in virtualized environments */
-	if (index < 3)
-		return;
-
-	node = amd_get_nb_id(smp_processor_id());
-	this_leaf->nb = node_to_amd_nb(node);
-	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
-		amd_calc_l3_indices(this_leaf->nb);
-}
-
 /*
  * check whether a slot used for disabling an L3 index is occupied.
  * @l3: L3 cache descriptor
@@ -359,15 +340,16 @@ int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
 	return -1;
 }
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+static ssize_t show_cache_disable(struct cacheinfo *this_leaf, char *buf,
 				  unsigned int slot)
 {
 	int index;
+	struct amd_northbridge *nb = this_leaf->priv;
 
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
-	index = amd_get_l3_disable_slot(this_leaf->base.nb, slot);
+	index = amd_get_l3_disable_slot(nb, slot);
 	if (index >= 0)
 		return sprintf(buf, "%d\n", index);
 
@@ -376,9 +358,10 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 
 #define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf,	\
-			  unsigned int cpu)				\
+cache_disable_##slot##_show(struct device *dev,				\
+			    struct device_attribute *attr, char *buf)	\
 {									\
+	struct cacheinfo *this_leaf = dev_get_drvdata(dev);		\
 	return show_cache_disable(this_leaf, buf, slot);		\
 }
 SHOW_CACHE_DISABLE(0)
@@ -446,25 +429,26 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	return 0;
 }
 
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
-				  const char *buf, size_t count,
-				  unsigned int slot)
+static ssize_t store_cache_disable(struct cacheinfo *this_leaf,
+				   const char *buf, size_t count,
+				   unsigned int slot)
 {
 	unsigned long val = 0;
 	int cpu, err = 0;
+	struct amd_northbridge *nb = this_leaf->priv;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
-	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	cpu = cpumask_first(&this_leaf->shared_cpu_map);
 
 	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
+	err = amd_set_l3_disable_slot(nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
 			pr_warning("L3 slot %d in use/index already disabled!\n",
@@ -476,39 +460,39 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 #define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
-store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
-			   const char *buf, size_t count,		\
-			   unsigned int cpu)				\
+cache_disable_##slot##_store(struct device *dev,			\
+			     struct device_attribute *attr,		\
+			     const char *buf, size_t count)		\
 {									\
+	struct cacheinfo *this_leaf = dev_get_drvdata(dev);		\
 	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
 STORE_CACHE_DISABLE(0)
 STORE_CACHE_DISABLE(1)
 
-static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
-		show_cache_disable_0, store_cache_disable_0);
-static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
-		show_cache_disable_1, store_cache_disable_1);
-
-static ssize_t
-show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
+static ssize_t subcaches_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		return -EINVAL;
+	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
+	int cpu = cpumask_first(&this_leaf->shared_cpu_map);
 
+	if (!this_leaf->priv || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
 	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
 }
 
-static ssize_t
-store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
-		unsigned int cpu)
+static ssize_t subcaches_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
 {
+	struct cacheinfo *this_leaf = dev_get_drvdata(dev);
+	int cpu = cpumask_first(&this_leaf->shared_cpu_map);
 	unsigned long val;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+	if (!this_leaf->priv || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
 	if (strict_strtoul(buf, 16, &val) < 0)
@@ -520,9 +504,59 @@ store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
 	return count;
 }
 
-static struct _cache_attr subcaches =
-	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
+static DEVICE_ATTR_RW(cache_disable_0);
+static DEVICE_ATTR_RW(cache_disable_1);
+static DEVICE_ATTR_RW(subcaches);
+
+static void init_amd_l3_attrs(void)
+{
+	int n = 1;
+
+	if (amd_l3_attrs) /* already initialized */
+		return;
+
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+		n += 2;
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		n += 1;
+
+	amd_l3_attrs = kcalloc(n, sizeof(*amd_l3_attrs), GFP_KERNEL);
+	if (!amd_l3_attrs) {
+		pr_err("%s: failed to alloc memory!\n", __func__);
+		return;
+	}
+
+	n = 0;
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
+		amd_l3_attrs[n++] = &dev_attr_cache_disable_0.attr;
+		amd_l3_attrs[n++] = &dev_attr_cache_disable_1.attr;
+	}
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		amd_l3_attrs[n++] = &dev_attr_subcaches.attr;
+}
+
+const struct attribute **cache_get_priv_attr(struct cacheinfo *this_leaf)
+{
+	if (!this_leaf->priv || !amd_l3_attrs)
+		return NULL;
+	return (const struct attribute **)amd_l3_attrs;
+}
+
+static void amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
+{
+	int node;
+
+	/* only for L3, and not in virtualized environments */
+	if (index < 3)
+		return;
 
+	node = amd_get_nb_id(smp_processor_id());
+	this_leaf->nb = node_to_amd_nb(node);
+	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices) {
+		amd_calc_l3_indices(this_leaf->nb);
+		init_amd_l3_attrs();
+	}
+}
 #else
 #define amd_init_l3_cache(x, y)
 #endif  /* CONFIG_AMD_NB && CONFIG_SYSFS */
@@ -546,7 +580,7 @@ cpuid4_cache_lookup_regs(int index, struct _cpuid4_info_regs *this_leaf)
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
 
-	if (eax.split.type == CACHE_TYPE_NULL)
+	if (eax.split.type == CTYPE_NULL)
 		return -EIO; /* better error ? */
 
 	this_leaf->eax = eax;
@@ -575,7 +609,7 @@ static int find_num_cache_leaves(struct cpuinfo_x86 *c)
 		/* Do cpuid(op) loop to find out num_cache_leaves */
 		cpuid_count(op, i, &eax, &ebx, &ecx, &edx);
 		cache_eax.full = eax;
-	} while (cache_eax.split.type != CACHE_TYPE_NULL);
+	} while (cache_eax.split.type != CTYPE_NULL);
 	return i;
 }
 
@@ -626,9 +660,9 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 			switch (this_leaf.eax.split.level) {
 			case 1:
-				if (this_leaf.eax.split.type == CACHE_TYPE_DATA)
+				if (this_leaf.eax.split.type == CTYPE_DATA)
 					new_l1d = this_leaf.size/1024;
-				else if (this_leaf.eax.split.type == CACHE_TYPE_INST)
+				else if (this_leaf.eax.split.type == CTYPE_INST)
 					new_l1i = this_leaf.size/1024;
 				break;
 			case 2:
@@ -735,55 +769,46 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
-#ifdef CONFIG_SYSFS
-
-/* pointer to _cpuid4_info array (for each cache leaf) */
-static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(ici_cpuid4_info, x))[y]))
-
-#ifdef CONFIG_SMP
-
-static int cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
+static int __cache_amd_cpumap_setup(unsigned int cpu, int index,
+				    struct _cpuid4_info_regs *base)
 {
-	struct _cpuid4_info *this_leaf;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf;
 	int i, sibling;
 
 	if (cpu_has_topoext) {
 		unsigned int apicid, nshared, first, last;
 
-		if (!per_cpu(ici_cpuid4_info, cpu))
-			return 0;
-
-		this_leaf = CPUID4_INFO_IDX(cpu, index);
-		nshared = this_leaf->base.eax.split.num_threads_sharing + 1;
+		this_leaf = this_cpu_ci->info_list + index;
+		nshared = base->eax.split.num_threads_sharing + 1;
 		apicid = cpu_data(cpu).apicid;
 		first = apicid - (apicid % nshared);
 		last = first + nshared - 1;
 
 		for_each_online_cpu(i) {
+			this_cpu_ci = get_cpu_cacheinfo(i);
 			apicid = cpu_data(i).apicid;
 			if ((apicid < first) || (apicid > last))
 				continue;
-			if (!per_cpu(ici_cpuid4_info, i))
-				continue;
-			this_leaf = CPUID4_INFO_IDX(i, index);
+			this_leaf = this_cpu_ci->info_list + index;
 
 			for_each_online_cpu(sibling) {
 				apicid = cpu_data(sibling).apicid;
 				if ((apicid < first) || (apicid > last))
 					continue;
-				set_bit(sibling, this_leaf->shared_cpu_map);
+				cpumask_set_cpu(sibling,
+						&this_leaf->shared_cpu_map);
 			}
 		}
 	} else if (index == 3) {
 		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
-			if (!per_cpu(ici_cpuid4_info, i))
-				continue;
-			this_leaf = CPUID4_INFO_IDX(i, index);
+			this_cpu_ci = get_cpu_cacheinfo(i);
+			this_leaf = this_cpu_ci->info_list + index;
 			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
-				set_bit(sibling, this_leaf->shared_cpu_map);
+				cpumask_set_cpu(sibling,
+						&this_leaf->shared_cpu_map);
 			}
 		}
 	} else
@@ -792,459 +817,86 @@ static int cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 	return 1;
 }
 
-static void cache_shared_cpu_map_setup(unsigned int cpu, int index)
+static void __cache_cpumap_setup(unsigned int cpu, int index,
+				 struct _cpuid4_info_regs *base)
 {
-	struct _cpuid4_info *this_leaf, *sibling_leaf;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
 	int index_msb, i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if (cache_shared_amd_cpu_map_setup(cpu, index))
+		if (__cache_amd_cpumap_setup(cpu, index, base))
 			return;
 	}
 
-	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
+	this_leaf = this_cpu_ci->info_list + index;
+	num_threads_sharing = 1 + base->eax.split.num_threads_sharing;
 
+	cpumask_set_cpu(cpu, &this_leaf->shared_cpu_map);
 	if (num_threads_sharing == 1)
-		cpumask_set_cpu(cpu, to_cpumask(this_leaf->shared_cpu_map));
-	else {
-		index_msb = get_count_order(num_threads_sharing);
-
-		for_each_online_cpu(i) {
-			if (cpu_data(i).apicid >> index_msb ==
-			    c->apicid >> index_msb) {
-				cpumask_set_cpu(i,
-					to_cpumask(this_leaf->shared_cpu_map));
-				if (i != cpu && per_cpu(ici_cpuid4_info, i))  {
-					sibling_leaf =
-						CPUID4_INFO_IDX(i, index);
-					cpumask_set_cpu(cpu, to_cpumask(
-						sibling_leaf->shared_cpu_map));
-				}
-			}
-		}
-	}
-}
-static void cache_remove_shared_cpu_map(unsigned int cpu, int index)
-{
-	struct _cpuid4_info	*this_leaf, *sibling_leaf;
-	int sibling;
-
-	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu(sibling, to_cpumask(this_leaf->shared_cpu_map)) {
-		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
-		cpumask_clear_cpu(cpu,
-				  to_cpumask(sibling_leaf->shared_cpu_map));
-	}
-}
-#else
-static void cache_shared_cpu_map_setup(unsigned int cpu, int index)
-{
-}
-
-static void cache_remove_shared_cpu_map(unsigned int cpu, int index)
-{
-}
-#endif
-
-static void free_cache_attributes(unsigned int cpu)
-{
-	int i;
-
-	for (i = 0; i < num_cache_leaves; i++)
-		cache_remove_shared_cpu_map(cpu, i);
-
-	kfree(per_cpu(ici_cpuid4_info, cpu));
-	per_cpu(ici_cpuid4_info, cpu) = NULL;
-}
-
-static void get_cpu_leaves(void *_retval)
-{
-	int j, *retval = _retval, cpu = smp_processor_id();
+		return;
 
-	/* Do cpuid and store the results */
-	for (j = 0; j < num_cache_leaves; j++) {
-		struct _cpuid4_info *this_leaf = CPUID4_INFO_IDX(cpu, j);
+	index_msb = get_count_order(num_threads_sharing);
 
-		*retval = cpuid4_cache_lookup_regs(j, &this_leaf->base);
-		if (unlikely(*retval < 0)) {
-			int i;
+	for_each_online_cpu(i)
+		if (cpu_data(i).apicid >> index_msb == c->apicid >> index_msb) {
+			struct cpu_cacheinfo *sib_cpu_ci = get_cpu_cacheinfo(i);
 
-			for (i = 0; i < j; i++)
-				cache_remove_shared_cpu_map(cpu, i);
-			break;
+			if (i == cpu || !sib_cpu_ci->info_list)
+				continue;/* skip if itself or no cacheinfo */
+			sibling_leaf = sib_cpu_ci->info_list + index;
+			cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+			cpumask_set_cpu(cpu, &sibling_leaf->shared_cpu_map);
 		}
-		cache_shared_cpu_map_setup(cpu, j);
-	}
 }
 
-static int detect_cache_attributes(unsigned int cpu)
+static void ci_leaf_init(struct cacheinfo *this_leaf,
+			 struct _cpuid4_info_regs *base)
 {
-	int			retval;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	per_cpu(ici_cpuid4_info, cpu) = kzalloc(
-	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
-		return -ENOMEM;
-
-	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
-	if (retval) {
-		kfree(per_cpu(ici_cpuid4_info, cpu));
-		per_cpu(ici_cpuid4_info, cpu) = NULL;
-	}
-
-	return retval;
+	this_leaf->level = base->eax.split.level;
+	this_leaf->type = cache_type_map[base->eax.split.type];
+	this_leaf->coherency_line_size =
+				base->ebx.split.coherency_line_size + 1;
+	this_leaf->ways_of_associativity =
+				base->ebx.split.ways_of_associativity + 1;
+	this_leaf->size = base->size;
+	this_leaf->number_of_sets = base->ecx.split.number_of_sets + 1;
+	this_leaf->physical_line_partition =
+				base->ebx.split.physical_line_partition + 1;
+	this_leaf->priv = base->nb;
 }
 
-#include <linux/kobject.h>
-#include <linux/sysfs.h>
-#include <linux/cpu.h>
-
-/* pointer to kobject for cpuX/cache */
-static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
-
-struct _index_kobject {
-	struct kobject kobj;
-	unsigned int cpu;
-	unsigned short index;
-};
-
-/* pointer to array of kobjects for cpuX/cache/indexY */
-static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
-
-#define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
-				unsigned int cpu)			\
-{									\
-	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
-}
-
-show_one_plus(level, base.eax.split.level, 0);
-show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
-show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1);
-show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
-show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
-
-static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
-			 unsigned int cpu)
-{
-	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
-}
-
-static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
-					int type, char *buf)
-{
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
-
-	if (len > 1) {
-		const struct cpumask *mask;
-
-		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type ?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
-}
-
-static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
-					  unsigned int cpu)
-{
-	return show_shared_cpu_map_func(leaf, 0, buf);
-}
-
-static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf,
-					   unsigned int cpu)
-{
-	return show_shared_cpu_map_func(leaf, 1, buf);
-}
-
-static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
-			 unsigned int cpu)
-{
-	switch (this_leaf->base.eax.split.type) {
-	case CACHE_TYPE_DATA:
-		return sprintf(buf, "Data\n");
-	case CACHE_TYPE_INST:
-		return sprintf(buf, "Instruction\n");
-	case CACHE_TYPE_UNIFIED:
-		return sprintf(buf, "Unified\n");
-	default:
-		return sprintf(buf, "Unknown\n");
-	}
-}
-
-#define to_object(k)	container_of(k, struct _index_kobject, kobj)
-#define to_attr(a)	container_of(a, struct _cache_attr, attr)
-
-#define define_one_ro(_name) \
-static struct _cache_attr _name = \
-	__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(level);
-define_one_ro(type);
-define_one_ro(coherency_line_size);
-define_one_ro(physical_line_partition);
-define_one_ro(ways_of_associativity);
-define_one_ro(number_of_sets);
-define_one_ro(size);
-define_one_ro(shared_cpu_map);
-define_one_ro(shared_cpu_list);
-
-static struct attribute *default_attrs[] = {
-	&type.attr,
-	&level.attr,
-	&coherency_line_size.attr,
-	&physical_line_partition.attr,
-	&ways_of_associativity.attr,
-	&number_of_sets.attr,
-	&size.attr,
-	&shared_cpu_map.attr,
-	&shared_cpu_list.attr,
-	NULL
-};
-
-#ifdef CONFIG_AMD_NB
-static struct attribute **amd_l3_attrs(void)
+static int __init_cache_level(unsigned int cpu)
 {
-	static struct attribute **attrs;
-	int n;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
-	if (attrs)
-		return attrs;
-
-	n = ARRAY_SIZE(default_attrs);
-
-	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
-		n += 2;
-
-	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		n += 1;
-
-	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
-	if (attrs == NULL)
-		return attrs = default_attrs;
-
-	for (n = 0; default_attrs[n]; n++)
-		attrs[n] = default_attrs[n];
-
-	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
-		attrs[n++] = &cache_disable_0.attr;
-		attrs[n++] = &cache_disable_1.attr;
-	}
-
-	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		attrs[n++] = &subcaches.attr;
-
-	return attrs;
-}
-#endif
-
-static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	struct _cache_attr *fattr = to_attr(attr);
-	struct _index_kobject *this_leaf = to_object(kobj);
-	ssize_t ret;
-
-	ret = fattr->show ?
-		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf, this_leaf->cpu) :
-		0;
-	return ret;
-}
-
-static ssize_t store(struct kobject *kobj, struct attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct _cache_attr *fattr = to_attr(attr);
-	struct _index_kobject *this_leaf = to_object(kobj);
-	ssize_t ret;
-
-	ret = fattr->store ?
-		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf, count, this_leaf->cpu) :
-		0;
-	return ret;
-}
-
-static const struct sysfs_ops sysfs_ops = {
-	.show   = show,
-	.store  = store,
-};
-
-static struct kobj_type ktype_cache = {
-	.sysfs_ops	= &sysfs_ops,
-	.default_attrs	= default_attrs,
-};
-
-static struct kobj_type ktype_percpu_entry = {
-	.sysfs_ops	= &sysfs_ops,
-};
-
-static void cpuid4_cache_sysfs_exit(unsigned int cpu)
-{
-	kfree(per_cpu(ici_cache_kobject, cpu));
-	kfree(per_cpu(ici_index_kobject, cpu));
-	per_cpu(ici_cache_kobject, cpu) = NULL;
-	per_cpu(ici_index_kobject, cpu) = NULL;
-	free_cache_attributes(cpu);
-}
-
-static int cpuid4_cache_sysfs_init(unsigned int cpu)
-{
-	int err;
-
-	if (num_cache_leaves == 0)
+	if (!num_cache_leaves)
 		return -ENOENT;
-
-	err = detect_cache_attributes(cpu);
-	if (err)
-		return err;
-
-	/* Allocate all required memory */
-	per_cpu(ici_cache_kobject, cpu) =
-		kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (unlikely(per_cpu(ici_cache_kobject, cpu) == NULL))
-		goto err_out;
-
-	per_cpu(ici_index_kobject, cpu) = kzalloc(
-	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(per_cpu(ici_index_kobject, cpu) == NULL))
-		goto err_out;
-
+	if (!this_cpu_ci)
+		return -EINVAL;
+	this_cpu_ci->num_levels = 3;
+	this_cpu_ci->num_leaves = num_cache_leaves;
 	return 0;
-
-err_out:
-	cpuid4_cache_sysfs_exit(cpu);
-	return -ENOMEM;
 }
 
-static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
-
-/* Add/Remove cache interface for CPU device */
-static int cache_add_dev(struct device *dev)
+static int __populate_cache_leaves(unsigned int cpu)
 {
-	unsigned int cpu = dev->id;
-	unsigned long i, j;
-	struct _index_kobject *this_object;
-	struct _cpuid4_info   *this_leaf;
-	int retval;
-
-	retval = cpuid4_cache_sysfs_init(cpu);
-	if (unlikely(retval < 0))
-		return retval;
-
-	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
-				      &ktype_percpu_entry,
-				      &dev->kobj, "%s", "cache");
-	if (retval < 0) {
-		cpuid4_cache_sysfs_exit(cpu);
-		return retval;
-	}
+	unsigned int idx, ret;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+	struct _cpuid4_info_regs id4_regs = {};
 
-	for (i = 0; i < num_cache_leaves; i++) {
-		this_object = INDEX_KOBJECT_PTR(cpu, i);
-		this_object->cpu = cpu;
-		this_object->index = i;
-
-		this_leaf = CPUID4_INFO_IDX(cpu, i);
-
-		ktype_cache.default_attrs = default_attrs;
-#ifdef CONFIG_AMD_NB
-		if (this_leaf->base.nb)
-			ktype_cache.default_attrs = amd_l3_attrs();
-#endif
-		retval = kobject_init_and_add(&(this_object->kobj),
-					      &ktype_cache,
-					      per_cpu(ici_cache_kobject, cpu),
-					      "index%1lu", i);
-		if (unlikely(retval)) {
-			for (j = 0; j < i; j++)
-				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
-			kobject_put(per_cpu(ici_cache_kobject, cpu));
-			cpuid4_cache_sysfs_exit(cpu);
-			return retval;
-		}
-		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
+	for (idx = 0; idx < this_cpu_ci->num_leaves; idx++) {
+		ret = cpuid4_cache_lookup_regs(idx, &id4_regs);
+		if (ret)
+			return ret;
+		ci_leaf_init(this_leaf++, &id4_regs);
+		__cache_cpumap_setup(cpu, idx, &id4_regs);
 	}
-	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
-
-	kobject_uevent(per_cpu(ici_cache_kobject, cpu), KOBJ_ADD);
 	return 0;
 }
 
-static void cache_remove_dev(struct device *dev)
-{
-	unsigned int cpu = dev->id;
-	unsigned long i;
-
-	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
-		return;
-	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
-		return;
-	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
-
-	for (i = 0; i < num_cache_leaves; i++)
-		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
-	kobject_put(per_cpu(ici_cache_kobject, cpu));
-	cpuid4_cache_sysfs_exit(cpu);
-}
-
-static int cacheinfo_cpu_callback(struct notifier_block *nfb,
-				  unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-	struct device *dev;
-
-	dev = get_cpu_device(cpu);
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cache_add_dev(dev);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		cache_remove_dev(dev);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block cacheinfo_cpu_notifier = {
-	.notifier_call = cacheinfo_cpu_callback,
-};
-
-static int __init cache_sysfs_init(void)
-{
-	int i, err = 0;
-
-	if (num_cache_leaves == 0)
-		return 0;
-
-	cpu_notifier_register_begin();
-	for_each_online_cpu(i) {
-		struct device *dev = get_cpu_device(i);
-
-		err = cache_add_dev(dev);
-		if (err)
-			goto out;
-	}
-	__register_hotcpu_notifier(&cacheinfo_cpu_notifier);
-
-out:
-	cpu_notifier_register_done();
-	return err;
-}
-
-device_initcall(cache_sysfs_init);
-
-#endif
+DEFINE_SMP_CALL_FUNCTION(init_cache_level)
+DEFINE_SMP_CALL_FUNCTION(populate_cache_leaves)
-- 
1.8.3.2

