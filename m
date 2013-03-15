Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3COTvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:51:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3COTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:30 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XVHfoNyK8BMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AKE7BAHAN7sA:10 a=6OGh4nRmbv8vFL1Y6JUA:9 a=QEXdDO2ut3YA:10 a=HYwA_318O_0A:10 a=jeBq3FmKZ4MA:10 a=vQNUPMucJ1ol-Cho:21 a=rzXQjN2SOofeLaYK:21 a=WAicF9d73_OXBJpb:21 a=Ra1Cl3hiiV8702NEp94A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195125.922922040@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 20/20] tracing: Bring Documentation/trace/ftrace.txt up to date
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0020-tracing-Bring-Documentation-trace-ftrace.txt-up-to-d.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The ftrace.txt document has been suffering from some serious bit rot.

Updated the current content to how things are as of v3.10.
Remove things that no longer exist.
Add documentation about new features:
  per_cpu
  stats
  instances
  stack trace
  etc.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt | 2097 ++++++++++++++++++++++++++++--------=
----
 1 file changed, 1480 insertions(+), 617 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index a372304..bfe8c29 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -8,6 +8,7 @@ Copyright 2008 Red Hat Inc.
 Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
 	     John Kacur, and David Teigland.
 Written for: 2.6.28-rc2
+Updated for: 3.10
=20
 Introduction
 ------------
@@ -17,13 +18,16 @@ designers of systems to find what is going on inside th=
e kernel.
 It can be used for debugging or analyzing latencies and
 performance issues that take place outside of user-space.
=20
-Although ftrace is the function tracer, it also includes an
-infrastructure that allows for other types of tracing. Some of
-the tracers that are currently in ftrace include a tracer to
-trace context switches, the time it takes for a high priority
-task to run after it was woken up, the time interrupts are
-disabled, and more (ftrace allows for tracer plugins, which
-means that the list of tracers can always grow).
+Although ftrace is typically considered the function tracer, it
+is really a frame work of several assorted tracing utilities.
+There's latency tracing to examine what occurs between interrupts
+disabled and enabled, as well as for preemption and from a time
+a task is woken to the task is actually scheduled in.
+
+One of the most common uses of ftrace is the event tracing.
+Through out the kernel is hundreds of static event points that
+can be enabled via the debugfs file system to see what is
+going on in certain parts of the kernel.
=20
=20
 Implementation Details
@@ -61,7 +65,7 @@ the extended "/sys/kernel/debug/tracing" path name.
=20
 That's it! (assuming that you have ftrace configured into your kernel)
=20
-After mounting the debugfs, you can see a directory called
+After mounting debugfs, you can see a directory called
 "tracing".  This directory contains the control and output files
 of ftrace. Here is a list of some of the key files:
=20
@@ -84,7 +88,9 @@ of ftrace. Here is a list of some of the key files:
=20
 	This sets or displays whether writing to the trace
 	ring buffer is enabled. Echo 0 into this file to disable
-	the tracer or 1 to enable it.
+	the tracer or 1 to enable it. Note, this only disables
+	writing to the ring buffer, the tracing overhead may
+	still be occurring.
=20
   trace:
=20
@@ -109,7 +115,15 @@ of ftrace. Here is a list of some of the key files:
=20
 	This file lets the user control the amount of data
 	that is displayed in one of the above output
-	files.
+	files. Options also exist to modify how a tracer
+	or events work (stack traces, timestamps, etc).
+
+  options:
+
+	This is a directory that has a file for every available
+	trace option (also in trace_options). Options may also be set
+	or cleared by writing a "1" or "0" respectively into the
+	corresponding file with the option name.
=20
   tracing_max_latency:
=20
@@ -121,10 +135,17 @@ of ftrace. Here is a list of some of the key files:
 	latency is greater than the value in this
 	file. (in microseconds)
=20
+  tracing_thresh:
+
+	Some latency tracers will record a trace whenever the
+	latency is greater than the number in this file.
+	Only active when the file contains a number greater than 0.
+	(in microseconds)
+
   buffer_size_kb:
=20
 	This sets or displays the number of kilobytes each CPU
-	buffer can hold. The tracer buffers are the same size
+	buffer holds. By default, the trace buffers are the same size
 	for each CPU. The displayed number is the size of the
 	CPU buffer and not total size of all buffers. The
 	trace buffers are allocated in pages (blocks of memory
@@ -133,16 +154,30 @@ of ftrace. Here is a list of some of the key files:
 	than requested, the rest of the page will be used,
 	making the actual allocation bigger than requested.
 	( Note, the size may not be a multiple of the page size
-	  due to buffer management overhead. )
+	  due to buffer management meta-data. )
=20
-	This can only be updated when the current_tracer
-	is set to "nop".
+  buffer_total_size_kb:
+
+	This displays the total combined size of all the trace buffers.
+
+  free_buffer:
+
+	If a process is performing the tracing, and the ring buffer
+	should be shrunk "freed" when the process is finished, even
+	if it were to be killed by a signal, this file can be used
+	for that purpose. On close of this file, the ring buffer will
+	be resized to its minimum size. Having a process that is tracing
+	also open this file, when the process exits its file descriptor
+	for this file will be closed, and in doing so, the ring buffer
+	will be "freed".
+
+	It may also stop tracing if disable_on_free option is set.
=20
   tracing_cpumask:
=20
 	This is a mask that lets the user only trace
-	on specified CPUS. The format is a hex string
-	representing the CPUS.
+	on specified CPUs. The format is a hex string
+	representing the CPUs.
=20
   set_ftrace_filter:
=20
@@ -183,6 +218,261 @@ of ftrace. Here is a list of some of the key files:
 	"set_ftrace_notrace". (See the section "dynamic ftrace"
 	below for more details.)
=20
+  enabled_functions:
+
+	This file is more for debugging ftrace, but can also be useful
+	in seeing if any function has a callback attached to it.
+	Not only does the trace infrastructure use ftrace function
+	trace utility, but other subsystems might too. This file
+	displays all functions that have a callback attached to them
+	as well as the number of callbacks that have been attached.
+	Note, a callback may also call multiple functions which will
+	not be listed in this count.
+
+	If the callback registered to be traced by a function with
+	the "save regs" attribute (thus even more overhead), a 'R'
+	will be displayed on the same line as the function that
+	is returning registers.
+
+  function_profile_enabled:
+
+	When set it will enable all functions with either the function
+	tracer, or if enabled, the function graph tracer. It will
+	keep a histogram of the number of functions that were called
+	and if run with the function graph tracer, it will also keep
+	track of the time spent in those functions. The histogram
+	content can be displayed in the files:
+
+	trace_stats/function<cpu> ( function0, function1, etc).
+
+  trace_stats:
+
+	A directory that holds different tracing stats.
+
+  kprobe_events:
+=20
+	Enable dynamic trace points. See kprobetrace.txt.
+
+  kprobe_profile:
+
+	Dynamic trace points stats. See kprobetrace.txt.
+
+  max_graph_depth:
+
+	Used with the function graph tracer. This is the max depth
+	it will trace into a function. Setting this to a value of
+	one will show only the first kernel function that is called
+	from user space.
+
+  printk_formats:
+
+	This is for tools that read the raw format files. If an event in
+	the ring buffer references a string (currently only trace_printk()
+	does this), only a pointer to the string is recorded into the buffer
+	and not the string itself. This prevents tools from knowing what
+	that string was. This file displays the string and address for
+	the string allowing tools to map the pointers to what the
+	strings were.
+
+  saved_cmdlines:
+
+	Only the pid of the task is recorded in a trace event unless
+	the event specifically saves the task comm as well. Ftrace
+	makes a cache of pid mappings to comms to try to display
+	comms for events. If a pid for a comm is not listed, then
+	"<...>" is displayed in the output.
+
+  snapshot:
+
+	This displays the "snapshot" buffer and also lets the user
+	take a snapshot of the current running trace.
+	See the "Snapshot" section below for more details.
+
+  stack_max_size:
+
+	When the stack tracer is activated, this will display the
+	maximum stack size it has encountered.
+	See the "Stack Trace" section below.
+
+  stack_trace:
+
+	This displays the stack back trace of the largest stack
+	that was encountered when the stack tracer is activated.
+	See the "Stack Trace" section below.
+
+  stack_trace_filter:
+
+	This is similar to "set_ftrace_filter" but it limits what
+	functions the stack tracer will check.
+
+  trace_clock:
+
+	Whenever an event is recorded into the ring buffer, a
+	"timestamp" is added. This stamp comes from a specified
+	clock. By default, ftrace uses the "local" clock. This
+	clock is very fast and strictly per cpu, but on some
+	systems it may not be monotonic with respect to other
+	CPUs. In other words, the local clocks may not be in sync
+	with local clocks on other CPUs.
+
+	Usual clocks for tracing:
+
+	  # cat trace_clock
+	  [local] global counter x86-tsc
+
+	  local: Default clock, but may not be in sync across CPUs
+
+	  global: This clock is in sync with all CPUs but may
+	  	  be a bit slower than the local clock.
+
+	  counter: This is not a clock at all, but literally an atomic
+	  	   counter. It counts up one by one, but is in sync
+		   with all CPUs. This is useful when you need to
+		   know exactly the order events occurred with respect to
+		   each other on different CPUs.
+
+	  uptime: This uses the jiffies counter and the time stamp
+	  	  is relative to the time since boot up.
+
+	  perf: This makes ftrace use the same clock that perf uses.
+	  	Eventually perf will be able to read ftrace buffers
+		and this will help out in interleaving the data.
+
+	  x86-tsc: Architectures may define their own clocks. For
+	  	   example, x86 uses its own TSC cycle clock here.
+
+	To set a clock, simply echo the clock name into this file.
+
+	  echo global > trace_clock
+
+  trace_marker:
+
+	This is a very useful file for synchronizing user space
+	with events happening in the kernel. Writing strings into
+	this file will be written into the ftrace buffer.
+
+	It is useful in applications to open this file at the start
+	of the application and just reference the file descriptor
+	for the file.
+
+	void trace_write(const char *fmt, ...)
+	{
+		va_list ap;
+		char buf[256];
+		int n;
+
+		if (trace_fd < 0)
+			return;
+
+		va_start(ap, fmt);
+		n =3D vsnprintf(buf, 256, fmt, ap);
+		va_end(ap);
+
+		write(trace_fd, buf, n);
+	}
+
+	start:
+
+		trace_fd =3D open("trace_marker", WR_ONLY);
+
+  uprobe_events:
+=20
+	Add dynamic tracepoints in programs.
+	See uprobetracer.txt
+
+  uprobe_profile:
+
+	Uprobe statistics. See uprobetrace.txt
+
+  instances:
+
+	This is a way to make multiple trace buffers where different
+	events can be recorded in different buffers.
+	See "Instances" section below.
+
+  events:
+
+	This is the trace event directory. It holds event tracepoints
+	(also known as static tracepoints) that have been compiled
+	into the kernel. It shows what event tracepoints exist
+	and how they are grouped by system. There are "enable"
+	files at various levels that can enable the tracepoints
+	when a "1" is written to them.
+
+	See events.txt for more information.
+
+  per_cpu:
+
+	This is a directory that contains the trace per_cpu information.
+
+  per_cpu/cpu0/buffer_size_kb:
+
+	The ftrace buffer is defined per_cpu. That is, there's a separate
+	buffer for each CPU to allow writes to be done atomically,
+	and free from cache bouncing. These buffers may have different
+	size buffers. This file is similar to the buffer_size_kb
+	file, but it only displays or sets the buffer size for the
+	specific CPU. (here cpu0).
+
+  per_cpu/cpu0/trace:
+
+	This is similar to the "trace" file, but it will only display
+	the data specific for the CPU. If written to, it only clears
+	the specific CPU buffer.
+
+  per_cpu/cpu0/trace_pipe
+
+	This is similar to the "trace_pipe" file, and is a consuming
+	read, but it will only display (and consume) the data specific
+	for the CPU.
+
+  per_cpu/cpu0/trace_pipe_raw
+
+	For tools that can parse the ftrace ring buffer binary format,
+	the trace_pipe_raw file can be used to extract the data
+	from the ring buffer directly. With the use of the splice()
+	system call, the buffer data can be quickly transferred to
+	a file or to the network where a server is collecting the
+	data.
+
+	Like trace_pipe, this is a consuming reader, where multiple
+	reads will always produce different data.
+
+  per_cpu/cpu0/snapshot:
+
+	This is similar to the main "snapshot" file, but will only
+	snapshot the current CPU (if supported). It only displays
+	the content of the snapshot for a given CPU, and if
+	written to, only clears this CPU buffer.
+
+  per_cpu/cpu0/snapshot_raw:
+
+	Similar to the trace_pipe_raw, but will read the binary format
+	from the snapshot buffer for the given CPU.
+
+  per_cpu/cpu0/stats:
+
+	This displays certain stats about the ring buffer:
+
+	 entries: The number of events that are still in the buffer.
+
+	 overrun: The number of lost events due to overwriting when
+	 	  the buffer was full.
+
+	 commit overrun: Should always be zero.
+	 	This gets set if so many events happened within a nested
+		event (ring buffer is re-entrant), that it fills the
+		buffer and starts dropping events.
+
+	 bytes: Bytes actually read (not overwritten).
+
+	 oldest event ts: The oldest timestamp in the buffer
+
+	 now ts: The current timestamp
+
+	 dropped events: Events lost due to overwrite option being off.
+
+	 read events: The number of events read.
=20
 The Tracers
 -----------
@@ -234,11 +524,6 @@ Here is the list of current tracers that may be config=
ured.
         RT tasks (as the current "wakeup" does). This is useful
         for those interested in wake up timings of RT tasks.
=20
-  "hw-branch-tracer"
-
-	Uses the BTS CPU feature on x86 CPUs to traces all
-	branches executed.
-
   "nop"
=20
 	This is the "trace nothing" tracer. To remove all
