Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3GIN7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:59:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GIN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:59:13 -0400
Message-ID: <51DC1712.30401@ti.com>
Date: Tue, 9 Jul 2013 16:58:42 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306281346430.1047-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306281346430.1047-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 10:06 PM, Alan Stern wrote:
> On Fri, 28 Jun 2013, Roger Quadros wrote:
> 
>>> That's not what I meant.  Never mind the pinctrl; I was asking about
>>> the EHCI controller itself.  Under what circumstances does the
>>> controller assert its wakeup signal?  And how do you tell it to stop
>>> asserting that signal?
>>
>> I believe this would be through the EHCI Interrupt enable register (USBINTR).
>> I'm not aware of any other mechanism.
> 
> That's strange, because ehci_suspend() sets the intr_enable register to 
> 0.  So how do you ever get any wakeup interrupts at all?
> 
>> Right. It seems the external hub has signaled remote wakeup but the kernel doesn't
>> resume the root hub's port it is connected to.
>>
>> By observing the detailed logs below you can see that the root hub does not generate
>> an INTerrupt transaction to notify the port status change event. I've captured the pstatus
>> and GetPortStatus info as well.
> 
> We don't need an interrupt.  The driver is supposed to detect the
> remote wakeup sent by the external hub all by itself.
> 
>> Failing case
>> ------------
>>
>> [   16.108032] usb usb1: usb auto-resume
>> [   16.108062] ehci-omap 48064800.ehci: resume root hub
>> [   16.108154] hub 1-0:1.0: hub_resume
>> [   16.108398] ehci_hub_control GetPortStatus, port 1 temp = 0x1000
>> [   16.108459] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
> 
> Here's where we should detect it.  Look at the GetPortStatus case in
> ehci_hub_control(); the PORT_RESUME bit (0x0040) is set in temp, so the
> "Remote Wakeup received?" code should run.  In particular, these lines
> should run:
> 
> 			/* resume signaling for 20 msec */
> 			ehci->reset_done[wIndex] = jiffies
> 					+ msecs_to_jiffies(20);
> 			usb_hcd_start_port_resume(&hcd->self, wIndex);
> 			/* check the port again */
> 			mod_timer(&ehci_to_hcd(ehci)->rh_timer,
> 					ehci->reset_done[wIndex]);
> 
> Therefore 20 ms later, around timestamp 16.128459,
> ehci_hub_status_data() should have been called.  At that time, the
> root-hub port should have been fully resumed.
> 
>> [   16.108551] hub 1-0:1.0: port 2: status 0507 change 0000
>> [   16.108612] ehci_hub_control GetPortStatus, port 3 temp = 0x1000
>> [   16.108642] hub 1-0:1.0: hub_activate submitting urb
>> [   16.109222] ehci_irq port 3 pstatus 0x1000
>> [   16.109222] ehci_irq port 2 pstatus 0x14c5
>> [   16.109252] ehci_irq port 1 pstatus 0x1000
>> [   16.109374] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
> 
> But apparently nothing happened.  Why not?  Did the rh_timer get reset?  
> Maybe you can find out what went wrong.
> 
> (Hmmm, we seem to be missing a
> 
> 			set_bit(wIndex, &ehci->resuming_ports);
> 
> line in there...)
> 

Right. This is indeed the problem. I've cooked up a patch for that and will send
it separately in a moment.

cheers,
-roger
