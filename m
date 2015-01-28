Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbbA1ACd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:02:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:39631 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbbA1ABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052513"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 4/6] x86/intel_cat: Implement scheduling support for Intel CAT
Date: Tue, 27 Jan 2015 16:00:07 -0800
Message-Id: <1422403209-15533-5-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for IA32_PQR_ASSOC MSR writes during task scheduling.

The high 32 bits in the per processor MSR IA32_PQR_ASSOC represents the
CLOSid. During context switch kernel implements this by writing the
CLOSid of the cgroup to which the task belongs to the CPU's
IA32_PQR_ASSOC MSR.

This would let the task fill in the cache 'subset' represented by the
cgroup's Cache bit mask(CBM).

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/include/asm/intel_cat.h | 54 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/switch_to.h |  3 +++
 arch/x86/kernel/cpu/intel_cat.c  |  3 +++
 kernel/sched/core.c              |  1 +
 kernel/sched/sched.h             |  3 +++
 5 files changed, 64 insertions(+)

diff --git a/arch/x86/include/asm/intel_cat.h b/arch/x86/include/asm/intel_cat.h
index b19df52..eda86b1 100644
--- a/arch/x86/include/asm/intel_cat.h
+++ b/arch/x86/include/asm/intel_cat.h
@@ -4,9 +4,12 @@
 #ifdef CONFIG_CGROUP_CAT
 
 #include <linux/cgroup.h>
+#define MSR_IA32_PQR_ASSOC		0xc8f
 #define MAX_CBM_LENGTH			32
 #define IA32_L3_CBM_BASE		0xc90
 #define CBM_FROM_INDEX(x)		(IA32_L3_CBM_BASE + x)
+DECLARE_PER_CPU(unsigned int, x86_cpu_clos);
+extern struct static_key cat_enable_key;
 
 struct cat_subsys_info {
 	/* Clos Bitmap to keep track of available CLOSids.*/
@@ -26,6 +29,11 @@ struct clos_cbm_map {
 	unsigned int cgrp_count;
 };
 
+static inline bool cat_enabled(void)
+{
+	return static_key_false(&cat_enable_key);
+}
+
 /*
  * Return cat group corresponding to this container.
  */
@@ -39,5 +47,51 @@ static inline struct cache_alloc *parent_cat(struct cache_alloc *cq)
 	return css_cat(cq->css.parent);
 }
 
+/*
+ * Return cat group to which this task belongs.
+ */
+static inline struct cache_alloc *task_cat(struct task_struct *task)
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
+	struct cache_alloc *cq;
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
+	wrmsr(MSR_IA32_PQR_ASSOC, 0, cq->clos);
+	this_cpu_write(x86_cpu_clos, cq->clos);
+	rcu_read_unlock();
+}
+
+#else
+
+static inline void cat_sched_in(struct task_struct *task) {}
+
 #endif
 #endif
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 751bf4b..0662877 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -8,6 +8,9 @@ struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
 
+#include <asm/intel_cat.h>
+#define post_arch_switch(current)	cat_sched_in(current)
+
 #ifdef CONFIG_X86_32
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/cpu/intel_cat.c b/arch/x86/kernel/cpu/intel_cat.c
index 049e840..ebd5ed8 100644
--- a/arch/x86/kernel/cpu/intel_cat.c
+++ b/arch/x86/kernel/cpu/intel_cat.c
@@ -32,6 +32,8 @@ static struct clos_cbm_map *ccmap;
 static struct cat_subsys_info catss_info;
 static DEFINE_MUTEX(cat_group_mutex);
 struct cache_alloc cat_root_group;
+struct static_key __read_mostly cat_enable_key = STATIC_KEY_INIT_FALSE;
+DEFINE_PER_CPU(unsigned int, x86_cpu_clos);
 
 #define cat_for_each_child(pos_css, parent_cq)		\
 	css_for_each_child((pos_css), &(parent_cq)->css)
@@ -78,6 +80,7 @@ static int __init cat_late_init(void)
 		ccm->cbm = (u32)((u64)(1 << cbm_len) - 1);
 		cat_root_group.cbm = &(ccm->cbm);
 		ccm->cgrp_count++;
+		static_key_slow_inc(&cat_enable_key);
 	}
 
 	pr_info("cbmlength:%u,Closs: %u\n", cbm_len, maxid);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d22fb16..a5c4d87 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2249,6 +2249,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	prev_state = prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
+	post_arch_switch(current);
 	perf_event_task_sched_in(prev, current);
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a2a45c..49e77d7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1008,6 +1008,9 @@ static inline int task_on_rq_migrating(struct task_struct *p)
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

