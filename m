Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCKR67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:58:59 -0400
Received: from mail.efficios.com ([78.47.125.74]:45761 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbaCKR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:58:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH] Tracepoint cleanup: remove unused API functions
Date: Tue, 11 Mar 2014 13:58:45 -0400
Message-Id: <1394560725-17132-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
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
 include/linux/tracepoint.h |   11 ---
 kernel/tracepoint.c        |  179 --------------------------------------------
 2 files changed, 190 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 7159a0a..d405195 100644
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
@@ -75,11 +69,6 @@ struct tracepoint_iter {
 	struct tracepoint * const *tracepoint;
 };
 
-extern void tracepoint_iter_start(struct tracepoint_iter *iter);
-extern void tracepoint_iter_next(struct tracepoint_iter *iter);
-extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
-extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
  * probe unregistration and the end of module exit to make sure there is no
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc56..0faf2a4 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -451,185 +451,6 @@ static void tracepoint_add_old_probes(void *old)
 	}
 }
 
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
-- 
1.7.10.4

