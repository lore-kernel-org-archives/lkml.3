Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3F0Pkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:40:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752654Ab3F0Pk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:40:29 -0400
Date: Thu, 27 Jun 2013 11:40:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
In-Reply-To: <51CAEEC4.4030304@ti.com>
Message-ID: <Pine.LNX.4.44L0.1306271032210.1167-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Roger Quadros wrote:

> > Could the mapping be changed so that a different interrupt vector was 
> > used for wakeups and normal I/O?  That would make this a little easier, 
> > although it wouldn't solve the general problem.
> 
> I'm not sure which IRQ we can map it to, but it could be mapped to some
> free IRQ number. Since it doesn't make things easier, I think we can leave
> it as it is for now.

All right.

> > There's still a race problem.  Suppose a normal wakeup interrupt occurs
> > just before or as the controller gets suspended.  By the time the code
> > here runs, HCD_HW_ACCESSIBLE may have been cleared by the suspend
> > routine.  The interrupt would be lost.  Depending on the design of the
> > controller, the entire wakeup signal could end up getting lost as well.
> 
> But if I call ehci_suspend() in the runtime_suspend handler, this race
> won't happen right?

That race doesn't apply to your system anyway; it matters only on 
systems where hcd->has_wakeup_irq isn't set.  The only way to fix it 
involves changing ehci_suspend() somewhat (and making the equivalent 
change for other HCDs too).  Those musings above were just me thinking 
out loud about the problems involved in implementing reliable wakeups.

> > Do you know how the OMAP EHCI controller behaves?  Under what 
> > conditions does it send the wakeup IRQ?  How do you tell it to turn off 
> > the wakeup IRQ?
> 
> Once the controller is suspended, the wakeup IRQ comes out-of-band. i.e. through
> pad wakeup and pinctrl subsystem.
> The only way to turn that wakeup off is to disable the wakeup enable bit on the pad.
> This could be done by not putting the pins in the IDLE_WAKEUP state during
> suspend.

That's not what I meant.  Never mind the pinctrl; I was asking about
the EHCI controller itself.  Under what circumstances does the
controller assert its wakeup signal?  And how do you tell it to stop
asserting that signal?

> Thanks for the review.
> 
> I updated the ehci-omap.c driver to call ehci_suspend/resume during runtime_suspend/resume.
> After that, it stopped detecting the port status change event when a device was plugged
> to an external HUB. The wakeup irq was coming and the root hub/controller were being resumed,
> but after that, no hub_irq.

Wait a minute.  I'm not clear on what happened.  You're starting out
with the controller, the root hub, and the external hub all suspended, 
right?  Then you plugged a new device into the external hub.  This 
caused the controller and the root hub to wake up, but not the external 
hub?

> Adding some delay (or printk) somewhere in the resume path fixes the issue. I'm not sure what
> is going on and why the delay is needed. Below is the ehci-omap patch. I've put the delay
> in the runtime_resume handler.
> 
> e.g. log
> 
> [    8.674377] usb usb1: usb wakeup-resume
> [    8.678833] ehci-omap 48064800.ehci: omap_ehci_runtime_resume
> [    8.695190] usb usb1: usb auto-resume
> [    8.699066] ehci-omap 48064800.ehci: resume root hub
> [    8.704437] hub 1-0:1.0: hub_resume
> [    8.708312] hub 1-0:1.0: port 2: status 0507 change 0000
> [    8.714630] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
> 
> <---- gets stuck here in the failing case---->
> 
> [    8.723541] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0004
> [    8.729400] ehci-omap 48064800.ehci: GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [    8.753204] usb 1-2: usb wakeup-resume
> [    8.757293] usb 1-2: finish resume
> [    8.761627] hub 1-2:1.0: hub_resume

Yeah, we need more debugging info.  In ehci_irq(), right after the
"pstatus = ehci_readl(..." line, what is the value of pstatus?  And in
the GetPortStatus case of ehci_hub_control(), right after the "temp =
ehci_readl(..." line, what is the value of temp?

> @@ -286,15 +293,70 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
>  
>  MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
>  
> +static int omap_ehci_suspend(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +	bool do_wakeup = device_may_wakeup(dev);
> +
> +	dev_dbg(dev, "%s: do_wakeup: %d\n", __func__, do_wakeup);
> +
> +	return ehci_suspend(hcd, do_wakeup);
> +}
> +
> +static int omap_ehci_resume(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	return ehci_resume(hcd, false);
> +}

Those two routines look okay.

> +static int omap_ehci_runtime_suspend(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
> +	bool do_wakeup = device_may_wakeup(dev);
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	if (omap->initialized)
> +		ehci_suspend(hcd, do_wakeup);

Here you should not use do_wakeup.  The second argument should always
be "true", because wakeup is always enabled during runtime suspend.

Also, why do you need omap->initialized?  Do you think you might get a 
wakeup interrupt before the controller has been fully set up?  I don't 
see how you could, given the pm_runtime_get_sync() call in the probe 
routine.

Alan Stern

