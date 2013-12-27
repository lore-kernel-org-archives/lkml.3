Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3L0COw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 21:14:52 -0500
Received: from netrider.rowland.org ([192.131.102.5]:34749 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754011Ab3L0COu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 21:14:50 -0500
Date: Thu, 26 Dec 2013 21:14:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes
 for v3.13-rc5)
In-Reply-To: <20131226190120.GC16483@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1312262048540.29101-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 26 Dec 2013, Tejun Heo wrote:

> > Maybe it's the other way around: The separate paths are necessary, and 
> > the freezer _simplifies_ the system sleep ops.
> 
> Again, the point is it's too big a tool given the problem with history
> of abuse.  It sure is "convenient" to have tools at that level for
> that particular user - not because the task at hand fits such solution
> but because a lot more is being paid elsewhere.  It just is out of
> proportion and isn't a good design in larger sense.

I can't disagree with this.  But the design may well be perfectly
adequate for some use cases.  Given a workqueue or kthread which should
not operate during system sleep, we have to:

	Tell the wq/thread to stop running because a sleep is about
	to start, and

	Provide a function the wq/thread can call to put itself on 
	hold for the duration of the sleep.

The freezer does both these things pretty efficiently.  Problems may
arise, though, because of workqueues or kthreads which need to continue 
some but not all of their operations, or which need to be put on hold 
in a specific sequence with respect to other threads.  The freezer is 
not suited for such things.

(There is a similar problem when userspace gets frozen.  Tasks 
implementing FUSE filesystems, in particular, have a deplorable 
tendency to get frozen at inconvenient times.)

> As for autopm vs. system pm, there sure are necessary differences
> between the two but they also can share a lot.  At least, it looks
> that way from libata side.  I really don't think having two separate
> paradigms in implementing PM is a good idea even if the two paths have
> to deviate in significant ways.

Put it the other way around: Implementing two significantly different
kinds of PM is okay because the two paths can share a lot.

Really.  Although system PM and runtime PM may appear similar from some
points of view, underneath they are quite different in several
important ways.  Most of what they have in common is the idea of 
putting devices into or out of low-power states.  But when and how to 
do these things...

> > Taking khubd as an example, I have to agree that converting it to a
> > workqueue would be a big simplification overall.  And yet there are
> > some things khubd does which are (as far as I know) rather difficult to
> > accomplish with workqueues.  One example in drivers/usb/core/hub.c:  
> > kick_khubd() calls usb_autopm_get_interface_no_resume() if and only if
> > it added the hub to the event list (and it does so before releasing the
> > list's lock).  How can you do that with a workqueue?
> 
> Do the same thing and just replace wake_up() with queue_work()?

So you're suggesting changing the kthread to a workqueue thread, but
keeping the existing list of scheduled events instead of relying on the
workqueue's own queue of work items?  What's the advantage?  Making
such a change wouldn't simplify anything.

Alan Stern

