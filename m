Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbaLDX36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:29:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:58513 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbaLDX3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:29:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="632939335"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com,
        vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com
Subject: [PATCH v2] x86: Intel Cache Allocation Technology support
Date: Thu,  4 Dec 2014 15:29:23 -0800
Message-Id: <1417735763-28699-1-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is Cache Allocation Technology ( CAT )
-------------------------------------------

Cache Allocation Technology provides a way for the Software (OS/VMM) to
restrict cache allocation to a defined 'subset' of cache which may be
overlapping with other 'subsets'.  This feature is used when allocating
a line in cache ie when pulling new data into the cache.  The
programming of the h/w is done via programming  MSRs.

The different cache subsets are identified by CLOS identifier (class of
service) and each CLOS has a CBM (cache bit mask).  The CBM is a
contiguous set of bits which defines the amount of cache resource that
is available for each 'subset'.

Why is CAT (cache allocation technology)  needed
------------------------------------------------

The CAT  enables more cache resources to be made available for higher
priority applications based on guidance from the execution
environment.

The architecture also allows dynamically changing these subsets during
runtime to further optimize the performance of the higher priority
application with minimal degradation to the low priority app.
Additionally, resources can be rebalanced for system throughput benefit.

This technique may be useful in managing large computer systems which
large LLC. Examples may be large servers running  instances of
webservers or database servers. In such complex systems, these subsets
can be used for more careful placing of the available cache resources.

The CAT kernel patch would provide a basic kernel framework for users to
be able to implement such cache subsets.

Kernel Implementation
---------------------

This patch implements a cgroup subsystem to support cache allocation.
Each cgroup has a CLOSid <-> CBM(cache bit mask) mapping.  A
CLOS(Class of service) is represented by a CLOSid.CLOSid is internal
to the kernel and not exposed to user.  Each cgroup would have one CBM
and would just represent one cache 'subset'.

The cgroup follows cgroup hierarchy ,mkdir and adding tasks to the
cgroup never fails.  When a child cgroup is created it inherits the
CLOSid and the CBM from its parent.  When a user changes the default
CBM for a cgroup, a new CLOSid may be allocated if the CBM was not
used before.  The changing of 'cbm' may fail with -ERRNOSPC once the
kernel runs out of maximum CLOSids it can support.
User can create as many cgroups as he wants but having different CBMs
at the same time is restricted by the maximum number of CLOSids
(multiple cgroups can have the same CBM).
Kernel maintains a CLOSid<->cbm mapping which keeps reference counter
for each cgroup using a CLOSid.

The tasks in the cgroup would get to fill the LLC cache represented by
the cgroup's 'cbm' file.

Root directory would have all available  bits set in 'cbm' file by
default.

Assignment of CBM,CLOS
---------------------------------

The 'cbm' needs to be a  subset of the parent node's 'cbm'.  Any
contiguous subset of these bits(with a minimum of 2 bits) maybe set to
indicate the cache mapping desired.  The 'cbm' between 2 directories can
overlap. The 'cbm' would represent the cache 'subset' of the CAT cgroup.
For ex: on a system with 16 bits of max cbm bits, if the directory has
the least significant 4 bits set in its 'cbm' file(meaning the 'cbm' is
just 0xf), it would be allocated the right quarter of the Last level
cache which means the tasks belonging to this CAT cgroup can use the
right quarter of the cache to fill. If it has the most significant 8
bits set ,it would be allocated the left half of the cache(8 bits  out
of 16 represents 50%).

The cache portion defined in the CBM file is available to all tasks
within the cgroup to fill and these task are not allowed to allocate
space in other parts of the cache.

Scheduling and Context Switch
------------------------------

During context switch kernel implements this by writing the CLOSid
(internally maintained by kernel) of the cgroup to which the task
belongs to the CPU's IA32_PQR_ASSOC MSR.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
Thanks to feedback from tglx, Boris, Dave Hansen and  Matt.  
Changes in v2:
- Removed HSW specific enumeration changes. Plan to include it later as a
  seperate patch.  
- Fixed the code in prep_arch_switch to be specific for x86 and removed
  x86 defines.
- Fixed cbm_write to not write all 1s when a cgroup is freed.
- fixed one possible memory leak in init.  
- Changed some of manual bitmap
  manipulation to use the predefined bitmap APIs to make code more readable
