Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaLOAiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:38:08 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36479 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaLOAiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:38:01 -0500
MIME-Version: 1.0
In-Reply-To: <20141214234654.GA396@redhat.com>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
Date: Sun, 14 Dec 2014 16:38:00 -0800
X-Google-Sender-Auth: rGR8jasTLMWZdzluoGyU6YzbEY4
Message-ID: <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 3:46 PM, Dave Jones <davej@redhat.com> wrote:
> On Sat, Dec 13, 2014 at 02:40:51PM -0800, Linus Torvalds wrote:
>  > On Sat, Dec 13, 2014 at 2:36 PM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > Ok, I think we can rule out preemption. I just checked on it, and
>  > > found it wedged.
>  >
>  > Ok, one more. Mind checking what happens without CONFIG_DEBUG_PAGEALLOC?
>
> Crap. Looks like it wedged. It's stuck that way until I get back to it
> on Wednesday.

Hey, this is not "crap" at all. Quite the reverse. I think you may
have hit on the real bug now, and it's possible that the
DEBUG_PAGEALLOC code was hiding it because it was trying to handle the
page fault.

Or something.

Anyway, this time your backtrace is *interesting*. It's showing
something that looks real. Namely "save_xstate_sig" apparently taking
a page fault. And unlike your earlier traces, now all the different
CPU traces show very similar things, which again is something that
makes a lot more sense than your previous lockups have.

That said, maybe I'm just being optimistic, because while the NMI
watchdog messages now look ostensibly much saner, I'm not actually
seeing what's really going on. But at least this time I *could*
imagine that it's something like infinitely taking a page fault in
save_xstate_sig. This is some pretty special code, with the whole FPU
save state handling  being one mess of random really subtle issues
with FPU exceptions, page faults, delayed allocation, yadda yadda.

And I could fairly easily imagine endless page faults due to the
exception table, or even endless signal handling loops due to getting
a signal while trying to handle a signal. Both things that would
actually reasonably result in a watchdog.

So I'm adding some x86 FPU save people to the cc.

Can anybody make sense of that backtrace, keeping in mind that we're
looking for some kind of endless loop where we don't make progress?

There's more in the original email (see on lkml if you haven't seen
the thread earlier already), but they look similar with that whole
do_signal -> save_xstate_sig -> do_page_fault thing just on other
CPU's.

DaveJ, do you have the kernel image for this? I'd love to see what the
code is around that "save_xstate_sig+0x81" or around those
__clear_user+0x17/0x36 points...

                          Linus


> [ 6188.985536] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c175:14205]
> [ 6188.985612] CPU: 1 PID: 14205 Comm: trinity-c175 Not tainted 3.18.0+ #103 [loadavg: 200.63 151.07 150.40 179/407 17316]
> [ 6188.985652] task: ffff880056ac96d0 ti: ffff8800975d8000 task.ti: ffff8800975d8000
> [ 6188.985680] RIP: 0010:[<ffffffff810c6430>]  [<ffffffff810c6430>] lock_release+0xc0/0x240
> [ 6188.985988] Stack:
> [ 6188.986101] Call Trace:
> [ 6188.986116]  [<ffffffff8116f928>] __perf_sw_event+0x168/0x240
> [ 6188.987079]  [<ffffffff8116f842>] ? __perf_sw_event+0x82/0x240
> [ 6188.988045]  [<ffffffff81178ab2>] ? __lock_page_or_retry+0xb2/0xc0
> [ 6188.989008]  [<ffffffff811a68f8>] ? handle_mm_fault+0x458/0xe90
> [ 6188.989986]  [<ffffffff8104250e>] __do_page_fault+0x28e/0x5c0
> [ 6188.990940]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 6188.991884]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
> [ 6188.992826]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
> [ 6188.993773]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [ 6188.994715]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
> [ 6188.995658]  [<ffffffff817d1a32>] page_fault+0x22/0x30
> [ 6188.996590]  [<ffffffff81375266>] ? __clear_user+0x36/0x60
> [ 6188.997518]  [<ffffffff81375247>] ? __clear_user+0x17/0x60
> [ 6188.998440]  [<ffffffff8100f3f1>] save_xstate_sig+0x81/0x220
> [ 6188.999362]  [<ffffffff817cf1cf>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
> [ 6189.000291]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
> [ 6189.001220]  [<ffffffff81209acf>] ? mnt_drop_write+0x2f/0x40
> [ 6189.002164]  [<ffffffff811e527e>] ? chmod_common+0xfe/0x150
> [ 6189.003096]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
> [ 6189.004038]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 6189.004972]  [<ffffffff817d00ff>] int_signal+0x12/0x17
> [ 6189.005899] Code: ff 0f 85 7c 00 00 00 4c 89 ea 4c 89 e6 48 89 df e8 26 fc ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 41 56 9d <48> 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d f3 c3 65 ff 04 25 e0
