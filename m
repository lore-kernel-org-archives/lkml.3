Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3HVT7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:59:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:8380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab3HVT6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="366995309"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v5 09/10] tracing: add documentation for trace event triggers
Date: Thu, 22 Aug 2013 14:57:42 -0500
Message-Id: <fc3a6f587ac6be8af67194ecf93402271bda6fcc.1377183739.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1377183739.git.tom.zanussi@linux.intel.com>
References: <cover.1377183739.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a basic overview of trace event triggers and document the
available trigger commands, along with a few simple examples.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 Documentation/trace/events.txt | 207 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 207 insertions(+)

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
-- 
1.7.11.4

