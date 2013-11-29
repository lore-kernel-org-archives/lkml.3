Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3K2PbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:31:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52952 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754692Ab3K2Pa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:30:58 -0500
Date: Fri, 29 Nov 2013 10:30:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Ulf Hansson <ulf.hansson@linaro.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at
 system suspend
In-Reply-To: <4064706.R9zKA4hcfi@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1311291014020.27250-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Rafael J. Wysocki wrote:

> That should have been
> 
>  	driver->runtime_suspend(dev)
>  	do_X(dev)
> 
> because do_Y(dev) is for runtime suspend.  Sorry.
> 
> And of course, the subsystem-level code you're developing the driver for may not
> do the do_X(dev) thing at all, in which case all will work.  But what if someone
> tries to use the driver with a different subsystem-level code (like a new PM
> domain)?

It sounds like the problem is one of division of responsibilities.  
What part of the work is done by the subsystem, and what part is done 
by the driver?  Obviously the answer will vary from one subsystem to 
another.

As I understand it, in Ulf's situation the subsystem knows that the
operations needed for the suspend_late phase of system suspend are the
same as those carried out by the driver's runtime_suspend callback (if
the device isn't already in a runtime-PM low-power state).  Or perhaps
it knows they are the same as those carried out by the subsystem's
runtime_suspend callback.  Or perhaps the _driver_ knows that the
operations it needs for suspend_late are the same as those carried out
by its own runtime_suspend callback (if the device isn't already in a
low-power state).

Regardless, under those conditions the suspend_late routine merely has
to invoke the appropriate runtime_suspend routine, after checking the
device's runtime PM status.  We can't do this by calling
pm_runtime_suspend, because runtime PM is disabled during suspend_late.  
Instead, we have to call the proper runtime-suspend routine directly.

The amount of code needed is quite small; basically nothing more than:

	if (!pm_runtime_status_suspended(dev))
		dev->driver->pm->runtime_suspend(dev);

The problems are:

     1. Which callback does this code belong in?

     2. Which runtime_suspend callback should be invoked?  The example 
	above uses dev->driver->pm->runtime_suspend, but this may not 
	always be the right one.

Alan Stern