@@ -261,70 +546,100 @@ Here is an example of the output format of the file =
"trace"
                              --------
 # tracer: function
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-            bash-4251  [01] 10152.583854: path_put <-path_walk
-            bash-4251  [01] 10152.583855: dput <-path_put
-            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
+# entries-in-buffer/entries-written: 140080/250280   #P:4
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+            bash-1977  [000] .... 17284.993652: sys_close <-system_call_fa=
stpath
+            bash-1977  [000] .... 17284.993653: __close_fd <-sys_close
+            bash-1977  [000] .... 17284.993653: _raw_spin_lock <-__close_fd
+            sshd-1974  [003] .... 17284.993653: __srcu_read_unlock <-fsnot=
ify
+            bash-1977  [000] .... 17284.993654: add_preempt_count <-_raw_s=
pin_lock
+            bash-1977  [000] ...1 17284.993655: _raw_spin_unlock <-__close=
_fd
+            bash-1977  [000] ...1 17284.993656: sub_preempt_count <-_raw_s=
pin_unlock
+            bash-1977  [000] .... 17284.993657: filp_close <-__close_fd
+            bash-1977  [000] .... 17284.993657: dnotify_flush <-filp_close
+            sshd-1974  [003] .... 17284.993658: sys_select <-system_call_f=
astpath
                              --------
=20
 A header is printed with the tracer name that is represented by
-the trace. In this case the tracer is "function". Then a header
-showing the format. Task name "bash", the task PID "4251", the
-CPU that it was running on "01", the timestamp in <secs>.<usecs>
-format, the function name that was traced "path_put" and the
-parent function that called this function "path_walk". The
-timestamp is the time at which the function was entered.
+the trace. In this case the tracer is "function". Then it shows the
+number of events in the buffer as well as the total number of entries
+that were written. The difference is the number of entries that were
+lost due to the buffer filling up (250280 - 140080 =3D 110200 events
+lost).
+
+The header explains the content of the events. Task name "bash", the task
+PID "1977", the CPU that it was running on "000", the latency format
+(explained below), the timestamp in <secs>.<usecs> format, the
+function name that was traced "sys_close" and the parent function that
+called this function "system_call_fastpath". The timestamp is the time
+at which the function was entered.
=20
 Latency trace format
 --------------------
=20
-When the latency-format option is enabled, the trace file gives
-somewhat more information to see why a latency happened.
-Here is a typical trace.
+When the latency-format option is enabled or when one of the latency
+tracers is set, the trace file gives somewhat more information to see
+why a latency happened. Here is a typical trace.
=20
 # tracer: irqsoff
 #
-irqsoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: apic_timer_interrupt
- =3D> ended at:   do_softirq
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interru=
pt)
-  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
-  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
+# irqsoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 259 us, #4/4, CPU#2 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: ps-6143 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: __lock_task_sighand
+#  =3D> ended at:   _raw_spin_unlock_irqrestore
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+      ps-6143    2d...    0us!: trace_hardirqs_off <-__lock_task_sighand
+      ps-6143    2d..1  259us+: trace_hardirqs_on <-_raw_spin_unlock_irqre=
store
+      ps-6143    2d..1  263us+: time_hardirqs_on <-_raw_spin_unlock_irqres=
tore
+      ps-6143    2d..1  306us : <stack trace>
+ =3D> trace_hardirqs_on_caller
+ =3D> trace_hardirqs_on
+ =3D> _raw_spin_unlock_irqrestore
+ =3D> do_task_stat
+ =3D> proc_tgid_stat
+ =3D> proc_single_show
+ =3D> seq_read
+ =3D> vfs_read
+ =3D> sys_read
+ =3D> system_call_fastpath
=20
=20
 This shows that the current tracer is "irqsoff" tracing the time
