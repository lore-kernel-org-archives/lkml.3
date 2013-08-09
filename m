Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab3HIRXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:23:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:39478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab3HIRXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:23:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,847,1367996400"; 
   d="scan'208";a="384543129"
Date: Fri, 9 Aug 2013 10:22:57 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Shawn Nematbakhsh <shawnn@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
Message-ID: <20130809172257.GA713@xanatos>
References: <20130524210503.GC15788@xanatos>
 <Pine.LNX.4.44L0.1305251005390.18146-100000@netrider.rowland.org>
 <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALaWCOOGEDtF1z29df2ST9kV-VpMa9VbvFK0Hh71WJG5f_pngA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

I noticed that the ChromeOS kernel tree is still using this particular
patch, and thought it was probably time to revisit it.

On Sat, May 25, 2013 at 09:57:57AM -0700, Shawn Nematbakhsh wrote:
> Hi Sarah and Alan,
> 
> Thanks for the comments. I will make the following revisions:
> 
> 1. Call pm_runtime_get_noresume only when the first device is connected,
> and call pm_runtime_put when the last device is disconnected.
> 2. Wrap the calls in an ifdef CONFIG_USB_DEFAULT_PERSIST.
> 3. Make sure that all pm_runtime_get_noresume calls have a corresponding
> pm_runtime_put somewhere (originally the intent was to disable runtime
> suspend "forever", but no longer).
> 
> In principle, would the patch be acceptable with these revisions?

The thread petered off with all other options turning out to be
dead-ends, so yes, if you made those changes, you could get that patch
upstream.  I would like the ChromeOS kernel to be as close to upstream
as possible, so please resubmit this patch with those changes.

Thanks,
Sarah Sharp

> 
> On Sat, May 25, 2013 at 7:11 AM, Alan Stern <stern@rowland.harvard.edu>wrote:
> 
> > On Fri, 24 May 2013, Sarah Sharp wrote:
> >
> > > On Fri, May 24, 2013 at 11:12:57AM -0700, Shawn Nematbakhsh wrote:
> > > > If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
> > > > a reset will be performed upon runtime resume. Any previously suspended
> > > > devices attached to the controller will be re-enumerated at this time.
> > > > This will cause problems, for example, if an open system call on the
> > > > device triggered the resume (the open call will fail).
> > >
> > > That's ugly, but disabling runtime PM is going to have a big impact on
> > > the power consumption of those systems.
> > >
> > > Alan, do you think this is really the right thing to be doing here?  It
> > > feels like userspace should just be able to deal with devices
> > > disconnecting on resume.  After all, there are lots of USB devices that
> > > can't handle USB device suspend at all.
> >
> > This is a complicated issue.  It depends on the runtime PM settings for
> > both the device and the host controller.
> >
> > As just one aspect, consider the fact that if it wants to, userspace
> > can already prevent the controller from going into runtime suspend.
> > Always preventing this at the kernel level, even when no devices are
> > plugged in, does seem too heavy-handed.
> >
> > > Shouldn't userspace just disable runtime PM for the USB device classes
> > > that don't have a reset resume callback?
> >
> > That's not so easy, because the kernel changes over time.  Userspace
> > has no general way to tell which drivers have reset-resume support.
> >
> > > > Note that this change is only relevant when persist_enabled is not set
> > > > for USB devices.
> > >
> > > Could we at least wrap the call in an ifdef CONFIG_USB_DEFAULT_PERSIST?
> > > That way if people have USB persist turned off in their configuration,
> > > their host will still be able to suspend.
> >
> > Not just that; the patch is incorrect on the face of it...
> >
> > > > @@ -4687,6 +4687,12 @@ int xhci_gen_setup(struct usb_hcd *hcd,
> > xhci_get_quirks_t get_quirks)
> > > >
> > > >     get_quirks(dev, xhci);
> > > >
> > > > +   /* If we are resetting upon resume, we must disable runtime PM.
> > > > +    * Otherwise, an open() syscall to a device on our runtime
> > suspended
> > > > +    * controller will trigger controller reset and device
> > re-enumeration */
> > > > +   if (xhci->quirks & XHCI_RESET_ON_RESUME)
> > > > +           pm_runtime_get_noresume(dev);
> > > > +
> >
> > It adds a pm_runtime_get call with no corresponding pm_runtime_put.
> >
> > Alan Stern
> >
> >
