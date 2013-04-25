Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3DYOy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:54:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60480 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932572Ab3DYOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:54:55 -0400
Date: Thu, 25 Apr 2013 10:54:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tom.vaden@hp.com>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <5178856F.6000908@hp.com>
Message-ID: <Pine.LNX.4.44L0.1304251039210.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, ZhenHua wrote:

> >>> +#define UHCI_SUSPENDRH_RETRY_MAX      10
> >>> +#define UHCI_SUSPENDRH_RETRY_DELAY    100
> > Why is the delay set to 100 us?  Isn't that excessively large?  How
> > long does it take for this controller to go into suspend?
> This controller will take about 200~400 us, but I am not sure how long 
> other devices will take.
> I set interval to 100 us,  so it will save more time.

A 400-us delay is fairly long.  It would be better to avoid it
entirely.

> > Why are these variables u16?  Why not int?
> uhci_readw will return u16.

That's not a good reason, since u16 fits perfectly well inside an
int.  But never mind...

> > Anyway, a better approach would be not to add a delay loop at all.
> > Instead, change this test:
> >
> > 	if (!auto_stop && !(uhci_readw(uhci, USBSTS) & USBSTS_HCH)) {
> > 		uhci->rh_state = UHCI_RH_SUSPENDING;
> > 		spin_unlock_irq(&uhci->lock);
> > 		msleep(1);
> > 		spin_lock_irq(&uhci->lock);
> > 		if (uhci->dead)
> > 			return;
> > 	}
> >
> > When the iLo controller is present, make the "if" statement always
> > succeed.  Then you'll get a whole 1-ms delay.
> This will cause more operation and more time for other devices.

Actually what I wrote was wrong anyway.  I forgot that when auto_stop 
is set, the routine is not allowed to sleep.

A better way to solve your problem is to change uhci_hub_status_data().
In the UHCI_RH_RUNNING_NODEVS case, change the line that says

		else if (time_after_eq(jiffies, uhci->auto_stop_time))

to

		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
				!uhci->no_auto_stops)

where uhci->no_auto_stops is a new bitflag that you set inside
uhci_pci_init() if you detect that the controller is an iLo virtual
UHCI controller.

This way there will always be a 1-ms delay, so the slow controller will
suspend successfully.  And other types of host controllers won't be
affected, because the no_auto_stops flag won't get set for them.

Alan Stern

