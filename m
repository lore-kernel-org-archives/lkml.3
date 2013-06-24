Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3FXTeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:34:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51852 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750900Ab3FXTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:34:19 -0400
Date: Mon, 24 Jun 2013 15:34:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <51C86113.1090902@ti.com>
Message-ID: <Pine.LNX.4.44L0.1306241133500.1406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Roger Quadros wrote:

> OK I've tried to handle all this in an alternate way. Now the controller suspend/resume
> and runtime suspend/resume is independent of bus suspend.
> 
> The controller now runtime suspends when all devices on the bus have suspended and
> the hub auto suspends. NOTE: HW_ACCESSIBLE is still set on runtime_suspend.
> The challenge here is to process the interrupt in this state.

The situation is a little peculiar.  Does the hardware really use the
same IRQ for reporting wakeup events when the controller is suspended
and for reporting normal I/O events?

In principle, HW_ACCESSIBLE should not be set when the controller is
suspended, because you can't access the hardware then (since the clocks
are off, right?).  But I can see how this would cause a problem if it
leads to wakeup interrupts being ignored.

Also, note that one of the things ehci_suspend() does is turn off the 
Interrupt-Enable register, which means the wakeup interrupt would never 
be issued in the first place.  I guess ehci_hcd_omap_suspend() will 
have to turn on the proper enable bit before stopping the clocks.

> I've tried to handle this state. (i.e. interrupt while controller is runtime suspended),
> by disabling the interrupt till we are ready and calling usb_hcd_resume_root_hub().
> We mark a flag (HW_IRQ_DISABLED) stating that the interrupt was disabled and based on
> that enable the IRQ and clear the flag in hcd_resume_work().
> 
> Do let me know what you think of this approach.

This is a very tricky problem.  Right now, usbcore assumes that when 
HW_ACCESSIBLE is clear, the hardware can't generate interrupt requests 
and therefore any interrupt must come from some other device sharing 
the same IRQ line.  For the systems you're working on, this is wrong in 
both respects (the hardware _can_ generate interrupt requests and IRQ 
lines aren't shared).

I think we will have to add a new flag to describe your situation.  
Let's call it hcd->has_wakeup_interrupts.  Presumably there will never
be a system that uses interrupts for wakeup signals _and_ has shared
IRQ lines?  That would be a bad combination...

> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d53547d..8879cd2 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2136,6 +2136,11 @@ static void hcd_resume_work(struct work_struct *work)
>  	usb_lock_device(udev);
>  	usb_remote_wakeup(udev);
>  	usb_unlock_device(udev);
> +	if (HCD_IRQ_DISABLED(hcd)) {
> +		/* Interrupt was disabled */
> +		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> +		enable_irq(hcd->irq);
> +	}
>  }

This part is okay.

> @@ -2225,6 +2230,16 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  
>  	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
>  		rc = IRQ_NONE;
> +	else if (pm_runtime_status_suspended(hcd->self.controller)) {
> +		/*
> +		 * We can't handle it yet so disable IRQ, make note of it
> +		 * and resume root hub (i.e. controller as well)
> +		 */
> +		disable_irq_nosync(hcd->irq);
> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> +		usb_hcd_resume_root_hub(hcd);
> +		rc = IRQ_HANDLED;
> +	}

This part will have to be different.

Certainly if HCD_DEAD(hcd) then we want to return IRQ_NONE.  Likewise
if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_interrupts).  In all
other cases we have to call the HCD's interrupt handler.

The rest of the work will have to be done in the HCD, while holding the 
private lock.  In ehci_irq(), after the spin_lock() call, you'll have 
to add something like this:

	if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
		/*
		 * We got a wakeup interrupt while the controller was
		 * suspending or suspended.  We can't handle it now, so
		 * disable the IRQ and resume the root hub (and hence
		 * the controller too).
		 */
		disable_irq_nosync(hcd->irq);
		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
		spin_unlock(&ehci->lock);

		usb_hcd_resume_root_hub(hcd);
		return IRQ_HANDLED;
	}

I think this will work.  How does it look to you?

Alan Stern

