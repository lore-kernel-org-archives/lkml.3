Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaE2WAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:00:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:60687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933019AbaE2WAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,936,1392192000"; 
   d="scan'208";a="539733576"
Message-ID: <5387AD34.8060408@linux.intel.com>
Date: Thu, 29 May 2014 14:57:08 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>,
        "Holmberg, Hans" <hans.holmberg@intel.com>
Subject: Re: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
References: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com> <CACRpkdaR0E_fnFZaX7zYmxtLjEuRKr_XW7B8HavpkkjArmy35A@mail.gmail.com>
In-Reply-To: <CACRpkdaR0E_fnFZaX7zYmxtLjEuRKr_XW7B8HavpkkjArmy35A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-29 06:44 AM, Linus Walleij wrote:
> On Tue, May 27, 2014 at 9:26 PM,  <eric.ernst@linux.intel.com> wrote:
>
>> From: Eric Ernst <eric.ernst@linux.intel.com>
>>
>> For Baytrail, you should never set a GPIO set to direct_irq
>> to output mode.  When direct_irq_en is set for a GPIO, it is
>> tied directly to an APIC internally, and making the pad output
>> does not make any sense. Assert a WARN() in the event this happens.
>>
>> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
> Can I get some ACK from the author's of this driver on Eric's patch?
>
> Eric, you *are* aware of what the gpio_lock_as_irq() and
> gpio_unlock_as_irq() in the .irq_request_resources are doing
> right? Is this patch just some extra safety measure?
>
> Yours,
> Linus Walleij
Linus, thanks for the feedback.

I do see the usage for gpio_lock_as_irq() and gpio_unlock_as_irq(), 
though I'm not sure if this would help me in this scenario.  I am adding 
an extra safety measure, as an attempt to check exactly how the GPIO pin 
was configured, possibly before kernel, before changing the direction to 
output.

In my situation, a device attached via GPIO will act as an IRQ, but also 
toggled as output during setup in order to communicate with the device 
(ugly device, i know).  Specifically for this pincntrl device on 
Baytrail, we need to make sure that if the pin were ever to be used for 
IO, that direct IRQ is not set in its config register (ie - don't handle 
the IRQ via the APIC).  This check and WARN is to look for that 
situation, and provide a caution to the user that what they're asking 
for isn't necessarily what they will be getting.
Thanks,
Eric
