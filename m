Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3GEKZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:25:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:44270 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3GEKZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:25:36 -0400
Date: Fri, 5 Jul 2013 12:25:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com,
        john.stultz@linaro.org, xen-devel@lists.xen.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
In-Reply-To: <51D69ACF.9020001@citrix.com>
Message-ID: <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com> <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org> <20130705093003.GA4033@cpv436-motbuntu> <51D69ACF.9020001@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, David Vrabel wrote:

You failed to CC Artem :(

> On 05/07/13 10:30, Artem Savkov wrote:
> > This commit brings up a warning about a potential deadlock in
> > smp_call_function_many() discussed previously:
> > https://lkml.org/lkml/2013/4/18/546
> 
> Can we just avoid the wait in clock_was_set()?  Something like this?
> 
> 8<------------------------------------------------------
> hrtimers: do not wait for other CPUs in clock_was_set()
> 
> Calling on_each_cpu() and waiting in a softirq causes a WARNing about
> a potential deadlock.
> 
> Because hrtimers are per-CPU, it is sufficient to ensure that all
> other CPUs' timers are reprogrammed as soon as possible and before the
> next softirq on that CPU.  There is no need to wait for this to be
> complete on all CPUs.
> 
> on_each_cpu() works by IPIing all CPUs which will ensure
> retrigger_next_event() will be called as earlier as possible and
> before the next softirq.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  kernel/hrtimer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index e86827e..fd5d391 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -766,7 +766,7 @@ void clock_was_set(void)
>  {
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  	/* Retrigger the CPU local events everywhere */
> -	on_each_cpu(retrigger_next_event, NULL, 1);
> +	on_each_cpu(retrigger_next_event, NULL, 0);
>  #endif
>  	timerfd_clock_was_set();
>  }
> -- 
> 1.7.2.5
> 
> 
> > 
> > [ 4363.082047] PM: Restoring platform NVS memory
> > [ 4363.082471] ------------[ cut here ]------------
> > [ 4363.083800] WARNING: CPU: 0 PID: 3977 at kernel/smp.c:385 smp_call_function_many+0xbd/0x2c0()
> > [ 4363.085789] Modules linked in:
> > [ 4363.086542] CPU: 0 PID: 3977 Comm: pm-suspend Tainted: G        W    3.10.0-next-20130705 #126
> > [ 4363.088634] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [ 4363.090402]  0000000000000181 ffff88001f403d98 ffffffff81d2e2b7 ffffffff821cdb2e
> > [ 4363.092366]  0000000000000000 ffff88001f403dd8 ffffffff810a278c ffff88001f403dd8
> > [ 4363.094215]  0000000000000000 0000000000000000 0000000000000000 ffffffff82561898
> > [ 4363.096094] Call Trace:
> > [ 4363.096656]  <IRQ>  [<ffffffff81d2e2b7>] dump_stack+0x59/0x82
> > [ 4363.098259]  [<ffffffff810a278c>] warn_slowpath_common+0x8c/0xc0
> > [ 4363.099762]  [<ffffffff810a27da>] warn_slowpath_null+0x1a/0x20
> > [ 4363.100925]  [<ffffffff81118fcd>] smp_call_function_many+0xbd/0x2c0
> > [ 4363.101937]  [<ffffffff8110f0dd>] ? trace_hardirqs_on+0xd/0x10
> > [ 4363.102870]  [<ffffffff810d7030>] ? hrtimer_wakeup+0x30/0x30
> > [ 4363.103737]  [<ffffffff811193bb>] smp_call_function+0x3b/0x50
> > [ 4363.104609]  [<ffffffff810d7030>] ? hrtimer_wakeup+0x30/0x30
> > [ 4363.105455]  [<ffffffff8111943b>] on_each_cpu+0x3b/0x120
> > [ 4363.106249]  [<ffffffff810d743c>] clock_was_set+0x1c/0x30
> > [ 4363.107168]  [<ffffffff810d825c>] run_hrtimer_softirq+0x2c/0x40
> > [ 4363.108055]  [<ffffffff810acf26>] __do_softirq+0x216/0x450
> > [ 4363.108865]  [<ffffffff810ad297>] irq_exit+0x77/0xb0
> > [ 4363.109618]  [<ffffffff81d414da>] smp_apic_timer_interrupt+0x4a/0x60
> > [ 4363.110569]  [<ffffffff81d40032>] apic_timer_interrupt+0x72/0x80
> > [ 4363.111467]  <EOI>  [<ffffffff8110eb24>] ? mark_held_locks+0x134/0x160
> > [ 4363.112481]  [<ffffffff810f52af>] ? arch_suspend_enable_irqs+0x2f/0x40
> > [ 4363.113457]  [<ffffffff810f528e>] ? arch_suspend_enable_irqs+0xe/0x40
> > [ 4363.113910]  [<ffffffff810f54c1>] suspend_enter+0x1d1/0x270
> > [ 4363.114320]  [<ffffffff810f5794>] suspend_devices_and_enter+0x1a4/0x390
> > [ 4363.114887]  [<ffffffff810f5a74>] enter_state+0xf4/0x150
> > [ 4363.115288]  [<ffffffff810f5aeb>] pm_suspend+0x1b/0x70
> > [ 4363.115662]  [<ffffffff810f452b>] state_store+0xeb/0xf0
> > [ 4363.116055]  [<ffffffff815d3fc7>] kobj_attr_store+0x17/0x20
> > [ 4363.116468]  [<ffffffff8126f113>] sysfs_write_file+0xb3/0x100
> > [ 4363.116890]  [<ffffffff811f0aca>] vfs_write+0xda/0x170
> > [ 4363.117274]  [<ffffffff811f10b2>] SyS_write+0x62/0xa0
> > [ 4363.117645]  [<ffffffff815e01fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [ 4363.118118]  [<ffffffff81d3f399>] system_call_fastpath+0x16/0x1b
> > [ 4363.118558] ---[ end trace 87cc49a77badea1e ]---
> > [ 4363.119093] Enabling non-boot CPUs ...
> > 
> > 
> > On Fri, Jun 28, 2013 at 02:18:37PM -0700, tip-bot for David Vrabel wrote:
> >> Commit-ID:  7c4c3a0f18ba57ea2a2985034532303d2929902a
> >> Gitweb:     http://git.kernel.org/tip/7c4c3a0f18ba57ea2a2985034532303d2929902a
> >> Author:     David Vrabel <david.vrabel@citrix.com>
> >> AuthorDate: Thu, 27 Jun 2013 11:35:44 +0100
> >> Committer:  Thomas Gleixner <tglx@linutronix.de>
> >> CommitDate: Fri, 28 Jun 2013 23:15:06 +0200
> >>
> >> hrtimers: Support resuming with two or more CPUs online (but stopped)
> >>
> >> hrtimers_resume() only reprograms the timers for the current CPU as it
> >> assumes that all other CPUs are offline at this point in the resume
> >> process. If other CPUs are online then their timers will not be
> >> corrected and they may fire at the wrong time.
> >>
> >> When running as a Xen guest, this assumption is not true.  Non-boot
> >> CPUs are only stopped with IRQs disabled instead of offlining them.
> >> This is a performance optimization as disabling the CPUs would add an
> >> unacceptable amount of additional downtime during a live migration (>
> >> 200 ms for a 4 VCPU guest).
> >>
> >> hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
> >> as the other CPUs will be stopped with IRQs disabled.  Instead, defer
> >> the call to the next softirq.
> >>
> >> [ tglx: Separated the xen change out ]
> >>
> >> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> >> Cc: Konrad Rzeszutek Wilk  <konrad.wilk@oracle.com>
> >> Cc: John Stultz  <john.stultz@linaro.org>
> >> Cc: <xen-devel@lists.xen.org>
> >> Link: http://lkml.kernel.org/r/1372329348-20841-2-git-send-email-david.vrabel@citrix.com
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >> ---
> >>  kernel/hrtimer.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> >> index fd4b13b..e86827e 100644
> >> --- a/kernel/hrtimer.c
> >> +++ b/kernel/hrtimer.c
> >> @@ -773,15 +773,24 @@ void clock_was_set(void)
> >>  
> >>  /*
> >>   * During resume we might have to reprogram the high resolution timer
> >> - * interrupt (on the local CPU):
> >> + * interrupt on all online CPUs.  However, all other CPUs will be
> >> + * stopped with IRQs interrupts disabled so the clock_was_set() call
> >> + * must be deferred to the softirq.
> >> + *
> >> + * The one-shot timer has already been programmed to fire immediately
> >> + * (see tick_resume_oneshot()) and this interrupt will trigger the
> >> + * softirq to run early enough to correctly reprogram the timers on
> >> + * all CPUs.
> >>   */
> >>  void hrtimers_resume(void)
> >>  {
> >> +	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
> >> +
> >>  	WARN_ONCE(!irqs_disabled(),
> >>  		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
> >>  
> >> -	retrigger_next_event(NULL);
> >> -	timerfd_clock_was_set();
> >> +	cpu_base->clock_was_set = 1;
> >> +	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
> >>  }
> >>  
> >>  static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> 
> 
