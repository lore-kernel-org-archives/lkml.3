Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaKEMue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:50:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:36675 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaKEMuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:50:32 -0500
Date: Wed, 5 Nov 2014 13:50:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
Message-ID: <20141105125028.GA30087@linutronix.de>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <545829CA.7040900@voxpopuli.im>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexandre Montplaisir | 2014-11-04 02:20:10 [+0100]:

>Hi Sebastian,
Hi Alexandre,

>On 11/03/2014 06:58 PM, Sebastian Andrzej Siewior wrote:
>This is really great! Initially, I had believed that we would have
>needed to add a separate parser plugin, and to consider "perf traces"
>as a completely different beast from LTTng traces. However if you can
>get this close to they way LTTng presents its data, then we can
>probably re-use most of the existing code. In which case we could
>rename the "LTTng Kernel Trace" type in the UI to simply "Linux
>Kernel Trace". And that would cover both LTTng kernel traces and
>CTF-perf traces.

we have now CTF here. So lets see what we do about the naming 
convention.

>>The cpu_id field change will be addressed soon on our side.
>>Now, the remaining things:
>>The "domain = kernel" thingy (or another identifier if desired) is
>>something we could add.
>
>Unless the event data is exactly the same, it would be easier to use
>a different name. Like "kernel-perf" for instance?

Some kind of a namespace / identifier is probably not wrong. The lttng 
tracer added a tracer version probably in case the format changes 
between version for some reason. Perf comes with the kernel so for this
the kernel version should sufficient.

>From the user's point of view, both would still be Linux Kernel
>Traces, but we could use the domain internally to determine which
>event/field layout to use.
>
>Mathieu, any thoughts on how CTF domains should be namespaced?
>
>>Now that I identified the differences between the CTF from lttng and
>>perf, any suggestions / ideas how this could be solved?
>
>I suppose it would be better/cleaner if the event and field names
>would remain the same, or at least be similar, in the perf.data and
>perf-CTF formats.

Yes, that would be cool. Especially if we teach perf to record straight 
to CTF.

>If the trace events from both LTTng and perf represent the same thing
>(and I assume they should, since they come from the same tracepoints,
>right?), then we could just add a wrapper on the viewer side to
>decide which event/field names to use, depending on the trace type.
>
>Right now, we only define LTTng event and field names:
>http://git.eclipse.org/c/tracecompass/org.eclipse.tracecompass.git/tree/org.eclipse.tracecompass.lttng2.kernel.core/src/org/eclipse/tracecompass/internal/lttng2/kernel/core/LttngStrings.java

Okay. So I found this file for linuxtools now let me try tracecompass.
The basic renaming should do the job. Then I have to figure out how to
compile this thingy…

There is this one thing where you go for "tid" while perf says "pid". I
guess I could figure that out once I have the rename done.
We don't have lttng_statedump_process_state, this look lttng specific. I
would have to look if there is a replacement event in perf. 

I have no idea what we could do about the "unknown" events, say someone 
enbales skb tracing. But this is probably something for once we are 
done with the basic integration.

>But if you could for example tell me the perf equivalents of all the
>strings in that file, I could hack together such wrapper. With that,
>in theory, perf traces should behave exactly the same as LTTng traces
>in the viewer!

Oooh, that would be awesome. So I installed maven but didn't get much 
further. Let me gather this for you.

