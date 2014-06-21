Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaFUNeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:34:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56740 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752413AbaFUNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:34:29 -0400
Date: Sat, 21 Jun 2014 09:34:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kevin Hilman <khilman@linaro.org>
cc: Allen Yu <alleny@nvidia.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <7h8uortghi.fsf@paris.lan>
Message-ID: <Pine.LNX.4.44L0.1406210913470.26962-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Kevin Hilman wrote:

> > For a general device, the fact that dev->power.is_suspended is set
> > means the device _has_ been powered down.  Even though the
> > runtime_status may not have changed, the PM core has to assume the
> > device is not available for use.
> 
> This is where things get fuzzy because of the overlap between system PM
> and runtime PM.  It makes sense that from a system PM perspecitve, the
> core has to assume the device isn't available.  But from a runtime PM
> perspective, we know that it is, so we allow the *runtime PM* requests
> to succeed.

Well, to be fair, from a runtime PM perspective the core _doesn't_
know that the device is available.  For example, if we were talking
about a USB device rather than an I2C device, it _wouldn't_ be
available.

The fact is, after ->suspend returns some devices are still available
and some aren't.  Currently the PM core doesn't know which are which.

> > While your I2C devices may be useable even after the ->suspend callback
> > returns, for most devices this isn't true.  So we shouldn't allow
> > rpm_resume() to return imediately when is_suspended is set.
> 
> It's not just my I2C devices, those are just a convenient example.  It's
> true for any device that does a pm_runtime_get*() during its system
> suspend/resume path.

Yes.  But what if a pm_runtime_get*() happens duing system suspend but
not on the suspend path?  For example, what if a workqueue routine
happens to run at that time and completely independently calls
pm_runtime_get_sync()?  The PM core needs to know whether that call
should be allowed to succeed.

> > That's the intention.  When is_suspended is set, the PM core assumes
> > that the device has been powered down in preparation for system
> > suspend.  We don't want to mess that up by performing a runtime resume.
> 
> This is where I disagree.  Some devices really need to be runtime
> resumed during the suspend/resume process. 

Okay, I believe you.  But do they need to be runtime resumed by a call
to pm_runtime_get_*, or could pm_runtime_force_resume() be used 
instead?

> > Yes.  But the core also has to assume that the ->runtime_resume 
> > callback will undo the effect of ->suspend.  Therefore the core should 
> > not call ->runtime_resume if is_suspended is set.
> 
> I agree with Rafael that it should be up to the bus/subsystem to
> allow/deny that.

How?  Wouldn't that mean changing every subsystem that wants to
prevent the callbacks?

> > At what stage do these devices get powered down?  During suspend_late
> > or suspend_irq?  
> 
> Correct.
> 
> > At such times the PM core won't invoke the runtime PM callbacks
> > anyway.
>   
> The core wont, but the bus/subsystem/pm_domain can.  Also, recently the
> pm_runtime_force* functions were added so that a bus/subsystem could do
> this easily.

That's okay; if a subsystem calls one of those functions then we know
it intends to work around the usual protections.

> > It sounds like what you really want for these devices is to have
> > dev->power.is_suspended get set at the start of
> > __device_suspend_late() rather than at the end of __device_suspend().  
> > Or maybe even not to get set at all.
> 
> Well, from my PoV, power.is_suspended doesn't have any meaning for
> runtime PM.  It's only for system suspend.

If it doesn't have any meaning for runtime PM, it shouldn't be tested
in runtime.c.

But never mind that; the is_suspended flag is a red herring.  It
doesn't have clearly defined semantics.

What we really need to figure out is how to tell the PM core which
devices may safely have their runtime callbacks invoked during system
suspend.  For those devices, the core can avoid calling
pm_runtime_disable() during the suspend_late phase.  That would address
your requirements, right?

Here's another way to think about it.  At some point during system
suspend, a device needs to powered down for the last time.  Many
subsystems/drivers do this in their ->suspend callback.  Some during
->suspend_late or ->suspend_irq.  Some may never do it explicitly.  
Regardless, the PM core needs to know when it has happened, so that it
can block ->runtime_resume callbacks from that point onward.

Alan Stern

