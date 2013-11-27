Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3K0GUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:20:18 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50663 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K0GUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:09 -0500
X-AuditID: 9c930197-b7caaae000001cef-a8-52958f16a183
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 03/17] tracing/kprobes: Factor out struct trace_probe
Date: Wed, 27 Nov 2013 15:19:49 +0900
Message-Id: <1385533203-10014-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There are functions that can be shared to both of kprobes and uprobes.
Separate common data structure to struct trace_probe and use it from
the shared functions.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 396 +++++++++++++++++++++-----------------------
 kernel/trace/trace_probe.h  |  20 +++
 2 files changed, 213 insertions(+), 203 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index dae9541ada9e..72b76e1f2d34 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,18 +27,12 @@
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
-	struct list_head	files;
-	ssize_t			size;		/* trace entry size */
-	unsigned int		nr_args;
-	struct probe_arg	args[];
+	struct trace_probe	p;
 };
 
 struct event_file_link {
@@ -46,56 +40,46 @@ struct event_file_link {
 	struct list_head		list;
 };
 
-#define SIZEOF_TRACE_PROBE(n)			\
-	(offsetof(struct trace_probe, args) +	\
+#define SIZEOF_TRACE_PROBE(n)				\
+	(offsetof(struct trace_kprobe, p.args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_is_return(struct trace_kprobe *tk)
 {
-	return tp->rp.handler != NULL;
+	return tk->rp.handler != NULL;
 }
 
-static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
+static __kprobes const char *trace_kprobe_symbol(struct trace_kprobe *tk)
 {
-	return tp->symbol ? tp->symbol : "unknown";
+	return tk->symbol ? tk->symbol : "unknown";
 }
 
-static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
+static __kprobes unsigned long trace_kprobe_offset(struct trace_kprobe *tk)
 {
-	return tp->rp.kp.offset;
+	return tk->rp.kp.offset;
 }
 
-static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_has_gone(struct trace_kprobe *tk)
 {
-	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
+	return !!(kprobe_gone(&tk->rp.kp));
 }
 
-static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
-{
-	return !!(tp->flags & TP_FLAG_REGISTERED);
-}
-
-static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
-{
-	return !!(kprobe_gone(&tp->rp.kp));
-}
-
-static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
-						struct module *mod)
+static __kprobes bool trace_kprobe_within_module(struct trace_kprobe *tk,
+						 struct module *mod)
 {
 	int len = strlen(mod->name);
-	const char *name = trace_probe_symbol(tp);
+	const char *name = trace_kprobe_symbol(tk);
 	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
 }
 
-static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
+static __kprobes bool trace_kprobe_is_on_module(struct trace_kprobe *tk)
 {
-	return !!strchr(trace_probe_symbol(tp), ':');
+	return !!strchr(trace_kprobe_symbol(tk), ':');
 }
 
-static int register_probe_event(struct trace_probe *tp);
-static int unregister_probe_event(struct trace_probe *tp);
+static int register_kprobe_event(struct trace_kprobe *tk);
+static int unregister_kprobe_event(struct trace_kprobe *tk);
 
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
@@ -107,14 +91,14 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
-static struct trace_probe *alloc_trace_probe(const char *group,
+static struct trace_kprobe *alloc_trace_kprobe(const char *group,
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
@@ -140,9 +124,9 @@ static struct trace_probe *alloc_trace_probe(const char *group,
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
@@ -150,41 +134,41 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->class.system = kstrdup(group, GFP_KERNEL);
-	if (!tp->class.system)
+	tp->p.class.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->p.class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
-	INIT_LIST_HEAD(&tp->files);
+	INIT_LIST_HEAD(&tp->p.files);
 	return tp;
 error:
-	kfree(tp->call.name);
+	kfree(tp->p.call.name);
 	kfree(tp->symbol);
 	kfree(tp);
 	return ERR_PTR(ret);
 }
 
-static void free_trace_probe(struct trace_probe *tp)
+static void free_trace_kprobe(struct trace_kprobe *tp)
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
+static struct trace_kprobe *find_trace_kprobe(const char *event,
+					      const char *group)
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
@@ -194,7 +178,7 @@ static struct trace_probe *find_trace_probe(const char *event,
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
  */
 static int
-enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+enable_trace_kprobe(struct trace_kprobe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
@@ -208,14 +192,14 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		}
 
 		link->file = file;
-		list_add_tail_rcu(&link->list, &tp->files);
+		list_add_tail_rcu(&link->list, &tp->p.files);
 
-		tp->flags |= TP_FLAG_TRACE;
+		tp->p.flags |= TP_FLAG_TRACE;
 	} else
-		tp->flags |= TP_FLAG_PROFILE;
+		tp->p.flags |= TP_FLAG_PROFILE;
 
-	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
-		if (trace_probe_is_return(tp))
+	if (trace_probe_is_registered(&tp->p) && !trace_kprobe_has_gone(tp)) {
+		if (trace_kprobe_is_return(tp))
 			ret = enable_kretprobe(&tp->rp);
 		else
 			ret = enable_kprobe(&tp->rp.kp);
@@ -241,14 +225,14 @@ find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
  * if the file is NULL, disable "perf" handler, or disable "trace" handler.
  */
 static int
-disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+disable_trace_kprobe(struct trace_kprobe *tp, struct ftrace_event_file *file)
 {
 	struct event_file_link *link = NULL;
 	int wait = 0;
 	int ret = 0;
 
 	if (file) {
-		link = find_event_file_link(tp, file);
+		link = find_event_file_link(&tp->p, file);
 		if (!link) {
 			ret = -EINVAL;
 			goto out;
@@ -256,15 +240,15 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 
 		list_del_rcu(&link->list);
 		wait = 1;
-		if (!list_empty(&tp->files))
+		if (!list_empty(&tp->p.files))
 			goto out;
 
-		tp->flags &= ~TP_FLAG_TRACE;
+		tp->p.flags &= ~TP_FLAG_TRACE;
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
@@ -288,33 +272,33 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 }
 
 /* Internal register function - just handle k*probes and flags */
-static int __register_trace_probe(struct trace_probe *tp)
+static int __register_trace_kprobe(struct trace_kprobe *tp)
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
@@ -330,14 +314,14 @@ static int __register_trace_probe(struct trace_probe *tp)
 }
 
 /* Internal unregister function - just handle k*probes and flags */
-static void __unregister_trace_probe(struct trace_probe *tp)
+static void __unregister_trace_kprobe(struct trace_kprobe *tp)
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
@@ -345,50 +329,50 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static int unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_kprobe(struct trace_kprobe *tp)
 {
 	/* Enabled event can not be unregistered */
-	if (trace_probe_is_enabled(tp))
+	if (trace_probe_is_enabled(&tp->p))
 		return -EBUSY;
 
 	/* Will fail if probe is being used by ftrace or perf */
-	if (unregister_probe_event(tp))
+	if (unregister_kprobe_event(tp))
 		return -EBUSY;
 
-	__unregister_trace_probe(tp);
+	__unregister_trace_kprobe(tp);
 	list_del(&tp->list);
 
 	return 0;
 }
 
 /* Register a trace_probe and probe_event */
-static int register_trace_probe(struct trace_probe *tp)
+static int register_trace_kprobe(struct trace_kprobe *tp)
 {
-	struct trace_probe *old_tp;
+	struct trace_kprobe *old_tp;
 	int ret;
 
 	mutex_lock(&probe_lock);
 
 	/* Delete old (same name) event if exist */
-	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
+	old_tp = find_trace_kprobe(tp->p.call.name, tp->p.call.class->system);
 	if (old_tp) {
-		ret = unregister_trace_probe(old_tp);
+		ret = unregister_trace_kprobe(old_tp);
 		if (ret < 0)
 			goto end;
-		free_trace_probe(old_tp);
+		free_trace_kprobe(old_tp);
 	}
 
 	/* Register new event */
-	ret = register_probe_event(tp);
+	ret = register_kprobe_event(tp);
 	if (ret) {
 		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
 	/* Register k*probe */
-	ret = __register_trace_probe(tp);
+	ret = __register_trace_kprobe(tp);
 	if (ret < 0)
-		unregister_probe_event(tp);
+		unregister_kprobe_event(tp);
 	else
 		list_add_tail(&tp->list, &probe_list);
 
@@ -398,11 +382,11 @@ end:
 }
 
 /* Module notifier call back, checking event on the module */
-static int trace_probe_module_callback(struct notifier_block *nb,
+static int trace_kprobe_module_callback(struct notifier_block *nb,
 				       unsigned long val, void *data)
 {
 	struct module *mod = data;
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int ret;
 
 	if (val != MODULE_STATE_COMING)
@@ -411,14 +395,14 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 	/* Update probes on coming module */
 	mutex_lock(&probe_lock);
 	list_for_each_entry(tp, &probe_list, list) {
-		if (trace_probe_within_module(tp, mod)) {
+		if (trace_kprobe_within_module(tp, mod)) {
 			/* Don't need to check busy - this should have gone. */
-			__unregister_trace_probe(tp);
-			ret = __register_trace_probe(tp);
+			__unregister_trace_kprobe(tp);
+			ret = __register_trace_kprobe(tp);
 			if (ret)
 				pr_warning("Failed to re-register probe %s on"
 					   "%s: %d\n",
-					   tp->call.name, mod->name, ret);
+					   tp->p.call.name, mod->name, ret);
 		}
 	}
 	mutex_unlock(&probe_lock);
@@ -426,12 +410,12 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block trace_probe_module_nb = {
-	.notifier_call = trace_probe_module_callback,
+static struct notifier_block trace_kprobe_module_nb = {
+	.notifier_call = trace_kprobe_module_callback,
 	.priority = 1	/* Invoked after kprobe module callback */
 };
 
-static int create_trace_probe(int argc, char **argv)
+static int create_trace_kprobe(int argc, char **argv)
 {
 	/*
 	 * Argument syntax:
@@ -451,7 +435,7 @@ static int create_trace_probe(int argc, char **argv)
 	 * Type of args:
 	 *  FETCHARG:TYPE : use TYPE instead of unsigned long.
 	 */
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	int i, ret = 0;
 	bool is_return = false, is_delete = false;
 	char *symbol = NULL, *event = NULL, *group = NULL;
@@ -498,16 +482,16 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		mutex_lock(&probe_lock);
-		tp = find_trace_probe(event, group);
+		tp = find_trace_kprobe(event, group);
 		if (!tp) {
 			mutex_unlock(&probe_lock);
 			pr_info("Event %s/%s doesn't exist.\n", group, event);
 			return -ENOENT;
 		}
 		/* delete an event */
-		ret = unregister_trace_probe(tp);
+		ret = unregister_trace_kprobe(tp);
 		if (ret == 0)
-			free_trace_probe(tp);
+			free_trace_kprobe(tp);
 		mutex_unlock(&probe_lock);
 		return ret;
 	}
@@ -554,7 +538,7 @@ static int create_trace_probe(int argc, char **argv)
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}
-	tp = alloc_trace_probe(group, event, addr, symbol, offset, argc,
+	tp = alloc_trace_kprobe(group, event, addr, symbol, offset, argc,
 			       is_return);
 	if (IS_ERR(tp)) {
 		pr_info("Failed to allocate trace_probe.(%d)\n",
@@ -565,36 +549,38 @@ static int create_trace_probe(int argc, char **argv)
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
@@ -602,7 +588,7 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
+		ret = traceprobe_parse_probe_arg(arg, &tp->p.size, parg,
 						is_return, true);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
@@ -610,35 +596,35 @@ static int create_trace_probe(int argc, char **argv)
 		}
 	}
 
-	ret = register_trace_probe(tp);
+	ret = register_trace_kprobe(tp);
 	if (ret)
 		goto error;
 	return 0;
 
 error:
-	free_trace_probe(tp);
+	free_trace_kprobe(tp);
 	return ret;
 }
 
-static int release_all_trace_probes(void)
+static int release_all_trace_kprobes(void)
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
-		ret = unregister_trace_probe(tp);
+		tp = list_entry(probe_list.next, struct trace_kprobe, list);
+		ret = unregister_trace_kprobe(tp);
 		if (ret)
 			goto end;
-		free_trace_probe(tp);
+		free_trace_kprobe(tp);
 	}
 
 end:
@@ -666,22 +652,22 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 
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
@@ -699,7 +685,7 @@ static int probes_open(struct inode *inode, struct file *file)
 	int ret;
 
 	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
-		ret = release_all_trace_probes();
+		ret = release_all_trace_kprobes();
 		if (ret < 0)
 			return ret;
 	}
@@ -711,7 +697,7 @@ static ssize_t probes_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
 	return traceprobe_probes_write(file, buffer, count, ppos,
-			create_trace_probe);
+			create_trace_kprobe);
 }
 
 static const struct file_operations kprobe_events_ops = {
@@ -726,9 +712,9 @@ static const struct file_operations kprobe_events_ops = {
 /* Probes profiling interfaces */
 static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
-	struct trace_probe *tp = v;
+	struct trace_kprobe *tp = v;
 
-	seq_printf(m, "  %-44s %15lu %15lu\n", tp->call.name, tp->nhit,
+	seq_printf(m, "  %-44s %15lu %15lu\n", tp->p.call.name, tp->nhit,
 		   tp->rp.kp.nmissed);
 
 	return 0;
@@ -804,7 +790,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 
 /* Kprobe handler */
 static __kprobes void
-__kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
+__kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 		    struct ftrace_event_file *ftrace_file)
 {
 	struct kprobe_trace_entry_head *entry;
@@ -812,7 +798,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
@@ -822,8 +808,8 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -833,7 +819,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = (unsigned long)tp->rp.kp.addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -841,17 +827,17 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 }
 
 static __kprobes void
-kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs)
 {
 	struct event_file_link *link;
 
-	list_for_each_entry_rcu(link, &tp->files, list)
+	list_for_each_entry_rcu(link, &tp->p.files, list)
 		__kprobe_trace_func(tp, regs, link->file);
 }
 
 /* Kretprobe handler */
 static __kprobes void
-__kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+__kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 		       struct pt_regs *regs,
 		       struct ftrace_event_file *ftrace_file)
 {
@@ -860,7 +846,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tp->p.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
@@ -870,8 +856,8 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -882,7 +868,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry = ring_buffer_event_data(event);
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_check_discard(ftrace_file, entry, buffer, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -890,12 +876,12 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 }
 
 static __kprobes void
-kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
 	struct event_file_link *link;
 
-	list_for_each_entry_rcu(link, &tp->files, list)
+	list_for_each_entry_rcu(link, &tp->p.files, list)
 		__kretprobe_trace_func(tp, ri, regs, link->file);
 }
 
@@ -983,16 +969,18 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
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
@@ -1004,17 +992,19 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
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
@@ -1022,14 +1012,14 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
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
@@ -1042,21 +1032,21 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 
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
@@ -1065,7 +1055,7 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 	return pos;
 }
 
-static int set_print_fmt(struct trace_probe *tp)
+static int set_print_fmt(struct trace_kprobe *tp)
 {
 	int len;
 	char *print_fmt;
@@ -1078,7 +1068,7 @@ static int set_print_fmt(struct trace_probe *tp)
 
 	/* Second: actually write the @print_fmt */
 	__set_print_fmt(tp, print_fmt, len + 1);
-	tp->call.print_fmt = print_fmt;
+	tp->p.call.print_fmt = print_fmt;
 
 	return 0;
 }
@@ -1087,9 +1077,9 @@ static int set_print_fmt(struct trace_probe *tp)
 
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
@@ -1099,8 +1089,8 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
@@ -1110,16 +1100,16 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 
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
@@ -1129,8 +1119,8 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tp->p, regs);
+	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
@@ -1140,7 +1130,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
@@ -1155,20 +1145,20 @@ static __kprobes
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
-	struct trace_probe *tp = (struct trace_probe *)event->data;
+	struct trace_kprobe *tp = (struct trace_kprobe *)event->data;
 	struct ftrace_event_file *file = data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return enable_trace_probe(tp, file);
+		return enable_trace_kprobe(tp, file);
 	case TRACE_REG_UNREGISTER:
-		return disable_trace_probe(tp, file);
+		return disable_trace_kprobe(tp, file);
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return enable_trace_probe(tp, NULL);
+		return enable_trace_kprobe(tp, NULL);
 	case TRACE_REG_PERF_UNREGISTER:
-		return disable_trace_probe(tp, NULL);
+		return disable_trace_kprobe(tp, NULL);
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
 	case TRACE_REG_PERF_ADD:
@@ -1182,14 +1172,14 @@ int kprobe_register(struct ftrace_event_call *event,
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
@@ -1198,14 +1188,14 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
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
@@ -1219,14 +1209,14 @@ static struct trace_event_functions kprobe_funcs = {
 	.trace		= print_kprobe_event
 };
 
-static int register_probe_event(struct trace_probe *tp)
+static int register_kprobe_event(struct trace_kprobe *tp)
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
@@ -1252,14 +1242,14 @@ static int register_probe_event(struct trace_probe *tp)
 	return ret;
 }
 
-static int unregister_probe_event(struct trace_probe *tp)
+static int unregister_kprobe_event(struct trace_kprobe *tp)
 {
 	int ret;
 
 	/* tp->event is unregistered in trace_remove_event_call() */
-	ret = trace_remove_event_call(&tp->call);
+	ret = trace_remove_event_call(&tp->p.call);
 	if (!ret)
-		kfree(tp->call.print_fmt);
+		kfree(tp->p.call.print_fmt);
 	return ret;
 }
 
@@ -1269,7 +1259,7 @@ static __init int init_kprobe_trace(void)
 	struct dentry *d_tracer;
 	struct dentry *entry;
 
-	if (register_module_notifier(&trace_probe_module_nb))
+	if (register_module_notifier(&trace_kprobe_module_nb))
 		return -EINVAL;
 
 	d_tracer = tracing_init_dentry();
@@ -1309,12 +1299,12 @@ static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
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
@@ -1328,7 +1318,7 @@ static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
 	int (*target)(int, int, int, int, int, int);
-	struct trace_probe *tp;
+	struct trace_kprobe *tp;
 	struct ftrace_event_file *file;
 
 	target = kprobe_trace_selftest_target;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5c7e09d10d74..984e91ed8a44 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -124,6 +124,26 @@ struct probe_arg {
 	const struct fetch_type	*type;	/* Type of this argument */
 };
 
+struct trace_probe {
+	unsigned int			flags;	/* For TP_FLAG_* */
+	struct ftrace_event_class	class;
+	struct ftrace_event_call	call;
+	struct list_head 		files;
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
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest)
 {
-- 
1.7.11.7