So first the renaming:
diff --git a/LttngStrings.java b/LttngStrings.java
--- a/LttngStrings.java
+++ b/LttngStrings.java
@@ -27,17 +27,17 @@ public interface LttngStrings {
 
     /* Event names */
     static final String EXIT_SYSCALL = "exit_syscall";
-    static final String IRQ_HANDLER_ENTRY = "irq_handler_entry";
-    static final String IRQ_HANDLER_EXIT = "irq_handler_exit";
-    static final String SOFTIRQ_ENTRY = "softirq_entry";
-    static final String SOFTIRQ_EXIT = "softirq_exit";
-    static final String SOFTIRQ_RAISE = "softirq_raise";
-    static final String SCHED_SWITCH = "sched_switch";
-    static final String SCHED_WAKEUP = "sched_wakeup";
-    static final String SCHED_WAKEUP_NEW = "sched_wakeup_new";
-    static final String SCHED_PROCESS_FORK = "sched_process_fork";
-    static final String SCHED_PROCESS_EXIT = "sched_process_exit";
-    static final String SCHED_PROCESS_FREE = "sched_process_free";
+    static final String IRQ_HANDLER_ENTRY = "irq:irq_handler_entry";
+    static final String IRQ_HANDLER_EXIT = "irq:irq_handler_exit";
+    static final String SOFTIRQ_ENTRY = "irq:softirq_entry";
+    static final String SOFTIRQ_EXIT = "irq:softirq_exit";
+    static final String SOFTIRQ_RAISE = "irq:softirq_raise";
+    static final String SCHED_SWITCH = "sched:sched_switch";
+    static final String SCHED_WAKEUP = "sched:sched_wakeup";
+    static final String SCHED_WAKEUP_NEW = "sched:sched_wakeup_new";
+    static final String SCHED_PROCESS_FORK = "sched:sched_process_fork";
+    static final String SCHED_PROCESS_EXIT = "sched:sched_process_exit";
+    static final String SCHED_PROCESS_FREE = "sched:sched_process_free";
     static final String STATEDUMP_PROCESS_STATE = "lttng_statedump_process_state";
 
     /* System call names */

I have no idea how exit_syscall is different from irq_handler_exit and I
think we have to skip for now on STATEDUMP_PROCESS_STATE.

For the syscalls:

- static final String SYSCALL_PREFIX = "sys_";
  It is bassicaly:
    syscalls:sys_enter_
    syscalls:sys_exit_
  depending what you are looking for.

- static final String COMPAT_SYSCALL_PREFIX = "compat_sys_";
  I haven't found this. Could it be that we don't record the compat_sys
  at all?

- static final String SYS_CLONE = "sys_clone";
  here we have 
    syscalls:sys_enter_clone
    syscalls:sys_exit_clone
  I guess the enter is what you are looking for.

For the fields, this is one event with alle the members we have. Please
note that lttng saves the members with the _ prefix and I haven't seen
that prefix in that .java file. The members of each event:

event {
name = "raw_syscalls:sys_enter";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 64; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } args[6];
};

event {
name = "raw_syscalls:sys_exit";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 64; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } id;
	integer { size = 64; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } ret;
};

event {
name = "irq:irq_handler_entry";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } irq;
	string { encoding = UTF8; } name;
};

event {
name = "irq:irq_handler_exit";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } irq;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } ret;
};

event {
name = "irq:softirq_entry";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } vec;
};

event {
name = "irq:softirq_exit";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } vec;
};

event {
name = "irq:softirq_raise";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } vec;
};

event {
name = "sched:sched_switch";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } prev_comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prev_pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prev_prio;
	integer { size = 64; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prev_state;
	string { encoding = UTF8; } next_comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } next_pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } next_prio;
};

event {
name = "sched:sched_wakeup";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prio;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } success;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } target_cpu;
};

event {
name = "sched:sched_wakeup_new";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prio;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } success;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } target_cpu;
};

event {
name = "sched:sched_process_fork";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } parent_comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } parent_pid;
	string { encoding = UTF8; } child_comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } child_pid;
};

event {
name = "sched:sched_process_exit";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prio;
};

event {
name = "sched:sched_process_free";
	integer { size = 64; align = 1; signed = false; encoding = none; base = hexadecimal; byte_order = le; } perf_ip;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_tid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } perf_pid;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_id;
	integer { size = 64; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } perf_period;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_type;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_flags;
	integer { size = 32; align = 1; signed = false; encoding = none; base = decimal; byte_order = le; } common_preempt_count;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } common_pid;
	string { encoding = UTF8; } comm;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } pid;
	integer { size = 32; align = 1; signed = true; encoding = none; base = decimal; byte_order = le; } prio;
};

and here are some example from babeltrace output. One example per event:

raw_syscalls:sys_enter
[03:37:07.579969498] (+?.?????????) raw_syscalls:sys_enter: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF81020EBC, perf_tid = 30004, perf_pid = 30004, perf_id = 382, perf_period = 1, common_type = 76, common_flags = 0, common_preempt_count = 0, common_pid = 30004, id = 16, args = [ [0] = 0xE, [1] = 0x2400, [2] = 0x0, [3] = 0x0, [4] = 0xA20F00, [5] = 0xA1FDA0 ] }

raw_syscalls:sys_exit
[03:37:07.579971763] (+0.000002265) raw_syscalls:sys_exit: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF81020FAD, perf_tid = 30004, perf_pid = 30004, perf_id = 390, perf_period = 1, common_type = 75, common_flags = 0, common_preempt_count = 0, common_pid = 30004, id = 16, ret = 0 }

