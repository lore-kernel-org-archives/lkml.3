Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbaGCQSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759134AbaGCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:25 -0400
Message-Id: <20140703160503.006976702@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/21] tracing: Updates for 3.17
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my current 3.17 queue. I'm still waiting on acks from various
arch maintainers to add the ftrace_stop/start() removal code that I also
want to add to this.

This includes various clean ups and enhancements, but the big feature
is the "trampoline" field added to the ftrace_ops. The only user of
that currently is the function_graph tracer. This is because the
function graph tracer normally jumps to the function tracer mcount
trampoline, saves and restores regs without doing anything before it
gets to the function graph code that also saves and restores regs
(slightly differently mind you), and runs its code. Now, if function
graph tracer is the only callback of a function, its code will be called
directly, skipping the function trampoline entirely.

The trace_seq code was also cleaned up. This opens up the possibility
that the trace_seq can be converted to "seq_buf" and used for printing
in NMI context.

I'm still waiting on a Acked-by from the SCSI folks for a change to
the trace_seq code that removes some open access of the trace_seq buffer.
I wont push this to my next branch until I hear back from them.

The way to push will also let people give me feedback before this becomes
solidified in stone, as I don't like to rebase my for-next branch.

-- Steve



  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: d048a8c7b509f35dd351e1415fe49fa99e4cb7ef


Fabian Frederick (2):
      tracing: Remove unnecessary null test before debugfs_remove()
      tracing: Convert pr_warning() to pr_warn() in trace_events.c

Masami Hiramatsu (1):
      ftrace: Simplify ftrace_hash_disable/enable path in ftrace_hash_move

Namhyung Kim (7):
      ftrace: Get rid of obsolete global_start_up variable
      ftrace: Fix memory leak on failure path in ftrace_allocate_pages()
      ftrace: Do not copy hash if O_TRUNC is set
      tracing: Add ftrace_graph_notrace boot parameter
      tracing: Improve message of empty set_graph_notrace file
      tracing: Improve message of empty set_ftrace_notrace file
      tracing: Add description of set_graph_notrace to tracing/README

Steven Rostedt (Red Hat) (10):
      ftrace: Allow no regs if no more callbacks require it
      ftrace: Use macros for numbers in ftrace rec shift bits
      ftrace: Add ftrace_rec_counter() macro to simplify the code
      ftrace: Optimize function graph to be called directly
      ftrace: Add trampolines to enabled_functions debug file
      tracing: Move the trace_seq_* functions into its own trace_seq.c file
      tracing: Clean up trace_seq.c
      tracing: Make trace_seq_putmem_hex() more robust
      tracing: Remove trace_seq_reserve()
      tracing: Add trace_seq_buffer_ptr() helper function

Zhao Hongjiang (1):
      tracing: Change trace event sample to use strlcpy instead of strncpy

----
 Documentation/kernel-parameters.txt        |   6 +
 arch/x86/kernel/mcount_64.S                |   5 +
 arch/x86/kvm/mmutrace.h                    |   2 +-
 drivers/scsi/scsi_trace.c                  |  16 +-
 include/linux/ftrace.h                     |  24 +-
 include/linux/trace_seq.h                  |  36 ++-
 kernel/trace/Makefile                      |   1 +
 kernel/trace/ftrace.c                      | 394 ++++++++++++++++++++++----
 kernel/trace/trace.c                       |  31 +--
 kernel/trace/trace_events.c                |  56 ++--
 kernel/trace/trace_output.c                | 282 +------------------
 kernel/trace/trace_output.h                |   4 -
 kernel/trace/trace_seq.c                   | 428 +++++++++++++++++++++++++++++
 samples/trace_events/trace-events-sample.h |   2 +-
 14 files changed, 870 insertions(+), 417 deletions(-)