-for which interrupts were disabled. It gives the trace version
-and the version of the kernel upon which this was executed on
-(2.6.26-rc8). Then it displays the max latency in microsecs (97
-us). The number of trace entries displayed and the total number
-recorded (both are three: #3/3). The type of preemption that was
-used (PREEMPT). VP, KP, SP, and HP are always zero and are
-reserved for later use. #P is the number of online CPUS (#P:2).
+for which interrupts were disabled. It gives the trace version (which
+never changes) and the version of the kernel upon which this was executed =
on
+(3.10). Then it displays the max latency in microseconds (259 us). The num=
ber
+of trace entries displayed and the total number (both are four: #4/4).
+VP, KP, SP, and HP are always zero and are reserved for later use.
+#P is the number of online CPUs (#P:4).
=20
 The task is the process that was running when the latency
-occurred. (swapper pid: 0).
+occurred. (ps pid: 6143).
=20
 The start and stop (the functions in which the interrupts were
 disabled and enabled respectively) that caused the latencies:
=20
-  apic_timer_interrupt is where the interrupts were disabled.
-  do_softirq is where they were enabled again.
+ __lock_task_sighand is where the interrupts were disabled.
+ _raw_spin_unlock_irqrestore is where they were enabled again.
=20
 The next lines after the header are the trace itself. The header
 explains which is which.
@@ -367,16 +682,43 @@ The above is mostly meaningful for kernel developers.
=20
   The rest is the same as the 'trace' file.
=20
+  Note, the latency tracers will usually end with a back trace
+  to easily find where the latency occurred.
=20
 trace_options
 -------------
=20
-The trace_options file is used to control what gets printed in
-the trace output. To see what is available, simply cat the file:
+The trace_options file (or the options directory) is used to control
+what gets printed in the trace output, or manipulate the tracers.
+To see what is available, simply cat the file:
=20
   cat trace_options
-  print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
-  noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
+print-parent
+nosym-offset
+nosym-addr
+noverbose
+noraw
+nohex
+nobin
+noblock
+nostacktrace
+trace_printk
+noftrace_preempt
+nobranch
+annotate
+nouserstacktrace
+nosym-userobj
+noprintk-msg-only
+context-info
+latency-format
+sleep-time
+graph-time
+record-cmd
+overwrite
+nodisable_on_free
+irq-info
+markers
+function-trace
=20
 To disable one of the options, echo in the option prepended with
 "no".
@@ -428,13 +770,34 @@ Here are the available options:
=20
   bin - This will print out the formats in raw binary.
=20
-  block - TBD (needs update)
+  block - When set, reading trace_pipe will not block when polled.
=20
   stacktrace - This is one of the options that changes the trace
 	       itself. When a trace is recorded, so is the stack
 	       of functions. This allows for back traces of
 	       trace sites.
=20
+  trace_printk - Can disable trace_printk() from writing into the buffer.
+
+  branch - Enable branch tracing with the tracer.
+
+  annotate - It is sometimes confusing when the CPU buffers are full
+  	     and one CPU buffer had a lot of events recently, thus
+	     a shorter time frame, were another CPU may have only had
+	     a few events, which lets it have older events. When
+	     the trace is reported, it shows the oldest events first,
+	     and it may look like only one CPU ran (the one with the
+	     oldest events). When the annotate option is set, it will
+	     display when a new CPU buffer started:
+
+          <idle>-0     [001] dNs4 21169.031481: wake_up_idle_cpu <-add_tim=
er_on
+          <idle>-0     [001] dNs4 21169.031482: _raw_spin_unlock_irqrestor=
e <-add_timer_on
+          <idle>-0     [001] .Ns4 21169.031484: sub_preempt_count <-_raw_s=
pin_unlock_irqrestore
+##### CPU 2 buffer started ####
+          <idle>-0     [002] .N.1 21169.031484: rcu_idle_exit <-cpu_idle
+          <idle>-0     [001] .Ns3 21169.031484: _raw_spin_unlock <-clockso=
urce_watchdog
+          <idle>-0     [001] .Ns3 21169.031485: sub_preempt_count <-_raw_s=
pin_unlock
+
   userstacktrace - This option changes the trace. It records a
 		   stacktrace of the current userspace thread.
=20
@@ -451,9 +814,13 @@ Here are the available options:
 		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
 x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
=20
-  sched-tree - trace all tasks that are on the runqueue, at
-	       every scheduling event. Will add overhead if
-	       there's a lot of tasks running at once.
+
+  printk-msg-only - When set, trace_printk()s will only show the format
+  		    and not their parameters (if trace_bprintk() or
+		    trace_bputs() was used to save the trace_printk()).
+
+  context-info - Show only the event data. Hides the comm, PID,
+  	         timestamp, CPU, and other useful data.
=20
   latency-format - This option changes the trace. When
                    it is enabled, the trace displays
@@ -461,31 +828,61 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1=
e1a6]
                    latencies, as described in "Latency
                    trace format".
=20
+  sleep-time - When running function graph tracer, to include
+  	       the time a task schedules out in its function.
+	       When enabled, it will account time the task has been
+	       scheduled out as part of the function call.
+
+  graph-time - When running function graph tracer, to include the
+  	       time to call nested functions. When this is not set,
+	       the time reported for the function will only include
+	       the time the function itself executed for, not the time
+	       for functions that it called.
+
+  record-cmd - When any event or tracer is enabled, a hook is enabled
+  	       in the sched_switch trace point to fill comm cache
+	       with mapped pids and comms. But this may cause some
+	       overhead, and if you only care about pids, and not the
+	       name of the task, disabling this option can lower the
+	       impact of tracing.
+
   overwrite - This controls what happens when the trace buffer is
               full. If "1" (default), the oldest events are
               discarded and overwritten. If "0", then the newest
               events are discarded.
+	        (see per_cpu/cpu0/stats for overrun and dropped)
=20
-ftrace_enabled
---------------
+  disable_on_free - When the free_buffer is closed, tracing will
+  		    stop (tracing_on set to 0).
=20
-The following tracers (listed below) give different output
-depending on whether or not the sysctl ftrace_enabled is set. To
-set ftrace_enabled, one can either use the sysctl function or
-set it via the proc file system interface.
+  irq-info - Shows the interrupt, preempt count, need resched data.
+  	     When disabled, the trace looks like:
=20
-  sysctl kernel.ftrace_enabled=3D1
+# tracer: function
+#
+# entries-in-buffer/entries-written: 144405/9452052   #P:4
+#
+#           TASK-PID   CPU#      TIMESTAMP  FUNCTION
+#              | |       |          |         |
+          <idle>-0     [002]  23636.756054: ttwu_do_activate.constprop.89 =
<-try_to_wake_up
+          <idle>-0     [002]  23636.756054: activate_task <-ttwu_do_activa=
te.constprop.89
+          <idle>-0     [002]  23636.756055: enqueue_task <-activate_task
=20
- or
=20
-  echo 1 > /proc/sys/kernel/ftrace_enabled
+  markers - When set, the trace_marker is writable (only by root).
+  	    When disabled, the trace_marker will error with EINVAL
+	    on write.
+
+
+  function-trace - The latency tracers will enable function tracing
+  	    if this option is enabled (default it is). When
+	    it is disabled, the latency tracers do not trace
+	    functions. This keeps the overhead of the tracer down
+	    when performing latency tests.
=20
-To disable ftrace_enabled simply replace the '1' with '0' in the
-above commands.
+ Note: Some tracers have their own options. They only appear
+       when the tracer is active.
=20
-When ftrace_enabled is set the tracers will also record the
-functions that are within the trace. The descriptions of the
-tracers will also show an example with ftrace enabled.
=20
=20
 irqsoff
@@ -506,95 +903,133 @@ new trace is saved.
 To reset the maximum, echo 0 into tracing_max_latency. Here is
 an example:
=20
+ # echo 0 > options/function-trace
  # echo irqsoff > current_tracer
- # echo latency-format > trace_options
- # echo 0 > tracing_max_latency
  # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
  # ls -ltr
  [...]
  # echo 0 > tracing_on
  # cat trace
 # tracer: irqsoff
 #
-irqsoff latency trace v1.1.5 on 2.6.26
---------------------------------------------------------------------
- latency: 12 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: bash-3730 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: sys_setpgid
- =3D> ended at:   sys_setpgid
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-    bash-3730  1d...    0us : _write_lock_irq (sys_setpgid)
-    bash-3730  1d..1    1us+: _write_unlock_irq (sys_setpgid)
-    bash-3730  1d..2   14us : trace_hardirqs_on (sys_setpgid)
-
-
-Here we see that that we had a latency of 12 microsecs (which is
-very good). The _write_lock_irq in sys_setpgid disabled
-interrupts. The difference between the 12 and the displayed
-timestamp 14us occurred because the clock was incremented
+# irqsoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 16 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: swapper/0-0 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: run_timer_softirq
+#  =3D> ended at:   run_timer_softirq
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+  <idle>-0       0d.s2    0us+: _raw_spin_lock_irq <-run_timer_softirq
+  <idle>-0       0dNs3   17us : _raw_spin_unlock_irq <-run_timer_softirq
+  <idle>-0       0dNs3   17us+: trace_hardirqs_on <-run_timer_softirq
+  <idle>-0       0dNs3   25us : <stack trace>
+ =3D> _raw_spin_unlock_irq
+ =3D> run_timer_softirq
+ =3D> __do_softirq
+ =3D> call_softirq
+ =3D> do_softirq
+ =3D> irq_exit
+ =3D> smp_apic_timer_interrupt
+ =3D> apic_timer_interrupt
+ =3D> rcu_idle_exit
+ =3D> cpu_idle
+ =3D> rest_init
+ =3D> start_kernel
+ =3D> x86_64_start_reservations
+ =3D> x86_64_start_kernel
+
+Here we see that that we had a latency of 16 microseconds (which is
+very good). The _raw_spin_lock_irq in run_timer_softirq disabled
+interrupts. The difference between the 16 and the displayed
+timestamp 25us occurred because the clock was incremented
 between the time of recording the max latency and the time of
 recording the function that had that latency.
=20
-Note the above example had ftrace_enabled not set. If we set the
-ftrace_enabled, we get a much larger output:
+Note the above example had function-trace not set. If we set
+function-trace, we get a much larger output:
+
+ with echo 1 > options/function-trace
=20
 # tracer: irqsoff
 #
-irqsoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 50 us, #101/101, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: ls-4339 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: __alloc_pages_internal
- =3D> ended at:   __alloc_pages_internal
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-      ls-4339  0...1    0us+: get_page_from_freelist (__alloc_pages_intern=
al)
-      ls-4339  0d..1    3us : rmqueue_bulk (get_page_from_freelist)
-      ls-4339  0d..1    3us : _spin_lock (rmqueue_bulk)
-      ls-4339  0d..1    4us : add_preempt_count (_spin_lock)
-      ls-4339  0d..2    4us : __rmqueue (rmqueue_bulk)
-      ls-4339  0d..2    5us : __rmqueue_smallest (__rmqueue)
-      ls-4339  0d..2    5us : __mod_zone_page_state (__rmqueue_smallest)
-      ls-4339  0d..2    6us : __rmqueue (rmqueue_bulk)
-      ls-4339  0d..2    6us : __rmqueue_smallest (__rmqueue)
-      ls-4339  0d..2    7us : __mod_zone_page_state (__rmqueue_smallest)
-      ls-4339  0d..2    7us : __rmqueue (rmqueue_bulk)
-      ls-4339  0d..2    8us : __rmqueue_smallest (__rmqueue)
+# irqsoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 71 us, #168/168, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: bash-2042 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: ata_scsi_queuecmd
+#  =3D> ended at:   ata_scsi_queuecmd
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+    bash-2042    3d...    0us : _raw_spin_lock_irqsave <-ata_scsi_queuecmd
+    bash-2042    3d...    0us : add_preempt_count <-_raw_spin_lock_irqsave
+    bash-2042    3d..1    1us : ata_scsi_find_dev <-ata_scsi_queuecmd
+    bash-2042    3d..1    1us : __ata_scsi_find_dev <-ata_scsi_find_dev
+    bash-2042    3d..1    2us : ata_find_dev.part.14 <-__ata_scsi_find_dev
+    bash-2042    3d..1    2us : ata_qc_new_init <-__ata_scsi_queuecmd
+    bash-2042    3d..1    3us : ata_sg_init <-__ata_scsi_queuecmd
+    bash-2042    3d..1    4us : ata_scsi_rw_xlat <-__ata_scsi_queuecmd
+    bash-2042    3d..1    4us : ata_build_rw_tf <-ata_scsi_rw_xlat
 [...]
-      ls-4339  0d..2   46us : __rmqueue_smallest (__rmqueue)
-      ls-4339  0d..2   47us : __mod_zone_page_state (__rmqueue_smallest)
-      ls-4339  0d..2   47us : __rmqueue (rmqueue_bulk)
-      ls-4339  0d..2   48us : __rmqueue_smallest (__rmqueue)
-      ls-4339  0d..2   48us : __mod_zone_page_state (__rmqueue_smallest)
-      ls-4339  0d..2   49us : _spin_unlock (rmqueue_bulk)
-      ls-4339  0d..2   49us : sub_preempt_count (_spin_unlock)
-      ls-4339  0d..1   50us : get_page_from_freelist (__alloc_pages_intern=
al)
-      ls-4339  0d..2   51us : trace_hardirqs_on (__alloc_pages_internal)
-
-
-
-Here we traced a 50 microsecond latency. But we also see all the
+    bash-2042    3d..1   67us : delay_tsc <-__delay
+    bash-2042    3d..1   67us : add_preempt_count <-delay_tsc
+    bash-2042    3d..2   67us : sub_preempt_count <-delay_tsc
+    bash-2042    3d..1   67us : add_preempt_count <-delay_tsc
+    bash-2042    3d..2   68us : sub_preempt_count <-delay_tsc
+    bash-2042    3d..1   68us+: ata_bmdma_start <-ata_bmdma_qc_issue
+    bash-2042    3d..1   71us : _raw_spin_unlock_irqrestore <-ata_scsi_que=
uecmd
+    bash-2042    3d..1   71us : _raw_spin_unlock_irqrestore <-ata_scsi_que=
uecmd
+    bash-2042    3d..1   72us+: trace_hardirqs_on <-ata_scsi_queuecmd
+    bash-2042    3d..1  120us : <stack trace>
+ =3D> _raw_spin_unlock_irqrestore
+ =3D> ata_scsi_queuecmd
+ =3D> scsi_dispatch_cmd
+ =3D> scsi_request_fn
+ =3D> __blk_run_queue_uncond
+ =3D> __blk_run_queue
+ =3D> blk_queue_bio
+ =3D> generic_make_request
+ =3D> submit_bio
+ =3D> submit_bh
+ =3D> __ext3_get_inode_loc
+ =3D> ext3_iget
+ =3D> ext3_lookup
+ =3D> lookup_real
+ =3D> __lookup_hash
+ =3D> walk_component
+ =3D> lookup_last
+ =3D> path_lookupat
+ =3D> filename_lookup
+ =3D> user_path_at_empty
+ =3D> user_path_at
+ =3D> vfs_fstatat
+ =3D> vfs_stat
+ =3D> sys_newstat
+ =3D> system_call_fastpath
+
+
+Here we traced a 71 microsecond latency. But we also see all the
 functions that were called during that time. Note that by
 enabling function tracing, we incur an added overhead. This
 overhead may extend the latency times. But nevertheless, this
@@ -614,120 +1049,122 @@ Like the irqsoff tracer, it records the maximum la=
tency for
 which preemption was disabled. The control of preemptoff tracer
 is much like the irqsoff tracer.
=20
+ # echo 0 > options/function-trace
  # echo preemptoff > current_tracer
- # echo latency-format > trace_options
- # echo 0 > tracing_max_latency
  # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
  # ls -ltr
  [...]
  # echo 0 > tracing_on
  # cat trace
 # tracer: preemptoff
 #
-preemptoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 29 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: do_IRQ
- =3D> ended at:   __do_softirq
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-    sshd-4261  0d.h.    0us+: irq_enter (do_IRQ)
-    sshd-4261  0d.s.   29us : _local_bh_enable (__do_softirq)
-    sshd-4261  0d.s1   30us : trace_preempt_on (__do_softirq)
+# preemptoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 46 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: sshd-1991 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: do_IRQ
+#  =3D> ended at:   do_IRQ
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+    sshd-1991    1d.h.    0us+: irq_enter <-do_IRQ
+    sshd-1991    1d..1   46us : irq_exit <-do_IRQ
+    sshd-1991    1d..1   47us+: trace_preempt_on <-do_IRQ
+    sshd-1991    1d..1   52us : <stack trace>
+ =3D> sub_preempt_count
+ =3D> irq_exit
+ =3D> do_IRQ
+ =3D> ret_from_intr
=20
=20
 This has some more changes. Preemption was disabled when an
-interrupt came in (notice the 'h'), and was enabled while doing
-a softirq. (notice the 's'). But we also see that interrupts
-have been disabled when entering the preempt off section and
-leaving it (the 'd'). We do not know if interrupts were enabled
-in the mean time.
+interrupt came in (notice the 'h'), and was enabled on exit.
+But we also see that interrupts have been disabled when entering
+the preempt off section and leaving it (the 'd'). We do not know if
+interrupts were enabled in the mean time or shortly after this
+was over.
=20
 # tracer: preemptoff
 #
-preemptoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 63 us, #87/87, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: remove_wait_queue
- =3D> ended at:   __do_softirq
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-    sshd-4261  0d..1    0us : _spin_lock_irqsave (remove_wait_queue)
-    sshd-4261  0d..1    1us : _spin_unlock_irqrestore (remove_wait_queue)
-    sshd-4261  0d..1    2us : do_IRQ (common_interrupt)
-    sshd-4261  0d..1    2us : irq_enter (do_IRQ)
-    sshd-4261  0d..1    2us : idle_cpu (irq_enter)
-    sshd-4261  0d..1    3us : add_preempt_count (irq_enter)
-    sshd-4261  0d.h1    3us : idle_cpu (irq_enter)
-    sshd-4261  0d.h.    4us : handle_fasteoi_irq (do_IRQ)
+# preemptoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 83 us, #241/241, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: bash-1994 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: wake_up_new_task
+#  =3D> ended at:   task_rq_unlock
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+    bash-1994    1d..1    0us : _raw_spin_lock_irqsave <-wake_up_new_task
+    bash-1994    1d..1    0us : select_task_rq_fair <-select_task_rq
+    bash-1994    1d..1    1us : __rcu_read_lock <-select_task_rq_fair
+    bash-1994    1d..1    1us : source_load <-select_task_rq_fair
+    bash-1994    1d..1    1us : source_load <-select_task_rq_fair
 [...]
-    sshd-4261  0d.h.   12us : add_preempt_count (_spin_lock)
-    sshd-4261  0d.h1   12us : ack_ioapic_quirk_irq (handle_fasteoi_irq)
-    sshd-4261  0d.h1   13us : move_native_irq (ack_ioapic_quirk_irq)
-    sshd-4261  0d.h1   13us : _spin_unlock (handle_fasteoi_irq)
-    sshd-4261  0d.h1   14us : sub_preempt_count (_spin_unlock)
-    sshd-4261  0d.h1   14us : irq_exit (do_IRQ)
-    sshd-4261  0d.h1   15us : sub_preempt_count (irq_exit)
-    sshd-4261  0d..2   15us : do_softirq (irq_exit)
-    sshd-4261  0d...   15us : __do_softirq (do_softirq)
-    sshd-4261  0d...   16us : __local_bh_disable (__do_softirq)
-    sshd-4261  0d...   16us+: add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s4   20us : add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s4   21us : sub_preempt_count (local_bh_enable)
-    sshd-4261  0d.s5   21us : sub_preempt_count (local_bh_enable)
+    bash-1994    1d..1   12us : irq_enter <-smp_apic_timer_interrupt
+    bash-1994    1d..1   12us : rcu_irq_enter <-irq_enter
+    bash-1994    1d..1   13us : add_preempt_count <-irq_enter
+    bash-1994    1d.h1   13us : exit_idle <-smp_apic_timer_interrupt
+    bash-1994    1d.h1   13us : hrtimer_interrupt <-smp_apic_timer_interru=
pt
+    bash-1994    1d.h1   13us : _raw_spin_lock <-hrtimer_interrupt
+    bash-1994    1d.h1   14us : add_preempt_count <-_raw_spin_lock
+    bash-1994    1d.h2   14us : ktime_get_update_offsets <-hrtimer_interru=
pt
 [...]
-    sshd-4261  0d.s6   41us : add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s6   42us : sub_preempt_count (local_bh_enable)
-    sshd-4261  0d.s7   42us : sub_preempt_count (local_bh_enable)
-    sshd-4261  0d.s5   43us : add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s5   43us : sub_preempt_count (local_bh_enable_ip)
-    sshd-4261  0d.s6   44us : sub_preempt_count (local_bh_enable_ip)
-    sshd-4261  0d.s5   44us : add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s5   45us : sub_preempt_count (local_bh_enable)
+    bash-1994    1d.h1   35us : lapic_next_event <-clockevents_program_eve=
nt
+    bash-1994    1d.h1   35us : irq_exit <-smp_apic_timer_interrupt
+    bash-1994    1d.h1   36us : sub_preempt_count <-irq_exit
+    bash-1994    1d..2   36us : do_softirq <-irq_exit
+    bash-1994    1d..2   36us : __do_softirq <-call_softirq
+    bash-1994    1d..2   36us : __local_bh_disable <-__do_softirq
+    bash-1994    1d.s2   37us : add_preempt_count <-_raw_spin_lock_irq
+    bash-1994    1d.s3   38us : _raw_spin_unlock <-run_timer_softirq
+    bash-1994    1d.s3   39us : sub_preempt_count <-_raw_spin_unlock
+    bash-1994    1d.s2   39us : call_timer_fn <-run_timer_softirq
 [...]
-    sshd-4261  0d.s.   63us : _local_bh_enable (__do_softirq)
-    sshd-4261  0d.s1   64us : trace_preempt_on (__do_softirq)
+    bash-1994    1dNs2   81us : cpu_needs_another_gp <-rcu_process_callbac=
ks
+    bash-1994    1dNs2   82us : __local_bh_enable <-__do_softirq
+    bash-1994    1dNs2   82us : sub_preempt_count <-__local_bh_enable
+    bash-1994    1dN.2   82us : idle_cpu <-irq_exit
+    bash-1994    1dN.2   83us : rcu_irq_exit <-irq_exit
+    bash-1994    1dN.2   83us : sub_preempt_count <-irq_exit
+    bash-1994    1.N.1   84us : _raw_spin_unlock_irqrestore <-task_rq_unlo=
ck
+    bash-1994    1.N.1   84us+: trace_preempt_on <-task_rq_unlock
+    bash-1994    1.N.1  104us : <stack trace>
+ =3D> sub_preempt_count
+ =3D> _raw_spin_unlock_irqrestore
+ =3D> task_rq_unlock
+ =3D> wake_up_new_task
+ =3D> do_fork
+ =3D> sys_clone
+ =3D> stub_clone
=20
=20
 The above is an example of the preemptoff trace with
-ftrace_enabled set. Here we see that interrupts were disabled
+function-trace set. Here we see that interrupts were not disabled
 the entire time. The irq_enter code lets us know that we entered
 an interrupt 'h'. Before that, the functions being traced still
 show that it is not in an interrupt, but we can see from the
 functions themselves that this is not the case.
=20
-Notice that __do_softirq when called does not have a
-preempt_count. It may seem that we missed a preempt enabling.
-What really happened is that the preempt count is held on the
-thread's stack and we switched to the softirq stack (4K stacks
-in effect). The code does not copy the preempt count, but
-because interrupts are disabled, we do not need to worry about
-it. Having a tracer like this is good for letting people know
-what really happens inside the kernel.
-
-
 preemptirqsoff
 --------------
