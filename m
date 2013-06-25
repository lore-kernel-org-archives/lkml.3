Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3FYRih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:38:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45141 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752027Ab3FYRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:38:33 -0400
Date: Tue, 25 Jun 2013 13:38:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <51C9A23F.80305@ti.com>
Message-ID: <Pine.LNX.4.44L0.1306251251550.1340-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Roger Quadros wrote:

> On 06/24/2013 10:34 PM, Alan Stern wrote:
> > On Mon, 24 Jun 2013, Roger Quadros wrote:
> > 
> >> OK I've tried to handle all this in an alternate way. Now the controller suspend/resume
> >> and runtime suspend/resume is independent of bus suspend.
> >>
> >> The controller now runtime suspends when all devices on the bus have suspended and
> >> the hub auto suspends. NOTE: HW_ACCESSIBLE is still set on runtime_suspend.
> >> The challenge here is to process the interrupt in this state.
> > 
> > The situation is a little peculiar.  Does the hardware really use the
> > same IRQ for reporting wakeup events when the controller is suspended
> > and for reporting normal I/O events?
> 
> No and yes :). Actually the Pad wakeup comes as a separate IRQ from hardware.
> The omap pinctrl driver captures that, determines which pad caused the wakeup and
> routes it to the appropriate interrupt based on the mapping provided in the device tree.
> In the ehci-omap case we provide the EHCI IRQ number in the mapping for the USB host pads.

Could the mapping be changed so that a different interrupt vector was 
used for wakeups and normal I/O?  That would make this a little easier, 
although it wouldn't solve the general problem.

> >>  	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
> >>  		rc = IRQ_NONE;
> >> +	else if (pm_runtime_status_suspended(hcd->self.controller)) {
> >> +		/*
> >> +		 * We can't handle it yet so disable IRQ, make note of it
> >> +		 * and resume root hub (i.e. controller as well)
> >> +		 */
> >> +		disable_irq_nosync(hcd->irq);
> >> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> >> +		usb_hcd_resume_root_hub(hcd);
> >> +		rc = IRQ_HANDLED;
> >> +	}
> > 
> > This part will have to be different.
> > 
> > Certainly if HCD_DEAD(hcd) then we want to return IRQ_NONE.  Likewise
> > if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_interrupts).  In all
> > other cases we have to call the HCD's interrupt handler.

There's still a race problem.  Suppose a normal wakeup interrupt occurs
just before or as the controller gets suspended.  By the time the code
here runs, HCD_HW_ACCESSIBLE may have been cleared by the suspend
routine.  The interrupt would be lost.  Depending on the design of the
controller, the entire wakeup signal could end up getting lost as well.

Do you know how the OMAP EHCI controller behaves?  Under what 
conditions does it send the wakeup IRQ?  How do you tell it to turn off 
the wakeup IRQ?

> Looks good to me. Below is the implementation on these lines.
> I've added a flag "has_wakeup_irq:1" in struct hcd to indicate the special
> case where the interrupt can come even if controller is suspended.
> 
> I've modified the ehci-omap driver to call ehci_suspend/resume() on system
> suspend/resume. For runtime suspend/resume I just toggle the HCD_HW_ACCESSIBLE
> flag to indicate that controller cannot be accessed when runtime suspended.

You're going to change that, right?  ehci_suspend/resume should be
called whenever the controller's power state changes, regardless of
whether it is for runtime PM or system PM.

> The cutting of clocks is done in the parent driver (i.e. drivers/mfd/omap-usb-host.c)
> 
> Patch is below. If it looks OK. I'll re-post the entire series. Thanks.
> 
> diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> index f5f5c7d..51c2d59 100644
> --- a/include/linux/usb/hcd.h
> +++ b/include/linux/usb/hcd.h
> @@ -110,6 +110,7 @@ struct usb_hcd {
>  #define HCD_FLAG_WAKEUP_PENDING		4	/* root hub is resuming? */
>  #define HCD_FLAG_RH_RUNNING		5	/* root hub is running? */
>  #define HCD_FLAG_DEAD			6	/* controller has died? */
> +#define HCD_FLAG_IRQ_DISABLED		7	/* Interrupt was disabled */
>  
>  	/* The flags can be tested using these macros; they are likely to
>  	 * be slightly faster than test_bit().
> @@ -120,6 +121,7 @@ struct usb_hcd {
>  #define HCD_WAKEUP_PENDING(hcd)	((hcd)->flags & (1U << HCD_FLAG_WAKEUP_PENDING))
>  #define HCD_RH_RUNNING(hcd)	((hcd)->flags & (1U << HCD_FLAG_RH_RUNNING))
>  #define HCD_DEAD(hcd)		((hcd)->flags & (1U << HCD_FLAG_DEAD))
> +#define HCD_IRQ_DISABLED(hcd)	((hcd)->flags & (1U << HCD_FLAG_IRQ_DISABLED))
>  
>  	/* Flags that get set only during HCD registration or removal. */
>  	unsigned		rh_registered:1;/* is root hub registered? */
> @@ -132,6 +134,7 @@ struct usb_hcd {
>  	unsigned		wireless:1;	/* Wireless USB HCD */
>  	unsigned		authorized_default:1;
>  	unsigned		has_tt:1;	/* Integrated TT in root hub */
> +	unsigned		has_wakeup_irq:1; /* Can generate IRQ when suspended */
>  
>  	unsigned int		irq;		/* irq allocated */
>  	void __iomem		*regs;		/* device memory/io */
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d53547d..24e21a2 100644
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
>  
>  /**
> @@ -2223,7 +2228,9 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  	 */
>  	local_irq_save(flags);
>  
> -	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
> +	if (unlikely(HCD_DEAD(hcd)))
> +		rc = IRQ_NONE;
> +	else if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_irq)
>  		rc = IRQ_NONE;

Add an unlikely() here too.

>  	else if (hcd->driver->irq(hcd) == IRQ_NONE)
>  		rc = IRQ_NONE;
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 246e124..1844e31 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -689,6 +689,21 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
>  
>  	spin_lock (&ehci->lock);
>  
> +	if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
> +		/*
> +		 * We got a wakeup interrupt while the controller was
> +		 * suspending or suspended.  We can't handle it now, so
> +		 * disable the IRQ and resume the root hub (and hence
> +		 * the controller too).
> +		 */
> +		disable_irq_nosync(hcd->irq);
> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);

To be safe, let's put these two statements inside

		if (hcd->has_wakeup_irq) { ... }

I think if the right sort of race occurs, we could end up here even 
when hcd->has_wakeup_irq is clear.  So this test is needed.  We don't 
want to disable a shared IRQ line.

> +		spin_unlock(&ehci->lock);
> +
> +		usb_hcd_resume_root_hub(hcd);
> +		return IRQ_HANDLED;
> +	}
> +
>  	status = ehci_readl(ehci, &ehci->regs->status);
>  
>  	/* e.g. cardbus physical eject */
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 16d7150..ead7d12 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c

This part seems reasonable, once the runtime PM routines are fixed.

Alan Stern



