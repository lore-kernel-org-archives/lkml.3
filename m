Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbaCSWbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:31:44 -0400
Received: from mail.efficios.com ([78.47.125.74]:57748 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbaCSWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:31:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v6 1/3] Tracepoint cleanup: remove unused API functions
Date: Wed, 19 Mar 2014 18:31:00 -0400
Message-Id: <1395268262-31224-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the following commit:

commit b75ef8b44b1cb95f5a26484b0e2fe37a63b12b44
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Wed Aug 10 15:18:39 2011 -0400

    Tracepoint: Dissociate from module mutex

The following functions became unnecessary:

- tracepoint_probe_register_noupdate,
- tracepoint_probe_unregister_noupdate,
- tracepoint_probe_update_all.

In fact, none of the in-kernel tracers, nor LTTng, nor SystemTAP use
them. Remove those.

Moreover, the functions:

- tracepoint_iter_start,
- tracepoint_iter_next,
- tracepoint_iter_stop,
- tracepoint_iter_reset.

are unused by in-kernel tracers, LTTng and SystemTAP. Remove those too.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Frank Ch. Eigler <fche@redhat.com>
CC: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/tracepoint.h |   18 ----
 kernel/tracepoint.c        |  221 +-------------------------------------------
 2 files changed, 5 insertions(+), 234 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 7159a0a..812b255 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -48,12 +48,6 @@ extern int tracepoint_probe_register(const char *name, void *probe, void *data);
 extern int
 tracepoint_probe_unregister(const char *name, void *probe, void *data);
 
-extern int tracepoint_probe_register_noupdate(const char *name, void *probe,
-					      void *data);
-extern int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
-						void *data);
-extern void tracepoint_probe_update_all(void);
-
 #ifdef CONFIG_MODULES
 struct tp_module {
 	struct list_head list;
@@ -68,18 +62,6 @@ static inline bool trace_module_has_bad_taint(struct module *mod)
 }
 #endif /* CONFIG_MODULES */
 
-struct tracepoint_iter {
-#ifdef CONFIG_MODULES
-	struct tp_module *module;
-#endif /* CONFIG_MODULES */
-	struct tracepoint * const *tracepoint;
-};
-
-extern void tracepoint_iter_start(struct tracepoint_iter *iter);
-extern void tracepoint_iter_next(struct tracepoint_iter *iter);
-extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
-extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
  * probe unregistration and the end of module exit to make sure there is no
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc56..f27e5f0 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -66,10 +66,7 @@ struct tracepoint_entry {
 };
 
 struct tp_probes {
-	union {
-		struct rcu_head rcu;
-		struct list_head list;
-	} u;
+	struct rcu_head rcu;
 	struct tracepoint_func probes[0];
 };
 
@@ -82,7 +79,7 @@ static inline void *allocate_probes(int count)
 
 static void rcu_free_old_probes(struct rcu_head *head)
 {
-	kfree(container_of(head, struct tp_probes, u.rcu));
+	kfree(container_of(head, struct tp_probes, rcu));
 }
 
 static inline void release_probes(struct tracepoint_func *old)
@@ -90,7 +87,7 @@ static inline void release_probes(struct tracepoint_func *old)
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu_sched(&tp_probes->u.rcu, rcu_free_old_probes);
+		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
 	}
 }
 
@@ -438,198 +435,6 @@ int tracepoint_probe_unregister(const char *name, void *probe, void *data)
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
 
