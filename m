Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3FZNir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:38:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53585 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3FZNiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:38:46 -0400
Message-ID: <51CAEEC4.4030304@ti.com>
Date: Wed, 26 Jun 2013 16:38:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306251251550.1340-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306251251550.1340-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 08:38 PM, Alan Stern wrote:
> On Tue, 25 Jun 2013, Roger Quadros wrote:
> 
>> On 06/24/2013 10:34 PM, Alan Stern wrote:
>>> On Mon, 24 Jun 2013, Roger Quadros wrote:
>>>
>>>> OK I've tried to handle all this in an alternate way. Now the controller suspend/resume
>>>> and runtime suspend/resume is independent of bus suspend.
>>>>
>>>> The controller now runtime suspends when all devices on the bus have suspended and
>>>> the hub auto suspends. NOTE: HW_ACCESSIBLE is still set on runtime_suspend.
>>>> The challenge here is to process the interrupt in this state.
>>>
>>> The situation is a little peculiar.  Does the hardware really use the
>>> same IRQ for reporting wakeup events when the controller is suspended
>>> and for reporting normal I/O events?
>>
>> No and yes :). Actually the Pad wakeup comes as a separate IRQ from hardware.
>> The omap pinctrl driver captures that, determines which pad caused the wakeup and
>> routes it to the appropriate interrupt based on the mapping provided in the device tree.
>> In the ehci-omap case we provide the EHCI IRQ number in the mapping for the USB host pads.
> 
> Could the mapping be changed so that a different interrupt vector was 
> used for wakeups and normal I/O?  That would make this a little easier, 
> although it wouldn't solve the general problem.

I'm not sure which IRQ we can map it to, but it could be mapped to some
free IRQ number. Since it doesn't make things easier, I think we can leave
it as it is for now.

> 
>>>>  	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
>>>>  		rc = IRQ_NONE;
>>>> +	else if (pm_runtime_status_suspended(hcd->self.controller)) {
>>>> +		/*
>>>> +		 * We can't handle it yet so disable IRQ, make note of it
>>>> +		 * and resume root hub (i.e. controller as well)
>>>> +		 */
>>>> +		disable_irq_nosync(hcd->irq);
>>>> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
>>>> +		usb_hcd_resume_root_hub(hcd);
>>>> +		rc = IRQ_HANDLED;
>>>> +	}
>>>
>>> This part will have to be different.
>>>
>>> Certainly if HCD_DEAD(hcd) then we want to return IRQ_NONE.  Likewise
>>> if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_interrupts).  In all
>>> other cases we have to call the HCD's interrupt handler.
> 
> There's still a race problem.  Suppose a normal wakeup interrupt occurs
> just before or as the controller gets suspended.  By the time the code
> here runs, HCD_HW_ACCESSIBLE may have been cleared by the suspend
> routine.  The interrupt would be lost.  Depending on the design of the
> controller, the entire wakeup signal could end up getting lost as well.

But if I call ehci_suspend() in the runtime_suspend handler, this race
won't happen right?

> 
> Do you know how the OMAP EHCI controller behaves?  Under what 
> conditions does it send the wakeup IRQ?  How do you tell it to turn off 
> the wakeup IRQ?

Once the controller is suspended, the wakeup IRQ comes out-of-band. i.e. through
pad wakeup and pinctrl subsystem.
The only way to turn that wakeup off is to disable the wakeup enable bit on the pad.
This could be done by not putting the pins in the IDLE_WAKEUP state during
suspend.

ff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>> index d53547d..24e21a2 100644
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
>>  
>>  /**
>> @@ -2223,7 +2228,9 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>>  	 */
>>  	local_irq_save(flags);
>>  
>> -	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
>> +	if (unlikely(HCD_DEAD(hcd)))
>> +		rc = IRQ_NONE;
>> +	else if (!HCD_HW_ACCESSIBLE(hcd) && !hcd->has_wakeup_irq)
>>  		rc = IRQ_NONE;
> 
> Add an unlikely() here too.
> 
OK.

