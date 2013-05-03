Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab3ECJrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:47:49 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:55500 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3ECJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130321214930.752934102@linutronix.de>
References: <20130321214930.752934102@linutronix.de>
Date: Fri, 3 May 2013 11:47:44 +0200
X-Google-Sender-Auth: rTdKJL60EvUu4z8E4q59bo_a_ZE
Message-ID: <CAMuHMdUuVdPjgu1mX+sxZv894LZNPgp_8NTUqUE4NC7-p=duCA@mail.gmail.com>
Subject: Re: [patch 00/34] idle: Consolidate idle implementations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, Mar 21, 2013 at 10:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Each architecture implements its own cpu_idle() code, which is more or
> less the same on all architectures (plus/minus a few bugs and a few
> missing extra functionalities, instrumentation ...). That also forces
> everyone who is interested in idle related features to add new
> functionality to every architecture. What a waste.

I noticed there are still prototypes for cpu_idle() in include/linux/cpu.h
and include/linux/smp.h, so I ran a full "git grep -w cpu_idle", which
suggested a few more places that needs updates:

Documentation/s390/Debugging390.txt:0001b304 T cpu_idle
Documentation/s390/Debugging390.txt:is cpu_idle+0x66 ( quiet the cpu
is asleep, don't wake it )
Documentation/scheduler/sched-arch.txt:Your cpu_idle routines need to
obey the following rules:
Documentation/scheduler/sched-arch.txt:3. When cpu_idle finds
(need_resched() == 'true'), it should call
Documentation/trace/events-power.txt:cpu_idle           "state=%lu cpu_id=%lu"
Documentation/trace/ftrace.txt:          <idle>-0     [002] .N.1
21169.031484: rcu_idle_exit <-cpu_idle
Documentation/trace/ftrace.txt: => cpu_idle
Documentation/trace/ftrace.txt:  <idle>-0       3.N.1   11us :
rcu_idle_exit <-cpu_idle
Documentation/trace/ftrace.txt:  <idle>-0       3.N.1   11us :
tick_nohz_idle_exit <-cpu_idle
Documentation/trace/ftrace.txt:  <idle>-0       3.N.1   25us :
sub_preempt_count <-cpu_idle
Documentation/trace/ftrace.txt:  <idle>-0       3.N..   25us :
schedule <-cpu_idle
Documentation/trace/ftrace.txt:  <idle>-0       2.N.2    3us :
cpu_idle: state=4294967295 cpu_id=2
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:       #3
0x100a5508 in cpu_idle () at process_kern.c:471
arch/arm/Kconfig:         This option adds a write barrier to the
cpu_idle loop so that,
arch/cris/arch-v10/drivers/gpio.c:       * from cpu_idle() in kernel/process.c
arch/cris/arch-v10/drivers/gpio.c:       * The check in cpu_idle()
reduces latency from ~15 ms to ~6 ms
arch/cris/arch-v32/drivers/mach-fs/gpio.c:       * from cpu_idle() in
kernel/process.c
arch/cris/arch-v32/drivers/mach-fs/gpio.c:       * The check in
cpu_idle() reduces latency from ~15 ms to ~6 ms
arch/mips/kernel/smtc.c:                printk("Dangling IXMT in cpu_idle()\n");
arch/powerpc/kernel/irq.c: * in cpu_idle() will properly re-enable everything.
arch/sparc/kernel/leon_pmc.c:/* leon_pmc.c: LEON Power-down cpu_idle() handler
arch/sparc/kernel/smp_32.c:     printk("CPU[%d]: Returns from
cpu_idle!\n", smp_processor_id());
arch/sparc/kernel/smp_64.c:     printk("CPU[%d]: Returns from
cpu_idle!\n", smp_processor_id());
arch/tile/include/asm/thread_info.h:/* Enable interrupts racelessly
and nap forever: helper for cpu_idle(). */
drivers/acpi/processor_driver.c:         * Set flag to delay
cpu_idle/throttling initialization
include/linux/cpu.h:void cpu_idle(void);
include/linux/smp.h:extern void cpu_idle(void);
include/trace/events/power.h:DEFINE_EVENT(cpu, cpu_idle,
init/main.c: * cpu_idle.
init/main.c:    /* Call into cpu_idle with preempt disabled */
init/main.c:     * fragile until we cpu_idle() for the first time.
kernel/trace/power-traces.c:EXPORT_TRACEPOINT_SYMBOL_GPL(cpu_idle);
tools/perf/builtin-timechart.c:          * Mapping all these
"power:cpu_idle" strings to the tracepoint
tools/perf/builtin-timechart.c:         if (strcmp(event_str,
"power:cpu_idle") == 0) {
tools/perf/builtin-timechart.c:         "-e", "power:cpu_idle",
tools/perf/builtin-timechart.c: if (!is_valid_tracepoint("power:cpu_idle") &&
tools/perf/builtin-top.c:       "cpu_idle",

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
