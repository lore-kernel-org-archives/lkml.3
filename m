Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaBXXw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:52:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64167 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753326AbaBXXww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:52:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of suspended devices
Date: Tue, 25 Feb 2014 01:07:49 +0100
Message-ID: <10187724.x3fLnu1cYV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1402241124350.1427-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402241124350.1427-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 02:36:02 PM Alan Stern wrote:
> On Mon, 24 Feb 2014, Rafael J. Wysocki wrote:
> 
> > Also, it may not do that today and I'd like to introduce a mechanism by which
> > that optimizatiom may be enabled by subsystems/drivers when ready.
> > 
> > So for example today there is no guarantee that each device will be resumed
> > as appropriate by whoever handles its children when necessary, because that
> > code may expect the device to be operational when it is running (precisely
> > because we used to resume that device in .prepare()).
> 
> > Yes.  In particular, I'd like the "child" subsystem to be able to let the
> > core know that it is fine to leave the parent suspended.
> 
> > That said the patchset doesn't really do both.  It only really is about
> > skipping the ->suspend callbacks if possible, but the *consequence* of that
> > is that *system* resume ->resume callbacks cannot be used to resume the
> > device any more in general.  That's because ->resume_early may try to
> > reverse the ->suspend_late's actions and so on, so if ->suspend_late hasn't
> > run, it would be a bug to run ->resume_early for that device.
> 
> > I agree.  For this reason, I think that the core has no choice but to treat
> > power.ignore_children set as "well, that device may need to be operational
> > going forward".
> 
> This discussion is getting a little messy.  Let's try to clarify it.
> Here is the major point:
> 
> 	We would like to save time during system suspend/resume by

Actually, that's not only about saving time, but also about saving energy.

> 	skipping over devices that are already in runtime suspend,
> 	whenever it is safe to do so.
> 
> Of course, the "it is safe to do so" part is what makes this difficult.  
> It boils down to three characteristics for each device.
> 
>     (a) The device uses the same power state for runtime suspend and
> 	system suspend.  Therefore, if the device is already in runtime
> 	suspend and the wakeup settings are correct, there is no need
> 	for the PM core to invoke the device's ->suspend callbacks.
> 
> This requires a few comments.  The matter of whether the same power
> state is used for both types of suspend is generally known beforehand,
> because it is decided by the subsystem or driver.  The matter of
> whether the wakeup settings are correct often can't be known until the
> system suspend starts, because userspace can select whether or not
> wakeup should be enabled during a system sleep.
> 
> Also, if the PM core is going to skip the ->suspend callbacks then it 
> is obliged to skip the ->resume callbacks as well (we mustn't call one 
> without the other).  Therefore, in cases where (a) holds, the device 
> will necessarily emerge from the system resume in a runtime-suspended 
> state.

The "emerge from system resume" requires a bit of clarification in my
opinion.  Do you refer to the status of the device when user space is
thawed or earlier?  If earlier, then when exactly?

> This may or may not cause problems for the device's children; 
> see below.
> 
>     (b) It's okay for the device's parent to be in runtime suspend
> 	when the device's ->suspend callbacks are invoked.
> 
> I included this just to be thorough.  In fact, I expect (b) to be true 
> for pretty much every device already.

I don't quite understand this.  What if the parent is a bridge and the
child's ->suspend tries to access the child's registers?  That surely won't
work if the parent is in a low-power state at that point.

