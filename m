Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaJBWBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:01:38 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:41555 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaJBWBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <20141002182409.GA29934@redhat.com>
References: <20140925141425.GA21702@redhat.com> <alpine.DEB.2.10.1409251630210.4604@nanos>
 <20140925234657.GB14870@lerouge> <20141002182409.GA29934@redhat.com>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Thu, 2 Oct 2014 23:01:16 +0100
Message-ID: <CAHbf0-F7NPNefH_tqDDA+5OU51x6Q9W6ZOj8xWv=kbXpT8ap2A@mail.gmail.com>
Subject: Re: hrtimer deadlock caused by nohz_full
To: Dave Jones <davej@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this might be the bug I reported here
https://bugzilla.kernel.org/show_bug.cgi?id=84131

On 2 October 2014 19:24, Dave Jones <davej@redhat.com> wrote:
> On Fri, Sep 26, 2014 at 01:46:59AM +0200, Frederic Weisbecker wrote:
>
>  > > >  [<ffffffffa10f95f8>] hrtimer_try_to_cancel+0x58/0x1f0
>  > > >  [<ffffffffa10f97aa>] hrtimer_cancel+0x1a/0x30
>  > > >  [<ffffffffa110a0e7>] tick_nohz_restart+0x17/0x90
>  > > >  [<ffffffffa110af38>] __tick_nohz_full_check+0xc8/0xe0
>  > > >  [<ffffffffa110af5e>] nohz_full_kick_work_func+0xe/0x10
>  > > >  [<ffffffffa117c9bf>] irq_work_run_list+0x4f/0x70
>  > > >  [<ffffffffa117ca0a>] irq_work_run+0x2a/0x60
>  > > >  [<ffffffffa10f82eb>] update_process_times+0x5b/0x70
>  > > >  [<ffffffffa1109dc5>] tick_sched_handle.isra.21+0x25/0x60
>  > > >  [<ffffffffa110a0b1>] tick_sched_timer+0x41/0x60
>  > > >  [<ffffffffa10f8c71>] __run_hrtimer+0x81/0x480
>  > > >  [<ffffffffa110a070>] ? tick_sched_do_timer+0x90/0x90
>  > > >  [<ffffffffa10f9b27>] hrtimer_interrupt+0x107/0x260
>  > > >  [<ffffffffa10331a4>] local_apic_timer_interrupt+0x34/0x60
>  > > >  [<ffffffffa182734f>] smp_apic_timer_interrupt+0x3f/0x60
>  > > >  [<ffffffffa182576f>] apic_timer_interrupt+0x6f/0x80
>  > >
>  > > hrtimer_interrupt
>  > >   tick_sched_timer
>  > >     tick_sched_handle
>  > >       update_process_times
>  > >         irq_work_run
>  > >      irq_work_run_list
>  > >        nohz_full_kick_work_func
>  > >          __tick_nohz_full_check
>  > >            tick_nohz_restart
>  > >                   hrtimer_cancel
>  > >
>  > > And that hrtimer_cancel is:
>  > >
>  > > static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
>  > > {
>  > >    hrtimer_cancel(&ts->sched_timer);
>  > >
>  > > Now, that's really bad because we are in the timer callback of
>  > > ts->sched_timer. So hrtimer_cancel will loop forever waiting for the
>  > > callback to complete.
>  > >
>  > > Frederic !?!?
>  >
>  > Right, this patchset fixes it: "[PATCH 0/8] nohz: Fix nohz kick irq work on tick v3"
>  >
>  > I was about to make the pull request, the branch is acked by peterz.
>  > Would you like to pull it? It's all merge window material.
>  >
>  > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>  >      nohz/fixes-v3
>
> I'm now hitting this with such regularity that it's preventing me from
> tracking down other bugs.  Can we get this merged soon please ?
>
>         Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