- Changed name in sources from cqe to cat
- Global cat enable flag changed to static_key and disabled cgroup early_init

This patch will apply on 3.18-rc7

 arch/x86/include/asm/cat.h        | 106 +++++++++++++
 arch/x86/include/asm/cpufeature.h |   6 +-
 arch/x86/include/asm/processor.h  |   3 +
 arch/x86/include/asm/switch_to.h  |   5 +
 arch/x86/kernel/cpu/Makefile      |   1 +
 arch/x86/kernel/cpu/cat.c         | 310 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c      |  16 ++
 include/linux/cgroup_subsys.h     |   4 +
 init/Kconfig                      |  11 ++
 kernel/sched/core.c               |   1 +
 kernel/sched/sched.h              |   3 +
 11 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/cat.h
 create mode 100644 arch/x86/kernel/cpu/cat.c

diff --git a/arch/x86/include/asm/cat.h b/arch/x86/include/asm/cat.h
new file mode 100644
index 0000000..49b643c
--- /dev/null
+++ b/arch/x86/include/asm/cat.h
@@ -0,0 +1,106 @@
+#ifndef _CAT_H_
+#define _CAT_H_
+
+#ifdef CONFIG_CGROUP_CAT
+
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/seq_file.h>
+#include <linux/err.h>
+
+#define IA32_PQR_ASSOC		0xc8f
+#define MAX_CBM_LENGTH		32
+#define IA32_CBM_MASK		0xffffffff
+#define IA32_L3_CBM_BASE	0xc90
+#define CBMFROMINDEX(x)		(IA32_L3_CBM_BASE + x)
+
+DECLARE_PER_CPU(unsigned int, x86_cpu_clos);
+extern struct static_key cat_enable_key;
+extern struct cat root_cat_group;
+
+struct cat_subsys_info {
+	/* Clos Bitmap to keep track of available CLOSids.*/
+	unsigned long *closmap;
+};
+
+struct cat {
+	struct cgroup_subsys_state css;
+	/* Class of service for the cgroup.*/
+	unsigned int clos;
+	/* Corresponding cache bit mask.*/
+	unsigned long *cbm;
+};
+
+struct closcbm_map {
+	unsigned long cbm;
+	unsigned int ref;
+};
+
+static inline bool cat_enabled(void)
+{
+	return static_key_false(&cat_enable_key);
+}
+
+/*
+ * Return cat group corresponding to this container.
+ */
+static inline struct cat *css_cat(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct cat, css) : NULL;
+}
+
+static inline struct cat *parent_cat(struct cat *cq)
+{
+	return css_cat(cq->css.parent);
+}
+
+/*
+ * Return cat group to which this task belongs.
+ */
+static inline struct cat *task_cat(struct task_struct *task)
+{
+	return css_cat(task_css(task, cat_cgrp_id));
+}
+
+/*
+ * cat_sched_in() - Writes the task's CLOSid to IA32_PQR_MSR
+ * if the current Closid is different than the new one.
+ */
+
+static inline void cat_sched_in(struct task_struct *task)
+{
+	struct cat *cq;
+	unsigned int clos;
+
+	if (!cat_enabled())
+		return;
+
+	/*
+	 * This needs to be fixed after CQM code stabilizes
+	 * to cache the whole PQR instead of just CLOSid.
+	 * PQR has closid in high 32 bits and CQM-RMID in low 10 bits.
+	 * Should not write a 0 to the low 10 bits of PQR
+	 * and corrupt RMID.
+	 */
+	clos = this_cpu_read(x86_cpu_clos);
+
+	rcu_read_lock();
+	cq = task_cat(task);
+	if (cq->clos == clos) {
+		rcu_read_unlock();
+		return;
+	}
+
+	wrmsr(IA32_PQR_ASSOC, 0, cq->clos);
+	this_cpu_write(x86_cpu_clos, cq->clos);
+	rcu_read_unlock();
+}
+
+#else
+
+static inline void cat_sched_in(struct task_struct *task) {}
+
+#endif
+#endif
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0bb1335..40dcd9c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -12,7 +12,7 @@
 #include <asm/disabled-features.h>
 #endif
 
-#define NCAPINTS	11	/* N 32-bit words worth of info */
+#define NCAPINTS	12	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
@@ -221,6 +221,7 @@
 #define X86_FEATURE_INVPCID	( 9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_CAT		( 9*32+15) /* Cache QOS Enforcement */
 #define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
