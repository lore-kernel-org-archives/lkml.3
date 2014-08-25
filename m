Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaHYK4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:56:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50462 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaHYK4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:56:04 -0400
Subject: [RFC PATCH 5/5] module: Remove stop_machine from module unloading
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Mon, 25 Aug 2014 10:55:55 +0000
Message-ID: <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove stop_machine from module unloading by replacing module_ref
with atomic_t. Note that this can cause a performance regression
on big-SMP machine by direct memory access. For those machines,
you can lockdwon all modules. Since the lockdown skips reference
counting, it'll be more scalable than per-cpu module_ref counters.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h        |   16 ------
 include/trace/events/module.h |    2 -
 kernel/module.c               |  108 +++++++++++++++--------------------------
 3 files changed, 41 insertions(+), 85 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 670cb2e..3ebe049 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -211,20 +211,6 @@ enum module_state {
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
 
@@ -368,7 +354,7 @@ struct module {
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
index 85ffc1d..7af6ff7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -42,7 +42,6 @@
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
-#include <linux/stop_machine.h>
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
@@ -98,7 +97,7 @@
  * 1) List of modules (also safely readable with preempt_disable),
  * 2) module_use links,
  * 3) module_addr_min/module_addr_max.
- * (delete uses stop_machine/add uses RCU list operations). */
+ * (delete and add uses RCU list operations). */
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
@@ -628,18 +627,26 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 EXPORT_TRACEPOINT_SYMBOL(module_get);
 
+/*
+ * MODULE_REF_BASE must be 1, since we use atomic_inc_not_zero() for
+ * recovering refcnt (see try_release_module_ref() ).
+ */
+#define MODULE_REF_BASE	1
+
 /* Init the unload section of the module. */
 static int module_unload_init(struct module *mod)
 {
-	mod->refptr = alloc_percpu(struct module_ref);
-	if (!mod->refptr)
-		return -ENOMEM;
+	/*
+	 * Initialize reference counter to MODULE_REF_BASE.
+	 * refcnt == 0 means module is going.
+	 */
+	atomic_set(&mod->refcnt, MODULE_REF_BASE);
 
 	INIT_LIST_HEAD(&mod->source_list);
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	raw_cpu_write(mod->refptr->incs, 1);
+	atomic_inc(&mod->refcnt);
 
 	return 0;
 }
@@ -721,8 +728,6 @@ static void module_unload_free(struct module *mod)
 		kfree(use);
 	}
 	mutex_unlock(&module_mutex);
-
-	free_percpu(mod->refptr);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -740,60 +745,38 @@ static inline int try_force_unload(unsigned int flags)
 }
 #endif /* CONFIG_MODULE_FORCE_UNLOAD */
 
-struct stopref
+/* Try to release refcount of module, 0 means success. */
+static int try_release_module_ref(struct module *mod)
 {
-	struct module *mod;
-	int flags;
-	int *forced;
-};
+	int ret;
 
-/* Whole machine is stopped with interrupts off when this runs. */
-static int __try_stop_module(void *_sref)
-{
-	struct stopref *sref = _sref;
+	/* Try to decrement refcnt which we set at loading */
+	ret = atomic_sub_return(MODULE_REF_BASE, &mod->refcnt);
+	if (ret)
+		/* Someone can put this right now, recover with checking */
+		ret = atomic_inc_not_zero(&mod->refcnt);
+
+	return ret;
+}
 
+static int try_stop_module(struct module *mod, int flags, int *forced)
+{
 	/* If it's not unused, quit unless we're forcing. */
-	if (module_is_locked(sref->mod) || module_refcount(sref->mod) != 0) {
-		if (!(*sref->forced = try_force_unload(sref->flags)))
+	if (module_is_locked(mod) || try_release_module_ref(mod) != 0) {
+		*forced = try_force_unload(flags);
+		if (!(*forced))
 			return -EWOULDBLOCK;
 	}
 
 	/* Mark it as dying. */
-	sref->mod->state = MODULE_STATE_GOING;
-	return 0;
-}
+	mod->state = MODULE_STATE_GOING;
 
-static int try_stop_module(struct module *mod, int flags, int *forced)
-{
-	struct stopref sref = { mod, flags, forced };
-
-	return stop_machine(__try_stop_module, &sref, NULL);
+	return 0;
 }
 
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
+	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
 }
 EXPORT_SYMBOL(module_refcount);
 
@@ -935,10 +918,8 @@ static struct module_attribute modinfo_refcnt =
 void __module_get(struct module *module)
 {
 	if (module) {
-		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
+		atomic_inc(&module->refcnt);
 		trace_module_get(module, _RET_IP_);
-		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(__module_get);
@@ -947,21 +928,14 @@ bool try_module_get(struct module *module)
 {
 	bool ret = true;
 
-	if (module) {
-		if (module_is_locked(module))
-			goto end;
-
-		preempt_disable();
-
-		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->incs);
+	if (module && !module_is_locked(module)) {
+		if (module_is_live(module) &&
+		    atomic_inc_not_zero(&module->refcnt) != 0)
 			trace_module_get(module, _RET_IP_);
-		} else
+		else
 			ret = false;
-
-		preempt_enable();
 	}
-end:
+
 	return ret;
 }
 EXPORT_SYMBOL(try_module_get);
@@ -969,12 +943,8 @@ EXPORT_SYMBOL(try_module_get);
 void module_put(struct module *module)
 {
 	if (module && !module_is_locked(module)) {
-		preempt_disable();
-		smp_wmb(); /* see comment in module_refcount */
-		__this_cpu_inc(module->refptr->decs);
-
+		atomic_dec(&module->refcnt);
 		trace_module_put(module, _RET_IP_);
-		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(module_put);


