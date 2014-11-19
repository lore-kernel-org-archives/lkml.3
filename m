Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaKSEk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:40:57 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58822 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaKSEk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:40:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141119021902.GA14216@redhat.com>
References: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141117170359.GA1382@redhat.com>
	<CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
	<20141118020959.GA2091@redhat.com>
	<CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
	<20141118023930.GA2871@redhat.com>
	<CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
Date: Tue, 18 Nov 2014 20:40:55 -0800
X-Google-Sender-Auth: iavkIwHNpSotXy4XHgVjstaUP9c
Message-ID: <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 6:19 PM, Dave Jones <davej@redhat.com> wrote:
>
> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 21s! [trinity-c42:31480]
> CPU: 2 PID: 31480 Comm: trinity-c42 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
> RIP: 0010:[<ffffffff8a1798b4>]  [<ffffffff8a1798b4>] context_tracking_user_enter+0xa4/0x190
> Call Trace:
>  [<ffffffff8a012fc5>] syscall_trace_leave+0xa5/0x160
>  [<ffffffff8a7d8624>] int_check_syscall_exit_work+0x34/0x3d

Hmm, if we are getting soft-lockups here, maybe it suggest too much exit-work.

Some TIF_NOHZ loop, perhaps? You have nohz on, don't you?

That makes me wonder: does the problem go away if you disable NOHZ?

> CPU: 0 PID: 27716 Comm: kworker/0:1 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
> Workqueue: events nohz_kick_work_fn
> RIP: 0010:[<ffffffff8a0ffb52>]  [<ffffffff8a0ffb52>] smp_call_function_many+0x1b2/0x320
> Call Trace:
>  [<ffffffff8a0fa3f5>] tick_nohz_full_kick_all+0x35/0x70
>  [<ffffffff8a0ec8fe>] nohz_kick_work_fn+0xe/0x10
>  [<ffffffff8a08e61d>] process_one_work+0x1fd/0x590
>  [<ffffffff8a08eacb>] worker_thread+0x11b/0x490
>  [<ffffffff8a0942e9>] kthread+0xf9/0x110
>  [<ffffffff8a7d82ac>] ret_from_fork+0x7c/0xb0

Yeah, there's certainly some NOHZ work going on on CPU0 too.


> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 10/411 32140]
> RIP: 0010:[<ffffffff8a3e14a5>]  [<ffffffff8a3e14a5>] intel_idle+0xd5/0x180
> Call Trace:
>  [<ffffffff8a666075>] cpuidle_enter_state+0x55/0x1c0
>  [<ffffffff8a666297>] cpuidle_enter+0x17/0x20
>  [<ffffffff8a0bb323>] cpu_startup_entry+0x433/0x4e0
>  [<ffffffff8a02b763>] start_secondary+0x1a3/0x220

Nothing.

> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 10/411 32140]
> RIP: 0010:[<ffffffff8a3e14a5>]  [<ffffffff8a3e14a5>] intel_idle+0xd5/0x180
>  [<ffffffff8a666075>] cpuidle_enter_state+0x55/0x1c0
>  [<ffffffff8a666297>] cpuidle_enter+0x17/0x20
>  [<ffffffff8a0bb323>] cpu_startup_entry+0x433/0x4e0
>  [<ffffffff8a02b763>] start_secondary+0x1a3/0x220

Nothing.

Hmm. NOHZ?

                     Linus
