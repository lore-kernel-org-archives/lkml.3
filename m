Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3LZSmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:42:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:56980 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752947Ab3LZSma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:42:30 -0500
Date: Thu, 26 Dec 2013 13:42:29 -0500 (EST)
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
In-Reply-To: <20131226160517.GB16483@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1312261326540.24521-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Tejun Heo wrote:

> Hello, Rafael.
> 
> On Thu, Dec 26, 2013 at 04:05:53PM +0100, Rafael J. Wysocki wrote:
> > First, there is a removal-vs-resume deadlock which technically is related to
> > the freezing, but it is not entirely clear to me that using a more fine grained
> > mechanism instead of the freezing will actually help here.  It may turn out to
> > be necessary to defer the removal until the resume is complete anyway.

In fact, some places may be using the freezer as a convenient way to 
implement just such a deferral.

> > Second, there is the problem with the freezer being a huge sledgehammer which
> > sometimes is used too eagerly and without enough understanding.  I agree that
> > that is a problem and probably the best way to address it would be to make
> > people use more specific things instead of the freezer for workqueues/kthreads.
> 
> I don't think the two points are separate.  There's no reason for
> anything above device drivers (themselves or whatever midlayer
> implementing command queue) to be participating in the freezer and
> this deadlock occurred only because writeback is freezable for no good
> reason that I can see.

I don't know why writeback was made freezable -- but that would be a
reasonable way to avoid changing on-disk data during hibernation.

>  If we make "freezing" specific to the places
> where the actual PM operations are necessary, these lockups cannot
> happen, or rather, if a deadlock happens, the blame would likely be
> clearly on the device driver or its subsystem implementation.

In the case of hibernation, it's not so simple.  We do need to perform 
I/O, in order to save the memory image.  But we also need to avoid 
unnecessary I/O, in order to keep the on-disk data consistent with the 
data in the memory image.  You probably can't accomplish this at the 
device driver or subsystem level.

> > I actually think that khubd is somewhat analogous to the PM workqueue, so
> > it needs to be stopped before we start calling suspend callbacks or we'd
> > have to deal with a lot more complexity than really necessary.  There may
> > be more things like that, but that's hard to tell without reviewing all
> > users of freezable kthreads and workqueues and analysing them all.  So I
> > guess that's the next step if we want to go into that direction.
> 
> I see.  I'm kinda curious how that jives with runtime PM.  One thing

There are some very significant differences between system sleep and 
runtime PM.  What is appropriate for one may not be appropriate for the 
other.  In particular, the freezer is not appropriate for runtime PM.

> which bothers me about the freezer is that it's essentially a separate
> entry point for suspend/resume implementation, and not a particularly
> well designed one at that.  Things which depend on freezer for PM ops
> would need completely separate paths for runtime PM.  They probably
> need some deviations anyway but freezer would push it unnecessarily.

Maybe it's the other way around: The separate paths are necessary, and 
the freezer _simplifies_ the system sleep ops.

> Well, converting kthreads to workqueues are pretty easy and usually
> beneficial anyway, especially given that people often get things not
> completely right when mixing kthread_should_stop() and freezing
> condition checks (it can be surprisingly tricky and likely to work
> most of the time even when slightly broken) and workqueue is a lot
> easier to get right on that respect.

Taking khubd as an example, I have to agree that converting it to a
workqueue would be a big simplification overall.  And yet there are
some things khubd does which are (as far as I know) rather difficult to
accomplish with workqueues.  One example in drivers/usb/core/hub.c:  
kick_khubd() calls usb_autopm_get_interface_no_resume() if and only if
it added the hub to the event list (and it does so before releasing the
list's lock).  How can you do that with a workqueue?

Alan Stern

