Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaATWPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:15:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:18180 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380AbaATWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:15:33 -0500
Date: Mon, 20 Jan 2014 17:15:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing: New features and fixes
Message-ID: <20140120171529.2f5f1eaf@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This pull request has a new feature to ftrace, namely the trace event
triggers by Tom Zanussi. A trigger is a way to enable an action when an
event is hit. The actions are:

 o  trace on/off - enable or disable tracing
 o  snapshot     - save the current trace buffer in the snapshot
 o  stacktrace   - dump the current stack trace to the ringbuffer
 o  enable/disable events - enable or disable another event

Namhyung Kim added updates to the tracing uprobes code. Having the
uprobes add support for fetch methods.

The rest are various bug fixes with the new code, and minor ones for
the old code.

Please pull the latest trace-3.14 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.14

Tag SHA1: 1863c5c59ad66019a694147e822499a7aa8b027b
Head SHA1: 92fdd98cf8bdec4d6b0c510e2f073ac4fd059be8


Al Viro (1):
      tracing: Fix buggered tee(2) on tracing_pipe

Hyeoncheol Lee (1):
      tracing/probes: Add fetch{,_size} member into deref fetch method

Namhyung Kim (16):
      tracing/uprobes: Fix documentation of uprobe registration syntax
      tracing/probes: Fix basic print type functions
      tracing/kprobes: Factor out struct trace_probe
      tracing/uprobes: Convert to struct trace_probe
      tracing/kprobes: Move common functions to trace_probe.h
      tracing/probes: Integrate duplicate set_print_fmt()
      tracing/probes: Move fetch function helpers to trace_probe.h
      tracing/probes: Split [ku]probes_fetch_type_table
      tracing/probes: Implement 'stack' fetch method for uprobes
      tracing/probes: Move 'symbol' fetch method to kprobes
      tracing/probes: Implement 'memory' fetch method for uprobes
      tracing/uprobes: Pass 'is_return' to traceprobe_parse_probe_arg()
      tracing/uprobes: Fetch args before reserving a ring buffer
      tracing/uprobes: Add support for full argument access methods
      tracing/uprobes: Add @+file_offset fetch method
      tracing/probes: Fix build break on !CONFIG_KPROBE_EVENT

Oleg Nesterov (1):
      uprobes: Allocate ->utask before handler_chain() for tracing handlers

Steven Rostedt (Red Hat) (10):
      tracing: Move ftrace_event_file() out of DYNAMIC_FTRACE ifdef
      tracing: Add generic tracing_lseek() function
      tracing: Fix rcu handling of event_trigger_data filter field
      tracing: Fix counter for traceon/off event triggers
      tracing: Consolidate event trigger code
      tracing: Show available event triggers when no trigger is set
      ftrace: Synchronize setting function_trace_op with ftrace_trace_function
      ftrace: Have function graph only trace based on global_ops filters
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      tracing: Have trace buffer point back to trace_array

Tom Zanussi (9):
      tracing: Add basic event trigger framework
      tracing: Add 'traceon' and 'traceoff' event trigger commands
      tracing: Add 'snapshot' event trigger command
      tracing: Add 'stacktrace' event trigger command
      tracing: Add 'enable_event' and 'disable_event' event trigger commands
      tracing: Add and use generic set_trigger_filter() implementation
      tracing: Add documentation for trace event triggers
      tracing/kprobes: Add trace event trigger invocations
      tracing: Remove double-underscore naming in syscall trigger invocations

----
 Documentation/trace/events.txt       |  207 +++++
 Documentation/trace/uprobetracer.txt |   36 +-
 include/linux/ftrace.h               |    2 -
 include/linux/ftrace_event.h         |  139 ++++
 include/trace/ftrace.h               |   29 +-
 kernel/events/uprobes.c              |    4 +
 kernel/trace/Makefile                |    1 +
 kernel/trace/ftrace.c                |  215 +++--
 kernel/trace/trace.c                 |   57 +-
 kernel/trace/trace.h                 |  193 +++++
 kernel/trace/trace_events.c          |   49 +-
 kernel/trace/trace_events_filter.c   |   12 +
 kernel/trace/trace_events_trigger.c  | 1437 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_kprobe.c          |  838 +++++++++++---------
 kernel/trace/trace_probe.c           |  440 ++++-------
 kernel/trace/trace_probe.h           |  224 ++++++
 kernel/trace/trace_stack.c           |    2 +-
 kernel/trace/trace_syscalls.c        |   14 +-
 kernel/trace/trace_uprobe.c          |  487 ++++++++----
 19 files changed, 3463 insertions(+), 923 deletions(-)
---------------------------
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 37732a2..c94435d 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -287,3 +287,210 @@ their old filters):
 prev_pid == 0
 # cat sched_wakeup/filter
 common_pid == 0
+
+6. Event triggers
+=================
+
+Trace events can be made to conditionally invoke trigger 'commands'
+which can take various forms and are described in detail below;
+examples would be enabling or disabling other trace events or invoking
+a stack trace whenever the trace event is hit.  Whenever a trace event
+with attached triggers is invoked, the set of trigger commands
+associated with that event is invoked.  Any given trigger can
+additionally have an event filter of the same form as described in
+section 5 (Event filtering) associated with it - the command will only
+be invoked if the event being invoked passes the associated filter.
+If no filter is associated with the trigger, it always passes.
+
+Triggers are added to and removed from a particular event by writing
+trigger expressions to the 'trigger' file for the given event.
+
+A given event can have any number of triggers associated with it,
+subject to any restrictions that individual commands may have in that
+regard.
+
+Event triggers are implemented on top of "soft" mode, which means that
+whenever a trace event has one or more triggers associated with it,
+the event is activated even if it isn't actually enabled, but is
+disabled in a "soft" mode.  That is, the tracepoint will be called,
+but just will not be traced, unless of course it's actually enabled.
+This scheme allows triggers to be invoked even for events that aren't
+enabled, and also allows the current event filter implementation to be
+used for conditionally invoking triggers.
+
+The syntax for event triggers is roughly based on the syntax for
+set_ftrace_filter 'ftrace filter commands' (see the 'Filter commands'
+section of Documentation/trace/ftrace.txt), but there are major
+differences and the implementation isn't currently tied to it in any
+way, so beware about making generalizations between the two.
+
+6.1 Expression syntax
+---------------------
+
+Triggers are added by echoing the command to the 'trigger' file:
+
+  # echo 'command[:count] [if filter]' > trigger
+
+Triggers are removed by echoing the same command but starting with '!'
+to the 'trigger' file:
+
+  # echo '!command[:count] [if filter]' > trigger
+
+The [if filter] part isn't used in matching commands when removing, so
+leaving that off in a '!' command will accomplish the same thing as
+having it in.
+
+The filter syntax is the same as that described in the 'Event
+filtering' section above.
+
+For ease of use, writing to the trigger file using '>' currently just
+adds or removes a single trigger and there's no explicit '>>' support
+('>' actually behaves like '>>') or truncation support to remove all
+triggers (you have to use '!' for each one added.)
+
+6.2 Supported trigger commands
+------------------------------
+
+The following commands are supported:
+
+- enable_event/disable_event
+
+  These commands can enable or disable another trace event whenever
+  the triggering event is hit.  When these commands are registered,
+  the other trace event is activated, but disabled in a "soft" mode.
+  That is, the tracepoint will be called, but just will not be traced.
+  The event tracepoint stays in this mode as long as there's a trigger
+  in effect that can trigger it.
+
+  For example, the following trigger causes kmalloc events to be
+  traced when a read system call is entered, and the :1 at the end
+  specifies that this enablement happens only once:
+
+  # echo 'enable_event:kmem:kmalloc:1' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
+
+  The following trigger causes kmalloc events to stop being traced
+  when a read system call exits.  This disablement happens on every
+  read system call exit:
+
+  # echo 'disable_event:kmem:kmalloc' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger
+
+  The format is:
+
+      enable_event:<system>:<event>[:count]
+      disable_event:<system>:<event>[:count]
+
+  To remove the above commands:
+
+  # echo '!enable_event:kmem:kmalloc:1' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
+
+  # echo '!disable_event:kmem:kmalloc' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger
+
+  Note that there can be any number of enable/disable_event triggers
+  per triggering event, but there can only be one trigger per
+  triggered event. e.g. sys_enter_read can have triggers enabling both
+  kmem:kmalloc and sched:sched_switch, but can't have two kmem:kmalloc
+  versions such as kmem:kmalloc and kmem:kmalloc:1 or 'kmem:kmalloc if
+  bytes_req == 256' and 'kmem:kmalloc if bytes_alloc == 256' (they
+  could be combined into a single filter on kmem:kmalloc though).
+
+- stacktrace
+
+  This command dumps a stacktrace in the trace buffer whenever the
+  triggering event occurs.
+
+  For example, the following trigger dumps a stacktrace every time the
+  kmalloc tracepoint is hit:
+
+  # echo 'stacktrace' > \
+        /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  The following trigger dumps a stacktrace the first 5 times a kmalloc
+  request happens with a size >= 64K
+
+  # echo 'stacktrace:5 if bytes_req >= 65536' > \
+        /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  The format is:
+
+      stacktrace[:count]
+
+  To remove the above commands:
+
+  # echo '!stacktrace' > \
+        /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  # echo '!stacktrace:5 if bytes_req >= 65536' > \
+        /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  The latter can also be removed more simply by the following (without
+  the filter):
+
+  # echo '!stacktrace:5' > \
+        /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  Note that there can be only one stacktrace trigger per triggering
+  event.
+
+- snapshot
+
+  This command causes a snapshot to be triggered whenever the
+  triggering event occurs.
+
+  The following command creates a snapshot every time a block request
+  queue is unplugged with a depth > 1.  If you were tracing a set of
+  events or functions at the time, the snapshot trace buffer would
+  capture those events when the trigger event occured:
+
+  # echo 'snapshot if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  To only snapshot once:
+
+  # echo 'snapshot:1 if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  To remove the above commands:
+
+  # echo '!snapshot if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  # echo '!snapshot:1 if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  Note that there can be only one snapshot trigger per triggering
+  event.
+
+- traceon/traceoff
+
+  These commands turn tracing on and off when the specified events are
+  hit. The parameter determines how many times the tracing system is
+  turned on and off. If unspecified, there is no limit.
+
+  The following command turns tracing off the first time a block
+  request queue is unplugged with a depth > 1.  If you were tracing a
+  set of events or functions at the time, you could then examine the
+  trace buffer to see the sequence of events that led up to the
+  trigger event:
+
+  # echo 'traceoff:1 if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  To always disable tracing when nr_rq  > 1 :
+
+  # echo 'traceoff if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  To remove the above commands:
+
+  # echo '!traceoff:1 if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  # echo '!traceoff if nr_rq > 1' > \
+        /sys/kernel/debug/tracing/events/block/block_unplug/trigger
+
+  Note that there can be only one traceon or traceoff trigger per
+  triggering event.
diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index d9c3e68..f1cf9a3 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -19,18 +19,44 @@ user to calculate the offset of the probepoint in the object.
 
 Synopsis of uprobe_tracer
 -------------------------
-  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a uprobe
-  r[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a return uprobe (uretprobe)
-  -:[GRP/]EVENT                                  : Clear uprobe or uretprobe event
+  p[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS] : Set a uprobe
+  r[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS] : Set a return uprobe (uretprobe)
+  -:[GRP/]EVENT                           : Clear uprobe or uretprobe event
 
   GRP           : Group name. If omitted, "uprobes" is the default value.
   EVENT         : Event name. If omitted, the event name is generated based
-                  on SYMBOL+offs.
+                  on PATH+OFFSET.
   PATH          : Path to an executable or a library.
-  SYMBOL[+offs] : Symbol+offset where the probe is inserted.
+  OFFSET        : Offset where the probe is inserted.
 
   FETCHARGS     : Arguments. Each probe can have up to 128 args.
    %REG         : Fetch register REG
+   @ADDR	: Fetch memory at ADDR (ADDR should be in userspace)
+   @+OFFSET	: Fetch memory at OFFSET (OFFSET from same file as PATH)
+   $stackN	: Fetch Nth entry of stack (N >= 0)
+   $stack	: Fetch stack address.
+   $retval	: Fetch return value.(*)
+   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
+   NAME=FETCHARG     : Set NAME as the argument name of FETCHARG.
+   FETCHARG:TYPE     : Set TYPE as the type of FETCHARG. Currently, basic types
+		       (u8/u16/u32/u64/s8/s16/s32/s64), "string" and bitfield
+		       are supported.
+
+  (*) only for return probe.
+  (**) this is useful for fetching a field of data structures.
+
+Types
+-----
+Several types are supported for fetch-args. Uprobe tracer will access memory
+by given type. Prefix 's' and 'u' means those types are signed and unsigned
+respectively. Traced arguments are shown in decimal (signed) or hex (unsigned).
+String type is a special type, which fetches a "null-terminated" string from
+user space.
+Bitfield is another special type, which takes 3 parameters, bit-width, bit-
+offset, and container-size (usually 32). The syntax is;
+
+ b<bit-width>@<bit-offset>/<container-size>
+
 
 Event Profiling
 ---------------
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 31ea4b4..f4233b1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -570,8 +570,6 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
-
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8c9b7a1..4e4cc28 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -1,3 +1,4 @@
+
 #ifndef _LINUX_FTRACE_EVENT_H
 #define _LINUX_FTRACE_EVENT_H
 
@@ -264,6 +265,8 @@ enum {
 	FTRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+	FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
+	FTRACE_EVENT_FL_TRIGGER_COND_BIT,
 };
 
 /*
@@ -275,6 +278,8 @@ enum {
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                   tracepoint may be enabled)
+ *  TRIGGER_MODE  - When set, invoke the triggers associated with the event
+ *  TRIGGER_COND  - When set, one or more triggers has an associated filter
  */
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
@@ -283,6 +288,8 @@ enum {
 	FTRACE_EVENT_FL_NO_SET_FILTER	= (1 << FTRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
+	FTRACE_EVENT_FL_TRIGGER_MODE	= (1 << FTRACE_EVENT_FL_TRIGGER_MODE_BIT),
+	FTRACE_EVENT_FL_TRIGGER_COND	= (1 << FTRACE_EVENT_FL_TRIGGER_COND_BIT),
 };
 
 struct ftrace_event_file {
@@ -292,6 +299,7 @@ struct ftrace_event_file {
 	struct dentry			*dir;
 	struct trace_array		*tr;
 	struct ftrace_subsystem_dir	*system;
+	struct list_head		triggers;
 
 	/*
 	 * 32 bit flags:
@@ -299,6 +307,7 @@ struct ftrace_event_file {
 	 *   bit 1:		enabled cmd record
 	 *   bit 2:		enable/disable with the soft disable bit
 	 *   bit 3:		soft disabled
+	 *   bit 4:		trigger enabled
 	 *
 	 * Note: The bits must be set atomically to prevent races
 	 * from other writers. Reads of flags do not need to be in
@@ -310,6 +319,7 @@ struct ftrace_event_file {
 	 */
 	unsigned long		flags;
 	atomic_t		sm_ref;	/* soft-mode reference counter */
+	atomic_t		tm_ref;	/* trigger-mode reference counter */
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
@@ -337,6 +347,14 @@ struct ftrace_event_file {
 
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
+enum event_trigger_type {
+	ETT_NONE		= (0),
+	ETT_TRACE_ONOFF		= (1 << 0),
+	ETT_SNAPSHOT		= (1 << 1),
+	ETT_STACKTRACE		= (1 << 2),
+	ETT_EVENT_ENABLE	= (1 << 3),
+};
+
 extern void destroy_preds(struct ftrace_event_file *file);
 extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
@@ -347,6 +365,127 @@ extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
 extern int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
 				     struct ring_buffer *buffer,
 				     struct ring_buffer_event *event);
+extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *file,
+						   void *rec);
+extern void event_triggers_post_call(struct ftrace_event_file *file,
+				     enum event_trigger_type tt);
+
+/**
+ * ftrace_trigger_soft_disabled - do triggers and test if soft disabled
+ * @file: The file pointer of the event to test
+ *
+ * If any triggers without filters are attached to this event, they
+ * will be called here. If the event is soft disabled and has no
+ * triggers that require testing the fields, it will return true,
+ * otherwise false.
+ */
+static inline bool
+ftrace_trigger_soft_disabled(struct ftrace_event_file *file)
+{
+	unsigned long eflags = file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * Helper function for event_trigger_unlock_commit{_regs}().
+ * If there are event triggers attached to this event that requires
+ * filtering against its fields, then they wil be called as the
+ * entry already holds the field information of the current event.
+ *
+ * It also checks if the event should be discarded or not.
+ * It is to be discarded if the event is soft disabled and the
+ * event was only recorded to process triggers, or if the event
+ * filter is active and this event did not match the filters.
+ *
+ * Returns true if the event is discarded, false otherwise.
+ */
+static inline bool
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
+		return false;
+
+	return true;
+}
+
+/**
+ * event_trigger_unlock_commit - handle triggers and finish event commit
+ * @file: The file pointer assoctiated to the event
+ * @buffer: The ring buffer that the event is being written to
+ * @event: The event meta data in the ring buffer
+ * @entry: The event itself
+ * @irq_flags: The state of the interrupts at the start of the event
+ * @pc: The state of the preempt count at the start of the event.
+ *
+ * This is a helper function to handle triggers that require data
+ * from the event itself. It also tests the event against filters and
+ * if the event is soft disabled and should be discarded.
+ */
+static inline void
+event_trigger_unlock_commit(struct ftrace_event_file *file,
+			    struct ring_buffer *buffer,
+			    struct ring_buffer_event *event,
+			    void *entry, unsigned long irq_flags, int pc)
+{
+	enum event_trigger_type tt = ETT_NONE;
+
+	if (!__event_trigger_test_discard(file, buffer, event, entry, &tt))
+		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+
+	if (tt)
+		event_triggers_post_call(file, tt);
+}
+
+/**
+ * event_trigger_unlock_commit_regs - handle triggers and finish event commit
+ * @file: The file pointer assoctiated to the event
+ * @buffer: The ring buffer that the event is being written to
+ * @event: The event meta data in the ring buffer
+ * @entry: The event itself
+ * @irq_flags: The state of the interrupts at the start of the event
+ * @pc: The state of the preempt count at the start of the event.
+ *
+ * This is a helper function to handle triggers that require data
+ * from the event itself. It also tests the event against filters and
+ * if the event is soft disabled and should be discarded.
+ *
+ * Same as event_trigger_unlock_commit() but calls
+ * trace_buffer_unlock_commit_regs() instead of trace_buffer_unlock_commit().
+ */
+static inline void
+event_trigger_unlock_commit_regs(struct ftrace_event_file *file,
+				 struct ring_buffer *buffer,
+				 struct ring_buffer_event *event,
+				 void *entry, unsigned long irq_flags, int pc,
+				 struct pt_regs *regs)
+{
+	enum event_trigger_type tt = ETT_NONE;
+
+	if (!__event_trigger_test_discard(file, buffer, event, entry, &tt))
+		trace_buffer_unlock_commit_regs(buffer, event,
+						irq_flags, pc, regs);
+
+	if (tt)
+		event_triggers_post_call(file, tt);
+}
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5c38606..1a8b28d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -418,6 +418,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	struct ftrace_event_file *ftrace_file = __data;
  *	struct ftrace_event_call *event_call = ftrace_file->event_call;
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
+ *	unsigned long eflags = ftrace_file->flags;
+ *	enum event_trigger_type __tt = ETT_NONE;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
  *	struct ring_buffer *buffer;
@@ -425,9 +427,12 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	int __data_size;
  *	int pc;
  *
- *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
- *		     &ftrace_file->flags))
- *		return;
+ *	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+ *		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+ *			event_triggers_call(ftrace_file, NULL);
+ *		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+ *			return;
+ *	}
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
@@ -445,8 +450,17 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	{ <assign>; }  <-- Here we assign the entries by the __field and
  *			   __array macros.
  *