> Or if it isn't true for some 
> devices, this is because of a special arrangement between the device's 
> subsystem and the parent's subsystem.  For example, the parent might 
> always be runtime-resumed by its subsystem at the start of a system 
> suspend (which is what PCI does now; I don't know if it is necessary).
> 
> In the absence of any sort of special arrangement, if (b) wasn't true 
> for some device then that device would already be experiencing problems 
> going into system suspend.

Unless, of course, its parent is a PCI device, because in that case it will
always be resumed by the PCI bus type.  And if the "always resumed" is going
to be changed to "only resumed if the parent's configuration needs to change",
there may be some regressions here and there.

> So (b) should not cause much difficulty.

I disagree.

> And if a special arrangement is present, it is a private matter between 
> the two subsystems, not involving the PM core.
> 
>     (c) It's okay for the device's parent to be in runtime suspend
> 	when the device's ->resume callbacks are invoked.
> 
> Unlike (b), I expect that (c) does _not_ hold for quite a few devices
> currently.  The reason is historical: When runtime PM was first
> implemented, we decided that all devices should emerge from system
> resume in the RPM_ACTIVE state, even if they were in runtime suspend
> when the system suspend started.  Therefore drivers could depend on the
> parent not being in runtime suspend while the device's ->resume
> callback was running.

That's correct.

> I don't think it is a good idea to perpetuate an accident of history.  
> Instead of adding a special mechanism to the PM core for accomodating 
> devices where (c) doesn't hold, I think we should fix up the drivers 
> so that (c) _does_ hold everywhere.  Maybe you disagree.

I agree with the idea, but I have a certain view on how to achieve it.
Which is by allowing the "good" ones to mark themselves as "good", then
go through the ones that aren't marked as "good" yet, fix them up and
mark them as "good".  Finally, when everyone is marked "good", we can
drop the marking.

> Anyway, let's assume first that things are all fixed up, and (b) and
> (c) hold for every device.  This means we can go back and consider (a).
> 
> Since the "same power state for both types of suspend" answer is known 
> beforehand, let's concentrate on devices where it is true (other 
> devices will simply continue to operate as they do today).  For these 
> devices, the driver or subsystem will have to compute a flag value --
> let's call it "same_wakeup_setting".  The PM core can't do this because 
> it doesn't understand the device-specific details of wakeup settings.
> 
> Then your proposal comes down to this:
> 
> 	If ->prepare returns > 0, the PM core sets the
> 	same_wakeup_setting flag.
> 
> 	If same_wakeup_setting is on and the device is in runtime
> 	suspend, the PM core skips the various ->suspend and ->resume 
> 	callbacks.
> 
> My proposal was never made explicit, but it would take a form something 
> like this:
> 
> 	During ->prepare, the subsystem sets the same_wakeup_setting
> 	flag appropriately.
> 
> 	If same_wakeup_setting is on and the device is in runtime
> 	suspend, the subsystem's ->suspend and ->resume callbacks
> 	return immediately.
> 
> There isn't very much difference between the two proposals.  Mine is a 
> little more flexible; for example, it allows the subsystem to return 
> immediately from ->suspend but have ->resume put the device back in the 
> RPM_ACTIVE state.

Your version is fine by me, I only made the PM core set the flag, because it
would clear that flag afterward in some cases.

> Now let's change course and suppose that (c) _doesn't_ hold for a large
> selection of devices.  As a simple consequence, if (c) doesn't hold for
> some device then (a) can't be allowed to hold for any ancestor of that
> device.  (I'm disregarding the power.ignore_children flag.)
> 
> Your proposal would take the same_wakeup_setting flag (you called it
> "fast_suspend"), used for answering (a), and combine it with the answer
> to (c).  That is, you would have ->prepare return > 0 only if (a) and
> (c) both hold -- and in addition, you turn off the flag if it is off in
> any child.
> 
> In practice, I suspect this means fast_suspend will end up affecting
> only leaf devices: those with no children.  This is partly because many
> devices don't have a .prepare method; there are plenty of entries in
> the device tree that don't correspond to physical devices (e.g., class
> devices, or devices present only for their sysfs attributes) and hence
> have no PM support at all.  Even though (c) does hold for such devices,
> the PM core won't realize it.
> 
> In addition, I don't like the way your proposal mixes together the
> answers to (a) and (c).

It really doesn't and I tried to explain that in my previous message, but
that apparently wasn't clear enough.

The reasoning was basically to set fast_suspend for a device if your condition
(a) held *and* if fast_suspend was set for all of the device's children.  Then
we would know that all those children would be RPM_SUSPENDED during system
resume as well and the resume part might be "streamlined" as well.  There was
nothing about (c) anywhere in that patchset. :-)

> If they could be kept separate, I think you could do a better job.
> 
> For instance, suppose (a) is true for some device, but (c) is false for
> one of its children.  Then the PM core could skip the ->suspend and
> ->resume callbacks for that device, and it could do a pm_runtime_resume
> on the device before resuming the child.  The end result would be a
> single ->runtime_resume call, instead of ->runtime_resume followed by
> ->suspend and then ->resume.

That would be a different optimization from the one I'm thinking about.

For now, I'm focusing on one problem, which is when resuming runtime-suspended
devices during system suspend may be avoided and how to make that generally
work for different parent-child arrangements.

The resume part changes in my patchset were consequences of that only.

Rafael

