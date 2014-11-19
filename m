Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaKSDse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:48:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:18355 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754168AbaKSDsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:48:31 -0500
Message-Id: <20141119033331.689278545@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 18 Nov 2014 22:33:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        williams@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 0/2] ftrace: Fix stack tracing issues
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran my ftrace tests on a PREEMPT_RT kernel and one of the tests failed.
It triggered a race that was in mainline and was fixed by another patch.
The bug was with the traceoff function trigger.

I stated testing the other triggers and discovered two other bugs.
One was caused by my latest changes, but the other one has been in
mainline for some time. It's been there since 3.16, and I haven't
tested it further. It's not that big of a bug so I'm not labeling
it with stable.

The bug that's been there happens when CONFIG_FRAME_POINTERS is set.
The ftrace trampoline doesn't set up a frame pointer, and the stack
trace code will miss the called function. That is if you do:

 echo __kmalloc:stacktrace > set_ftrace_filter

It will not show __kmalloc in the trace. This isn't that bad, but if
fentry is used (compiled with gcc 4.6 and newer on x86), then not only
is __kmalloc missed, but also the function that called __kmalloc.
This is a bit more serious, as that is useful information. The reason
for the difference with fentry, is that the fentry is called before
the stack frame is set up, so the missing bp frame pointer goes back
pass the parent.

The second bug is with the new code and dynamic ftrace trampolines.
There's a check in the stack trace recording to see if the address
on the stack is kernel code or not. This checks core kernel text as
well as module address. But it doesn't check if it is a dynamically
allocated ftrace trampoline. This is much worse than the other bug
because if FRAME_POINTERS is set, the pointer to the trampoline is
skipped and the bp frame pointer is never updated. That means, no
functions will be traced. Makes the stack trace from function tracing
rather pointless. Luckily, that code is not in mainline yet and this
fix will make sure mainline doesn't get the bug (except for bisects).

Enjoy,

-- Steve


Steven Rostedt (Red Hat) (2):
      ftrace/x86: Add frames pointers to trampoline as necessary
      ftrace/x86/extable: Add is_ftrace_trampoline() function

----
 arch/x86/kernel/ftrace.c    |  9 +++++++--
 arch/x86/kernel/mcount_64.S | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ftrace.h      |  8 ++++++++
 kernel/extable.c            |  3 +++
 kernel/trace/ftrace.c       | 26 ++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 2 deletions(-)