- *	if (!filter_check_discard(ftrace_file, entry, buffer, event))
+ *	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
+ *		__tt = event_triggers_call(ftrace_file, entry);
+ *
+ *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+ *		     &ftrace_file->flags))
+ *		ring_buffer_discard_commit(buffer, event);
+ *	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
  *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *
+ *	if (__tt)
+ *		event_triggers_post_call(ftrace_file, __tt);
  * }
  *
  * static struct trace_event ftrace_event_type_<call> = {
@@ -539,8 +553,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
-		     &ftrace_file->flags))				\
+	if (ftrace_trigger_soft_disabled(ftrace_file))			\
 		return;							\
 									\
 	local_save_flags(irq_flags);					\
@@ -560,8 +573,8 @@ ftrace_raw_event_##call(void *__data, proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))	\
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry, \
+				    irq_flags, pc);		       \
 }
 /*
  * The ftrace_test_probe is compiled out, it is only here as a build time check
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6c..3cc8e0b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1828,6 +1828,10 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
+	/* Tracing handlers use ->utask to communicate with fetch methods */
+	if (!get_utask())
+		goto out;
+
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d7e2068..1378e84 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -50,6 +50,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_PM_RUNTIME),y)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0e9f9ea..7181ad1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -85,6 +85,8 @@ int function_trace_stop __read_mostly;
 
 /* Current function tracing op */
 struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
+/* What to set function_trace_op to */
+static struct ftrace_ops *set_function_trace_op;
 
 /* List for set_ftrace_pid's pids. */
 LIST_HEAD(ftrace_pids);
@@ -278,6 +280,29 @@ static void update_global_ops(void)
 	global_ops.func = func;
 }
 
+static void ftrace_sync(struct work_struct *work)
+{
+	/*
+	 * This function is just a stub to implement a hard force
+	 * of synchronize_sched(). This requires synchronizing
+	 * tasks even in userspace and idle.
+	 *
+	 * Yes, function tracing is rude.
+	 */
+}
+
+static void ftrace_sync_ipi(void *data)
+{
+	/* Probably not needed, but do it anyway */
+	smp_rmb();
+}
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void update_function_graph_func(void);
+#else
+static inline void update_function_graph_func(void) { }
+#endif
+
 static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
@@ -296,16 +321,61 @@ static void update_ftrace_function(void)
 	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
 		if (ftrace_ops_list == &global_ops)
-			function_trace_op = ftrace_global_list;
+			set_function_trace_op = ftrace_global_list;
 		else
-			function_trace_op = ftrace_ops_list;
+			set_function_trace_op = ftrace_ops_list;
 		func = ftrace_ops_list->func;
 	} else {
 		/* Just use the default ftrace_ops */
-		function_trace_op = &ftrace_list_end;
+		set_function_trace_op = &ftrace_list_end;
 		func = ftrace_ops_list_func;
 	}
 
+	/* If there's no change, then do nothing more here */
+	if (ftrace_trace_function == func)
+		return;
+
+	update_function_graph_func();
+
+	/*
+	 * If we are using the list function, it doesn't care
+	 * about the function_trace_ops.
+	 */
+	if (func == ftrace_ops_list_func) {
+		ftrace_trace_function = func;
+		/*
+		 * Don't even bother setting function_trace_ops,
+		 * it would be racy to do so anyway.
+		 */
+		return;
+	}
+
+#ifndef CONFIG_DYNAMIC_FTRACE
+	/*
+	 * For static tracing, we need to be a bit more careful.
+	 * The function change takes affect immediately. Thus,
+	 * we need to coorditate the setting of the function_trace_ops
+	 * with the setting of the ftrace_trace_function.
+	 *
+	 * Set the function to the list ops, which will call the
+	 * function we want, albeit indirectly, but it handles the
+	 * ftrace_ops and doesn't depend on function_trace_op.
+	 */
+	ftrace_trace_function = ftrace_ops_list_func;
+	/*
+	 * Make sure all CPUs see this. Yes this is slow, but static
+	 * tracing is slow and nasty to have enabled.
+	 */
+	schedule_on_each_cpu(ftrace_sync);
+	/* Now all cpus are using the list ops. */
+	function_trace_op = set_function_trace_op;
+	/* Make sure the function_trace_op is visible on all CPUs */
+	smp_wmb();
+	/* Nasty way to force a rmb on all cpus */
+	smp_call_function(ftrace_sync_ipi, NULL, 1);
+	/* OK, we are all set to update the ftrace_trace_function now! */
+#endif /* !CONFIG_DYNAMIC_FTRACE */
+
 	ftrace_trace_function = func;
 }
 
@@ -410,17 +480,6 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void ftrace_sync(struct work_struct *work)
-{
-	/*
-	 * This function is just a stub to implement a hard force
-	 * of synchronize_sched(). This requires synchronizing
-	 * tasks even in userspace and idle.
-	 *
-	 * Yes, function tracing is rude.
-	 */
-}
-
 static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
@@ -439,20 +498,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		ret = remove_ftrace_list_ops(&ftrace_control_list,
 					     &control_ops, ops);
-		if (!ret) {
-			/*
-			 * The ftrace_ops is now removed from the list,
-			 * so there'll be no new users. We must ensure
-			 * all current users are done before we free
-			 * the control data.
-			 * Note synchronize_sched() is not enough, as we
-			 * use preempt_disable() to do RCU, but the function
-			 * tracer can be called where RCU is not active
-			 * (before user_exit()).
-			 */
-			schedule_on_each_cpu(ftrace_sync);
-			control_ops_free(ops);
-		}
 	} else
 		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -462,17 +507,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_enabled)
 		update_ftrace_function();
 
-	/*
-	 * Dynamic ops may be freed, we must make sure that all
-	 * callers are done before leaving this function.
-	 *
-	 * Again, normal synchronize_sched() is not good enough.
-	 * We need to do a hard force of sched synchronization.
-	 */
-	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		schedule_on_each_cpu(ftrace_sync);
-
-
 	return 0;
 }
 
@@ -1082,19 +1116,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
-loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, whence);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -1992,8 +2013,14 @@ void ftrace_modify_all_code(int command)
 	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
 
-	if (update && ftrace_trace_function != ftrace_ops_list_func)
+	if (update && ftrace_trace_function != ftrace_ops_list_func) {
+		function_trace_op = set_function_trace_op;
+		smp_wmb();
+		/* If irqs are disabled, we are in stop machine */
+		if (!irqs_disabled())
+			smp_call_function(ftrace_sync_ipi, NULL, 1);
 		ftrace_update_ftrace_func(ftrace_trace_function);
+	}
 
 	if (command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
@@ -2156,10 +2183,41 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 		command |= FTRACE_UPDATE_TRACE_FUNC;
 	}
 
-	if (!command || !ftrace_enabled)
+	if (!command || !ftrace_enabled) {
+		/*
+		 * If these are control ops, they still need their
+		 * per_cpu field freed. Since, function tracing is
+		 * not currently active, we can just free them
+		 * without synchronizing all CPUs.
+		 */
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
 		return 0;
+	}
 
 	ftrace_run_update_code(command);
+
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 * The same goes for freeing the per_cpu data of the control
+	 * ops.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
+	 * This is because we use preempt_disable() to do RCU, but
+	 * the function tracers can be called where RCU is not watching
+	 * (like before user_exit()). We can not rely on the RCU
+	 * infrastructure to do the synchronization, thus we must do it
+	 * ourselves.
+	 */
+	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_CONTROL)) {
+		schedule_on_each_cpu(ftrace_sync);
+
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
+	}
+
 	return 0;
 }
 
@@ -2739,7 +2797,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_filter_lseek() should be used as the lseek routine, and
+ * tracing_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -3767,7 +3825,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3775,7 +3833,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -4038,7 +4096,7 @@ static const struct file_operations ftrace_graph_fops = {
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_graph_release,
 };
 
@@ -4046,7 +4104,7 @@ static const struct file_operations ftrace_graph_notrace_fops = {
 	.open		= ftrace_graph_notrace_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_graph_release,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
@@ -4719,7 +4777,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_pid_release,
 };
 
@@ -4862,6 +4920,7 @@ int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 trace_func_graph_ret_t ftrace_graph_return =
 			(trace_func_graph_ret_t)ftrace_stub;
 trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
+static trace_func_graph_ent_t __ftrace_graph_entry = ftrace_graph_entry_stub;
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -5003,6 +5062,30 @@ static struct ftrace_ops fgraph_ops __read_mostly = {
 				FTRACE_OPS_FL_RECURSION_SAFE,
 };
 
+static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
+{
+	if (!ftrace_ops_test(&global_ops, trace->func, NULL))
+		return 0;
+	return __ftrace_graph_entry(trace);
+}
+
+/*
+ * The function graph tracer should only trace the functions defined
+ * by set_ftrace_filter and set_ftrace_notrace. If another function
+ * tracer ops is registered, the graph tracer requires testing the
+ * function against the global ops, and not just trace any function
+ * that any ftrace_ops registered.
+ */
+static void update_function_graph_func(void)
+{
+	if (ftrace_ops_list == &ftrace_list_end ||
+	    (ftrace_ops_list == &global_ops &&
+	     global_ops.next == &ftrace_list_end))
+		ftrace_graph_entry = __ftrace_graph_entry;
+	else
+		ftrace_graph_entry = ftrace_graph_entry_test;
+}
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -5027,7 +5110,16 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	}
 
 	ftrace_graph_return = retfunc;
-	ftrace_graph_entry = entryfunc;
+
+	/*
+	 * Update the indirect function to the entryfunc, and the
+	 * function that gets called to the entry_test first. Then
+	 * call the update fgraph entry function to determine if
+	 * the entryfunc should be called directly or not.
+	 */
+	__ftrace_graph_entry = entryfunc;
+	ftrace_graph_entry = ftrace_graph_entry_test;
+	update_function_graph_func();
 
 	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
 
@@ -5046,6 +5138,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
+	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..20c755e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -595,6 +595,28 @@ void free_snapshot(struct trace_array *tr)
 }
 
 /**
+ * tracing_alloc_snapshot - allocate snapshot buffer.
+ *
+ * This only allocates the snapshot buffer if it isn't already
+ * allocated - it doesn't also take a snapshot.
+ *
+ * This is meant to be used in cases where the snapshot buffer needs
+ * to be set up for events that can't sleep but need to be able to
+ * trigger a snapshot.
+ */
+int tracing_alloc_snapshot(void)
+{
+	struct trace_array *tr = &global_trace;
+	int ret;
+
+	ret = alloc_snapshot(tr);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
+
+/**
  * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
  *
  * This is similar to trace_snapshot(), but it will allocate the
@@ -607,11 +629,10 @@ void free_snapshot(struct trace_array *tr)
  */
 void tracing_snapshot_alloc(void)
 {
-	struct trace_array *tr = &global_trace;
 	int ret;
 
-	ret = alloc_snapshot(tr);
-	if (WARN_ON(ret < 0))
+	ret = tracing_alloc_snapshot();
+	if (ret < 0)
 		return;
 
 	tracing_snapshot();
@@ -623,6 +644,12 @@ void tracing_snapshot(void)
 	WARN_ONCE(1, "Snapshot feature not enabled, but internal snapshot used");
 }
 EXPORT_SYMBOL_GPL(tracing_snapshot);
+int tracing_alloc_snapshot(void)
+{
+	WARN_ONCE(1, "Snapshot feature not enabled, but snapshot allocation used");
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
 void tracing_snapshot_alloc(void)
 {
 	/* Give warning */
@@ -3156,19 +3183,23 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
-static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+loff_t tracing_lseek(struct file *file, loff_t offset, int whence)
 {
+	int ret;
+
 	if (file->f_mode & FMODE_READ)
-		return seq_lseek(file, offset, origin);
+		ret = seq_lseek(file, offset, whence);
 	else
-		return 0;
+		file->f_pos = ret = 0;
+
+	return ret;
 }
 
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.write		= tracing_write_stub,
-	.llseek		= tracing_seek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_release,
 };
 
@@ -4212,12 +4243,6 @@ out:
 	return sret;
 }
 
-static void tracing_pipe_buf_release(struct pipe_inode_info *pipe,
-				     struct pipe_buffer *buf)
-{
-	__free_page(buf->page);
-}
-
 static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
 				     unsigned int idx)
 {
@@ -4229,7 +4254,7 @@ static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
 	.confirm		= generic_pipe_buf_confirm,
-	.release		= tracing_pipe_buf_release,
+	.release		= generic_pipe_buf_release,
 	.steal			= generic_pipe_buf_steal,
 	.get			= generic_pipe_buf_get,
 };
@@ -4913,7 +4938,7 @@ static const struct file_operations snapshot_fops = {
 	.open		= tracing_snapshot_open,
 	.read		= seq_read,
 	.write		= tracing_snapshot_write,
-	.llseek		= tracing_seek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_snapshot_release,
 };
 
@@ -5883,6 +5908,8 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
+	buf->tr = tr;
+
 	buf->buffer = ring_buffer_alloc(size, rb_flags);
 	if (!buf->buffer)
 		return -ENOMEM;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea189e0..02b592f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1,3 +1,4 @@
+
 #ifndef _LINUX_KERNEL_TRACE_H
 #define _LINUX_KERNEL_TRACE_H
 
@@ -587,6 +588,8 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
+loff_t tracing_lseek(struct file *file, loff_t offset, int whence);
+
 extern cpumask_var_t __read_mostly tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
@@ -1020,6 +1023,10 @@ extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
+extern int create_event_filter(struct ftrace_event_call *call,
+			       char *filter_str, bool set_str,
+			       struct event_filter **filterp);
+extern void free_event_filter(struct event_filter *filter);
 
 struct ftrace_event_field *
 trace_find_event_field(struct ftrace_event_call *call, char *name);
@@ -1028,9 +1035,195 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
+extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
+						 const char *system,
+						 const char *event);
+
+static inline void *event_file_data(struct file *filp)
+{
+	return ACCESS_ONCE(file_inode(filp)->i_private);
+}
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
+extern const struct file_operations event_trigger_fops;
+
+extern int register_trigger_cmds(void);
+extern void clear_event_triggers(struct trace_array *tr);
+
+struct event_trigger_data {
+	unsigned long			count;
+	int				ref;
+	struct event_trigger_ops	*ops;
+	struct event_command		*cmd_ops;
+	struct event_filter __rcu	*filter;
+	char				*filter_str;
+	void				*private_data;
+	struct list_head		list;
+};
+
+/**
+ * struct event_trigger_ops - callbacks for trace event triggers
+ *
+ * The methods in this structure provide per-event trigger hooks for
+ * various trigger operations.
+ *
+ * All the methods below, except for @init() and @free(), must be
+ * implemented.
+ *
+ * @func: The trigger 'probe' function called when the triggering
+ *	event occurs.  The data passed into this callback is the data
+ *	that was supplied to the event_command @reg() function that
+ *	registered the trigger (see struct event_command).
+ *
+ * @init: An optional initialization function called for the trigger
+ *	when the trigger is registered (via the event_command reg()
+ *	function).  This can be used to perform per-trigger
+ *	initialization such as incrementing a per-trigger reference
+ *	count, for instance.  This is usually implemented by the
+ *	generic utility function @event_trigger_init() (see
+ *	trace_event_triggers.c).
+ *
+ * @free: An optional de-initialization function called for the
+ *	trigger when the trigger is unregistered (via the
+ *	event_command @reg() function).  This can be used to perform
+ *	per-trigger de-initialization such as decrementing a
+ *	per-trigger reference count and freeing corresponding trigger
+ *	data, for instance.  This is usually implemented by the
+ *	generic utility function @event_trigger_free() (see
+ *	trace_event_triggers.c).
+ *
+ * @print: The callback function invoked to have the trigger print
+ *	itself.  This is usually implemented by a wrapper function
+ *	that calls the generic utility function @event_trigger_print()
+ *	(see trace_event_triggers.c).
+ */
+struct event_trigger_ops {
+	void			(*func)(struct event_trigger_data *data);
+	int			(*init)(struct event_trigger_ops *ops,
+					struct event_trigger_data *data);
+	void			(*free)(struct event_trigger_ops *ops,
+					struct event_trigger_data *data);
+	int			(*print)(struct seq_file *m,
+					 struct event_trigger_ops *ops,
+					 struct event_trigger_data *data);
+};
+
+/**
+ * struct event_command - callbacks and data members for event commands
+ *
+ * Event commands are invoked by users by writing the command name
+ * into the 'trigger' file associated with a trace event.  The
+ * parameters associated with a specific invocation of an event
+ * command are used to create an event trigger instance, which is
+ * added to the list of trigger instances associated with that trace
+ * event.  When the event is hit, the set of triggers associated with
+ * that event is invoked.
+ *
+ * The data members in this structure provide per-event command data
+ * for various event commands.
+ *
+ * All the data members below, except for @post_trigger, must be set
+ * for each event command.
+ *
+ * @name: The unique name that identifies the event command.  This is
+ *	the name used when setting triggers via trigger files.
+ *
+ * @trigger_type: A unique id that identifies the event command
+ *	'type'.  This value has two purposes, the first to ensure that
+ *	only one trigger of the same type can be set at a given time
+ *	for a particular event e.g. it doesn't make sense to have both
+ *	a traceon and traceoff trigger attached to a single event at
+ *	the same time, so traceon and traceoff have the same type
+ *	though they have different names.  The @trigger_type value is
+ *	also used as a bit value for deferring the actual trigger
+ *	action until after the current event is finished.  Some
+ *	commands need to do this if they themselves log to the trace
+ *	buffer (see the @post_trigger() member below).  @trigger_type
+ *	values are defined by adding new values to the trigger_type
+ *	enum in include/linux/ftrace_event.h.
+ *
+ * @post_trigger: A flag that says whether or not this command needs
+ *	to have its action delayed until after the current event has
+ *	been closed.  Some triggers need to avoid being invoked while
+ *	an event is currently in the process of being logged, since
+ *	the trigger may itself log data into the trace buffer.  Thus
+ *	we make sure the current event is committed before invoking
+ *	those triggers.  To do that, the trigger invocation is split
+ *	in two - the first part checks the filter using the current
+ *	trace record; if a command has the @post_trigger flag set, it
+ *	sets a bit for itself in the return value, otherwise it
+ *	directly invokes the trigger.  Once all commands have been
+ *	either invoked or set their return flag, the current record is
+ *	either committed or discarded.  At that point, if any commands
+ *	have deferred their triggers, those commands are finally
+ *	invoked following the close of the current event.  In other
+ *	words, if the event_trigger_ops @func() probe implementation
+ *	itself logs to the trace buffer, this flag should be set,
+ *	otherwise it can be left unspecified.
+ *
+ * All the methods below, except for @set_filter(), must be
+ * implemented.
+ *
+ * @func: The callback function responsible for parsing and
+ *	registering the trigger written to the 'trigger' file by the
+ *	user.  It allocates the trigger instance and registers it with
+ *	the appropriate trace event.  It makes use of the other
+ *	event_command callback functions to orchestrate this, and is
+ *	usually implemented by the generic utility function
+ *	@event_trigger_callback() (see trace_event_triggers.c).
+ *
+ * @reg: Adds the trigger to the list of triggers associated with the
+ *	event, and enables the event trigger itself, after
+ *	initializing it (via the event_trigger_ops @init() function).
+ *	This is also where commands can use the @trigger_type value to
+ *	make the decision as to whether or not multiple instances of
+ *	the trigger should be allowed.  This is usually implemented by
+ *	the generic utility function @register_trigger() (see
+ *	trace_event_triggers.c).
+ *
+ * @unreg: Removes the trigger from the list of triggers associated
+ *	with the event, and disables the event trigger itself, after
+ *	initializing it (via the event_trigger_ops @free() function).
+ *	This is usually implemented by the generic utility function
+ *	@unregister_trigger() (see trace_event_triggers.c).
+ *
+ * @set_filter: An optional function called to parse and set a filter
+ *	for the trigger.  If no @set_filter() method is set for the
+ *	event command, filters set by the user for the command will be
+ *	ignored.  This is usually implemented by the generic utility
+ *	function @set_trigger_filter() (see trace_event_triggers.c).
+ *
+ * @get_trigger_ops: The callback function invoked to retrieve the
+ *	event_trigger_ops implementation associated with the command.
+ */
+struct event_command {
+	struct list_head	list;
+	char			*name;
+	enum event_trigger_type	trigger_type;
+	bool			post_trigger;
+	int			(*func)(struct event_command *cmd_ops,
+					struct ftrace_event_file *file,
+					char *glob, char *cmd, char *params);
+	int			(*reg)(char *glob,
+				       struct event_trigger_ops *ops,
+				       struct event_trigger_data *data,
+				       struct ftrace_event_file *file);
+	void			(*unreg)(char *glob,
+					 struct event_trigger_ops *ops,
+					 struct event_trigger_data *data,
+					 struct ftrace_event_file *file);
+	int			(*set_filter)(char *filter_str,
+					      struct event_trigger_data *data,
+					      struct ftrace_event_file *file);
+	struct event_trigger_ops *(*get_trigger_ops)(char *cmd, char *param);
+};
+
+extern int trace_event_enable_disable(struct ftrace_event_file *file,
+				      int enable, int soft_disable);
+extern int tracing_alloc_snapshot(void);
+
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a11800a..e71ffd4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -342,6 +342,12 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 	return ret;
 }
 
