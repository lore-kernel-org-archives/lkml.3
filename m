Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3DWPKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:10:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35358 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756138Ab3DWPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:10:18 -0400
Date: Tue, 23 Apr 2013 11:10:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: "Li, Zhen-Hua" <zhen-hual@hp.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tom.vaden@hp.com>
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
In-Reply-To: <20130423140734.GA30877@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1304231102490.1679-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Greg KH wrote:

> On Tue, Apr 23, 2013 at 03:15:01PM +0800, Li, Zhen-Hua wrote:
> > From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> > 
> > This patch is trying to fix bug QXCR1001261767.
> 
> What is that bug number?  Where can it be referenced?  If you are going
> to put it in a public place (like a kernel changelog), it needs to be
> publicly accessible.
> 
> > On some HP platform, when usb driver inits the iLo Virtual USB Controller, there may be a warning "Controller not stopped yet!". It is because driver does not wait enough time.
> 
> What happened to your line endings?
> 
> > This patch adds more time waiting and retries.
> 
> Why not only do this for your device?

It won't hurt to do it for all devices, because the wait loop will 
terminate as soon as the controller goes into suspend.  For normal 
controllers this will be on the first iteration.

> > Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> > ---
> >  drivers/usb/host/uhci-hcd.c |   16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> > index 4a86b63..514e9d7 100644
> > --- a/drivers/usb/host/uhci-hcd.c
> > +++ b/drivers/usb/host/uhci-hcd.c
> > @@ -277,6 +277,9 @@ static int global_suspend_mode_is_broken(struct uhci_hcd *uhci)
> >  		uhci->global_suspend_mode_is_broken(uhci) : 0;
> >  }
> >  
> > +#define UHCI_SUSPENDRH_RETRY_MAX      10
> > +#define UHCI_SUSPENDRH_RETRY_DELAY    100

Why is the delay set to 100 us?  Isn't that excessively large?  How 
long does it take for this controller to go into suspend?

> >  static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state)
> >  __releases(uhci->lock)
> >  __acquires(uhci->lock)
> > @@ -284,6 +287,7 @@ __acquires(uhci->lock)
> >  	int auto_stop;
> >  	int int_enable, egsm_enable, wakeup_enable;
> >  	struct usb_device *rhdev = uhci_to_hcd(uhci)->self.root_hub;
> > +	u16 try, stopped;

Why are these variables u16?  Why not int?

Anyway, a better approach would be not to add a delay loop at all.  
Instead, change this test:

	if (!auto_stop && !(uhci_readw(uhci, USBSTS) & USBSTS_HCH)) {
		uhci->rh_state = UHCI_RH_SUSPENDING;
		spin_unlock_irq(&uhci->lock);
		msleep(1);
		spin_lock_irq(&uhci->lock);
		if (uhci->dead)
			return;
	}

When the iLo controller is present, make the "if" statement always 
succeed.  Then you'll get a whole 1-ms delay.

Alan Stern

