Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3EYOLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:11:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54277 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756373Ab3EYOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:11:45 -0400
Date: Sat, 25 May 2013 10:11:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Shawn Nematbakhsh <shawnn@chromium.org>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
In-Reply-To: <20130524210503.GC15788@xanatos>
Message-ID: <Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013, Sarah Sharp wrote:

> On Fri, May 24, 2013 at 11:12:57AM -0700, Shawn Nematbakhsh wrote:
> > If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
> > a reset will be performed upon runtime resume. Any previously suspended
> > devices attached to the controller will be re-enumerated at this time.
> > This will cause problems, for example, if an open system call on the
> > device triggered the resume (the open call will fail).
> 
> That's ugly, but disabling runtime PM is going to have a big impact on
> the power consumption of those systems.
> 
> Alan, do you think this is really the right thing to be doing here?  It
> feels like userspace should just be able to deal with devices
> disconnecting on resume.  After all, there are lots of USB devices that
> can't handle USB device suspend at all.

This is a complicated issue.  It depends on the runtime PM settings for 
both the device and the host controller.

As just one aspect, consider the fact that if it wants to, userspace
can already prevent the controller from going into runtime suspend.  
Always preventing this at the kernel level, even when no devices are 
plugged in, does seem too heavy-handed.

> Shouldn't userspace just disable runtime PM for the USB device classes
> that don't have a reset resume callback?

That's not so easy, because the kernel changes over time.  Userspace 
has no general way to tell which drivers have reset-resume support.

> > Note that this change is only relevant when persist_enabled is not set
> > for USB devices.
> 
> Could we at least wrap the call in an ifdef CONFIG_USB_DEFAULT_PERSIST?
> That way if people have USB persist turned off in their configuration,
> their host will still be able to suspend.

Not just that; the patch is incorrect on the face of it...

> > @@ -4687,6 +4687,12 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
> >  
> >  	get_quirks(dev, xhci);
> >  
> > +	/* If we are resetting upon resume, we must disable runtime PM.
> > +	 * Otherwise, an open() syscall to a device on our runtime suspended
> > +	 * controller will trigger controller reset and device re-enumeration */
> > +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
> > +		pm_runtime_get_noresume(dev);
> > +

It adds a pm_runtime_get call with no corresponding pm_runtime_put.

Alan Stern

