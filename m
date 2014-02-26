Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaBZV3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:29:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55128 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751929AbaBZV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:29:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Wed, 26 Feb 2014 22:44:18 +0100
Message-ID: <3594089.JH6xlacmJ3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1402261103190.1308-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402261103190.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 11:49:05 AM Alan Stern wrote:
> On Wed, 26 Feb 2014, Rafael J. Wysocki wrote:
> 
> > > I admit, there most likely _are_ devices that would get into trouble if
> > > the question ever did arise.
> > 
> > Well, I kind of put that to a test by posting these two patches:
> > 
> > https://patchwork.kernel.org/patch/3705261/
> > https://patchwork.kernel.org/patch/3705271/
> > 
> > We'll see if they lead to any regressions, but I'm going to work on top of
> > them going forward anyway.
> 
> And here I had the impression that you wanted to avoid any regressions
> from those patches...

In the meantime I realized that regressions from them are quite unlikely and
if they happen, they will be limited to corner cases.

The reason is (as you kind of noted below) that (assuming that runtime PM is
supported for both the child and the parent) if the child is to be accessed
in ->suspend, for example, it should be runtime-resumed beforehand and that
will cause the parent to be runtime-resumed as well (the power.ignore_children
devices are special-cased explicitly).

> > Actually, on top of the two patches mentioned above (and for devices
> > without power.ignore_children set) the question reduces to whether or not
> > (i) the device itself is runtime-suspended when its .suspend() callback is
> > running and (ii) its power state is such that it can remain suspended.
> > If both (i) and (ii) are met, the device may be left suspended safely,
> > because if any of its children had depended on it, they would have resumed
> > it already.
> 
> Does this mean you changed your mind?  In an earlier email, you wrote:

I've just realized that if the pm_runtime_resume() is moved from ->prepare
to ->suspend, then it is done *after* the ->suspend callbacks of the
children have been executed, which means that if the parent is runtime-suspended
at this point, the children are runtime-suspended either.  Moreover, they
can't be runtime-resumed in ->suspend_late, because that is executed with
runtime PM disabled, so it is reasonalby safe to assume that they won't need
the parent going forward - until ->resume.

> > >     (b) It's okay for the device's parent to be in runtime suspend
> > >       when the device's ->suspend callbacks are invoked.
> > > 
> > > I included this just to be thorough.  In fact, I expect (b) to be true 
> > > for pretty much every device already.
> > 
> > I don't quite understand this.  What if the parent is a bridge and the
> > child's ->suspend tries to access the child's registers?  That surely won't
> > work if the parent is in a low-power state at that point.
> 
> So the answer is that if the bridge is suspended, then the child must
> be suspended too and hence the child's ->suspend should _expect_
> problems if it tries to access the child's registers.

Agreed.

> (By the way, during this discussion I have had a tendency to mix up two 
> related concepts:
> 
> 	The device's ->suspend routine expects the _parent_ not to be
> 	suspended;
> 
> 	The device's ->suspend routine expects the _device_ not to be
> 	suspended.
> 
> Obviously the second implies the first.  But once the second has been
> fixed, the first should never cause any trouble.)
> 
> > Still, I think that something like power.fast_suspend is needed to indicate
> > that .suspend_late(), .suspend_noirq(), .resume_noirq() and .resume_early()
> > should be skipped for it (in my opinion the core may very well skip them then)
> > and so that .resume() knows how to handle the device.
> 
> I don't follow.  Why would you skip these routines without also
> skipping .suspend and .resume?

Because .suspend will set the flag and then it would be reasonable to call .resume,
for symmetry and to let it decide what to do (e.g. call pm_runtime_resume(dev) or
do something else, depending on the subsystem).

> > I generally agree that whether or not a device may be left suspended during and
> > after system resume and whether or not a device may be left suspended during
> > system suspend are two different questions.  However, when it *is* left
> > suspended during system suspend, then that implies certain way of handling it
> > during the subsequent system resume.  After which it still may not be left
> > suspended.
> 
> I would prefer to say: "However, when the system suspend callbacks
> _are_ skipped, that implies the corresponding system resume callbacks
> must also be skipped and hence the device must remain suspended".  Is
> this consistent with what you meant?

Yes, it is.

> As I see it, the fast_suspend implementation could lead to regressions
> in two ways:
> 
> 	The child's ->suspend doesn't expect the parent to be 
> 	suspended.
> 
> 	The child's ->resume doesn't expect the parent to be
> 	suspended.
> 
> We agree now that the first won't be a problem, because it would imply
> the child is suspended too.

Yes.

> However, the second may indeed be a problem.  I don't know how you
> intend to handle it.  Apply the patch, like you did for ACPI and PCI
> above, and then see what happens?

For starters, I'd just make the parent's ->resume call pm_runtime_resume(dev).
That will make the parent be ready before the child's ->resume is called.
And then it may be optimized further going forward, possibly by replacing
the pm_runtime_resume() with pm_request_resume() for some devices and by
leaving some devices in RPM_SUSPENDED.

> A simple solution is to use fast_suspend only for devices that have no
> children.  But that would not be optimal.
> 
> Another possibility is always to call pm_runtime_resume(dev->parent)
> before invoking dev's ->resume callback.  But that might not solve the
> entire problem (it wouldn't help dev's ->resume_early callback, for
> instance) and it also might be sub-optimal.

The child's ->resume_early may be a problem indeed (or its ->resume_noirq
for that matter).

Well, if power.fast_suspend set guarantees that ->suspend_late, ->suspend_noirq,
->resume_noirq, and ->resume_early will be skipped for a device, then we may
restrict setting it for devices whose children have it set (or that have no
children).  Initially, that will be equivalent to setting it for leaf devices
only, but it might be extended over time in a natural way.

Rafael

