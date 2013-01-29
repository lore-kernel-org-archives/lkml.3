Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3A2SE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:04:58 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:36491 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3A2SE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:04:56 -0500
Date: Tue, 29 Jan 2013 10:04:52 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] module: Convert to generic percpu refcounts
Message-ID: <20130129180452.GJ26407@google.com>
References: <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
 <20130128215042.GN22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128215042.GN22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started screwing aronud just to see how hard a conversion would be and
what it'd look like. I _think_ this is complete, but there's enough
going on I undoubtedly missed something.

Completely untested - builds and that's it. I'm sure it's broken.

Deletes almost 100 lines of code though. I like how it looks for the
most part... MODULE_STATE_GOING is messy since the percpu ref has to
track that, and I didn't want to track that in two places - but I
couldn't just delete the enum since module notifiers use it. It's
currently vestigal and only used for the notifiers.

Similarly with the other places module->state and percpu_ref_dead() (via
module_is_live()) are checked... bit ugly but ah well.

---
 include/linux/module.h        |  28 +++----
 include/trace/events/module.h |   2 +-
 kernel/debug/kdb/kdb_main.c   |   8 +-
 kernel/module.c               | 165 +++++++++++++-----------------------------
 4 files changed, 60 insertions(+), 143 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ead1b57..88f78f6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
 #include <linux/export.h>
+#include <linux/percpu-refcount.h>
 
 #include <linux/percpu.h>
 #include <asm/module.h>
@@ -206,19 +207,7 @@ enum module_state {
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
+const char *module_state(struct module *mod);
 
 struct module
 {
@@ -361,13 +350,10 @@ struct module
 	/* What modules do I depend on? */
 	struct list_head target_list;
 
-	/* Who is waiting for us to be unloaded */
-	struct task_struct *waiter;
-
 	/* Destruction function. */
 	void (*exit)(void);
 
-	struct module_ref __percpu *refptr;
+	struct percpu_ref ref;
 #endif
 
 #ifdef CONFIG_CONSTRUCTORS
@@ -387,7 +373,7 @@ extern struct mutex module_mutex;
    (IDE & SCSI) require entry into the module during init.*/
 static inline int module_is_live(struct module *mod)
 {
-	return mod->state != MODULE_STATE_GOING;
+	return !percpu_ref_dead(&mod->ref);
 }
 
 struct module *__module_text_address(unsigned long addr);
@@ -451,7 +437,11 @@ extern void __module_put_and_exit(struct module *mod, long code)
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
 
 #ifdef CONFIG_MODULE_UNLOAD
-unsigned long module_refcount(struct module *mod);
+static inline unsigned long module_refcount(struct module *mod)
+{
+	return percpu_ref_count(&mod->ref) - 1;
+}
+
 void __symbol_put(const char *symbol);
 #define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
 void symbol_put_addr(void *addr);
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 1619327..3de2241 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -78,7 +78,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
+		__entry->refcnt = module_refcount(mod);
 		__assign_str(name, mod->name);
 	),
 
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 8875254..813c0ed 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1978,13 +1978,7 @@ static int kdb_lsmod(int argc, const char **argv)
 #ifdef CONFIG_MODULE_UNLOAD
 		kdb_printf("%4ld ", module_refcount(mod));
 #endif
-		if (mod->state == MODULE_STATE_GOING)
-			kdb_printf(" (Unloading)");
-		else if (mod->state == MODULE_STATE_COMING)
-			kdb_printf(" (Loading)");
-		else
-			kdb_printf(" (Live)");
-		kdb_printf(" 0x%p", mod->module_core);
+		kdb_printf(" (%s) 0x%p", module_state(mod), mod->module_core);
 
 #ifdef CONFIG_MODULE_UNLOAD
 		{
diff --git a/kernel/module.c b/kernel/module.c
index 921bed4..08aa83a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -625,21 +625,15 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
 EXPORT_TRACEPOINT_SYMBOL(module_get);
 
 /* Init the unload section of the module. */
-static int module_unload_init(struct module *mod)
+static void module_unload_init(struct module *mod)
 {
-	mod->refptr = alloc_percpu(struct module_ref);
-	if (!mod->refptr)
-		return -ENOMEM;
+	percpu_ref_init(&mod->ref);
 
 	INIT_LIST_HEAD(&mod->source_list);
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->incs, 1);
-	/* Backwards compatibility macros put refcount during init. */
-	mod->waiter = current;
-
-	return 0;
+	__module_get(mod);
 }
 
 /* Does a already use b? */
@@ -719,8 +713,6 @@ static void module_unload_free(struct module *mod)
 		kfree(use);
 	}
 	mutex_unlock(&module_mutex);