+int trace_event_enable_disable(struct ftrace_event_file *file,
+			       int enable, int soft_disable)
+{
+	return __ftrace_event_enable_disable(file, enable, soft_disable);
+}
+
 static int ftrace_event_enable_disable(struct ftrace_event_file *file,
 				       int enable)
 {
@@ -421,11 +427,6 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 	}
 }
 
-static void *event_file_data(struct file *filp)
-{
-	return ACCESS_ONCE(file_inode(filp)->i_private);
-}
-
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
 	struct dentry *dir = file->dir;
@@ -1549,6 +1550,9 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	trace_create_file("filter", 0644, file->dir, file,
 			  &ftrace_event_filter_fops);
 
+	trace_create_file("trigger", 0644, file->dir, file,
+			  &event_trigger_fops);
+
 	trace_create_file("format", 0444, file->dir, call,
 			  &ftrace_event_format_fops);
 
@@ -1645,6 +1649,8 @@ trace_create_new_event(struct ftrace_event_call *call,
 	file->event_call = call;
 	file->tr = tr;
 	atomic_set(&file->sm_ref, 0);
+	atomic_set(&file->tm_ref, 0);
+	INIT_LIST_HEAD(&file->triggers);
 	list_add(&file->list, &tr->events);
 
 	return file;
@@ -1849,20 +1855,7 @@ __trace_add_event_dirs(struct trace_array *tr)
 	}
 }
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
-/* Avoid typos */
-#define ENABLE_EVENT_STR	"enable_event"
-#define DISABLE_EVENT_STR	"disable_event"
-
-struct event_probe_data {
-	struct ftrace_event_file	*file;
-	unsigned long			count;
-	int				ref;
-	bool				enable;
-};
-
-static struct ftrace_event_file *
+struct ftrace_event_file *
 find_event_file(struct trace_array *tr, const char *system,  const char *event)
 {
 	struct ftrace_event_file *file;
@@ -1885,6 +1878,19 @@ find_event_file(struct trace_array *tr, const char *system,  const char *event)
 	return NULL;
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+struct event_probe_data {
+	struct ftrace_event_file	*file;
+	unsigned long			count;
+	int				ref;
+	bool				enable;
+};
+
 static void
 event_enable_probe(unsigned long ip, unsigned long parent_ip, void **_data)
 {
@@ -2311,6 +2317,9 @@ int event_trace_del_tracer(struct trace_array *tr)
 {
 	mutex_lock(&event_mutex);
 
+	/* Disable any event triggers and associated soft-disabled events */
+	clear_event_triggers(tr);
+
 	/* Disable any running events */
 	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
 
@@ -2377,6 +2386,8 @@ static __init int event_trace_enable(void)
 
 	register_event_cmds();
 
+	register_trigger_cmds();
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2468f56..8a86319 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -799,6 +799,11 @@ static void __free_filter(struct event_filter *filter)
 	kfree(filter);
 }
 
+void free_event_filter(struct event_filter *filter)
+{
+	__free_filter(filter);
+}
+
 void destroy_call_preds(struct ftrace_event_call *call)
 {
 	__free_filter(call->filter);
@@ -1938,6 +1943,13 @@ static int create_filter(struct ftrace_event_call *call,
 	return err;
 }
 
+int create_event_filter(struct ftrace_event_call *call,
+			char *filter_str, bool set_str,
+			struct event_filter **filterp)
+{
+	return create_filter(call, filter_str, set_str, filterp);
+}
+
 /**
  * create_system_filter - create a filter for an event_subsystem
  * @system: event_subsystem to create a filter for
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
new file mode 100644
index 0000000..8efbb69
--- /dev/null
+++ b/kernel/trace/trace_events_trigger.c
@@ -0,0 +1,1437 @@
+/*
+ * trace_events_trigger - trace event triggers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2013 Tom Zanussi <tom.zanussi@linux.intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include "trace.h"
+
+static LIST_HEAD(trigger_commands);
+static DEFINE_MUTEX(trigger_cmd_mutex);
+
+static void
+trigger_data_free(struct event_trigger_data *data)
+{
+	if (data->cmd_ops->set_filter)
+		data->cmd_ops->set_filter(NULL, data, NULL);
+
+	synchronize_sched(); /* make sure current triggers exit before free */
+	kfree(data);
+}
+
+/**
+ * event_triggers_call - Call triggers associated with a trace event
+ * @file: The ftrace_event_file associated with the event
+ * @rec: The trace entry for the event, NULL for unconditional invocation
+ *
+ * For each trigger associated with an event, invoke the trigger
+ * function registered with the associated trigger command.  If rec is
+ * non-NULL, it means that the trigger requires further processing and
+ * shouldn't be unconditionally invoked.  If rec is non-NULL and the
+ * trigger has a filter associated with it, rec will checked against
+ * the filter and if the record matches the trigger will be invoked.
+ * If the trigger is a 'post_trigger', meaning it shouldn't be invoked
+ * in any case until the current event is written, the trigger
+ * function isn't invoked but the bit associated with the deferred
+ * trigger is set in the return value.
+ *
+ * Returns an enum event_trigger_type value containing a set bit for
+ * any trigger that should be deferred, ETT_NONE if nothing to defer.
+ *
+ * Called from tracepoint handlers (with rcu_read_lock_sched() held).
+ *
+ * Return: an enum event_trigger_type value containing a set bit for
+ * any trigger that should be deferred, ETT_NONE if nothing to defer.
+ */
+enum event_trigger_type
+event_triggers_call(struct ftrace_event_file *file, void *rec)
+{
+	struct event_trigger_data *data;
+	enum event_trigger_type tt = ETT_NONE;
+	struct event_filter *filter;
+
+	if (list_empty(&file->triggers))
+		return tt;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (!rec) {
+			data->ops->func(data);
+			continue;
+		}
+		filter = rcu_dereference(data->filter);
+		if (filter && !filter_match_preds(filter, rec))
+			continue;
+		if (data->cmd_ops->post_trigger) {
+			tt |= data->cmd_ops->trigger_type;
+			continue;
+		}
+		data->ops->func(data);
+	}
+	return tt;
+}
+EXPORT_SYMBOL_GPL(event_triggers_call);
+
+/**
+ * event_triggers_post_call - Call 'post_triggers' for a trace event
+ * @file: The ftrace_event_file associated with the event
+ * @tt: enum event_trigger_type containing a set bit for each trigger to invoke
+ *
+ * For each trigger associated with an event, invoke the trigger
+ * function registered with the associated trigger command, if the
+ * corresponding bit is set in the tt enum passed into this function.
+ * See @event_triggers_call for details on how those bits are set.
+ *
+ * Called from tracepoint handlers (with rcu_read_lock_sched() held).
+ */
+void
+event_triggers_post_call(struct ftrace_event_file *file,
+			 enum event_trigger_type tt)
+{
+	struct event_trigger_data *data;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->cmd_ops->trigger_type & tt)
+			data->ops->func(data);
+	}
+}
+EXPORT_SYMBOL_GPL(event_triggers_post_call);
+
+#define SHOW_AVAILABLE_TRIGGERS	(void *)(1UL)
+
+static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
+{
+	struct ftrace_event_file *event_file = event_file_data(m->private);
+
+	if (t == SHOW_AVAILABLE_TRIGGERS)
+		return NULL;
+
+	return seq_list_next(t, &event_file->triggers, pos);
+}
+
+static void *trigger_start(struct seq_file *m, loff_t *pos)
+{
+	struct ftrace_event_file *event_file;
+
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	event_file = event_file_data(m->private);
+	if (unlikely(!event_file))
+		return ERR_PTR(-ENODEV);
+
+	if (list_empty(&event_file->triggers))
+		return *pos == 0 ? SHOW_AVAILABLE_TRIGGERS : NULL;
+
+	return seq_list_start(&event_file->triggers, *pos);
+}
+
+static void trigger_stop(struct seq_file *m, void *t)
+{
+	mutex_unlock(&event_mutex);
+}
+
+static int trigger_show(struct seq_file *m, void *v)
+{
+	struct event_trigger_data *data;
+	struct event_command *p;
+
+	if (v == SHOW_AVAILABLE_TRIGGERS) {
+		seq_puts(m, "# Available triggers:\n");
+		seq_putc(m, '#');
+		mutex_lock(&trigger_cmd_mutex);
+		list_for_each_entry_reverse(p, &trigger_commands, list)
+			seq_printf(m, " %s", p->name);
+		seq_putc(m, '\n');
+		mutex_unlock(&trigger_cmd_mutex);
+		return 0;
+	}
+
+	data = list_entry(v, struct event_trigger_data, list);
+	data->ops->print(m, data->ops, data);
+
+	return 0;
+}
+
+static const struct seq_operations event_triggers_seq_ops = {
+	.start = trigger_start,
+	.next = trigger_next,
+	.stop = trigger_stop,
+	.show = trigger_show,
+};
+
+static int event_trigger_regex_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&event_mutex);
+
+	if (unlikely(!event_file_data(file))) {
+		mutex_unlock(&event_mutex);
+		return -ENODEV;
+	}
+
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, &event_triggers_seq_ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+			m->private = file;
+		}
+	}
+
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int trigger_process_regex(struct ftrace_event_file *file, char *buff)
+{
+	char *command, *next = buff;
+	struct event_command *p;
+	int ret = -EINVAL;
+
+	command = strsep(&next, ": \t");
+	command = (command[0] != '!') ? command : command + 1;
+
+	mutex_lock(&trigger_cmd_mutex);
+	list_for_each_entry(p, &trigger_commands, list) {
+		if (strcmp(p->name, command) == 0) {
+			ret = p->func(p, file, buff, command, next);
+			goto out_unlock;
+		}
+	}
+ out_unlock:
+	mutex_unlock(&trigger_cmd_mutex);
+
+	return ret;
+}
+
+static ssize_t event_trigger_regex_write(struct file *file,
+					 const char __user *ubuf,
+					 size_t cnt, loff_t *ppos)
+{
+	struct ftrace_event_file *event_file;
+	ssize_t ret;
+	char *buf;
+
+	if (!cnt)
+		return 0;
+
+	if (cnt >= PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long)buf);
+		return -EFAULT;
+	}
+	buf[cnt] = '\0';
+	strim(buf);
+
+	mutex_lock(&event_mutex);
+	event_file = event_file_data(file);
+	if (unlikely(!event_file)) {
+		mutex_unlock(&event_mutex);
+		free_page((unsigned long)buf);
+		return -ENODEV;
+	}
+	ret = trigger_process_regex(event_file, buf);
+	mutex_unlock(&event_mutex);
+
+	free_page((unsigned long)buf);
+	if (ret < 0)
+		goto out;
+
+	*ppos += cnt;
+	ret = cnt;
+ out:
+	return ret;
+}
+
+static int event_trigger_regex_release(struct inode *inode, struct file *file)
+{
+	mutex_lock(&event_mutex);
+
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
+
+	mutex_unlock(&event_mutex);
+
+	return 0;
+}
+
+static ssize_t
+event_trigger_write(struct file *filp, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	return event_trigger_regex_write(filp, ubuf, cnt, ppos);
+}
+
+static int
+event_trigger_open(struct inode *inode, struct file *filp)
+{
+	return event_trigger_regex_open(inode, filp);
+}
+
+static int
+event_trigger_release(struct inode *inode, struct file *file)
+{
+	return event_trigger_regex_release(inode, file);
+}
+
+const struct file_operations event_trigger_fops = {
+	.open = event_trigger_open,
+	.read = seq_read,
+	.write = event_trigger_write,
+	.llseek = tracing_lseek,
+	.release = event_trigger_release,
+};
+
+/*
+ * Currently we only register event commands from __init, so mark this
+ * __init too.
+ */
+static __init int register_event_command(struct event_command *cmd)
+{
+	struct event_command *p;
+	int ret = 0;
+
+	mutex_lock(&trigger_cmd_mutex);
+	list_for_each_entry(p, &trigger_commands, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+	}
+	list_add(&cmd->list, &trigger_commands);
+ out_unlock:
+	mutex_unlock(&trigger_cmd_mutex);
+
+	return ret;
+}
+
+/*
+ * Currently we only unregister event commands from __init, so mark
+ * this __init too.
+ */
+static __init int unregister_event_command(struct event_command *cmd)
+{
+	struct event_command *p, *n;
+	int ret = -ENODEV;
+
+	mutex_lock(&trigger_cmd_mutex);
+	list_for_each_entry_safe(p, n, &trigger_commands, list) {
+		if (strcmp(cmd->name, p->name) == 0) {
+			ret = 0;
+			list_del_init(&p->list);
+			goto out_unlock;
+		}
+	}
+ out_unlock:
+	mutex_unlock(&trigger_cmd_mutex);
+
+	return ret;
+}
+
+/**
+ * event_trigger_print - Generic event_trigger_ops @print implementation
+ * @name: The name of the event trigger
+ * @m: The seq_file being printed to
+ * @data: Trigger-specific data
+ * @filter_str: filter_str to print, if present
+ *
+ * Common implementation for event triggers to print themselves.
+ *
+ * Usually wrapped by a function that simply sets the @name of the
+ * trigger command and then invokes this.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int
+event_trigger_print(const char *name, struct seq_file *m,
+		    void *data, char *filter_str)
+{
+	long count = (long)data;
+
+	seq_printf(m, "%s", name);
+
+	if (count == -1)
+		seq_puts(m, ":unlimited");
+	else
+		seq_printf(m, ":count=%ld", count);
+
+	if (filter_str)
+		seq_printf(m, " if %s\n", filter_str);
+	else
+		seq_puts(m, "\n");
+
+	return 0;
+}
+
+/**
+ * event_trigger_init - Generic event_trigger_ops @init implementation
+ * @ops: The trigger ops associated with the trigger
+ * @data: Trigger-specific data
+ *
+ * Common implementation of event trigger initialization.
+ *
+ * Usually used directly as the @init method in event trigger
+ * implementations.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int
+event_trigger_init(struct event_trigger_ops *ops,
+		   struct event_trigger_data *data)
+{
+	data->ref++;
+	return 0;
+}
+
+/**
+ * event_trigger_free - Generic event_trigger_ops @free implementation
+ * @ops: The trigger ops associated with the trigger
+ * @data: Trigger-specific data
+ *
+ * Common implementation of event trigger de-initialization.
+ *
+ * Usually used directly as the @free method in event trigger
+ * implementations.
+ */
+static void
+event_trigger_free(struct event_trigger_ops *ops,
+		   struct event_trigger_data *data)
+{
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref)
+		trigger_data_free(data);
+}
+
+static int trace_event_trigger_enable_disable(struct ftrace_event_file *file,
+					      int trigger_enable)
+{
+	int ret = 0;
+
+	if (trigger_enable) {
+		if (atomic_inc_return(&file->tm_ref) > 1)
+			return ret;
+		set_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+		ret = trace_event_enable_disable(file, 1, 1);
+	} else {
+		if (atomic_dec_return(&file->tm_ref) > 0)
+			return ret;
+		clear_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT, &file->flags);
+		ret = trace_event_enable_disable(file, 0, 1);
+	}
+
+	return ret;
+}
+
+/**
+ * clear_event_triggers - Clear all triggers associated with a trace array
+ * @tr: The trace array to clear
+ *
+ * For each trigger, the triggering event has its tm_ref decremented
+ * via trace_event_trigger_enable_disable(), and any associated event
+ * (in the case of enable/disable_event triggers) will have its sm_ref
+ * decremented via free()->trace_event_enable_disable().  That
+ * combination effectively reverses the soft-mode/trigger state added
+ * by trigger registration.
+ *
+ * Must be called with event_mutex held.
+ */
+void
+clear_event_triggers(struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	list_for_each_entry(file, &tr->events, list) {
+		struct event_trigger_data *data;
+		list_for_each_entry_rcu(data, &file->triggers, list) {
+			trace_event_trigger_enable_disable(file, 0);
+			if (data->ops->free)
+				data->ops->free(data->ops, data);
+		}
+	}
+}
+
+/**
+ * update_cond_flag - Set or reset the TRIGGER_COND bit
+ * @file: The ftrace_event_file associated with the event
+ *
+ * If an event has triggers and any of those triggers has a filter or
+ * a post_trigger, trigger invocation needs to be deferred until after
+ * the current event has logged its data, and the event should have
+ * its TRIGGER_COND bit set, otherwise the TRIGGER_COND bit should be
+ * cleared.
+ */
+static void update_cond_flag(struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data;
+	bool set_cond = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->filter || data->cmd_ops->post_trigger) {
+			set_cond = true;
+			break;
+		}
+	}
+
+	if (set_cond)
+		set_bit(FTRACE_EVENT_FL_TRIGGER_COND_BIT, &file->flags);
+	else
+		clear_bit(FTRACE_EVENT_FL_TRIGGER_COND_BIT, &file->flags);
+}
+
+/**
+ * register_trigger - Generic event_command @reg implementation
+ * @glob: The raw string used to register the trigger
+ * @ops: The trigger ops associated with the trigger
+ * @data: Trigger-specific data to associate with the trigger
+ * @file: The ftrace_event_file associated with the event
+ *
+ * Common implementation for event trigger registration.
+ *
+ * Usually used directly as the @reg method in event command
+ * implementations.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int register_trigger(char *glob, struct event_trigger_ops *ops,
+			    struct event_trigger_data *data,
+			    struct ftrace_event_file *file)
+{
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &file->triggers, list) {
+		if (test->cmd_ops->trigger_type == data->cmd_ops->trigger_type) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	if (data->ops->init) {
+		ret = data->ops->init(data->ops, data);
+		if (ret < 0)
+			goto out;
+	}
+
+	list_add_rcu(&data->list, &file->triggers);
+	ret++;
+
+	if (trace_event_trigger_enable_disable(file, 1) < 0) {
+		list_del_rcu(&data->list);
+		ret--;
+	}
+	update_cond_flag(file);
+out:
+	return ret;
+}
+
+/**
+ * unregister_trigger - Generic event_command @unreg implementation
+ * @glob: The raw string used to register the trigger
+ * @ops: The trigger ops associated with the trigger
+ * @test: Trigger-specific data used to find the trigger to remove
+ * @file: The ftrace_event_file associated with the event
+ *
+ * Common implementation for event trigger unregistration.
+ *
+ * Usually used directly as the @unreg method in event command
+ * implementations.
+ */
+static void unregister_trigger(char *glob, struct event_trigger_ops *ops,
+			       struct event_trigger_data *test,
+			       struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->cmd_ops->trigger_type == test->cmd_ops->trigger_type) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			update_cond_flag(file);
+			trace_event_trigger_enable_disable(file, 0);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, data);
+}
+
+/**
+ * event_trigger_callback - Generic event_command @func implementation
+ * @cmd_ops: The command ops, used for trigger registration
+ * @file: The ftrace_event_file associated with the event
+ * @glob: The raw string used to register the trigger
+ * @cmd: The cmd portion of the string used to register the trigger
+ * @param: The params portion of the string used to register the trigger
+ *
+ * Common implementation for event command parsing and trigger
+ * instantiation.
+ *
+ * Usually used directly as the @func method in event command
+ * implementations.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int
+event_trigger_callback(struct event_command *cmd_ops,
+		       struct ftrace_event_file *file,
+		       char *glob, char *cmd, char *param)
+{
+	struct event_trigger_data *trigger_data;
+	struct event_trigger_ops *trigger_ops;
+	char *trigger = NULL;
+	char *number;
+	int ret;
+
+	/* separate the trigger from the filter (t:n [if filter]) */
+	if (param && isdigit(param[0]))
+		trigger = strsep(&param, " \t");
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	trigger_data->count = -1;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
+		kfree(trigger_data);
+		ret = 0;
+		goto out;
+	}
+
+	if (trigger) {
+		number = strsep(&trigger, ":");
+
+		ret = -EINVAL;
+		if (!strlen(number))
+			goto out_free;
+
+		/*
+		 * We use the callback data field (which is a pointer)
+		 * as our counter.
+		 */
+		ret = kstrtoul(number, 0, &trigger_data->count);
+		if (ret)
+			goto out_free;
+	}
+
+	if (!param) /* if param is non-empty, it's supposed to be a filter */
+		goto out_reg;
+
+	if (!cmd_ops->set_filter)
+		goto out_reg;
+
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_free;
+	} else if (ret < 0)
+		goto out_free;
+	ret = 0;
+ out:
+	return ret;
+
+ out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
+	kfree(trigger_data);
+	goto out;
+}
+
+/**
+ * set_trigger_filter - Generic event_command @set_filter implementation
+ * @filter_str: The filter string for the trigger, NULL to remove filter
+ * @trigger_data: Trigger-specific data
+ * @file: The ftrace_event_file associated with the event
+ *
+ * Common implementation for event command filter parsing and filter
+ * instantiation.
+ *
+ * Usually used directly as the @set_filter method in event command
+ * implementations.
+ *
+ * Also used to remove a filter (if filter_str = NULL).
+ *
+ * Return: 0 on success, errno otherwise
+ */
+static int set_trigger_filter(char *filter_str,
+			      struct event_trigger_data *trigger_data,
+			      struct ftrace_event_file *file)
+{
+	struct event_trigger_data *data = trigger_data;
+	struct event_filter *filter = NULL, *tmp;
+	int ret = -EINVAL;
+	char *s;
+
+	if (!filter_str) /* clear the current filter */
+		goto assign;
+
+	s = strsep(&filter_str, " \t");
+
+	if (!strlen(s) || strcmp(s, "if") != 0)
+		goto out;
+
+	if (!filter_str)
+		goto out;
+
+	/* The filter is for the 'trigger' event, not the triggered event */
+	ret = create_event_filter(file->event_call, filter_str, false, &filter);
+	if (ret)
+		goto out;
+ assign:
+	tmp = rcu_access_pointer(data->filter);
+
+	rcu_assign_pointer(data->filter, filter);
+
+	if (tmp) {
+		/* Make sure the call is done with the filter */
+		synchronize_sched();
+		free_event_filter(tmp);
+	}
+
+	kfree(data->filter_str);
+	data->filter_str = NULL;
+
+	if (filter_str) {
+		data->filter_str = kstrdup(filter_str, GFP_KERNEL);
+		if (!data->filter_str) {
+			free_event_filter(rcu_access_pointer(data->filter));
+			data->filter = NULL;
+			ret = -ENOMEM;
+		}
+	}
+ out:
+	return ret;
+}
+
+static void
+traceon_trigger(struct event_trigger_data *data)
+{
+	if (tracing_is_on())
+		return;
+
+	tracing_on();
+}
+
+static void
+traceon_count_trigger(struct event_trigger_data *data)
+{
+	if (tracing_is_on())
+		return;
+
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	tracing_on();
+}
+
+static void
+traceoff_trigger(struct event_trigger_data *data)
+{
+	if (!tracing_is_on())
+		return;
+
+	tracing_off();
+}
+
+static void
+traceoff_count_trigger(struct event_trigger_data *data)
+{
+	if (!tracing_is_on())
+		return;
+
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	tracing_off();
+}
+
+static int
+traceon_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		      struct event_trigger_data *data)
+{
+	return event_trigger_print("traceon", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static int
+traceoff_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       struct event_trigger_data *data)
+{
+	return event_trigger_print("traceoff", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops traceon_trigger_ops = {
+	.func			= traceon_trigger,
+	.print			= traceon_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceon_count_trigger_ops = {
+	.func			= traceon_count_trigger,
+	.print			= traceon_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceoff_trigger_ops = {
+	.func			= traceoff_trigger,
+	.print			= traceoff_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops traceoff_count_trigger_ops = {
+	.func			= traceoff_count_trigger,
+	.print			= traceoff_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+onoff_get_trigger_ops(char *cmd, char *param)
+{
+	struct event_trigger_ops *ops;
+
+	/* we register both traceon and traceoff to this callback */
+	if (strcmp(cmd, "traceon") == 0)
+		ops = param ? &traceon_count_trigger_ops :
+			&traceon_trigger_ops;
+	else
+		ops = param ? &traceoff_count_trigger_ops :
+			&traceoff_trigger_ops;
+
+	return ops;
+}
+
+static struct event_command trigger_traceon_cmd = {
+	.name			= "traceon",
+	.trigger_type		= ETT_TRACE_ONOFF,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static struct event_command trigger_traceoff_cmd = {
+	.name			= "traceoff",
+	.trigger_type		= ETT_TRACE_ONOFF,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= onoff_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+#ifdef CONFIG_TRACER_SNAPSHOT
+static void
+snapshot_trigger(struct event_trigger_data *data)
+{
+	tracing_snapshot();
+}
+
+static void
+snapshot_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	snapshot_trigger(data);
+}
+
+static int
+register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
+			  struct event_trigger_data *data,
+			  struct ftrace_event_file *file)
+{
+	int ret = register_trigger(glob, ops, data, file);
+
+	if (ret > 0 && tracing_alloc_snapshot() != 0) {
+		unregister_trigger(glob, ops, data, file);
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int
+snapshot_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+		       struct event_trigger_data *data)
+{
+	return event_trigger_print("snapshot", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops snapshot_trigger_ops = {
+	.func			= snapshot_trigger,
+	.print			= snapshot_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops snapshot_count_trigger_ops = {
+	.func			= snapshot_count_trigger,
+	.print			= snapshot_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+snapshot_get_trigger_ops(char *cmd, char *param)
+{
+	return param ? &snapshot_count_trigger_ops : &snapshot_trigger_ops;
+}
+
+static struct event_command trigger_snapshot_cmd = {
+	.name			= "snapshot",
+	.trigger_type		= ETT_SNAPSHOT,
+	.func			= event_trigger_callback,
+	.reg			= register_snapshot_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= snapshot_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static __init int register_trigger_snapshot_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_snapshot_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+#else
+static __init int register_trigger_snapshot_cmd(void) { return 0; }
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
+#ifdef CONFIG_STACKTRACE
+/*
+ * Skip 3:
+ *   stacktrace_trigger()
+ *   event_triggers_post_call()
+ *   ftrace_raw_event_xxx()
+ */
+#define STACK_SKIP 3
+
+static void
+stacktrace_trigger(struct event_trigger_data *data)
+{
+	trace_dump_stack(STACK_SKIP);
+}
+
+static void
+stacktrace_count_trigger(struct event_trigger_data *data)
+{
+	if (!data->count)
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	stacktrace_trigger(data);
+}
+
+static int
+stacktrace_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			 struct event_trigger_data *data)
+{
+	return event_trigger_print("stacktrace", m, (void *)data->count,
+				   data->filter_str);
+}
+
+static struct event_trigger_ops stacktrace_trigger_ops = {
+	.func			= stacktrace_trigger,
+	.print			= stacktrace_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops stacktrace_count_trigger_ops = {
+	.func			= stacktrace_count_trigger,
+	.print			= stacktrace_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_trigger_free,
+};
+
+static struct event_trigger_ops *
+stacktrace_get_trigger_ops(char *cmd, char *param)
+{
+	return param ? &stacktrace_count_trigger_ops : &stacktrace_trigger_ops;
+}
+
+static struct event_command trigger_stacktrace_cmd = {
+	.name			= "stacktrace",
+	.trigger_type		= ETT_STACKTRACE,
+	.post_trigger		= true,
+	.func			= event_trigger_callback,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= stacktrace_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static __init int register_trigger_stacktrace_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_stacktrace_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+#else
+static __init int register_trigger_stacktrace_cmd(void) { return 0; }
+#endif /* CONFIG_STACKTRACE */
+
+static __init void unregister_trigger_traceon_traceoff_cmds(void)
+{
+	unregister_event_command(&trigger_traceon_cmd);
+	unregister_event_command(&trigger_traceoff_cmd);
+}
+
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+struct enable_trigger_data {
+	struct ftrace_event_file	*file;
+	bool				enable;
+};
+
+static void
+event_enable_trigger(struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (enable_data->enable)
+		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &enable_data->file->flags);
+	else
+		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &enable_data->file->flags);
+}
+
+static void
+event_enable_count_trigger(struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (!data->count)
+		return;
+
+	/* Skip if the event is in a state we want to switch to */
+	if (enable_data->enable == !(enable_data->file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+		return;
+
+	if (data->count != -1)
+		(data->count)--;
+
+	event_enable_trigger(data);
+}
+
+static int
+event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			   struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	seq_printf(m, "%s:%s:%s",
+		   enable_data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
+		   enable_data->file->event_call->class->system,
+		   enable_data->file->event_call->name);
+
+	if (data->count == -1)
+		seq_puts(m, ":unlimited");
+	else
+		seq_printf(m, ":count=%ld", data->count);
+
+	if (data->filter_str)
+		seq_printf(m, " if %s\n", data->filter_str);
+	else
+		seq_puts(m, "\n");
+
+	return 0;
+}
+
+static void
+event_enable_trigger_free(struct event_trigger_ops *ops,
+			  struct event_trigger_data *data)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		/* Remove the SOFT_MODE flag */
+		trace_event_enable_disable(enable_data->file, 0, 1);
+		module_put(enable_data->file->event_call->mod);
+		trigger_data_free(data);
+		kfree(enable_data);
+	}
+}
+
+static struct event_trigger_ops event_enable_trigger_ops = {
+	.func			= event_enable_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_enable_count_trigger_ops = {
+	.func			= event_enable_count_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_disable_trigger_ops = {
+	.func			= event_enable_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static struct event_trigger_ops event_disable_count_trigger_ops = {
+	.func			= event_enable_count_trigger,
+	.print			= event_enable_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_enable_trigger_free,
+};
+
+static int
+event_enable_trigger_func(struct event_command *cmd_ops,
+			  struct ftrace_event_file *file,
+			  char *glob, char *cmd, char *param)
+{
+	struct ftrace_event_file *event_enable_file;
+	struct enable_trigger_data *enable_data;
+	struct event_trigger_data *trigger_data;
+	struct event_trigger_ops *trigger_ops;
+	struct trace_array *tr = file->tr;
+	const char *system;
+	const char *event;
+	char *trigger;
+	char *number;
+	bool enable;
+	int ret;
+
+	if (!param)
+		return -EINVAL;
+
+	/* separate the trigger from the filter (s:e:n [if filter]) */
+	trigger = strsep(&param, " \t");
+	if (!trigger)
+		return -EINVAL;
+
+	system = strsep(&trigger, ":");
+	if (!trigger)
+		return -EINVAL;
+
+	event = strsep(&trigger, ":");
+
+	ret = -EINVAL;
+	event_enable_file = find_event_file(tr, system, event);
+	if (!event_enable_file)
+		goto out;
+
+	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	enable_data = kzalloc(sizeof(*enable_data), GFP_KERNEL);
+	if (!enable_data) {
+		kfree(trigger_data);
+		goto out;
+	}
+
+	trigger_data->count = -1;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+	RCU_INIT_POINTER(trigger_data->filter, NULL);
+
+	enable_data->enable = enable;
+	enable_data->file = event_enable_file;
+	trigger_data->private_data = enable_data;
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
+		kfree(trigger_data);
+		kfree(enable_data);
+		ret = 0;
+		goto out;
+	}
+
+	if (trigger) {
+		number = strsep(&trigger, ":");
+
+		ret = -EINVAL;
+		if (!strlen(number))
+			goto out_free;
+
+		/*
+		 * We use the callback data field (which is a pointer)
+		 * as our counter.
+		 */
+		ret = kstrtoul(number, 0, &trigger_data->count);
+		if (ret)
+			goto out_free;
+	}
+
+	if (!param) /* if param is non-empty, it's supposed to be a filter */
+		goto out_reg;
+
+	if (!cmd_ops->set_filter)
+		goto out_reg;
+
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	/* Don't let event modules unload while probe registered */
+	ret = try_module_get(event_enable_file->event_call->mod);
+	if (!ret) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	ret = trace_event_enable_disable(event_enable_file, 1, 1);
+	if (ret < 0)
+		goto out_put;
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_disable;
+	} else if (ret < 0)
+		goto out_disable;
+	/* Just return zero, not the number of enabled functions */
+	ret = 0;
+ out:
+	return ret;
+
+ out_disable:
+	trace_event_enable_disable(event_enable_file, 0, 1);
+ out_put:
+	module_put(event_enable_file->event_call->mod);
+ out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
+	kfree(trigger_data);
+	kfree(enable_data);
+	goto out;
+}
+
+static int event_enable_register_trigger(char *glob,
+					 struct event_trigger_ops *ops,
+					 struct event_trigger_data *data,
+					 struct ftrace_event_file *file)
+{
+	struct enable_trigger_data *enable_data = data->private_data;
+	struct enable_trigger_data *test_enable_data;
+	struct event_trigger_data *test;
+	int ret = 0;
+
+	list_for_each_entry_rcu(test, &file->triggers, list) {
+		test_enable_data = test->private_data;
+		if (test_enable_data &&
+		    (test_enable_data->file == enable_data->file)) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	if (data->ops->init) {
+		ret = data->ops->init(data->ops, data);
+		if (ret < 0)
+			goto out;
+	}
+
+	list_add_rcu(&data->list, &file->triggers);
+	ret++;
+
+	if (trace_event_trigger_enable_disable(file, 1) < 0) {
+		list_del_rcu(&data->list);
+		ret--;
+	}
+	update_cond_flag(file);
+out:
+	return ret;
+}
+
+static void event_enable_unregister_trigger(char *glob,
+					    struct event_trigger_ops *ops,
+					    struct event_trigger_data *test,
+					    struct ftrace_event_file *file)
+{
+	struct enable_trigger_data *test_enable_data = test->private_data;
+	struct enable_trigger_data *enable_data;
+	struct event_trigger_data *data;
+	bool unregistered = false;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		enable_data = data->private_data;
+		if (enable_data &&
+		    (enable_data->file == test_enable_data->file)) {
+			unregistered = true;
+			list_del_rcu(&data->list);
+			update_cond_flag(file);
+			trace_event_trigger_enable_disable(file, 0);
+			break;
+		}
+	}
+
+	if (unregistered && data->ops->free)
+		data->ops->free(data->ops, data);
+}
+
+static struct event_trigger_ops *
+event_enable_get_trigger_ops(char *cmd, char *param)
+{
+	struct event_trigger_ops *ops;
+	bool enable;
+
+	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
+
+	if (enable)
+		ops = param ? &event_enable_count_trigger_ops :
+			&event_enable_trigger_ops;
+	else
+		ops = param ? &event_disable_count_trigger_ops :
+			&event_disable_trigger_ops;
+
+	return ops;
+}
+
+static struct event_command trigger_enable_cmd = {
+	.name			= ENABLE_EVENT_STR,
+	.trigger_type		= ETT_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static struct event_command trigger_disable_cmd = {
+	.name			= DISABLE_EVENT_STR,
+	.trigger_type		= ETT_EVENT_ENABLE,
+	.func			= event_enable_trigger_func,
+	.reg			= event_enable_register_trigger,
+	.unreg			= event_enable_unregister_trigger,
+	.get_trigger_ops	= event_enable_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static __init void unregister_trigger_enable_disable_cmds(void)
+{
+	unregister_event_command(&trigger_enable_cmd);
+	unregister_event_command(&trigger_disable_cmd);
+}
+
+static __init int register_trigger_enable_disable_cmds(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_enable_cmd);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret = register_event_command(&trigger_disable_cmd);
+	if (WARN_ON(ret < 0))
+		unregister_trigger_enable_disable_cmds();
+
+	return ret;
+}
+
+static __init int register_trigger_traceon_traceoff_cmds(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_traceon_cmd);
+	if (WARN_ON(ret < 0))
+		return ret;
+	ret = register_event_command(&trigger_traceoff_cmd);
+	if (WARN_ON(ret < 0))
+		unregister_trigger_traceon_traceoff_cmds();
+
+	return ret;
+}
+
+__init int register_trigger_cmds(void)
+{
+	register_trigger_traceon_traceoff_cmds();
+	register_trigger_snapshot_cmd();
+	register_trigger_stacktrace_cmd();
+	register_trigger_enable_disable_cmds();
+
+	return 0;
+}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index dae9541..bdbae45 100644
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
+	struct trace_probe	tp;
 };
 
 struct event_file_link {
@@ -46,56 +40,46 @@ struct event_file_link {
 	struct list_head		list;
 };
 
-#define SIZEOF_TRACE_PROBE(n)			\
-	(offsetof(struct trace_probe, args) +	\
+#define SIZEOF_TRACE_KPROBE(n)				\
+	(offsetof(struct trace_kprobe, tp.args) +	\
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
@@ -104,45 +88,224 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Memory fetching by symbol */
+struct symbol_cache {
+	char		*symbol;
+	long		offset;
+	unsigned long	addr;
+};
+
+unsigned long update_symbol_cache(struct symbol_cache *sc)
+{
+	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+
+	if (sc->addr)
+		sc->addr += sc->offset;
+
+	return sc->addr;
+}
+
+void free_symbol_cache(struct symbol_cache *sc)
+{
+	kfree(sc->symbol);
+	kfree(sc);
+}
+
+struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+{
+	struct symbol_cache *sc;
+
+	if (!sym || strlen(sym) == 0)
+		return NULL;
+
+	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
+	if (!sc)
+		return NULL;
+
+	sc->symbol = kstrdup(sym, GFP_KERNEL);
+	if (!sc->symbol) {
+		kfree(sc);
+		return NULL;
+	}
+	sc->offset = offset;
+	update_symbol_cache(sc);
+
+	return sc;
+}
+
+/*
+ * Kprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+					  void *addr, void *dest)	\
+{									\
+	type retval;							\
+	if (probe_kernel_address(addr, retval))				\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	long ret;
+	int maxlen = get_rloc_len(*(u32 *)dest);
+	u8 *dst = get_rloc_data(dest);
+	u8 *src = addr;
+	mm_segment_t old_fs = get_fs();
+
+	if (!maxlen)
+		return;
+
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do
+		ret = __copy_from_user_inatomic(dst++, src++, 1);
+	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+
+	dst[-1] = '\0';
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
+	} else {
+		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
+					      get_rloc_offs(*(u32 *)dest));
+	}
+}
+
+/* Return the length of string -- including null terminal byte */
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+							void *addr, void *dest)
+{
+	mm_segment_t old_fs;
+	int ret, len = 0;
+	u8 c;
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do {
+		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
+#define DEFINE_FETCH_symbol(type)					\
+__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
+					  void *data, void *dest)	\
+{									\
+	struct symbol_cache *sc = data;					\
+	if (sc->addr)							\
+		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	else								\
+		*(type *)dest = 0;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(symbol)
+DEFINE_FETCH_symbol(string)
+DEFINE_FETCH_symbol(string_size)
+
+/* kprobes don't support file_offset fetch methods */
+#define fetch_file_offset_u8		NULL
+#define fetch_file_offset_u16		NULL
+#define fetch_file_offset_u32		NULL
+#define fetch_file_offset_u64		NULL
+#define fetch_file_offset_string	NULL
+#define fetch_file_offset_string_size	NULL
+
+/* Fetch type information table */
+const struct fetch_type kprobes_fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),
+	ASSIGN_FETCH_TYPE(u16, u16, 0),
+	ASSIGN_FETCH_TYPE(u32, u32, 0),
+	ASSIGN_FETCH_TYPE(u64, u64, 0),
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),
+	ASSIGN_FETCH_TYPE(s16, u16, 1),
+	ASSIGN_FETCH_TYPE(s32, u32, 1),
+	ASSIGN_FETCH_TYPE(s64, u64, 1),
+
+	ASSIGN_FETCH_TYPE_END
+};
+
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
+	struct trace_kprobe *tk;
 	int ret = -ENOMEM;
 
-	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
-	if (!tp)
+	tk = kzalloc(SIZEOF_TRACE_KPROBE(nargs), GFP_KERNEL);
+	if (!tk)
 		return ERR_PTR(ret);
 
 	if (symbol) {
-		tp->symbol = kstrdup(symbol, GFP_KERNEL);
-		if (!tp->symbol)
+		tk->symbol = kstrdup(symbol, GFP_KERNEL);
+		if (!tk->symbol)
 			goto error;
-		tp->rp.kp.symbol_name = tp->symbol;
-		tp->rp.kp.offset = offs;
+		tk->rp.kp.symbol_name = tk->symbol;
+		tk->rp.kp.offset = offs;
 	} else
-		tp->rp.kp.addr = addr;
+		tk->rp.kp.addr = addr;
 
 	if (is_return)
-		tp->rp.handler = kretprobe_dispatcher;
+		tk->rp.handler = kretprobe_dispatcher;
 	else
-		tp->rp.kp.pre_handler = kprobe_dispatcher;
+		tk->rp.kp.pre_handler = kprobe_dispatcher;
 
 	if (!event || !is_good_name(event)) {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	tp->call.class = &tp->class;
-	tp->call.name = kstrdup(event, GFP_KERNEL);
-	if (!tp->call.name)
+	tk->tp.call.class = &tk->tp.class;
+	tk->tp.call.name = kstrdup(event, GFP_KERNEL);
+	if (!tk->tp.call.name)
 		goto error;
 
 	if (!group || !is_good_name(group)) {
@@ -150,42 +313,42 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->class.system = kstrdup(group, GFP_KERNEL);
-	if (!tp->class.system)
+	tk->tp.class.system = kstrdup(group, GFP_KERNEL);
+	if (!tk->tp.class.system)
 		goto error;
 
-	INIT_LIST_HEAD(&tp->list);
-	INIT_LIST_HEAD(&tp->files);
-	return tp;
+	INIT_LIST_HEAD(&tk->list);
+	INIT_LIST_HEAD(&tk->tp.files);
+	return tk;
 error:
-	kfree(tp->call.name);
-	kfree(tp->symbol);
-	kfree(tp);
+	kfree(tk->tp.call.name);
+	kfree(tk->symbol);
+	kfree(tk);
 	return ERR_PTR(ret);
 }
 
-static void free_trace_probe(struct trace_probe *tp)
+static void free_trace_kprobe(struct trace_kprobe *tk)
 {
 	int i;
 
-	for (i = 0; i < tp->nr_args; i++)
-		traceprobe_free_probe_arg(&tp->args[i]);
+	for (i = 0; i < tk->tp.nr_args; i++)
+		traceprobe_free_probe_arg(&tk->tp.args[i]);
 
-	kfree(tp->call.class->system);
-	kfree(tp->call.name);
-	kfree(tp->symbol);
-	kfree(tp);
+	kfree(tk->tp.call.class->system);
+	kfree(tk->tp.call.name);
+	kfree(tk->symbol);
+	kfree(tk);
 }
 
-static struct trace_probe *find_trace_probe(const char *event,
-					    const char *group)
+static struct trace_kprobe *find_trace_kprobe(const char *event,
+					      const char *group)
 {
-	struct trace_probe *tp;
+	struct trace_kprobe *tk;
 
-	list_for_each_entry(tp, &probe_list, list)
-		if (strcmp(tp->call.name, event) == 0 &&
-		    strcmp(tp->call.class->system, group) == 0)
-			return tp;
+	list_for_each_entry(tk, &probe_list, list)
+		if (strcmp(tk->tp.call.name, event) == 0 &&
+		    strcmp(tk->tp.call.class->system, group) == 0)
+			return tk;
 	return NULL;
 }
 
@@ -194,7 +357,7 @@ static struct trace_probe *find_trace_probe(const char *event,
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
  */
 static int
-enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+enable_trace_kprobe(struct trace_kprobe *tk, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
@@ -208,17 +371,17 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		}
 
 		link->file = file;
-		list_add_tail_rcu(&link->list, &tp->files);
+		list_add_tail_rcu(&link->list, &tk->tp.files);
 
-		tp->flags |= TP_FLAG_TRACE;
+		tk->tp.flags |= TP_FLAG_TRACE;
 	} else
-		tp->flags |= TP_FLAG_PROFILE;
+		tk->tp.flags |= TP_FLAG_PROFILE;
 
-	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
-		if (trace_probe_is_return(tp))
-			ret = enable_kretprobe(&tp->rp);
+	if (trace_probe_is_registered(&tk->tp) && !trace_kprobe_has_gone(tk)) {
+		if (trace_kprobe_is_return(tk))
+			ret = enable_kretprobe(&tk->rp);
 		else
-			ret = enable_kprobe(&tp->rp.kp);
+			ret = enable_kprobe(&tk->rp.kp);
 	}
  out:
 	return ret;
@@ -241,14 +404,14 @@ find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
  * if the file is NULL, disable "perf" handler, or disable "trace" handler.
  */
 static int
-disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
+disable_trace_kprobe(struct trace_kprobe *tk, struct ftrace_event_file *file)
 {
 	struct event_file_link *link = NULL;
 	int wait = 0;
 	int ret = 0;
 
 	if (file) {
-		link = find_event_file_link(tp, file);
+		link = find_event_file_link(&tk->tp, file);
 		if (!link) {
 			ret = -EINVAL;
 			goto out;
@@ -256,18 +419,18 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 
 		list_del_rcu(&link->list);
 		wait = 1;
-		if (!list_empty(&tp->files))
+		if (!list_empty(&tk->tp.files))
 			goto out;
 
-		tp->flags &= ~TP_FLAG_TRACE;
+		tk->tp.flags &= ~TP_FLAG_TRACE;
 	} else
-		tp->flags &= ~TP_FLAG_PROFILE;
+		tk->tp.flags &= ~TP_FLAG_PROFILE;
 
-	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
-		if (trace_probe_is_return(tp))
-			disable_kretprobe(&tp->rp);
+	if (!trace_probe_is_enabled(&tk->tp) && trace_probe_is_registered(&tk->tp)) {
+		if (trace_kprobe_is_return(tk))
+			disable_kretprobe(&tk->rp);
 		else
-			disable_kprobe(&tp->rp.kp);
+			disable_kprobe(&tk->rp.kp);
 		wait = 1;
 	}
  out:
@@ -288,40 +451,40 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 }
 
 /* Internal register function - just handle k*probes and flags */
-static int __register_trace_probe(struct trace_probe *tp)
+static int __register_trace_kprobe(struct trace_kprobe *tk)
 {
 	int i, ret;
 
-	if (trace_probe_is_registered(tp))
+	if (trace_probe_is_registered(&tk->tp))
 		return -EINVAL;
 
-	for (i = 0; i < tp->nr_args; i++)
-		traceprobe_update_arg(&tp->args[i]);
+	for (i = 0; i < tk->tp.nr_args; i++)
+		traceprobe_update_arg(&tk->tp.args[i]);
 
 	/* Set/clear disabled flag according to tp->flag */
-	if (trace_probe_is_enabled(tp))
-		tp->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
+	if (trace_probe_is_enabled(&tk->tp))
+		tk->rp.kp.flags &= ~KPROBE_FLAG_DISABLED;
 	else
-		tp->rp.kp.flags |= KPROBE_FLAG_DISABLED;
+		tk->rp.kp.flags |= KPROBE_FLAG_DISABLED;
 
-	if (trace_probe_is_return(tp))
-		ret = register_kretprobe(&tp->rp);
+	if (trace_kprobe_is_return(tk))
+		ret = register_kretprobe(&tk->rp);
 	else
-		ret = register_kprobe(&tp->rp.kp);
+		ret = register_kprobe(&tk->rp.kp);
 
 	if (ret == 0)
-		tp->flags |= TP_FLAG_REGISTERED;
+		tk->tp.flags |= TP_FLAG_REGISTERED;
 	else {
 		pr_warning("Could not insert probe at %s+%lu: %d\n",
-			   trace_probe_symbol(tp), trace_probe_offset(tp), ret);
-		if (ret == -ENOENT && trace_probe_is_on_module(tp)) {
+			   trace_kprobe_symbol(tk), trace_kprobe_offset(tk), ret);
+		if (ret == -ENOENT && trace_kprobe_is_on_module(tk)) {
 			pr_warning("This probe might be able to register after"
 				   "target module is loaded. Continue.\n");
 			ret = 0;
 		} else if (ret == -EILSEQ) {
 			pr_warning("Probing address(0x%p) is not an "
 				   "instruction boundary.\n",
-				   tp->rp.kp.addr);
+				   tk->rp.kp.addr);
 			ret = -EINVAL;
 		}
 	}
@@ -330,67 +493,67 @@ static int __register_trace_probe(struct trace_probe *tp)
 }
 
 /* Internal unregister function - just handle k*probes and flags */
-static void __unregister_trace_probe(struct trace_probe *tp)
+static void __unregister_trace_kprobe(struct trace_kprobe *tk)
 {
-	if (trace_probe_is_registered(tp)) {
-		if (trace_probe_is_return(tp))
-			unregister_kretprobe(&tp->rp);
+	if (trace_probe_is_registered(&tk->tp)) {
+		if (trace_kprobe_is_return(tk))
+			unregister_kretprobe(&tk->rp);
 		else
-			unregister_kprobe(&tp->rp.kp);
-		tp->flags &= ~TP_FLAG_REGISTERED;
+			unregister_kprobe(&tk->rp.kp);
+		tk->tp.flags &= ~TP_FLAG_REGISTERED;
 		/* Cleanup kprobe for reuse */
-		if (tp->rp.kp.symbol_name)
-			tp->rp.kp.addr = NULL;
+		if (tk->rp.kp.symbol_name)
+			tk->rp.kp.addr = NULL;
 	}
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
-static int unregister_trace_probe(struct trace_probe *tp)
+static int unregister_trace_kprobe(struct trace_kprobe *tk)
 {
 	/* Enabled event can not be unregistered */
-	if (trace_probe_is_enabled(tp))
+	if (trace_probe_is_enabled(&tk->tp))
 		return -EBUSY;
 
 	/* Will fail if probe is being used by ftrace or perf */
-	if (unregister_probe_event(tp))
+	if (unregister_kprobe_event(tk))
 		return -EBUSY;
 
-	__unregister_trace_probe(tp);
-	list_del(&tp->list);
+	__unregister_trace_kprobe(tk);
+	list_del(&tk->list);
 
 	return 0;
 }
 
 /* Register a trace_probe and probe_event */
-static int register_trace_probe(struct trace_probe *tp)
+static int register_trace_kprobe(struct trace_kprobe *tk)
 {
-	struct trace_probe *old_tp;
+	struct trace_kprobe *old_tk;
 	int ret;
 
 	mutex_lock(&probe_lock);
 
 	/* Delete old (same name) event if exist */
-	old_tp = find_trace_probe(tp->call.name, tp->call.class->system);
-	if (old_tp) {
-		ret = unregister_trace_probe(old_tp);
+	old_tk = find_trace_kprobe(tk->tp.call.name, tk->tp.call.class->system);
+	if (old_tk) {
+		ret = unregister_trace_kprobe(old_tk);
 		if (ret < 0)
 			goto end;
-		free_trace_probe(old_tp);
+		free_trace_kprobe(old_tk);
 	}
 
 	/* Register new event */
-	ret = register_probe_event(tp);
+	ret = register_kprobe_event(tk);
 	if (ret) {
 		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
 	/* Register k*probe */
-	ret = __register_trace_probe(tp);
+	ret = __register_trace_kprobe(tk);
 	if (ret < 0)
-		unregister_probe_event(tp);
+		unregister_kprobe_event(tk);
 	else
-		list_add_tail(&tp->list, &probe_list);
+		list_add_tail(&tk->list, &probe_list);
 
 end:
 	mutex_unlock(&probe_lock);
@@ -398,11 +561,11 @@ end:
 }
 
 /* Module notifier call back, checking event on the module */
-static int trace_probe_module_callback(struct notifier_block *nb,
+static int trace_kprobe_module_callback(struct notifier_block *nb,
 				       unsigned long val, void *data)
 {
 	struct module *mod = data;
-	struct trace_probe *tp;
+	struct trace_kprobe *tk;
 	int ret;
 
 	if (val != MODULE_STATE_COMING)
@@ -410,15 +573,15 @@ static int trace_probe_module_callback(struct notifier_block *nb,
 
 	/* Update probes on coming module */
 	mutex_lock(&probe_lock);
-	list_for_each_entry(tp, &probe_list, list) {
-		if (trace_probe_within_module(tp, mod)) {
+	list_for_each_entry(tk, &probe_list, list) {
+		if (trace_kprobe_within_module(tk, mod)) {
 			/* Don't need to check busy - this should have gone. */
-			__unregister_trace_probe(tp);
-			ret = __register_trace_probe(tp);
+			__unregister_trace_kprobe(tk);
+			ret = __register_trace_kprobe(tk);
 			if (ret)
 				pr_warning("Failed to re-register probe %s on"
 					   "%s: %d\n",
-					   tp->call.name, mod->name, ret);
+					   tk->tp.call.name, mod->name, ret);
 		}
 	}
 	mutex_unlock(&probe_lock);
@@ -426,12 +589,12 @@ static int trace_probe_module_callback(struct notifier_block *nb,
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
@@ -451,7 +614,7 @@ static int create_trace_probe(int argc, char **argv)
 	 * Type of args:
 	 *  FETCHARG:TYPE : use TYPE instead of unsigned long.
 	 */
-	struct trace_probe *tp;
+	struct trace_kprobe *tk;
 	int i, ret = 0;
 	bool is_return = false, is_delete = false;
 	char *symbol = NULL, *event = NULL, *group = NULL;
@@ -498,16 +661,16 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		mutex_lock(&probe_lock);
-		tp = find_trace_probe(event, group);
-		if (!tp) {
+		tk = find_trace_kprobe(event, group);
+		if (!tk) {
 			mutex_unlock(&probe_lock);
 			pr_info("Event %s/%s doesn't exist.\n", group, event);
 			return -ENOENT;
 		}
 		/* delete an event */
-		ret = unregister_trace_probe(tp);
+		ret = unregister_trace_kprobe(tk);
 		if (ret == 0)
-			free_trace_probe(tp);
+			free_trace_kprobe(tk);
 		mutex_unlock(&probe_lock);
 		return ret;
 	}
@@ -554,47 +717,49 @@ static int create_trace_probe(int argc, char **argv)
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}
-	tp = alloc_trace_probe(group, event, addr, symbol, offset, argc,
+	tk = alloc_trace_kprobe(group, event, addr, symbol, offset, argc,
 			       is_return);
-	if (IS_ERR(tp)) {
+	if (IS_ERR(tk)) {
 		pr_info("Failed to allocate trace_probe.(%d)\n",
-			(int)PTR_ERR(tp));
-		return PTR_ERR(tp);
+			(int)PTR_ERR(tk));
+		return PTR_ERR(tk);
 	}
 
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		struct probe_arg *parg = &tk->tp.args[i];
+
 		/* Increment count for freeing args in error case */
-		tp->nr_args++;
+		tk->tp.nr_args++;
 
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
+							tk->tp.args, i)) {
 			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -602,7 +767,7 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
+		ret = traceprobe_parse_probe_arg(arg, &tk->tp.size, parg,
 						is_return, true);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
@@ -610,35 +775,35 @@ static int create_trace_probe(int argc, char **argv)
 		}
 	}
 
-	ret = register_trace_probe(tp);
+	ret = register_trace_kprobe(tk);
 	if (ret)
 		goto error;
 	return 0;
 
 error:
-	free_trace_probe(tp);
+	free_trace_kprobe(tk);
 	return ret;
 }
 
-static int release_all_trace_probes(void)
+static int release_all_trace_kprobes(void)
 {
-	struct trace_probe *tp;
+	struct trace_kprobe *tk;
 	int ret = 0;
 
 	mutex_lock(&probe_lock);
 	/* Ensure no probe is in use. */
-	list_for_each_entry(tp, &probe_list, list)
-		if (trace_probe_is_enabled(tp)) {
+	list_for_each_entry(tk, &probe_list, list)
+		if (trace_probe_is_enabled(&tk->tp)) {
 			ret = -EBUSY;
 			goto end;
 		}
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
-		tp = list_entry(probe_list.next, struct trace_probe, list);
-		ret = unregister_trace_probe(tp);
+		tk = list_entry(probe_list.next, struct trace_kprobe, list);
+		ret = unregister_trace_kprobe(tk);
 		if (ret)
 			goto end;
-		free_trace_probe(tp);
+		free_trace_kprobe(tk);
 	}
 
 end:
@@ -666,22 +831,22 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 
 static int probes_seq_show(struct seq_file *m, void *v)
 {
-	struct trace_probe *tp = v;
+	struct trace_kprobe *tk = v;
 	int i;
 
-	seq_printf(m, "%c", trace_probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
+	seq_printf(m, "%c", trace_kprobe_is_return(tk) ? 'r' : 'p');
+	seq_printf(m, ":%s/%s", tk->tp.call.class->system, tk->tp.call.name);
 
-	if (!tp->symbol)
-		seq_printf(m, " 0x%p", tp->rp.kp.addr);
-	else if (tp->rp.kp.offset)
-		seq_printf(m, " %s+%u", trace_probe_symbol(tp),
-			   tp->rp.kp.offset);
+	if (!tk->symbol)
+		seq_printf(m, " 0x%p", tk->rp.kp.addr);
+	else if (tk->rp.kp.offset)
+		seq_printf(m, " %s+%u", trace_kprobe_symbol(tk),
+			   tk->rp.kp.offset);
 	else
-		seq_printf(m, " %s", trace_probe_symbol(tp));
+		seq_printf(m, " %s", trace_kprobe_symbol(tk));
 
-	for (i = 0; i < tp->nr_args; i++)
-		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
+	for (i = 0; i < tk->tp.nr_args; i++)
+		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
 	seq_printf(m, "\n");
 
 	return 0;
@@ -699,7 +864,7 @@ static int probes_open(struct inode *inode, struct file *file)
 	int ret;
 
 	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
-		ret = release_all_trace_probes();
+		ret = release_all_trace_kprobes();
 		if (ret < 0)
 			return ret;
 	}
@@ -711,7 +876,7 @@ static ssize_t probes_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
 	return traceprobe_probes_write(file, buffer, count, ppos,
-			create_trace_probe);
+			create_trace_kprobe);
 }
 
 static const struct file_operations kprobe_events_ops = {
@@ -726,10 +891,10 @@ static const struct file_operations kprobe_events_ops = {
 /* Probes profiling interfaces */
 static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
-	struct trace_probe *tp = v;
+	struct trace_kprobe *tk = v;
 
-	seq_printf(m, "  %-44s %15lu %15lu\n", tp->call.name, tp->nhit,
-		   tp->rp.kp.nmissed);
+	seq_printf(m, "  %-44s %15lu %15lu\n", tk->tp.call.name, tk->nhit,
+		   tk->rp.kp.nmissed);
 
 	return 0;
 }
@@ -754,57 +919,9 @@ static const struct file_operations kprobe_profile_ops = {
 	.release        = seq_release,
 };
 
-/* Sum up total data length for dynamic arraies (strings) */
-static __kprobes int __get_data_size(struct trace_probe *tp,
-				     struct pt_regs *regs)
-{
-	int i, ret = 0;
-	u32 len;
-
-	for (i = 0; i < tp->nr_args; i++)
-		if (unlikely(tp->args[i].fetch_size.fn)) {
-			call_fetch(&tp->args[i].fetch_size, regs, &len);
-			ret += len;
-		}
-
-	return ret;
-}
-
-/* Store the value of each argument */
-static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
-				       struct pt_regs *regs,
-				       u8 *data, int maxlen)
-{
-	int i;
-	u32 end = tp->size;
-	u32 *dl;	/* Data (relative) location */
-
-	for (i = 0; i < tp->nr_args; i++) {
-		if (unlikely(tp->args[i].fetch_size.fn)) {
-			/*
-			 * First, we set the relative location and
-			 * maximum data length to *dl
-			 */
-			dl = (u32 *)(data + tp->args[i].offset);
-			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
-			/* Then try to fetch string or dynamic array data */
-			call_fetch(&tp->args[i].fetch, regs, dl);
-			/* Reduce maximum length */
-			end += get_rloc_len(*dl);
-			maxlen -= get_rloc_len(*dl);
-			/* Trick here, convert data_rloc to data_loc */
-			*dl = convert_rloc_to_loc(*dl,
-				 ent_size + tp->args[i].offset);
-		} else
-			/* Just fetching data normally */
-			call_fetch(&tp->args[i].fetch, regs,
-				   data + tp->args[i].offset);
-	}
-}
-
 /* Kprobe handler */
 static __kprobes void
-__kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
+__kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 		    struct ftrace_event_file *ftrace_file)
 {
 	struct kprobe_trace_entry_head *entry;
@@ -812,18 +929,18 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	struct ring_buffer *buffer;
 	int size, dsize, pc;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if (ftrace_trigger_soft_disabled(ftrace_file))
 		return;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tk->tp, regs);
+	size = sizeof(*entry) + tk->tp.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -832,26 +949,25 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->ip = (unsigned long)tp->rp.kp.addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	entry->ip = (unsigned long)tk->rp.kp.addr;
+	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_buffer_unlock_commit_regs(buffer, event,
-						irq_flags, pc, regs);
+	event_trigger_unlock_commit_regs(ftrace_file, buffer, event,
+					 entry, irq_flags, pc, regs);
 }
 
 static __kprobes void
-kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs)
 {
 	struct event_file_link *link;
 
-	list_for_each_entry_rcu(link, &tp->files, list)
-		__kprobe_trace_func(tp, regs, link->file);
+	list_for_each_entry_rcu(link, &tk->tp.files, list)
+		__kprobe_trace_func(tk, regs, link->file);
 }
 
 /* Kretprobe handler */
 static __kprobes void
-__kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+__kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		       struct pt_regs *regs,
 		       struct ftrace_event_file *ftrace_file)
 {
@@ -860,18 +976,18 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	struct ring_buffer *buffer;
 	int size, pc, dsize;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tk->tp.call;
 
 	WARN_ON(call != ftrace_file->event_call);
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if (ftrace_trigger_soft_disabled(ftrace_file))
 		return;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(tp, regs);
-	size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tk->tp, regs);
+	size = sizeof(*entry) + tk->tp.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
@@ -880,23 +996,22 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->func = (unsigned long)tp->rp.kp.addr;
+	entry->func = (unsigned long)tk->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_buffer_unlock_commit_regs(buffer, event,
-						irq_flags, pc, regs);
+	event_trigger_unlock_commit_regs(ftrace_file, buffer, event,
+					 entry, irq_flags, pc, regs);
 }
 
 static __kprobes void
-kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
 	struct event_file_link *link;
 
-	list_for_each_entry_rcu(link, &tp->files, list)
-		__kretprobe_trace_func(tp, ri, regs, link->file);
+	list_for_each_entry_rcu(link, &tk->tp.files, list)
+		__kretprobe_trace_func(tk, ri, regs, link->file);
 }
 
 /* Event entry printers */
@@ -983,16 +1098,18 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kprobe_trace_entry_head field;
-	struct trace_probe *tp = (struct trace_probe *)event_call->data;
+	struct trace_kprobe *tk = (struct trace_kprobe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
-					 tp->args[i].name,
-					 sizeof(field) + tp->args[i].offset,
-					 tp->args[i].type->size,
-					 tp->args[i].type->is_signed,
+	for (i = 0; i < tk->tp.nr_args; i++) {
+		struct probe_arg *parg = &tk->tp.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name,
+					 sizeof(field) + parg->offset,
+					 parg->type->size,
+					 parg->type->is_signed,
 					 FILTER_OTHER);
 		if (ret)
 			return ret;
@@ -1004,17 +1121,19 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kretprobe_trace_entry_head field;
-	struct trace_probe *tp = (struct trace_probe *)event_call->data;
+	struct trace_kprobe *tk = (struct trace_kprobe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
-					 tp->args[i].name,
-					 sizeof(field) + tp->args[i].offset,
-					 tp->args[i].type->size,
-					 tp->args[i].type->is_signed,
+	for (i = 0; i < tk->tp.nr_args; i++) {
+		struct probe_arg *parg = &tk->tp.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name,
+					 sizeof(field) + parg->offset,
+					 parg->type->size,
+					 parg->type->is_signed,
 					 FILTER_OTHER);
 		if (ret)
 			return ret;
@@ -1022,74 +1141,13 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
-{
-	int i;
-	int pos = 0;
-
-	const char *fmt, *arg;
-
-	if (!trace_probe_is_return(tp)) {
-		fmt = "(%lx)";
-		arg = "REC->" FIELD_STRING_IP;
-	} else {
-		fmt = "(%lx <- %lx)";
-		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
-	}
-
-	/* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
-
-	for (i = 0; i < tp->nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tp->args[i].name, tp->args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tp->nr_args; i++) {
-		if (strcmp(tp->args[i].type->name, "string") == 0)
-			pos += snprintf(buf + pos, LEN_OR_ZERO,
-					", __get_str(%s)",
-					tp->args[i].name);
-		else
-			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-					tp->args[i].name);
-	}
-
-#undef LEN_OR_ZERO
-
-	/* return the length of print_fmt */
-	return pos;
-}
-
-static int set_print_fmt(struct trace_probe *tp)
-{
-	int len;
-	char *print_fmt;
-
-	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tp, NULL, 0);
-	print_fmt = kmalloc(len + 1, GFP_KERNEL);
-	if (!print_fmt)
-		return -ENOMEM;
-
-	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tp, print_fmt, len + 1);
-	tp->call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
 static __kprobes void
-kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
+kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tk->tp.call;
 	struct kprobe_trace_entry_head *entry;
 	struct hlist_head *head;
 	int size, __size, dsize;
@@ -1099,8 +1157,8 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tk->tp, regs);
+	__size = sizeof(*entry) + tk->tp.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
@@ -1108,18 +1166,18 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	if (!entry)
 		return;
 
-	entry->ip = (unsigned long)tp->rp.kp.addr;
+	entry->ip = (unsigned long)tk->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 
 /* Kretprobe profile handler */
 static __kprobes void
-kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		    struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tk->tp.call;
 	struct kretprobe_trace_entry_head *entry;
 	struct hlist_head *head;
 	int size, __size, dsize;
@@ -1129,8 +1187,8 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(tp, regs);
-	__size = sizeof(*entry) + tp->size + dsize;
+	dsize = __get_data_size(&tk->tp, regs);
+	__size = sizeof(*entry) + tk->tp.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 
@@ -1138,9 +1196,9 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	if (!entry)
 		return;
 
-	entry->func = (unsigned long)tp->rp.kp.addr;
+	entry->func = (unsigned long)tk->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
@@ -1155,20 +1213,20 @@ static __kprobes
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
-	struct trace_probe *tp = (struct trace_probe *)event->data;
+	struct trace_kprobe *tk = (struct trace_kprobe *)event->data;
 	struct ftrace_event_file *file = data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return enable_trace_probe(tp, file);
+		return enable_trace_kprobe(tk, file);
 	case TRACE_REG_UNREGISTER:
-		return disable_trace_probe(tp, file);
+		return disable_trace_kprobe(tk, file);
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return enable_trace_probe(tp, NULL);
+		return enable_trace_kprobe(tk, NULL);
 	case TRACE_REG_PERF_UNREGISTER:
-		return disable_trace_probe(tp, NULL);
+		return disable_trace_kprobe(tk, NULL);
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
 	case TRACE_REG_PERF_ADD:
@@ -1182,15 +1240,15 @@ int kprobe_register(struct ftrace_event_call *event,
 static __kprobes
 int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
+	struct trace_kprobe *tk = container_of(kp, struct trace_kprobe, rp.kp);
 
-	tp->nhit++;
+	tk->nhit++;
 
-	if (tp->flags & TP_FLAG_TRACE)
-		kprobe_trace_func(tp, regs);
+	if (tk->tp.flags & TP_FLAG_TRACE)
+		kprobe_trace_func(tk, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (tp->flags & TP_FLAG_PROFILE)
-		kprobe_perf_func(tp, regs);
+	if (tk->tp.flags & TP_FLAG_PROFILE)
+		kprobe_perf_func(tk, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1198,15 +1256,15 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 static __kprobes
 int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+	struct trace_kprobe *tk = container_of(ri->rp, struct trace_kprobe, rp);
 
-	tp->nhit++;
+	tk->nhit++;
 
-	if (tp->flags & TP_FLAG_TRACE)
-		kretprobe_trace_func(tp, ri, regs);
+	if (tk->tp.flags & TP_FLAG_TRACE)
+		kretprobe_trace_func(tk, ri, regs);
 #ifdef CONFIG_PERF_EVENTS
-	if (tp->flags & TP_FLAG_PROFILE)
-		kretprobe_perf_func(tp, ri, regs);
+	if (tk->tp.flags & TP_FLAG_PROFILE)
+		kretprobe_perf_func(tk, ri, regs);
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
@@ -1219,21 +1277,21 @@ static struct trace_event_functions kprobe_funcs = {
 	.trace		= print_kprobe_event
 };
 
-static int register_probe_event(struct trace_probe *tp)
+static int register_kprobe_event(struct trace_kprobe *tk)
 {
-	struct ftrace_event_call *call = &tp->call;
+	struct ftrace_event_call *call = &tk->tp.call;
 	int ret;
 
 	/* Initialize ftrace_event_call */
 	INIT_LIST_HEAD(&call->class->fields);
-	if (trace_probe_is_return(tp)) {
+	if (trace_kprobe_is_return(tk)) {
 		call->event.funcs = &kretprobe_funcs;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
 		call->event.funcs = &kprobe_funcs;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
-	if (set_print_fmt(tp) < 0)
+	if (set_print_fmt(&tk->tp, trace_kprobe_is_return(tk)) < 0)
 		return -ENOMEM;
 	ret = register_ftrace_event(&call->event);
 	if (!ret) {
@@ -1242,7 +1300,7 @@ static int register_probe_event(struct trace_probe *tp)
 	}
 	call->flags = 0;
 	call->class->reg = kprobe_register;
-	call->data = tp;
+	call->data = tk;
 	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
@@ -1252,14 +1310,14 @@ static int register_probe_event(struct trace_probe *tp)
 	return ret;
 }
 
-static int unregister_probe_event(struct trace_probe *tp)
+static int unregister_kprobe_event(struct trace_kprobe *tk)
 {
 	int ret;
 
 	/* tp->event is unregistered in trace_remove_event_call() */
-	ret = trace_remove_event_call(&tp->call);
+	ret = trace_remove_event_call(&tk->tp.call);
 	if (!ret)
-		kfree(tp->call.print_fmt);
+		kfree(tk->tp.call.print_fmt);
 	return ret;
 }
 
@@ -1269,7 +1327,7 @@ static __init int init_kprobe_trace(void)
 	struct dentry *d_tracer;
 	struct dentry *entry;
 
-	if (register_module_notifier(&trace_probe_module_nb))
+	if (register_module_notifier(&trace_kprobe_module_nb))
 		return -EINVAL;
 
 	d_tracer = tracing_init_dentry();
@@ -1309,26 +1367,26 @@ static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
 }
 
 static struct ftrace_event_file *
-find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
+find_trace_probe_file(struct trace_kprobe *tk, struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
 
 	list_for_each_entry(file, &tr->events, list)
-		if (file->event_call == &tp->call)
+		if (file->event_call == &tk->tp.call)
 			return file;
 
 	return NULL;
 }
 
 /*
- * Nobody but us can call enable_trace_probe/disable_trace_probe at this
+ * Nobody but us can call enable_trace_kprobe/disable_trace_kprobe at this
  * stage, we can do this lockless.
  */
 static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
 	int (*target)(int, int, int, int, int, int);
-	struct trace_probe *tp;
+	struct trace_kprobe *tk;
 	struct ftrace_event_file *file;
 
 	target = kprobe_trace_selftest_target;
@@ -1337,44 +1395,44 @@ static __init int kprobe_trace_self_tests_init(void)
 
 	ret = traceprobe_command("p:testprobe kprobe_trace_selftest_target "
 				  "$stack $stack0 +0($stack)",
-				  create_trace_probe);
+				  create_trace_kprobe);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warn("error on probing function entry.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
-		if (WARN_ON_ONCE(tp == NULL)) {
+		tk = find_trace_kprobe("testprobe", KPROBE_EVENT_SYSTEM);
+		if (WARN_ON_ONCE(tk == NULL)) {
 			pr_warn("error on getting new probe.\n");
 			warn++;
 		} else {
-			file = find_trace_probe_file(tp, top_trace_array());
+			file = find_trace_probe_file(tk, top_trace_array());
 			if (WARN_ON_ONCE(file == NULL)) {
 				pr_warn("error on getting probe file.\n");
 				warn++;
 			} else
-				enable_trace_probe(tp, file);
+				enable_trace_kprobe(tk, file);
 		}
 	}
 
 	ret = traceprobe_command("r:testprobe2 kprobe_trace_selftest_target "
-				  "$retval", create_trace_probe);
+				  "$retval", create_trace_kprobe);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warn("error on probing function return.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
-		tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
-		if (WARN_ON_ONCE(tp == NULL)) {
+		tk = find_trace_kprobe("testprobe2", KPROBE_EVENT_SYSTEM);
+		if (WARN_ON_ONCE(tk == NULL)) {
 			pr_warn("error on getting 2nd new probe.\n");
 			warn++;
 		} else {
-			file = find_trace_probe_file(tp, top_trace_array());
+			file = find_trace_probe_file(tk, top_trace_array());
 			if (WARN_ON_ONCE(file == NULL)) {
 				pr_warn("error on getting probe file.\n");
 				warn++;
 			} else
-				enable_trace_probe(tp, file);
+				enable_trace_kprobe(tk, file);
 		}
 	}
 
@@ -1384,46 +1442,46 @@ static __init int kprobe_trace_self_tests_init(void)
 	ret = target(1, 2, 3, 4, 5, 6);
 
 	/* Disable trace points before removing it */
-	tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
-	if (WARN_ON_ONCE(tp == NULL)) {
+	tk = find_trace_kprobe("testprobe", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tk == NULL)) {
 		pr_warn("error on getting test probe.\n");
 		warn++;
 	} else {
-		file = find_trace_probe_file(tp, top_trace_array());
+		file = find_trace_probe_file(tk, top_trace_array());
 		if (WARN_ON_ONCE(file == NULL)) {
 			pr_warn("error on getting probe file.\n");
 			warn++;
 		} else
-			disable_trace_probe(tp, file);
+			disable_trace_kprobe(tk, file);
 	}
 
-	tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
-	if (WARN_ON_ONCE(tp == NULL)) {
+	tk = find_trace_kprobe("testprobe2", KPROBE_EVENT_SYSTEM);
+	if (WARN_ON_ONCE(tk == NULL)) {
 		pr_warn("error on getting 2nd test probe.\n");
 		warn++;
 	} else {
-		file = find_trace_probe_file(tp, top_trace_array());
+		file = find_trace_probe_file(tk, top_trace_array());
 		if (WARN_ON_ONCE(file == NULL)) {
 			pr_warn("error on getting probe file.\n");
 			warn++;
 		} else
-			disable_trace_probe(tp, file);
+			disable_trace_kprobe(tk, file);
 	}
 
-	ret = traceprobe_command("-:testprobe", create_trace_probe);
+	ret = traceprobe_command("-:testprobe", create_trace_kprobe);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
 
-	ret = traceprobe_command("-:testprobe2", create_trace_probe);
+	ret = traceprobe_command("-:testprobe2", create_trace_kprobe);
 	if (WARN_ON_ONCE(ret)) {
 		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
 
 end:
-	release_all_trace_probes();
+	release_all_trace_kprobes();
 	if (warn)
 		pr_cont("NG: Some tests are failed. Please check them.\n");
 	else
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959..8364a42 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -35,46 +35,27 @@ const char *reserved_field_names[] = {
 	FIELD_STRING_FUNC,
 };
 
-/* Printing function type */
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
 /* Printing  in basic type function template */
-#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt)				\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
 						const char *name,	\
-						void *data, void *ent)\
+						void *data, void *ent)	\
 {									\
-	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
+	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
 }									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
-
-DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
-
-static inline void *get_rloc_data(u32 *dl)
-{
-	return (u8 *)dl + get_rloc_offs(*dl);
-}
+const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
-/* For data_loc conversion */
-static inline void *get_loc_data(u32 *dl, void *ent)
-{
-	return (u8 *)ent + get_rloc_offs(*dl);
-}
-
-/* For defining macros, define string/string_size types */
-typedef u32 string;
-typedef u32 string_size;
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "0x%Lx")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
 /* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+__kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 						  const char *name,
 						  void *data, void *ent)
 {
@@ -87,18 +68,7 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 					(const char *)get_loc_data(data, ent));
 }
 
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
-
-#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
-/*
- * Define macro for basic types - we don't need to define s* types, because
- * we have to care only about bitwidth at recording time.
- */
-#define DEFINE_BASIC_FETCH_FUNCS(method) \
-DEFINE_FETCH_##method(u8)		\
-DEFINE_FETCH_##method(u16)		\
-DEFINE_FETCH_##method(u32)		\
-DEFINE_FETCH_##method(u64)
+const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
 #define CHECK_FETCH_FUNCS(method, fn)			\
 	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
@@ -111,7 +81,7 @@ DEFINE_FETCH_##method(u64)
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+__kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
 					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
@@ -122,20 +92,8 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 #define fetch_reg_string	NULL
 #define fetch_reg_string_size	NULL
 
-#define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(stack)
-/* No string on the stack entry */
-#define fetch_stack_string	NULL
-#define fetch_stack_string_size	NULL
-
 #define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
 					  void *dummy, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
@@ -145,150 +103,16 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
 #define fetch_retval_string		NULL
 #define fetch_retval_string_size	NULL
 
-#define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
-{									\
-	type retval;							\
-	if (probe_kernel_address(addr, retval))				\
-		*(type *)dest = 0;					\
-	else								\
-		*(type *)dest = retval;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(memory)
-/*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
- * length and relative data location.
- */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
-{
-	long ret;
-	int maxlen = get_rloc_len(*(u32 *)dest);
-	u8 *dst = get_rloc_data(dest);
-	u8 *src = addr;
-	mm_segment_t old_fs = get_fs();
-
-	if (!maxlen)
-		return;
-
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do
-		ret = __copy_from_user_inatomic(dst++, src++, 1);
-	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
-
-	dst[-1] = '\0';
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0) {	/* Failed to fetch string */
-		((u8 *)get_rloc_data(dest))[0] = '\0';
-		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
-	} else {
-		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
-					      get_rloc_offs(*(u32 *)dest));
-	}
-}
-
-/* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
-{
-	mm_segment_t old_fs;
-	int ret, len = 0;
-	u8 c;
-
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do {
-		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0)	/* Failed to check the length */
-		*(u32 *)dest = 0;
-	else
-		*(u32 *)dest = len;
-}
-
-/* Memory fetching by symbol */
-struct symbol_cache {
-	char		*symbol;
-	long		offset;
-	unsigned long	addr;
-};
-
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
-{
-	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
-
-	if (sc->addr)
-		sc->addr += sc->offset;
-
-	return sc->addr;
-}
-
-static void free_symbol_cache(struct symbol_cache *sc)
-{
-	kfree(sc->symbol);
-	kfree(sc);
-}
-
-static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
-{
-	struct symbol_cache *sc;
-
-	if (!sym || strlen(sym) == 0)
-		return NULL;
-
-	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
-	if (!sc)
-		return NULL;
-
-	sc->symbol = kstrdup(sym, GFP_KERNEL);
-	if (!sc->symbol) {
-		kfree(sc);
-		return NULL;
-	}
-	sc->offset = offset;
-	update_symbol_cache(sc);
-
-	return sc;
-}
-
-#define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
-					  void *data, void *dest)	\
-{									\
-	struct symbol_cache *sc = data;					\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
-	else								\
-		*(type *)dest = 0;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(symbol)
-DEFINE_FETCH_symbol(string)
-DEFINE_FETCH_symbol(string_size)
-
 /* Dereference memory access function */
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fetch;
+	fetch_func_t		fetch_size;
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -296,13 +120,26 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		dprm->fetch(regs, (void *)addr, dest);			\
 	} else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
-DEFINE_FETCH_deref(string_size)
+
+__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
+						   void *data, void *dest)
+{
+	struct deref_fetch_param *dprm = data;
+	unsigned long addr;
+
+	call_fetch(&dprm->orig, regs, &addr);
+	if (addr && dprm->fetch_size) {
+		addr += dprm->offset;
+		dprm->fetch_size(regs, (void *)addr, dest);
+	} else
+		*(string_size *)dest = 0;
+}
 
 static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
 {
@@ -329,7 +166,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -374,58 +211,8 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	kfree(data);
 }
 
-/* Default (unsigned long) fetch type */
-#define __DEFAULT_FETCH_TYPE(t) u##t
-#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
-#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
-#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
-
-#define ASSIGN_FETCH_FUNC(method, type)	\
-	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
-
-#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
-	{.name = _name,				\
-	 .size = _size,					\
-	 .is_signed = sign,				\
-	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
-	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
-	 .fmttype = _fmttype,				\
-	 .fetch = {					\
-ASSIGN_FETCH_FUNC(reg, ftype),				\
-ASSIGN_FETCH_FUNC(stack, ftype),			\
-ASSIGN_FETCH_FUNC(retval, ftype),			\
-ASSIGN_FETCH_FUNC(memory, ftype),			\
-ASSIGN_FETCH_FUNC(symbol, ftype),			\
-ASSIGN_FETCH_FUNC(deref, ftype),			\
-ASSIGN_FETCH_FUNC(bitfield, ftype),			\
-	  }						\
-	}
-
-#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
-	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
-
-#define FETCH_TYPE_STRING	0
-#define FETCH_TYPE_STRSIZE	1
-
-/* Fetch type information table */
-static const struct fetch_type fetch_type_table[] = {
-	/* Special types */
-	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
-					sizeof(u32), 1, "__data_loc char[]"),
-	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
-					string_size, sizeof(u32), 0, "u32"),
-	/* Basic types */
-	ASSIGN_FETCH_TYPE(u8,  u8,  0),
-	ASSIGN_FETCH_TYPE(u16, u16, 0),
-	ASSIGN_FETCH_TYPE(u32, u32, 0),
-	ASSIGN_FETCH_TYPE(u64, u64, 0),
-	ASSIGN_FETCH_TYPE(s8,  u8,  1),
-	ASSIGN_FETCH_TYPE(s16, u16, 1),
-	ASSIGN_FETCH_TYPE(s32, u32, 1),
-	ASSIGN_FETCH_TYPE(s64, u64, 1),
-};
-
-static const struct fetch_type *find_fetch_type(const char *type)
+static const struct fetch_type *find_fetch_type(const char *type,
+						const struct fetch_type *ftbl)
 {
 	int i;
 
@@ -446,44 +233,52 @@ static const struct fetch_type *find_fetch_type(const char *type)
 
 		switch (bs) {
 		case 8:
-			return find_fetch_type("u8");
+			return find_fetch_type("u8", ftbl);
 		case 16:
-			return find_fetch_type("u16");
+			return find_fetch_type("u16", ftbl);
 		case 32:
-			return find_fetch_type("u32");
+			return find_fetch_type("u32", ftbl);
 		case 64:
-			return find_fetch_type("u64");
+			return find_fetch_type("u64", ftbl);
 		default:
 			goto fail;
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
-		if (strcmp(type, fetch_type_table[i].name) == 0)
-			return &fetch_type_table[i];
+	for (i = 0; ftbl[i].name; i++) {
+		if (strcmp(type, ftbl[i].name) == 0)
+			return &ftbl[i];
+	}
 
 fail:
 	return NULL;
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
+						 void *dummy, void *dest)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
 
+static __kprobes void fetch_user_stack_address(struct pt_regs *regs,
+					       void *dummy, void *dest)
+{
+	*(unsigned long *)dest = user_stack_pointer(regs);
+}
+
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
-					fetch_func_t orig_fn)
+					    fetch_func_t orig_fn,
+					    const struct fetch_type *ftbl)
 {
 	int i;
 
-	if (type != &fetch_type_table[FETCH_TYPE_STRING])
+	if (type != &ftbl[FETCH_TYPE_STRING])
 		return NULL;	/* Only string type needs size function */
 
 	for (i = 0; i < FETCH_MTD_END; i++)
 		if (type->fetch[i] == orig_fn)
-			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
+			return ftbl[FETCH_TYPE_STRSIZE].fetch[i];
 
 	WARN_ON(1);	/* This should not happen */
 
@@ -516,7 +311,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, bool is_return)
+			    struct fetch_param *f, bool is_return,
+			    bool is_kprobe)
 {
 	int ret = 0;
 	unsigned long param;
@@ -528,13 +324,16 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
-			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
-				f->fn = fetch_stack_address;
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
+				return -EINVAL;
+
+			if (is_kprobe)
+				f->fn = fetch_kernel_stack_address;
 			else
-				ret = -EINVAL;
+				f->fn = fetch_user_stack_address;
 		} else if (isdigit(arg[5])) {
 			ret = kstrtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -552,20 +351,18 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		     struct fetch_param *f, bool is_return, bool is_kprobe)
 {
+	const struct fetch_type *ftbl;
 	unsigned long param;
 	long offset;
 	char *tmp;
-	int ret;
-
-	ret = 0;
+	int ret = 0;
 
-	/* Until uprobe_events supports only reg arguments */
-	if (!is_kprobe && arg[0] != '%')
-		return -EINVAL;
+	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
+	BUG_ON(ftbl == NULL);
 
 	switch (arg[0]) {
 	case '$':
-		ret = parse_probe_vars(arg + 1, t, f, is_return);
+		ret = parse_probe_vars(arg + 1, t, f, is_return, is_kprobe);
 		break;
 
 	case '%':	/* named register */
@@ -577,7 +374,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 
-	case '@':	/* memory or symbol */
+	case '@':	/* memory, file-offset or symbol */
 		if (isdigit(arg[1])) {
 			ret = kstrtoul(arg + 1, 0, &param);
 			if (ret)
@@ -585,7 +382,22 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
+		} else if (arg[1] == '+') {
+			/* kprobes don't support file offsets */
+			if (is_kprobe)
+				return -EINVAL;
+
+			ret = kstrtol(arg + 2, 0, &offset);
+			if (ret)
+				break;
+
+			f->fn = t->fetch[FETCH_MTD_file_offset];
+			f->data = (void *)offset;
 		} else {
+			/* uprobes don't support symbols */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
@@ -616,7 +428,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			struct deref_fetch_param	*dprm;
 			const struct fetch_type		*t2;
 
-			t2 = find_fetch_type(NULL);
+			t2 = find_fetch_type(NULL, ftbl);
 			*tmp = '\0';
 			dprm = kzalloc(sizeof(struct deref_fetch_param), GFP_KERNEL);
 
@@ -624,6 +436,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fetch = t->fetch[FETCH_MTD_memory];
+			dprm->fetch_size = get_fetch_size_function(t,
+							dprm->fetch, ftbl);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
 							is_kprobe);
 			if (ret)
@@ -685,9 +500,13 @@ static int __parse_bitfield_probe_arg(const char *bf,
 int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		struct probe_arg *parg, bool is_return, bool is_kprobe)
 {
+	const struct fetch_type *ftbl;
 	const char *t;
 	int ret;
 
+	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
+	BUG_ON(ftbl == NULL);
+
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
 		return -ENOSPC;
@@ -702,7 +521,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		arg[t - parg->comm] = '\0';
 		t++;
 	}
-	parg->type = find_fetch_type(t);
+	parg->type = find_fetch_type(t, ftbl);
 	if (!parg->type) {
 		pr_info("Unsupported type: %s\n", t);
 		return -EINVAL;
@@ -716,7 +535,8 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 
 	if (ret >= 0) {
 		parg->fetch_size.fn = get_fetch_size_function(parg->type,
-							      parg->fetch.fn);
+							      parg->fetch.fn,
+							      ftbl);
 		parg->fetch_size.data = parg->fetch.data;
 	}
 
@@ -837,3 +657,65 @@ out:
 
 	return ret;
 }
+
+static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
+			   bool is_return)
+{
+	int i;
+	int pos = 0;
+
+	const char *fmt, *arg;
+
+	if (!is_return) {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	} else {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	}
+
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
+				tp->args[i].name, tp->args[i].type->fmt);
+	}
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (strcmp(tp->args[i].type->name, "string") == 0)
+			pos += snprintf(buf + pos, LEN_OR_ZERO,
+					", __get_str(%s)",
+					tp->args[i].name);
+		else
+			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+					tp->args[i].name);
+	}
+
+#undef LEN_OR_ZERO
+
+	/* return the length of print_fmt */
+	return pos;
+}
+
+int set_print_fmt(struct trace_probe *tp, bool is_return)
+{
+	int len;
+	char *print_fmt;
+
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_print_fmt(tp, NULL, 0, is_return);
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_print_fmt(tp, print_fmt, len + 1, is_return);
+	tp->call.print_fmt = print_fmt;
+
+	return 0;
+}
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5c7e09d..b73574a 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -81,6 +81,17 @@
  */
 #define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
 
+static inline void *get_rloc_data(u32 *dl)
+{
+	return (u8 *)dl + get_rloc_offs(*dl);
+}
+
+/* For data_loc conversion */
+static inline void *get_loc_data(u32 *dl, void *ent)
+{
+	return (u8 *)ent + get_rloc_offs(*dl);
+}
+
 /* Data fetch function type */
 typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
 /* Printing function type */
@@ -95,6 +106,7 @@ enum {
 	FETCH_MTD_symbol,
 	FETCH_MTD_deref,
 	FETCH_MTD_bitfield,
+	FETCH_MTD_file_offset,
 	FETCH_MTD_END,
 };
 
@@ -115,6 +127,148 @@ struct fetch_param {
 	void 			*data;
 };
 
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+/* Printing  in basic type function template */
+#define DECLARE_BASIC_PRINT_TYPE_FUNC(type)				\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
+					 const char *name,		\
+					 void *data, void *ent);	\
+extern const char PRINT_TYPE_FMT_NAME(type)[]
+
+DECLARE_BASIC_PRINT_TYPE_FUNC(u8);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u16);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u32);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u64);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s8);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s16);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s32);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s64);
+DECLARE_BASIC_PRINT_TYPE_FUNC(string);
+
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+
+/* Declare macro for basic types */
+#define DECLARE_FETCH_FUNC(method, type)				\
+extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *regs, 	\
+					  void *data, void *dest)
+
+#define DECLARE_BASIC_FETCH_FUNCS(method) 	\
+DECLARE_FETCH_FUNC(method, u8);			\
+DECLARE_FETCH_FUNC(method, u16);		\
+DECLARE_FETCH_FUNC(method, u32);		\
+DECLARE_FETCH_FUNC(method, u64)
+
+DECLARE_BASIC_FETCH_FUNCS(reg);
+#define fetch_reg_string			NULL
+#define fetch_reg_string_size			NULL
+
+DECLARE_BASIC_FETCH_FUNCS(retval);
+#define fetch_retval_string			NULL
+#define fetch_retval_string_size		NULL
+
+DECLARE_BASIC_FETCH_FUNCS(symbol);
+DECLARE_FETCH_FUNC(symbol, string);
+DECLARE_FETCH_FUNC(symbol, string_size);
+
+DECLARE_BASIC_FETCH_FUNCS(deref);
+DECLARE_FETCH_FUNC(deref, string);
+DECLARE_FETCH_FUNC(deref, string_size);
+
+DECLARE_BASIC_FETCH_FUNCS(bitfield);
+#define fetch_bitfield_string			NULL
+#define fetch_bitfield_string_size		NULL
+
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(method) \
+DEFINE_FETCH_##method(u8)		\
+DEFINE_FETCH_##method(u16)		\
+DEFINE_FETCH_##method(u32)		\
+DEFINE_FETCH_##method(u64)
+
+/* Default (unsigned long) fetch type */
+#define __DEFAULT_FETCH_TYPE(t) u##t
+#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
+#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
+#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
+
+#define ASSIGN_FETCH_FUNC(method, type)	\
+	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
+
+#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
+	{.name = _name,				\
+	 .size = _size,					\
+	 .is_signed = sign,				\
+	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
+	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
+	 .fmttype = _fmttype,				\
+	 .fetch = {					\
+ASSIGN_FETCH_FUNC(reg, ftype),				\
+ASSIGN_FETCH_FUNC(stack, ftype),			\
+ASSIGN_FETCH_FUNC(retval, ftype),			\
+ASSIGN_FETCH_FUNC(memory, ftype),			\
+ASSIGN_FETCH_FUNC(symbol, ftype),			\
+ASSIGN_FETCH_FUNC(deref, ftype),			\
+ASSIGN_FETCH_FUNC(bitfield, ftype),			\
+ASSIGN_FETCH_FUNC(file_offset, ftype),			\
+	  }						\
+	}
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+#define ASSIGN_FETCH_TYPE_END {}
+
+#define FETCH_TYPE_STRING	0
+#define FETCH_TYPE_STRSIZE	1
+
+/*
+ * Fetch type information table.
+ * It's declared as a weak symbol due to conditional compilation.
+ */
+extern __weak const struct fetch_type kprobes_fetch_type_table[];
+extern __weak const struct fetch_type uprobes_fetch_type_table[];
+
+#ifdef CONFIG_KPROBE_EVENT
+struct symbol_cache;
+unsigned long update_symbol_cache(struct symbol_cache *sc);
+void free_symbol_cache(struct symbol_cache *sc);
+struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
+#else
+/* uprobes do not support symbol fetch methods */
+#define fetch_symbol_u8			NULL
+#define fetch_symbol_u16		NULL
+#define fetch_symbol_u32		NULL
+#define fetch_symbol_u64		NULL
+#define fetch_symbol_string		NULL
+#define fetch_symbol_string_size	NULL
+
+struct symbol_cache {
+};
+static inline unsigned long __used update_symbol_cache(struct symbol_cache *sc)
+{
+	return 0;
+}
+
+static inline void __used free_symbol_cache(struct symbol_cache *sc)
+{
+}
+
+static inline struct symbol_cache * __used
+alloc_symbol_cache(const char *sym, long offset)
+{
+	return NULL;
+}
+#endif /* CONFIG_KPROBE_EVENT */
+
 struct probe_arg {
 	struct fetch_param	fetch;
 	struct fetch_param	fetch_size;
@@ -124,6 +278,26 @@ struct probe_arg {
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
@@ -158,3 +332,53 @@ extern ssize_t traceprobe_probes_write(struct file *file,
 		int (*createfn)(int, char**));
 
 extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
+
+/* Sum up total data length for dynamic arraies (strings) */
+static inline __kprobes int
+__get_data_size(struct trace_probe *tp, struct pt_regs *regs)
+{
+	int i, ret = 0;
+	u32 len;
+
+	for (i = 0; i < tp->nr_args; i++)
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			ret += len;
+		}
+
+	return ret;
+}
+
+/* Store the value of each argument */
+static inline __kprobes void
+store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
+		 u8 *data, int maxlen)
+{
+	int i;
+	u32 end = tp->size;
+	u32 *dl;	/* Data (relative) location */
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			/*
+			 * First, we set the relative location and
+			 * maximum data length to *dl
+			 */
+			dl = (u32 *)(data + tp->args[i].offset);
+			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
+			/* Then try to fetch string or dynamic array data */
+			call_fetch(&tp->args[i].fetch, regs, dl);
+			/* Reduce maximum length */
+			end += get_rloc_len(*dl);
+			maxlen -= get_rloc_len(*dl);
+			/* Trick here, convert data_rloc to data_loc */
+			*dl = convert_rloc_to_loc(*dl,
+				 ent_size + tp->args[i].offset);
+		} else
+			/* Just fetching data normally */
+			call_fetch(&tp->args[i].fetch, regs,
+				   data + tp->args[i].offset);
+	}
+}
+
+extern int set_print_fmt(struct trace_probe *tp, bool is_return);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index b20428c..e6be585 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -382,7 +382,7 @@ static const struct file_operations stack_trace_filter_fops = {
 	.open = stack_trace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ea90eb5..759d5e0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -321,7 +321,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if (ftrace_trigger_soft_disabled(ftrace_file))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -343,9 +343,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry,
+				    irq_flags, pc);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -369,7 +368,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!ftrace_file)
 		return;
 
