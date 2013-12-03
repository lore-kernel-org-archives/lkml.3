Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3LCSKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:10:31 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:59955 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3LCSKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:10:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131203085233.GA20179@gmail.com>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
	<CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
	<20131203085233.GA20179@gmail.com>
Date: Tue, 3 Dec 2013 10:10:29 -0800
X-Google-Sender-Auth: l2fNItGK6clNh-Ef1eyRhcuyAmE
Message-ID: <CA+55aFxhUYi6Lbrxfjgq7OqSDMF24wqvnGn_J_RAMY7y-AmRiQ@mail.gmail.com>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I'd expect such bugs to be more prominent with unlucky object
> size/alignment: if mutex->count lies on a separate cache line from
> mutex->wait_lock.

I doubt that makes much of a difference. It's still just "CPU cycles"
away, and the window will be tiny unless you have multi-socket
machines and/or are just very unlucky.

For stress-testing, it would be much better to use some hack like

    /* udelay a bit if the spinlock isn't contended */
    if (mutex->wait_lock.ticket.head+1 == mutex->wait_lock.ticket.tail)
        udelay(1);

in __mutex_unlock_common() just before the spin_unlock(). Make the
window really *big*.

That said:

>> So having a non-atomic refcount protected inside a sleeping lock is
>> a bug, and that's really the bug that ended up biting us for pipes.
>>
>> Now, the question is: do we have other such cases? How do we
>> document this? [...]
>
> I'd not be surprised if we had such cases, especially where
> spinlock->mutex conversions were done

So I actually don't think we do. Why? Having a sleeping lock inside
the object that protects the refcount is actually hard to do.

You need to increment the refcount when finding the object, but that
in turn tends to imply holding the lock *before* you find it. Or you
have to find it locklessly, which in turn implies RCU, which in turn
implies non-sleeping lock.

And quite frankly, anybody who uses SRCU and a sleeping lock is just
broken to begin with. That's just an abomination.  If the RT codepaths
do something like that, don't even tell me. It's broken and stupid.

So protecting a refcount with a mutex in the same object is really
quite hard. Even the pipe code didn't actually do that, it just
happened to nest the real lock inside the sleeping lock (but that's
also why it was so easy to fix - the sleeping lock wasn't actually
necessary or helpful in the refcounting path).

So my *gut* feel is that nobody does this. But people have been known
to do insane things just because they use too many sleeping locks and
think it's "better".

                Linus
