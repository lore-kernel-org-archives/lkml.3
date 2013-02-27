Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab3B0RuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:50:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3B0Rt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:49:59 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GKElicI09NwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DVV_lGpT1NkA:10 a=I8-cvdjB6tWXQnppWGcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227172232.707306533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 0/8] tracing: Addition of multiple buffers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been on and off working on getting multiple buffers for ftrace since
last June. This has been requested time and time again, and because it
was so intrusive to the tracing system it took me a while to get it working
properly. But now I feel it's ready for inclusion and destined for 3.10.
But I would like to get it into linux-next right away to get the most
testing out of it as possible before I even send it to Ingo for inclusion
into tip.

It required rewriting a lot of the way events and tracers work, to get
rid of all the global variables that were referenced. I NACK'd ever effort
to make "global_trace" non static, and that has helped to make this effort
a bit easier, but I allowed short cuts to get to the global_trace via
functions that did not pass in a descriptor. All that had to change.

With this patch set, a new directory is created in the debug/tracing
directory called "instances". Here you can mkdir/rmdir a new directory
that will contain some of the files in the debug/tracing directory.
Note, this is not totally finished, but it's at a point were it is
functional and useful.

To add mkdir/rmdir in debugfs, as debugfs does not support these operations,
I had to have the instances' inode use its own inode_operations and add a
mkdir and rmdir method. As the instances directory can not be renamed
or removed, or modified in any other way, it has the inode mutex released
in order to call back to create or remove the debugfs directories.
It has its own mutex to protect against multiple instances of this,
and I've run many stress tests to make sure it can't crash. I haven't
found were it can. The alternative is to have a "new" and "free" file
to create and remove directories and it will basically do the exact
same thing that the mkdir/rmdir does now, with the exact same protection.
I do eventually want to make a tracefs, but that requires a lot of
design planning and wont be in the near future (too many other things
to do).

Anyway, there's a lot more to be done here:

 o 	Make the per_cpu directories available for instances
 o	Make the snapshot available for instances
 o	Make tracers available for instances
 o	Make trace options affect instances differenty (right now it
	  it's global for all buffers, including top level)
 o	Add a hook for perf to access ftrace buffers directly

That last point is a goal for this work. I would like perf to be able
to access ftrace buffer and features directly via a system call. But
in order to do that, a lot of this needs to be designed differently and
this patch set moves things in that direction.

I'll be pushing this to linux-next probably tomorrow. This is just
a preview of what's to come.

Steven Rostedt (8):
      tracing: Separate out trace events from global variables
      tracing: Use RING_BUFFER_ALL_CPUS for TRACE_PIPE_ALL_CPU
      tracing: Encapsulate global_trace and remove dependencies on global vars
      tracing: Pass the ftrace_file to the buffer lock reserve code
      tracing: Replace the static global per_cpu arrays with allocated per_cpu
      tracing: Make syscall events suitable for multiple buffers
      tracing: Add interface to allow multiple trace buffers
      tracing: Add rmdir to remove multibuffer instances

----
 include/linux/ftrace_event.h         |   58 ++-
 include/trace/ftrace.h               |   12 +-
 kernel/trace/trace.c                 |  819 +++++++++++++++++++++++-----------
 kernel/trace/trace.h                 |   76 +++-
 kernel/trace/trace_branch.c          |    6 +-
 kernel/trace/trace_events.c          |  819 ++++++++++++++++++++++++----------
 kernel/trace/trace_events_filter.c   |    5 +-
 kernel/trace/trace_functions.c       |    4 +-
 kernel/trace/trace_functions_graph.c |    4 +-
 kernel/trace/trace_irqsoff.c         |    6 +-
 kernel/trace/trace_kdb.c             |    4 +-
 kernel/trace/trace_mmiotrace.c       |    4 +-
 kernel/trace/trace_sched_switch.c    |    4 +-
 kernel/trace/trace_sched_wakeup.c    |   14 +-
 kernel/trace/trace_syscalls.c        |   80 ++--
 15 files changed, 1331 insertions(+), 584 deletions(-)
