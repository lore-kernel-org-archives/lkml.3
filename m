Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab3CDP5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:57:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44971 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758371Ab3CDP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:57:14 -0500
Date: Mon, 4 Mar 2013 10:57:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <kishon@ti.com>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
In-Reply-To: <20130302232132.GB14558@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1303041038390.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Mar 2013, Felipe Balbi wrote:

> > > this is good point and, in fact, a doubt I have myself. How are we
> > > supposed to check if device is suspended ? In case it _is_ suspended we
> > > might not be able to read device's registers due to clocks possibly
> > > being gated.
> > 
> > That's really a separate question.  It has a simple answer, though: If 
> > you want to access a device's registers, call pm_runtime_get_sync() 
> > beforehand and pm_runtime_put() (or _put_sync()) afterward.  Then it 
> > won't matter if the device was suspended originally.
> 
> that's alright, but how do you want me to check if my device is enabled
> or not before pm_runtime_enable() ?

You're not supposed to check.  Just make sure your own 
pm_runtime_enable() and _disable() calls are done correctly, and let 
the PM core worry about the rest.  :-)

More to the point, the question of what code enables a device for
runtime PM is decided by the subsystem.  Many subsystems will do it
automatically so that their drivers don't have to worry about it.  
Other subsystems will leave it entirely up to the drivers.  You have to
know what the subsystem wants.

In this case, it's appropriate to do the enable here in the probe
routine because the platform core doesn't do it for you.  This also
means the driver should disable the device in the remove routine.

> > I don't know much about clock handling.  In general, the
> > pm_runtime_set_active() and pm_runtime_enable() parts should be done by
> > the subsystem, not the driver, whenever possible.
> 
> good to know :-) Though I disagree with calling pm_runtime_enable() at
> the subsystem level.

It depends on the subsystem.  For some (like the USB host subsystem),
it is appropriate.

> > Whichever piece of code is responsible for associating a clock with a
> > device should also be responsible for making sure that neither is
> > suspended when the driver's probe routine runs.  I'm not sure how 
> > different platforms do this; using a PM domain could be one answer.
> 
> that's alright, but it generates a different set of problems. That same
> piece of code which associates a device with its clock, doesn't really
> know if the driver is even available which means we could be enabling
> clocks for no reason and just wasting precious battery juice ;-)

Better than wasting our precious bodily fluids...  :-)

I guess the best answer is to set up the association but then leave the
device and clocks in a runtime-suspended status.  Then do a
pm_runtime_get_sync() just before calling the driver's probe routine
and a pm_runtime_put_sync() just after calling the remove routine.  
That should leave the device and the clocks in the state the driver
expects.  (But be careful that these two calls don't invoke the
driver's runtime-PM callbacks!)

Probably nobody has thought these problems through very carefully for 
the platform subsystem.  Nevertheless, that's where the decisions need 
to be made.

Alan Stern

