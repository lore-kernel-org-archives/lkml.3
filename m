Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaFTVb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:31:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53007 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaFTVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:31:56 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
References: <Pine.LNX.4.44L0.1406191552330.1247-100000@iolanthe.rowland.org>
Date: Fri, 20 Jun 2014 14:31:53 -0700
In-Reply-To: <Pine.LNX.4.44L0.1406191552330.1247-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 19 Jun 2014 16:13:07 -0400 (EDT)")
Message-ID: <7h8uortghi.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 19 Jun 2014, Kevin Hilman wrote:
>
>> Alan Stern <stern@rowland.harvard.edu> writes:
>> 
>> > On Thu, 19 Jun 2014, Allen Yu wrote:
>> >
>> >> So what's the exact state of device if dev->power.is_suspended flag
>> >> is set and runtime_status is RPM_ACTIVE? Is it a state like
>> >> "suspended but still can be accessed"?
>> >> 
>> >> I'm just afraid the existing code would cause a device hang if we
>> >> allow it to be accessed even though it's suspended (at this point
>> >> RPM_ACTIVE could be meaningless). I don't understand the original
>> >> motivation of these code. If it's a valid case, most likely it should
>> >> be handled in the specific device driver instead of the PM core.
>> >
>> > You should read the Changelog for commit 6f3c77b040f (PM / Runtime:  
>> > let rpm_resume() succeed if RPM_ACTIVE, even when disabled, v2).  It
>> > explains why the code looks the way it does.
>> >
>> > However, I'm starting to think the reasoning in that commit may not be
>> > valid.  While perhaps it is okay for some I2C devices (mentioned in the
>> > commit log), it probably isn't okay in general.
>> 
>> Why not?
>
> See below.
>
>> > Kevin, do have any comments on this matter?  What do you think about 
>> > making the following change to rpm_resume():
>> >
>> >  repeat:
>> > 	if (dev->power.runtime_error)
>> > 		retval = -EINVAL;
>> > -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
>> > +	else if (dev->power.disable_depth > 0
>> > 	    && dev->power.runtime_status == RPM_ACTIVE)
>> > 		retval = 1;
>> > 	else if (dev->power.disable_depth > 0)
>> >
>> > Or even:
>> >
>> > +	else if (dev->power.disable_depth > 0 && !dev->power.is_suspended
>> >
>> > although this would require the I2C driver you mentioned in your commit 
>> > to change.
>> 
>> My change was introduced to catch a very specific case.  Namely, when we
>> know that the core has successfully asked the device to do a system suspend
>> (dev->power.is_suspended == true) *and* we know that runtime PM was
>> disabled *only* by the PM core (disable_depth == 0) while the device was
>> still active (runtime_status == RPM_ACTIVE.)
>
> For a general device, the fact that dev->power.is_suspended is set
> means the device _has_ been powered down.  Even though the
> runtime_status may not have changed, the PM core has to assume the
> device is not available for use.

This is where things get fuzzy because of the overlap between system PM
and runtime PM.  It makes sense that from a system PM perspecitve, the
core has to assume the device isn't available.  But from a runtime PM
perspective, we know that it is, so we allow the *runtime PM* requests
to succeed.

> While your I2C devices may be useable even after the ->suspend callback
> returns, for most devices this isn't true.  So we shouldn't allow
> rpm_resume() to return imediately when is_suspended is set.

It's not just my I2C devices, those are just a convenient example.  It's
true for any device that does a pm_runtime_get*() during its system
suspend/resume path.

>> In your first idea above, it would allow a _get() to succeed even if
>> someone other than the core (including the driver itself) had called
>> pm_runtime_disable().  I don't think we want that.
>
> Why not?  The fact that the device is disabled for runtime PM means
> that the PM core mustn't try to change its power state.  But if the
> runtime status is RPM_ACTIVE then the device should already be powered
> up, so there's no harm in letting runtime_resume() succeed.

Well, if we want pm_runtime_disable() to mean "disable only if
!RPM_ACTIVE", I guess that's another question to be debated.  However,
in my original patch I didn't want to make that generic change, I only
was after the very specific case when we know it was only the core which
disabled runtime PM.

> To put it another way, disabled_depth > 0 means that the PM core isn't
> allowed to invoke any of the runtime PM callbacks.  But when
> runtime_status == RPM_ACTIVE, runtime_resume() can run successfully
> without invoking any callbacks.

I'd be OK with that more generic change, but I suspect there may be some
drivers out there that may be relying on the -EACCESS.

>> In the second idea above, we'd completely miss the case where runtime PM
>> has been disabled by the core (because the core would have set
>> dev->power.is_suspended)
>
> That's the intention.  When is_suspended is set, the PM core assumes
> that the device has been powered down in preparation for system
> suspend.  We don't want to mess that up by performing a runtime resume.

This is where I disagree.  Some devices really need to be runtime
resumed during the suspend/resume process. 

>> In both cases, we're no longer just checking for that specific condition
>> I was after, so I'd have to spend more time thinking about any other
>> possible consequences as well.
>
> Indeed.  Hopefully the fallout won't affect more than a few drivers.

The fallout for the first one would be minor I suspect.  But the second
one is a pretty major change that I don't agree with.

>> I think part of the confusion here is coming from what
>> dev->power.is_suspended means.  From the core's perspective, it just
>> means that the core has called the ->suspend callback, and didn't detect
>> any errors.  
>
> Yes.  But the core also has to assume that the ->runtime_resume 
> callback will undo the effect of ->suspend.  Therefore the core should 
> not call ->runtime_resume if is_suspended is set.

I agree with Rafael that it should be up to the bus/subsystem to
allow/deny that.

>> Depending on the driver though, it doesn't have to mean that the device
>> is actually fully suspended.  For example, there are several cases of
>> "runtime PM centric" drivers are may be needed by other devices during
>> the system suspend/resume process and so are runtime PM resumed during
>> system suspend.
>
> At what stage do these devices get powered down?  During suspend_late
> or suspend_irq?  

Correct.

> At such times the PM core won't invoke the runtime PM callbacks
> anyway.
  
The core wont, but the bus/subsystem/pm_domain can.  Also, recently the
pm_runtime_force* functions were added so that a bus/subsystem could do
this easily.

> It sounds like what you really want for these devices is to have
> dev->power.is_suspended get set at the start of
> __device_suspend_late() rather than at the end of __device_suspend().  
> Or maybe even not to get set at all.

Well, from my PoV, power.is_suspended doesn't have any meaning for
runtime PM.  It's only for system suspend.

Kevin
