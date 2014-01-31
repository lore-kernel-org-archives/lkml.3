Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaAaVea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:34:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47111 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932629AbaAaVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:34:28 -0500
Date: Fri, 31 Jan 2014 16:34:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for
 platform-bus
In-Reply-To: <1391191965-31102-1-git-send-email-balbi@ti.com>
Message-ID: <Pine.LNX.4.44L0.1401311614100.12368-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Felipe Balbi wrote:

> Still TODO a commit log. Not for merging!!!!!
> 
> NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> This patch is an idea I've had recently in order to combine several different
> PM implementations into the platform-bus.
> 
> This patch is bare minimum for platforms which need to handle functional and
> interface clocks but the whole thing is made optional.
> 
> Note that this patch makes sure that by the time a platform_driver's probe is
> called, we already have clocks enabled and pm_runtime_set_active() has been
> called, thus making sure that a device driver's pm_runtime_get_sync() will
> solely increase the pm usage counter.
> 
> I have *NOT* tested this anywhere *YET*, but I suppose it shouldn't cause any
> issues since the clock API has ref counting too.
> 
> Would really like to get some review from several folks involved with ARM SoC
> PM so that's the reason for the wide audience. If I have missed anybody, please
> add them to Cc.
> 
> As mentioned above, this is *NOT* meant for merging, but serves as a starting
> point for discussing some convergence of several PM domain implementations on
> different arch/arm/mach-* directories.

You might want to copy the runtime-PM approach used by the PCI 
subsystem.  It works like this:

	The core invokes a driver's probe routine with runtime PM 
	enabled, the device in the ACTIVE state, and the usage counter 
	incremented by 1.

	If the driver wants to support runtime PM, the probe routine
	can call pm_runtime_put_noidle.

	The core does pm_runtime_get_sync before invoking the driver's
	remove routine.  At this point a runtime-PM-aware driver whould 
	call pm_runtime_get_noresume, to balance the _put during probe.

	After invoking the remove routine, the core does a put_noidle
	(to balance the get_sync) and a final put_sync (to balance the
	increment before probe and to leave the device at low power.)

A nice consequence is that everything is transparent for drivers that 
don't support runtime PM.  The usage counter remains > 0 the entire 
time the driver is bound.

Conversely, drivers that do support runtime PM merely have to add one 
call during probe and one during remove.

There is one tricky aspect to all this.  The driver core sets the
dev->driver field before calling the subsystem core's probe routine.  
As a result, the subsystem has to be very careful about performing
runtime PM before invoking the driver's probe routine.  Otherwise you
will end up calling the driver's runtime_resume callback before the
driver's probe!  (And of course, the same problem exists in reverse
during remove.)

Alan Stern

