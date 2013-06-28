Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3F1MVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:21:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45287 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3F1MVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:21:16 -0400
Message-ID: <51CD7FA1.3020005@ti.com>
Date: Fri, 28 Jun 2013 15:20:49 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306271032210.1167-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306271032210.1167-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 06:40 PM, Alan Stern wrote:
> On Wed, 26 Jun 2013, Roger Quadros wrote:
> 
> 
> That race doesn't apply to your system anyway; it matters only on 
> systems where hcd->has_wakeup_irq isn't set.  The only way to fix it 
> involves changing ehci_suspend() somewhat (and making the equivalent 
> change for other HCDs too).  Those musings above were just me thinking 
> out loud about the problems involved in implementing reliable wakeups.
> 

OK.

>>> Do you know how the OMAP EHCI controller behaves?  Under what 
>>> conditions does it send the wakeup IRQ?  How do you tell it to turn off 
>>> the wakeup IRQ?
>>
>> Once the controller is suspended, the wakeup IRQ comes out-of-band. i.e. through
>> pad wakeup and pinctrl subsystem.
>> The only way to turn that wakeup off is to disable the wakeup enable bit on the pad.
>> This could be done by not putting the pins in the IDLE_WAKEUP state during
>> suspend.
> 
> That's not what I meant.  Never mind the pinctrl; I was asking about
> the EHCI controller itself.  Under what circumstances does the
> controller assert its wakeup signal?  And how do you tell it to stop
> asserting that signal?

I believe this would be through the EHCI Interrupt enable register (USBINTR).
I'm not aware of any other mechanism.

>> I updated the ehci-omap.c driver to call ehci_suspend/resume during runtime_suspend/resume.
>> After that, it stopped detecting the port status change event when a device was plugged
>> to an external HUB. The wakeup irq was coming and the root hub/controller were being resumed,
>> but after that, no hub_irq.
> 
> Wait a minute.  I'm not clear on what happened.  You're starting out
> with the controller, the root hub, and the external hub all suspended, 
> right?  Then you plugged a new device into the external hub.  This 

This is right.

> caused the controller and the root hub to wake up, but not the external 
> hub?
>
Right. It seems the external hub has signaled remote wakeup but the kernel doesn't
resume the root hub's port it is connected to.

By observing the detailed logs below you can see that the root hub does not generate
an INTerrupt transaction to notify the port status change event. I've captured the pstatus
and GetPortStatus info as well.

Failing case
------------

[   16.108032] usb usb1: usb auto-resume
[   16.108062] ehci-omap 48064800.ehci: resume root hub
[   16.108154] hub 1-0:1.0: hub_resume
[   16.108398] ehci_hub_control GetPortStatus, port 1 temp = 0x1000
[   16.108459] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
[   16.108551] hub 1-0:1.0: port 2: status 0507 change 0000
[   16.108612] ehci_hub_control GetPortStatus, port 3 temp = 0x1000
[   16.108642] hub 1-0:1.0: hub_activate submitting urb
[   16.109222] ehci_irq port 3 pstatus 0x1000
[   16.109222] ehci_irq port 2 pstatus 0x14c5
[   16.109252] ehci_irq port 1 pstatus 0x1000
[   16.109374] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000

Passing case
------------

/ # [   19.704589] usb usb1: usb wakeup-resume
[   19.709075] ehci-omap 48064800.ehci: omap_ehci_runtime_resume
[   19.715423] usb usb1: usb auto-resume
[   19.719299] ehci-omap 48064800.ehci: resume root hub
[   19.724670] hub 1-0:1.0: hub_resume
[   19.728424] ehci_hub_control GetPortStatus, port 1 temp = 0x1000
[   19.734863] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
[   19.741271] hub 1-0:1.0: port 2: status 0507 change 0000
[   19.746948] ehci_hub_control GetPortStatus, port 3 temp = 0x1000
[   19.753448] hub 1-0:1.0: hub_activate submitting urb
[   19.759216] ehci_irq port 3 pstatus 0x1000
[   19.763519] ehci_irq port 2 pstatus 0x14c5
[   19.767822] ehci_irq port 1 pstatus 0x1000
[   19.772155] hub 1-0:1.0: hub_irq 

<---This is the Port Status change hub INT which is missing in the failing case--->

[   19.775604] hub 1-0:1.0: hub_irq submitting urb
[   19.780548] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0004
[   19.786407] hub 1-0:1.0: hub_irq
[   19.789916] hub 1-0:1.0: hub_irq submitting urb
[   19.794799] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
[   19.801147] ehci-omap 48064800.ehci: GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   19.822937] usb 1-2: usb wakeup-resume
[   19.826995] ehci_hub_control GetPortStatus, port 2 temp = 0x1005
[   19.833404] usb 1-2: finish resume
[   19.837738] hub 1-2:1.0: hub_resume
[   19.841613] hub 1-2:1.0: port 1: status 0507 change 0000
[   19.848358] hub 1-2:1.0: port 4: status 0101 change 0001
[   19.962890] hub 1-2:1.0: hub_activate submitting urb
[   19.968139] ehci-omap 48064800.ehci: reused qh dd450200 schedule
[   19.974456] usb 1-2: link qh256-0001/dd450200 start 1 [1/0 us]
[   19.980743] hub 1-0:1.0: resume on port 2, status 0
[   19.985961] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[   19.991760] hub 1-2:1.0: state 7 ports 5 chg 0010 evt 0000
[   19.997741] hub 1-2:1.0: port 4, status 0101, change 0000, 12 Mb/s
[   20.083129] usb 1-2.4: new high-speed USB device number 4 using ehci-omap
<snip>

One more thing is that the delay didn't help if I reduce printk verbosity to 7.
So the debug prints are also adding some delays around the place which is affecting
the behaviour.

>> +static int omap_ehci_runtime_suspend(struct device *dev)
>> +{
>> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
>> +	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
>> +	bool do_wakeup = device_may_wakeup(dev);
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	if (omap->initialized)
>> +		ehci_suspend(hcd, do_wakeup);
> 
> Here you should not use do_wakeup.  The second argument should always
> be "true", because wakeup is always enabled during runtime suspend.

OK.

> 
> Also, why do you need omap->initialized?  Do you think you might get a 
> wakeup interrupt before the controller has been fully set up?  I don't 
> see how you could, given the pm_runtime_get_sync() call in the probe 
> routine.
> 

During probe we need to runtime_resume the device before usb_add_hcd() since the
controller clocks must be enabled before any registers are accessed.
However, we cannot call ehci_resume() before usb_add_hcd(). So to prevent this
chicken & egg situation, I've used the omap->initialized flag. It only indicates that
the ehci structures are initialized and we can call ehci_resume/suspend().

cheers,
-roger


