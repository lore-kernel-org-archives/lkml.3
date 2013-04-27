Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3D0PO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:14:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48358 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753859Ab3D0POz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:14:55 -0400
Date: Sat, 27 Apr 2013 11:14:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: ZhenHua <zhen-hual@hp.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <517B18E2.3060408@hp.com>
Message-ID: <Pine.LNX.4.44L0.1304271111530.30732-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013, ZhenHua wrote:

> On 04/27/2013 12:51 AM, Alan Stern wrote:
> > On Fri, 26 Apr 2013, ZhenHua wrote:
> >
> >> There is a function  wait_for_HP() in uhci-hub.c. In this
> >> patch, it is used in suspend_rh(),  I think this can be a
> >> solution. And I have tested this patch, it can fix the bug.
> >>
> >> I think there is another patch needed. As Alan said in another
> >> mail, in the UHCI_RH_RUNNING_NODEVS case, it should not be stopped
> >> if the uhci device is HP iLo virtual usb.
> > I believe that if you change the UHCI_RH_RUNNING_NODEVS case, you will
> > find that this patch (calling wait_for_HP) isn't needed.
> >
> > In fact, the patch is so easy that I am including it below.  Please
> > test this (without either of your patches) to see if it works.
> >
> > Alan Stern
> >
> >
> >
> >
> > Index: usb-3.9/drivers/usb/host/uhci-hub.c
> > ===================================================================
> > --- usb-3.9.orig/drivers/usb/host/uhci-hub.c
> > +++ usb-3.9/drivers/usb/host/uhci-hub.c
> > @@ -225,7 +225,8 @@ static int uhci_hub_status_data(struct u
> >   		/* auto-stop if nothing connected for 1 second */
> >   		if (any_ports_active(uhci))
> >   			uhci->rh_state = UHCI_RH_RUNNING;
> > -		else if (time_after_eq(jiffies, uhci->auto_stop_time))
> > +		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
> > +				!uhci->wait_for_hp)
> >   			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
> >   		break;
> >   
> >
> I have tested the UHCI_RH_RUNNING_NODEVS case yeasterday, and it works.
> But the function suspend_rh is also called in other places, so I think 
> it only fixes
> the warning when auto stop is called, but not fix the warning when 
> uhci's bus_suspend
> is called,  it will come out again.

Have you tried this?  I expect the warning will not occur when the
bus_suspend routine is called, because then there will be a 1-ms delay,
not just a 400-us delay.

> And if you add uhci->wait_for_hp check in the UHCI_RH_RUNNING_NODEVS case,
> all hp uhci devices will not auto stop, not only the virtual devices. I 
> guess it may waste resource.

If you want, you can add a new flag specifically for virtual
controllers.  But it shouldn't matter -- as long as your kernels are
built with CONFIG_PM_RUNTIME enabled, there won't be any significant
waste of resources.

Alan Stern

