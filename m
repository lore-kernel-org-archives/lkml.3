Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3CHDHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759571Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zd8wKc_Hs3wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5mOzXG88NXgA:10 a=k2IuSe-cshqN-ecKrO8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308025958.501479677@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 21:59:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 00/17] tracing: multi-buffers with snapshots, per_cpu and some debugging tools
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's more updates for linux-next.

I rebased the series on top of my last pull request of
 tip/perf/urgent.

Here I made the multi-buffers work with the snapshots, as well as
added per-cpu directory for the snapshots.

I added a snapshot_raw to allow tools to pull in the binary data
of the snapshot so that it can be analyzed better.

I removed the max_tr and added two trace buffers into the trace_array.
This actually makes things much simpler, and I really should have
designed ftrace to do this from day one. It makes things so much easier.

I added an internal tracing tool called tracing_snapshot() and
tracing_snapshot_alloc(). This will allow a developer to place in
the kernel a way to say "snapshot" here, and let the tracing
continue in case there's a better place to take a snapshot.

Note, tracing_snapshot() will fail if the snapshot buffer was never
allocated, but tracing_snapshot_alloc() needs to be called from
a context that can sleep (or early boot up). When debugging, it's
best to through in a tracing_snapshot_alloc() early on so that
it will be ready to use. Hmm, I should also add a kernel command
line parameter to allocate it on boot up. Darn, I thought I was
done for 3.10. That will need to be next :-/

Enjoy,

-- Steve

Steven Rostedt (Red Hat) (17):
      ring-buffer: Init waitqueue for blocked readers
      tracing: Add comment for trace event flag IGNORE_ENABLE
      tracing: Only clear trace buffer on module unload if event was traced
      tracing: Clear all trace buffers when unloaded module event was used
      tracing: Enable snapshot when any latency tracer is enabled
      tracing: Consolidate max_tr into main trace_array structure
      tracing: Add snapshot in the per_cpu trace directories
      tracing: Add config option to allow snapshot to swap per cpu
      tracing: Add snapshot_raw to extract the raw data from snapshot
      tracing: Have trace_array keep track if snapshot buffer is allocated
      tracing: Consolidate buffer allocation code
      tracing: Add snapshot feature to instances
      tracing: Add per_cpu directory into tracing instances
      tracing: Prevent deleting instances when they are being read
      tracing: Add internal tracing_snapshot() functions
      ring-buffer: Do not use schedule_work_on() for current CPU
      tracing: Move the tracing selftest code into its own function

----
 include/linux/ftrace_event.h         |    8 +
 include/linux/kernel.h               |    4 +
 kernel/trace/Kconfig                 |   26 +
 kernel/trace/blktrace.c              |    4 +-
 kernel/trace/ring_buffer.c           |   35 +-
 kernel/trace/trace.c                 |  997 ++++++++++++++++++++++------------
 kernel/trace/trace.h                 |   40 +-
 kernel/trace/trace_events.c          |   20 +-
 kernel/trace/trace_functions.c       |    8 +-
 kernel/trace/trace_functions_graph.c |   12 +-
 kernel/trace/trace_irqsoff.c         |   10 +-
 kernel/trace/trace_kdb.c             |    8 +-
 kernel/trace/trace_mmiotrace.c       |   12 +-
 kernel/trace/trace_output.c          |    2 +-
 kernel/trace/trace_sched_switch.c    |    8 +-
 kernel/trace/trace_sched_wakeup.c    |   16 +-
 kernel/trace/trace_selftest.c        |   42 +-
 kernel/trace/trace_syscalls.c        |    4 +-
 18 files changed, 824 insertions(+), 432 deletions(-)
