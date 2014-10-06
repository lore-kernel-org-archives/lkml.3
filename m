Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaJFVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:36:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58304 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaJFVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:36:32 -0400
Message-Id: <20141006213544.344821619@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 06 Oct 2014 17:35:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/11] [GIT PULL] tracing: Updates for 3.18
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This set has a few minor updates, but the big change is the redesign
of the trampoline logic.

The trampoline logic of 3.17 required a descriptor for every function
that is registered to be traced and uses a trampoline. Currently,
only the function graph tracer uses a trampoline, but if you were
to trace all 32,000 (give or take a few thousand) functions with the
function graph tracer, it would create 32,000 descriptors to let us
know that there's a trampoline associated with it. This takes up a bit
of memory when there's a better way to do it.

The redesign now reuses the ftrace_ops' (what registers the function graph
tracer) hash tables. The hash tables tell ftrace what the tracer
wants to trace or doesn't want to trace. There's two of them: one
that tells us what to trace, the other tells us what not to trace.
If the first one is empty, it means all functions should be traced,
otherwise only the ones that are listed should be. The second hash table
tells us what not to trace, and if it is empty, all functions may be
traced, and if there's any listed, then those should not be traced
even if they exist in the first hash table.

It took a bit of massaging, but now these hashes can be used to
keep track of what has a trampoline and what does not, and allows
the ftrace accounting to work. Now we can trace all functions when using
the function graph trampoline, and avoid needing to create any special
descriptors to hold all the functions that are being traced.

Please pull the latest trace-3.18 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.18

Tag SHA1: 9e06c8f394155d5501cbd85894562405566d7c43
Head SHA1: 3ddee63a099ebbdc8f84697fe46730b58240c09d


Andreea-Cristina Bernat (1):
      kernel: trace_syscalls: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Dave Hansen (1):
      tracing: generate RCU warnings even when tracepoints are disabled

Steven Rostedt (Red Hat) (9):
      ftrace: Add separate function for non recursive callbacks
      ftrace: Add helper function ftrace_ops_get_func()
      ftrace: Set callback to ftrace_stub when no ops are registered
      ftrace: Remove freeing of old_hash from ftrace_hash_move()
      ftrace: Grab any ops for a rec for enabled_functions output
      ftrace: Annotate the ops operation on update
      ftrace: Replace tramp_hash with old_*_hash to save space
      ftrace: Add sanity check when unregistering last ftrace_ops
      ftrace: Only disable ftrace_enabled to test buffer in selftest

----
 include/linux/ftrace.h        |  10 +-
 include/linux/tracepoint.h    |  11 ++
 kernel/trace/ftrace.c         | 416 ++++++++++++++++++++++++------------------
 kernel/trace/trace_selftest.c |   4 +
 kernel/trace/trace_syscalls.c |   4 +-
 5 files changed, 267 insertions(+), 178 deletions(-)
