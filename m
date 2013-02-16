Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3BPT0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:26:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41228 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3BPT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:26:08 -0500
Date: Sat, 16 Feb 2013 11:25:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130216192554.GB7035@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com>
 <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
 <20130215174435.GA2792@linux.vnet.ibm.com>
 <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
 <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
 <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021619-7606-0000-0000-0000087745B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:50:31AM -0800, Linus Torvalds wrote:
> On Fri, Feb 15, 2013 at 10:35 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Feb 15, 2013 at 10:34 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> Something like this ENTIRELY UNTESTED patch.
> >
> > .. and let's actually attach the patch this time.
> 
> That's odd. I got a "server error" from gmail. And again no attachment.
> 
> Maybe THIS time.

Sorry for the delay in testing this, but there was a need to upgrade
my laptop, and bozo here figured "why not go to 64 bits while I am at
it?" -- and then proceeded to learn the hard way that it is necessary
to do "make mrproper" before doing a build in 64-bit mode.  :-/

The kernel build system's way of telling you this at the moment is:

arch/x86/built-in.o:(.rodata+0x4990): undefined reference to `stub32_sigaltstack'

Anyway, with this patch, I see CPU stall warnings when running rcutorture
as shown below.  This is not a hard failure:

[   32.553647] rcu-torture: rtc: ffffffff836a57a0 ver: 131 tfle: 0 rta: 131 rtaf: 0 rtf: 93 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 27 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 6/7:0

Note the "ver: 131", which means that rcutorture successfully did 131
grace periods before the failure.  It manages to offline a CPU subsequently,
but then appears to hang while onlining it.

							Thanx, Paul

	[   23.706051] INFO: rcu_preempt self-detected stall on CPU[   23.707053] INFO: rcu_preempt self-detected stall on CPU
	[   23.707053] 	1: (20976 ticks this GP) idle=883/140000000000001/0 drain=5 . timer not pending
	[   23.707053] 	 (t=21000 jiffies g=85 c=84 q=6756)
	[   23.707053] Pid: 606, comm: rcu_torture_rea Not tainted 3.8.0-rc7+ #2
	[   23.707053] Call Trace:
	[   23.707053]  <IRQ>  [<ffffffff810c12b2>] rcu_pending+0x192/0x7a0
	[   23.707053]  [<ffffffff810c590b>] rcu_check_callbacks+0xbb/0x220
	[   23.707053]  [<ffffffff8104c193>] update_process_times+0x43/0x80
	[   23.707053]  [<ffffffff8108f901>] tick_sched_handle.isra.8+0x31/0x40
	[   23.707053]  [<ffffffff8108f9f7>] tick_sched_timer+0x47/0x70
	[   23.707053]  [<ffffffff8106619c>] __run_hrtimer+0x7c/0x240
	[   23.707053]  [<ffffffff8108f9b0>] ? tick_nohz_handler+0xa0/0xa0
	[   23.707053]  [<ffffffff81089617>] ? ktime_get_update_offsets+0x47/0xd0
	[   23.707053]  [<ffffffff81066a37>] hrtimer_interrupt+0xf7/0x240
	[   23.707053]  [<ffffffff81025883>] smp_apic_timer_interrupt+0x63/0xa0
	[   23.707053]  [<ffffffff817b6e8a>] apic_timer_interrupt+0x6a/0x70
	[   23.707053]  <EOI>  [<ffffffff817af17d>] ? _raw_spin_unlock_irq+0xd/0x40
	[   23.707053]  [<ffffffff817ae2aa>] __schedule+0x68a/0x790
	[   23.707053]  [<ffffffff817ae4c4>] schedule+0x24/0x70
	[   23.707053]  [<ffffffff810c05b7>] rcu_torture_reader+0xd7/0x2d0
	[   23.707053]  [<ffffffff810c07b0>] ? rcu_torture_reader+0x2d0/0x2d0
	[   23.707053]  [<ffffffff810c04e0>] ? rcutorture_trace_dump+0x50/0x50
	[   23.707053]  [<ffffffff81061e6b>] kthread+0xbb/0xc0
	[   23.707053]  [<ffffffff817a0000>] ? timer_cpu_notify+0x1e9/0x300
	[   23.707053]  [<ffffffff81061db0>] ? flush_kthread_worker+0xa0/0xa0
	[   23.707053]  [<ffffffff817b626c>] ret_from_fork+0x7c/0xb0
	[   23.707053]  [<ffffffff81061db0>] ? flush_kthread_worker+0xa0/0xa0

	[   23.706051] 
	[   23.706051] 	0: (1 GPs behind) idle=429/140000000000001/0 drain=5 . timer not pending
	[   23.706051] 	 (t=21000 jiffies g=85 c=84 q=6756)
	[   23.706051] Pid: 603, comm: rcu_torture_rea Not tainted 3.8.0-rc7+ #2
	[   23.706051] Call Trace:
	[   23.706051]  <IRQ>  [<ffffffff810c12b2>] rcu_pending+0x192/0x7a0
	[   23.706051]  [<ffffffff810c590b>] rcu_check_callbacks+0xbb/0x220
	[   23.706051]  [<ffffffff8104c193>] update_process_times+0x43/0x80
	[   23.706051]  [<ffffffff8108f901>] tick_sched_handle.isra.8+0x31/0x40
	[   23.706051]  [<ffffffff8108f9f7>] tick_sched_timer+0x47/0x70
	[   23.706051]  [<ffffffff8106619c>] __run_hrtimer+0x7c/0x240
	[   23.706051]  [<ffffffff8108f9b0>] ? tick_nohz_handler+0xa0/0xa0
	[   23.706051]  [<ffffffff81089617>] ? ktime_get_update_offsets+0x47/0xd0
	[   23.706051]  [<ffffffff81066a37>] hrtimer_interrupt+0xf7/0x240
	[   23.706051]  [<ffffffff81025883>] smp_apic_timer_interrupt+0x63/0xa0
	[   23.706051]  [<ffffffff817b6e8a>] apic_timer_interrupt+0x6a/0x70
	[   23.706051]  <EOI>  [<ffffffff817b2ae0>] ? add_preempt_count+0x30/0x90
	[   23.706051]  [<ffffffff817adc5d>] __schedule+0x3d/0x790
	[   23.706051]  [<ffffffff817ae4c4>] schedule+0x24/0x70
	[   23.706051]  [<ffffffff810c05b7>] rcu_torture_reader+0xd7/0x2d0
	[   23.706051]  [<ffffffff810c07b0>] ? rcu_torture_reader+0x2d0/0x2d0
	[   23.706051]  [<ffffffff810c04e0>] ? rcutorture_trace_dump+0x50/0x50
	[   23.706051]  [<ffffffff81061e6b>] kthread+0xbb/0xc0
	[   23.706051]  [<ffffffff817a0000>] ? timer_cpu_notify+0x1e9/0x300
	[   23.706051]  [<ffffffff81061db0>] ? flush_kthread_worker+0xa0/0xa0
	[   23.706051]  [<ffffffff817b626c>] ret_from_fork+0x7c/0xb0
	[   23.706051]  [<ffffffff81061db0>] ? flush_kthread_worker+0xa0/0xa0