-	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+	if (ftrace_trigger_soft_disabled(ftrace_file))
 		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
@@ -390,9 +389,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_check_discard(ftrace_file, entry, buffer, event))
-		trace_current_buffer_unlock_commit(buffer, event,
-						   irq_flags, pc);
+	event_trigger_unlock_commit(ftrace_file, buffer, event, entry,
+				    irq_flags, pc);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index b6dcc42..79e52d9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -51,22 +51,17 @@ struct trace_uprobe_filter {
  */
 struct trace_uprobe {
 	struct list_head		list;
-	struct ftrace_event_class	class;
-	struct ftrace_event_call	call;
 	struct trace_uprobe_filter	filter;
 	struct uprobe_consumer		consumer;
 	struct inode			*inode;
 	char				*filename;
 	unsigned long			offset;
 	unsigned long			nhit;
-	unsigned int			flags;	/* For TP_FLAG_* */
-	ssize_t				size;	/* trace entry size */
-	unsigned int			nr_args;
-	struct probe_arg		args[];
+	struct trace_probe		tp;
 };
 
-#define SIZEOF_TRACE_UPROBE(n)			\
-	(offsetof(struct trace_uprobe, args) +	\
+#define SIZEOF_TRACE_UPROBE(n)				\
+	(offsetof(struct trace_uprobe, tp.args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
 static int register_uprobe_event(struct trace_uprobe *tu);
@@ -75,10 +70,151 @@ static int unregister_uprobe_event(struct trace_uprobe *tu);
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
+struct uprobe_dispatch_data {
+	struct trace_uprobe	*tu;
+	unsigned long		bp_addr;
+};
+
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs);
 
+#ifdef CONFIG_STACK_GROWSUP
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned int n)
+{
+	return addr - (n * sizeof(long));
+}
+#else
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned int n)
+{
+	return addr + (n * sizeof(long));
+}
+#endif
+
+static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
+{
+	unsigned long ret;
+	unsigned long addr = user_stack_pointer(regs);
+
+	addr = adjust_stack_addr(addr, n);
+
+	if (copy_from_user(&ret, (void __force __user *) addr, sizeof(ret)))
+		return 0;
+
+	return ret;
+}
+
+/*
+ * Uprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)get_user_stack_nth(regs,			\
+					      ((unsigned long)offset)); \
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+						void *addr, void *dest) \
+{									\
+	type retval;							\
+	void __user *vaddr = (void __force __user *) addr;		\
+									\
+	if (copy_from_user(&retval, vaddr, sizeof(type)))		\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *) dest = retval;				\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	long ret;
+	u32 rloc = *(u32 *)dest;
+	int maxlen  = get_rloc_len(rloc);
+	u8 *dst = get_rloc_data(dest);
+	void __user *src = (void __force __user *) addr;
+
+	if (!maxlen)
+		return;
+
+	ret = strncpy_from_user(dst, src, maxlen);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(rloc));
+	} else {
+		*(u32 *)dest = make_data_rloc(ret, get_rloc_offs(rloc));
+	}
+}
+
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	int len;
+	void __user *vaddr = (void __force __user *) addr;
+
+	len = strnlen_user(vaddr, MAX_STRING_SIZE);
+
+	if (len == 0 || len > MAX_STRING_SIZE)  /* Failed to check length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
+static unsigned long translate_user_vaddr(void *file_offset)
+{
+	unsigned long base_addr;
+	struct uprobe_dispatch_data *udd;
+
+	udd = (void *) current->utask->vaddr;
+
+	base_addr = udd->bp_addr - udd->tu->offset;
+	return base_addr + (unsigned long)file_offset;
+}
+
+#define DEFINE_FETCH_file_offset(type)					\
+static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
+					void *offset, void *dest) 	\
+{									\
+	void *vaddr = (void *)translate_user_vaddr(offset);		\
+									\
+	FETCH_FUNC_NAME(memory, type)(regs, vaddr, dest);		\
+}
+DEFINE_BASIC_FETCH_FUNCS(file_offset)
+DEFINE_FETCH_file_offset(string)
+DEFINE_FETCH_file_offset(string_size)
+
+/* Fetch type information table */
+const struct fetch_type uprobes_fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),
+	ASSIGN_FETCH_TYPE(u16, u16, 0),
+	ASSIGN_FETCH_TYPE(u32, u32, 0),
+	ASSIGN_FETCH_TYPE(u64, u64, 0),
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),
+	ASSIGN_FETCH_TYPE(s16, u16, 1),
+	ASSIGN_FETCH_TYPE(s32, u32, 1),
+	ASSIGN_FETCH_TYPE(s64, u64, 1),
+
+	ASSIGN_FETCH_TYPE_END
+};
+
 static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
 {
 	rwlock_init(&filter->rwlock);
@@ -114,13 +250,13 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (!tu)
 		return ERR_PTR(-ENOMEM);
 
-	tu->call.class = &tu->class;
-	tu->call.name = kstrdup(event, GFP_KERNEL);
-	if (!tu->call.name)
+	tu->tp.call.class = &tu->tp.class;
+	tu->tp.call.name = kstrdup(event, GFP_KERNEL);
+	if (!tu->tp.call.name)
 		goto error;
 
-	tu->class.system = kstrdup(group, GFP_KERNEL);
-	if (!tu->class.system)
+	tu->tp.class.system = kstrdup(group, GFP_KERNEL);
+	if (!tu->tp.class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tu->list);
@@ -128,11 +264,11 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
-	tu->call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
+	tu->tp.call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
 	return tu;
 
 error:
-	kfree(tu->call.name);
+	kfree(tu->tp.call.name);
 	kfree(tu);
 
 	return ERR_PTR(-ENOMEM);
@@ -142,12 +278,12 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
 {
 	int i;
 
-	for (i = 0; i < tu->nr_args; i++)
-		traceprobe_free_probe_arg(&tu->args[i]);
+	for (i = 0; i < tu->tp.nr_args; i++)
+		traceprobe_free_probe_arg(&tu->tp.args[i]);
 
 	iput(tu->inode);
-	kfree(tu->call.class->system);
-	kfree(tu->call.name);
+	kfree(tu->tp.call.class->system);
+	kfree(tu->tp.call.name);
 	kfree(tu->filename);
 	kfree(tu);
 }
@@ -157,8 +293,8 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 	struct trace_uprobe *tu;
 
 	list_for_each_entry(tu, &uprobe_list, list)
-		if (strcmp(tu->call.name, event) == 0 &&
-		    strcmp(tu->call.class->system, group) == 0)
+		if (strcmp(tu->tp.call.name, event) == 0 &&
+		    strcmp(tu->tp.call.class->system, group) == 0)
 			return tu;
 
 	return NULL;
@@ -181,16 +317,16 @@ static int unregister_trace_uprobe(struct trace_uprobe *tu)
 /* Register a trace_uprobe and probe_event */
 static int register_trace_uprobe(struct trace_uprobe *tu)
 {
-	struct trace_uprobe *old_tp;
+	struct trace_uprobe *old_tu;
 	int ret;
 
 	mutex_lock(&uprobe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
-	if (old_tp) {
+	old_tu = find_probe_event(tu->tp.call.name, tu->tp.call.class->system);
+	if (old_tu) {
 		/* delete old event */
-		ret = unregister_trace_uprobe(old_tp);
+		ret = unregister_trace_uprobe(old_tu);
 		if (ret)
 			goto end;
 	}
@@ -211,7 +347,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
+ *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
@@ -360,34 +496,36 @@ static int create_trace_uprobe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		struct probe_arg *parg = &tu->tp.args[i];
+
 		/* Increment count for freeing args in error case */
-		tu->nr_args++;
+		tu->tp.nr_args++;
 
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
 		if (arg) {
 			*arg++ = '\0';
-			tu->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+			parg->name = kstrdup(argv[i], GFP_KERNEL);
 		} else {
 			arg = argv[i];
 			/* If argument name is omitted, set "argN" */
 			snprintf(buf, MAX_EVENT_NAME_LEN, "arg%d", i + 1);
-			tu->args[i].name = kstrdup(buf, GFP_KERNEL);
+			parg->name = kstrdup(buf, GFP_KERNEL);
 		}
 
-		if (!tu->args[i].name) {
+		if (!parg->name) {
 			pr_info("Failed to allocate argument[%d] name.\n", i);
 			ret = -ENOMEM;
 			goto error;
 		}
 
-		if (!is_good_name(tu->args[i].name)) {
-			pr_info("Invalid argument[%d] name: %s\n", i, tu->args[i].name);
+		if (!is_good_name(parg->name)) {
+			pr_info("Invalid argument[%d] name: %s\n", i, parg->name);
 			ret = -EINVAL;
 			goto error;
 		}
 
-		if (traceprobe_conflict_field_name(tu->args[i].name, tu->args, i)) {
+		if (traceprobe_conflict_field_name(parg->name, tu->tp.args, i)) {
 			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -395,7 +533,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i], false, false);
+		ret = traceprobe_parse_probe_arg(arg, &tu->tp.size, parg,
+						 is_return, false);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
@@ -459,11 +598,11 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char c = is_ret_probe(tu) ? 'r' : 'p';
 	int i;
 
-	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", c, tu->tp.call.class->system, tu->tp.call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
-	for (i = 0; i < tu->nr_args; i++)
-		seq_printf(m, " %s=%s", tu->args[i].name, tu->args[i].comm);
+	for (i = 0; i < tu->tp.nr_args; i++)
+		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
 
 	seq_printf(m, "\n");
 	return 0;
@@ -509,7 +648,7 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
 
-	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->call.name, tu->nhit);
+	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->tp.call.name, tu->nhit);
 	return 0;
 }
 
@@ -533,21 +672,117 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
+struct uprobe_cpu_buffer {
+	struct mutex mutex;
+	void *buf;
+};
+static struct uprobe_cpu_buffer __percpu *uprobe_cpu_buffer;
+static int uprobe_buffer_refcnt;
+
+static int uprobe_buffer_init(void)
+{
+	int cpu, err_cpu;
+
+	uprobe_cpu_buffer = alloc_percpu(struct uprobe_cpu_buffer);
+	if (uprobe_cpu_buffer == NULL)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct page *p = alloc_pages_node(cpu_to_node(cpu),
+						  GFP_KERNEL, 0);
+		if (p == NULL) {
+			err_cpu = cpu;
+			goto err;
+		}
+		per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf = page_address(p);
+		mutex_init(&per_cpu_ptr(uprobe_cpu_buffer, cpu)->mutex);
+	}
+
+	return 0;
+
+err:
+	for_each_possible_cpu(cpu) {
+		if (cpu == err_cpu)
+			break;
+		free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
+	}
+
+	free_percpu(uprobe_cpu_buffer);
+	return -ENOMEM;
+}
+
+static int uprobe_buffer_enable(void)
+{
+	int ret = 0;
+
+	BUG_ON(!mutex_is_locked(&event_mutex));
+
+	if (uprobe_buffer_refcnt++ == 0) {
+		ret = uprobe_buffer_init();
+		if (ret < 0)
+			uprobe_buffer_refcnt--;
+	}
+
+	return ret;
+}
+
+static void uprobe_buffer_disable(void)
+{
+	BUG_ON(!mutex_is_locked(&event_mutex));
+
+	if (--uprobe_buffer_refcnt == 0) {
+		free_percpu(uprobe_cpu_buffer);
+		uprobe_cpu_buffer = NULL;
+	}
+}
+
+static struct uprobe_cpu_buffer *uprobe_buffer_get(void)
+{
+	struct uprobe_cpu_buffer *ucb;
+	int cpu;
+
+	cpu = raw_smp_processor_id();
+	ucb = per_cpu_ptr(uprobe_cpu_buffer, cpu);
+
+	/*
+	 * Use per-cpu buffers for fastest access, but we might migrate
+	 * so the mutex makes sure we have sole access to it.
+	 */
+	mutex_lock(&ucb->mutex);
+
+	return ucb;
+}
+
+static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
+{
+	mutex_unlock(&ucb->mutex);
+}
+
 static void uprobe_trace_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, i;
-	struct ftrace_event_call *call = &tu->call;
+	int size, dsize, esize;
+	struct ftrace_event_call *call = &tu->tp.call;
+
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->tp.size + dsize > PAGE_SIZE))
+		return;
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
+
+	size = esize + tu->tp.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->size, 0, 0);
+						  size, 0, 0);
 	if (!event)
