Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3EPLvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:51:44 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50731 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3EPLvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:51:40 -0400
X-AuditID: 85900ec0-d4ccab900000151e-07-5194c8484152
Subject: [PATCH 5/5] tracing: Support enable/disable multiple events trigger
 by wild cards
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 16 May 2013 20:49:00 +0900
Message-ID: <20130516114900.13508.29247.stgit@mhiramat-M0-7522>
In-Reply-To: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support enable/disable multiple events trigger on ftrace
by using wild cards. This makes enabling multiple events
at once easy.

e.g.)
 # echo vfs_symlink:enable_event:\*:\*rq\* > set_ftrace_filter

 # cat set_ftrace_filter
#### all functions enabled ####
vfs_symlink:enable_event:*:*rq*:unlimited

 # grep 0\\* -r events/*/*/enable
events/block/block_getrq/enable:0*
events/block/block_rq_abort/enable:0*
events/block/block_rq_complete/enable:0*
events/block/block_rq_insert/enable:0*
events/block/block_rq_issue/enable:0*
events/block/block_rq_remap/enable:0*
events/block/block_rq_requeue/enable:0*
events/block/block_sleeprq/enable:0*
events/irq/irq_handler_entry/enable:0*
events/irq/irq_handler_exit/enable:0*
events/irq/softirq_entry/enable:0*
events/irq/softirq_exit/enable:0*
events/irq/softirq_raise/enable:0*

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 Documentation/trace/ftrace.txt |   12 ++--
 kernel/trace/trace_events.c    |  123 +++++++++++++++++++++++++++++-----------
 2 files changed, 95 insertions(+), 40 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bfe8c29..92ca5236 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2407,11 +2407,11 @@ The following commands are supported:
    echo '!native_flush_tlb_others:snapshot:0' > set_ftrace_filter
 
 - enable_event/disable_event
-  These commands can enable or disable a trace event. Note, because
+  These commands can enable or disable trace events. Note, because
   function tracing callbacks are very sensitive, when these commands
-  are registered, the trace point is activated, but disabled in
-  a "soft" mode. That is, the tracepoint will be called, but
-  just will not be traced. The event tracepoint stays in this mode
+  are registered, the tracepoints are activated, but disabled in
+  a "soft" mode. That is, the tracepoints will be called, but
+  just will not be traced. The event tracepoints stay in this mode
   as long as there's a command that triggers it.
 
    echo 'try_to_wake_up:enable_event:sched:sched_switch:2' > \
@@ -2422,8 +2422,10 @@ The following commands are supported:
     <function>:enable_event:<system>:<event>[:count]
     <function>:disable_event:<system>:<event>[:count]
 
-  To remove the events commands:
+  Note that the system and event accept wildcards for operating
+  multiple events at once.
 
+  To remove the events commands:
 
    echo '!try_to_wake_up:enable_event:sched:sched_switch:0' > \
    	 set_ftrace_filter
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..1376bb4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1850,17 +1850,21 @@ __trace_add_event_dirs(struct trace_array *tr)
 #define DISABLE_EVENT_STR	"disable_event"
 
 struct event_probe_data {
-	struct ftrace_event_file	*file;
+	struct ftrace_event_file	**files;
+	char				*event;
+	char				*system;
 	unsigned long			count;
 	int				ref;
 	bool				enable;
 };
 
-static struct ftrace_event_file *
-find_event_file(struct trace_array *tr, const char *system,  const char *event)
+static int
+find_event_files(struct trace_array *tr, const char *system, const char *event,
+		 struct ftrace_event_file **files, int size)
 {
 	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
+	int nr = 0;
 
 	list_for_each_entry(file, &tr->events, list) {
 
@@ -1872,11 +1876,14 @@ find_event_file(struct trace_array *tr, const char *system,  const char *event)
 		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
 			continue;
 
-		if (strcmp(event, call->name) == 0 &&
-		    strcmp(system, call->class->system) == 0)
-			return file;
+		if (strglobmatch(event, call->name) &&
+		    strglobmatch(system, call->class->system)) {
+			if (files && nr < size)
+				files[nr] = file;
+			nr++;
+		}
 	}
-	return NULL;
+	return nr;
 }
 
 static void
@@ -1884,14 +1891,24 @@ event_enable_probe(unsigned long ip, unsigned long parent_ip, void **_data)
 {
 	struct event_probe_data **pdata = (struct event_probe_data **)_data;
 	struct event_probe_data *data = *pdata;
+	struct ftrace_event_file **file;
 
 	if (!data)
 		return;
 
-	if (data->enable)
-		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
-	else
-		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
+	file = data->files;
+	if (unlikely(!file))
+		return;
+
+	while (*file) {
+		if (data->enable)
+			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+				  &(*file)->flags);
+		else
+			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+				  &(*file)->flags);
+		file++;
+	}
 }
 
 static void
