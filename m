Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbbAOP30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:29:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:2511 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754064AbbAOP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:29:23 -0500
Message-Id: <20150115152801.855110791@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 15 Jan 2015 10:28:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 0/5] [GIT PULL] ftrace: jprobe, syscall and other fixes
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This holds a few fixes to the ftrace infrastructure as well as
the mixture of function graph tracing and kprobes.

When jprobes and function graph tracing is enabled at the same time
it will crash the system.

  # modprobe jprobe_example
  # echo function_graph > /sys/kernel/debug/tracing/current_tracer

After the first fork (jprobe_example probes it), the system will crash.
This is due to the way jprobes copies the stack frame and does not
do a normal function return. This messes up with the function graph
tracing accounting which hijacks the return address from the stack
and replaces it with a hook function. It saves the return addresses in
a separate stack to put back the correct return address when done.
But because the jprobe functions do not do a normal return, their
stack addresses are not put back until the function they probe is called,
which means that the probed function will get the return address of
the jprobe handler instead of its own.

The simple fix here was to disable function graph tracing while the
jprobe handler is being called.

While debugging this I found two minor bugs with the function graph
tracing.

The first was about the function graph tracer sharing its function hash
with the function tracer (they both get filtered by the same input).
The changing of the set_ftrace_filter would not sync the function recording
records after a change if the function tracer was disabled but the
function graph tracer was enabled. This was due to the update only checking
one of the ops instead of the shared ops to see if they were enabled and
should perform the sync. This caused the ftrace accounting to break and
a ftrace_bug() would be triggered, disabling ftrace until a reboot.

The second was that the check to update records only checked one of the
filter hashes. It needs to test both the "filter" and "notrace" hashes.
The "filter" hash determines what functions to trace where as the "notrace"
hash determines what functions not to trace (trace all but these).
Both hashes need to be passed to the update code to find out what change
is being done during the update. This also broke the ftrace record
accounting and triggered a ftrace_bug().

This patch set also include two more fixes that were reported separately
from the kprobe issue.

One was that init_ftrace_syscalls() was called twice at boot up.
This is not a major bug, but that call performed a rather large kmalloc
(NR_syscalls * sizeof(*syscalls_metadata)). The second call made the first
one a memory leak, and wastes memory.

The other fix is a regression caused by an update in the v3.19 merge window.
The moving to enable events early, moved the enabling before PID 1 was
created. The syscall events require setting the TIF_SYSCALL_TRACEPOINT
for all tasks. But for_each_process_thread() does not include the swapper
task (PID 0), and ended up being a nop. A suggested fix was to add
the init_task() to have its flag set, but I didn't really want to mess
with PID 0 for this minor bug. Instead I disable and re-enable events again
at early_initcall() where it use to be enabled. This also handles any other
event that might have its own reg function that could break at early
boot up.

Please pull the latest trace-fixes-v3.19-rc3 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.19-rc3

Tag SHA1: 73a577e76939fb74bc8de1e2a816b3d8a0fe850d
Head SHA1: ce1039bd3a89e99e4f624e75fb1777fc92d76eb3


Steven Rostedt (Red Hat) (5):
      ftrace: Fix updating of filters for shared global_ops filters
      ftrace: Check both notrace and filter for old hash
      ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing
      tracing: Remove extra call to init_ftrace_syscalls()
      tracing: Fix enabling of syscall events on the command line

----
 arch/x86/kernel/kprobes/core.c | 20 +++++++++---
 kernel/trace/ftrace.c          | 53 +++++++++++++++++++++++++++-----
 kernel/trace/trace.c           |  1 -
 kernel/trace/trace_events.c    | 69 +++++++++++++++++++++++++++++++++---------
 4 files changed, 115 insertions(+), 28 deletions(-)
