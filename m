Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3CSBSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:18:00 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36366 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab3CSBR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:17:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIbAOS7R1F5LMSe/2dsb2JhbABDh0a4UoUjAQMBgV8XdIIkAQEEATocIwULCAMYCSUPBSUDIROIDgWyMpAZFY1gIB5dB4NAA5MYg0WRA4MeKA
Date: Tue, 19 Mar 2013 12:17:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Michel Lespinasse <walken@google.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
Message-ID: <20130319011754.GU6369@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
 <20130309003221.GE23616@dastard>
 <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
 <20130311001650.GB20565@dastard>
 <CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
 <20130312023658.GH21651@dastard>
 <CANN689Hu4S6hQaZ0tytNuToCpwtdJmyisyqyrDrNK+buJXTsKA@mail.gmail.com>
 <20130313032334.GU21651@dastard>
 <1363226451.25976.170.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363226451.25976.170.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 10:00:51PM -0400, Peter Hurley wrote:
> On Wed, 2013-03-13 at 14:23 +1100, Dave Chinner wrote:
> > We don't care about the ordering between multiple concurrent
> > metadata modifications - what matters is whether the ongoing data IO
> > around them is ordered correctly.
> 
> Dave,
> 
> The point that Michel is making is that there never was any ordering
> guarantee by rwsem. It's an illusion.

Weasel words.

> The reason is simple: to even get to the lock the cpu has to be
> sleep-able. So for every submission that you believe is ordered, is by
> its very nature __not ordered__, even when used by kernel code.
>
> Why? Because any thread on its way to claim the lock (reader or writer)
> could be pre-empted for some other task, thus delaying the submission of
> whatever i/o you believed to be ordered.

You think I don't know this?  You're arguing fine grained, low level
behaviour between tasks is unpredictable. I get that. I understand
that. But I'm not arguing about fine-grained, low level, microsecond
semantics of the locking order....

What you (and Michael) appear to be failing to see is what happens
on a macro level when you have read locks being held for periods
measured in *seconds* (e.g. direct IO gets queued behind a few
thousand other IOs in the elevator waiting for a request slot),
and the subsequent effect of inserting an operation that requires a
write lock into that IO stream.

IOWs, it simply doesn't matter if there's a micro-level race between
the write lock and a couple of the readers. That's the level you
guys are arguing at but it simply does not matter in the cases I'm
describing. I'm talking about high level serialisation behaviours
that might take of *seconds* to play out and the ordering behaviours
observed at that scale.

That is, I don't care if a couple of threads out of a few thousand
race with the write lock over few tens to hundreds of microseconds,
but I most definitely care if a few thousand IOs issued seconds
after the write lock is queued jump over the write lock. That is a
gross behavioural change at the macro-level.....

> So just to reiterate: there is no 'queue' and no 'barrier'. The
> guarantees that rwsem makes are;
> 1. Multiple readers can own the lock.
> 2. Only a single writer can own the lock.
> 3. Readers will not starve writers.

You've conveniently ignored the fact that the current implementation
also provides following guarantee:

4. new readers will block behind existing writers

And that's the behaviour we currently depend on, whether you like it
or not.

> Where lock policy can have a significant impact is on performance. But
> predicting that impact is difficult -- it's better just to measure.

Predicting the impact in this case is trivial - it's obvious that
ordering of operations will change and break high level assumptions
that userspace currently makes about various IO operations on XFS
filesystems

> It's not my intention to convince you (or anyone else) that there should
> only be One True Rwsem, because I don't believe that. But I didn't want
> the impression to persist that rwsem does anything more than implement a
> fair reader/writer semaphore.

I'm sorry, but redefining "fair" to suit your own needs doesn't
convince me of anything. rwsem behaviour has been unchanged for at
least 10 years and hence the current implementation defines what is
"fair", not what you say is fair....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