=20
@@ -762,38 +1199,57 @@ tracer.
 Again, using this trace is much like the irqsoff and preemptoff
 tracers.
=20
+ # echo 0 > options/function-trace
  # echo preemptirqsoff > current_tracer
- # echo latency-format > trace_options
- # echo 0 > tracing_max_latency
  # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
  # ls -ltr
  [...]
  # echo 0 > tracing_on
  # cat trace
 # tracer: preemptirqsoff
 #
-preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 293 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: ls-4860 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: apic_timer_interrupt
- =3D> ended at:   __do_softirq
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-      ls-4860  0d...    0us!: trace_hardirqs_off_thunk (apic_timer_interru=
pt)
-      ls-4860  0d.s.  294us : _local_bh_enable (__do_softirq)
-      ls-4860  0d.s1  294us : trace_preempt_on (__do_softirq)
-
+# preemptirqsoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 100 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: ls-2230 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: ata_scsi_queuecmd
+#  =3D> ended at:   ata_scsi_queuecmd
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+      ls-2230    3d...    0us+: _raw_spin_lock_irqsave <-ata_scsi_queuecmd
+      ls-2230    3...1  100us : _raw_spin_unlock_irqrestore <-ata_scsi_que=
uecmd
+      ls-2230    3...1  101us+: trace_preempt_on <-ata_scsi_queuecmd
+      ls-2230    3...1  111us : <stack trace>
+ =3D> sub_preempt_count
+ =3D> _raw_spin_unlock_irqrestore
+ =3D> ata_scsi_queuecmd
+ =3D> scsi_dispatch_cmd
+ =3D> scsi_request_fn
+ =3D> __blk_run_queue_uncond
+ =3D> __blk_run_queue
+ =3D> blk_queue_bio
+ =3D> generic_make_request
+ =3D> submit_bio
+ =3D> submit_bh
+ =3D> ext3_bread
+ =3D> ext3_dir_bread
+ =3D> htree_dirblock_to_tree
+ =3D> ext3_htree_fill_tree
+ =3D> ext3_readdir
+ =3D> vfs_readdir
+ =3D> sys_getdents
+ =3D> system_call_fastpath
=20
=20
 The trace_hardirqs_off_thunk is called from assembly on x86 when
@@ -802,105 +1258,158 @@ function tracing, we do not know if interrupts wer=
e enabled
 within the preemption points. We do see that it started with
 preemption enabled.
=20
-Here is a trace with ftrace_enabled set:
-
+Here is a trace with function-trace set:
=20
 # tracer: preemptirqsoff
 #
-preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 105 us, #183/183, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
-    -----------------
- =3D> started at: write_chan
- =3D> ended at:   __do_softirq
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-      ls-4473  0.N..    0us : preempt_schedule (write_chan)
-      ls-4473  0dN.1    1us : _spin_lock (schedule)
-      ls-4473  0dN.1    2us : add_preempt_count (_spin_lock)
-      ls-4473  0d..2    2us : put_prev_task_fair (schedule)
-[...]
-      ls-4473  0d..2   13us : set_normalized_timespec (ktime_get_ts)
-      ls-4473  0d..2   13us : __switch_to (schedule)
-    sshd-4261  0d..2   14us : finish_task_switch (schedule)
-    sshd-4261  0d..2   14us : _spin_unlock_irq (finish_task_switch)
-    sshd-4261  0d..1   15us : add_preempt_count (_spin_lock_irqsave)
-    sshd-4261  0d..2   16us : _spin_unlock_irqrestore (hrtick_set)
-    sshd-4261  0d..2   16us : do_IRQ (common_interrupt)
-    sshd-4261  0d..2   17us : irq_enter (do_IRQ)
-    sshd-4261  0d..2   17us : idle_cpu (irq_enter)
-    sshd-4261  0d..2   18us : add_preempt_count (irq_enter)
-    sshd-4261  0d.h2   18us : idle_cpu (irq_enter)
-    sshd-4261  0d.h.   18us : handle_fasteoi_irq (do_IRQ)
-    sshd-4261  0d.h.   19us : _spin_lock (handle_fasteoi_irq)
-    sshd-4261  0d.h.   19us : add_preempt_count (_spin_lock)
-    sshd-4261  0d.h1   20us : _spin_unlock (handle_fasteoi_irq)
-    sshd-4261  0d.h1   20us : sub_preempt_count (_spin_unlock)
-[...]
-    sshd-4261  0d.h1   28us : _spin_unlock (handle_fasteoi_irq)
-    sshd-4261  0d.h1   29us : sub_preempt_count (_spin_unlock)
-    sshd-4261  0d.h2   29us : irq_exit (do_IRQ)
-    sshd-4261  0d.h2   29us : sub_preempt_count (irq_exit)
-    sshd-4261  0d..3   30us : do_softirq (irq_exit)
-    sshd-4261  0d...   30us : __do_softirq (do_softirq)
-    sshd-4261  0d...   31us : __local_bh_disable (__do_softirq)
-    sshd-4261  0d...   31us+: add_preempt_count (__local_bh_disable)
-    sshd-4261  0d.s4   34us : add_preempt_count (__local_bh_disable)
+# preemptirqsoff latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 161 us, #339/339, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: ls-2269 (uid:0 nice:0 policy:0 rt_prio:0)
+#    -----------------
+#  =3D> started at: schedule
+#  =3D> ended at:   mutex_unlock
+#
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+kworker/-59      3...1    0us : __schedule <-schedule
+kworker/-59      3d..1    0us : rcu_preempt_qs <-rcu_note_context_switch
+kworker/-59      3d..1    1us : add_preempt_count <-_raw_spin_lock_irq
+kworker/-59      3d..2    1us : deactivate_task <-__schedule
+kworker/-59      3d..2    1us : dequeue_task <-deactivate_task
+kworker/-59      3d..2    2us : update_rq_clock <-dequeue_task
+kworker/-59      3d..2    2us : dequeue_task_fair <-dequeue_task
+kworker/-59      3d..2    2us : update_curr <-dequeue_task_fair
+kworker/-59      3d..2    2us : update_min_vruntime <-update_curr
+kworker/-59      3d..2    3us : cpuacct_charge <-update_curr
+kworker/-59      3d..2    3us : __rcu_read_lock <-cpuacct_charge
+kworker/-59      3d..2    3us : __rcu_read_unlock <-cpuacct_charge
+kworker/-59      3d..2    3us : update_cfs_rq_blocked_load <-dequeue_task_=
fair
+kworker/-59      3d..2    4us : clear_buddies <-dequeue_task_fair
+kworker/-59      3d..2    4us : account_entity_dequeue <-dequeue_task_fair
+kworker/-59      3d..2    4us : update_min_vruntime <-dequeue_task_fair
+kworker/-59      3d..2    4us : update_cfs_shares <-dequeue_task_fair
+kworker/-59      3d..2    5us : hrtick_update <-dequeue_task_fair
+kworker/-59      3d..2    5us : wq_worker_sleeping <-__schedule
+kworker/-59      3d..2    5us : kthread_data <-wq_worker_sleeping
+kworker/-59      3d..2    5us : put_prev_task_fair <-__schedule
+kworker/-59      3d..2    6us : pick_next_task_fair <-pick_next_task
+kworker/-59      3d..2    6us : clear_buddies <-pick_next_task_fair
+kworker/-59      3d..2    6us : set_next_entity <-pick_next_task_fair
+kworker/-59      3d..2    6us : update_stats_wait_end <-set_next_entity
+      ls-2269    3d..2    7us : finish_task_switch <-__schedule
+      ls-2269    3d..2    7us : _raw_spin_unlock_irq <-finish_task_switch
+      ls-2269    3d..2    8us : do_IRQ <-ret_from_intr
+      ls-2269    3d..2    8us : irq_enter <-do_IRQ
+      ls-2269    3d..2    8us : rcu_irq_enter <-irq_enter
+      ls-2269    3d..2    9us : add_preempt_count <-irq_enter
+      ls-2269    3d.h2    9us : exit_idle <-do_IRQ
 [...]
-    sshd-4261  0d.s3   43us : sub_preempt_count (local_bh_enable_ip)
-    sshd-4261  0d.s4   44us : sub_preempt_count (local_bh_enable_ip)
-    sshd-4261  0d.s3   44us : smp_apic_timer_interrupt (apic_timer_interru=
pt)
-    sshd-4261  0d.s3   45us : irq_enter (smp_apic_timer_interrupt)
-    sshd-4261  0d.s3   45us : idle_cpu (irq_enter)
-    sshd-4261  0d.s3   46us : add_preempt_count (irq_enter)
-    sshd-4261  0d.H3   46us : idle_cpu (irq_enter)
-    sshd-4261  0d.H3   47us : hrtimer_interrupt (smp_apic_timer_interrupt)
-    sshd-4261  0d.H3   47us : ktime_get (hrtimer_interrupt)
+      ls-2269    3d.h3   20us : sub_preempt_count <-_raw_spin_unlock
+      ls-2269    3d.h2   20us : irq_exit <-do_IRQ
+      ls-2269    3d.h2   21us : sub_preempt_count <-irq_exit
+      ls-2269    3d..3   21us : do_softirq <-irq_exit
+      ls-2269    3d..3   21us : __do_softirq <-call_softirq
+      ls-2269    3d..3   21us+: __local_bh_disable <-__do_softirq
+      ls-2269    3d.s4   29us : sub_preempt_count <-_local_bh_enable_ip
+      ls-2269    3d.s5   29us : sub_preempt_count <-_local_bh_enable_ip
+      ls-2269    3d.s5   31us : do_IRQ <-ret_from_intr
+      ls-2269    3d.s5   31us : irq_enter <-do_IRQ
+      ls-2269    3d.s5   31us : rcu_irq_enter <-irq_enter
 [...]
-    sshd-4261  0d.H3   81us : tick_program_event (hrtimer_interrupt)
-    sshd-4261  0d.H3   82us : ktime_get (tick_program_event)
-    sshd-4261  0d.H3   82us : ktime_get_ts (ktime_get)
-    sshd-4261  0d.H3   83us : getnstimeofday (ktime_get_ts)
-    sshd-4261  0d.H3   83us : set_normalized_timespec (ktime_get_ts)
-    sshd-4261  0d.H3   84us : clockevents_program_event (tick_program_even=
t)
-    sshd-4261  0d.H3   84us : lapic_next_event (clockevents_program_event)
-    sshd-4261  0d.H3   85us : irq_exit (smp_apic_timer_interrupt)
-    sshd-4261  0d.H3   85us : sub_preempt_count (irq_exit)
-    sshd-4261  0d.s4   86us : sub_preempt_count (irq_exit)
-    sshd-4261  0d.s3   86us : add_preempt_count (__local_bh_disable)
+      ls-2269    3d.s5   31us : rcu_irq_enter <-irq_enter
+      ls-2269    3d.s5   32us : add_preempt_count <-irq_enter
+      ls-2269    3d.H5   32us : exit_idle <-do_IRQ
+      ls-2269    3d.H5   32us : handle_irq <-do_IRQ
+      ls-2269    3d.H5   32us : irq_to_desc <-handle_irq
+      ls-2269    3d.H5   33us : handle_fasteoi_irq <-handle_irq
 [...]
-    sshd-4261  0d.s1   98us : sub_preempt_count (net_rx_action)
-    sshd-4261  0d.s.   99us : add_preempt_count (_spin_lock_irq)
-    sshd-4261  0d.s1   99us+: _spin_unlock_irq (run_timer_softirq)
-    sshd-4261  0d.s.  104us : _local_bh_enable (__do_softirq)
-    sshd-4261  0d.s.  104us : sub_preempt_count (_local_bh_enable)
-    sshd-4261  0d.s.  105us : _local_bh_enable (__do_softirq)
-    sshd-4261  0d.s1  105us : trace_preempt_on (__do_softirq)
-
-
-This is a very interesting trace. It started with the preemption
-of the ls task. We see that the task had the "need_resched" bit
-set via the 'N' in the trace.  Interrupts were disabled before
-the spin_lock at the beginning of the trace. We see that a
-schedule took place to run sshd.  When the interrupts were
-enabled, we took an interrupt. On return from the interrupt
-handler, the softirq ran. We took another interrupt while
-running the softirq as we see from the capital 'H'.
+      ls-2269    3d.s5  158us : _raw_spin_unlock_irqrestore <-rtl8139_poll
+      ls-2269    3d.s3  158us : net_rps_action_and_irq_enable.isra.65 <-ne=
t_rx_action
+      ls-2269    3d.s3  159us : __local_bh_enable <-__do_softirq
+      ls-2269    3d.s3  159us : sub_preempt_count <-__local_bh_enable
+      ls-2269    3d..3  159us : idle_cpu <-irq_exit
+      ls-2269    3d..3  159us : rcu_irq_exit <-irq_exit
+      ls-2269    3d..3  160us : sub_preempt_count <-irq_exit
+      ls-2269    3d...  161us : __mutex_unlock_slowpath <-mutex_unlock
+      ls-2269    3d...  162us+: trace_hardirqs_on <-mutex_unlock
+      ls-2269    3d...  186us : <stack trace>
+ =3D> __mutex_unlock_slowpath
+ =3D> mutex_unlock
+ =3D> process_output
+ =3D> n_tty_write
+ =3D> tty_write
+ =3D> vfs_write
+ =3D> sys_write
+ =3D> system_call_fastpath
+
+This is an interesting trace. It started with kworker running and
+scheduling out and ls taking over. But as soon as ls released the
+rq lock and enabled interrupts (but not preemption) an interrupt
+triggered. When the interrupt finished, it started running softirqs.
+But while the softirq was running, another interrupt triggered.
+When an interrupt is running inside a softirq, the annotation is 'H'.
=20
=20
 wakeup
 ------
