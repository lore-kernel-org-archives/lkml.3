Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3D1SzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 14:55:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44592 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751707Ab3D1SzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 14:55:16 -0400
Date: Sun, 28 Apr 2013 14:55:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <517C808A.2060502@hp.com>
Message-ID: <Pine.LNX.4.44L0.1304281447010.23571-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Apr 2013, ZhenHua wrote:

> >>> In fact, the patch is so easy that I am including it below.  Please
> >>> test this (without either of your patches) to see if it works.
> >>>
> >>> Alan Stern
> >>>
> >>>
> >>>
> >>>
> >>> Index: usb-3.9/drivers/usb/host/uhci-hub.c
> >>> ===================================================================
> >>> --- usb-3.9.orig/drivers/usb/host/uhci-hub.c
> >>> +++ usb-3.9/drivers/usb/host/uhci-hub.c
> >>> @@ -225,7 +225,8 @@ static int uhci_hub_status_data(struct u
> >>>    		/* auto-stop if nothing connected for 1 second */
> >>>    		if (any_ports_active(uhci))
> >>>    			uhci->rh_state = UHCI_RH_RUNNING;
> >>> -		else if (time_after_eq(jiffies, uhci->auto_stop_time))
> >>> +		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
> >>> +				!uhci->wait_for_hp)
> >>>    			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
> >>>    		break;
> >>>    
> >>>
> >> I have tested the UHCI_RH_RUNNING_NODEVS case yeasterday, and it works.
> >> But the function suspend_rh is also called in other places, so I think
> >> it only fixes
> >> the warning when auto stop is called, but not fix the warning when
> >> uhci's bus_suspend
> >> is called,  it will come out again.
> > Have you tried this?  I expect the warning will not occur when the
> > bus_suspend routine is called, because then there will be a 1-ms delay,
> > not just a 400-us delay.
> I tested this, and the warning is gone.  Is this patch committed ?
> I need to paste the link to suse bugzilla.

You must be joking.  I wrote that patch while composing the email
message to you, and nobody except you has tested it.

Since you confirm that it works, I will submit it.  But new patches
like this won't be accepted until after the upcoming merge window
closes, which won't be for more than two weeks.

> >> And if you add uhci->wait_for_hp check in the UHCI_RH_RUNNING_NODEVS case,
> >> all hp uhci devices will not auto stop, not only the virtual devices. I
> >> guess it may waste resource.
> > If you want, you can add a new flag specifically for virtual
> > controllers.  But it shouldn't matter -- as long as your kernels are
> > built with CONFIG_PM_RUNTIME enabled, there won't be any significant
> > waste of resources.
> >
> > Alan Stern
> >
> I think we can check the product id to determine whether a device is 
> virtual.
> Do you know if there is another way to check this?

I don't know anything at all about your virtual UHCI controllers, other
than what you have told me.  In particular, I don't know what product
IDs are used by HP's virtual and non-virtual controllers.  Maybe
somebody else at HP can tell you.

Alan Stern