-		return;
+		goto out;
 
 	entry = ring_buffer_event_data(event);
 	if (is_ret_probe(tu)) {
@@ -559,11 +794,13 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+	memcpy(data, ucb->buf, tu->tp.size + dsize);
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
+
+out:
+	uprobe_buffer_put(ucb);
 }
 
 /* uprobe handler */
@@ -591,23 +828,24 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	int i;
 
 	entry = (struct uprobe_trace_entry_head *)iter->ent;
-	tu = container_of(event, struct trace_uprobe, call.event);
+	tu = container_of(event, struct trace_uprobe, tp.call.event);
 
 	if (is_ret_probe(tu)) {
-		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
+		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->tp.call.name,
 					entry->vaddr[1], entry->vaddr[0]))
 			goto partial;
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
+		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->tp.call.name,
 					entry->vaddr[0]))
 			goto partial;
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++) {
-		if (!tu->args[i].type->print(s, tu->args[i].name,
-					     data + tu->args[i].offset, entry))
+	for (i = 0; i < tu->tp.nr_args; i++) {
+		struct probe_arg *parg = &tu->tp.args[i];
+
+		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
 			goto partial;
 	}
 
@@ -618,11 +856,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
-{
-	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
-}
-
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
@@ -632,29 +865,35 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 {
 	int ret = 0;
 
-	if (is_trace_uprobe_enabled(tu))
+	if (trace_probe_is_enabled(&tu->tp))
 		return -EINTR;
 
+	ret = uprobe_buffer_enable();
+	if (ret < 0)
+		return ret;
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
-	tu->flags |= flag;
+	tu->tp.flags |= flag;
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
 	if (ret)
-		tu->flags &= ~flag;
+		tu->tp.flags &= ~flag;
 
 	return ret;
 }
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!is_trace_uprobe_enabled(tu))
+	if (!trace_probe_is_enabled(&tu->tp))
 		return;
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
-	tu->flags &= ~flag;
+	tu->tp.flags &= ~flag;
+
+	uprobe_buffer_disable();
 }
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
@@ -672,12 +911,12 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 		size = SIZEOF_TRACE_ENTRY(false);
 	}
 	/* Set argument names as fields */