=20
+One common case that people are interested in tracing is the
+time it takes for a task that is woken to actually wake up.
+Now for non Real-Time tasks, this can be arbitrary. But tracing
+it none the less can be interesting.=20
+
+Without function tracing:
+
+ # echo 0 > options/function-trace
+ # echo wakeup > current_tracer
+ # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
+ # chrt -f 5 sleep 1
+ # echo 0 > tracing_on
+ # cat trace
+# tracer: wakeup
+#
+# wakeup latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 15 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: kworker/3:1H-312 (uid:0 nice:-20 policy:0 rt_prio:0)
+#    -----------------
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+  <idle>-0       3dNs7    0us :      0:120:R   + [003]   312:100:R kworker=
/3:1H
+  <idle>-0       3dNs7    1us+: ttwu_do_activate.constprop.87 <-try_to_wak=
e_up
+  <idle>-0       3d..3   15us : __schedule <-schedule
+  <idle>-0       3d..3   15us :      0:120:R =3D=3D> [003]   312:100:R kwo=
rker/3:1H
+
+The tracer only traces the highest priority task in the system
+to avoid tracing the normal circumstances. Here we see that
+the kworker with a nice priority of -20 (not very nice), took
+just 15 microseconds from the time it woke up, to the time it
+ran.
+
+Non Real-Time tasks are not that interesting. A more interesting
+trace is to concentrate only on Real-Time tasks.
+
+wakeup_rt
+---------
+
 In a Real-Time environment it is very important to know the
 wakeup time it takes for the highest priority task that is woken
 up to the time that it executes. This is also known as "schedule
@@ -914,124 +1423,229 @@ Real-Time environments are interested in the worst=
 case latency.
 That is the longest latency it takes for something to happen,
 and not the average. We can have a very fast scheduler that may
 only have a large latency once in a while, but that would not
-work well with Real-Time tasks.  The wakeup tracer was designed
+work well with Real-Time tasks.  The wakeup_rt tracer was designed
 to record the worst case wakeups of RT tasks. Non-RT tasks are
 not recorded because the tracer only records one worst case and
 tracing non-RT tasks that are unpredictable will overwrite the
-worst case latency of RT tasks.
+worst case latency of RT tasks (just run the normal wakeup
+tracer for a while to see that effect).
=20
 Since this tracer only deals with RT tasks, we will run this
 slightly differently than we did with the previous tracers.
 Instead of performing an 'ls', we will run 'sleep 1' under
 'chrt' which changes the priority of the task.
=20
- # echo wakeup > current_tracer
- # echo latency-format > trace_options
- # echo 0 > tracing_max_latency
+ # echo 0 > options/function-trace
+ # echo wakeup_rt > current_tracer
  # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
  # chrt -f 5 sleep 1
  # echo 0 > tracing_on
  # cat trace
 # tracer: wakeup
 #
-wakeup latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 4 us, #2/2, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: sleep-4901 (uid:0 nice:0 policy:1 rt_prio:5)
-    -----------------
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-  <idle>-0     1d.h4    0us+: try_to_wake_up (wake_up_process)
-  <idle>-0     1d..4    4us : schedule (cpu_idle)
-
-
-Running this on an idle system, we see that it only took 4
-microseconds to perform the task switch.  Note, since the trace
-marker in the schedule is before the actual "switch", we stop
-the tracing when the recorded task is about to schedule in. This
-may change if we add a new marker at the end of the scheduler.
-
-Notice that the recorded task is 'sleep' with the PID of 4901
+# tracer: wakeup_rt
+#
+# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 5 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: sleep-2389 (uid:0 nice:0 policy:1 rt_prio:5)
+#    -----------------
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+  <idle>-0       3d.h4    0us :      0:120:R   + [003]  2389: 94:R sleep
+  <idle>-0       3d.h4    1us+: ttwu_do_activate.constprop.87 <-try_to_wak=
e_up
+  <idle>-0       3d..3    5us : __schedule <-schedule
+  <idle>-0       3d..3    5us :      0:120:R =3D=3D> [003]  2389: 94:R sle=
ep
+
+
+Running this on an idle system, we see that it only took 5 microseconds
+to perform the task switch.  Note, since the trace point in the schedule
+is before the actual "switch", we stop the tracing when the recorded task
+is about to schedule in. This may change if we add a new marker at the
+end of the scheduler.
+
+Notice that the recorded task is 'sleep' with the PID of 2389
 and it has an rt_prio of 5. This priority is user-space priority
 and not the internal kernel priority. The policy is 1 for
 SCHED_FIFO and 2 for SCHED_RR.
=20
-Doing the same with chrt -r 5 and ftrace_enabled set.
+Note, that the trace data shows the internal priority (99 - rtprio).
=20
-# tracer: wakeup
+  <idle>-0       3d..3    5us :      0:120:R =3D=3D> [003]  2389: 94:R sle=
ep
+
+The 0:120:R means idle was running with a nice priority of 0 (120 - 20)
+and in the running state 'R'. The sleep task was scheduled in with
+2389: 94:R. That is the priority is the kernel rtprio (99 - 5 =3D 94)
+and it too is in the running state.
+
+Doing the same with chrt -r 5 and function-trace set.
+
+  echo 1 > options/function-trace
+
+# tracer: wakeup_rt
 #
-wakeup latency trace v1.1.5 on 2.6.26-rc8
---------------------------------------------------------------------
- latency: 50 us, #60/60, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
-    -----------------
-    | task: sleep-4068 (uid:0 nice:0 policy:2 rt_prio:5)
-    -----------------
-
-#                _------=3D> CPU#
-#               / _-----=3D> irqs-off
-#              | / _----=3D> need-resched
-#              || / _---=3D> hardirq/softirq
-#              ||| / _--=3D> preempt-depth
-#              |||| /
-#              |||||     delay
-#  cmd     pid ||||| time  |   caller
-#     \   /    |||||   \   |   /
-ksoftirq-7     1d.H3    0us : try_to_wake_up (wake_up_process)
-ksoftirq-7     1d.H4    1us : sub_preempt_count (marker_probe_cb)
-ksoftirq-7     1d.H3    2us : check_preempt_wakeup (try_to_wake_up)
-ksoftirq-7     1d.H3    3us : update_curr (check_preempt_wakeup)
-ksoftirq-7     1d.H3    4us : calc_delta_mine (update_curr)
-ksoftirq-7     1d.H3    5us : __resched_task (check_preempt_wakeup)
-ksoftirq-7     1d.H3    6us : task_wake_up_rt (try_to_wake_up)
-ksoftirq-7     1d.H3    7us : _spin_unlock_irqrestore (try_to_wake_up)
-[...]
-ksoftirq-7     1d.H2   17us : irq_exit (smp_apic_timer_interrupt)
-ksoftirq-7     1d.H2   18us : sub_preempt_count (irq_exit)
-ksoftirq-7     1d.s3   19us : sub_preempt_count (irq_exit)
-ksoftirq-7     1..s2   20us : rcu_process_callbacks (__do_softirq)
-[...]
-ksoftirq-7     1..s2   26us : __rcu_process_callbacks (rcu_process_callbac=
ks)
-ksoftirq-7     1d.s2   27us : _local_bh_enable (__do_softirq)
-ksoftirq-7     1d.s2   28us : sub_preempt_count (_local_bh_enable)
-ksoftirq-7     1.N.3   29us : sub_preempt_count (ksoftirqd)
-ksoftirq-7     1.N.2   30us : _cond_resched (ksoftirqd)
-ksoftirq-7     1.N.2   31us : __cond_resched (_cond_resched)
-ksoftirq-7     1.N.2   32us : add_preempt_count (__cond_resched)
-ksoftirq-7     1.N.2   33us : schedule (__cond_resched)
-ksoftirq-7     1.N.2   33us : add_preempt_count (schedule)
-ksoftirq-7     1.N.3   34us : hrtick_clear (schedule)
-ksoftirq-7     1dN.3   35us : _spin_lock (schedule)
-ksoftirq-7     1dN.3   36us : add_preempt_count (_spin_lock)
-ksoftirq-7     1d..4   37us : put_prev_task_fair (schedule)
-ksoftirq-7     1d..4   38us : update_curr (put_prev_task_fair)
-[...]
-ksoftirq-7     1d..5   47us : _spin_trylock (tracing_record_cmdline)
-ksoftirq-7     1d..5   48us : add_preempt_count (_spin_trylock)
-ksoftirq-7     1d..6   49us : _spin_unlock (tracing_record_cmdline)
-ksoftirq-7     1d..6   49us : sub_preempt_count (_spin_unlock)
-ksoftirq-7     1d..4   50us : schedule (__cond_resched)
-
-The interrupt went off while running ksoftirqd. This task runs
-at SCHED_OTHER. Why did not we see the 'N' set early? This may
-be a harmless bug with x86_32 and 4K stacks. On x86_32 with 4K
-stacks configured, the interrupt and softirq run with their own
-stack. Some information is held on the top of the task's stack
-(need_resched and preempt_count are both stored there). The
-setting of the NEED_RESCHED bit is done directly to the task's
-stack, but the reading of the NEED_RESCHED is done by looking at
-the current stack, which in this case is the stack for the hard
-interrupt. This hides the fact that NEED_RESCHED has been set.
-We do not see the 'N' until we switch back to the task's
-assigned stack.
+# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 29 us, #85/85, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: sleep-2448 (uid:0 nice:0 policy:1 rt_prio:5)
+#    -----------------
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+  <idle>-0       3d.h4    1us+:      0:120:R   + [003]  2448: 94:R sleep
+  <idle>-0       3d.h4    2us : ttwu_do_activate.constprop.87 <-try_to_wak=
e_up
+  <idle>-0       3d.h3    3us : check_preempt_curr <-ttwu_do_wakeup
+  <idle>-0       3d.h3    3us : resched_task <-check_preempt_curr
+  <idle>-0       3dNh3    4us : task_woken_rt <-ttwu_do_wakeup
+  <idle>-0       3dNh3    4us : _raw_spin_unlock <-try_to_wake_up
+  <idle>-0       3dNh3    4us : sub_preempt_count <-_raw_spin_unlock
+  <idle>-0       3dNh2    5us : ttwu_stat <-try_to_wake_up
+  <idle>-0       3dNh2    5us : _raw_spin_unlock_irqrestore <-try_to_wake_=
up
+  <idle>-0       3dNh2    6us : sub_preempt_count <-_raw_spin_unlock_irqre=
store
+  <idle>-0       3dNh1    6us : _raw_spin_lock <-__run_hrtimer
+  <idle>-0       3dNh1    6us : add_preempt_count <-_raw_spin_lock
+  <idle>-0       3dNh2    7us : _raw_spin_unlock <-hrtimer_interrupt
+  <idle>-0       3dNh2    7us : sub_preempt_count <-_raw_spin_unlock
+  <idle>-0       3dNh1    7us : tick_program_event <-hrtimer_interrupt
+  <idle>-0       3dNh1    7us : clockevents_program_event <-tick_program_e=
vent
+  <idle>-0       3dNh1    8us : ktime_get <-clockevents_program_event
+  <idle>-0       3dNh1    8us : lapic_next_event <-clockevents_program_eve=
nt
+  <idle>-0       3dNh1    8us : irq_exit <-smp_apic_timer_interrupt
+  <idle>-0       3dNh1    9us : sub_preempt_count <-irq_exit
+  <idle>-0       3dN.2    9us : idle_cpu <-irq_exit
+  <idle>-0       3dN.2    9us : rcu_irq_exit <-irq_exit
+  <idle>-0       3dN.2   10us : rcu_eqs_enter_common.isra.45 <-rcu_irq_exit
+  <idle>-0       3dN.2   10us : sub_preempt_count <-irq_exit
+  <idle>-0       3.N.1   11us : rcu_idle_exit <-cpu_idle
+  <idle>-0       3dN.1   11us : rcu_eqs_exit_common.isra.43 <-rcu_idle_exit
+  <idle>-0       3.N.1   11us : tick_nohz_idle_exit <-cpu_idle
+  <idle>-0       3dN.1   12us : menu_hrtimer_cancel <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   12us : ktime_get <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   12us : tick_do_update_jiffies64 <-tick_nohz_idle_=
exit
+  <idle>-0       3dN.1   13us : update_cpu_load_nohz <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   13us : _raw_spin_lock <-update_cpu_load_nohz
+  <idle>-0       3dN.1   13us : add_preempt_count <-_raw_spin_lock
+  <idle>-0       3dN.2   13us : __update_cpu_load <-update_cpu_load_nohz
+  <idle>-0       3dN.2   14us : sched_avg_update <-__update_cpu_load
+  <idle>-0       3dN.2   14us : _raw_spin_unlock <-update_cpu_load_nohz
+  <idle>-0       3dN.2   14us : sub_preempt_count <-_raw_spin_unlock
+  <idle>-0       3dN.1   15us : calc_load_exit_idle <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   15us : touch_softlockup_watchdog <-tick_nohz_idle=
_exit
+  <idle>-0       3dN.1   15us : hrtimer_cancel <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   15us : hrtimer_try_to_cancel <-hrtimer_cancel
+  <idle>-0       3dN.1   16us : lock_hrtimer_base.isra.18 <-hrtimer_try_to=
_cancel
+  <idle>-0       3dN.1   16us : _raw_spin_lock_irqsave <-lock_hrtimer_base=
.isra.18
+  <idle>-0       3dN.1   16us : add_preempt_count <-_raw_spin_lock_irqsave
+  <idle>-0       3dN.2   17us : __remove_hrtimer <-remove_hrtimer.part.16
+  <idle>-0       3dN.2   17us : hrtimer_force_reprogram <-__remove_hrtimer
+  <idle>-0       3dN.2   17us : tick_program_event <-hrtimer_force_reprogr=
am
+  <idle>-0       3dN.2   18us : clockevents_program_event <-tick_program_e=
vent
+  <idle>-0       3dN.2   18us : ktime_get <-clockevents_program_event
+  <idle>-0       3dN.2   18us : lapic_next_event <-clockevents_program_eve=
nt
+  <idle>-0       3dN.2   19us : _raw_spin_unlock_irqrestore <-hrtimer_try_=
to_cancel
+  <idle>-0       3dN.2   19us : sub_preempt_count <-_raw_spin_unlock_irqre=
store
+  <idle>-0       3dN.1   19us : hrtimer_forward <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   20us : ktime_add_safe <-hrtimer_forward
+  <idle>-0       3dN.1   20us : ktime_add_safe <-hrtimer_forward
+  <idle>-0       3dN.1   20us : hrtimer_start_range_ns <-hrtimer_start_exp=
ires.constprop.11
+  <idle>-0       3dN.1   20us : __hrtimer_start_range_ns <-hrtimer_start_r=
ange_ns
+  <idle>-0       3dN.1   21us : lock_hrtimer_base.isra.18 <-__hrtimer_star=
t_range_ns
+  <idle>-0       3dN.1   21us : _raw_spin_lock_irqsave <-lock_hrtimer_base=
.isra.18
+  <idle>-0       3dN.1   21us : add_preempt_count <-_raw_spin_lock_irqsave
+  <idle>-0       3dN.2   22us : ktime_add_safe <-__hrtimer_start_range_ns
+  <idle>-0       3dN.2   22us : enqueue_hrtimer <-__hrtimer_start_range_ns
+  <idle>-0       3dN.2   22us : tick_program_event <-__hrtimer_start_range=
_ns
+  <idle>-0       3dN.2   23us : clockevents_program_event <-tick_program_e=
vent
+  <idle>-0       3dN.2   23us : ktime_get <-clockevents_program_event
+  <idle>-0       3dN.2   23us : lapic_next_event <-clockevents_program_eve=
nt
+  <idle>-0       3dN.2   24us : _raw_spin_unlock_irqrestore <-__hrtimer_st=
art_range_ns
+  <idle>-0       3dN.2   24us : sub_preempt_count <-_raw_spin_unlock_irqre=
store
+  <idle>-0       3dN.1   24us : account_idle_ticks <-tick_nohz_idle_exit
+  <idle>-0       3dN.1   24us : account_idle_time <-account_idle_ticks
+  <idle>-0       3.N.1   25us : sub_preempt_count <-cpu_idle
+  <idle>-0       3.N..   25us : schedule <-cpu_idle
+  <idle>-0       3.N..   25us : __schedule <-preempt_schedule
+  <idle>-0       3.N..   26us : add_preempt_count <-__schedule
+  <idle>-0       3.N.1   26us : rcu_note_context_switch <-__schedule
+  <idle>-0       3.N.1   26us : rcu_sched_qs <-rcu_note_context_switch
+  <idle>-0       3dN.1   27us : rcu_preempt_qs <-rcu_note_context_switch
+  <idle>-0       3.N.1   27us : _raw_spin_lock_irq <-__schedule
+  <idle>-0       3dN.1   27us : add_preempt_count <-_raw_spin_lock_irq
+  <idle>-0       3dN.2   28us : put_prev_task_idle <-__schedule
+  <idle>-0       3dN.2   28us : pick_next_task_stop <-pick_next_task
+  <idle>-0       3dN.2   28us : pick_next_task_rt <-pick_next_task
+  <idle>-0       3dN.2   29us : dequeue_pushable_task <-pick_next_task_rt
+  <idle>-0       3d..3   29us : __schedule <-preempt_schedule
+  <idle>-0       3d..3   30us :      0:120:R =3D=3D> [003]  2448: 94:R sle=
ep
+
+This isn't that big of a trace, even with function tracing enabled,
+so I included the entire trace.
+
+The interrupt went off while when the system was idle. Somewhere
+before task_woken_rt() was called, the NEED_RESCHED flag was set,
+this is indicated by the first occurrence of the 'N' flag.
+
+Latency tracing and events
+--------------------------
+As function tracing can induce a much larger latency, but without
+seeing what happens within the latency it is hard to know what
+caused it. There is a middle ground, and that is with enabling
+events.
+
+ # echo 0 > options/function-trace
+ # echo wakeup_rt > current_tracer
+ # echo 1 > events/enable
+ # echo 1 > tracing_on
+ # echo 0 > tracing_max_latency
+ # chrt -f 5 sleep 1
+ # echo 0 > tracing_on
+ # cat trace
+# tracer: wakeup_rt
+#
+# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
+# --------------------------------------------------------------------
+# latency: 6 us, #12/12, CPU#2 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
+#    -----------------
+#    | task: sleep-5882 (uid:0 nice:0 policy:1 rt_prio:5)
+#    -----------------
+#
+#                  _------=3D> CPU#=20=20=20=20=20=20=20=20=20=20=20=20
+#                 / _-----=3D> irqs-off=20=20=20=20=20=20=20=20
+#                | / _----=3D> need-resched=20=20=20=20
+#                || / _---=3D> hardirq/softirq=20
+#                ||| / _--=3D> preempt-depth=20=20=20
+#                |||| /     delay=20=20=20=20=20=20=20=20=20=20=20=20=20
+#  cmd     pid   ||||| time  |   caller=20=20=20=20=20=20
+#     \   /      |||||  \    |   /=20=20=20=20=20=20=20=20=20=20=20
+  <idle>-0       2d.h4    0us :      0:120:R   + [002]  5882: 94:R sleep
+  <idle>-0       2d.h4    0us : ttwu_do_activate.constprop.87 <-try_to_wak=
e_up
+  <idle>-0       2d.h4    1us : sched_wakeup: comm=3Dsleep pid=3D5882 prio=
=3D94 success=3D1 target_cpu=3D002
+  <idle>-0       2dNh2    1us : hrtimer_expire_exit: hrtimer=3Dffff8800779=
6feb8
+  <idle>-0       2.N.2    2us : power_end: cpu_id=3D2
+  <idle>-0       2.N.2    3us : cpu_idle: state=3D4294967295 cpu_id=3D2
+  <idle>-0       2dN.3    4us : hrtimer_cancel: hrtimer=3Dffff88007d50d5e0
+  <idle>-0       2dN.3    4us : hrtimer_start: hrtimer=3Dffff88007d50d5e0 =
function=3Dtick_sched_timer expires=3D34311211000000 softexpires=3D34311211=
000000
+  <idle>-0       2.N.2    5us : rcu_utilization: Start context switch
+  <idle>-0       2.N.2    5us : rcu_utilization: End context switch
+  <idle>-0       2d..3    6us : __schedule <-schedule
+  <idle>-0       2d..3    6us :      0:120:R =3D=3D> [002]  5882: 94:R sle=
ep
+
=20
 function
 --------
