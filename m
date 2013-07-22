Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3GVOVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:21:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3GVOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:26 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=RgSTy_Au6X4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2viBZTd0xxgA:10 a=VwQbUJbxAAAA:8 a=j0dDaYE-5XIQHPaq2esA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722141947.972915744@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:19:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 00/14] [GIT PULL] tracing: fixes, clean ups and optimizations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This contains fixes, optimizations and some clean ups

Some of the fixes need to go back to 3.10. They are minor, and deal mostly
with incorrect ref counting in accessing event files.

There was a couple of optimizations that should have perf perform a bit
better when accessing trace events.

And some various clean ups. Some of the clean ups are necessary to help
in a fix to a theoretical race between opening a event file and
deleting that event.  That fix isn't there yet, we are still working on
a clean solution.

Please pull the latest trace-3.11-rc2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.11-rc2

Tag SHA1: 8876f82e516564d3581e1572f10d5f229beed1b8
Head SHA1: e70e78e3c83b536730e31231dd9b979768d8df3c


Alexander Z Lam (2):
      tracing: Fix error handling to ensure instances can always be removed
      tracing: Miscellaneous fixes for trace_array ref counting

Masami Hiramatsu (1):
      tracing/kprobe: Wait for disabling all running kprobe handlers

Oleg Nesterov (7):
      tracing/function: Avoid perf_trace_buf_*() if event_function.perf_events is empty
      tracing/syscall: Avoid perf_trace_buf_*() if sys_data->perf_events is empty
      tracing/perf: Move the PERF_MAX_TRACE_SIZE check into perf_trace_buf_prepare()
      tracing: Simplify the iteration logic in f_start/f_next
      tracing: Do not (ab)use trace_seq in event_id_read()
      tracing: Kill trace_array->waiter
      tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()

Steven Rostedt (Red Hat) (1):
      tracing: Add ref_data to function and fgraph tracer structs

zhangwei(Jovi) (3):
      tracing: Use correct config guard CONFIG_STACK_TRACER
      tracing: Use trace_seq_puts()/trace_seq_putc() where possible
      tracing: Typo fix on ring buffer comments

----
 include/trace/ftrace.h               |    4 --
 kernel/trace/ring_buffer.c           |   26 ++++-----
 kernel/trace/trace.c                 |   34 ++++++++----
 kernel/trace/trace.h                 |   10 +++-
 kernel/trace/trace_event_perf.c      |   10 +++-
 kernel/trace/trace_events.c          |   98 ++++++++++++++++------------------
 kernel/trace/trace_events_filter.c   |    4 +-
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |   54 +++++++++----------
 kernel/trace/trace_kprobe.c          |   29 +++++-----
 kernel/trace/trace_mmiotrace.c       |    8 +--
 kernel/trace/trace_output.c          |   14 ++---
 kernel/trace/trace_syscalls.c        |   26 ++++-----
 kernel/trace/trace_uprobe.c          |    2 -
 14 files changed, 166 insertions(+), 155 deletions(-)
