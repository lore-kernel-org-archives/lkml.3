Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbaFZRGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:06:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:56035 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757346AbaFZQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:50 -0400
Message-Id: <20140626165221.736847419@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 00/27] ftrace: Remove ftrace_start/stop() and friends
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Request for Acks *

>From the time I created the use of function_trace_stop, I hated it.
There was two reasons to create this, one was to try to lower the
function tracing overhead when debugfs file tracing_enable was set to zero
(note, tracing_enable no longer exists), the other was a way to stop
function tracing when going down into suspend and resume.

Some function was causing suspend and resume to reboot the kernel. In
debugging this I found that an empty callback from mcount would work.
That is, instead of running the tracing code, I would just have the
function trace callback be a nop:

 void function_trace_call(unsigned long ip, unsigned long parent_ip)
 {
 }

This worked. That means the code in mcount wasn't an issue. I started
bisecting the contents of the function_trace_call and found that this
would cause the system to reboot!

 void function_trace_call(unsigned long ip, unsigned long parent_ip)
 {
	smp_processor_id();
 }

That is, just calling smp_processor_id() was enough to trigger a triple
fault on resume of the system.

Today, this big hammer approach of disabling the function tracer is starting
to show its issues. It can't help out in debugging suspend and resume,
and there's other function trace callbacks that should still work.

I also have learned ways to bisect functions that cause bugs in function
tracing. I finally got some time to do so with a box that would reboot
on suspend and resume. This led me down to a single function:

 restore_processor_state()

This made perfect sense, as this function is called from assembly on a
CPU startup. One of the jobs of this function was to set up the GS register.
That register is also the register that is used by smp_processor_id()
to find what CPU the task is running on. With it not set up it will offset
into some random location and fault. As the fault handlers can also be
traced, those will fault too and finally the system will reset due to a
triple fault.

This is all being very specific to x86 of course. For other archs, I don't
have anything to test suspend on. But because the ftrace_stop() was added
because x86 was complaining, I'm removing it because x86 no longer complains.
If your arch exhibits problems with function tracing and suspend and resume
let me know and I can work with you in finding the functions that need to
be treated as notrace.

Anyway, as there is no more reason to set function_trace_stop it is time
to remove it. Unfortunately it's in several archs in assembly. Most of
the assembly looks rather straight forward and I removed them myself. But
I was only able to compile test them (for archs: arm64, metag, and microblaze
I do not have my cross tools set up for them and did not even compile test
it). But I would really love it if people can download their patch and test
it out. You only need the patches that go against your arch and to really
test it, also include the patch titled: 

 ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST

Otherwise your arch patch will call the list op that still does the check.
That is, if you want to test suspend and resume on your arch.

As you may see, there are patches to the ftrace infrastructure that depend
on the arch patches being implemented. I removed the functionality from
the infrastructure, then removed it from the archs, and then finally
removed the existence of the function_trace_stop variable, which would
cause the archs to fail to compile if that were to go first.

If you can test your arch and give me your acked-by, I would appreciate it.
Otherwise, if you need this to go through your tree, I would ask you
to set up a dedicated branch that I can pull from to keep this order intact.

Thanks!

-- Steve

Heiko Carstens (1):
      s390/ftrace: remove check of obsolete variable function_trace_stop

Steven Rostedt (Red Hat) (26):
      x86, power, suspend: Annotate restore_processor_state() with notrace
      PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
      tracing: Remove ftrace_stop/start() from reading the trace file
      ftrace-graph: Remove dependency of ftrace_stop() from ftrace_graph_stop()
      ftrace/x86: Add call to ftrace_graph_is_dead() in function graph code
      microblaze: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      MIPS: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      powerpc/ftrace: Add call to ftrace_graph_is_dead() in function graph code
      sh: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      ftrace-graph: Remove usage of ftrace_stop() in ftrace_graph_stop()
      ftrace: Remove ftrace_start/stop()
      ftrace: Do no disable function tracing on enabling function tracing
      ftrace: Remove function_trace_stop check from list func
      ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
      ftrace: x86: Remove check of obsolete variable function_trace_stop
      tile: ftrace: Remove check of obsolete variable function_trace_stop
      sparc64,ftrace: Remove check of obsolete variable function_trace_stop
      sh: ftrace: Remove check of obsolete variable function_trace_stop
      parisc: ftrace: Remove check of obsolete variable function_trace_stop
      MIPS: ftrace: Remove check of obsolete variable function_trace_stop
      microblaze: ftrace: Remove check of obsolete variable function_trace_stop
      metag: ftrace: Remove check of obsolete variable function_trace_stop
      Blackfin: ftrace: Remove check of obsolete variable function_trace_stop
      arm64, ftrace: Remove check of obsolete variable function_trace_stop
      tracing: Remove function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST

----
 Documentation/trace/ftrace-design.txt | 26 --------------------------
 arch/arm64/kernel/entry-ftrace.S      |  5 -----
 arch/blackfin/Kconfig                 |  1 -
 arch/blackfin/kernel/ftrace-entry.S   | 18 ------------------
 arch/metag/Kconfig                    |  1 -
 arch/metag/kernel/ftrace_stub.S       | 14 --------------
 arch/microblaze/Kconfig               |  1 -
 arch/microblaze/kernel/ftrace.c       |  3 +++
 arch/microblaze/kernel/mcount.S       |  5 -----
 arch/mips/Kconfig                     |  1 -
 arch/mips/kernel/ftrace.c             |  3 +++
 arch/mips/kernel/mcount.S             |  7 -------
 arch/parisc/Kconfig                   |  1 -
 arch/parisc/kernel/ftrace.c           |  6 +++---
 arch/powerpc/kernel/ftrace.c          |  3 +++
 arch/s390/Kconfig                     |  1 -
 arch/s390/kernel/mcount.S             | 10 +++-------
 arch/s390/kernel/mcount64.S           |  3 ---
 arch/sh/Kconfig                       |  1 -
 arch/sh/kernel/ftrace.c               |  3 +++
 arch/sh/lib/mcount.S                  | 24 ++----------------------
 arch/sparc/Kconfig                    |  1 -
 arch/sparc/lib/mcount.S               | 10 ++--------
 arch/tile/Kconfig                     |  1 -
 arch/tile/kernel/mcount_64.S          | 18 ------------------
 arch/x86/Kconfig                      |  1 -
 arch/x86/kernel/entry_32.S            |  9 ---------
 arch/x86/kernel/ftrace.c              |  3 +++
 arch/x86/kernel/mcount_64.S           | 18 +-----------------
 arch/x86/power/cpu.c                  |  4 ++--
 include/linux/ftrace.h                | 34 ++--------------------------------
 kernel/power/hibernate.c              |  6 ------
 kernel/power/suspend.c                |  2 --
 kernel/trace/Kconfig                  |  5 -----
 kernel/trace/ftrace.c                 | 23 ++---------------------
 kernel/trace/trace.c                  |  2 --
 kernel/trace/trace_functions_graph.c  | 30 ++++++++++++++++++++++++++++++
 37 files changed, 62 insertions(+), 242 deletions(-)
