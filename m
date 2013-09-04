Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3IDUQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:16:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38516 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab3IDUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:16:41 -0400
Message-ID: <52279524.8090006@wwwdotorg.org>
Date: Wed, 04 Sep 2013 14:16:36 -0600
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
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <1521079.WSLhhfqBXl@lem-wkst-02> <52261BF0.4090106@wwwdotorg.org> <3144247.j2q6H0KWZx@lem-wkst-02>
In-Reply-To: <3144247.j2q6H0KWZx@lem-wkst-02>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:05 AM, Lars Poeschel wrote:
> On Wednesday 04 September 2013 11:27:12, Stephen Warren wrote:
>> On 09/02/2013 03:25 AM, Lars Poeschel wrote:
>>> Some leagcy drivers currently do this:
>>>
>>> request_gpio(gpio);
>>> gpio_direction_input(gpio);
>>> request_irq(gpio_to_irq(gpio));
>>>
>>> In that case request_irq should not fail because the driver is already the
>>> correct owner of this gpio. But if some other entity owns this gpio it
>>> should fail.
>>
>> Yes.
>>
>>> Also if I understand you correct the other way round should also possible:
>>>
>>> request_irq(gpio_to_irq(gpio));
>>> request_gpio(gpio);
>>> gpio_direction_input(gpio);
>>>
>>> request_irq() also requests the gpio then but the following request_gpio()
>>> should also not fail.
>>
>> I don't believe that code sequence is currently banned. If we want to
>> ban it, we should document that. Until this is documented as being
>> banned, I think we must fully support that code sequence.
>>
>>> To have it work that way we have to track the owners of all requested
>>> gpios
>>> somewhere. Or am I wrong here?
>>> Where and how to record these owners? Can gpio system achieve this? gpios
>>> are requested without an owning device.
>>
>> Yes. But, I believe we need to fully track every GPIO/IRQ owner already
>> right now; if a driver (not the GPIO/IRQ chip driver, but a driver that
>> uses the GPIOs/IRQs) calls gpio_request()/request_irq(), and this patch
>> has already requested them, then we already need to fully track GPIO/IRQ
>> ownership to make sure that the driver's own requests aren't failed
>> because the DT/GPIO core has already requested them on its behalf.
> 
> The driver that tries to use the GPIO requested by this patch before HAS to 
> fail. This is exactly the intention of this patch. We don't want the GPIO to 
> be requested any more, if it is used as an interrupt pin.

That will break existing drivers. There are drivers that request the
same GPIO and IRQ. IIRC, the SDHCI CD (Card Detect) GPIO is requested
that way.

> To be able to implement the way you proposed some mails before, I have to be 
> able to do some checks that to my opinion (and if I understand Linus 
> correctly) aren't possible at the moment.

True.

> So I asked, where and how to record 
> these owners of the GPIOs? And can the GPIO system achieve this and how? Can 
> you please shed some light on this! Thanks!

Alex Courbot's (proposed) new gpiod API has a "dev" parameter to
gpiod_request() which could be used for this purpose. Something similar
could be done for interrupts.