@@ -1039,6 +1653,7 @@ function
 This tracer is the function tracer. Enabling the function tracer
 can be done from the debug file system. Make sure the
 ftrace_enabled is set; otherwise this tracer is a nop.
+See the "ftrace_enabled" section below.
=20
  # sysctl kernel.ftrace_enabled=3D1
  # echo function > current_tracer
@@ -1048,23 +1663,23 @@ ftrace_enabled is set; otherwise this tracer is a n=
op.
  # cat trace
 # tracer: function
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-            bash-4003  [00]   123.638713: finish_task_switch <-schedule
-            bash-4003  [00]   123.638714: _spin_unlock_irq <-finish_task_s=
witch
-            bash-4003  [00]   123.638714: sub_preempt_count <-_spin_unlock=
_irq
-            bash-4003  [00]   123.638715: hrtick_set <-schedule
-            bash-4003  [00]   123.638715: _spin_lock_irqsave <-hrtick_set
-            bash-4003  [00]   123.638716: add_preempt_count <-_spin_lock_i=
rqsave
-            bash-4003  [00]   123.638716: _spin_unlock_irqrestore <-hrtick=
_set
-            bash-4003  [00]   123.638717: sub_preempt_count <-_spin_unlock=
_irqrestore
-            bash-4003  [00]   123.638717: hrtick_clear <-hrtick_set
-            bash-4003  [00]   123.638718: sub_preempt_count <-schedule
-            bash-4003  [00]   123.638718: sub_preempt_count <-preempt_sche=
dule
-            bash-4003  [00]   123.638719: wait_for_completion <-__stop_mac=
hine_run
-            bash-4003  [00]   123.638719: wait_for_common <-wait_for_compl=
etion
-            bash-4003  [00]   123.638720: _spin_lock_irq <-wait_for_common
-            bash-4003  [00]   123.638720: add_preempt_count <-_spin_lock_i=
rq
+# entries-in-buffer/entries-written: 24799/24799   #P:4
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+            bash-1994  [002] ....  3082.063030: mutex_unlock <-rb_simple_w=
rite
+            bash-1994  [002] ....  3082.063031: __mutex_unlock_slowpath <-=
mutex_unlock
+            bash-1994  [002] ....  3082.063031: __fsnotify_parent <-fsnoti=
fy_modify
+            bash-1994  [002] ....  3082.063032: fsnotify <-fsnotify_modify
+            bash-1994  [002] ....  3082.063032: __srcu_read_lock <-fsnotify
+            bash-1994  [002] ....  3082.063032: add_preempt_count <-__srcu=
_read_lock
+            bash-1994  [002] ...1  3082.063032: sub_preempt_count <-__srcu=
_read_lock
+            bash-1994  [002] ....  3082.063033: __srcu_read_unlock <-fsnot=
ify
 [...]
=20
=20
@@ -1214,79 +1829,19 @@ int main (int argc, char **argv)
         return 0;
 }
