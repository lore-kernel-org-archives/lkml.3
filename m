Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3LCPLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:11:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46555 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3LCPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:11:10 -0500
Date: Tue, 3 Dec 2013 16:10:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com
Subject: Re: [RFC][PATCH 0/7] sched: Optimize sched_clock bits
Message-ID: <20131203151053.GD8070@laptop.programming.kicks-ass.net>
References: <20131129173657.252094369@infradead.org>
 <529B7B27.4070801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529B7B27.4070801@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 01, 2013 at 08:08:39PM +0200, Eliezer Tamir wrote:
> If you can think of any other interesting tests, or anything I'm doing
> wrong, I'm open to suggestions.

I haven't actually looked at your results yet -- will do next week (I'm
supposed to have PTO noaw ;-) but I couldn't resist tinkering a little:

The below is a simple cycles benchmark I used on my WSM-EP (which as you
might guess from the code has a 12M L3 cache), it pretty much says that
with these patches (and a few fixes included below) local_clock() is
faster than sched_clock() used to be by about 3 times.

Obviously the unstable case is still sucky, and in fact we suck worse
even though we're now more than twice as fast as we used to be. I'm
saying we suck more because whereas we used to be ~4 times slower than
sched_clock() we're now actually ~8 times slower.

Go figure :-)

Anyway, these patches are a keeper based on these (simple) numbers from
my 1 machine test.

I'll fix them up and post them again next week.

Also, static_key and related APIs suck donkey ballz -- I did indeed
promise myself I'd not step into that bike shed contest but having had
to use them again *painfull*.

PRE:

[    5.616495] sched_clock_stable: 1
[   19.465079] (cold) sched_clock: 1643511
[   33.146204] (cold) local_clock: 1701454
[   33.150126] (warm) sched_clock: 39471
[   33.153909] (warm) local_clock: 132954
[    0.004000] sched_clock_stable: 0
[   45.110749] (cold) sched_clock: 1725363
[   58.798048] (cold) local_clock: 1799885
[   58.801976] (warm) sched_clock: 39420
[   58.805784] (warm) local_clock: 185943

[    5.615367] sched_clock_stable: 1
[   19.463919] (cold) sched_clock: 1753379
[   33.145528] (cold) local_clock: 1755582
[   33.149449] (warm) sched_clock: 39492
[   33.153237] (warm) local_clock: 132915
[    0.004000] sched_clock_stable: 0
[   45.114798] (cold) sched_clock: 1798290
[   58.802376] (cold) local_clock: 1880658
[   58.806301] (warm) sched_clock: 39482
[   58.810108] (warm) local_clock: 185943

POST:

[    5.061000] sched_clock_stable: 1
[   18.916000] (cold) sched_clock: 1335206
[   32.576000] (cold) local_clock: 1365236
[   32.580000] (warm) sched_clock: 11771
[   32.584000] (warm) local_clock: 14725
[   32.609024] sched_clock_stable: 0
[   46.298928] (cold) sched_clock: 1615798
[   59.965926] (cold) local_clock: 1780387
[   59.969844] (warm) sched_clock: 11803
[   59.973575] (warm) local_clock: 80769

[    5.059000] sched_clock_stable: 1
[   18.912000] (cold) sched_clock: 1323258
[   32.576000] (cold) local_clock: 1404544
[   32.580000] (warm) sched_clock: 11758
[   32.584000] (warm) local_clock: 14714
[   32.609498] sched_clock_stable: 0
[   46.294431] (cold) sched_clock: 1436083
[   59.965695] (cold) local_clock: 1506272
[   59.969608] (warm) sched_clock: 11801
[   59.973340] (warm) local_clock: 80782


Boot with tsc=reliable and ignore SPLATS, not for actual merging.

---
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -77,7 +77,7 @@ struct cyc2ns_latch {
 	struct cyc2ns_data data[2];
 };
 
-static DEFINE_PER_CPU(struct cyc2ns_latch, cyc2ns);
+static DEFINE_PER_CPU_ALIGNED(struct cyc2ns_latch, cyc2ns);
 
 /*
  * Use a {offset, mul} pair of this cpu.
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -87,14 +87,14 @@ int sched_clock_stable(void)
 void set_sched_clock_stable(void)
 {
 	if (!sched_clock_stable())
-		static_key_slow_inc(&__sched_clock_stable);
+		static_key_slow_dec(&__sched_clock_stable);
 }
 
 void clear_sched_clock_stable(void)
 {
 	/* XXX worry about clock continuity */
 	if (sched_clock_stable())
