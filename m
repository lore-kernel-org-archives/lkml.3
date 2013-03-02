Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3CBWCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:02:16 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33480 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751207Ab3CBWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:02:14 -0500
Date: Sat, 2 Mar 2013 17:02:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <kishon@ti.com>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
In-Reply-To: <20130302203908.GF12181@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1303021647290.17418-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Mar 2013, Felipe Balbi wrote:

> > > @@ -174,6 +177,10 @@ static int xhci_plat_remove(struct platform_device *dev)
> > >  	struct usb_hcd	*hcd = platform_get_drvdata(dev);
> > >  	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
> > >  
> > > +	if (!pm_runtime_suspended(&dev->dev))
> > > +		pm_runtime_put(&dev->dev);
> > > +	pm_runtime_disable(&dev->dev);
> > > +
> > >  	usb_remove_hcd(xhci->shared_hcd);
> > >  	usb_put_hcd(xhci->shared_hcd);
> > 
> > This is very strange.  Why have a pm_runtime_put with no balancing 
> > pm_runtime_get?
> 
> this is good point and, in fact, a doubt I have myself. How are we
> supposed to check if device is suspended ? In case it _is_ suspended we
> might not be able to read device's registers due to clocks possibly
> being gated.

That's really a separate question.  It has a simple answer, though: If 
you want to access a device's registers, call pm_runtime_get_sync() 
beforehand and pm_runtime_put() (or _put_sync()) afterward.  Then it 
won't matter if the device was suspended originally.

If you actually do want to tell whether or not a device is suspended
and nothing more, call pm_runtime_status_suspended().  Of course, this
is racy -- the power state might change right after you make the call.

> Also, considering that some drivers are used in multiple platforms and
> those might behave differently when it comes to clock handling, how do
> we do that ? Should we require drivers to explicitly clk_get();
> clk_prepare_enable(); pm_runtime_set_active(); pm_runtime_enable() ?

I don't know much about clock handling.  In general, the
pm_runtime_set_active() and pm_runtime_enable() parts should be done by
the subsystem, not the driver, whenever possible.

> While that's doable, I don't see how that'd be doable for OMAP since
> they want to hide clock handling from drivers.
> 
> Any tips ?

Whichever piece of code is responsible for associating a clock with a
device should also be responsible for making sure that neither is
suspended when the driver's probe routine runs.  I'm not sure how 
different platforms do this; using a PM domain could be one answer.

All this is somewhat off the point of my original comment, however.  
Drivers must be sure to balance their pm_runtime_get() and _put()  
calls.  Having an unbalanced _put() in the remove routine is almost
certainly a mistake -- especially if it is conditional on the device's
power state, because a device can remain unsuspended even after the
driver does a pm_runtime_put().  For example, this will happen if the
user wrote "on"  to /sys/.../power/control.

Alan Stern

