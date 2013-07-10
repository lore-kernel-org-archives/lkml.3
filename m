Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3GJSpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:45:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40992 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755386Ab3GJSpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:45:03 -0400
Date: Wed, 10 Jul 2013 14:45:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] USB: Support wakeup IRQ for suspended controllers
In-Reply-To: <1373473393-27552-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307101440140.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Roger Quadros wrote:

> Some platforms e.g. ehci-omap can generate an interrupt
> (i.e. remote wakeup) even when the controller is suspended i.e.
> HW_ACCESSIBLE is cleared.
> 
> Introduce a flag "has_wakeup_irq" in struct usb_hcd to indicate
> such cases.
> 
> We tackle this case by disabling the IRQ, scheduling a
> hub resume and enabling back the IRQ after the controller has
> resumed. This ensures that the IRQ handler runs only after the
> controller is accessible.

> @@ -2248,7 +2253,21 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  	 */
>  	local_irq_save(flags);
>  
> -	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
> +	if (unlikely(HCD_DEAD(hcd)))
> +		rc = IRQ_NONE;
> +	else if (unlikely(!HCD_HW_ACCESSIBLE(hcd) && hcd->has_wakeup_irq)) {
> +		/*
> +		 * We got a wakeup interrupt while the controller was
> +		 * suspending or suspended.  We can't handle it now, so
> +		 * disable the IRQ and resume the root hub (and hence
> +		 * the controller too).
> +		 */
> +		disable_irq_nosync(hcd->irq);
> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> +		usb_hcd_resume_root_hub(hcd);
> +
> +		rc = IRQ_HANDLED;
> +	} else if (unlikely(!HCD_HW_ACCESSIBLE(hcd)))
>  		rc = IRQ_NONE;

In the interest of minimizing the amount of work needed in the most 
common case, this should be written as:

	else if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
		if (hcd->has_wakeup_irq) {
			...
		} else
			rc = IRQ_NONE;

>  	else if (hcd->driver->irq(hcd) == IRQ_NONE)
>  		rc = IRQ_NONE;

Apart from that, the patch is okay.  When you rearrange the logic, you 
can add my Acked-by.

Alan Stern

