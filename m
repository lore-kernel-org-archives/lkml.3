Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3HaFRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:17:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3HaFRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uDI3RM8CAjQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mPQ3Dgj11gYA:10 a=BKBK9F9Kas-9isosNxoA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051117.884125230@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 00/18 v2] ftrace/rcu: Handle unsafe RCU functions and ftrace callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my final draft of the patches. I'm starting to run them
through my formal tests now. They may change depending on the outcome
of the tests.

I'm also a bit tired, and I added the change logs last. Thus I may
need to go back and fix the change logs up too. But the code was done
when I was rather spunky. But that doesn't mean I didn't break anything.

Anyway, let me know what you think. I'm going to need acks for the
places I added the FTRACE_UNSAFE_RCU() annotations.

I added a checker that traces all functions with the non RCU safe
settings, and did a rcu_read_lock() with PROVE_RCU enabled. This caught
several functions that needed to be annotated. There may be more, but
the test gives us a way to find out.

There's some improvements that can be done to these patches, but for
3.12, I think this version is good enough. We can do the improvements
for 3.13.

Well, enjoy.

-- Steve


Steven Rostedt (Red Hat) (18):
      ftrace: Add hash list to save RCU unsafe functions
      ftrace: Do not set ftrace records for unsafe RCU when not allowed
      ftrace: Set ftrace internal function tracing RCU safe
      ftrace: Add test for ops against unsafe RCU functions in callback
      ftrace: Do not display non safe RCU functions in available_filter_functions
      ftrace: Add rcu_unsafe_filter_functions file
      ftrace: Add selftest to check if RCU unsafe functions are filtered properly
      ftrace/rcu: Do not trace debug_lockdep_rcu_enabled()
      ftrace: Fix a slight race in modifying what function callback gets traced
      ftrace: Create a RCU unsafe checker
      ftrace: Adde infrastructure to stop RCU unsafe checker from checking
      ftrace: Disable RCU unsafe checker when function graph is enabled
      ftrace: Disable the RCU unsafe checker when irqsoff is enabled
      ftrace/lockdep: Have the RCU lockdep splat show what function triggered
      ftrace/rcu: Mark functions that are RCU unsafe
      rcu/irq/x86: Mark functions that are RCU unsafe
      ftrace/cpuidle/x86: Mark functions that are RCU unsafe
      ftrace/sched: Mark functions that are RCU unsafe

----
 arch/x86/kernel/apic/apic.c           |    2 +
 arch/x86/kernel/irq.c                 |    1 +
 arch/x86/kernel/irq_work.c            |    3 +
 arch/x86/kernel/process.c             |    2 +
 arch/x86/kernel/smp.c                 |    8 ++
 drivers/cpuidle/cpuidle.c             |    2 +
 include/asm-generic/vmlinux.lds.h     |   10 ++
 include/linux/ftrace.h                |   46 +++++++
 kernel/cpu/idle.c                     |    2 +
 kernel/lockdep.c                      |    2 +
 kernel/rcupdate.c                     |    2 +-
 kernel/rcutiny.c                      |    1 +
 kernel/rcutree.c                      |    7 +
 kernel/sched/core.c                   |    2 +
 kernel/softirq.c                      |    2 +
 kernel/trace/Kconfig                  |   22 ++++
 kernel/trace/ftrace.c                 |  231 +++++++++++++++++++++++++++++++--
 kernel/trace/trace.h                  |   11 ++
 kernel/trace/trace_functions.c        |   76 ++++++++++-
 kernel/trace/trace_irqsoff.c          |   16 ++-
 kernel/trace/trace_selftest.c         |   94 ++++++++++++++
 kernel/trace/trace_selftest_dynamic.c |    7 +
 22 files changed, 532 insertions(+), 17 deletions(-)
