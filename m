Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaAFVNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:13:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755984AbaAFVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:13:49 -0500
Date: Mon, 6 Jan 2014 16:13:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
Message-ID: <20140106161347.4cc82a4b@gandalf.local.home>
In-Reply-To: <cover.1389036657.git.tom.zanussi@linux.intel.com>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied these locally, but I'm also going to apply this patch to get
rid of all that duplicate code. Any objections? (or do you see any
mistakes? I only compiled and boot tested it, nothing more strenuous) I
will do that before pushing it though.

-- Steve

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 03d2db2..ccda66f 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -370,6 +370,75 @@ extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *fil
 extern void event_triggers_post_call(struct ftrace_event_file *file,
 				     enum event_trigger_type tt);
 
+static inline int
+ftrace_trigger_call_disabled(struct ftrace_event_file *file)
+{
+	unsigned long eflags = file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return 1;
+	}
+	return 0;
+}
+
+static inline int
+__event_trigger_test_discard(struct ftrace_event_file *file,
+			     struct ring_buffer *buffer,
+			     struct ring_buffer_event *event,
+			     void *entry,
+			     enum event_trigger_type *tt)
+{
+	unsigned long eflags = file->flags;
+
+	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+		*tt = event_triggers_call(file, entry);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags))
+		ring_buffer_discard_commit(buffer, event);
+	else if (!filter_check_discard(file, entry, buffer, event))
+		return 1;
+
+	return 0;
+}
+
+static inline void
+event_trigger_unlock_commit(struct ftrace_event_file *file,
+			    struct ring_buffer *buffer,
+			    struct ring_buffer_event *event,
+			    void *entry, unsigned long irq_flags, int pc)
+{
+	unsigned long eflags = file->flags;
+	enum event_trigger_type tt = ETT_NONE;
+
+	if (__event_trigger_test_discard(file, buffer, event, entry, &tt))
+		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+
+	if (tt)
+		event_triggers_post_call(file, tt);
+}
+
+
+static inline void
+event_trigger_unlock_commit_regs(struct ftrace_event_file *file,
+				 struct ring_buffer *buffer,
+				 struct ring_buffer_event *event,
+				 void *entry, unsigned long irq_flags, int pc,
+				 struct pt_regs *regs)
+{
+	unsigned long eflags = file->flags;
+	enum event_trigger_type tt = ETT_NONE;
+
+	if (__event_trigger_test_discard(file, buffer, event, entry, &tt))
+		trace_buffer_unlock_commit_regs(buffer, event,
+						irq_flags, pc, regs);
+
+	if (tt)
+		event_triggers_post_call(file, tt);
+}
+
 enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0962968..7a43935 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -546,8 +546,6 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	struct ftrace_event_file *ftrace_file = __data;			\
 	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	unsigned long eflags = ftrace_file->flags;			\
-	enum event_trigger_type __tt = ETT_NONE;			\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	struct ring_buffer *buffer;					\
@@ -555,12 +553,8 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {			\
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)		\
-			event_triggers_call(ftrace_file, NULL);		\
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)		\
-			return;						\
-	}								\
+	if (ftrace_trigger_call_disabled(ftrace_file))			\
+		return;							\
 									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
@@ -579,17 +573,8 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
-	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)			\
-		__tt = event_triggers_call(ftrace_file, entry);		\
-									\
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,                 \
-		     &ftrace_file->flags))                              \
-		ring_buffer_discard_commit(buffer, event);              \
-	else if (!filter_check_discard(ftrace_file, entry, buffer, event)) \
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
-									\
-	if (__tt)							\
-		event_triggers_post_call(ftrace_file, __tt);		\
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, \
+				    irq_flags, pc);		       \
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3afa716..196b427 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -929,20 +929,12 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
-	unsigned long eflags;
-	enum event_trigger_type tt = ETT_NONE;
 	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	eflags = ftrace_file->flags;
-
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
-			event_triggers_call(ftrace_file, NULL);
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			return;
-	}
+	if (ftrace_trigger_call_disabled(ftrace_file))
+		return;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
@@ -960,16 +952,8 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	entry->ip = (unsigned long)tk->rp.kp.addr;
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		tt = event_triggers_call(ftrace_file, entry);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_buffer_unlock_commit_regs(buffer, event,
-						irq_flags, pc, regs);
-	if (tt)
-		event_triggers_post_call(ftrace_file, tt);
+	event_trigger_unlock_commit_regs(ftrace_file, buffer, event,
+					 entry, irq_flags, pc, regs);
 }
 
 static __kprobes void
@@ -992,20 +976,12 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
-	unsigned long eflags;
-	enum event_trigger_type tt = ETT_NONE;
 	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	eflags = ftrace_file->flags;
-
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
-			event_triggers_call(ftrace_file, NULL);
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			return;
-	}
+	if (ftrace_trigger_call_disabled(ftrace_file))
+		return;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
@@ -1024,16 +1000,8 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		tt = event_triggers_call(ftrace_file, entry);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_buffer_unlock_commit_regs(buffer, event,
-						irq_flags, pc, regs);
-	if (tt)
-		event_triggers_post_call(ftrace_file, tt);
+	event_trigger_unlock_commit_regs(ftrace_file, buffer, event,
+					 entry, irq_flags, pc, regs);
 }
 
 static __kprobes void
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a4acf9b..6d407eb 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,10 +306,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	enum event_trigger_type tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
-	unsigned long eflags;
 	int pc;
 	int syscall_nr;
 	int size;
@@ -323,14 +321,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!ftrace_file)
 		return;
 
-	eflags = ftrace_file->flags;
-
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
-			event_triggers_call(ftrace_file, NULL);
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			return;
-	}
+	if (ftrace_trigger_call_disabled(ftrace_file))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -351,16 +343,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		tt = event_triggers_call(ftrace_file, entry);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
-	if (tt)
-		event_triggers_post_call(ftrace_file, tt);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry,
+				    irq_flags, pc);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -370,10 +354,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
-	enum event_trigger_type tt = ETT_NONE;
 	struct ring_buffer *buffer;
 	unsigned long irq_flags;
-	unsigned long eflags;
 	int pc;
 	int syscall_nr;
 
@@ -386,14 +368,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!ftrace_file)
 		return;
 
-	eflags = ftrace_file->flags;
-
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
-			event_triggers_call(ftrace_file, NULL);
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			return;
-	}
+	if (ftrace_trigger_call_disabled(ftrace_file))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -413,16 +389,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
-		tt = event_triggers_call(ftrace_file, entry);
-
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
-		ring_buffer_discard_commit(buffer, event);
-	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
-	if (tt)
-		event_triggers_post_call(ftrace_file, tt);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry,
+				    irq_flags, pc);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
