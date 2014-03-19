Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbaCSWbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:31:50 -0400
Received: from mail.efficios.com ([78.47.125.74]:57768 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445AbaCSWbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:31:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v6 3/3] Tracepoint: register/unregister struct tracepoint
Date: Wed, 19 Mar 2014 18:31:02 -0400
Message-Id: <1395268262-31224-4-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register/unregister tracepoint probes with struct tracepoint pointer
rather than tracepoint name.

This change, which vastly simplifies tracepoint.c, has been proposed by
Steven Rostedt.

>From this point on, the tracers need to pass a struct tracepoint pointer
to probe register/unregister. A probe can now only be connected to a
tracepoint that exists. Moreover, tracers are responsible for
unregistering the probe before the module containing its associated
tracepoint is unloaded.

Not-Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Frank Ch. Eigler <fche@redhat.com>
CC: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ftrace_event.h |    1 +
 include/linux/tracepoint.h   |   44 ++--
 include/trace/ftrace.h       |    2 +
 kernel/trace/trace_events.c  |    8 +-
 kernel/tracepoint.c          |  536 ++++++++++++++++++++----------------------
 5 files changed, 287 insertions(+), 304 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4e4cc28..1592c1c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -230,6 +230,7 @@ struct ftrace_event_call {
 	struct list_head	list;
 	struct ftrace_event_class *class;
 	char			*name;
+	struct tracepoint	*tp;
 	struct trace_event	event;
 	const char		*print_fmt;
 	struct event_filter	*filter;
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 812b255..d16d7667c 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -21,6 +21,7 @@
 
 struct module;
 struct tracepoint;
+struct notifier_block;
 
 struct tracepoint_func {
 	void *func;
@@ -35,31 +36,32 @@ struct tracepoint {
 	struct tracepoint_func __rcu *funcs;
 };
 
-/*
- * Connect a probe to a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int tracepoint_probe_register(const char *name, void *probe, void *data);
-
-/*
- * Disconnect a probe from a tracepoint.
- * Internal API, should not be used directly.
- */
-extern int
-tracepoint_probe_unregister(const char *name, void *probe, void *data);
+extern
+int tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data);
+extern
+int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
+void for_each_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv);
 
 #ifdef CONFIG_MODULES
-struct tp_module {
-	struct list_head list;
-	unsigned int num_tracepoints;
-	struct tracepoint * const *tracepoints_ptrs;
-};
 bool trace_module_has_bad_taint(struct module *mod);
+int register_tracepoint_module_notifier(struct notifier_block *nb);
+int unregister_tracepoint_module_notifier(struct notifier_block *nb);
 #else
 static inline bool trace_module_has_bad_taint(struct module *mod)
 {
 	return false;
 }
+static inline
+int register_tracepoint_module_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline
+int unregister_tracepoint_module_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 #endif /* CONFIG_MODULES */
 
 /*
@@ -160,14 +162,14 @@ static inline void tracepoint_synchronize_unregister(void)
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
-		return tracepoint_probe_register(#name, (void *)probe,	\
-						 data);			\
+		return tracepoint_probe_register(&__tracepoint_##name,	\
+						(void *)probe, data);	\
 	}								\
 	static inline int						\
 	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
-		return tracepoint_probe_unregister(#name, (void *)probe, \
-						   data);		\
+		return tracepoint_probe_unregister(&__tracepoint_##name,\
+						(void *)probe, data);	\
 	}								\
 	static inline void						\
 	check_trace_callback_type_##name(void (*cb)(data_proto))	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28d..415b986 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -625,6 +625,7 @@ static struct ftrace_event_class __used __refdata event_class_##call = { \
 									\
 static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
+	.tp			= &__tracepoint_##call,			\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
@@ -639,6 +640,7 @@ static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
+	.tp			= &__tracepoint_##call,			\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f3989ce..0e39692 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -201,22 +201,22 @@ int ftrace_event_reg(struct ftrace_event_call *call,
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return tracepoint_probe_register(call->name,
+		return tracepoint_probe_register(call->tp,
 						 call->class->probe,
 						 file);
 	case TRACE_REG_UNREGISTER:
-		tracepoint_probe_unregister(call->name,
+		tracepoint_probe_unregister(call->tp,
 					    call->class->probe,
 					    file);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return tracepoint_probe_register(call->name,
+		return tracepoint_probe_register(call->tp,
 						 call->class->perf_probe,
 						 call);
 	case TRACE_REG_PERF_UNREGISTER:
-		tracepoint_probe_unregister(call->name,
+		tracepoint_probe_unregister(call->tp,
 					    call->class->perf_probe,
 					    call);
 		return 0;
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 2e4bfcb..d4d071c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -33,40 +33,38 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
 
+#ifdef CONFIG_MODULES
+struct tp_module {
+	struct list_head list;
+	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
+};
+
 /*
- * Tracepoints mutex protects the builtin and module tracepoints and the hash
- * table, as well as the local module list.
+ * Tracepoint module list mutex protects the local module list.
  */
