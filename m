Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FXPJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:09:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3FXPJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:09:39 -0400
Message-ID: <51C86113.1090902@ti.com>
Date: Mon, 24 Jun 2013 18:09:07 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306201326100.2063-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306201326100.2063-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 06/20/2013 08:33 PM, Alan Stern wrote:
> On Thu, 20 Jun 2013, Roger Quadros wrote:
> 
>>> runtime_resume(dev)
>>> {
>>> 	...
>>>
>>> 	if (omap->flags & OMAP_EHCI_IRQ_PENDING) {
>>> 		process_pending_irqs(omap);
>>
>> OK, thanks. 
>>
>> But I'm not sure if the generic ehci_irq handler is able to
>> run in a process context. Maybe if we replace spin_lock(&ehci->lock);
>> with spin_lock_irqsave() there, it will work.
>>
>> Alan is this a doable option?
> 
> ehci_irq() will work okay in process context, provided the caller 
> disables interrupts.
> 
> But maybe none of this will be needed after Roger redesigns the
> controller suspend to work at the right time.  Or if it is, we could
> adopt a simpler alternative: the controller's resume routine could
> always call usb_hcd_resume_root_hub().  After all, about the only
> reason for doing a runtime resume of the controller is because the root
> hub needs to do something.
> 

OK I've tried to handle all this in an alternate way. Now the controller suspend/resume
and runtime suspend/resume is independent of bus suspend.

The controller now runtime suspends when all devices on the bus have suspended and
the hub auto suspends. NOTE: HW_ACCESSIBLE is still set on runtime_suspend.
The challenge here is to process the interrupt in this state.

I've tried to handle this state. (i.e. interrupt while controller is runtime suspended),
by disabling the interrupt till we are ready and calling usb_hcd_resume_root_hub().
We mark a flag (HW_IRQ_DISABLED) stating that the interrupt was disabled and based on
that enable the IRQ and clear the flag in hcd_resume_work().

Do let me know what you think of this approach.

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d53547d..8879cd2 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2136,6 +2136,11 @@ static void hcd_resume_work(struct work_struct *work)
 	usb_lock_device(udev);
 	usb_remote_wakeup(udev);
 	usb_unlock_device(udev);
+	if (HCD_IRQ_DISABLED(hcd)) {
+		/* Interrupt was disabled */
+		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		enable_irq(hcd->irq);
+	}
 }
 
 /**
@@ -2225,6 +2230,16 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 
 	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
 		rc = IRQ_NONE;
+	else if (pm_runtime_status_suspended(hcd->self.controller)) {
+		/*
+		 * We can't handle it yet so disable IRQ, make note of it
+		 * and resume root hub (i.e. controller as well)
+		 */
+		disable_irq_nosync(hcd->irq);
+		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		usb_hcd_resume_root_hub(hcd);
+		rc = IRQ_HANDLED;
+	}
 	else if (hcd->driver->irq(hcd) == IRQ_NONE)
 		rc = IRQ_NONE;
 	else

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index f5f5c7d..6c6287e 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -110,6 +110,7 @@ struct usb_hcd {
 #define HCD_FLAG_WAKEUP_PENDING		4	/* root hub is resuming? */
 #define HCD_FLAG_RH_RUNNING		5	/* root hub is running? */
 #define HCD_FLAG_DEAD			6	/* controller has died? */
+#define HCD_FLAG_IRQ_DISABLED		7	/* Interrupt was disabled */
 
 	/* The flags can be tested using these macros; they are likely to
 	 * be slightly faster than test_bit().
@@ -120,6 +121,7 @@ struct usb_hcd {
 #define HCD_WAKEUP_PENDING(hcd)	((hcd)->flags & (1U << HCD_FLAG_WAKEUP_PENDING))
 #define HCD_RH_RUNNING(hcd)	((hcd)->flags & (1U << HCD_FLAG_RH_RUNNING))
 #define HCD_DEAD(hcd)		((hcd)->flags & (1U << HCD_FLAG_DEAD))
+#define HCD_IRQ_DISABLED(hcd)	((hcd)->flags & (1U << HCD_FLAG_IRQ_DISABLED))
 
 	/* Flags that get set only during HCD registration or removal. */
 	unsigned		rh_registered:1;/* is root hub registered? */

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 16d7150..c5320c7 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -225,6 +225,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_pm_runtime:

