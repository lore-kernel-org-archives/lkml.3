Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaBWXpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:45:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56638 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751545AbaBWXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:45:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Mon, 24 Feb 2014 01:00:14 +0100
Message-ID: <6679559.WlyTU99iuj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1402201113070.888-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402201113070.888-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 20, 2014 12:03:37 PM Alan Stern wrote:
> On Thu, 20 Feb 2014, Rafael J. Wysocki wrote:
> 
> > On Wednesday, February 19, 2014 12:01:20 PM Alan Stern wrote:
> > > On Mon, 17 Feb 2014, Rafael J. Wysocki wrote:
> > > 
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
> > > > resume all runtime-suspended devices during system suspend, mostly
> > > > because those devices may need to be reprogrammed due to different
> > > > wakeup settings for system sleep and for runtime PM.  However, at
> > > > least in some cases, that isn't really necessary, because the wakeup
> > > > settings may not be really different.
> > > > 
> > > > The idea here is that subsystems should know whether or not it is
> > > > necessary to reprogram a given device during system suspend and they
> > > > should be able to tell the PM core about that.  For this reason,
> > > > modify the PM core so that if the .prepare() callback returns a
> > > > positive value for certain device, the core will set a new
> > > > power.fast_suspend flag for it.  Then, if that flag is set, the core
> > > > will skip all of the subsequent suspend callbacks for that device.
> > > > It also will skip all of the system resume callbacks for the device
> > > > during the subsequent system resume and pm_request_resume() will be
> > > > executed to trigger a runtime PM resume of the device after the
> > > > system device resume sequence has been finished.
> > 
> > I was worried that you wouldn't comment at all. ;-)
> 
> Things have been pretty busy here for the last few weeks...
> 
> > > Does the PM core really need to get involved in this?
> > 
> > Yes, it does, in my opinion, and the reason is because it may be necessary
> > to resume parents in order to reprogram their children and the parents and
> > the children may be on different bus types.
> 
> Hmmm.  Reprogramming the children could refer to two different things:
> 
>    (1)	Altering the child's wakeup settings before suspending it, or
> 
>    (2)	Doing I/O to the child after resuming it.
> 
> (1) is something we already have to deal with.  Generally, the child's
> subsystem or driver would simply call pm_runtime_get_sync, or something
> of the sort.

Yes, it could.  Except that that won't work for parents with power.ignore_children
set.

Also, it may not do that today and I'd like to introduce a mechanism by which
that optimizatiom may be enabled by subsystems/drivers when ready.

So for example today there is no guarantee that each device will be resumed
as appropriate by whoever handles its children when necessary, because that
code may expect the device to be operational when it is running (precisely
because we used to resume that device in .prepare()).

> The parent would then be in the RPM_ACTIVE state when its
> ->resume callback was invoked, so the rest of this discussion would not 
> apply.
> 
> (2) is more difficult.  It is the reason why, in the original runtime 
> PM documentation, we suggested that system resume should wake up _all_ 
> devices, including those that were in runtime suspend before the system 
> sleep.

In my view there really is no substantial difference between (1) and (2).
After all, changing the wakeup settings of a device's children may involve
doing I/O to them.

> If the child's subsystem or driver knows to call pm_runtime_get_sync
> before starting the I/O, then it should work out okay.  Trouble arises
> when the subsystem/driver _assumes_ that the parent is active.

Precisely

> This sounds like the sort of thing that could be fixed on a case-by-case
> basis: Simply remove that assumption from the child's subsystem/driver.  
> But I guess you want to set up a more structured solution.

Yes.  In particular, I'd like the "child" subsystem to be able to let the
core know that it is fine to leave the parent suspended.

> Note that this patch set really addresses two distinct issues: Skipping 
> the ->suspend callbacks if the device is already runtime suspended, and 
> skipping the ->resume callbacks.  In principle these are independent 
> decisions.

Yes, they are.

That said the patchset doesn't really do both.  It only really is about
skipping the ->suspend callbacks if possible, but the *consequence* of that
is that *system* resume ->resume callbacks cannot be used to resume the
device any more in general.  That's because ->resume_early may try to
reverse the ->suspend_late's actions and so on, so if ->suspend_late hasn't
run, it would be a bug to run ->resume_early for that device.

> > > Can't the subsystem do the right thing on its own?
> > 
> > No, I don't think so.
> 
> Well, certainly the subsystem could avoid doing anything in the
> ->suspend callbacks, by returning immediately.

As I said above, today there's no guaranee that things would work out correctly
in that case.

> But skipping over the ->resume callbacks is more problematic, because of case
> (2) above.
> 
> > > In the USB subsystem, the .suspend routine checks the required wakeup
> > > settings.  If they are different for runtime suspend and system
> > > suspend, and if the device is runtime suspended, then we call
> > > pm_runtime_resume.  After that, if the device is still in runtime
> > > suspend then we return immediately.
> > > 
> > > Of course, this addresses only the suspend side of the issue.  Skipping 
> > > the resume callbacks is a separate matter, and the USB subsystem 
> > > doesn't try to do it.  Still, I don't see any reason why we couldn't 
> > > take care of that as well.
> > 
> > What about USB controllers that are PCI devices?
> 
> The description above applies to USB devices, not USB controllers.  
> For PCI-based USB controllers, we currently assume that the controller
> is RPM_ACTIVE when the ->suspend callback is called.
> 
> Of course, that assumption could be removed easily enough.