@@ -236,6 +237,9 @@
 #define X86_FEATURE_XGETBV1	(10*32+ 2) /* XGETBV with ECX = 1 */
 #define X86_FEATURE_XSAVES	(10*32+ 3) /* XSAVES/XRSTORS */
 
+/* Intel-defined CPU features, CPUID level 0x00000010:0 (ebx), word 11 */
+#define X86_FEATURE_CAT_L3	(11*32 + 1) /*Cache QOS Enforcement L3*/
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..5f1926a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -111,6 +111,9 @@ struct cpuinfo_x86 {
 	int			x86_cache_alignment;	/* In bytes */
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
+	/* Cache Allocation Technology values */
+	int			x86_cat_cbmlength;
+	int			x86_cat_closs;
 	/* cpuid returned max cores value: */
 	u16			 x86_max_cores;
 	u16			apicid;
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index d7f3b3b..b82b78e 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -8,6 +8,11 @@ struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
 
+#ifdef CONFIG_CGROUP_CAT
+#include <asm/cat.h>
+#define post_arch_switch(current)	cat_sched_in(current)
+#endif
+
 #ifdef CONFIG_X86_32
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e27b49d..c493387 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_PERF_EVENTS_INTEL_UNCORE)	+= perf_event_intel_uncore.o \
 					   perf_event_intel_uncore_nhmex.o
 endif
 
