Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553AbbA1Eb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:31:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:2907 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965061AbbA1EbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:31:24 -0500
Message-Id: <20150128043036.429390502@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 27 Jan 2015 23:30:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 0/3] kprobes/ftrace/x86: Function graph trace jprobes
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had these patches sitting in my repo for a while, thinking I already
posted them. I never did, so here I go  (a little late :-/)

Basically, what I had before was fixes for jprobes and function graph
tracing that were stepping on each other. When enabling both jprobes
and graph tracer, it could crash the system. The fix was just to ignore
function graph tracing while handling a jprobe. This was fine for stable
and fixing a bug that would usually crash, but it still messes with
function graph trace. It is still required if fentry is not used, but
when fentry is (which is now the majority of cases - gcc > 4.6 and x86_64),
we can trace jprobes with a little trickery.

The way this solves the issue is that on the return from the jprobe,
we can detect if function graph tracing happened because the stack
frame would have changed. When this is detected
 (saved_sp == return_to_handler), the ip is changed once again to
go preform a "fixup". The real ip is saved in r10 (callee clobber)
and will be put back by the fixup trampoline.

The second patch will move ip to r10 always, and will call either
the fixup (if it was modified) or will jump to ftrace_trace_addr.
The ftrace_trace_addr will call the function graph code, if the
ip address is set to be traced. Otherwise the function graph code
ignores it (which is why it's called by all jprobe returns).

The final patch fixes the name of a variable that Masami suggesed.

Steven Rostedt (Red Hat) (3):
      ftrace/jprobes/x86: Allow jprobes to be graph traced if using fentry
      ftrace/jprobes/x86: Have function being probed be graph traced
      ftrace: Rename variable from old_hash_ops to old_ops_hash

----
 arch/x86/include/asm/ftrace.h    |  4 +++
 arch/x86/include/asm/kprobes.h   |  9 +++++
 arch/x86/kernel/kprobes/core.c   | 72 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/kprobes/ftrace.c | 14 ++++++++
 arch/x86/kernel/mcount_64.S      | 36 +++++++++++++++++++-
 kernel/trace/ftrace.c            | 24 +++++++-------
 6 files changed, 145 insertions(+), 14 deletions(-)
