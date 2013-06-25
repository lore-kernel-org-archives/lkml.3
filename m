Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3FYN76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:59:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37808 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab3FYN7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:59:54 -0400
Message-ID: <51C9A23F.80305@ti.com>
Date: Tue, 25 Jun 2013 16:59:27 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306241133500.1406-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306241133500.1406-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 10:34 PM, Alan Stern wrote:
> On Mon, 24 Jun 2013, Roger Quadros wrote:
> 
>> OK I've tried to handle all this in an alternate way. Now the controller suspend/resume
>> and runtime suspend/resume is independent of bus suspend.
>>
>> The controller now runtime suspends when all devices on the bus have suspended and
>> the hub auto suspends. NOTE: HW_ACCESSIBLE is still set on runtime_suspend.
>> The challenge here is to process the interrupt in this state.
> 
> The situation is a little peculiar.  Does the hardware really use the
> same IRQ for reporting wakeup events when the controller is suspended
> and for reporting normal I/O events?

No and yes :). Actually the Pad wakeup comes as a separate IRQ from hardware.
The omap pinctrl driver captures that, determines which pad caused the wakeup and
routes it to the appropriate interrupt based on the mapping provided in the device tree.
In the ehci-omap case we provide the EHCI IRQ number in the mapping for the USB host pads.

> 
> In principle, HW_ACCESSIBLE should not be set when the controller is
> suspended, because you can't access the hardware then (since the clocks
> are off, right?).  But I can see how this would cause a problem if it
> leads to wakeup interrupts being ignored.
> 
> Also, note that one of the things ehci_suspend() does is turn off the 
> Interrupt-Enable register, which means the wakeup interrupt would never 
> be issued in the first place.  I guess ehci_hcd_omap_suspend() will 
> have to turn on the proper enable bit before stopping the clocks.

For us, in runtime_suspend, we do not call ehci_suspend(), we just cut the clocks.
So HW_ACCESSIBLE is still set, which is kind of wrong, I agree. I'll update this in
the next patch.

> 
>> I've tried to handle this state. (i.e. interrupt while controller is runtime suspended),
>> by disabling the interrupt till we are ready and calling usb_hcd_resume_root_hub().
>> We mark a flag (HW_IRQ_DISABLED) stating that the interrupt was disabled and based on
>> that enable the IRQ and clear the flag in hcd_resume_work().
>>
>> Do let me know what you think of this approach.
> 
> This is a very tricky problem.  Right now, usbcore assumes that when 
> HW_ACCESSIBLE is clear, the hardware can't generate interrupt requests 
> and therefore any interrupt must come from some other device sharing 
> the same IRQ line.  For the systems you're working on, this is wrong in 
> both respects (the hardware _can_ generate interrupt requests and IRQ 
> lines aren't shared).

Right.
> 
> I think we will have to add a new flag to describe your situation.  
> Let's call it hcd->has_wakeup_interrupts.  Presumably there will never
> be a system that uses interrupts for wakeup signals _and_ has shared
> IRQ lines?  That would be a bad combination...

Sounds good.

> 
>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>> index d53547d..8879cd2 100644
>> --- a/drivers/usb/core/hcd.c
>> +++ b/drivers/usb/core/hcd.c
>> @@ -2136,6 +2136,11 @@ static void hcd_resume_work(struct work_struct *work)
>>  	usb_lock_device(udev);
>>  	usb_remote_wakeup(udev);
>>  	usb_unlock_device(udev);
>> +	if (HCD_IRQ_DISABLED(hcd)) {
>> +		/* Interrupt was disabled */
>> +		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
>> +		enable_irq(hcd->irq);
>> +	}
>>  }
> 
> This part is okay.
> 
>> @@ -2225,6 +2230,16 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>>  
>>  	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
>>  		rc = IRQ_NONE;
>> +	else if (pm_runtime_status_suspended(hcd->self.controller)) {
>> +		/*
>> +		 * We can't handle it yet so disable IRQ, make note of it
>> +		 * and resume root hub (i.e. controller as well)
>> +		 */
>> +		disable_irq_nosync(hcd->irq);
>> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
>> +		usb_hcd_resume_root_hub(hcd);
>> +		rc = IRQ_HANDLED;
>> +	}
> 
> This part will have to be different.
> 
> Certainly if HCD_DEAD(hcd) then we want to return IRQ_NONE.  Likewise
> if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_interrupts).  In all
> other cases we have to call the HCD's interrupt handler.
> 
> The rest of the work will have to be done in the HCD, while holding the 
> private lock.  In ehci_irq(), after the spin_lock() call, you'll have 
> to add something like this:
> 
> 	if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
> 		/*
> 		 * We got a wakeup interrupt while the controller was
> 		 * suspending or suspended.  We can't handle it now, so
> 		 * disable the IRQ and resume the root hub (and hence
> 		 * the controller too).
> 		 */
> 		disable_irq_nosync(hcd->irq);
> 		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> 		spin_unlock(&ehci->lock);
> 
> 		usb_hcd_resume_root_hub(hcd);
> 		return IRQ_HANDLED;
> 	}
> 
> I think this will work.  How does it look to you?
> 

