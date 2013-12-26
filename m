Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3LZXgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 18:36:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61325 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753891Ab3LZXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 18:36:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes for v3.13-rc5)
Date: Fri, 27 Dec 2013 00:49:47 +0100
Message-ID: <4783540.1PxNCSxdqk@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131226160517.GB16483@htj.dyndns.org>
References: <1667032.A7Knz5cBng@vostro.rjw.lan> <1963765.T2MGFJrVrL@vostro.rjw.lan> <20131226160517.GB16483@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 26, 2013 11:05:17 AM Tejun Heo wrote:
> Hello, Rafael.

Hi Tejun,

> On Thu, Dec 26, 2013 at 04:05:53PM +0100, Rafael J. Wysocki wrote:
> > First, there is a removal-vs-resume deadlock which technically is related to
> > the freezing, but it is not entirely clear to me that using a more fine grained
> > mechanism instead of the freezing will actually help here.  It may turn out to
> > be necessary to defer the removal until the resume is complete anyway.
> > 
> > Second, there is the problem with the freezer being a huge sledgehammer which
> > sometimes is used too eagerly and without enough understanding.  I agree that
> > that is a problem and probably the best way to address it would be to make
> > people use more specific things instead of the freezer for workqueues/kthreads.
> 
> I don't think the two points are separate.  There's no reason for
> anything above device drivers (themselves or whatever midlayer
> implementing command queue) to be participating in the freezer and
> this deadlock occurred only because writeback is freezable for no good
> reason that I can see.  If we make "freezing" specific to the places
> where the actual PM operations are necessary, these lockups cannot
> happen, or rather, if a deadlock happens, the blame would likely be
> clearly on the device driver or its subsystem implementation.

The rule is that system suspend (or hibernation) can happen at any time and
certain things that may be running at that point need to be stopped, this way
or another.  The stopping may be done by individual drivers (through PM
callbacks) or at a higher level (e.g. through the freezer) and what makes more
sense depends on the specific case in my opinion.

Runtime PM has a mechanism by which you can say "do not run PM callbacks for
that device now" which makes things quite a bit different.

> > Well, we agreed long ago that making the freezer any more "complete" (in
> > terms of stopping more things) would be harmful, but then we thought that
> > it was not necessary to rework the subsystems using it already.  Perhaps
> > that was a mistake.
> 
> Hmmm... it doesn't look like we have too many freezable users in the
> kernel at this point.  Hopefully doing a sweep through what's
> remaining wouldn't be too hard?
> 
> > I actually think that khubd is somewhat analogous to the PM workqueue, so
> > it needs to be stopped before we start calling suspend callbacks or we'd
> > have to deal with a lot more complexity than really necessary.  There may
> > be more things like that, but that's hard to tell without reviewing all
> > users of freezable kthreads and workqueues and analysing them all.  So I
> > guess that's the next step if we want to go into that direction.
> 
> I see.  I'm kinda curious how that jives with runtime PM.  One thing
> which bothers me about the freezer is that it's essentially a separate
> entry point for suspend/resume implementation, and not a particularly
> well designed one at that.  Things which depend on freezer for PM ops
> would need completely separate paths for runtime PM.  They probably
> need some deviations anyway but freezer would push it unnecessarily.

As I said above, using the freezer is just one of possible ways to stop things
that need to be stopped.  Whoever choses the freezer for that should better
know why exactly or it most likely is a bug.

> > Well, it looks like we don't really know why things are done the way they
> > are done at least in some cases, so in my personal view it would be good to
> > go through all of the kernel freezer users just for this reason alone.  We
> > can't really say which of them are legitimate without that and how difficult
> > it would be for them to switch over to using something more fine grained than
> > the freezer.
> 
> I'm a bit worried about things which may not be explicit.
> ie. something which is broken but sorta working because things like
> writeback and jbd are frozen.  I think I worry about that because I
> remember one argument for kernel freezer from way way back, that it's
> too hard to implement proper suspend/resume for all drivers and by
> freezing most kthreads things should mostly work, which sounded pretty
> crazy to me even back then.  Hopefully, we don't have much left
> depending on such magic.

I *hope* we don't.  In any case, we certainly need to know *why* things are
done in a specific way, whatever that way is.  In this particular case, if
some kthread/workqueue is frozen over suspend/resume, we should know why
exactly (i.e. what problem the freezing is supposed to address) or all that
becomes voodoo programming.

> > I'm not worried about workqueues, becuase I see no reason why they can't use
> > workqueue_set_max_active() the way we discussed (after the two patches of yours
> > that haven't been applied yet), but kthreads are a somewhat different matter.
> 
> Well, converting kthreads to workqueues are pretty easy and usually
> beneficial anyway, especially given that people often get things not
> completely right when mixing kthread_should_stop() and freezing
> condition checks (it can be surprisingly tricky and likely to work
> most of the time even when slightly broken) and workqueue is a lot
> easier to get right on that respect.

Well, agreed. :-)

Thanks,
Rafael