-
-	free_percpu(mod->refptr);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -745,6 +737,15 @@ struct stopref
 	int *forced;
 };
 
+static void stop_module(struct module *mod)
+{
+	/* Mark it as dying, drop base ref */
+	if (percpu_ref_kill(&mod->ref))
+		module_put(mod);
+	else
+		WARN(1, "initial module ref already dropped");
+}
+
 /* Whole machine is stopped with interrupts off when this runs. */
 static int __try_stop_module(void *_sref)
 {
@@ -756,8 +757,7 @@ static int __try_stop_module(void *_sref)
 			return -EWOULDBLOCK;
 	}
 
-	/* Mark it as dying. */
-	sref->mod->state = MODULE_STATE_GOING;
+	stop_module(sref->mod);
 	return 0;
 }
 
@@ -769,57 +769,14 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 		return stop_machine(__try_stop_module, &sref, NULL);
 	} else {
 		/* We don't need to stop the machine for this. */
-		mod->state = MODULE_STATE_GOING;
-		synchronize_sched();
+		stop_module(mod);
 		return 0;
 	}
 }
 
-unsigned long module_refcount(struct module *mod)
-{
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
-}
-EXPORT_SYMBOL(module_refcount);
-
 /* This exists whether we can unload or not */
 static void free_module(struct module *mod);
 
-static void wait_for_zero_refcount(struct module *mod)
-{
-	/* Since we might sleep for some time, release the mutex first */
-	mutex_unlock(&module_mutex);
-	for (;;) {
-		pr_debug("Looking at refcount...\n");
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (module_refcount(mod) == 0)
-			break;
-		schedule();
-	}
-	current->state = TASK_RUNNING;
-	mutex_lock(&module_mutex);
-}
-
 SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		unsigned int, flags)
 {
@@ -850,7 +807,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	}
 
 	/* Doing init or already dying? */
-	if (mod->state != MODULE_STATE_LIVE) {
+	if (mod->state != MODULE_STATE_LIVE || !module_is_live(mod)) {
 		/* FIXME: if (force), slam module count and wake up
                    waiter --RR */
 		pr_debug("%s already dying\n", mod->name);
@@ -868,19 +825,17 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		}
 	}
 
-	/* Set this up before setting mod->state */
-	mod->waiter = current;
-
 	/* Stop the machine so refcounts can't move and disable module. */
 	ret = try_stop_module(mod, flags, &forced);
 	if (ret != 0)
 		goto out;
 
+	mutex_unlock(&module_mutex);
+
 	/* Never wait if forced. */
-	if (!forced && module_refcount(mod) != 0)
-		wait_for_zero_refcount(mod);
+	if (!forced)
+		wait_event(module_wq, !percpu_ref_count(&mod->ref));
 
-	mutex_unlock(&module_mutex);
 	/* Final destruction now no one is using it. */
 	if (mod->exit != NULL)
 		mod->exit();
