Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab3G0C5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 22:57:14 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61491 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab3G0C5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 22:57:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkGAFY281F5LPxH/2dsb2JhbABbgwY1uHqFMoEZF3SCJAEBBTocIxAIAxgJJQ8FJQMhE4gPDbhvBBaNGIJPB4MWbwOXXpFNgyYq
Date: Sat, 27 Jul 2013 12:57:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hch@lst.de,
        jack@suse.cz, curtw@google.com, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC fs] v2 Make sync() satisfy many requests with one
 invocation
Message-ID: <20130727025703.GF21982@dastard>
References: <20130726232852.GA15147@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726232852.GA15147@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:28:52PM -0700, Paul E. McKenney wrote:
> Dave Jones reported RCU stalls, overly long hrtimer interrupts, and
> amazingly long NMI handlers from a trinity-induced workload involving
> lots of concurrent sync() calls (https://lkml.org/lkml/2013/7/23/369).
> There are any number of things that one might do to make sync() behave
> better under high levels of contention, but it is also the case that
> multiple concurrent sync() system calls can be satisfied by a single
> sys_sync() invocation.
> 
> Given that this situation is reminiscent of rcu_barrier(), this commit
> applies the rcu_barrier() approach to sys_sync().  This approach uses
> a global mutex and a sequence counter.  The mutex is held across the
> sync() operation, which eliminates contention between concurrent sync()
> operations.
>
> The counter is incremented at the beginning and end of
> each sync() operation, so that it is odd while a sync() operation is in
> progress and even otherwise, just like sequence locks.
> 
> The code that used to be in sys_sync() is now in do_sync(), and sys_sync()
> now handles the concurrency.  The sys_sync() function first takes a
> snapshot of the counter, then acquires the mutex, and then takes another
> snapshot of the counter.  If the values of the two snapshots indicate that
> a full do_sync() executed during the mutex acquisition, the sys_sync()
> function releases the mutex and returns ("Our work is done!").  Otherwise,
> sys_sync() increments the counter, invokes do_sync(), and increments
> the counter again.
> 
> This approach allows a single call to do_sync() to satisfy an arbitrarily
> large number of sync() system calls, which should eliminate issues due
> to large numbers of concurrent invocations of the sync() system call.

This is not addressing the problem that is causing issues during
sync. Indeed, it only puts a bandaid over the currently observed
trigger.

Indeed, i suspect that this will significantly slow down concurrent
sync operations, as it serialised sync across all superblocks rather
than serialising per-superblock like is currently done. Indeed, that
per-superblock serialisation is where all the lock contention
problems are. And it's not sync alone that causes the contention
problems - it has to be combined with other concurrent workloads
that add or remove inodes from the inode cache at tha same time.

I have patches to address that by removing the source
of the lock contention completely, and not just for the sys_sync
trigger. Those patches make the problems with concurrent
sys_sync operation go away completely for me, not to mention improve
performance for 8+ thread metadata workloads on XFS significantly.

IOWs, I don't see that concurrent sys_sync operation is a problem at
all, and it is actively desirable for systems that have multiple
busy filesystems as it allows concurrent dispatch of IO across those
multiple filesystems. Serialising all sys_sync work might stop the
contention problems, but it will also slow down concurrent sync
operations on busy systems as it only allows one thread to dispatch
and wait for IO at a time.

So, let's not slap a bandaid over a symptom - let's address the
cause of the lock contention properly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
