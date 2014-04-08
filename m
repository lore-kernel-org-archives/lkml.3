Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaDHSxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:53:53 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:35030 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbaDHSxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140408181305.GT10526@twins.programming.kicks-ass.net>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	<CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	<CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	<20140408181305.GT10526@twins.programming.kicks-ass.net>
Date: Tue, 8 Apr 2014 11:53:47 -0700
X-Google-Sender-Auth: NGNoa7wUW6YHgSr81Ky1OQrgrtE
Message-ID: <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Stancek <jstancek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 11:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Apr 08, 2014 at 10:33:55AM -0700, Linus Torvalds wrote:
>> Hmm. And let's think about that powerpc race, where "spin_is_locked()"
>> can be false when somebody is waiting to get the lock..
>
> Right; so in the original discussion I never really got to why that is a
> problem. A pending waiter cannot modify the wait list, so either we see
> the current holder, or we see a stable list.

It's not just the list vs lock, it's also the ordering wrt the actual
futex value accesses. I have to say, the "waiters" approach makes
things a lot simpler, because then the main ordering issues are just
between "waiters and futex value".

The spinlock+waitqueue thing is rather more complex, because the
spinlock is gotten before reading the futex value (on the waiting
side), but *after* writing the futex value (on the waking side). While
the waitqueue is then modified *after* reading the futex value (on
both the waiting and waking side).

Now, on x86, my argument for using the "spinlock + wait queue"
combination was that getting the spinlock actually has the exact same
semantics as the atomic waiters update (because it really *is* an
atomic add), and while the spin-unlock destroys it, we can largely
ignore that because by that time we'd have been guaranteed to see the
wait-queue change too.

But even on x86, I was a *bit* worried about the ordering of the
"spin_is_locked()" read and the waitqueue value read.  I thought about
it, and the smp_rmb() we put in place should have been safe, but I
have to admit that I was a bit nervous. It gets really hard to think
about these things.

So while I still think it should all work, I have to admit that I
didn't really mind horribly much going back to the explicit "waiters"
model that had a lot simpler ordering: just between the "waiters"
accesses and the "futex value" accesses, and without that combination
of "before and after" thing.

Which is also why I think I'd prefer to make the requeueing case have
the *same* rules, ie "waiters" needs to be incremented *before*
getting the spinlock.

A simple patch that adds a "hb_waiters_inc(&hb2);" to the top of
double_lock_hb(), and a "hb_waiters_decc(&hb2);" to double_unlock_hb()
would seem to be the simplest solution. But that adds some unnecessary
atomics (in particular, to the futex_wake_op() case too, which doesn't
need it at all, it's just futex_requeue() that needs it, afaik).

But that alternative patch might be worth testing, just to verify that
"yes, doing the hb_waiters_inc before getting the lock really does fix
Jan's case *without* the use spin_is_locked()". Jan? Can you try that?

                 Linus
