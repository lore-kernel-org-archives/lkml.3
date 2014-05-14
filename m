Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaENF7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:59:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60087 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaENF7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:59:48 -0400
Message-ID: <5373064F.4000204@ti.com>
Date: Wed, 14 May 2014 11:29:43 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerq@ti.com>, <kishon@ti.com>
Subject: Re: [PATCH 5/5] usb: dwc3: dwc3-omap: Disable/Enable core interrupts
 in Suspend/Resume
References: <1399541587-14067-1-git-send-email-george.cherian@ti.com> <1399541587-14067-6-git-send-email-george.cherian@ti.com> <20140513155019.GN1151@saruman.home>
In-Reply-To: <20140513155019.GN1151@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 9:20 PM, Felipe Balbi wrote:
> Hi,
>
> On Thu, May 08, 2014 at 03:03:07PM +0530, George Cherian wrote:
>> Enabling the core interrupts in complete is too late for XHCI, and stops
>> xhci from proper operation. So remove prepare and complete and disable/enable
> isn't this a bug in xhci ? I mean the driver should make no assumption
> as to when IRQs are enabled, why do we need to enable IRQs earlier when
> the device is only considered "ready for use" after ->complete()
> finishes executing ?
I dont think its a bug in xhci. In case of xhci-pci driver it actually 
does an
hcd->driver->pci_suspend (xhci_suspend) followed by synchronize_irq()
and the does a pci_disable_device().  In resume path it calls 
pci_enable_device()
followed by hcd->driver->pci_resume(xhci_resume).

In case of dwc3-omap we do have a wrapper register which can still 
disable the XHCI IRQs
even though the xhci driver enables the interrupts internally.

Now dwc3-omap wrapper driver should not actually fiddle with the core 
Interrupt
enable/disable except in probe/remove.

>  From documentation we have:
>
> 107  * @complete: Undo the changes made by @prepare().  This method is executed for
> 108  *      all kinds of resume transitions, following one of the resume callbacks:
> 109  *      @resume(), @thaw(), @restore().  Also called if the state transition
> 110  *      fails before the driver's suspend callback: @suspend(), @freeze() or
> 111  *      @poweroff(), can be executed (e.g. if the suspend callback fails for one
> 112  *      of the other devices that the PM core has unsuccessfully attempted to
> 113  *      suspend earlier).
> 114  *      The PM core executes subsystem-level @complete() after it has executed
> 115  *      the appropriate resume callbacks for all devices.
>
> which tells me that using ->complete() to reenable IRQs is ok here.
> Specially when you consider that the role of ->prepare() is to prevent
> new children from being created and, for a USB host, that means we
> should prevent hub port changes.
Probably the patch should have been to still keep the complete/prepare 
in place
but not disable the core interrupts, rather enable/disable only the 
wrapper interrupt.
> cheers
>


-- 
-George