-	for (i = 0; i < tu->nr_args; i++) {
-		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
-					 tu->args[i].name,
-					 size + tu->args[i].offset,
-					 tu->args[i].type->size,
-					 tu->args[i].type->is_signed,
+	for (i = 0; i < tu->tp.nr_args; i++) {
+		struct probe_arg *parg = &tu->tp.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name, size + parg->offset,
+					 parg->type->size, parg->type->is_signed,
 					 FILTER_OTHER);
 
 		if (ret)
@@ -686,59 +925,6 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 	return 0;
 }
 
-#define LEN_OR_ZERO		(len ? len - pos : 0)
-static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
-{
-	const char *fmt, *arg;
-	int i;
-	int pos = 0;
-
-	if (is_ret_probe(tu)) {
-		fmt = "(%lx <- %lx)";
-		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
-	} else {
-		fmt = "(%lx)";
-		arg = "REC->" FIELD_STRING_IP;
-	}
-
-	/* When len=0, we just calculate the needed length */
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
-
-	for (i = 0; i < tu->nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tu->args[i].name, tu->args[i].type->fmt);
-	}
-
-	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
-
-	for (i = 0; i < tu->nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-				tu->args[i].name);
-	}
-
-	return pos;	/* return the length of print_fmt */
-}
-#undef LEN_OR_ZERO
-
-static int set_print_fmt(struct trace_uprobe *tu)
-{
-	char *print_fmt;
-	int len;
-
-	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tu, NULL, 0);
-	print_fmt = kmalloc(len + 1, GFP_KERNEL);
-	if (!print_fmt)
-		return -ENOMEM;
-
-	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tu, print_fmt, len + 1);
-	tu->call.print_fmt = print_fmt;
-
-	return 0;
-}
-
 #ifdef CONFIG_PERF_EVENTS
 static bool
 __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