Looks good to me. Below is the implementation on these lines.
I've added a flag "has_wakeup_irq:1" in struct hcd to indicate the special
case where the interrupt can come even if controller is suspended.

I've modified the ehci-omap driver to call ehci_suspend/resume() on system
suspend/resume. For runtime suspend/resume I just toggle the HCD_HW_ACCESSIBLE
flag to indicate that controller cannot be accessed when runtime suspended.
The cutting of clocks is done in the parent driver (i.e. drivers/mfd/omap-usb-host.c)

Patch is below. If it looks OK. I'll re-post the entire series. Thanks.

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index f5f5c7d..51c2d59 100644
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
@@ -132,6 +134,7 @@ struct usb_hcd {
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
+	unsigned		has_wakeup_irq:1; /* Can generate IRQ when suspended */
 
 	unsigned int		irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d53547d..24e21a2 100644
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
@@ -2223,7 +2228,9 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	 */
 	local_irq_save(flags);
 
-	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
+	if (unlikely(HCD_DEAD(hcd)))
+		rc = IRQ_NONE;
+	else if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_irq)
 		rc = IRQ_NONE;
 	else if (hcd->driver->irq(hcd) == IRQ_NONE)
 		rc = IRQ_NONE;
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 246e124..1844e31 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -689,6 +689,21 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 	spin_lock (&ehci->lock);
 
+	if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
+		/*
+		 * We got a wakeup interrupt while the controller was
+		 * suspending or suspended.  We can't handle it now, so
+		 * disable the IRQ and resume the root hub (and hence
+		 * the controller too).
+		 */
+		disable_irq_nosync(hcd->irq);
+		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		spin_unlock(&ehci->lock);
+
+		usb_hcd_resume_root_hub(hcd);
+		return IRQ_HANDLED;
+	}
+
 	status = ehci_readl(ehci, &ehci->regs->status);
 
 	/* e.g. cardbus physical eject */

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 16d7150..ead7d12 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -159,6 +159,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	hcd->has_wakeup_irq = true;
 	hcd_to_ehci(hcd)->caps = regs;
 
 	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
@@ -225,6 +226,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_pm_runtime:
@@ -257,6 +260,7 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	int i;
 
+	pm_runtime_get_sync(dev);
 	usb_remove_hcd(hcd);
 
 	for (i = 0; i < omap->nports; i++) {
@@ -286,15 +290,61 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
 
 MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
 
+static int omap_ehci_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	bool do_wakeup = device_may_wakeup(dev);
+
+	dev_dbg(dev, "%s: do_wakeup: %d\n", __func__, do_wakeup);
+
+	return ehci_suspend(hcd, do_wakeup);
+}
+
+static int omap_ehci_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	return ehci_resume(hcd, false);
+}
+
+static int omap_ehci_runtime_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+
+	return 0;
+}
+
+static int omap_ehci_runtime_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+
+	return 0;
+}
+
+
+static const struct dev_pm_ops omap_ehci_pm_ops = {
+        .suspend = omap_ehci_suspend,
+        .resume = omap_ehci_resume,
+        .runtime_suspend = omap_ehci_runtime_suspend,
+        .runtime_resume = omap_ehci_runtime_resume,
+};
+
 static struct platform_driver ehci_hcd_omap_driver = {
 	.probe			= ehci_hcd_omap_probe,
 	.remove			= ehci_hcd_omap_remove,
 	.shutdown		= ehci_hcd_omap_shutdown,
-	/*.suspend		= ehci_hcd_omap_suspend, */
-	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
 		.name		= hcd_name,
 		.of_match_table = of_match_ptr(omap_ehci_dt_ids),
+		.pm		= &omap_ehci_pm_ops,
 	}
 };
 