@@ -962,45 +917,29 @@ static struct module_attribute modinfo_refcnt =
 void __module_get(struct module *module)
 {
 	if (module) {
-		preempt_disable();
-		__this_cpu_inc(module->refptr->incs);
 		trace_module_get(module, _RET_IP_);
-		preempt_enable();
+		percpu_ref_get(&module->ref);
 	}
 }
 EXPORT_SYMBOL(__module_get);
 
 bool try_module_get(struct module *module)
 {
-	bool ret = true;
-
 	if (module) {
-		preempt_disable();
-
-		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->incs);
-			trace_module_get(module, _RET_IP_);
-		} else
-			ret = false;
-
-		preempt_enable();
-	}
-	return ret;
+		trace_module_get(module, _RET_IP_);
+		return percpu_ref_tryget(&module->ref);
+	} else
+		return true;
 }
 EXPORT_SYMBOL(try_module_get);
 
 void module_put(struct module *module)
 {
 	if (module) {
-		preempt_disable();
-		smp_wmb(); /* see comment in module_refcount */
-		__this_cpu_inc(module->refptr->decs);
-
 		trace_module_put(module, _RET_IP_);
-		/* Maybe they're waiting for us to drop reference? */
-		if (unlikely(!module_is_live(module)))
-			wake_up_process(module->waiter);
-		preempt_enable();
+
+		if (percpu_ref_put(&module->ref))
+			wake_up_all(&module_wq);
 	}
 }
 EXPORT_SYMBOL(module_put);
@@ -1048,25 +987,27 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 	return l;
 }
 
-static ssize_t show_initstate(struct module_attribute *mattr,
-			      struct module_kobject *mk, char *buffer)
+const char *module_state(struct module *mod)
 {
-	const char *state = "unknown";
-
-	switch (mk->mod->state) {
+	switch (mod->state) {
 	case MODULE_STATE_LIVE:
-		state = "live";
-		break;
+		if (module_is_live(mod))
+			return "live";
+		else
+			return "going";
 	case MODULE_STATE_COMING:
-		state = "coming";
-		break;
-	case MODULE_STATE_GOING:
-		state = "going";
-		break;
+		return "coming";
+	case MODULE_STATE_UNFORMED:
+		return "unformed";
 	default:
-		BUG();
+		return "unknown";
 	}
-	return sprintf(buffer, "%s\n", state);
+}
+
+static ssize_t show_initstate(struct module_attribute *mattr,
+			      struct module_kobject *mk, char *buffer)
+{
+	return sprintf(buffer, "%s\n", module_state(mk->mod));
 }
 
 static struct module_attribute modinfo_initstate =
@@ -3022,8 +2963,7 @@ static bool finished_loading(const char *name)
 
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE
-		|| mod->state == MODULE_STATE_GOING;
+	ret = !mod || mod->state == MODULE_STATE_LIVE;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3073,8 +3013,7 @@ static int do_init_module(struct module *mod)
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
-		mod->state = MODULE_STATE_GOING;
-		synchronize_sched();
+		stop_module(mod);
 		module_put(mod);
 		blocking_notifier_call_chain(&module_notify_list,
 					     MODULE_STATE_GOING, mod);
@@ -3245,9 +3184,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 #endif
 
 	/* Now module is in final location, initialize linked lists, etc. */
-	err = module_unload_init(mod);
-	if (err)
-		goto unlink_mod;
+	module_unload_init(mod);
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
@@ -3323,7 +3260,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	free_modinfo(mod);
  free_unload:
 	module_unload_free(mod);
- unlink_mod:
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
@@ -3614,12 +3550,12 @@ static char *module_flags(struct module *mod, char *buf)
 
 	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
 	if (mod->taints ||
-	    mod->state == MODULE_STATE_GOING ||
+	    !module_is_live(mod) ||
 	    mod->state == MODULE_STATE_COMING) {
 		buf[bx++] = '(';
 		bx += module_flags_taint(mod, buf + bx);
 		/* Show a - for module-is-being-unloaded */
-		if (mod->state == MODULE_STATE_GOING)
+		if (!module_is_live(mod))
 			buf[bx++] = '-';
 		/* Show a + for module-is-being-loaded */
 		if (mod->state == MODULE_STATE_COMING)
@@ -3663,10 +3599,7 @@ static int m_show(struct seq_file *m, void *p)
 	print_unload_info(m, mod);
 
 	/* Informative for users. */
-	seq_printf(m, " %s",
-		   mod->state == MODULE_STATE_GOING ? "Unloading":
-		   mod->state == MODULE_STATE_COMING ? "Loading":
-		   "Live");
+	seq_printf(m, " %s", module_state(mod));
 	/* Used by oprofile and other similar tools. */
 	seq_printf(m, " 0x%pK", mod->module_core);
 
-- 
1.7.12