@@ -831,14 +1017,27 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 static void uprobe_perf_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->tp.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
+	struct uprobe_cpu_buffer *ucb;
 	void *data;
-	int size, rctx, i;
+	int size, dsize, esize;
+	int rctx;
 
-	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	dsize = __get_data_size(&tu->tp, regs);
+	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+
+	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
+		return;
+
+	size = esize + tu->tp.size + dsize;
+	size = ALIGN(size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
+		return;
+
+	ucb = uprobe_buffer_get();
+	store_trace_args(esize, &tu->tp, regs, ucb->buf, dsize);
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
@@ -858,12 +1057,18 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+	memcpy(data, ucb->buf, tu->tp.size + dsize);
+
+	if (size - esize > tu->tp.size + dsize) {
+		int len = tu->tp.size + dsize;
+
+		memset(data + len, 0, size - esize - len);
+	}
 
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
+	uprobe_buffer_put(ucb);
 }
 
 /* uprobe profile handler */
@@ -921,16 +1126,22 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_dispatch_data udd;
 	int ret = 0;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
-	if (tu->flags & TP_FLAG_TRACE)
+	udd.tu = tu;
+	udd.bp_addr = instruction_pointer(regs);
+
+	current->utask->vaddr = (unsigned long) &udd;
+
+	if (tu->tp.flags & TP_FLAG_TRACE)
 		ret |= uprobe_trace_func(tu, regs);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (tu->flags & TP_FLAG_PROFILE)
