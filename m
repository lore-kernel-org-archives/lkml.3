Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3LFQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:09:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:50403 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753458Ab3LFQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:09:42 -0500
Date: Fri, 6 Dec 2013 11:09:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Petr Mladek <pmladek@suse.cz>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [GIT PULL] tracing: Only run synchronize_sched() at instance
 deletion time
Message-ID: <20131206110940.173e8f0c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

A regression showed up that there's a large delay when enabling
all events. This was prevalent when FTRACE_SELFTEST was enabled which
enables all events several times, and caused the system bootup to
pause for over a minute.

This was tracked down to an addition of a synchronize_sched() performed
when system call tracepoints are unregistered.

The synchronize_sched() is needed between the unregistering of the
system call tracepoint and a deletion of a tracing instance buffer.
But placing the synchronize_sched() in the unreg of *every* system call
tracepoint is a bit overboard. A single synchronize_sched() before
the deletion of the instance is sufficient.

Please pull the latest trace-fixes-3.13-rc2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-3.13-rc2

Tag SHA1: c1bd293f5ee07cf4426e54f8124dd3eb2bff450a
Head SHA1: 3ccb01239201af06a07482ec686b14cd148102a5


Steven Rostedt (1):
      tracing: Only run synchronize_sched() at instance deletion time

----
 kernel/trace/trace_events.c   |  3 +++
 kernel/trace/trace_syscalls.c | 10 ----------
 2 files changed, 3 insertions(+), 10 deletions(-)
---------------------------
commit 3ccb01239201af06a07482ec686b14cd148102a5
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Tue Dec 3 12:41:20 2013 -0500

    tracing: Only run synchronize_sched() at instance deletion time
    
    It has been reported that boot up with FTRACE_SELFTEST enabled can take a
    very long time. There can be stalls of over a minute.
    
    This was tracked down to the synchronize_sched() called when a system call
    event is disabled. As the self tests enable and disable thousands of events,
    this makes the synchronize_sched() get called thousands of times.
    
    The synchornize_sched() was added with d562aff93bfb53 "tracing: Add support
    for SOFT_DISABLE to syscall events" which caused this regression (added
    in 3.13-rc1).
    
    The synchronize_sched() is to protect against the events being accessed
    when a tracer instance is being deleted. When an instance is being deleted
    all the events associated to it are unregistered. The synchronize_sched()
    makes sure that no more users are running when it finishes.
    
    Instead of calling synchronize_sched() for all syscall events, we only
    need to call it once, after the events are unregistered and before the
    instance is deleted. The event_mutex is held during this action to
    prevent new users from enabling events.
    
    Link: http://lkml.kernel.org/r/20131203124120.427b9661@gandalf.local.home
    
    Reported-by: Petr Mladek <pmladek@suse.cz>
    Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
    Acked-by: Petr Mladek <pmladek@suse.cz>
    Tested-by: Petr Mladek <pmladek@suse.cz>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f919a2e..a11800a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2314,6 +2314,9 @@ int event_trace_del_tracer(struct trace_array *tr)
 	/* Disable any running events */
 	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
 
+	/* Access to events are within rcu_read_lock_sched() */
+	synchronize_sched();
+
 	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
 	debugfs_remove_recursive(tr->event_dir);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index e4b6d11..ea90eb5 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -431,11 +431,6 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
-	/*
-	 * Callers expect the event to be completely disabled on
-	 * return, so wait for current handlers to finish.
-	 */
-	synchronize_sched();
 }
 
 static int reg_event_syscall_exit(struct ftrace_event_file *file,
@@ -474,11 +469,6 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
-	/*
-	 * Callers expect the event to be completely disabled on
-	 * return, so wait for current handlers to finish.
-	 */
-	synchronize_sched();
 }
 
 static int __init init_syscall_trace(struct ftrace_event_call *call)
