Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaBAKiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 05:38:25 -0500
Received: from science.horizon.com ([71.41.210.146]:37296 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751733AbaBAKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 05:38:22 -0500
Date: 1 Feb 2014 05:38:20 -0500
Message-ID: <20140201103820.32043.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org, waiman.long@hp.com
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock implementation
Cc: akpm@linux-foundation.org, andi@firstfloor.org, arnd@arndb.de,
        aswin@hp.com, hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, tim.c.chen@linux.intel.com,
        torvalds@linux-foundation.org, walken@google.com, x86@kernel.org
In-Reply-To: <20140131194718.GO5002@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 01:59:02PM -0500, Waiman Long wrote:
>> Using a ticket lock instead will have the same scalability problem as the
>> ticket spinlock as all the waiting threads will spin on the lock cacheline
>> causing a lot of cache bouncing traffic. That is the reason why I want to
>> replace ticket spinlock with queue spinlock.

> But but but, just fix such heavily contended locks. Don't make sensible
> code that is lightly contended run slower because of it.

While I agree that zero slowdown for "good" code is the goal, it is
impossible for the kernel to consist of only "good" code.

In particular, obscure error conditions causing locked regions to take
much longer than expected will never be completely expurgated; there's
a point where you just say "I'm not working for a week to save 10 people
per year a 2-minute stall."

What Waiman noted is that ticket locks take O(n^2) cache line transfers
to clear n waiters from the queue.  (Each write must be broadcast to
each spinning reader.)  So if you *do* get most of a large multiprocessor
piled up on a ticket lock, the performance can be disastrous.

It can conceivably send a large system into a "congestion collapse"
where the queue never clears.  And it can affect processors (such as
other partitions of a large machine) that aren't even contending for
the lock.

The MCS lock is O(1) per release and O(n) to clear n waiters.  This is
a noticeable improvement on 4- or 8-way contention, and (Waiman reports)
a huge improvement on 50-way and up.

Yes, if such contention occurs with any frequency at all, it should be
fixed, but it does seem worth mitigating problems in the meantime.

(As an aside, I have in the past heard people criticize the Linux kernel
for being optimized for the average case at the expense of worst-case
corner cases.)

Are we agreed that *not* improving highly-contended performance on the
grounds that it would discourage other optimization is as stupid as not
wearing a seat-belt because that would discourage more careful driving?


While I do think *some* benchmarking on smaller SMP systems is wanted,
given that Waiman has mananged to make the *uncontended* case faster,
and *that* is by far the most common case, it's quite plausible that it
will turn out to be a net performance improvement on 4- and 8-way systems.
