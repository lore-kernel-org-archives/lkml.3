Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3GRSrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:47:04 -0400
Received: from science.horizon.com ([71.41.210.146]:33027 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759124Ab3GRSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:46:33 -0400
Date: 18 Jul 2013 14:46:26 -0400
Message-ID: <20130718184626.24697.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, waiman.long@hp.com
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
Cc: JBeulich@novell.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <51E7F11A.2040301@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thank for the revision, I will make such a change in the next version of 
> my patch.

I'm relying on you to correct any technical errors in my description.
I just meant "something more like this", not impose that exact wording.

> As I said in my response to Ingo, that change will make the lock more 
> unfair to the writers. However, I can run some tests to find out the 
> performance impact of such a way on the benchmarks that I used.

You can do a lot with the basic structure if you're willing to
go to XADD in the _lock_failed handlers.

Adding writer priority is possible, but at least some call sites have
to be reader-priority because they're recursive or are in interrupts,
and readers don't disable interrupts.

The basic solution is for writers to first detect if they're the *first*
writer.  If a write lock fails, look and see if it's > -RW_LOCK_BIAS.

If not, drop it and spin reading until it's >= 0, then try again.
(Possibly with XADD this time to combine the acquire and add.)

But when we *are* the first writer, subtract an additional -RW_LOCK_BIAS/2.
This tells pending readers "writer wating, back off!".


What readers do when they see that bit set in rwlock->lock-1 depends on
whether they're fair or unfair:

- Fair readers re-increment the lock and spin waiting for it to become >
  -RW_LOCK_BIAS/2, at which point they try to reacquire.
- Unfair readers say "ah, that means I can go ahead, thank you!".


A waiting writer waits for the lock to equal -RW_LOCK_BIAS/2, meaning
all readers have left.  Then it adds -RW_LOCK_BIAS/2, meaning "write
lock taken" and goes ahead.

At this point, there is a thundering horde while the held-off readers
get back in line.  But hopefully it overlaps with the writer's lock tenure.

When the writer drops its lock, the waiting readers go ahead, and the
spinning writers advance in a thundering horde to contend for first place.
(Again, the latency for this is hopefully covered by the readers'
lock tenure.)


I count 531 calls to read_lock in the kernel (10 of them are in
lib/locking-selftest.c, called RL).  I don't have any idea how difficult
it would be to divide them into read_lock_fair and read_lock_unfair.
