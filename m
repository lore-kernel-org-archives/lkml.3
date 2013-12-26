Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3LZTBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:01:37 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:48010 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3LZTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:01:33 -0500
Date: Thu, 26 Dec 2013 14:01:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes
 for v3.13-rc5)
Message-ID: <20131226190120.GC16483@htj.dyndns.org>
References: <20131226160517.GB16483@htj.dyndns.org>
 <Pine.LNX.4.44L0.1312261326540.24521-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312261326540.24521-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 26, 2013 at 01:42:29PM -0500, Alan Stern wrote:
> In the case of hibernation, it's not so simple.  We do need to perform 
> I/O, in order to save the memory image.  But we also need to avoid 
> unnecessary I/O, in order to keep the on-disk data consistent with the 
> data in the memory image.  You probably can't accomplish this at the 
> device driver or subsystem level.

That was what I assumed too but Rafael tells me it has nothing to do
with hibernation.

> > which bothers me about the freezer is that it's essentially a separate
> > entry point for suspend/resume implementation, and not a particularly
> > well designed one at that.  Things which depend on freezer for PM ops
> > would need completely separate paths for runtime PM.  They probably
> > need some deviations anyway but freezer would push it unnecessarily.
> 
> Maybe it's the other way around: The separate paths are necessary, and 
> the freezer _simplifies_ the system sleep ops.

Again, the point is it's too big a tool given the problem with history
of abuse.  It sure is "convenient" to have tools at that level for
that particular user - not because the task at hand fits such solution
but because a lot more is being paid elsewhere.  It just is out of
proportion and isn't a good design in larger sense.

As for autopm vs. system pm, there sure are necessary differences
between the two but they also can share a lot.  At least, it looks
that way from libata side.  I really don't think having two separate
paradigms in implementing PM is a good idea even if the two paths have
to deviate in significant ways.

> Taking khubd as an example, I have to agree that converting it to a
> workqueue would be a big simplification overall.  And yet there are
> some things khubd does which are (as far as I know) rather difficult to
> accomplish with workqueues.  One example in drivers/usb/core/hub.c:  
> kick_khubd() calls usb_autopm_get_interface_no_resume() if and only if
> it added the hub to the event list (and it does so before releasing the
> list's lock).  How can you do that with a workqueue?

Do the same thing and just replace wake_up() with queue_work()?

Thanks.

-- 
tejun
