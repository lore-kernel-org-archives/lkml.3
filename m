Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab3GCMjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:39:02 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50635 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3GCMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:52 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-ed-51d41aa4abca
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 04/12] tracing/kprobes: Factor out struct trace_probe
Date: Wed,  3 Jul 2013 21:35:38 +0900
Message-Id: <1372854946-17074-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There are functions that can be shared to both of kprobes and uprobes.
Separate common data structure to struct trace_probe and use it from
the shared functions.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 340 +++++++++++++++++++++-----------------------
 kernel/trace/trace_probe.h  |  20 +++
 2 files changed, 185 insertions(+), 175 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5351e5d3c8f5..28360bbbb0b0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,70 +27,54 @@
 /**
  * Kprobe event core functions
  */
-struct trace_probe {
+struct trace_kprobe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
 	unsigned long 		nhit;
-	unsigned int		flags;	/* For TP_FLAG_* */
 	const char		*symbol;	/* symbol name */
-	struct ftrace_event_class	class;
-	struct ftrace_event_call	call;
-	struct ftrace_event_file * __rcu *files;
-	ssize_t			size;		/* trace entry size */
-	unsigned int		nr_args;
-	struct probe_arg	args[];
+	struct trace_probe	p;
 };
 
-#define SIZEOF_TRACE_PROBE(n)			\
-	(offsetof(struct trace_probe, args) +	\
+#define SIZEOF_TRACE_PROBE(n)				\
+	(offsetof(struct trace_kprobe, p.args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_is_return(struct trace_kprobe *tp)
 {
 	return tp->rp.handler != NULL;
 }
 
-static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
+static __kprobes const char *trace_kprobe_symbol(struct trace_kprobe *tp)
 {
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
-static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
+static __kprobes unsigned long trace_kprobe_offset(struct trace_kprobe *tp)
 {
 	return tp->rp.kp.offset;
 }
 
-static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
-{
-	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
-}
-
-static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
-{
-	return !!(tp->flags & TP_FLAG_REGISTERED);
-}
-
-static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_has_gone(struct trace_kprobe *tp)
 {
 	return !!(kprobe_gone(&tp->rp.kp));
 }
 
-static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
-						struct module *mod)
+static __kprobes bool trace_kprobe_within_module(struct trace_kprobe *tp,
+						 struct module *mod)
 {
 	int len = strlen(mod->name);
-	const char *name = trace_probe_symbol(tp);
+	const char *name = trace_kprobe_symbol(tp);
 	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
 }
 
-static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_is_on_module(struct trace_kprobe *tp)
 {
-	return !!strchr(trace_probe_symbol(tp), ':');
+	return !!strchr(trace_kprobe_symbol(tp), ':');
 }
 
-static int register_probe_event(struct trace_probe *tp);
-static void unregister_probe_event(struct trace_probe *tp);
+static int register_probe_event(struct trace_kprobe *tp);
+static void unregister_probe_event(struct trace_kprobe *tp);
 
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
@@ -102,14 +86,14 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
-static struct trace_probe *alloc_trace_probe(const char *group,
+static struct trace_kprobe *alloc_trace_probe(const char *group,
 					     const char *event,
 					     void *addr,
 					     const char *symbol,
 					     unsigned long offs,
 					     int nargs, bool is_return)
 {
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int ret = -ENOMEM;
 
 	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
@@ -135,9 +119,9 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->call.class = &tp->class;
-	tp->call.name = kstrdup(event, GFP_KERNEL);
-	if (!tp->call.name)
+	tp->p.call.class = &tp->p.class;
+	tp->p.call.name = kstrdup(event, GFP_KERNEL);
+	if (!tp->p.call.name)
 		goto error;
 
 	if (!group || !is_good_name(group)) {
@@ -145,45 +129,45 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->class.system = kstrdup(group, GFP_KERNEL);
-	if (!tp->class.system)
+	tp->p.class.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->p.class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
 	return tp;
 error:
-	kfree(tp->call.name);
+	kfree(tp->p.call.name);
 	kfree(tp->symbol);
 	kfree(tp);
 	return ERR_PTR(ret);
 }
 
-static void free_trace_probe(struct trace_probe *tp)
+static void free_trace_probe(struct trace_kprobe *tp)
 {
 	int i;
 
-	for (i = 0; i < tp->nr_args; i++)
-		traceprobe_free_probe_arg(&tp->args[i]);
+	for (i = 0; i < tp->p.nr_args; i++)
+		traceprobe_free_probe_arg(&tp->p.args[i]);
 
-	kfree(tp->call.class->system);
-	kfree(tp->call.name);
+	kfree(tp->p.call.class->system);
+	kfree(tp->p.call.name);
 	kfree(tp->symbol);
 	kfree(tp);
 }
 
-static struct trace_probe *find_trace_probe(const char *event,
-					    const char *group)
+static struct trace_kprobe *find_trace_probe(const char *event,
+					     const char *group)
 {
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 
 	list_for_each_entry(tp, &probe_list, list)
-		if (strcmp(tp->call.name, event) == 0 &&
-		    strcmp(tp->call.class->system, group) == 0)
+		if (strcmp(tp->p.call.name, event) == 0 &&
+		    strcmp(tp->p.call.class->system, group) == 0)
 			return tp;
 	return NULL;
 }
 
-static int trace_probe_nr_files(struct trace_probe *tp)
+static int trace_probe_nr_files(struct trace_kprobe *tp)
 {
 	struct ftrace_event_file **file;
 	int ret = 0;
@@ -192,7 +176,7 @@ static int trace_probe_nr_files(struct trace_probe *tp)
 	 * Since all tp->files updater is protected by probe_enable_lock,
 	 * we don't need to lock an rcu_read_lock.
 	 */
-	file = rcu_dereference_raw(tp->files);
+	file = rcu_dereference_raw(tp->p.files);
 	if (file)
 		while (*(file++))
 			ret++;
@@ -207,7 +191,7 @@ static DEFINE_MUTEX(probe_enable_lock);
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
  */
 static int
-enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+enable_trace_probe(struct trace_kprobe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
@@ -217,7 +201,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		struct ftrace_event_file **new, **old;
 		int n = trace_probe_nr_files(tp);
 
-		old = rcu_dereference_raw(tp->files);
+		old = rcu_dereference_raw(tp->p.files);
 		/* 1 is for new one and 1 is for stopper */
 		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
 			      GFP_KERNEL);
@@ -229,8 +213,8 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		new[n] = file;
 		/* The last one keeps a NULL */
 
-		rcu_assign_pointer(tp->files, new);
-		tp->flags |= TP_FLAG_TRACE;
+		rcu_assign_pointer(tp->p.files, new);
+		tp->p.flags |= TP_FLAG_TRACE;
 
 		if (old) {
 			/* Make sure the probe is done with old files */
@@ -238,11 +222,11 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 			kfree(old);
 		}
 	} else
-		tp->flags |= TP_FLAG_PROFILE;
+		tp->p.flags |= TP_FLAG_PROFILE;
 
-	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
-	    !trace_probe_has_gone(tp)) {
-		if (trace_probe_is_return(tp))
+	if (trace_probe_is_enabled(&tp->p) && trace_probe_is_registered(&tp->p) &&
+	    !trace_kprobe_has_gone(tp)) {
+		if (trace_kprobe_is_return(tp))
 			ret = enable_kretprobe(&tp->rp);
 		else
 			ret = enable_kprobe(&tp->rp.kp);
@@ -255,7 +239,7 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 }
 
 static int
-trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
+trace_probe_file_index(struct trace_kprobe *tp, struct ftrace_event_file *file)
 {
 	struct ftrace_event_file **files;
 	int i;
@@ -264,7 +248,7 @@ trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
 	 * Since all tp->files updater is protected by probe_enable_lock,
 	 * we don't need to lock an rcu_read_lock.
 	 */
-	files = rcu_dereference_raw(tp->files);
+	files = rcu_dereference_raw(tp->p.files);
 	if (files) {
 		for (i = 0; files[i]; i++)
 			if (files[i] == file)
@@ -279,7 +263,7 @@ trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
  * if the file is NULL, disable "perf" handler, or disable "trace" handler.
  */
 static int
-disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+disable_trace_probe(struct trace_kprobe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
@@ -290,14 +274,14 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		int n = trace_probe_nr_files(tp);
 		int i, j;
 
-		old = rcu_dereference_raw(tp->files);
+		old = rcu_dereference_raw(tp->p.files);
 		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
 
 		if (n == 1) {	/* Remove the last file */
-			tp->flags &= ~TP_FLAG_TRACE;
+			tp->p.flags &= ~TP_FLAG_TRACE;
 			new = NULL;
 		} else {
 			new = kzalloc(n * sizeof(struct ftrace_event_file *),
@@ -313,16 +297,16 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 					new[j++] = old[i];
 		}
 
-		rcu_assign_pointer(tp->files, new);
+		rcu_assign_pointer(tp->p.files, new);
 
 		/* Make sure the probe is done with old files */
 		synchronize_sched();
 		kfree(old);
 	} else
-		tp->flags &= ~TP_FLAG_PROFILE;
+		tp->p.flags &= ~TP_FLAG_PROFILE;
 
-	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
-		if (trace_probe_is_return(tp))
+	if (!trace_probe_is_enabled(&tp->p) && trace_probe_is_registered(&tp->p)) {
+		if (trace_kprobe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
@@ -335,33 +319,33 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 }
 
 /* Internal register function - just handle k*probes and flags */
-static int __register_trace_probe(struct trace_probe *tp)
+static int __register_trace_probe(struct trace_kprobe *tp)
 {
 	int i, ret;
 
-	if (trace_probe_is_registered(tp))
+	if (trace_probe_is_registered(&tp->p))
 		return -EINVAL;
 
-	for (i = 0; i < tp->nr_args; i++)
-		traceprobe_update_arg(&tp->args[i]);
+	for (i = 0; i < tp->p.nr_args; i++)
+		traceprobe_update_arg(&tp->p.args[i]);
 
 	/* Set/clear disabled flag according to tp->flag */
-	if (trace_probe_is_enabled(tp))
+	if (trace_probe_is_enabled(&tp->p))
 		tp->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
 	else
 		tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
 
-	if (trace_probe_is_return(tp))
+	if (trace_kprobe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
 		ret = register_kprobe(&tp->rp.kp);
 
 	if (ret == 0)
-		tp->flags |= TP_FLAG_REGISTERED;
+		tp->p.flags |= TP_FLAG_REGISTERED;
 	else {
 		pr_warning("Could not insert probe at %s+%lu: %d\n",
-			   trace_probe_symbol(tp), trace_probe_offset(tp), ret);
-		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
+			   trace_kprobe_symbol(tp), trace_kprobe_offset(tp), ret);
+		if (ret == -ENOENT && trace_kprobe_is_on_module(tp)) {
 			pr_warning("This probe might be able to register after"
 				   "target module is loaded. Continue.\n");
 			ret = 0;
@@ -377,14 +361,14 @@ static int __register_trace_probe(struct trace_probe *tp)
 }
 
 /* Internal unregister function - just handle k*probes and flags */
-static void __unregister_trace_probe(struct trace_probe *tp)
+static void __unregister_trace_probe(struct trace_kprobe *tp)
 {
-	if (trace_probe_is_registered(tp)) {
-		if (trace_probe_is_return(tp))
+	if (trace_probe_is_registered(&tp->p)) {
+		if (trace_kprobe_is_return(tp))
 			unregister_kretprobe(&tp->rp);
 		else
 			unregister_kprobe(&tp->rp.kp);
-		tp->flags &= ~TP_FLAG_REGISTERED;
+		tp->p.flags &= ~TP_FLAG_REGISTERED;
 		/* Cleanup kprobe for reuse */
 		if (tp->rp.kp.symbol_name)
 			tp->rp.kp.addr = NULL;
@@ -392,10 +376,10 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static int unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_probe(struct trace_kprobe *tp)
 {
 	/* Enabled event can not be unregistered */
-	if (trace_probe_is_enabled(tp))
+	if (trace_probe_is_enabled(&tp->p))
 		return -EBUSY;
 
 	__unregister_trace_probe(tp);
@@ -406,15 +390,15 @@ static int unregister_trace_probe(struct trace_probe *tp)
 }
 
 /* Register a trace_probe and probe_event */
-static int register_trace_probe(struct trace_probe *tp)
+static int register_trace_probe(struct trace_kprobe *tp)
 {
-	struct trace_probe *old_tp;
+	struct trace_kprobe *old_tp;
 	int ret;
 
 	mutex_lock(&probe_lock);
 
 	/* Delete old (same name) event if exist */
-	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
+	old_tp = find_trace_probe(tp->p.call.name, tp->p.call.class->system);
 	if (old_tp) {
 		ret = unregister_trace_probe(old_tp);
 		if (ret < 0)
@@ -446,7 +430,7 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 				       unsigned long val, void *data)
 {
 	struct module *mod = data;
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int ret;
 
 	if (val != MODULE_STATE_COMING)
@@ -455,14 +439,14 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 	/* Update probes on coming module */
 	mutex_lock(&probe_lock);
 	list_for_each_entry(tp, &probe_list, list) {
-		if (trace_probe_within_module(tp, mod)) {
+		if (trace_kprobe_within_module(tp, mod)) {
 			/* Don't need to check busy - this should have gone. */
 			__unregister_trace_probe(tp);
 			ret = __register_trace_probe(tp);
 			if (ret)
 				pr_warning("Failed to re-register probe %s on"
 					   "%s: %d\n",
-					   tp->call.name, mod->name, ret);
+					   tp->p.call.name, mod->name, ret);
 		}
 	}
 	mutex_unlock(&probe_lock);
@@ -495,7 +479,7 @@ static int create_trace_probe(int argc, char **argv)
 	 * Type of args:
 	 *  FETCHARG:TYPE : use TYPE instead of unsigned long.
 	 */
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int i, ret = 0;
 	bool is_return = false, is_delete = false;
 	char *symbol = NULL, *event = NULL, *group = NULL;
@@ -609,36 +593,38 @@ static int create_trace_probe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		struct probe_arg *parg = &tp->p.args[i];
+
 		/* Increment count for freeing args in error case */
-		tp->nr_args++;
+		tp->p.nr_args++;
 
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
 		if (arg) {
 			*arg++ = '\0';
-			tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+			parg->name = kstrdup(argv[i], GFP_KERNEL);
 		} else {
 			arg = argv[i];
 			/* If argument name is omitted, set "argN" */
 			snprintf(buf, MAX_EVENT_NAME_LEN, "arg%d", i + 1);
-			tp->args[i].name = kstrdup(buf, GFP_KERNEL);
+			parg->name = kstrdup(buf, GFP_KERNEL);
 		}
 
-		if (!tp->args[i].name) {
+		if (!parg->name) {
 			pr_info("Failed to allocate argument[%d] name.\n", i);
 			ret = -ENOMEM;
 			goto error;
 		}
 
-		if (!is_good_name(tp->args[i].name)) {
+		if (!is_good_name(parg->name)) {
 			pr_info("Invalid argument[%d] name: %s\n",
-				i, tp->args[i].name);
+				i, parg->name);
 			ret = -EINVAL;
 			goto error;
 		}
 
-		if (traceprobe_conflict_field_name(tp->args[i].name,
-							tp->args, i)) {
+		if (traceprobe_conflict_field_name(parg->name,
+							tp->p.args, i)) {
 			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -646,7 +632,7 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
+		ret = traceprobe_parse_probe_arg(arg, &tp->p.size, parg,
 						is_return, true);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
@@ -666,19 +652,19 @@ error:
 
 static int release_all_trace_probes(void)
 {
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int ret = 0;
 
 	mutex_lock(&probe_lock);
 	/* Ensure no probe is in use. */
 	list_for_each_entry(tp, &probe_list, list)
-		if (trace_probe_is_enabled(tp)) {
+		if (trace_probe_is_enabled(&tp->p)) {
 			ret = -EBUSY;
 			goto end;
 		}
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
-		tp = list_entry(probe_list.next, struct trace_probe, list);
+		tp = list_entry(probe_list.next, struct trace_kprobe, list);
 		unregister_trace_probe(tp);
 		free_trace_probe(tp);
 	}
@@ -708,22 +694,22 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 
 static int probes_seq_show(struct seq_file *m, void *v)
 {
-	struct trace_probe *tp = v;
+	struct trace_kprobe *tp = v;
 	int i;
 
-	seq_printf(m, "%c", trace_probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
+	seq_printf(m, "%c", trace_kprobe_is_return(tp) ? 'r' : 'p');
+	seq_printf(m, ":%s/%s", tp->p.call.class->system, tp->p.call.name);
 
 	if (!tp->symbol)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
 	else if (tp->rp.kp.offset)
-		seq_printf(m, " %s+%u", trace_probe_symbol(tp),
+		seq_printf(m, " %s+%u", trace_kprobe_symbol(tp),
 			   tp->rp.kp.offset);
 	else
-		seq_printf(m, " %s", trace_probe_symbol(tp));
+		seq_printf(m, " %s", trace_kprobe_symbol(tp));
 
-	for (i = 0; i < tp->nr_args; i++)
-		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
+	for (i = 0; i < tp->p.nr_args; i++)
+		seq_printf(m, " %s=%s", tp->p.args[i].name, tp->p.args[i].comm);
 	seq_printf(m, "\n");
 
 	return 0;
@@ -768,9 +754,9 @@ static const struct file_operations kprobe_events_ops = {
 /* Probes profiling interfaces */
 static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
-	struct trace_probe *tp = v;
+	struct trace_kprobe *tp = v;
 
-	seq_printf(m, "  %-44s %15lu %15lu\n", tp->call.name, tp->nhit,
+	seq_printf(m, "  %-44s %15lu %15lu\n", tp->p.call.name, tp->nhit,
 		   tp->rp.kp.nmissed);
 
 	return 0;
@@ -956,7 +942,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 
 /* Kprobe handler */
 static __kprobes void
-__kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
+__kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 		    struct ftrace_event_file *ftrace_file)
 {
 	struct kprobe_trace_entry_head *entry;
@@ -964,7 +950,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
@@ -974,8 +960,8 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -985,7 +971,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = (unsigned long)tp->rp.kp.addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -993,14 +979,14 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 }
 
 static __kprobes void
-kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs)
 {
 	/*
 	 * Note: preempt is already disabled around the kprobe handler.
 	 * However, we still need an smp_read_barrier_depends() corresponding
 	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
 	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
+	struct ftrace_event_file **file = rcu_dereference_raw(tp->p.files);
 
 	if (unlikely(!file))
 		return;
@@ -1013,7 +999,7 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 
 /* Kretprobe handler */
 static __kprobes void
-__kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+__kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 		       struct pt_regs *regs,
 		       struct ftrace_event_file *ftrace_file)
 {
@@ -1022,7 +1008,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
@@ -1032,8 +1018,8 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -1044,7 +1030,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry = ring_buffer_event_data(event);
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -1052,7 +1038,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 }
 
 static __kprobes void
-kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
 	/*
@@ -1060,7 +1046,7 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	 * However, we still need an smp_read_barrier_depends() corresponding
 	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
 	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
+	struct ftrace_event_file **file = rcu_dereference_raw(tp->p.files);
 
 	if (unlikely(!file))
 		return;
@@ -1155,16 +1141,18 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kprobe_trace_entry_head field;
-	struct trace_probe *tp = (struct trace_probe *)event_call->data;
+	struct trace_kprobe *tp = (struct trace_kprobe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
-					 tp->args[i].name,
-					 sizeof(field) + tp->args[i].offset,
-					 tp->args[i].type->size,
-					 tp->args[i].type->is_signed,
+	for (i = 0; i < tp->p.nr_args; i++) {
+		struct probe_arg *parg = &tp->p.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name,
+					 sizeof(field) + parg->offset,
+					 parg->type->size,
+					 parg->type->is_signed,
 					 FILTER_OTHER);
 		if (ret)
 			return ret;
@@ -1176,17 +1164,19 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kretprobe_trace_entry_head field;
-	struct trace_probe *tp = (struct trace_probe *)event_call->data;
+	struct trace_kprobe *tp = (struct trace_kprobe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
-					 tp->args[i].name,
-					 sizeof(field) + tp->args[i].offset,
-					 tp->args[i].type->size,
-					 tp->args[i].type->is_signed,
+	for (i = 0; i < tp->p.nr_args; i++) {
+		struct probe_arg *parg = &tp->p.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name,
+					 sizeof(field) + parg->offset,
+					 parg->type->size,
+					 parg->type->is_signed,
 					 FILTER_OTHER);
 		if (ret)
 			return ret;
@@ -1194,14 +1184,14 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
+static int __set_print_fmt(struct trace_kprobe *tp, char *buf, int len)
 {
 	int i;
 	int pos = 0;
 
 	const char *fmt, *arg;
 
-	if (!trace_probe_is_return(tp)) {
+	if (!trace_kprobe_is_return(tp)) {
 		fmt = "(%lx)";
 		arg = "REC->" FIELD_STRING_IP;
 	} else {
@@ -1214,21 +1204,21 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
 
-	for (i = 0; i < tp->nr_args; i++) {
+	for (i = 0; i < tp->p.nr_args; i++) {
 		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tp->args[i].name, tp->args[i].type->fmt);
+				tp->p.args[i].name, tp->p.args[i].type->fmt);
 	}
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
 
-	for (i = 0; i < tp->nr_args; i++) {
-		if (strcmp(tp->args[i].type->name, "string") == 0)
+	for (i = 0; i < tp->p.nr_args; i++) {
+		if (strcmp(tp->p.args[i].type->name, "string") == 0)
 			pos += snprintf(buf + pos, LEN_OR_ZERO,
 					", __get_str(%s)",
-					tp->args[i].name);
+					tp->p.args[i].name);
 		else
 			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-					tp->args[i].name);
+					tp->p.args[i].name);
 	}
 
 #undef LEN_OR_ZERO
@@ -1237,7 +1227,7 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 	return pos;
 }
 
-static int set_print_fmt(struct trace_probe *tp)
+static int set_print_fmt(struct trace_kprobe *tp)
 {
 	int len;
 	char *print_fmt;
@@ -1250,7 +1240,7 @@ static int set_print_fmt(struct trace_probe *tp)
 
 	/* Second: actually write the @print_fmt */
 	__set_print_fmt(tp, print_fmt, len + 1);
-	tp->call.print_fmt = print_fmt;
+	tp->p.call.print_fmt = print_fmt;
 
 	return 0;
 }
@@ -1259,16 +1249,16 @@ static int set_print_fmt(struct trace_probe *tp)
 
 /* Kprobe profile handler */
 static __kprobes void
-kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
+kprobe_perf_func(struct trace_kprobe *tp, struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 	struct kprobe_trace_entry_head *entry;
 	struct hlist_head *head;
 	int size, __size, dsize;
 	int rctx;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1281,7 +1271,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
@@ -1290,17 +1280,17 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 
 /* Kretprobe profile handler */
 static __kprobes void
-kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+kretprobe_perf_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 		    struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 	struct kretprobe_trace_entry_head *entry;
 	struct hlist_head *head;
 	int size, __size, dsize;
 	int rctx;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1313,7 +1303,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
@@ -1325,7 +1315,7 @@ static __kprobes
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
-	struct trace_probe *tp = (struct trace_probe *)event->data;
+	struct trace_kprobe *tp = (struct trace_kprobe *)event->data;
 	struct ftrace_event_file *file = data;
 
 	switch (type) {
@@ -1352,14 +1342,14 @@ int kprobe_register(struct ftrace_event_call *event,
 static __kprobes
 int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
+	struct trace_kprobe *tp = container_of(kp, struct trace_kprobe, rp.kp);
 
 	tp->nhit++;
 
-	if (tp->flags & TP_FLAG_TRACE)
+	if (tp->p.flags & TP_FLAG_TRACE)
 		kprobe_trace_func(tp, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (tp->flags & TP_FLAG_PROFILE)
+	if (tp->p.flags & TP_FLAG_PROFILE)
 		kprobe_perf_func(tp, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
@@ -1368,14 +1358,14 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 static __kprobes
 int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+	struct trace_kprobe *tp = container_of(ri->rp, struct trace_kprobe, rp);
 
 	tp->nhit++;
 
-	if (tp->flags & TP_FLAG_TRACE)
+	if (tp->p.flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(tp, ri, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (tp->flags & TP_FLAG_PROFILE)
+	if (tp->p.flags & TP_FLAG_PROFILE)
 		kretprobe_perf_func(tp, ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
@@ -1389,14 +1379,14 @@ static struct trace_event_functions kprobe_funcs = {
 	.trace		= print_kprobe_event
 };
 
-static int register_probe_event(struct trace_probe *tp)
+static int register_probe_event(struct trace_kprobe *tp)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 	int ret;
 
 	/* Initialize ftrace_event_call */
 	INIT_LIST_HEAD(&call->class->fields);
-	if (trace_probe_is_return(tp)) {
+	if (trace_kprobe_is_return(tp)) {
 		call->event.funcs = &kretprobe_funcs;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
@@ -1422,11 +1412,11 @@ static int register_probe_event(struct trace_probe *tp)
 	return ret;
 }
 
-static void unregister_probe_event(struct trace_probe *tp)
+static void unregister_probe_event(struct trace_kprobe *tp)
 {
 	/* tp->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tp->call);
-	kfree(tp->call.print_fmt);
+	trace_remove_event_call(&tp->p.call);
+	kfree(tp->p.call.print_fmt);
 }
 
 /* Make a debugfs interface for controlling probe points */
@@ -1475,12 +1465,12 @@ static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
 }
 
 static struct ftrace_event_file *
-find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
+find_trace_probe_file(struct trace_kprobe *tp, struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
 
 	list_for_each_entry(file, &tr->events, list)
-		if (file->event_call == &tp->call)
+		if (file->event_call == &tp->p.call)
 			return file;
 
 	return NULL;
@@ -1490,7 +1480,7 @@ static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
 	int (*target)(int, int, int, int, int, int);
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	struct ftrace_event_file *file;
 
 	target = kprobe_trace_selftest_target;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 50f152eb7ef0..4563e0befa01 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -159,6 +159,26 @@ struct probe_arg {
 	const struct fetch_type	*type;	/* Type of this argument */
 };
 
+struct trace_probe {
+	unsigned int			flags;	/* For TP_FLAG_* */
+	struct ftrace_event_class	class;
+	struct ftrace_event_call	call;
+	struct ftrace_event_file * __rcu *files;
+	ssize_t				size;	/* trace entry size */
+	unsigned int			nr_args;
+	struct probe_arg		args[];
+};
+
+static inline bool trace_probe_is_enabled(struct trace_probe *tp)
+{
+	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
+}
+
+static inline bool trace_probe_is_registered(struct trace_probe *tp)
+{
+	return !!(tp->flags & TP_FLAG_REGISTERED);
+}
+
 #define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 
 #define DECLARE_FETCH_FUNC(method, type)				\
-- 
1.7.11.7

