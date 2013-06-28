Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3F1N6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:58:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54254 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3F1N6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:58:22 -0400
Message-ID: <51CD9663.6060806@ti.com>
Date: Fri, 28 Jun 2013 16:57:55 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306271032210.1167-100000@iolanthe.rowland.org> <51CD7FA1.3020005@ti.com>
In-Reply-To: <51CD7FA1.3020005@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 03:20 PM, Roger Quadros wrote:
> On 06/27/2013 06:40 PM, Alan Stern wrote:
>> On Wed, 26 Jun 2013, Roger Quadros wrote:
>>

>>> I updated the ehci-omap.c driver to call ehci_suspend/resume during runtime_suspend/resume.
>>> After that, it stopped detecting the port status change event when a device was plugged
>>> to an external HUB. The wakeup irq was coming and the root hub/controller were being resumed,
>>> but after that, no hub_irq.
>>
>> Wait a minute.  I'm not clear on what happened.  You're starting out
>> with the controller, the root hub, and the external hub all suspended, 
>> right?  Then you plugged a new device into the external hub.  This 
> 
> This is right.
> 
>> caused the controller and the root hub to wake up, but not the external 
>> hub?
>>
> Right. It seems the external hub has signaled remote wakeup but the kernel doesn't
> resume the root hub's port it is connected to.
> 
> By observing the detailed logs below you can see that the root hub does not generate
> an INTerrupt transaction to notify the port status change event. I've captured the pstatus
> and GetPortStatus info as well.
> 
> Failing case
> ------------
> 
> [   16.108032] usb usb1: usb auto-resume
> [   16.108062] ehci-omap 48064800.ehci: resume root hub
> [   16.108154] hub 1-0:1.0: hub_resume
> [   16.108398] ehci_hub_control GetPortStatus, port 1 temp = 0x1000
> [   16.108459] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
> [   16.108551] hub 1-0:1.0: port 2: status 0507 change 0000
> [   16.108612] ehci_hub_control GetPortStatus, port 3 temp = 0x1000
> [   16.108642] hub 1-0:1.0: hub_activate submitting urb
> [   16.109222] ehci_irq port 3 pstatus 0x1000
> [   16.109222] ehci_irq port 2 pstatus 0x14c5
> [   16.109252] ehci_irq port 1 pstatus 0x1000
> [   16.109374] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
> 
> Passing case
> ------------
> 
> / # [   19.704589] usb usb1: usb wakeup-resume
> [   19.709075] ehci-omap 48064800.ehci: omap_ehci_runtime_resume
> [   19.715423] usb usb1: usb auto-resume
> [   19.719299] ehci-omap 48064800.ehci: resume root hub
> [   19.724670] hub 1-0:1.0: hub_resume
> [   19.728424] ehci_hub_control GetPortStatus, port 1 temp = 0x1000
> [   19.734863] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
> [   19.741271] hub 1-0:1.0: port 2: status 0507 change 0000
> [   19.746948] ehci_hub_control GetPortStatus, port 3 temp = 0x1000
> [   19.753448] hub 1-0:1.0: hub_activate submitting urb
> [   19.759216] ehci_irq port 3 pstatus 0x1000
> [   19.763519] ehci_irq port 2 pstatus 0x14c5
> [   19.767822] ehci_irq port 1 pstatus 0x1000
> [   19.772155] hub 1-0:1.0: hub_irq 
> 
> <---This is the Port Status change hub INT which is missing in the failing case--->
> 
> [   19.775604] hub 1-0:1.0: hub_irq submitting urb
> [   19.780548] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0004
> [   19.786407] hub 1-0:1.0: hub_irq
> [   19.789916] hub 1-0:1.0: hub_irq submitting urb
> [   19.794799] ehci_hub_control GetPortStatus, port 2 temp = 0x14c5
> [   19.801147] ehci-omap 48064800.ehci: GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
> [   19.822937] usb 1-2: usb wakeup-resume
> [   19.826995] ehci_hub_control GetPortStatus, port 2 temp = 0x1005
> [   19.833404] usb 1-2: finish resume
> [   19.837738] hub 1-2:1.0: hub_resume
> [   19.841613] hub 1-2:1.0: port 1: status 0507 change 0000
> [   19.848358] hub 1-2:1.0: port 4: status 0101 change 0001
> [   19.962890] hub 1-2:1.0: hub_activate submitting urb
> [   19.968139] ehci-omap 48064800.ehci: reused qh dd450200 schedule
> [   19.974456] usb 1-2: link qh256-0001/dd450200 start 1 [1/0 us]
> [   19.980743] hub 1-0:1.0: resume on port 2, status 0
> [   19.985961] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
> [   19.991760] hub 1-2:1.0: state 7 ports 5 chg 0010 evt 0000
> [   19.997741] hub 1-2:1.0: port 4, status 0101, change 0000, 12 Mb/s
> [   20.083129] usb 1-2.4: new high-speed USB device number 4 using ehci-omap
> <snip>
> 
> One more thing is that the delay didn't help if I reduce printk verbosity to 7.
> So the debug prints are also adding some delays around the place which is affecting
> the behaviour.


Just found the problem. It seems that enabling the ehci_irq _after_ the root hub is resumed
is the root cause of the problem. Doing so will miss events from the root hub.

The following modification worked for me without any delays.

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 72df4eb..b3af1aa 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2136,11 +2136,6 @@ static void hcd_resume_work(struct work_struct *work)
 	usb_lock_device(udev);
 	usb_remote_wakeup(udev);
 	usb_unlock_device(udev);
-	if (HCD_IRQ_DISABLED(hcd)) {
-		/* Interrupt was disabled */
-		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
-		enable_irq(hcd->irq);
-	}
 }
 
 /**
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 593d28d..f2a1a46 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1110,6 +1110,12 @@ int ehci_resume(struct usb_hcd *hcd, bool hibernated)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 
+	if (HCD_IRQ_DISABLED(hcd)) {
+		/* Interrupt was disabled */
+		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		enable_irq(hcd->irq);
+	}
+
 	if (time_before(jiffies, ehci->next_statechange))
 		msleep(100);
 
cheers,
-roger