-static LIST_HEAD(old_probes);
-static int need_update;
-
-static void tracepoint_add_old_probes(void *old)
-{
-	need_update = 1;
-	if (old) {
-		struct tp_probes *tp_probes = container_of(old,
-			struct tp_probes, probes[0]);
-		list_add(&tp_probes->u.list, &old_probes);
-	}
-}
-
-/**
- * tracepoint_probe_register_noupdate -  register a probe but not connect
- * @name: tracepoint name
- * @probe: probe handler
- *
- * caller must call tracepoint_probe_update_all()
- */
-int tracepoint_probe_register_noupdate(const char *name, void *probe,
-				       void *data)
-{
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_add_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_add_old_probes(old);
-	mutex_unlock(&tracepoints_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
-
-/**
- * tracepoint_probe_unregister_noupdate -  remove a probe but not disconnect
- * @name: tracepoint name
- * @probe: probe function pointer
- *
- * caller must call tracepoint_probe_update_all()
- */
-int tracepoint_probe_unregister_noupdate(const char *name, void *probe,
-					 void *data)
-{
-	struct tracepoint_func *old;
-
-	mutex_lock(&tracepoints_mutex);
-	old = tracepoint_remove_probe(name, probe, data);
-	if (IS_ERR(old)) {
-		mutex_unlock(&tracepoints_mutex);
-		return PTR_ERR(old);
-	}
-	tracepoint_add_old_probes(old);
-	mutex_unlock(&tracepoints_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_unregister_noupdate);
-
-/**
- * tracepoint_probe_update_all -  update tracepoints
- */
-void tracepoint_probe_update_all(void)
-{
-	LIST_HEAD(release_probes);
-	struct tp_probes *pos, *next;
-
-	mutex_lock(&tracepoints_mutex);
-	if (!need_update) {
-		mutex_unlock(&tracepoints_mutex);
-		return;
-	}
-	if (!list_empty(&old_probes))
-		list_replace_init(&old_probes, &release_probes);
-	need_update = 0;
-	tracepoint_update_probes();
-	mutex_unlock(&tracepoints_mutex);
-	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
-		list_del(&pos->u.list);
-		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
-	}
-}
-EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
-
-/**
- * tracepoint_get_iter_range - Get a next tracepoint iterator given a range.
- * @tracepoint: current tracepoints (in), next tracepoint (out)
- * @begin: beginning of the range
- * @end: end of the range
- *
- * Returns whether a next tracepoint has been found (1) or not (0).
- * Will return the first tracepoint in the range if the input tracepoint is
- * NULL.
- */
-static int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
-	struct tracepoint * const *begin, struct tracepoint * const *end)
-{
-	if (!*tracepoint && begin != end) {
-		*tracepoint = begin;
-		return 1;
-	}
-	if (*tracepoint >= begin && *tracepoint < end)
-		return 1;
-	return 0;
-}
-
-#ifdef CONFIG_MODULES
-static void tracepoint_get_iter(struct tracepoint_iter *iter)
-{
-	int found = 0;
-	struct tp_module *iter_mod;
-
-	/* Core kernel tracepoints */
-	if (!iter->module) {
-		found = tracepoint_get_iter_range(&iter->tracepoint,
-				__start___tracepoints_ptrs,
-				__stop___tracepoints_ptrs);
-		if (found)
-			goto end;
-	}
-	/* Tracepoints in modules */
-	mutex_lock(&tracepoints_mutex);
-	list_for_each_entry(iter_mod, &tracepoint_module_list, list) {
-		/*
-		 * Sorted module list
-		 */
-		if (iter_mod < iter->module)
-			continue;
-		else if (iter_mod > iter->module)
-			iter->tracepoint = NULL;
-		found = tracepoint_get_iter_range(&iter->tracepoint,
-			iter_mod->tracepoints_ptrs,
-			iter_mod->tracepoints_ptrs
-				+ iter_mod->num_tracepoints);
-		if (found) {
-			iter->module = iter_mod;
-			break;
-		}
-	}
-	mutex_unlock(&tracepoints_mutex);
-end:
-	if (!found)
-		tracepoint_iter_reset(iter);
-}
-#else /* CONFIG_MODULES */
-static void tracepoint_get_iter(struct tracepoint_iter *iter)
-{
-	int found = 0;
-
-	/* Core kernel tracepoints */
-	found = tracepoint_get_iter_range(&iter->tracepoint,
-			__start___tracepoints_ptrs,
-			__stop___tracepoints_ptrs);
-	if (!found)
-		tracepoint_iter_reset(iter);
-}
-#endif /* CONFIG_MODULES */
-
-void tracepoint_iter_start(struct tracepoint_iter *iter)
-{
-	tracepoint_get_iter(iter);
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_start);
-
-void tracepoint_iter_next(struct tracepoint_iter *iter)
-{
-	iter->tracepoint++;
-	/*
-	 * iter->tracepoint may be invalid because we blindly incremented it.
-	 * Make sure it is valid by marshalling on the tracepoints, getting the
-	 * tracepoints from following modules if necessary.
-	 */
-	tracepoint_get_iter(iter);
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_next);
-
-void tracepoint_iter_stop(struct tracepoint_iter *iter)
-{
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
-
-void tracepoint_iter_reset(struct tracepoint_iter *iter)
-{
-#ifdef CONFIG_MODULES
-	iter->module = NULL;
-#endif /* CONFIG_MODULES */
-	iter->tracepoint = NULL;
-}
-EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
-
 #ifdef CONFIG_MODULES
 bool trace_module_has_bad_taint(struct module *mod)
 {
@@ -638,7 +443,7 @@ bool trace_module_has_bad_taint(struct module *mod)
 
 static int tracepoint_module_coming(struct module *mod)
 {
-	struct tp_module *tp_mod, *iter;
+	struct tp_module *tp_mod;
 	int ret = 0;
 
 	/*
@@ -656,23 +461,7 @@ static int tracepoint_module_coming(struct module *mod)
 	}
 	tp_mod->num_tracepoints = mod->num_tracepoints;
 	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
-
-	/*
-	 * tracepoint_module_list is kept sorted by struct module pointer
-	 * address for iteration on tracepoints from a seq_file that can release
-	 * the mutex between calls.
-	 */
-	list_for_each_entry_reverse(iter, &tracepoint_module_list, list) {
-		BUG_ON(iter == tp_mod);	/* Should never be in the list twice */
-		if (iter < tp_mod) {
-			/* We belong to the location right after iter. */
-			list_add(&tp_mod->list, &iter->list);
-			goto module_added;
-		}
-	}
-	/* We belong to the beginning of the list */
-	list_add(&tp_mod->list, &tracepoint_module_list);
-module_added:
+	list_add_tail(&tp_mod->list, &tracepoint_module_list);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
 end:
-- 
1.7.10.4