-static DEFINE_MUTEX(tracepoints_mutex);
+static DEFINE_MUTEX(tp_modlist_mutex);
 
-#ifdef CONFIG_MODULES
-/* Local list of struct module */
-static LIST_HEAD(tracepoint_module_list);
+/* Local list of struct tp_module */
+static LIST_HEAD(tp_modlist);
 #endif /* CONFIG_MODULES */
 
 /*
- * Tracepoint hash table, containing the active tracepoints.
- * Protected by tracepoints_mutex.
+ * tracepoint_mutex protects the builtin and module tracepoints.
+ * tracepoint_mutex nests inside tp_modlist_mutex.
  */
-#define TRACEPOINT_HASH_BITS 6
-#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
-static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+static DEFINE_MUTEX(tracepoint_mutex);
 
 /*
  * Note about RCU :
  * It is used to delay the free of multiple probes array until a quiescent
  * state is reached.
- * Tracepoint entries modifications are protected by the tracepoints_mutex.
  */
-struct tracepoint_entry {
-	struct hlist_node hlist;
-	struct tracepoint_func *funcs;
-	int refcount;	/* Number of times armed. 0 if disarmed. */
-	char name[0];
-};
-
 struct tp_probes {
-	struct rcu_head rcu;
+	union {
+		struct rcu_head rcu;
+		struct list_head list;
+	} u;
 	struct tracepoint_func probes[0];
 };
 
@@ -79,7 +77,7 @@ static inline void *allocate_probes(int count)
 
 static void rcu_free_old_probes(struct rcu_head *head)
 {
-	kfree(container_of(head, struct tp_probes, rcu));
+	kfree(container_of(head, struct tp_probes, u.rcu));
 }
 
 static inline void release_probes(struct tracepoint_func *old)
@@ -87,38 +85,39 @@ static inline void release_probes(struct tracepoint_func *old)
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
+		call_rcu_sched(&tp_probes->u.rcu, rcu_free_old_probes);
 	}
 }
 
-static void debug_print_probes(struct tracepoint_entry *entry)
+static
+void debug_print_probes(struct tracepoint_func *funcs)
 {
 	int i;
 
-	if (!tracepoint_debug || !entry->funcs)
+	if (!tracepoint_debug || !funcs)
 		return;
 
-	for (i = 0; entry->funcs[i].func; i++)
-		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i].func);
+	for (i = 0; funcs[i].func; i++)
+		printk(KERN_DEBUG "Probe %d : %p\n", i, funcs[i].func);
 }
 