>>  	else if (hcd->driver->irq(hcd) == IRQ_NONE)
>>  		rc = IRQ_NONE;
>> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
>> index 246e124..1844e31 100644
>> --- a/drivers/usb/host/ehci-hcd.c
>> +++ b/drivers/usb/host/ehci-hcd.c
>> @@ -689,6 +689,21 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
>>  
>>  	spin_lock (&ehci->lock);
>>  
>> +	if (unlikely(!HCD_HW_ACCESSIBLE(hcd))) {
>> +		/*
>> +		 * We got a wakeup interrupt while the controller was
>> +		 * suspending or suspended.  We can't handle it now, so
>> +		 * disable the IRQ and resume the root hub (and hence
>> +		 * the controller too).
>> +		 */
>> +		disable_irq_nosync(hcd->irq);
>> +		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
> 
> To be safe, let's put these two statements inside
> 
> 		if (hcd->has_wakeup_irq) { ... }
> 
> I think if the right sort of race occurs, we could end up here even 
> when hcd->has_wakeup_irq is clear.  So this test is needed.  We don't 
> want to disable a shared IRQ line.
> 

OK.

>> +		spin_unlock(&ehci->lock);
>> +
>> +		usb_hcd_resume_root_hub(hcd);
>> +		return IRQ_HANDLED;
>> +	}
>> +
>>  	status = ehci_readl(ehci, &ehci->regs->status);
>>  
>>  	/* e.g. cardbus physical eject */
>>
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>> index 16d7150..ead7d12 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
> 
> This part seems reasonable, once the runtime PM routines are fixed.
> 

Thanks for the review.

I updated the ehci-omap.c driver to call ehci_suspend/resume during runtime_suspend/resume.
After that, it stopped detecting the port status change event when a device was plugged
to an external HUB. The wakeup irq was coming and the root hub/controller were being resumed,
but after that, no hub_irq.

Adding some delay (or printk) somewhere in the resume path fixes the issue. I'm not sure what
is going on and why the delay is needed. Below is the ehci-omap patch. I've put the delay
in the runtime_resume handler.

e.g. log

[    8.674377] usb usb1: usb wakeup-resume
[    8.678833] ehci-omap 48064800.ehci: omap_ehci_runtime_resume
[    8.695190] usb usb1: usb auto-resume
[    8.699066] ehci-omap 48064800.ehci: resume root hub
[    8.704437] hub 1-0:1.0: hub_resume
[    8.708312] hub 1-0:1.0: port 2: status 0507 change 0000
[    8.714630] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000

<---- gets stuck here in the failing case---->

[    8.723541] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0004
[    8.729400] ehci-omap 48064800.ehci: GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    8.753204] usb 1-2: usb wakeup-resume
[    8.757293] usb 1-2: finish resume
[    8.761627] hub 1-2:1.0: hub_resume


diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 16d7150..c687610 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -69,6 +69,7 @@ static const char hcd_name[] = "ehci-omap";
 struct omap_hcd {
 	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
 	int nports;
+	bool initialized;
 };
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
@@ -159,6 +160,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	hcd->has_wakeup_irq = true;
 	hcd_to_ehci(hcd)->caps = regs;
 
 	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
@@ -210,6 +212,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		goto err_pm_runtime;
 	}
 
+	omap->initialized = true;
+
 	/*
 	 * Bring PHYs out of reset.
 	 * Even though HSIC mode is a PHY-less mode, the reset
@@ -225,6 +229,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_pm_runtime:
@@ -257,6 +263,7 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	int i;
 
+	pm_runtime_get_sync(dev);
 	usb_remove_hcd(hcd);
 
 	for (i = 0; i < omap->nports; i++) {
@@ -286,15 +293,70 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
 
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
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	bool do_wakeup = device_may_wakeup(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (omap->initialized)
+		ehci_suspend(hcd, do_wakeup);
+
+	return 0;
+}
+
+static int omap_ehci_runtime_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (omap->initialized) {
+		ehci_resume(hcd, false);
+		mdelay(10);
+	}
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
 