+obj-$(CONFIG_CGROUP_CAT) 		+= cat.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/cat.c b/arch/x86/kernel/cpu/cat.c
new file mode 100644
index 0000000..ec782c0
--- /dev/null
+++ b/arch/x86/kernel/cpu/cat.c
@@ -0,0 +1,310 @@
+/*
+ *
+ * Processor Cache Allocation Technology(CAT) code
+ *
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * 2014-09-10 Written by Vikas Shivappa
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <asm/cat.h>
+
+/*
+ * ccmap maintains 1:1 mapping between CLOSid and cbm.
+ */
+static struct closcbm_map *ccmap;
+static struct cat_subsys_info catss_info;
+static DEFINE_MUTEX(cat_group_mutex);
+struct cat root_cat_group;
+struct static_key __read_mostly cat_enable_key = STATIC_KEY_INIT_FALSE;
+DEFINE_PER_CPU(unsigned int, x86_cpu_clos);
+
+#define cat_for_each_child(child_cq, pos_css, parent_cq)		\
+	css_for_each_child((pos_css),	\
+	&(parent_cq)->css)
+
+static inline bool cat_hwenabled(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_CAT_L3))
+		return true;
+
+	return false;
+}
+
+static int __init cat_late_init(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	size_t sizeb;
+	int maxid;
+
+	if (!cat_hwenabled(c)) {
+		root_cat_group.css.ss->disabled = 1;
+		return -ENODEV;
+
+	} else {
+		maxid = c->x86_cat_closs;
+		sizeb = BITS_TO_LONGS(maxid) * sizeof(long);
+		catss_info.closmap = kzalloc(sizeb, GFP_KERNEL);
+		if (!catss_info.closmap)
+			return -ENOMEM;
+
+		sizeb = maxid * sizeof(struct closcbm_map);
+		ccmap = kzalloc(sizeb, GFP_KERNEL);
+		if (!ccmap) {
+			kfree(catss_info.closmap);
+			return -ENOMEM;
+		}
+
+		set_bit(0, catss_info.closmap);
+		root_cat_group.clos = 0;
+
+		ccmap[root_cat_group.clos].cbm =
+			(u32)((u64)(1 << c->x86_cat_cbmlength) - 1);
+		root_cat_group.cbm = &ccmap[root_cat_group.clos].cbm;
+		ccmap[root_cat_group.clos].ref++;
+		static_key_slow_inc(&cat_enable_key);
+	}
+
+	pr_info("cat cbmlength:%u\ncat Closs: %u\n",
+				 c->x86_cat_cbmlength, c->x86_cat_closs);
+
+	return 0;
+}
+
+late_initcall(cat_late_init);
+
+/*
+ * Allocates a new closid from unused closids.
+ * Called with the cat_group_mutex held.
+ */
+
+static int cat_alloc_closid(struct cat *cq)
+{
+	unsigned int tempid;
+	unsigned int maxid;
+
+	maxid = boot_cpu_data.x86_cat_closs;
+	tempid = find_next_zero_bit(catss_info.closmap, maxid, 0);
+	if (tempid == maxid)
+		return -ENOSPC;
+
+	set_bit(tempid, catss_info.closmap);
+	ccmap[tempid].ref++;
+	cq->clos = tempid;
+
+	return 0;
+}
+
+/*
+* Called with the cat_group_mutex held.
+*/
+static int cat_free_closid(struct cat *cq)
+{
+	WARN_ON(!ccmap[cq->clos].ref);
+	ccmap[cq->clos].ref--;
+	if (!ccmap[cq->clos].ref)
+		clear_bit(cq->clos, catss_info.closmap);
+
+	return 0;
+}
+
+static struct cgroup_subsys_state *
+cat_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct cat *parent = css_cat(parent_css);
+	struct cat *cq;
+
+	/*
+	 * Cannot return failure on systems with no Cache Allocation
+	 * as the cgroup_init does not handle failures gracefully.
+	 */
+	if (!parent)
+		return &root_cat_group.css;
+
+	cq = kzalloc(sizeof(struct cat), GFP_KERNEL);
+	if (!cq)
+		return ERR_PTR(-ENOMEM);
+
+	cq->clos = parent->clos;
+	mutex_lock(&cat_group_mutex);
+	ccmap[parent->clos].ref++;
+	mutex_unlock(&cat_group_mutex);
+
+	cq->cbm = parent->cbm;
+	return &cq->css;
+}
+
+static void cat_css_free(struct cgroup_subsys_state *css)
+{
+	struct cat *cq = css_cat(css);
+
+	mutex_lock(&cat_group_mutex);
+	cat_free_closid(cq);
+	kfree(cq);
+	mutex_unlock(&cat_group_mutex);
+}
+
+/*
+ * Tests if atleast two contiguous bits are set.
+ */
+
+static inline bool cbm_iscontiguous(unsigned long var)
+{
+	unsigned long first_bit, zero_bit;
+	unsigned long maxcbm = MAX_CBM_LENGTH;
+
+	if (bitmap_weight(&var, maxcbm) < 2)
+		return false;
+
+	first_bit = find_next_bit(&var, maxcbm, 0);
+	zero_bit = find_next_zero_bit(&var, maxcbm, first_bit);
+
+	if (find_next_bit(&var, maxcbm, zero_bit) < maxcbm)
+		return false;
+
+	return true;
+}
+
+static int cat_cbm_read(struct seq_file *m, void *v)
+{
+	struct cat *cq = css_cat(seq_css(m));
+
+	seq_bitmap(m, cq->cbm, MAX_CBM_LENGTH);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int validate_cbm(struct cat *cq, unsigned long cbmvalue)
+{
+	struct cat *par, *c;
+	struct cgroup_subsys_state *css;
+
+	if (!cbm_iscontiguous(cbmvalue)) {
+		pr_info("cat error:cbm should have >= 2 contiguous bits\n");
+		return -EINVAL;
+	}
+
+	par = parent_cat(cq);
+	if (!bitmap_subset(&cbmvalue, par->cbm, MAX_CBM_LENGTH))
+		return -EINVAL;
+
+	rcu_read_lock();
+	cat_for_each_child(c, css, cq) {
+		c = css_cat(css);
+		if (!bitmap_subset(c->cbm, &cbmvalue, MAX_CBM_LENGTH)) {
+			pr_info("cat error: Children's mask not a subset\n");
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+	}
+
+	rcu_read_unlock();
+	return 0;
+}
+
+static bool cbm_search(unsigned long cbm, int *closid)
+{
+	int maxid = boot_cpu_data.x86_cat_closs;
+	unsigned int i;
+
+	for (i = 0; i < maxid; i++)
+		if (bitmap_equal(&cbm, &ccmap[i].cbm, MAX_CBM_LENGTH)) {
+			*closid = i;
+			return true;
+		}
+
+	return false;
+}
+
+static void cbmmap_dump(void)
+{
+	int i;
+
+	pr_debug("CBMMAP\n");
+	for (i = 0; i < boot_cpu_data.x86_cat_closs; i++)
+		pr_debug("cbm: 0x%x,ref: %u\n",
+		 (unsigned int)ccmap[i].cbm, ccmap[i].ref);
+}
+
+/*
+ * cat_cbm_write() - Validates and writes the cache bit mask(cbm)
+ * to the IA32_L3_MASK_n and also store the same in the ccmap.
+ *
+ * CLOSids are reused for cgroups which have same bitmask.
+ * - This helps to use the scant CLOSids optimally.
+ * - This also implies that at context switch write
+ * to PQR-MSR is done only when a task with a
+ * different bitmask is scheduled in.
+ */
+
+static int cat_cbm_write(struct cgroup_subsys_state *css,
+				 struct cftype *cft, u64 cbmvalue)
+{
+	struct cat *cq = css_cat(css);
+	ssize_t err = 0;
+	unsigned long cbm;
+	unsigned int closid;
+
+	if (cq == &root_cat_group)
+		return -EPERM;
+
+	/*
+	* Need global mutex as cbm write may allocate the closid.
+	*/
+	mutex_lock(&cat_group_mutex);
+	cbm = (cbmvalue & IA32_CBM_MASK);
+
+	if (bitmap_equal(&cbm, cq->cbm, MAX_CBM_LENGTH))
+		goto cbmwriteend;
+
+	err = validate_cbm(cq, cbm);
+	if (err)
+		goto cbmwriteend;
+
+	cat_free_closid(cq);
+	if (cbm_search(cbm, &closid)) {
+		cq->clos = closid;
+		ccmap[cq->clos].ref++;
+	} else {
+		err = cat_alloc_closid(cq);
+		if (err)
+			goto cbmwriteend;
+
+		wrmsrl(CBMFROMINDEX(cq->clos), cbm);
+	}
+
+	ccmap[cq->clos].cbm = cbm;
+	cq->cbm = &ccmap[cq->clos].cbm;
+	cbmmap_dump();
+
+cbmwriteend:
+
+	mutex_unlock(&cat_group_mutex);
+	return err;
+}
+
+static struct cftype cat_files[] = {
+	{
+		.name = "cbm",
+		.seq_show = cat_cbm_read,
+		.write_u64 = cat_cbm_write,
+		.mode = 0666,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys cat_cgrp_subsys = {
+	.css_alloc		= cat_css_alloc,
+	.css_free		= cat_css_free,
+	.legacy_cftypes		= cat_files,
+	.early_init		= 0,
+};
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cfa9b5b..24240c8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -644,6 +644,22 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[10] = eax;
 	}
 
+	/* Additional Intel-defined flags: level 0x00000010 */
+	if (c->cpuid_level >= 0x00000010) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x00000010, 0, &eax, &ebx, &ecx, &edx);
+		c->x86_capability[11] = ebx;
+
+		if (cpu_has(c, X86_FEATURE_CAT) &&
+			   cpu_has(c, X86_FEATURE_CAT_L3)) {
+
+			cpuid_count(0x00000010, 1, &eax, &ebx, &ecx, &edx);
+			c->x86_cat_closs = (edx & 0xffff) + 1;
+			c->x86_cat_cbmlength = (eax & 0xf) + 1;
+		}
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 98c4f9b..271c2c7 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -47,6 +47,10 @@ SUBSYS(net_prio)
 SUBSYS(hugetlb)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_CAT)
+SUBSYS(cat)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 2081a4d..d7687ac 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -968,6 +968,17 @@ config CPUSETS
 
 	  Say N if unsure.
 
+config CGROUP_CAT
+	bool "Cache Allocation Technology croup subsystem"
+	depends on X86 || X86_64
+	help
+	  This option provides framework to allocate cache lines when
+	  applications fill cache.
+	  This can be used by users to configure how much cache that can be
+	  allocated to different PIDs.
+
+	  Say N if unsure.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24beb9b..9b38e44 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2255,6 +2255,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
+	post_arch_switch(current);
 	perf_event_task_sched_in(prev, current);
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2df8ef0..6c6f032 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -971,6 +971,9 @@ static inline int task_on_rq_migrating(struct task_struct *p)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
+#ifndef post_arch_switch
+# define post_arch_switch(current)	do { } while (0)
+#endif
 #ifndef finish_arch_post_lock_switch
 # define finish_arch_post_lock_switch()	do { } while (0)
 #endif
-- 
1.9.1