-static struct tracepoint_func *
-tracepoint_entry_add_probe(struct tracepoint_entry *entry,
-			   void *probe, void *data)
+static
+struct tracepoint_func *func_add(struct tracepoint_func **funcs,
+		struct tracepoint_func *tp_func)
 {
 	int nr_probes = 0;
 	struct tracepoint_func *old, *new;
 
-	if (WARN_ON(!probe))
+	if (WARN_ON(!tp_func->func))
 		return ERR_PTR(-EINVAL);
 
-	debug_print_probes(entry);
-	old = entry->funcs;
+	debug_print_probes(*funcs);
+	old = *funcs;
 	if (old) {
 		/* (N -> N+1), (N != 0, 1) probes */
 		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
-			if (old[nr_probes].func == probe &&
-			    old[nr_probes].data == data)
+			if (old[nr_probes].func == tp_func->func &&
+			    old[nr_probes].data == tp_func->data)
 				return ERR_PTR(-EEXIST);
 	}
 	/* + 2 : one for new probe, one for NULL func */
@@ -127,33 +126,31 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
 		return ERR_PTR(-ENOMEM);
 	if (old)
 		memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
-	new[nr_probes].func = probe;
-	new[nr_probes].data = data;
+	new[nr_probes] = *tp_func;
 	new[nr_probes + 1].func = NULL;
-	entry->refcount = nr_probes + 1;
-	entry->funcs = new;
-	debug_print_probes(entry);
+	*funcs = new;
+	debug_print_probes(*funcs);
 	return old;
 }
 
-static void *
-tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
-			      void *probe, void *data)
+static
+void *func_remove(struct tracepoint_func **funcs,
+		struct tracepoint_func *tp_func)
 {
 	int nr_probes = 0, nr_del = 0, i;
 	struct tracepoint_func *old, *new;
 
-	old = entry->funcs;
+	old = *funcs;
 
 	if (!old)
 		return ERR_PTR(-ENOENT);
 
-	debug_print_probes(entry);
+	debug_print_probes(*funcs);
 	/* (N -> M), (N > 1, M >= 0) probes */
-	if (probe) {
+	if (tp_func->func) {
 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-			if (old[nr_probes].func == probe &&
-			     old[nr_probes].data == data)
+			if (old[nr_probes].func == tp_func->func &&
+			     old[nr_probes].data == tp_func->data)
 				nr_del++;
 		}
 	}
@@ -164,9 +161,8 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
 	 */
 	if (nr_probes - nr_del == 0) {
 		/* N -> 0, (N > 1) */
-		entry->funcs = NULL;
-		entry->refcount = 0;
-		debug_print_probes(entry);
+		*funcs = NULL;
+		debug_print_probes(*funcs);
 		return old;
 	} else {
 		int j = 0;
@@ -176,90 +172,35 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i = 0; old[i].func; i++)
-			if (old[i].func != probe || old[i].data != data)
+			if (old[i].func != tp_func->func
+					|| old[i].data != tp_func->data)
 				new[j++] = old[i];
 		new[nr_probes - nr_del].func = NULL;
-		entry->refcount = nr_probes - nr_del;
-		entry->funcs = new;
+		*funcs = new;
 	}
-	debug_print_probes(entry);
+	debug_print_probes(*funcs);
 	return old;
 }
 
 /*
- * Get tracepoint if the tracepoint is present in the tracepoint hash table.
- * Must be called with tracepoints_mutex held.
- * Returns NULL if not present.
- */
-static struct tracepoint_entry *get_tracepoint(const char *name)
-{
-	struct hlist_head *head;
-	struct tracepoint_entry *e;
-	u32 hash = jhash(name, strlen(name), 0);
-
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, head, hlist) {
-		if (!strcmp(name, e->name))
-			return e;
-	}
-	return NULL;
-}
-
-/*
- * Add the tracepoint to the tracepoint hash table. Must be called with
- * tracepoints_mutex held.
- */
-static struct tracepoint_entry *add_tracepoint(const char *name)
-{
-	struct hlist_head *head;
-	struct tracepoint_entry *e;
-	size_t name_len = strlen(name) + 1;
-	u32 hash = jhash(name, name_len-1, 0);
-
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, head, hlist) {
-		if (!strcmp(name, e->name)) {
-			printk(KERN_NOTICE
-				"tracepoint %s busy\n", name);
-			return ERR_PTR(-EEXIST);	/* Already there */
-		}
-	}
-	/*
-	 * Using kmalloc here to allocate a variable length element. Could
-	 * cause some memory fragmentation if overused.
-	 */
-	e = kmalloc(sizeof(struct tracepoint_entry) + name_len, GFP_KERNEL);
-	if (!e)
-		return ERR_PTR(-ENOMEM);
-	memcpy(&e->name[0], name, name_len);
-	e->funcs = NULL;
-	e->refcount = 0;
-	hlist_add_head(&e->hlist, head);
-	return e;
-}
-
-/*
- * Remove the tracepoint from the tracepoint hash table. Must be called with
- * mutex_lock held.
+ * Add the probe function to a tracepoint.
  */
