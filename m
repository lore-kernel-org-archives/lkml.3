Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3EJVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:38:59 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49189 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab3EJVi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:38:58 -0400
Date: Fri, 10 May 2013 23:38:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510213851.GC9358@somewhere>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz>
 <20130510152102.GD22942@pd.tnic>
 <20130510154349.GB9358@somewhere>
 <20130510162340.GE22942@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510162340.GE22942@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 06:23:40PM +0200, Borislav Petkov wrote:
> On Fri, May 10, 2013 at 05:43:50PM +0200, Frederic Weisbecker wrote:
> > So either interrupts are spuriously enabled early, or ts->tick_stopped
> > is not correctly initialized.
> 
> Hmm, it can't be interrupts disabled because add_timer_on() does
> spin_lock_irqsave() before calling wake_up_nohz_cpu()... Maybe something
> like the below could help check this...

Right, by the time we call wake_up_nohz_cpu(), irqs can't be enabled, but may
be they were enabled before in start_secondary().

> 
> Although AFAICT, we're enabling interrupts much later in
> start_secondary, even after we've set the bit in the online mask.

Right.

> 
> ---
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9c73b51817e4..1b679b0fa57a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -201,6 +201,8 @@ static void __cpuinit smp_callin(void)
>  	 */
>  	setup_vector_irq(smp_processor_id());
>  
> +	WARN_ON(!irqs_disabled());
> +

The problem is that it doesn't catch issues with irqs that have been enabled
before in start_secondary(), then re-disabled somewhow. Warning on offline CPU from the place 
that disables the tick should catch the issue.

Jiri, could you test the following patch? I also added some code to dump
the value of ts->tick_stopped, in case it's not well initialized or something.

Note this may give you spurious warning when you unplug a CPU or when you shutdown the
system. But it's interesting if it dumps something in the boot.

Thanks!

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..9853125 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -616,8 +616,17 @@ static bool wake_up_full_nohz_cpu(int cpu)
 {
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
-		    tick_nohz_tick_stopped())
+		    tick_nohz_tick_stopped()) {
+			if (!cpu_online(cpu)) {
+				static int printed = 0;
+				if (!printed) {
+					printk("src: %d dst: %d stopped: %d\n", cpu, smp_processor_id(), tick_nohz_tick_stopped());
+					dump_stack();
+					printed = 1;
+				}
+			}
 			smp_send_reschedule(cpu);
+		}
 		return true;
 	}
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bc67d42..abfa8c3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -650,6 +650,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
+			WARN_ON_ONCE(!cpu_online(cpu));
 			trace_tick_stop(1, " ");
 		}
 

