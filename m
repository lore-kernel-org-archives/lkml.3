Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3JQNeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:34:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3JQNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:34:00 -0400
Date: Thu, 17 Oct 2013 15:33:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017133350.GG3364@laptop.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016124649.GG227855@redhat.com>
 <20131016133125.GY10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016133125.GY10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:31:25PM +0200, Peter Zijlstra wrote:
> Pick a smaller box? I seem to be able to reproduce on my wsm-ep, which
> boots inside a minute :-)

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
fix it:

---
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
index ba77ebc2c353..6fcb49ce50a1 100644
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


