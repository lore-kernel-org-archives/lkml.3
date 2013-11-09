Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3KIPXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:23:05 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47492 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3KIPXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:23:01 -0500
Date: Sat, 9 Nov 2013 16:22:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109152255.GC26079@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109151014.GN16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:11:01PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 08, 2013 at 11:36:58PM +0100, Frederic Weisbecker wrote:
> > [  237.359091]  [<ffffffff8101a4d1>] perf_callchain_kernel+0x51/0x70
> > [  237.365155]  [<ffffffff8111fec6>] perf_callchain+0x256/0x2c0
> > [  237.370783]  [<ffffffff8111bb5b>] perf_prepare_sample+0x27b/0x300
> > [  237.376849]  [<ffffffff810bc1ea>] ? __rcu_is_watching+0x1a/0x30
> > [  237.382736]  [<ffffffff8111bd2c>] __perf_event_overflow+0x14c/0x310
> > [  237.388973]  [<ffffffff8111bcd9>] ? __perf_event_overflow+0xf9/0x310
> > [  237.395291]  [<ffffffff8109aa6d>] ? trace_hardirqs_off+0xd/0x10
> > [  237.401186]  [<ffffffff815c8753>] ? _raw_spin_unlock_irqrestore+0x53/0x90
> > [  237.407941]  [<ffffffff81061b46>] ? do_send_sig_info+0x66/0x90
> > [  237.413744]  [<ffffffff8111c0f9>] perf_swevent_overflow+0xa9/0xc0
> > [  237.419808]  [<ffffffff8111c16f>] perf_swevent_event+0x5f/0x80
> > [  237.425610]  [<ffffffff8111c2b8>] perf_tp_event+0x128/0x420
> > [  237.431154]  [<ffffffff81008108>] ? smp_trace_irq_work_interrupt+0x98/0x2a0
> > [  237.438085]  [<ffffffff815c83b5>] ? _raw_read_unlock+0x35/0x60
> > [  237.443887]  [<ffffffff81003fe7>] perf_trace_x86_irq_vector+0xc7/0xe0
> > [  237.450295]  [<ffffffff81008108>] ? smp_trace_irq_work_interrupt+0x98/0x2a0
> > [  237.457226]  [<ffffffff81008108>] smp_trace_irq_work_interrupt+0x98/0x2a0
> > [  237.463983]  [<ffffffff815cb132>] trace_irq_work_interrupt+0x72/0x80
> > [  237.470303]  [<ffffffff815c8fb7>] ? retint_restore_args+0x13/0x13
> > [  237.476366]  [<ffffffff815c877a>] ? _raw_spin_unlock_irqrestore+0x7a/0x90
> > [  237.483117]  [<ffffffff810c101b>] rcu_process_callbacks+0x1db/0x530
> > [  237.489360]  [<ffffffff8105381d>] __do_softirq+0xdd/0x490
> > [  237.494728]  [<ffffffff81053fe6>] irq_exit+0x96/0xc0
> > [  237.499668]  [<ffffffff815cbc3a>] smp_trace_apic_timer_interrupt+0x5a/0x2b4
> > [  237.506596]  [<ffffffff815ca7b2>] trace_apic_timer_interrupt+0x72/0x80
> 
> Cute.. so what appears to happen is that:
> 
> 1) we trace irq_work_exit
> 2) we generate event
> 3) event needs to deliver signal
> 4) we queue irq_work to send signal
> 5) goto 1
> 
> Does something like this solve it?
> 
> ---
>  kernel/events/core.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4dc078d18929..a3ad40f347c4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5289,6 +5289,16 @@ static void perf_log_throttle(struct perf_event *event, int enable)
>  	perf_output_end(&handle);
>  }
>  
> +static inline void perf_pending(struct perf_event *event)
> +{
> +	if (in_nmi()) {
> +		irq_work_pending(&event->pending);

I guess you mean irq_work_queue()?

But there are much more reasons that just being in nmi to async wakeups, signal sending, etc...
The fact that an event can happen anywhere (rq lock acquire or whatever) makes perf events all fragile
enough to always require irq work for these.

Probably what we need is rather some limit. Maybe we can't seriously apply recursion checks here
but perhaps the simple fact that we raise an irq work from an irq work should trigger an alarm
of some sort.
