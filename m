Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966750Ab3E2ULs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:11:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56767 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966369Ab3E2ULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:11:41 -0400
Date: Wed, 29 May 2013 16:11:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Julius Werner <jwerner@chromium.org>,
        Shawn Nematbakhsh <shawnn@chromium.org>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
In-Reply-To: <20130529193828.GK32085@xanatos>
Message-ID: <Pine.LNX.4.44L0.1305291558330.885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Sarah Sharp wrote:

> On Tue, May 28, 2013 at 02:41:18PM -0700, Julius Werner wrote:
> > The policy we want to achieve is to disable runtime PM iff there is a
> > device connected that doesn't have persist_enabled or a reset_resume()
> > handler and whose parent/root hub resets on resume, right?
> 
> Makes sense.  However, not all distros may want that policy, so there
> should be a way to change that policy via sysfs.  Some distros may
> choose to take the power savings over having a particular USB device
> work, especially in the server market.
> 
> Don, Oliver, what do you think of this patch:
> http://marc.info/?l=linux-usb&m=136941922715772&w=2
> 
> Julius is proposing to limit the scope of the patch a bit, but the
> impact will still be that TI hosts will be active more often than not.

In many cases, the usual default of allowing the root hub to 
autosuspend will be acceptable.  In cases where it isn't, I think we 
will have to rely on userspace to tell us.  The simplest way is for 
userspace to forbid autosuspend.

That may not be flexible enough, but at this point there doesn't seem 
to be any way for the kernel to include all the different policies that 
userspace might want.  All we can do is make the information available.

There already is a "quirks" attribute in sysfs, but it's probably not 
good enough for this.  The contents are subject to change if we 
renumber the QUIRK bits.  Maybe something more like the "avoid_reset" 
attribute.

A problem with registering sysfs attributes from within xhci-hcd is
that they won't become visible until some time after the device is
registered.  If a udev script runs too quickly, it won't see the
attribute.

> > So couldn't
> > we remove the HCD-specific XHCI_RESET_ON_RESUME and set the (existing)
> > generic USB_QUIRK_RESET_RESUME on the root hub instead?  Then we could
> > handle all of this in the USB core (during device initialization and
> > when changing persist_enabled through sysfs) by just checking for
> > udev->reset_resume on all parent hubs of the device in question (and
> > use pm_runtime_get/put() on said device to prevent its parents from
> > suspending as appropriate).
> 
> Alan, what happens if we set USB_QUIRK_RESET_RESUME on the roothub?
> I don't think that currently translates into the host controller's Reset
> register getting written, which is what I think Julius is proposing.

Hmmm.  Now that I look more closely, setting the RESET_RESUME quirk on
the root hub would prevent it from ever going into runtime suspend,
which is not what we are after.  (The quirk disables autosuspend for
devices whose drivers don't support reset-resume or require remote
wakeup.)

Oh, well.

Alan Stern