Well, in my view, in general, any mechanism that crosses the subsystem
boundary pretty much requires the core to be involved, this way or another.

> > > I have run across a similar issue.  It's a general problem that a
> > > device may try to remain in runtime suspend during a system resume, but
> > > a descendant of the device may need to perform I/O as part of its own
> > > resume routine.  A natural solution would be to use the regular runtime
> > > PM facilities to wake up the device.  But since the PM work queue is
> > > frozen, we can't rely on pm_runtime_get or the equivalent.  I'm not
> > > sure what the best solution will be.
> > 
> > We can rely on pm_runtime_get_sync(), though, which would be the right thing to
> > use here.
> > 
> > However, given that the parent's .prepare() has run already, I'm not sure
> > if we want runtime PM to be involved at all.
> 
> This is a decision we have to make.  At the start of a system resume, 
> we expect that the device is in a low-power state.  After the ->resume 
> callback returns, there is a choice.  The device could be back to full 
> power and marked RPM_ACTIVE.  Or it could remain in low power and be 
> marked RPM_SUSPENDED.  In the second alternative, it seems that runtime 
> PM is unavoidably involved.

I agree.  However, as stated above, once we've decided not to run, for
example, the ->suspend callback, we also should not attempt to run
->resume for the same device, because the latter may expect that the former
has run.  That is an additional complication that needs to be taken into
account in my opinion.

Of course, if the decision is left to the subsystem, then it will know
that ->suspend has returned immediately and it will make ->resume return
immediately too, but that sounds like a thing that will be readily duplicated
by multiple subsystems just because we don't want the core to be involved.
Also there's no way to know anything about the children then.

> Are you primarily concerned about performing runtime PM actions before 
> calling the ->complete callback?

No, I'm not.

> I don't think that will cause any difficulties, but we could warn about it in
> the documentation.
> 
> > > > @@ -1310,6 +1317,9 @@ static int __device_suspend(struct devic
> > > >  	dpm_watchdog_set(&wd, dev);
> > > >  	device_lock(dev);
> > > >  
> > > > +	if (dev->power.fast_suspend)
> > > > +		goto End;
> > > > +
> > > 
> > > What happens if dev->power.fast_suspend gets set following the .prepare
> > > callback, but then before __device_suspend runs, the device gets
> > > runtime resumed?
> > > 
> > > It looks like rpm_resume needs to clear the new flag.
> > 
> > I thought about that and came to the conclusion that that wasn't necessary.
> > 
> > There simply is no reason for devices with power.fast_suspend set to be
> > runtime-resumed after (or even during) dpm_prepare() other than while
> > resuming their children, in which case power.fast_suspend is going to be
> > cleared for the children and then for the parents too.
> > 
> > That *is* a little fragile, though.
> 
> It's possible for the device to get a wakeup request.  If this happens, 
> it should cause the entire system sleep to be aborted, but depending on 
> that is also a little fragile.
> 
> There's also the possibility of doing I/O to the child while the parent 
> is in runtime suspend (with ignore_children set).  These situations 
> tend to be idiosyncratic; it's hard to say anything about them in 
> general.

I agree.  For this reason, I think that the core has no choice but to treat
power.ignore_children set as "well, that device may need to be operational
going forward".

> > > > @@ -1358,9 +1368,14 @@ static int __device_suspend(struct devic
> > > >   End:
> > > >  	if (!error) {
> > > >  		dev->power.is_suspended = true;
> > > > -		if (dev->power.wakeup_path
> > > > -		    && dev->parent && !dev->parent->power.ignore_children)
> > > > -			dev->parent->power.wakeup_path = true;
> > > > +		if (dev->parent) {
> > > > +			if (!dev->parent->power.ignore_children
> > > > +			    && dev->power.wakeup_path)
> > > > +				dev->parent->power.wakeup_path = true;
> > > > +
> > > > +			if (!dev->power.fast_suspend)
> > > > +				dev->parent->power.fast_suspend = false;
> > > > +		}
> > > 
> > > On SMP systems with async suspend, this isn't safe.  Two threads should 
> > > not be allowed to write to bitfields in the same structure at the same 
> > > time.
> > 
> > Do I understand correctly that your concern is about suspending two
> > children of the same parent in parallel and one of them modifying
> > power.wakeup_path and the other modifying power.fast_suspend at the
> > same time?
> 
> Yes, that's what I meant.
> 
> > If so, that modification can be done under the parent's power.lock.
> 
> That would avoid the problem.
> 
> Overall, I'm not convinced about the need for the fast_suspend 
> mechanism.  I'm quite certain that the PM core doesn't need to get 
> involved in the decision about skipping ->suspend callbacks.

I obviously disagree. :-)

Otherwise, I wouldn't have bothered with posting this patchset ...

> The question of skipping ->resume callbacks is more complex.  In the
> end, it comes down to a question of leaving the device in runtime
> suspend during system resume -- whether this is happens because the PM
> core skips the ->resume callback or because the callback returns
> immediately is unimportant.

Well, not really in my opinion ...

> So I think what we really need to do is discuss this last question more
> fully.  Case (2) can be tricky, and we may find that the device's
> subsystem doesn't have enough information to predict what the
> children's subsystems will do.

Precisely. :-)  And that's why I'd like to give the children's subsystem
a way to give the parent's one a clue - with some help from the core.

Rafael