irq:irq_handler_entry
[03:37:08.088041486] (+0.000000211) irq:irq_handler_entry: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810B8C30, perf_tid = 0, perf_pid = 0, perf_id = 396, perf_period = 1, common_type = 112, common_flags = 9, common_preempt_count = 0, common_pid = 0, irq = 47, name = "ahci" }

irq:irq_handler_exit
[03:37:08.088049506] (+0.000000508) irq:irq_handler_exit: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF810B8C03, perf_tid = 0, perf_pid = 0, perf_id = 404, perf_period = 1, common_type = 111, common_flags = 9, common_preempt_count = 0, common_pid = 0, irq = 47, ret = 1 }

irq:softirq_entry
[03:37:07.583335617] (+0.000001100) irq:softirq_entry: { cpu_id = 3 }, { perf_ip = 0xFFFFFFFF8106A6DC, perf_tid = 0, perf_pid = 0, perf_id = 415, perf_period = 1, common_type = 110, common_flags = 16, common_preempt_count = 0, common_pid = 0, vec = 1 }

irq:softirq_exit
[03:37:07.583336555] (+0.000000619) irq:softirq_exit: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF8106A6AC, perf_tid = 30004, perf_pid = 30004, perf_id = 422, perf_period = 1, common_type = 109, common_flags = 16, common_preempt_count = 0, common_pid = 30004, vec = 1 }

irq:softirq_raise
[03:37:07.583333374] (+0.000002067) irq:softirq_raise: { cpu_id = 3 }, { perf_ip = 0xFFFFFFFF8106AA7C, perf_tid = 0, perf_pid = 0, perf_id = 431, perf_period = 1, common_type = 108, common_flags = 9, common_preempt_count = 0, common_pid = 0, vec = 1 }

sched:sched_switch
[03:37:07.583339259] (+0.000000046) sched:sched_switch: { cpu_id = 3 }, { perf_ip = 0xFFFFFFFF81508B48, perf_tid = 0, perf_pid = 0, perf_id = 439, perf_period = 1, common_type = 312, common_flags = 1, common_preempt_count = 0, common_pid = 0, prev_comm = "swapper/3", prev_pid = 0, prev_prio = 120, prev_state = 0, next_comm = "rcu_sched", next_pid = 7, next_prio = 120 }

sched:sched_wakeup
[03:37:07.583336717] (+0.000000162) sched:sched_wakeup: { cpu_id = 3 }, { perf_ip = 0xFFFFFFFF81092112, perf_tid = 0, perf_pid = 0, perf_id = 447, perf_period = 1, common_type = 314, common_flags = 53, common_preempt_count = 0, common_pid = 0, comm = "rcu_sched", pid = 7, prio = 120, success = 1, target_cpu = 3 }

sched:sched_wakeup_new
[04:16:12.328543282] (+0.000005791) sched:sched_wakeup_new: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF810944B2, perf_tid = 2819, perf_pid = 2819 , perf_id = 486, perf_period = 1, common_type = 313, common_flags = 1, common_preempt_count = 0, common_pid = 2819, comm = "bash", pid = 32604, prio = 120, success = 1, target_cpu = 7 }

sched:sched_process_fork
[04:16:12.328537491] (+?.?????????) sched:sched_process_fork: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF810649D0, perf_tid = 2819, perf_pid = 28 19, perf_id = 494, perf_period = 1, common_type = 306, common_flags = 0, common_preempt_count = 0, common_pid = 2819, parent_comm = "bash", parent_pid = 2819, child_comm = "bash", child_pid = 32604 }

sched:sched_process_exit
[04:16:12.350957386] (+0.022414104) sched:sched_process_exit: { cpu_id = 0 }, { perf_ip = 0xFFFFFFFF81067FED, perf_tid = 32604, perf_pid = 32604, perf_id = 500, perf_period = 1, common_type = 309, common_flags = 0, common_preempt_count = 0, common_pid = 32604, comm = "ps", pid = 32604, prio = 120 }

sched:sched_process_free
[04:16:12.382175653] (+0.031218267) sched:sched_process_free: { cpu_id = 2 }, { perf_ip = 0xFFFFFFFF810663FD, perf_tid = 18, perf_pid = 18, perf_id = 510, perf_period = 1, common_type = 310, common_flags = 16, common_preempt_count = 0, common_pid = 18, comm = "ps", pid = 32604, prio = 120 }

The complete babeltrace output from my sample trace is at
    https://breakpoint.cc/perf-ctf

>Cheers,
>Alexandre

Sebastian
