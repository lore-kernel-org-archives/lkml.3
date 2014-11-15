Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaKOFGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:06:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:48451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707AbaKOFGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:03 -0500
Message-Id: <20141115045847.712848224@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:58:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 00/26 v5] trace-seq/seq-buf/x86/printk: Print all stacks from NMI safely
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 5!

Full diff between v4 and v5 will be replied to this email.

Here's the summary of the differences since version 4:

 . Various clean ups

 . Added trace_seq_used() to be used instead of s->seq.len

 . Used seq_buf_used() instead of s->len

 . Fixed output of ftrace_raw_output_prep() as well as caller code

 . Fixed up tracing_fill_pipe_page() The logic was a bit whacky
   and this was needed when introducing trace_seq_used()

 . Rebased on latest ftrace/core code

 . Fixed uprobe to be like probe code in print_uprobe_event()

 . Introduced new seq_buf_can_fit() to remove the likelyhood of
   screwing up the s->len + * < s->size code. Now it's just
   seq_buf_can_fit(s, len) which will tell us if the len can still
   fit in the buffer.

Enjoy,

-- Steve


Steven Rostedt (Red Hat) (26):
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
      tracing: Fix return value of ftrace_raw_output_prep()
      tracing: Create seq_buf layer in trace_seq
      tracing: Convert seq_buf_path() to be like seq_path()
      tracing: Convert seq_buf fields to be like seq_file fields
      tracing: Add a seq_buf_clear() helper and clear len and readpos in init
      seq_buf: Create seq_buf_used() to find out how much was written
      tracing: Use trace_seq_used() and seq_buf_used() instead of len
      seq_buf: Add seq_buf_can_fit() helper function
      tracing: Have seq_buf use full buffer
      tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
      seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs

----
 arch/x86/kernel/apic/hw_nmi.c        |  91 +++++++-
 include/linux/ftrace_event.h         |  11 +
 include/linux/percpu.h               |   3 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              | 136 ++++++++++++
 include/linux/trace_seq.h            |  77 ++++---
 include/trace/ftrace.h               |   8 +-
 kernel/printk/printk.c               |  38 +++-
 kernel/trace/blktrace.c              | 148 ++++++-------
 kernel/trace/ring_buffer.c           |  75 +++----
 kernel/trace/trace.c                 | 126 ++++++-----
 kernel/trace/trace.h                 |   3 +-
 kernel/trace/trace_branch.c          |  15 +-
 kernel/trace/trace_events.c          |   9 +-
 kernel/trace/trace_functions_graph.c | 393 +++++++++++----------------------
 kernel/trace/trace_kprobe.c          |  42 ++--
 kernel/trace/trace_mmiotrace.c       |  52 ++---
 kernel/trace/trace_output.c          | 417 ++++++++++++++---------------------
 kernel/trace/trace_output.h          |  16 +-
 kernel/trace/trace_probe.c           |  10 +-
 kernel/trace/trace_seq.c             | 253 +++++++++------------
 kernel/trace/trace_syscalls.c        |  43 ++--
 kernel/trace/trace_uprobe.c          |  23 +-
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 351 +++++++++++++++++++++++++++++
 25 files changed, 1323 insertions(+), 1021 deletions(-)
