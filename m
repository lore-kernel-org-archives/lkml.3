Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3LZOwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:52:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50678 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753348Ab3LZOwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:52:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes for v3.13-rc5)
Date: Thu, 26 Dec 2013 16:05:53 +0100
Message-ID: <1963765.T2MGFJrVrL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131226041856.GA16483@htj.dyndns.org>
References: <1667032.A7Knz5cBng@vostro.rjw.lan> <Pine.LNX.4.44L0.1312252211550.15064-100000@netrider.rowland.org> <20131226041856.GA16483@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wednesday, December 25, 2013 11:18:56 PM Tejun Heo wrote:
> Hello, Alan.
> 
> On Wed, Dec 25, 2013 at 10:29:30PM -0500, Alan Stern wrote:
> > Thanks.  As I understand it (correct me if this is wrong), the problem
> > is that some subsystems wait for a freezable work queue or kthread to
> > carry out some job, and they do this as part of their resume pathway.  
> > Obviously this leads to deadlock.
> 
> It's not even that.  Freezer is too big and ends up causing deadlock
> which doesn't have much to do with resuming in itself.  The observed
> deadlock is between driver core resume and block layer removal paths.
> While the removal operation is kicked off by bus rescan during resume,
> it isn't an inherent part of libata resume.  ie. any block device
> removal can race against driver core freezer path.

It looks like we're talking about two problems somewhat related to each other.

First, there is a removal-vs-resume deadlock which technically is related to
the freezing, but it is not entirely clear to me that using a more fine grained
mechanism instead of the freezing will actually help here.  It may turn out to
be necessary to defer the removal until the resume is complete anyway.

Second, there is the problem with the freezer being a huge sledgehammer which
sometimes is used too eagerly and without enough understanding.  I agree that
that is a problem and probably the best way to address it would be to make
people use more specific things instead of the freezer for workqueues/kthreads.

> > But I don't see how swinging to the other extreme (i.e., making no
> > kernel threads or work queues freezable) really solves anything.  
> > Those things are freezable for real reasons; they do stuff that must
> > not happen while the system is in the middle of a sleep transition.
> 
> Kernel freezer has a lot of similarities with BKL.  I wouldn't call
> its eventual removal an extreme choice.
> 
> > Thus...  If a subsystem's resume pathway depends on something happening 
> > which must not happen during a sleep transition, then something is 
> > fundamentally broken.
> 
> Again, the deadlock doesn't have much to do with "a subsystem's resume
> pathway".  It's just freezer behaving as too big a lock used by too
> many subsystems which don't even need them eventually leading to messy
> deadlock.
> 
> > Perhaps the problem could be solved by a finer-grained approach.  For
> 
> Yeah, we seem to agree on the fact that it needs to be finer grained
> 
> > example, maybe some of these work queues or kthreads need to be frozen
> > only while the system is suspending, so they can safely be thawed when
> > the resume begins.  Would that fix the problem that began this 
> > discussion?
> 
> but not how to achieve it.  Kernel freezer's problem is that it's too
> big a mechanism for the given problem.  What we need is a mechanism to
> plug a handful (from what I've seen, there aren't too many legit
> users) of kthreads / workqueues, but what we have is a mechanism which
> is integral part of the whole task and workqueue machineries.
> 
> From the beginning and still, it's used as a voodoo mechanism which
> somehow makes the machine "mostly stopped" before performing PM
> operations.  That "mostly stopped" has never been well defined and
> always been a source of confusions causing people to just believe it's
> somehow all quiet and good without actually pondering what should
> happen - freezing of kthreads isn't atomic and doesn't have any
> inherent ordering among different kthreads / wqs && freezing kthread /
> wq doesn't mean the layer is actually empty or inactive.  irq / bh
> paths aren't blocked at all.

Well, we agreed long ago that making the freezer any more "complete" (in
terms of stopping more things) would be harmful, but then we thought that
it was not necessary to rework the subsystems using it already.  Perhaps
that was a mistake.

> A common misconception seems to be that by marking the workers in the
> upper layers freezable, somehow things are blocked from all the
> sources and thus the actual device, which needs to be plugged across
> suspend, is safe.  It's damaging because it'd work in many, if not
> most, cases but can never be made fully reliable.
> 
> > I know that in the case of khubd, we really do want it to remain frozen 
> > throughout the entire sleep transition.
> 
> I could be wrong but the only legitimate use cases of kernel freezer
> that I've seen are drivers using it as a fast way to implement
> suspend/resume callbacks and khubd seems to fall in that category.  I
> think it'd be actually healthier to implement it as a part of the
> usual PM notification / callback mechanism - a natural benefit would
> be helping consolidate system and runtime PM paths.  The conversion
> should be fairly simple and we definitely can add helpers and whatnot
> if we end up having to convert more than a handful.

I actually think that khubd is somewhat analogous to the PM workqueue, so
it needs to be stopped before we start calling suspend callbacks or we'd
have to deal with a lot more complexity than really necessary.  There may
be more things like that, but that's hard to tell without reviewing all
users of freezable kthreads and workqueues and analysing them all.  So I
guess that's the next step if we want to go into that direction.

> The danger is that because we've been plugging so many sources, we're
> likely to have lower level queues which aren't properly plugged.
> Those are broken but could have been working most of the time.
> Removing freezing from the upper layers could expose those issues, so
> the conversion as a whole may have some challanges in that department.
> It has been quite a while since I went through PM paths of many
> different drivers so I'd defer the judgement to Rafael.

Well, it looks like we don't really know why things are done the way they
are done at least in some cases, so in my personal view it would be good to
go through all of the kernel freezer users just for this reason alone.  We
can't really say which of them are legitimate without that and how difficult
it would be for them to switch over to using something more fine grained than
the freezer.

I'm not worried about workqueues, becuase I see no reason why they can't use
workqueue_set_max_active() the way we discussed (after the two patches of yours
that haven't been applied yet), but kthreads are a somewhat different matter.

Thanks,
Rafael

