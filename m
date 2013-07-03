Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3GCJOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:14:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37684 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3GCJOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:14:22 -0400
Message-ID: <51D3EB53.7080803@ti.com>
Date: Wed, 3 Jul 2013 12:13:55 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 08:17 PM, Alan Stern wrote:
> On Tue, 2 Jul 2013, Roger Quadros wrote:
> 
>> On 07/02/2013 12:01 AM, Alan Stern wrote:
>>> On Mon, 1 Jul 2013, Felipe Balbi wrote:
>>>
>>>>> I don't know what Pad wakeup is.  The wakeup signal has to originate 
>>>>> from the EHCI controller, doesn't it?  If not, how does the Pad know 
>>>>> when a wakeup is needed?
>>>>
>>>> That's really an OMAP thing, I guess. Pad wakeup sits in the PRCM (IIRC)
>>>> inside and always on power domain. EHCI sits in another power domain
>>>> which be turned off. When it's turned off (power gated and clock gated)
>>>> the EHCI block has no means to wakeup whatsoever. That's when pad wakeup
>>>> comes into play. It is generated when PRCM sees a change in the actual
>>>> pad of the die. To check who should 'own' the wakeup, it checks the
>>>> muxing settings to verify whose pad is that.
>>>
>>> How does the PRCM know which changes should generate wakeup events?  
>>
>> It doesn't know. It will always generate a wakeup on any change in the monitored pins.
>> We can only configure which pins we want to monitor.
>> So we can't choose which wakeup events we want to monitor. We just can
>> enable or disable all events.
>>
>>> In the EHCI controller, this is managed by the settings of the WKOC_E,
>>> WKDSCNNT_E, and WKCNNT_E bits in the PORTSC registers.  But if EHCI is
>>> powered off, those bits can't be used.
>>
>> Is "powered off" same as ehci_suspend? If yes then how does it work on other systems
>> for remote wakeup?
> 
> Above, Felipe wrote that on OMAP, EHCI sits in a power domain which is
> turned off: power gated and clock gated.  ehci_suspend() doesn't do
> those things, but they are what I was referring to.

OK right, those things are done by OMAP platform support code.
> 
> A PCI-based EHCI controller has two power sources: the core well (which
> is turned off during suspend) and the auxiliary well (which remains
> powered).  That's how remote wakeup works; it uses the auxiliary well.
> 

OK. Thanks for the info.

>>> Also, once the wakeup signal has been turned on, how does it get turned 
>>> off again?
>>
>> That is taken care of by the OMAP pinctrl driver. It will always turn off the
>> wakeup signal once the event is detected and forwarded as an IRQ.
>>
>> I know that all this is a bit ugly :(.
> 
> I still a little confused.  The wakeup signal turns on.  Then the
> pinctrl driver sees it, forwards it as an IRQ, and turns the wakeup
> signal off.  But what if the IRQ is disabled (as it would be with your
> patch)?  Does the IRQ line remain active until it causes an interrupt?  
> What eventually turns off the IRQ line?
> 

In the beagle/panda board, the USB lines of the OMAP are used in ULPI mode.
Here we are monitoring DATA0, DATA1 and DATA3 lines which get configured as Linestate
and Interrupt of the PHY device whenever the PHY is put into suspend mode. This usually
happens when we suspend the EHCI controller.

When EHCI is suspended, the pinctrl wakeup mechanism is active. Whenever there is
a change in the monitored lines we get the PAD IRQ and hence the EHCI IRQ. We don't really
care much about which line changed state.
(NOTE: while suspending, we didn't disable the EHCI IRQ). So we will always get the first IRQ
and then we disable it and queue a hub_resume_work.
Then EHCI resumes, pinctrl wakeup is disabled and EHCI IRQ is enabled.

When pinctrl wakeup mechanism is active, it clears the wakeup event flag after a PAD IRQ, but it
has no control on disabling the interrupt source. If there is a change in the pad, the
PAD IRQ will fire again.

cheers,
-roger