-		static_key_slow_dec(&__sched_clock_stable);
+		static_key_slow_inc(&__sched_clock_stable);
 }
 
 struct sched_clock_data {
@@ -255,20 +255,20 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd;
 	u64 clock;
 
-	WARN_ON_ONCE(!irqs_disabled());
-
 	if (sched_clock_stable())
 		return sched_clock();
 
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
+	preempt_disable();
 	scd = cpu_sdc(cpu);
 
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
 		clock = sched_clock_local(scd);
+	preempt_enable();
 
 	return clock;
 }
@@ -345,7 +345,7 @@ u64 cpu_clock(int cpu)
 u64 local_clock(void)
 {
 	if (static_key_false(&__sched_clock_stable))
-		return sched_clock_cpu(smp_processor_id());
+		return sched_clock_cpu(raw_smp_processor_id());
 
 	return sched_clock();
 }
@@ -379,3 +379,122 @@ u64 local_clock(void)
 
 EXPORT_SYMBOL_GPL(cpu_clock);
 EXPORT_SYMBOL_GPL(local_clock);
+
+#include <linux/perf_event.h>
+
+static char sched_clock_cache[12*1024*1024]; /* 12M l3 cache */
+static struct perf_event *__sched_clock_cycles;
+
+static u64 sched_clock_cycles(void)
+{
+	return perf_event_read(__sched_clock_cycles);
+}
+
+static __init void sched_clock_wipe_cache(void)
+{
+	int i;
+
+	for (i = 0; i < sizeof(sched_clock_cache); i++)
+		ACCESS_ONCE(sched_clock_cache[i]) = 0;
+}
+
+static __init u64 cache_cold_sched_clock(void)
+{
+	u64 cycles;
+
+	local_irq_disable();
+	sched_clock_wipe_cache();
+	cycles = sched_clock_cycles();
+	(void)sched_clock();
+	cycles = sched_clock_cycles() - cycles;
+	local_irq_enable();
+
+	return cycles;
+}
+
+static __init u64 cache_cold_local_clock(void)
+{
+	u64 cycles;
+
+	local_irq_disable();
+	sched_clock_wipe_cache();
+	cycles = sched_clock_cycles();
+	(void)local_clock();
+	cycles = sched_clock_cycles() - cycles;
+	local_irq_enable();
+
+	return cycles;
+}
+
+static __init void do_bench(void)
+{
+	u64 cycles;
+	u64 tmp;
+	int i;
+
+	printk("sched_clock_stable: %d\n", sched_clock_stable());
+
+	cycles = 0;
+	for (i = 0; i < 1000; i++)
+		cycles += cache_cold_sched_clock();
+
+	printk("(cold) sched_clock: %lu\n", cycles);
+
+	cycles = 0;
+	for (i = 0; i < 1000; i++)
+		cycles += cache_cold_local_clock();
+
+	printk("(cold) local_clock: %lu\n", cycles);
+
+	local_irq_disable();
+	ACCESS_ONCE(tmp) = sched_clock();
+
+	cycles = sched_clock_cycles();
+
+	for (i = 0; i < 1000; i++)
+		ACCESS_ONCE(tmp) = sched_clock();
+
+	cycles = sched_clock_cycles() - cycles;
+	local_irq_enable();
+
+	printk("(warm) sched_clock: %lu\n", cycles);
+
+	local_irq_disable();
+	ACCESS_ONCE(tmp) = local_clock();
+
+	cycles = sched_clock_cycles();
+
+	for (i = 0; i < 1000; i++)
+		ACCESS_ONCE(tmp) = local_clock();
+
+	cycles = sched_clock_cycles() - cycles;
+	local_irq_enable();
+
+	printk("(warm) local_clock: %lu\n", cycles);
+}
+
+static __init int sched_clock_bench(void)
+{
+	struct perf_event_attr perf_attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+		.size = sizeof(struct perf_event_attr),
+		.pinned = 1,
+	};
+
+	__sched_clock_cycles = perf_event_create_kernel_counter(&perf_attr, -1, current, NULL, NULL);
+
+	set_sched_clock_stable();
+	do_bench();
+
+	clear_sched_clock_stable();
+	do_bench();
+
+	set_sched_clock_stable();
+
+	perf_event_release_kernel(__sched_clock_cycles);
+
+	return 0;
+}
+
+late_initcall(sched_clock_bench);