+	if (tu->tp.flags & TP_FLAG_PROFILE)
 		ret |= uprobe_perf_func(tu, regs);
 #endif
 	return ret;
@@ -940,14 +1151,20 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct trace_uprobe *tu;
+	struct uprobe_dispatch_data udd;
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
-	if (tu->flags & TP_FLAG_TRACE)
+	udd.tu = tu;
+	udd.bp_addr = func;
+
+	current->utask->vaddr = (unsigned long) &udd;
+
+	if (tu->tp.flags & TP_FLAG_TRACE)
 		uretprobe_trace_func(tu, func, regs);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (tu->flags & TP_FLAG_PROFILE)
+	if (tu->tp.flags & TP_FLAG_PROFILE)
 		uretprobe_perf_func(tu, func, regs);
 #endif
 	return 0;
@@ -959,7 +1176,7 @@ static struct trace_event_functions uprobe_funcs = {
 
 static int register_uprobe_event(struct trace_uprobe *tu)
 {
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->tp.call;
 	int ret;
 
 	/* Initialize ftrace_event_call */
@@ -967,7 +1184,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 	call->event.funcs = &uprobe_funcs;
 	call->class->define_fields = uprobe_event_define_fields;
 
-	if (set_print_fmt(tu) < 0)
+	if (set_print_fmt(&tu->tp, is_ret_probe(tu)) < 0)
 		return -ENOMEM;
 
 	ret = register_ftrace_event(&call->event);
@@ -994,11 +1211,11 @@ static int unregister_uprobe_event(struct trace_uprobe *tu)
 	int ret;
 
 	/* tu->event is unregistered in trace_remove_event_call() */
-	ret = trace_remove_event_call(&tu->call);
+	ret = trace_remove_event_call(&tu->tp.call);
 	if (ret)
 		return ret;
-	kfree(tu->call.print_fmt);
-	tu->call.print_fmt = NULL;
+	kfree(tu->tp.call.print_fmt);
+	tu->tp.call.print_fmt = NULL;
 	return 0;
 }
 
