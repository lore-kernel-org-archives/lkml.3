Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3LSPUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:20:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3LSPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:20:10 -0500
Date: Thu, 19 Dec 2013 16:20:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
Message-ID: <20131219152002.GK16438@laptop.programming.kicks-ass.net>
References: <52B289F4.7060205@oracle.com>
 <20131219103401.GE30183@twins.programming.kicks-ass.net>
 <52B2FC66.9010309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B2FC66.9010309@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:02:14AM -0500, Sasha Levin wrote:
> On 12/19/2013 05:34 AM, Peter Zijlstra wrote:
> >On Thu, Dec 19, 2013 at 12:53:56AM -0500, Sasha Levin wrote:
> >>Hi all,
> >>
> >>I think that my bloated kernel managed to create way too many entries in the
> >>dependency table. If that sounds right, I can send a patch to increase those.
> >>
> >>Attached /proc/lock_stat as requested as well.
> >
> >/proc/lockdep_stats not lock_stat :-)
> >
> >Do you still happen to have that?
> 
> Is the BUG message intentional ("Please attach the output of /proc/lock_stat to the bug report")?

It does? This happened when I wasn't looking..

Commit 199e371f59d31 did that; and the Changelog fails to mention why or
what. Ingo, Dave?

So the thing I referred to was from Documentation/lockdep-design.txt:

---
Troubleshooting:
----------------

The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
Exceeding this number will trigger the following lockdep warning:

        (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))

By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
desktop systems have less than 1,000 lock classes, so this warning
normally results from lock-class leakage or failure to properly
initialize locks.  These two problems are illustrated below:

1.      Repeated module loading and unloading while running the validator
        will result in lock-class leakage.  The issue here is that each
        load of the module will create a new set of lock classes for
        that module's locks, but module unloading does not remove old
        classes (see below discussion of reuse of lock classes for why).
        Therefore, if that module is loaded and unloaded repeatedly,
        the number of lock classes will eventually reach the maximum.

2.      Using structures such as arrays that have large numbers of
        locks that are not explicitly initialized.  For example,
        a hash table with 8192 buckets where each bucket has its own
        spinlock_t will consume 8192 lock classes -unless- each spinlock
        is explicitly initialized at runtime, for example, using the
        run-time spin_lock_init() as opposed to compile-time initializers
        such as __SPIN_LOCK_UNLOCKED().  Failure to properly initialize
        the per-bucket spinlocks would guarantee lock-class overflow.
        In contrast, a loop that called spin_lock_init() on each lock
        would place all 8192 locks into a single lock class.

        The moral of this story is that you should always explicitly
        initialize your locks.

One might argue that the validator should be modified to allow
lock classes to be reused.  However, if you are tempted to make this
argument, first review the code and think through the changes that would
be required, keeping in mind that the lock classes to be removed are
likely to be linked into the lock-dependency graph.  This turns out to
be harder to do than to say.

Of course, if you do run out of lock classes, the next thing to do is
to find the offending lock classes.  First, the following command gives
you the number of lock classes currently in use along with the maximum:

        grep "lock-classes" /proc/lockdep_stats

This command produces the following output on a modest system:

         lock-classes:                          748 [max: 8191]

If the number allocated (748 above) increases continually over time,
then there is likely a leak.  The following command can be used to
identify the leaking lock classes:

        grep "BD" /proc/lockdep

Run the command and save the output, then compare against the output from
a later run of this command to identify the leakers.  This same output
can also help you find situations where runtime lock initialization has
been omitted.

