Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaEKQqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 12:46:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59525 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757349AbaEKQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 12:46:12 -0400
Date: Sun, 11 May 2014 12:46:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of
 runtime-suspended devices
In-Reply-To: <1599191.L8hnSpOETp@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405111213240.22680-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Rafael J. Wysocki wrote:

> On Thursday, May 08, 2014 09:52:18 PM Alan Stern wrote:
> > On Thu, 8 May 2014, Rafael J. Wysocki wrote:
> > 
> > > Well, no.
> > > 
> > > The reason why that doesn't work is because ->prepare() callbacks are
> > > executed in the reverse order, so the perent's ones will be run before
> > > the ->prepare() of the children.  Thus if ->prepare() sets the flag
> > > with the expectation that ->suspend() (and the subsequent callbacks)
> > > won't be executed, that expectation may not be met actually.
> > 
> > That's true also if the flag gets set in ->suspend(), isn't it?  A
> > driver may set direct_resume in its ->suspend() callback, expecting
> > that the subsequent callbacks won't be executed.  But if a descendant
> > hasn't also set its flag then the callbacks _will_ be executed.
> 
> No, that's not possible with the current patch, because __device_suspend() is
> executed for descendants first and then for ancestors and it clears
> direct_suspend for the parents of devices that don't have it set.  This means
> that the ancestor's ->suspend() will see the flag clear if it is unset for
> any of its descendants.
> 
> IOW, the only case in which the ancestor's ->suspend() sees the flag set is
> when it has been set for all of its descendants.  Thus, if it leaves the
> flag set, the late/early and noirq callbacks won't be executed for it.
> 
> Now, there is a reason for concern in that, because ->suspend() may set the
> flag as a result of an error and that may lead to unexpected consequences.

Ah, my mistake; I should have read the patch more carefully.  I didn't
realize that your plan was for subsystems/drivers to set the flag
during ->prepare() and then clear it (or leave it set) during
->suspend().

> Then the parent will have direct_resume unset.  That is not a concern.
> The only concern to me is possible errors in ->suspend() setting the
> flag when it shouldn't.

So now one question is: Why would a subsystem or driver want to clear a
flag that it had set earlier?  I can't think of any good reasons.  The
only obvious possibility would be if the wakeup requirements got
changed between ->prepare() and ->suspend(), but that should never
happen because wakeup settings are changed by userspace and userspace
will be frozen.

Another question is: Does a subsystem or driver need to know if the
original flag setting couldn't be honored?  Again, I don't think it is 
necessary to call ->suspend() just for this reason.  More precisely, I 
think it will be good enough to call ->suspend() when the flag is clear 
(either because a descendant device didn't set its flag or because the 
device is no longer in runtime suspend); if the flag is set then there 
is no reason to call ->suspend().  The subsystem can assume that 
->suspend() won't be called; then if it does get called, the subsystem 
will realize something has changed.

Thus, a suitable algorithm now appears to be:

	Have subsystems/drivers set the flag during ->prepare().  They
	don't even have to check if the device is runtime-suspended;
	if it isn't then the PM core will turn off the flag later.

	In __device_suspend(), before invoking the ->supend() callback, 
	check the flag.  If it is still set and if the device is
	runtime-suspended (a barrier may be necessary here), skip 
	->suspend() and the following callbacks.  Otherwise clear the
	parent's flag and proceed as usual.

> > Several of these questions are a lot easier to answer if the flag gets 
> > set during ->prepare() rather than ->suspend().
> 
> I agree with that, but I have one concern about this approach.  Namely,
> in that case the PM core has to use pm_runtime_resume() or equivalent to
> resume devices with the flag set during the device resume stage.  Now,
> in the next step we may want to leave certain devices suspended at that
> point and the PM core has no way to tell which ones.  Also subsystems
> don't really have a chance to tell it about that (they would need to
> know in advance during ->prepare(), which is kind of unrealistic, or
> perhaps it isn't).
> 
> However, if ->resume() is called for devices with the flag set, like in
> my most recent patch, the subsystem may decide not to resume the device
> if it knows enough about it.
> 
> This pretty much is my only concern here, so I'm open to ideas how to deal
> with leaving devices suspended (if possible) during the device resume stage. :-)

This is a good question.  I'm not sure of the best answer at the 
moment.

> For one, postponing the resume to ->complete() is an option, but it will have
> to be done with care, because the ->complete() callbacks are executed
> sequentially, so calling pm_runtime_resume() from there is rather out of the
> question.

Calling pm_request_resume() would be okay, though.

There's another aspect to this we need to consider: hibernation.  I'm
quite sure we don't want to come out of hibernation thinking that
devices are still in their runtime-suspended states.  Skipping the
callbacks for freeze and thaw would be all right in principle, and
maybe even for poweroff, but not for restore.  And of course, during
the restore stages, the last thing subsystems and drivers will remember
happening is freeze -- which might mean you shouldn't skip the freeze
callbacks either.

Alan Stern

