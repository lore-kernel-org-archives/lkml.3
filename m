Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3LBNpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:45:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45738 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3LBNpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:45:02 -0500
Message-ID: <529C8ED0.6060805@ti.com>
Date: Mon, 2 Dec 2013 15:44:48 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>, <tomi.valkeinen@ti.com>,
        Stefan Roese <sr@denx.de>, <ljkenny.mailinglists@gmail.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com> <529C76AF.10106@linutronix.de> <529C7922.5000601@ti.com> <529C854F.3010101@linutronix.de> <529C8CBD.4070003@ti.com> <529C8D74.10007@linutronix.de>
In-Reply-To: <529C8D74.10007@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 03:39 PM, Sebastian Andrzej Siewior wrote:
> On 12/02/2013 02:35 PM, Roger Quadros wrote:
>>> It refers to "Errata Id:i660" why it is required. Once you figured what
>>> why it has been added you could have an idea if it is okay to remove it
>>> and if the reset you do here might lead to it (I dunno).
>>>
>>
>> Keshava no longer works @TI. I have no other means to check why it was added
>> other than doing dome tests and making sure nothing breaks if we remove it.
>>
>> So far, things are going fine for about 50 or so boots divided between OMAP3 and 4
>> platforms. If more people can test and give feedback it'd be great.
> 
> Hmm. Can't you lookup the errata he revers to?
> 

Sure, but it was not making sense why RESET was avoided.
It doesn't say anything about not using RESET. In fact it says that RESET _is_ the
recovery procedure.

Pasting the errata description below for easy reference.

"Errata id: i660
DESCRIPTION
In the following configuration :
• USBHOST module is set to smart-idle mode
• PRCM asserts idle_req to the USBHOST module. (This typically happens when the system is going to
a low power mode : all ports have been suspended, the master part of the USBHOST module has
entered the standby state, and SW has cut the functional clocks.)
• an USBHOST interrupt occurs before the module is able to answer idle_ack, typically a remote wakeup
IRQ.
Then the USB HOST module will enter a deadlock situation where it is no more accessible nor functional.
The only way to recover will be to perform a software reset of the module.

WORKAROUND
The best workaround consists in switching the module to force idle mode right before cutting the
module's FCLK.
• the bus has reached the suspend state.
• write SYSCONFIG:Idlemode= ForceIdle and read it back to ensure the write has been taken into
account in case of posted writes.
• cut the FCLK
• Idle_req will be asserted and idle_ack answered within one L3 clock cycle.
Upon resume or remote wakeup, switch back the module to smart-idle.
This workaround reduces the failure window to only one L3 clock cycle. The probability for an interrupt to
fire at this exact time is considered extremely low, and the case has never been hit on board."

Based on this, I don't see anything wrong in Resetting the module at probe or at boot.

cheers,
-roger