@@ -1906,10 +1923,6 @@ event_enable_count_probe(unsigned long ip, unsigned long parent_ip, void **_data
 	if (!data->count)
 		return;
 
-	/* Skip if the event is in a state we want to switch to */
-	if (data->enable == !(data->file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
-		return;
-
 	if (data->count != -1)
 		(data->count)--;
 
@@ -1926,8 +1939,7 @@ event_enable_print(struct seq_file *m, unsigned long ip,
 
 	seq_printf(m, "%s:%s:%s",
 		   data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
-		   data->file->event_call->class->system,
-		   data->file->event_call->name);
+		   data->system, data->event);
 
 	if (data->count == -1)
 		seq_printf(m, ":unlimited\n");
@@ -1948,6 +1960,40 @@ event_enable_init(struct ftrace_probe_ops *ops, unsigned long ip,
 	return 0;
 }
 
+static int event_files_soft_mode(struct ftrace_event_file **files, int enable)
+{
+	struct ftrace_event_file **file = files;
+
+	if (!file)
+		return -EINVAL;
+
+	while (*file) {
+		/* Don't let event modules unload while probe registered */
+		if (enable) {
+			if (!try_module_get((*file)->event_call->mod))
+				goto rollback;
+		}
+
+		__ftrace_event_enable_disable(*file, enable, 1);
+
+		if (!enable)
+			module_put((*file)->event_call->mod);
+
+		file++;
+	}
+
+	return 0;
+
+ rollback:
+	while (file != files) {
+		file--;
+		__ftrace_event_enable_disable(*file, 0, 1);
+		module_put((*file)->event_call->mod);
+	}
+
+	return -EBUSY;
+}
+
 static void
 event_enable_free(struct ftrace_probe_ops *ops, unsigned long ip,
 		  void **_data)
@@ -1960,9 +2006,11 @@ event_enable_free(struct ftrace_probe_ops *ops, unsigned long ip,
 
 	data->ref--;
 	if (!data->ref) {
-		/* Remove the SOFT_MODE flag */
-		__ftrace_event_enable_disable(data->file, 0, 1);
-		module_put(data->file->event_call->mod);
+		/* We don't need wait rcu because no one refers data here */
+		event_files_soft_mode(data->files, 0);
+		kfree(data->files);
+		kfree(data->event);
+		kfree(data->system);
 		kfree(data);
 	}
 	*pdata = NULL;
@@ -2001,13 +2049,13 @@ event_enable_func(struct ftrace_hash *hash,
 		  char *glob, char *cmd, char *param, int enabled)
 {
 	struct trace_array *tr = top_trace_array();
-	struct ftrace_event_file *file;
 	struct ftrace_probe_ops *ops;
 	struct event_probe_data *data;
 	const char *system;
 	const char *event;
 	char *number;
 	bool enable;
+	int nr_files;
 	int ret;
 
 	/* hash funcs only work with set_ftrace_filter */
@@ -2026,8 +2074,8 @@ event_enable_func(struct ftrace_hash *hash,
 	mutex_lock(&event_mutex);
 
 	ret = -EINVAL;
-	file = find_event_file(tr, system, event);
-	if (!file)
+	nr_files = find_event_files(tr, system, event, NULL, 0);
+	if (nr_files == 0)
 		goto out;
 
 	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
@@ -2050,7 +2098,17 @@ event_enable_func(struct ftrace_hash *hash,
 
 	data->enable = enable;
 	data->count = -1;
-	data->file = file;
+	data->files = kzalloc((nr_files + 1) * sizeof(*data->files),
+			      GFP_KERNEL);
+	if (!data->files)
+		goto out_free;
+
+	find_event_files(tr, system, event, data->files, nr_files);
+
+	data->event = kstrdup(event, GFP_KERNEL);
+	data->system = kstrdup(system, GFP_KERNEL);
+	if (!data->event || !data->system)
+		goto out_free;
 
 	if (!param)
 		goto out_reg;
@@ -2070,16 +2128,10 @@ event_enable_func(struct ftrace_hash *hash,
 		goto out_free;
 
  out_reg:
-	/* Don't let event modules unload while probe registered */
-	ret = try_module_get(file->event_call->mod);
-	if (!ret) {
-		ret = -EBUSY;
+	ret = event_files_soft_mode(data->files, 1);
+	if (ret < 0)
 		goto out_free;
-	}
 
-	ret = __ftrace_event_enable_disable(file, 1, 1);
-	if (ret < 0)
-		goto out_put;
 	ret = register_ftrace_function_probe(glob, ops, data);
 	/*
 	 * The above returns on success the # of functions enabled,
@@ -2098,10 +2150,11 @@ event_enable_func(struct ftrace_hash *hash,
 	return ret;
 
  out_disable:
-	__ftrace_event_enable_disable(file, 0, 1);
- out_put:
-	module_put(file->event_call->mod);
+	event_files_soft_mode(data->files, 0);
  out_free:
+	kfree(data->files);
+	kfree(data->event);
+	kfree(data->system);
 	kfree(data);
 	goto out;
 }

