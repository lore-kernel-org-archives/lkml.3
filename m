Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaJWLaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56227 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:49 -0400
Subject: [PATCH v2 4/5] module: Replace module_ref with atomic_t refcnt
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:27:04 -0400
Message-ID: <20141023192704.10463.44047.stgit@localhost.localdomain>
In-Reply-To: <20141023192636.10463.45031.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace module_ref per-cpu complex reference counter with
an atomic_t simple refcnt. This is for code simplification.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 include/linux/module.h        |   16 +---------------
 include/trace/events/module.h |    2 +-
 kernel/module.c               |   39 +++++----------------------------------
 3 files changed, 7 insertions(+), 50 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 71f282a..ebfb0e1 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -210,20 +210,6 @@ enum module_state {
 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
 };
 
-/**
- * struct module_ref - per cpu module reference counts
- * @incs: number of module get on this cpu
- * @decs: number of module put on this cpu
- *
- * We force an alignment on 8 or 16 bytes, so that alloc_percpu()
- * put @incs/@decs in same cache line, with no extra memory cost,
- * since alloc_percpu() is fine grained.
- */
-struct module_ref {
-	unsigned long incs;
-	unsigned long decs;
-} __attribute((aligned(2 * sizeof(unsigned long))));
-
 struct module {
 	enum module_state state;
 
@@ -367,7 +353,7 @@ struct module {
 	/* Destruction function. */
 	void (*exit)(void);
 
-	struct module_ref __percpu *refptr;
+	atomic_t refcnt;
 #endif
 
 #ifdef CONFIG_CONSTRUCTORS
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 7c5cbfe..81c4c18 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -80,7 +80,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) - __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt	= atomic_read(&mod->refcnt);
 		__assign_str(name, mod->name);
 	),
 
diff --git a/kernel/module.c b/kernel/module.c
index d596a30..b1d485d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -631,15 +631,11 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
 /* Init the unload section of the module. */
 static int module_unload_init(struct module *mod)
 {
-	mod->refptr = alloc_percpu(struct module_ref);
-	if (!mod->refptr)
-		return -ENOMEM;
-
 	INIT_LIST_HEAD(&mod->source_list);
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	raw_cpu_write(mod->refptr->incs, 1);
+	atomic_set(&mod->refcnt, 1);
 
 	return 0;
 }
@@ -721,8 +717,6 @@ static void module_unload_free(struct module *mod)
 		kfree(use);
 	}
 	mutex_unlock(&module_mutex);
-
-	free_percpu(mod->refptr);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -772,28 +766,7 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 
 unsigned long module_refcount(struct module *mod)
 {
-	unsigned long incs = 0, decs = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		decs += per_cpu_ptr(mod->refptr, cpu)->decs;
-	/*
-	 * ensure the incs are added up after the decs.
-	 * module_put ensures incs are visible before decs with smp_wmb.
-	 *
-	 * This 2-count scheme avoids the situation where the refcount
-	 * for CPU0 is read, then CPU0 increments the module refcount,
-	 * then CPU1 drops that refcount, then the refcount for CPU1 is
-	 * read. We would record a decrement but not its corresponding
-	 * increment so we would see a low count (disaster).
-	 *
-	 * Rare situation? But module_refcount can be preempted, and we
-	 * might be tallying up 4096+ CPUs. So it is not impossible.
-	 */
-	smp_rmb();
-	for_each_possible_cpu(cpu)
-		incs += per_cpu_ptr(mod->refptr, cpu)->incs;
-	return incs - decs;
+	return (unsigned long)atomic_read(&mod->refcnt);
 }
 EXPORT_SYMBOL(module_refcount);
 
@@ -935,7 +908,7 @@ void __module_get(struct module *module)
 {
 	if (module) {
 		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
+		atomic_inc(&module->refcnt);
 		trace_module_get(module, _RET_IP_);
 		preempt_enable();
 	}
@@ -950,7 +923,7 @@ bool try_module_get(struct module *module)
 		preempt_disable();
 
 		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->incs);
+			atomic_inc(&module->refcnt);
 			trace_module_get(module, _RET_IP_);
 		} else
 			ret = false;
@@ -965,9 +938,7 @@ void module_put(struct module *module)
 {
 	if (module) {
 		preempt_disable();
-		smp_wmb(); /* see comment in module_refcount */
-		__this_cpu_inc(module->refptr->decs);
-
+		atomic_dec(&module->refcnt);
 		trace_module_put(module, _RET_IP_);
 		preempt_enable();
 	}


