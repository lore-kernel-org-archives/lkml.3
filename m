Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934930AbaKNBOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:14:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:43207 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934544AbaKNBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:12 -0500
Message-Id: <20141114011244.256115061@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 00/23 v4] trace-seq/seq-buf/x86/printk: Print all stacks from NMI safely
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Version 4:

I updated the code from most of the comments from Petr Mladek. One thing
I wanted to do was to remove the return values of the trace_seq_*()
functions. The ones that I plan on removing from seq_file equivalents.
To do so, I had to restructure the use cases, which ended up cleaning
up most of the code. Having updated the trace_seq_*() functions made
it possible not to worry about the return values of seq_buf as they were
no longer used.


Steven Rostedt (Red Hat) (23):
      tracing: Fix trace_seq_bitmask() to start at current position
      tracing: Add trace_seq_has_overflowed() and trace_handle_return()
      blktrace/tracing: Use trace_seq_has_overflowed() helper function
      ring-buffer: Remove check of trace_seq_{puts,printf}() return values
      tracing: Have branch tracer use trace_handle_return() helper function
      tracing: Have function_graph use trace_seq_has_overflowed()
      kprobes/tracing: Use trace_seq_has_overflowed() for overflow checks
      tracing: Do not check return values of trace_seq_p*() for mmio tracer
      tracing/probes: Do not use return value of trace_seq_printf()
      tracing/uprobes: Do not use return values of trace_seq_printf()
      tracing: Do not use return values of trace_seq_printf() in syscall tracing
      tracing: Remove return values of most trace_seq_*() functions
      tracing: Create seq_buf layer in trace_seq
      tracing: Convert seq_buf_path() to be like seq_path()
      tracing: Convert seq_buf fields to be like seq_file fields
      tracing: Add a seq_buf_clear() helper and clear len and readpos in init
      tracing: Have seq_buf use full buffer
      tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
      seq_buf: Create seq_buf_used() to find out how much was written
      seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c        |  91 +++++++-
 include/linux/ftrace_event.h         |  11 +
 include/linux/percpu.h               |   3 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              | 135 ++++++++++++
 include/linux/trace_seq.h            |  59 ++---
 include/trace/ftrace.h               |   6 +-
 kernel/printk/printk.c               |  38 +++-
 kernel/trace/blktrace.c              | 148 ++++++-------
 kernel/trace/ring_buffer.c           |  75 +++----
 kernel/trace/trace.c                 | 108 ++++-----
 kernel/trace/trace.h                 |   3 +-
 kernel/trace/trace_branch.c          |  15 +-
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c | 380 ++++++++++----------------------
 kernel/trace/trace_kprobe.c          |  42 ++--
 kernel/trace/trace_mmiotrace.c       |  52 ++---
 kernel/trace/trace_output.c          | 416 ++++++++++++++---------------------
 kernel/trace/trace_output.h          |  16 +-
 kernel/trace/trace_probe.c           |  10 +-
 kernel/trace/trace_seq.c             | 254 +++++++++------------
 kernel/trace/trace_syscalls.c        |  43 ++--
 kernel/trace/trace_uprobe.c          |  23 +-
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 346 +++++++++++++++++++++++++++++
 25 files changed, 1275 insertions(+), 1009 deletions(-)