=20
+Or this simple script!
=20
-hw-branch-tracer (x86 only)
----------------------------
-
-This tracer uses the x86 last branch tracing hardware feature to
-collect a branch trace on all cpus with relatively low overhead.
-
-The tracer uses a fixed-size circular buffer per cpu and only
-traces ring 0 branches. The trace file dumps that buffer in the
-following format:
-
-# tracer: hw-branch-tracer
-#
-# CPU#        TO  <-  FROM
-   0  scheduler_tick+0xb5/0x1bf	  <-  task_tick_idle+0x5/0x6
-   2  run_posix_cpu_timers+0x2b/0x72a	  <-  run_posix_cpu_timers+0x25/0x72a
-   0  scheduler_tick+0x139/0x1bf	  <-  scheduler_tick+0xed/0x1bf
-   0  scheduler_tick+0x17c/0x1bf	  <-  scheduler_tick+0x148/0x1bf
-   2  run_posix_cpu_timers+0x9e/0x72a	  <-  run_posix_cpu_timers+0x5e/0x72a
-   0  scheduler_tick+0x1b6/0x1bf	  <-  scheduler_tick+0x1aa/0x1bf
-
-
-The tracer may be used to dump the trace for the oops'ing cpu on
-a kernel oops into the system log. To enable this,
-ftrace_dump_on_oops must be set. To set ftrace_dump_on_oops, one
-can either use the sysctl function or set it via the proc system
-interface.
-
-  sysctl kernel.ftrace_dump_on_oops=3Dn
-
-or
-
-  echo n > /proc/sys/kernel/ftrace_dump_on_oops
-
-If n =3D 1, ftrace will dump buffers of all CPUs, if n =3D 2 ftrace will
-only dump the buffer of the CPU that triggered the oops.
-
-Here's an example of such a dump after a null pointer
-dereference in a kernel module:
-
-[57848.105921] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000000
-[57848.106019] IP: [<ffffffffa0000006>] open+0x6/0x14 [oops]
-[57848.106019] PGD 2354e9067 PUD 2375e7067 PMD 0
-[57848.106019] Oops: 0002 [#1] SMP
-[57848.106019] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:=
20:05.0/local_cpus
-[57848.106019] Dumping ftrace buffer:
-[57848.106019] ---------------------------------
-[...]
-[57848.106019]    0  chrdev_open+0xe6/0x165	  <-  cdev_put+0x23/0x24
-[57848.106019]    0  chrdev_open+0x117/0x165	  <-  chrdev_open+0xfa/0x165
-[57848.106019]    0  chrdev_open+0x120/0x165	  <-  chrdev_open+0x11c/0x165
-[57848.106019]    0  chrdev_open+0x134/0x165	  <-  chrdev_open+0x12b/0x165
-[57848.106019]    0  open+0x0/0x14 [oops]	  <-  chrdev_open+0x144/0x165
-[57848.106019]    0  page_fault+0x0/0x30	  <-  open+0x6/0x14 [oops]
-[57848.106019]    0  error_entry+0x0/0x5b	  <-  page_fault+0x4/0x30
-[57848.106019]    0  error_kernelspace+0x0/0x31	  <-  error_entry+0x59/0x5b
-[57848.106019]    0  error_sti+0x0/0x1	  <-  error_kernelspace+0x2d/0x31
-[57848.106019]    0  page_fault+0x9/0x30	  <-  error_sti+0x0/0x1
-[57848.106019]    0  do_page_fault+0x0/0x881	  <-  page_fault+0x1a/0x30
-[...]
-[57848.106019]    0  do_page_fault+0x66b/0x881	  <-  is_prefetch+0x1ee/0x1=
f2
-[57848.106019]    0  do_page_fault+0x6e0/0x881	  <-  do_page_fault+0x67a/0=
x881
-[57848.106019]    0  oops_begin+0x0/0x96	  <-  do_page_fault+0x6e0/0x881
-[57848.106019]    0  trace_hw_branch_oops+0x0/0x2d	  <-  oops_begin+0x9/0x=
96
-[...]
-[57848.106019]    0  ds_suspend_bts+0x2a/0xe3	  <-  ds_suspend_bts+0x1a/0x=
e3
-[57848.106019] ---------------------------------
-[57848.106019] CPU 0
-[57848.106019] Modules linked in: oops
-[57848.106019] Pid: 5542, comm: cat Tainted: G        W  2.6.28 #23
-[57848.106019] RIP: 0010:[<ffffffffa0000006>]  [<ffffffffa0000006>] open+0=
x6/0x14 [oops]
-[57848.106019] RSP: 0018:ffff880235457d48  EFLAGS: 00010246
-[...]
+------
+#!/bin/bash
+
+debugfs=3D`sed -ne 's/^debugfs \(.*\) debugfs.*/\1/p' /proc/mounts`
+echo nop > $debugfs/tracing/current_tracer
+echo 0 > $debugfs/tracing/tracing_on
+echo $$ > $debugfs/tracing/set_ftrace_pid
+echo function > $debugfs/tracing/current_tracer
+echo 1 > $debugfs/tracing/tracing_on
+exec "$@"
+------
=20
=20
 function graph tracer
@@ -1473,16 +2028,18 @@ starts of pointing to a simple return. (Enabling FT=
RACE will
 include the -pg switch in the compiling of the kernel.)
=20
 At compile time every C file object is run through the
-recordmcount.pl script (located in the scripts directory). This
-script will process the C object using objdump to find all the
-locations in the .text section that call mcount. (Note, only the
-.text section is processed, since processing other sections like
-.init.text may cause races due to those sections being freed).
+recordmcount program (located in the scripts directory). This
+program will parse the ELF headers in the C object to find all
+the locations in the .text section that call mcount. (Note, only
+white listed .text sections are processed, since processing other
+sections like .init.text may cause races due to those sections
+being freed unexpectedly).
=20
 A new section called "__mcount_loc" is created that holds
 references to all the mcount call sites in the .text section.
-This section is compiled back into the original object. The
-final linker will add all these references into a single table.
+The recordmcount program re-links this section back into the
+original object. The final linking stage of the kernel will add all these
+references into a single table.
=20
 On boot up, before SMP is initialized, the dynamic ftrace code
 scans this table and updates all the locations into nops. It
@@ -1493,13 +2050,25 @@ unloaded, it also removes its functions from the ft=
race function
 list. This is automatic in the module unload code, and the
 module author does not need to worry about it.
=20
-When tracing is enabled, kstop_machine is called to prevent
-races with the CPUS executing code being modified (which can
-cause the CPU to do undesirable things), and the nops are
+When tracing is enabled, the process of modifying the function
+tracepoints is dependent on architecture. The old method is to use
+kstop_machine to prevent races with the CPUs executing code being
+modified (which can cause the CPU to do undesirable things, especially
+if the modified code crosses cache (or page) boundaries), and the nops are
 patched back to calls. But this time, they do not call mcount
 (which is just a function stub). They now call into the ftrace
 infrastructure.
=20
+The new method of modifying the function tracepoints is to place
+a breakpoint at the location to be modified, sync all CPUs, modify
+the rest of the instruction not covered by the breakpoint. Sync
+all CPUs again, and then remove the breakpoint with the finished
+version to the ftrace call site.
+
+Some archs do not even need to monkey around with the synchronization,
+and can just slap the new code on top of the old without any
+problems with other CPUs executing it at the same time.
+
 One special side-effect to the recording of the functions being
 traced is that we can now selectively choose which functions we
 wish to trace and which ones we want the mcount calls to remain
@@ -1530,20 +2099,28 @@ mutex_lock
=20
 If I am only interested in sys_nanosleep and hrtimer_interrupt:
=20
- # echo sys_nanosleep hrtimer_interrupt \
-		> set_ftrace_filter
+ # echo sys_nanosleep hrtimer_interrupt > set_ftrace_filter
  # echo function > current_tracer
  # echo 1 > tracing_on
  # usleep 1
  # echo 0 > tracing_on
  # cat trace
-# tracer: ftrace
+# tracer: function
+#
+# entries-in-buffer/entries-written: 5/5   #P:4
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-          usleep-4134  [00]  1317.070017: hrtimer_interrupt <-smp_apic_tim=
er_interrupt
-          usleep-4134  [00]  1317.070111: sys_nanosleep <-syscall_call
-          <idle>-0     [00]  1317.070115: hrtimer_interrupt <-smp_apic_tim=
er_interrupt
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          usleep-2665  [001] ....  4186.475355: sys_nanosleep <-system_cal=
l_fastpath
+          <idle>-0     [001] d.h1  4186.475409: hrtimer_interrupt <-smp_ap=
ic_timer_interrupt
+          usleep-2665  [001] d.h1  4186.475426: hrtimer_interrupt <-smp_ap=
ic_timer_interrupt
+          <idle>-0     [003] d.h1  4186.475426: hrtimer_interrupt <-smp_ap=
ic_timer_interrupt
+          <idle>-0     [002] d.h1  4186.475427: hrtimer_interrupt <-smp_ap=
ic_timer_interrupt
=20
 To see which functions are being traced, you can cat the file:
=20
@@ -1571,20 +2148,25 @@ Note: It is better to use quotes to enclose the wil=
d cards,
=20
 Produces:
=20
-# tracer: ftrace
+# tracer: function
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-            bash-4003  [00]  1480.611794: hrtimer_init <-copy_process
-            bash-4003  [00]  1480.611941: hrtimer_start <-hrtick_set
-            bash-4003  [00]  1480.611956: hrtimer_cancel <-hrtick_clear
-            bash-4003  [00]  1480.611956: hrtimer_try_to_cancel <-hrtimer_=
cancel
-          <idle>-0     [00]  1480.612019: hrtimer_get_next_event <-get_nex=
t_timer_interrupt
-          <idle>-0     [00]  1480.612025: hrtimer_get_next_event <-get_nex=
t_timer_interrupt
-          <idle>-0     [00]  1480.612032: hrtimer_get_next_event <-get_nex=
t_timer_interrupt
-          <idle>-0     [00]  1480.612037: hrtimer_get_next_event <-get_nex=
t_timer_interrupt
-          <idle>-0     [00]  1480.612382: hrtimer_get_next_event <-get_nex=
t_timer_interrupt
-
+# entries-in-buffer/entries-written: 897/897   #P:4
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [003] dN.1  4228.547803: hrtimer_cancel <-tick_nohz=
_idle_exit
+          <idle>-0     [003] dN.1  4228.547804: hrtimer_try_to_cancel <-hr=
timer_cancel
+          <idle>-0     [003] dN.2  4228.547805: hrtimer_force_reprogram <-=
__remove_hrtimer
+          <idle>-0     [003] dN.1  4228.547805: hrtimer_forward <-tick_noh=
z_idle_exit
+          <idle>-0     [003] dN.1  4228.547805: hrtimer_start_range_ns <-h=
rtimer_start_expires.constprop.11
+          <idle>-0     [003] d..1  4228.547858: hrtimer_get_next_event <-g=
et_next_timer_interrupt
+          <idle>-0     [003] d..1  4228.547859: hrtimer_start <-__tick_noh=
z_idle_enter
+          <idle>-0     [003] d..2  4228.547860: hrtimer_force_reprogram <-=
__rem
=20
 Notice that we lost the sys_nanosleep.
=20
@@ -1651,19 +2233,29 @@ traced.
=20
 Produces:
=20
-# tracer: ftrace
+# tracer: function
+#
+# entries-in-buffer/entries-written: 39608/39608   #P:4
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
-            bash-4043  [01]   115.281644: finish_task_switch <-schedule
-            bash-4043  [01]   115.281645: hrtick_set <-schedule
-            bash-4043  [01]   115.281645: hrtick_clear <-hrtick_set
-            bash-4043  [01]   115.281646: wait_for_completion <-__stop_mac=
hine_run
-            bash-4043  [01]   115.281647: wait_for_common <-wait_for_compl=
etion
-            bash-4043  [01]   115.281647: kthread_stop <-stop_machine_run
-            bash-4043  [01]   115.281648: init_waitqueue_head <-kthread_st=
op
-            bash-4043  [01]   115.281648: wake_up_process <-kthread_stop
-            bash-4043  [01]   115.281649: try_to_wake_up <-wake_up_process
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+            bash-1994  [000] ....  4342.324896: file_ra_state_init <-do_de=
ntry_open
+            bash-1994  [000] ....  4342.324897: open_check_o_direct <-do_l=
ast
+            bash-1994  [000] ....  4342.324897: ima_file_check <-do_last
+            bash-1994  [000] ....  4342.324898: process_measurement <-ima_=
file_check
+            bash-1994  [000] ....  4342.324898: ima_get_action <-process_m=
easurement
+            bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get=
_action
+            bash-1994  [000] ....  4342.324899: do_truncate <-do_last
+            bash-1994  [000] ....  4342.324899: should_remove_suid <-do_tr=
uncate
+            bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
+            bash-1994  [000] ....  4342.324900: current_fs_time <-notify_c=
hange
+            bash-1994  [000] ....  4342.324900: current_kernel_time <-curr=
ent_fs_time
+            bash-1994  [000] ....  4342.324900: timespec_trunc <-current_f=
s_time
=20
 We can see that there's no more lock or preempt tracing.
=20
@@ -1729,6 +2321,28 @@ this special filter via:
  echo > set_graph_function
=20
=20
+ftrace_enabled
+--------------
+
+Note, the proc sysctl ftrace_enable is a big on/off switch for the
+function tracer. By default it is enabled (when function tracing is
+enabled in the kernel). If it is disabled, all function tracing is
+disabled. This includes not only the function tracers for ftrace, but
+also for any other uses (perf, kprobes, stack tracing, profiling, etc).
+
+Please disable this with care.
+
+This can be disable (and enabled) with:
+
+  sysctl kernel.ftrace_enabled=3D0
+  sysctl kernel.ftrace_enabled=3D1
+
+ or
+
+  echo 0 > /proc/sys/kernel/ftrace_enabled
+  echo 1 > /proc/sys/kernel/ftrace_enabled
+
+
 Filter commands
 ---------------
=20
@@ -1763,12 +2377,58 @@ The following commands are supported:
=20
    echo '__schedule_bug:traceoff:5' > set_ftrace_filter
=20
+  To always disable tracing when __schedule_bug is hit:
+
+   echo '__schedule_bug:traceoff' > set_ftrace_filter
+
   These commands are cumulative whether or not they are appended
   to set_ftrace_filter. To remove a command, prepend it by '!'
   and drop the parameter:
=20
+   echo '!__schedule_bug:traceoff:0' > set_ftrace_filter
+
+    The above removes the traceoff command for __schedule_bug
+    that have a counter. To remove commands without counters:
+
    echo '!__schedule_bug:traceoff' > set_ftrace_filter
=20
+- snapshot
+  Will cause a snapshot to be triggered when the function is hit.
+
+   echo 'native_flush_tlb_others:snapshot' > set_ftrace_filter
+
+  To only snapshot once:
+
+   echo 'native_flush_tlb_others:snapshot:1' > set_ftrace_filter
+
+  To remove the above commands:
+
+   echo '!native_flush_tlb_others:snapshot' > set_ftrace_filter
+   echo '!native_flush_tlb_others:snapshot:0' > set_ftrace_filter
+
+- enable_event/disable_event
+  These commands can enable or disable a trace event. Note, because
+  function tracing callbacks are very sensitive, when these commands
+  are registered, the trace point is activated, but disabled in
+  a "soft" mode. That is, the tracepoint will be called, but
+  just will not be traced. The event tracepoint stays in this mode
+  as long as there's a command that triggers it.
+
+   echo 'try_to_wake_up:enable_event:sched:sched_switch:2' > \
+   	 set_ftrace_filter
+
+  The format is:
+
+    <function>:enable_event:<system>:<event>[:count]
+    <function>:disable_event:<system>:<event>[:count]
+
+  To remove the events commands:
+
+
+   echo '!try_to_wake_up:enable_event:sched:sched_switch:0' > \
+   	 set_ftrace_filter
+   echo '!schedule:disable_event:sched:sched_switch' > \
+   	 set_ftrace_filter
=20
 trace_pipe
 ----------
@@ -1787,28 +2447,31 @@ different. The trace is live.
  # cat trace
 # tracer: function
 #
-#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
-#              | |      |          |         |
+# entries-in-buffer/entries-written: 0/0   #P:4
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
=20
  #
  # cat /tmp/trace.out
-            bash-4043  [00] 41.267106: finish_task_switch <-schedule
-            bash-4043  [00] 41.267106: hrtick_set <-schedule
-            bash-4043  [00] 41.267107: hrtick_clear <-hrtick_set
-            bash-4043  [00] 41.267108: wait_for_completion <-__stop_machin=
e_run
-            bash-4043  [00] 41.267108: wait_for_common <-wait_for_completi=
on
-            bash-4043  [00] 41.267109: kthread_stop <-stop_machine_run
-            bash-4043  [00] 41.267109: init_waitqueue_head <-kthread_stop
-            bash-4043  [00] 41.267110: wake_up_process <-kthread_stop
-            bash-4043  [00] 41.267110: try_to_wake_up <-wake_up_process
-            bash-4043  [00] 41.267111: select_task_rq_rt <-try_to_wake_up
+            bash-1994  [000] ....  5281.568961: mutex_unlock <-rb_simple_w=
rite
+            bash-1994  [000] ....  5281.568963: __mutex_unlock_slowpath <-=
mutex_unlock
+            bash-1994  [000] ....  5281.568963: __fsnotify_parent <-fsnoti=
fy_modify
+            bash-1994  [000] ....  5281.568964: fsnotify <-fsnotify_modify
+            bash-1994  [000] ....  5281.568964: __srcu_read_lock <-fsnotify
+            bash-1994  [000] ....  5281.568964: add_preempt_count <-__srcu=
_read_lock
+            bash-1994  [000] ...1  5281.568965: sub_preempt_count <-__srcu=
_read_lock
+            bash-1994  [000] ....  5281.568965: __srcu_read_unlock <-fsnot=
ify
+            bash-1994  [000] ....  5281.568967: sys_dup2 <-system_call_fas=
tpath
=20
=20
 Note, reading the trace_pipe file will block until more input is
-added. By changing the tracer, trace_pipe will issue an EOF. We
-needed to set the function tracer _before_ we "cat" the
-trace_pipe file.
-
+added.
=20
 trace entries
 -------------
@@ -1817,31 +2480,50 @@ Having too much or not enough data can be troubleso=
me in
 diagnosing an issue in the kernel. The file buffer_size_kb is
 used to modify the size of the internal trace buffers. The
 number listed is the number of entries that can be recorded per
-CPU. To know the full size, multiply the number of possible CPUS
+CPU. To know the full size, multiply the number of possible CPUs
 with the number of entries.
=20
  # cat buffer_size_kb
 1408 (units kilobytes)
=20
-Note, to modify this, you must have tracing completely disabled.
-To do that, echo "nop" into the current_tracer. If the
-current_tracer is not set to "nop", an EINVAL error will be
-returned.
+Or simply read buffer_total_size_kb
+
+ # cat buffer_total_size_kb=20
+5632
+
+To modify the buffer, simple echo in a number (in 1024 byte segments).
=20
- # echo nop > current_tracer
  # echo 10000 > buffer_size_kb
  # cat buffer_size_kb
 10000 (units kilobytes)
=20
-The number of pages which will be allocated is limited to a
-percentage of available memory. Allocating too much will produce
-an error.
+It will try to allocate as much as possible. If you allocate too
+much, it can cause Out-Of-Memory to trigger.
=20
  # echo 1000000000000 > buffer_size_kb
 -bash: echo: write error: Cannot allocate memory
  # cat buffer_size_kb
 85
=20
+The per_cpu buffers can be changed individually as well:
+
+ # echo 10000 > per_cpu/cpu0/buffer_size_kb
+ # echo 100 > per_cpu/cpu1/buffer_size_kb
+
+When the per_cpu buffers are not the same, the buffer_size_kb
+at the top level will just show an X
+
+ # cat buffer_size_kb
+X
+
+This is where the buffer_total_size_kb is useful:
+
+ # cat buffer_total_size_kb=20
+12916
+
+Writing to the top level buffer_size_kb will reset all the buffers
+to be the same again.
+
 Snapshot
 --------
 CONFIG_TRACER_SNAPSHOT makes a generic snapshot feature
@@ -1925,7 +2607,188 @@ bash: echo: write error: Device or resource busy
  # cat snapshot
 cat: snapshot: Device or resource busy
=20
+
+Instances
+---------
+In the debugfs tracing directory is a directory called "instances".
+This directory can have new directories created inside of it using
+mkdir, and removing directories with rmdir. The directory created
+with mkdir in this directory will already contain files and other
+directories after it is created.
+
+ # mkdir instances/foo
+ # ls instances/foo
+buffer_size_kb  buffer_total_size_kb  events  free_buffer  per_cpu
+set_event  snapshot  trace  trace_clock  trace_marker  trace_options
+trace_pipe  tracing_on
+
+As you can see, the new directory looks similar to the tracing directory
+itself. In fact, it is very similar, except that the buffer and
+events are agnostic from the main director, or from any other
+instances that are created.
+
+The files in the new directory work just like the files with the
+same name in the tracing directory except the buffer that is used
+is a separate and new buffer. The files affect that buffer but do not
+affect the main buffer with the exception of trace_options. Currently,
+the trace_options affect all instances and the top level buffer
+the same, but this may change in future releases. That is, options
+may become specific to the instance they reside in.
+
+Notice that none of the function tracer files are there, nor is
+current_tracer and available_tracers. This is because the buffers
+can currently only have events enabled for them.
+
+ # mkdir instances/foo
+ # mkdir instances/bar
+ # mkdir instances/zoot
+ # echo 100000 > buffer_size_kb
+ # echo 1000 > instances/foo/buffer_size_kb
+ # echo 5000 > instances/bar/per_cpu/cpu1/buffer_size_kb
+ # echo function > current_trace
+ # echo 1 > instances/foo/events/sched/sched_wakeup/enable
+ # echo 1 > instances/foo/events/sched/sched_wakeup_new/enable
+ # echo 1 > instances/foo/events/sched/sched_switch/enable
+ # echo 1 > instances/bar/events/irq/enable
+ # echo 1 > instances/zoot/events/syscalls/enable
+ # cat trace_pipe
+CPU:2 [LOST 11745 EVENTS]
+            bash-2044  [002] .... 10594.481032: _raw_spin_lock_irqsave <-g=
et_page_from_freelist
+            bash-2044  [002] d... 10594.481032: add_preempt_count <-_raw_s=
pin_lock_irqsave
+            bash-2044  [002] d..1 10594.481032: __rmqueue <-get_page_from_=
freelist
+            bash-2044  [002] d..1 10594.481033: _raw_spin_unlock <-get_pag=
e_from_freelist
+            bash-2044  [002] d..1 10594.481033: sub_preempt_count <-_raw_s=
pin_unlock
+            bash-2044  [002] d... 10594.481033: get_pageblock_flags_group =
<-get_pageblock_migratetype
+            bash-2044  [002] d... 10594.481034: __mod_zone_page_state <-ge=
t_page_from_freelist
+            bash-2044  [002] d... 10594.481034: zone_statistics <-get_page=
_from_freelist
+            bash-2044  [002] d... 10594.481034: __inc_zone_state <-zone_st=
atistics
+            bash-2044  [002] d... 10594.481034: __inc_zone_state <-zone_st=
atistics
+            bash-2044  [002] .... 10594.481035: arch_dup_task_struct <-cop=
y_process
+[...]
+
+ # cat instances/foo/trace_pipe
+            bash-1998  [000] d..4   136.676759: sched_wakeup: comm=3Dkwork=
er/0:1 pid=3D59 prio=3D120 success=3D1 target_cpu=3D000
+            bash-1998  [000] dN.4   136.676760: sched_wakeup: comm=3Dbash =
pid=3D1998 prio=3D120 success=3D1 target_cpu=3D000
+          <idle>-0     [003] d.h3   136.676906: sched_wakeup: comm=3Drcu_p=
reempt pid=3D9 prio=3D120 success=3D1 target_cpu=3D003
+          <idle>-0     [003] d..3   136.676909: sched_switch: prev_comm=3D=
swapper/3 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Dr=
cu_preempt next_pid=3D9 next_prio=3D120
+     rcu_preempt-9     [003] d..3   136.676916: sched_switch: prev_comm=3D=
rcu_preempt prev_pid=3D9 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=
=3Dswapper/3 next_pid=3D0 next_prio=3D120
+            bash-1998  [000] d..4   136.677014: sched_wakeup: comm=3Dkwork=
er/0:1 pid=3D59 prio=3D120 success=3D1 target_cpu=3D000
+            bash-1998  [000] dN.4   136.677016: sched_wakeup: comm=3Dbash =
pid=3D1998 prio=3D120 success=3D1 target_cpu=3D000
+            bash-1998  [000] d..3   136.677018: sched_switch: prev_comm=3D=
bash prev_pid=3D1998 prev_prio=3D120 prev_state=3DR+ =3D=3D> next_comm=3Dkw=
orker/0:1 next_pid=3D59 next_prio=3D120
+     kworker/0:1-59    [000] d..4   136.677022: sched_wakeup: comm=3Dsshd =
pid=3D1995 prio=3D120 success=3D1 target_cpu=3D001
+     kworker/0:1-59    [000] d..3   136.677025: sched_switch: prev_comm=3D=
kworker/0:1 prev_pid=3D59 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=
=3Dbash next_pid=3D1998 next_prio=3D120
+[...]
+
+ # cat instances/bar/trace_pipe
+     migration/1-14    [001] d.h3   138.732674: softirq_raise: vec=3D3 [ac=
tion=3DNET_RX]
+          <idle>-0     [001] dNh3   138.732725: softirq_raise: vec=3D3 [ac=
tion=3DNET_RX]
+            bash-1998  [000] d.h1   138.733101: softirq_raise: vec=3D1 [ac=
tion=3DTIMER]
+            bash-1998  [000] d.h1   138.733102: softirq_raise: vec=3D9 [ac=
tion=3DRCU]
+            bash-1998  [000] ..s2   138.733105: softirq_entry: vec=3D1 [ac=
tion=3DTIMER]
+            bash-1998  [000] ..s2   138.733106: softirq_exit: vec=3D1 [act=
ion=3DTIMER]
+            bash-1998  [000] ..s2   138.733106: softirq_entry: vec=3D9 [ac=
tion=3DRCU]
+            bash-1998  [000] ..s2   138.733109: softirq_exit: vec=3D9 [act=
ion=3DRCU]
+            sshd-1995  [001] d.h1   138.733278: irq_handler_entry: irq=3D2=
1 name=3Duhci_hcd:usb4
+            sshd-1995  [001] d.h1   138.733280: irq_handler_exit: irq=3D21=
 ret=3Dunhandled
+            sshd-1995  [001] d.h1   138.733281: irq_handler_entry: irq=3D2=
1 name=3Deth0
+            sshd-1995  [001] d.h1   138.733283: irq_handler_exit: irq=3D21=
 ret=3Dhandled
+[...]
+
+ # cat instances/zoot/trace
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 18996/18996   #P:4
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+            bash-1998  [000] d...   140.733501: sys_write -> 0x2
+            bash-1998  [000] d...   140.733504: sys_dup2(oldfd: a, newfd: =
1)
+            bash-1998  [000] d...   140.733506: sys_dup2 -> 0x1
+            bash-1998  [000] d...   140.733508: sys_fcntl(fd: a, cmd: 1, a=
rg: 0)
+            bash-1998  [000] d...   140.733509: sys_fcntl -> 0x1
+            bash-1998  [000] d...   140.733510: sys_close(fd: a)
+            bash-1998  [000] d...   140.733510: sys_close -> 0x0
+            bash-1998  [000] d...   140.733514: sys_rt_sigprocmask(how: 0,=
 nset: 0, oset: 6e2768, sigsetsize: 8)
+            bash-1998  [000] d...   140.733515: sys_rt_sigprocmask -> 0x0
+            bash-1998  [000] d...   140.733516: sys_rt_sigaction(sig: 2, a=
ct: 7fff718846f0, oact: 7fff71884650, sigsetsize: 8)
+            bash-1998  [000] d...   140.733516: sys_rt_sigaction -> 0x0
+
+You can see that the trace of the top most trace buffer shows only
+the function tracing. The foo instance displays wakeups and task
+switches.
+
+To remove the instances, simply delete their directories:
+
+ # rmdir instances/foo
+ # rmdir instances/bar
+ # rmdir instances/zoot
+
+Note, if a process has a trace file open in one of the instance
+directories, the rmdir will fail with EBUSY.
+
+
+Stack trace
 -----------
+Since the kernel has a fixed sized stack, it is important not to
+waste it in functions. A kernel developer must be conscience of
+what they allocate on the stack. If they add too much, the system
+can be in danger of a stack overflow, and corruption will occur,
+usually leading to a system panic.
+
+There are some tools that check this, usually with interrupts
+periodically checking usage. But if you can perform a check
+at every function call that will become very useful. As ftrace provides
+a function tracer, it makes it convenient to check the stack size
+at every function call. This is enabled via the stack tracer.
+
+CONFIG_STACK_TRACER enables the ftrace stack tracing functionality.
+To enable it, write a '1' into /proc/sys/kernel/stack_tracer_enabled.
+
+ # echo 1 > /proc/sys/kernel/stack_tracer_enabled
+
+You can also enable it from the kernel command line to trace
+the stack size of the kernel during boot up, by adding "stacktrace"
+to the kernel command line parameter.
+
+After running it for a few minutes, the output looks like:
+
+ # cat stack_max_size
+2928
+
+ # cat stack_trace
+        Depth    Size   Location    (18 entries)
+        -----    ----   --------
+  0)     2928     224   update_sd_lb_stats+0xbc/0x4ac
+  1)     2704     160   find_busiest_group+0x31/0x1f1
+  2)     2544     256   load_balance+0xd9/0x662
+  3)     2288      80   idle_balance+0xbb/0x130
+  4)     2208     128   __schedule+0x26e/0x5b9
+  5)     2080      16   schedule+0x64/0x66
+  6)     2064     128   schedule_timeout+0x34/0xe0
+  7)     1936     112   wait_for_common+0x97/0xf1
+  8)     1824      16   wait_for_completion+0x1d/0x1f
+  9)     1808     128   flush_work+0xfe/0x119
+ 10)     1680      16   tty_flush_to_ldisc+0x1e/0x20
+ 11)     1664      48   input_available_p+0x1d/0x5c
+ 12)     1616      48   n_tty_poll+0x6d/0x134
+ 13)     1568      64   tty_poll+0x64/0x7f
+ 14)     1504     880   do_select+0x31e/0x511
+ 15)      624     400   core_sys_select+0x177/0x216
+ 16)      224      96   sys_select+0x91/0xb9
+ 17)      128     128   system_call_fastpath+0x16/0x1b
+
+Note, if -mfentry is being used by gcc, functions get traced before
+they set up the stack frame. This means that leaf level functions
+are not tested by the stack tracer when -mfentry is used.
+
+Currently, -mfentry is used by gcc 4.6.0 and above on x86 only.
+
+---------
=20
 More details can be found in the source code, in the
 kernel/trace/*.c files.
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u+AAoJEOdOSU1xswtMTIoIAMeDABtY+aV8oLfkK1VlidLx
ls4MNFNENXorIRqGwZLhXLhoB+sl28r93n/758AmB1pzinIPwhpO2M/bUNDqhePn
xEVVGuslaJlgYn25oBN3qsqSX1TQmiKGe3tl5pRWsOeczX7+2IUO/WxH4q0BgWw+
9h5CxFisJLHzFU8QsV9a80VL1wD7/4Dd5TtlOIwrqAS8QRpH6xT+8A75Nhm4dbJe
+HIzJzaLsn4l1FpJngBCgMZ6qt3NKa5k7P6qjAloo/WHiIt3MgJxxq0S7iXhw7va
Q7naVNQKhfoCkeUrcTvC/TKFjKWF8tH41cgjDMJenR0QwPVSOO/Rac3nibzvkJg=
=TYGJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
