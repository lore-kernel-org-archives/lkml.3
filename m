Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab3ICR1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:27:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59603 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3ICR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:27:18 -0400
Message-ID: <52261BF0.4090106@wwwdotorg.org>
Date: Tue, 03 Sep 2013 11:27:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <521FE637.3010805@collabora.co.uk> <5220F8AE.2080300@wwwdotorg.org> <1521079.WSLhhfqBXl@lem-wkst-02>
In-Reply-To: <1521079.WSLhhfqBXl@lem-wkst-02>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 03:25 AM, Lars Poeschel wrote:
> Am Freitag, 30. August 2013, 13:55:26 schrieb Stephen Warren:
>> On 08/29/2013 06:24 PM, Javier Martinez Canillas wrote:
>> ...
>>
>>> We have been trying to solve this issue for a few months by now and Linus'
>>> approach seems to be the most sensible solution to me.
>>>
>>> Drivers that request an IRQ and assume that platform code will request and
>>> setup the GPIO have been broken since the boards using these drivers were
>>> migrated to DT (e.g: smsc911x on OMAP2+ boards).
>>
>> That's only true if the driver for the GPIO controller is buggy.
>> Whatever request_irq() maps down to in the GPIO/IRQ controller driver
>> simply needs to set up the pin as an interrupt input, then it doesn't
>> matter which order the driver does things.
> 
> Is it really that easy?

Yes.

> request_irq() should request the gpio and set it to input that it needs to 
> fulfill the irq request. That would then be the way to go for new drivers and 
> in the DT case.

Either explicitly request the GPIO, or simply directly program the HW in
whatever way is required for the pin to operate as an IRQ.

> Some leagcy drivers currently do this:
> 
> request_gpio(gpio);
> gpio_direction_input(gpio);
> request_irq(gpio_to_irq(gpio));
> 
> In that case request_irq should not fail because the driver is already the 
> correct owner of this gpio. But if some other entity owns this gpio it should 
> fail.

Yes.

> Also if I understand you correct the other way round should also possible:
> 
> request_irq(gpio_to_irq(gpio));
> request_gpio(gpio);
> gpio_direction_input(gpio);
> 
> request_irq() also requests the gpio then but the following request_gpio() 
> should also not fail.

I don't believe that code sequence is currently banned. If we want to
ban it, we should document that. Until this is documented as being
banned, I think we must fully support that code sequence.

> To have it work that way we have to track the owners of all requested gpios 
> somewhere. Or am I wrong here?
> Where and how to record these owners? Can gpio system achieve this? gpios are 
> requested without an owning device.

Yes. But, I believe we need to fully track every GPIO/IRQ owner already
right now; if a driver (not the GPIO/IRQ chip driver, but a driver that
uses the GPIOs/IRQs) calls gpio_request()/request_irq(), and this patch
has already requested them, then we already need to fully track GPIO/IRQ
ownership to make sure that the driver's own requests aren't failed
because the DT/GPIO core has already requested them on its behalf.