-static inline void remove_tracepoint(struct tracepoint_entry *e)
+static
+int tracepoint_add_func(struct tracepoint *tp,
+		struct tracepoint_func *func)
 {
-	hlist_del(&e->hlist);
-	kfree(e);
-}
+	struct tracepoint_func *old, *tp_funcs;
 
-/*
- * Sets the probe callback corresponding to one tracepoint.
- */
-static void set_tracepoint(struct tracepoint_entry **entry,
-	struct tracepoint *elem, int active)
-{
-	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
+	if (tp->regfunc && !static_key_enabled(&tp->key))
+		tp->regfunc();
 
-	if (elem->regfunc && !static_key_enabled(&elem->key) && active)
-		elem->regfunc();
-	else if (elem->unregfunc && static_key_enabled(&elem->key) && !active)
-		elem->unregfunc();
+	tp_funcs = tp->funcs;
+	old = func_add(&tp_funcs, func);
+	if (IS_ERR(old)) {
+		WARN_ON_ONCE(1);
+		return PTR_ERR(old);
+	}
+	release_probes(old);
 
 	/*
 	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
@@ -268,172 +209,89 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * include/linux/tracepoints.h. A matching smp_read_barrier_depends()
 	 * is used.
 	 */
-	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (active && !static_key_enabled(&elem->key))
-		static_key_slow_inc(&elem->key);
-	else if (!active && static_key_enabled(&elem->key))
-		static_key_slow_dec(&elem->key);
+	rcu_assign_pointer(tp->funcs, tp_funcs);
+	if (!static_key_enabled(&tp->key))
+		static_key_slow_inc(&tp->key);
+	return 0;
 }
 
 /*
- * Disable a tracepoint and its probe callback.
+ * Remove a probe function from a tracepoint.
  * Note: only waiting an RCU period after setting elem->call to the empty
  * function insures that the original callback is not used anymore. This insured
  * by preempt_disable around the call site.
  */
