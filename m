Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3LZQFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:05:23 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:39164 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3LZQFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:05:21 -0500
Date: Thu, 26 Dec 2013 11:05:17 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes
 for v3.13-rc5)
Message-ID: <20131226160517.GB16483@htj.dyndns.org>
References: <1667032.A7Knz5cBng@vostro.rjw.lan>
 <Pine.LNX.4.44L0.1312252211550.15064-100000@netrider.rowland.org>
 <20131226041856.GA16483@htj.dyndns.org>
 <1963765.T2MGFJrVrL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1963765.T2MGFJrVrL@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Thu, Dec 26, 2013 at 04:05:53PM +0100, Rafael J. Wysocki wrote:
> First, there is a removal-vs-resume deadlock which technically is related to
> the freezing, but it is not entirely clear to me that using a more fine grained
> mechanism instead of the freezing will actually help here.  It may turn out to
> be necessary to defer the removal until the resume is complete anyway.
> 
> Second, there is the problem with the freezer being a huge sledgehammer which
> sometimes is used too eagerly and without enough understanding.  I agree that
> that is a problem and probably the best way to address it would be to make
> people use more specific things instead of the freezer for workqueues/kthreads.

I don't think the two points are separate.  There's no reason for
anything above device drivers (themselves or whatever midlayer
implementing command queue) to be participating in the freezer and
this deadlock occurred only because writeback is freezable for no good
reason that I can see.  If we make "freezing" specific to the places
where the actual PM operations are necessary, these lockups cannot
happen, or rather, if a deadlock happens, the blame would likely be
clearly on the device driver or its subsystem implementation.

> Well, we agreed long ago that making the freezer any more "complete" (in
> terms of stopping more things) would be harmful, but then we thought that
> it was not necessary to rework the subsystems using it already.  Perhaps
> that was a mistake.

Hmmm... it doesn't look like we have too many freezable users in the
kernel at this point.  Hopefully doing a sweep through what's
remaining wouldn't be too hard?

> I actually think that khubd is somewhat analogous to the PM workqueue, so
> it needs to be stopped before we start calling suspend callbacks or we'd
> have to deal with a lot more complexity than really necessary.  There may
> be more things like that, but that's hard to tell without reviewing all
> users of freezable kthreads and workqueues and analysing them all.  So I
> guess that's the next step if we want to go into that direction.

I see.  I'm kinda curious how that jives with runtime PM.  One thing
which bothers me about the freezer is that it's essentially a separate
entry point for suspend/resume implementation, and not a particularly
well designed one at that.  Things which depend on freezer for PM ops
would need completely separate paths for runtime PM.  They probably
need some deviations anyway but freezer would push it unnecessarily.

> Well, it looks like we don't really know why things are done the way they
> are done at least in some cases, so in my personal view it would be good to
> go through all of the kernel freezer users just for this reason alone.  We
> can't really say which of them are legitimate without that and how difficult
> it would be for them to switch over to using something more fine grained than
> the freezer.

I'm a bit worried about things which may not be explicit.
ie. something which is broken but sorta working because things like
writeback and jbd are frozen.  I think I worry about that because I
remember one argument for kernel freezer from way way back, that it's
too hard to implement proper suspend/resume for all drivers and by
freezing most kthreads things should mostly work, which sounded pretty
crazy to me even back then.  Hopefully, we don't have much left
depending on such magic.

> I'm not worried about workqueues, becuase I see no reason why they can't use
> workqueue_set_max_active() the way we discussed (after the two patches of yours
> that haven't been applied yet), but kthreads are a somewhat different matter.

Well, converting kthreads to workqueues are pretty easy and usually
beneficial anyway, especially given that people often get things not
completely right when mixing kthread_should_stop() and freezing
condition checks (it can be surprisingly tricky and likely to work
most of the time even when slightly broken) and workqueue is a lot
easier to get right on that respect.

Thanks.

-- 
tejun
