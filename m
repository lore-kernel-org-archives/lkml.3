Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaGCUX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:23:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:60015 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787AbaGCUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:23:27 -0400
Message-Id: <20140703200750.648550267@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 16:07:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ NOT READY FOR INCLUSION! ]

Note, this is based off of my remove ftrace_start/stop() patch set.

I've been wanting to do this for years, and just never gotten around to it.
But with all this talk of kpatch and kgraft live kernel patching using
the ftrace infrastructure, it seems like a good time to do it.

The way the function callback mechanism works in ftrace is that if there's
only one function callback registered, it will set the mcount/fentry
trampoline to call that function directly. But as soon as you register
another callback, the mcount trampoline calls a loop function that iterates
over all the registered callbacks (ftrace_ops) checking their hash tables
to see if the called function matches the ops before calling its callback.
This happens even if the two registered functions are not even tracing
the same function!

This really sucks if you are tracing all functions, and then add a kprobe
or perf event that traces a single function. That will cause all the
other functions being traced to perform the loop test.

Ideally, if only a single callback (ftrace_ops) is registered to a
function, than that function should call a trampoline that will only
call that one callback without doing any other tests.

This patch set adds this functionality to x86_64. If a callback is
registered to a function and there's no other callback registered to
that function that ftrace_ops will get its own trampoline allocated
for it that will call the function directly.

Note, for dynamically allocated ftrace_ops (kprobes, perf, instance
directory function tracing), the dynamic trampoline will only be created
if CONFIG_PREEMPT is not set. That's because, until Paul finishes his
rcu_call_task() code, there's no safe way to know if a task was preempted
while on the trampoline and is waiting to run on it some more.

I need to write up a bunch of tests for this code, but currently it works
on the few tests I did manually. I didn't even run this code yet under
my full test suite, so it may very well have bugs in it that might be
easily triggered. But I wanted to get the code out for review to see
if anyone has any other idea to help enhance this feature.

If you want a git repo to play with this, you can get it from below.
That repo will rebase often, so do not build against it.

Enjoy,

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/trampoline

Head SHA1: 4d781e010842a56f8e7c1bbe309e38075c277c45


Steven Rostedt (Red Hat) (3):
      ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
      ftrace/x86: Show trampoline call function in enabled_functions
      ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines

----
 arch/x86/kernel/ftrace.c    | 240 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/mcount_64.S |  26 ++++-
 include/linux/ftrace.h      |   8 ++
 kernel/trace/ftrace.c       |  86 +++++++++++++++-
 4 files changed, 344 insertions(+), 16 deletions(-)

