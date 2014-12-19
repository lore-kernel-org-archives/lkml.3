Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaLSXz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:55:26 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42826 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLSXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:55:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412192201520.17382@nanos>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<alpine.DEB.2.11.1412192201520.17382@nanos>
Date: Fri, 19 Dec 2014 15:55:23 -0800
X-Google-Sender-Auth: 54yrFBXxUwjysRykf9alGCmFI1s
Message-ID: <CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 3:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Now that all looks correct. So there is something else going on. After
> staring some more at it, I think we are looking at it from the wrong
> angle.
>
> The watchdog always detects CPU1 as stuck and we got completely
> fixated on the csd_wait() in the stack trace on CPU1. Now we have
> stack traces which show a different picture, i.e. CPU1 makes progress
> after a gazillion of seconds.

.. but that doesn't explain why CPU0 ends up always being at that
*exact* same instruction in the NMI backtrace.

While a fairly tight loop, together with "mmio read is very expensive
and synchronizing" would explain it. An MMIO read can easily be as
expensive as several thousand instructions.

> I think we really need to look at CPU1 itself.

Not so fast. Take another look at CPU0.

[24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[24998.090435]  <EOI>
[24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70


Really. None of that changed. NONE. The likelihood that we hit the
exact same instruction every time? Over a timefraem of more than a
minute?

The only way I see that happening is (a) NMI is completely buggered,
and the backtrace is just random crap that is always the same.  Or (b)
it's really a fairly tight loop.

The fact that you had a hrtimer interrupt happen in the *middle* of
__remove_hrtimer() is really another fairly strong hint. That smells
like "__remove_hrtimer() has a race with hrtimer interrupts".

And that race results in a basically endless loop (which perhaps ends
when the HRtimer overflows, in what, a few minutes?)

I really don't think you should look at CPU1. Not when CPU0 has such
an interesting pattern that you dismissed just because the HPET is
making progress.

                            Linus