-static void disable_tracepoint(struct tracepoint *elem)
+static
+int tracepoint_remove_func(struct tracepoint *tp,
+		struct tracepoint_func *func)
 {
-	if (elem->unregfunc && static_key_enabled(&elem->key))
-		elem->unregfunc();
+	struct tracepoint_func *old, *tp_funcs;
 
-	if (static_key_enabled(&elem->key))
-		static_key_slow_dec(&elem->key);
-	rcu_assign_pointer(elem->funcs, NULL);
-}
-
-/**
- * tracepoint_update_probe_range - Update a probe range
- * @begin: beginning of the range
- * @end: end of the range
- *
- * Updates the probe callback corresponding to a range of tracepoints.
- * Called with tracepoints_mutex held.
- */
-static void tracepoint_update_probe_range(struct tracepoint * const *begin,
-					  struct tracepoint * const *end)
-{
-	struct tracepoint * const *iter;
-	struct tracepoint_entry *mark_entry;
-
-	if (!begin)
-		return;
-
-	for (iter = begin; iter < end; iter++) {
-		mark_entry = get_tracepoint((*iter)->name);
-		if (mark_entry) {
-			set_tracepoint(&mark_entry, *iter,
-					!!mark_entry->refcount);
-		} else {
-			disable_tracepoint(*iter);
-		}
+	tp_funcs = tp->funcs;
+	old = func_remove(&tp_funcs, func);
+	if (IS_ERR(old)) {
+		WARN_ON_ONCE(1);
+		return PTR_ERR(old);
 	}
-}
-
-#ifdef CONFIG_MODULES
-void module_update_tracepoints(void)
-{
-	struct tp_module *tp_mod;
-
-	list_for_each_entry(tp_mod, &tracepoint_module_list, list)
-		tracepoint_update_probe_range(tp_mod->tracepoints_ptrs,
-			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
-}
-#else /* CONFIG_MODULES */
-void module_update_tracepoints(void)
-{
-}
-#endif /* CONFIG_MODULES */
-
+	release_probes(old);
 
-/*
- * Update probes, removing the faulty probes.
- * Called with tracepoints_mutex held.
- */
-static void tracepoint_update_probes(void)
-{
-	/* Core kernel tracepoints */
-	tracepoint_update_probe_range(__start___tracepoints_ptrs,
-		__stop___tracepoints_ptrs);
-	/* tracepoints in modules. */
-	module_update_tracepoints();
-}
+	if (!tp_funcs) {
+		/* Removed last function */
+		if (tp->unregfunc && static_key_enabled(&tp->key))
+			tp->unregfunc();
 
-static struct tracepoint_func *
-tracepoint_add_probe(const char *name, void *probe, void *data)
-{
-	struct tracepoint_entry *entry;
-	struct tracepoint_func *old;
-
-	entry = get_tracepoint(name);
-	if (!entry) {
-		entry = add_tracepoint(name);
-		if (IS_ERR(entry))
-			return (struct tracepoint_func *)entry;
+		if (static_key_enabled(&tp->key))
+			static_key_slow_dec(&tp->key);
 	}
-	old = tracepoint_entry_add_probe(entry, probe, data);
-	if (IS_ERR(old) && !entry->refcount)
-		remove_tracepoint(entry);
-	return old;
+	rcu_assign_pointer(tp->funcs, tp_funcs);
+	return 0;
 }
 
 /**
  * tracepoint_probe_register -  Connect a probe to a tracepoint
- * @name: tracepoint name
+ * @tp: tracepoint
  * @probe: probe handler
  * @data: probe private data
  *
  * Returns 0 if ok, error value on error.
- * The probe address must at least be aligned on the architecture pointer size.
+ * Note: if @tp is within a module, the caller is responsible for
+ * unregistering the probe before the module is gone. This can be
+ * performed either with a tracepoint_module going notifier, or from
+ * within module exit functions.
  */
-int tracepoint_probe_register(const char *name, void *probe, void *data)
+int tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data)
 {
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_update_probes();		/* may update entry */
-	mutex_unlock(&tracepoints_mutex);
-	release_probes(old);
-	return 0;
+	struct tracepoint_func tp_func;
+	int ret;
+
+	mutex_lock(&tracepoint_mutex);
+	tp_func.func = probe;
+	tp_func.data = data;
+	ret = tracepoint_add_func(tp, &tp_func);
+	mutex_unlock(&tracepoint_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
-static struct tracepoint_func *
-tracepoint_remove_probe(const char *name, void *probe, void *data)
-{
-	struct tracepoint_entry *entry;
-	struct tracepoint_func *old;
-
-	entry = get_tracepoint(name);
-	if (!entry)
-		return ERR_PTR(-ENOENT);
-	old = tracepoint_entry_remove_probe(entry, probe, data);
-	if (IS_ERR(old))
-		return old;
-	if (!entry->refcount)
-		remove_tracepoint(entry);
-	return old;
-}
-
 /**
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
- * @name: tracepoint name
+ * @tp: tracepoint
  * @probe: probe function pointer
  * @data: probe private data
  *
- * We do not need to call a synchronize_sched to make sure the probes have
- * finished running before doing a module unload, because the module unload
- * itself uses stop_machine(), which insures that every preempt disabled section
- * have finished.
+ * Returns 0 if ok, error value on error.
  */
-int tracepoint_probe_unregister(const char *name, void *probe, void *data)
+int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
 {
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_update_probes();		/* may update entry */
-	mutex_unlock(&tracepoints_mutex);
-	release_probes(old);
-	return 0;
+	struct tracepoint_func tp_func;
+	int ret;
+
+	mutex_lock(&tracepoint_mutex);
+	tp_func.func = probe;
+	tp_func.data = data;
+	ret = tracepoint_remove_func(tp, &tp_func);
+	mutex_unlock(&tracepoint_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
 
@@ -443,19 +301,62 @@ bool trace_module_has_bad_taint(struct module *mod)
 	return mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP));
 }
 
-static int tracepoint_module_coming(struct module *mod)
+static BLOCKING_NOTIFIER_HEAD(tracepoint_notify_list);
+
+/**
+ * register_tracepoint_notifier - register tracepoint coming/going notifier
+ * @nb: notifier block
+ *
+ * Notifiers registered with this function are called on module
+ * coming/going with the tp_modlist_mutex held.
+ */
+int register_tracepoint_module_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&tracepoint_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_tracepoint_module_notifier);
+
+/**
+ * unregister_tracepoint_notifier - unregister tracepoint coming/going notifier
+ * @nb: notifier block
+ */
+int unregister_tracepoint_module_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&tracepoint_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_tracepoint_module_notifier);
+
+/*
+ * Ensure the tracer unregistered the module's probes before the module
+ * teardown is performed. Prevents leaks of probe and data pointers.
+ */
+static
+void tp_module_going_check_quiescent(struct tracepoint * const *begin,
+		struct tracepoint * const *end)
+{
+	struct tracepoint * const *iter;
+
+	if (!begin)
+		return;
+	for (iter = begin; iter < end; iter++)
+		WARN_ON_ONCE((*iter)->funcs);
+}
+
+static
+int tracepoint_module_coming(struct module *mod)
 {
 	struct tp_module *tp_mod;
 	int ret = 0;
 
 	/*
-	 * We skip modules that taint the kernel, especially those with different
-	 * module headers (for forced load), to make sure we don't cause a crash.
-	 * Staging and out-of-tree GPL modules are fine.
+	 * We skip modules that taint the kernel, especially those with
+	 * different module headers (for forced load), to make sure we
+	 * don't cause a crash. Staging and out-of-tree GPL modules are
+	 * fine.
 	 */
 	if (trace_module_has_bad_taint(mod))
 		return 0;
-	mutex_lock(&tracepoints_mutex);
+	mutex_lock(&tp_modlist_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
 	if (!tp_mod) {
 		ret = -ENOMEM;
@@ -463,25 +364,32 @@ static int tracepoint_module_coming(struct module *mod)
 	}
 	tp_mod->num_tracepoints = mod->num_tracepoints;
 	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
-	list_add_tail(&tp_mod->list, &tracepoint_module_list);
-	tracepoint_update_probe_range(mod->tracepoints_ptrs,
-		mod->tracepoints_ptrs + mod->num_tracepoints);
+	list_add_tail(&tp_mod->list, &tp_modlist);
+	blocking_notifier_call_chain(&tracepoint_notify_list,
+			MODULE_STATE_COMING, mod);
 end:
-	mutex_unlock(&tracepoints_mutex);
+	mutex_unlock(&tp_modlist_mutex);
 	return ret;
 }
 
-static int tracepoint_module_going(struct module *mod)
+static
+void tracepoint_module_going(struct module *mod)
 {
 	struct tp_module *pos;
 
-	mutex_lock(&tracepoints_mutex);
-	tracepoint_update_probe_range(mod->tracepoints_ptrs,
-		mod->tracepoints_ptrs + mod->num_tracepoints);
-	list_for_each_entry(pos, &tracepoint_module_list, list) {
+	mutex_lock(&tp_modlist_mutex);
+	list_for_each_entry(pos, &tp_modlist, list) {
 		if (pos->tracepoints_ptrs == mod->tracepoints_ptrs) {
+			blocking_notifier_call_chain(&tracepoint_notify_list,
+					MODULE_STATE_GOING, mod);
 			list_del(&pos->list);
 			kfree(pos);
+			/*
+			 * Called the going notifier before checking for
+			 * quiescence.
+			 */
+			tp_module_going_check_quiescent(mod->tracepoints_ptrs,
+				mod->tracepoints_ptrs + mod->num_tracepoints);
 			break;
 		}
 	}
@@ -491,12 +399,12 @@ static int tracepoint_module_going(struct module *mod)
 	 * flag on "going", in case a module taints the kernel only after being
 	 * loaded.
 	 */
-	mutex_unlock(&tracepoints_mutex);
-	return 0;
+	mutex_unlock(&tp_modlist_mutex);
 }
 
+static
 int tracepoint_module_notify(struct notifier_block *self,
-			     unsigned long val, void *data)
+		unsigned long val, void *data)
 {
 	struct module *mod = data;
 	int ret = 0;
@@ -505,30 +413,100 @@ int tracepoint_module_notify(struct notifier_block *self,
 	case MODULE_STATE_COMING:
 		ret = tracepoint_module_coming(mod);
 		break;
-	case MODULE_STATE_LIVE:
-		break;
 	case MODULE_STATE_GOING:
-		ret = tracepoint_module_going(mod);
+		tracepoint_module_going(mod);
+		break;
+	default:
 		break;
 	}
 	return ret;
 }
 
+static
 struct notifier_block tracepoint_module_nb = {
 	.notifier_call = tracepoint_module_notify,
 	.priority = 0,
 };
 
-static int init_tracepoints(void)
+static __init int init_tracepoints(void)
 {
-	return register_module_notifier(&tracepoint_module_nb);
+	int ret;
+
+	ret = register_module_notifier(&tracepoint_module_nb);
+	if (ret) {
+		pr_warning("Failed to register tracepoint module enter notifier\n");
+	}
+	return ret;
 }
 __initcall(init_tracepoints);
 #endif /* CONFIG_MODULES */
 
+static
+void for_each_tracepoint_range(struct tracepoint * const *begin,
+		struct tracepoint * const *end,
+		void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv)
+{
+	struct tracepoint * const *iter;
+
+	if (!begin)
+		return;
+	for (iter = begin; iter < end; iter++)
+		fct(*iter, priv);
+}
+
+static
+void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv)
+{
+	for_each_tracepoint_range(__start___tracepoints_ptrs,
+		__stop___tracepoints_ptrs, fct, priv);
+}
+
+#ifdef CONFIG_MODULES
+static
+void for_each_module_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv)
+{
+	struct tp_module *tp_mod;
+
+	mutex_lock(&tp_modlist_mutex);
+	list_for_each_entry(tp_mod, &tp_modlist, list)
+		for_each_tracepoint_range(tp_mod->tracepoints_ptrs,
+			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints,
+			fct, priv);
+	mutex_unlock(&tp_modlist_mutex);
+}
+#else /* CONFIG_MODULES */
+static
+void for_each_module_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv)
+{
+}
+#endif /* CONFIG_MODULES */
+
+/**
+ * for_each_tracepoint - iteration on all tracepoints
+ * @fct: callback
+ * @priv: private data
+ *
+ * Modules using "coming" and "going" notifiers to get notified of
+ * tracepoints within modules need to know the full listing of
+ * tracepoints beforehand.
+ */
+void for_each_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+		void *priv)
+{
+	/* Core kernel tracepoints */
+	for_each_kernel_tracepoint(fct, priv);
+	/* Tracepoints in modules */
+	for_each_module_tracepoint(fct, priv);
+}
+EXPORT_SYMBOL_GPL(for_each_tracepoint);
+
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
-/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
+/* NB: reg/unreg are called while guarded with the tracepoint_mutex */
 static int sys_tracepoint_refcount;
 
 void syscall_regfunc(void)
-- 
1.7.10.4

