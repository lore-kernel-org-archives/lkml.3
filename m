Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096AbaLLTOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:14:11 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39003 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934940AbaLLTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141212185454.GB4716@redhat.com>
References: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
Date: Fri, 12 Dec 2014 11:14:06 -0800
X-Google-Sender-Auth: kQEPL1LriZEq1-8H65GaHpaA_Hw
Message-ID: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
>
> Something that's still making me wonder if it's some kind of hardware
> problem is the non-deterministic nature of this bug.

I'd expect it to be a race condition, though. Which can easily cause
these kinds of issues, and the timing will be pretty random even if
the load is very regular.

And we know that the scheduler has an integer overflow under Sasha's
loads, although I didn't hear anything from Ingo and friends about it.
Ingo/Peter, you were cc'd on that report, where at least one of the
multiplcations in wake_affine() ended up overflowing..

Some scheduler thing that overflows only under heavy load, and screws
up scheduling could easily account for the RCU thread thing. I see it
*less* easily accounting for DaveJ's case, though, because the
watchdog is running at RT priority,  and the scheduler would have to
screw up much more to then not schedule an RT task, but..

I'm also not sure if the bug ever happens with preemption disabled.
Sasha, was that you who reported that you cannot reproduce it without
preemption? It strikes me that there's a race condition in
__cond_resched() wrt preemption, for example: we do

        __preempt_count_add(PREEMPT_ACTIVE);
        __schedule();
        __preempt_count_sub(PREEMPT_ACTIVE);

and in between the __schedule() and __preempt_count_sub(), if an
interrupt comes in and wakes up some important process, it won't
reschedule (because preemption is active), but then we enable
preemption again and don't check whether we should reschedule (again),
and we just go on our merry ways.

Now, I don't see how that could really matter for a long time -
returning to user space will check need_resched, and sleeping will
obviously force a reschedule anyway, so these kinds of races should at
most delay things by just a tiny amount, but maybe there is some case
where we screw up in a bigger way. So I do *not* believe that the one
in __cond_resched() matters, but I'm giving it as an example of the
kind of things that could go wrong.

                        Linus
