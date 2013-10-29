Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3J2OIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3J2OIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:05 -0400
Date: Tue, 29 Oct 2013 07:07:04 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e8a923cc1fff6e627f906655ad52ee694ef2f6d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20131017133350.GG3364@laptop.programming.kicks-ass.net>
References: <20131017133350.GG3364@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix NMI measurements
Git-Commit-ID: e8a923cc1fff6e627f906655ad52ee694ef2f6d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8a923cc1fff6e627f906655ad52ee694ef2f6d7
Gitweb:     http://git.kernel.org/tip/e8a923cc1fff6e627f906655ad52ee694ef2f6d7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 17 Oct 2013 15:32:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:01:20 +0100

perf/x86: Fix NMI measurements

OK, so what I'm actually seeing on my WSM is that sched/clock.c is
'broken' for the purpose we're using it for.

What triggered it is that my WSM-EP is broken :-(

  [    0.001000] tsc: Fast TSC calibration using PIT
  [    0.002000] tsc: Detected 2533.715 MHz processor
  [    0.500180] TSC synchronization [CPU#0 -> CPU#6]:
  [    0.505197] Measured 3 cycles TSC warp between CPUs, turning off TSC clock.
  [    0.004000] tsc: Marking TSC unstable due to check_tsc_sync_source failed

For some reason it consistently detects TSC skew, even though NHM+
should have a single clock domain for 'reasonable' systems.

This marks sched_clock_stable=0, which means that we do fancy stuff to
try and get a 'sane' clock. Part of this fancy stuff relies on the tick,
clearly that's gone when NOHZ=y. So for idle cpus time gets stuck, until
it either wakes up or gets kicked by another cpu.

While this is perfectly fine for the scheduler -- it only cares about
actually running stuff, and when we're running stuff we're obviously not
idle. This does somewhat break down for perf which can trigger events
just fine on an otherwise idle cpu.

So I've got NMIs get get 'measured' as taking ~1ms, which actually
don't last nearly that long:

          <idle>-0     [013] d.h.   886.311970: rcu_nmi_enter <-do_nmi
  ...
          <idle>-0     [013] d.h.   886.311997: perf_sample_event_took: HERE!!! : 1040990

So ftrace (which uses sched_clock(), not the fancy bits) only sees
~27us, but we measure ~1ms !!

Now since all this measurement stuff lives in x86 code, we can actually
fix it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org
Cc: dave.hansen@linux.intel.com
Cc: eranian@google.com
Cc: Don Zickus <dzickus@redhat.com>
Cc: jmario@redhat.com
Cc: acme@infradead.org
Link: http://lkml.kernel.org/r/20131017133350.GG3364@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 6 +++---
 arch/x86/kernel/nmi.c            | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9d84491..8a87a32 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1276,16 +1276,16 @@ void perf_events_lapic_init(void)
 static int __kprobes
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	int ret;
 	u64 start_clock;
 	u64 finish_clock;
+	int ret;
 
 	if (!atomic_read(&active_events))
 		return NMI_DONE;
 
-	start_clock = local_clock();
+	start_clock = sched_clock();
 	ret = x86_pmu.handle_irq(regs);
-	finish_clock = local_clock();
+	finish_clock = sched_clock();
 
 	perf_sample_event_took(finish_clock - start_clock);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index ba77ebc..6fcb49c 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -113,10 +113,10 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 		u64 before, delta, whole_msecs;
 		int remainder_ns, decimal_msecs, thishandled;
 
-		before = local_clock();
+		before = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-		delta = local_clock() - before;
+		delta = sched_clock() - before;
 		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
 		if (delta < nmi_longest_ns)
