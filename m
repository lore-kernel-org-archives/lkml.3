Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3F1TSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:18:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57139 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752709Ab3F1TS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:18:28 -0400
Date: Fri, 28 Jun 2013 15:18:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <51CD9663.6060806@ti.com>
Message-ID: <Pine.LNX.4.44L0.1306281507020.1047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Roger Quadros wrote:

> Just found the problem. It seems that enabling the ehci_irq _after_ the root hub is resumed
> is the root cause of the problem. Doing so will miss events from the root hub.

This sounds like a bug in the IRQ setup.  It's the sort of thing you 
see when a level-triggered IRQ is treated as though it were 
edge-triggered.

In any case, the wakeup should have worked whether the IRQ was issued 
or not.

> The following modification worked for me without any delays.
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 72df4eb..b3af1aa 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2136,11 +2136,6 @@ static void hcd_resume_work(struct work_struct *work)
>  	usb_lock_device(udev);
>  	usb_remote_wakeup(udev);
>  	usb_unlock_device(udev);
> -	if (HCD_IRQ_DISABLED(hcd)) {
> -		/* Interrupt was disabled */
> -		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> -		enable_irq(hcd->irq);
> -	}
>  }
>  
>  /**
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 593d28d..f2a1a46 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -1110,6 +1110,12 @@ int ehci_resume(struct usb_hcd *hcd, bool hibernated)
>  {
>  	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
>  
> +	if (HCD_IRQ_DISABLED(hcd)) {
> +		/* Interrupt was disabled */
> +		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> +		enable_irq(hcd->irq);
> +	}
> +
>  	if (time_before(jiffies, ehci->next_statechange))
>  		msleep(100);

I appreciate the symmetry of putting the enable_irq call in ehci-hcd, 
seeing as how the disable_irq is there too.  On the other hand, every 
HCD using this mechanism is going to have to do the same thing, which 
argues for putting the enable call in the core.  Perhaps at the start 
of hcd_resume_work() instead of the end.

Alan Stern

