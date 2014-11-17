Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaKQREN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaKQREL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:04:11 -0500
Date: Mon, 17 Nov 2014 12:03:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141117170359.GA1382@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 10:33:19PM -0800, Linus Torvalds wrote:
 
 > >  > I'll try that next, and check in on it tomorrow.
 > >
 > > No luck. Died even faster this time.
 > 
 > Yeah, and your other lockups haven't even been TLB related. Not that
 > they look like anything else *either*.
 > 
 > I have no ideas left. I'd go for a bisection - rather than try random
 > things, at least bisection will get us a smaller set of suspects if
 > you can go through a few cycles of it. Even if you decide that you
 > want to run for most of a day before you are convinced it's all good,
 > a couple of days should get you a handful of bisection points (that's
 > assuming you hit a couple of bad ones too that turn bad in a shorter
 > while). And 4 or five bisections should get us from 11k commits down
 > to the ~600 commit range. That would be a huge improvement.

Great start to the week: I decided to confirm my recollection that .17
was ok, only to hit this within 10 minutes.

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
CPU: 3 PID: 17176 Comm: trinity-c95 Not tainted 3.17.0+ #87
 0000000000000000 00000000f3a61725 ffff880244606bf0 ffffffff9583e9fa
 ffffffff95c67918 ffff880244606c78 ffffffff9583bcc0 0000000000000010
 ffff880244606c88 ffff880244606c20 00000000f3a61725 0000000000000000
Call Trace:
 <NMI>  [<ffffffff9583e9fa>] dump_stack+0x4e/0x7a
 [<ffffffff9583bcc0>] panic+0xd4/0x207
 [<ffffffff95150908>] watchdog_overflow_callback+0x118/0x120
 [<ffffffff95193dbe>] __perf_event_overflow+0xae/0x340
 [<ffffffff95192230>] ? perf_event_task_disable+0xa0/0xa0
 [<ffffffff9501a7bf>] ? x86_perf_event_set_period+0xbf/0x150
 [<ffffffff95194be4>] perf_event_overflow+0x14/0x20
 [<ffffffff95020676>] intel_pmu_handle_irq+0x206/0x410
 [<ffffffff9501966b>] perf_event_nmi_handler+0x2b/0x50
 [<ffffffff95007bb2>] nmi_handle+0xd2/0x390
 [<ffffffff95007ae5>] ? nmi_handle+0x5/0x390
 [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 [<ffffffff950080a2>] default_do_nmi+0x72/0x1c0
 [<ffffffff950082a8>] do_nmi+0xb8/0x100
 [<ffffffff9584b9aa>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 <<EOE>>  <IRQ>  [<ffffffff95101685>] lock_hrtimer_base.isra.18+0x25/0x50
 [<ffffffff951019d3>] hrtimer_try_to_cancel+0x33/0x1f0
 [<ffffffff95101baa>] hrtimer_cancel+0x1a/0x30
 [<ffffffff95113557>] tick_nohz_restart+0x17/0x90
 [<ffffffff95114533>] __tick_nohz_full_check+0xc3/0x100
 [<ffffffff9511457e>] nohz_full_kick_work_func+0xe/0x10
 [<ffffffff95188894>] irq_work_run_list+0x44/0x70
 [<ffffffff951888ea>] irq_work_run+0x2a/0x50
 [<ffffffff9510109b>] update_process_times+0x5b/0x70
 [<ffffffff95113325>] tick_sched_handle.isra.20+0x25/0x60
 [<ffffffff95113801>] tick_sched_timer+0x41/0x60
 [<ffffffff95102281>] __run_hrtimer+0x81/0x480
 [<ffffffff951137c0>] ? tick_sched_do_timer+0xb0/0xb0
 [<ffffffff95102977>] hrtimer_interrupt+0x117/0x270
 [<ffffffff950346d7>] local_apic_timer_interrupt+0x37/0x60
 [<ffffffff9584c44f>] smp_apic_timer_interrupt+0x3f/0x50
 [<ffffffff9584a86f>] apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffff950d3f3a>] ? lock_release_holdtime.part.28+0x9a/0x160
 [<ffffffff950ef3b7>] ? rcu_is_watching+0x27/0x60
 [<ffffffff9508cb75>] kill_pid_info+0xf5/0x130
 [<ffffffff9508ca85>] ? kill_pid_info+0x5/0x130
 [<ffffffff9508ccd3>] SYSC_kill+0x103/0x330
 [<ffffffff9508cc7c>] ? SYSC_kill+0xac/0x330
 [<ffffffff9519b592>] ? context_tracking_user_exit+0x52/0x1a0
 [<ffffffff950d6f1d>] ? trace_hardirqs_on_caller+0x16d/0x210
 [<ffffffff950d6fcd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff950137ad>] ? syscall_trace_enter+0x14d/0x330
 [<ffffffff9508f44e>] SyS_kill+0xe/0x10
 [<ffffffff95849b24>] tracesys+0xdd/0xe2
Kernel Offset: 0x14000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

It could a completely different cause for lockup, but seeing this now
has me wondering if perhaps it's something unrelated to the kernel.
I have recollection of running late .17rc's for days without incident,
and I'm pretty sure .17 was ok too.  But a few weeks ago I did upgrade
that test box to the Fedora 21 beta.  Which means I have a new gcc.
I'm not sure I really trust 4.9.1 yet, so maybe I'll see if I can
get 4.8 back on there and see if that's any better.

	Dave

