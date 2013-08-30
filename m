Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3H3UIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:08:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44299 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3H3UIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:08:47 -0400
Message-ID: <5220FBC9.1070602@wwwdotorg.org>
Date: Fri, 30 Aug 2013 14:08:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <1507189.CRWvzVJqTV@flatron> <521548E3.6010703@wwwdotorg.org> <CACRpkdYUeyVZcN1-jOzg0zo4eSJK1S+M5fJ0FcMsgwaPKW4Obw@mail.gmail.com> <52167E5D.6060802@wwwdotorg.org> <CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com> <5217BD74.5030801@wwwdotorg.org> <CACRpkdYz7Kn-y8LHpNBV3YyYFhyaU6N592BJE1newUZJpUMNfA@mail.gmail.com>
In-Reply-To: <CACRpkdYz7Kn-y8LHpNBV3YyYFhyaU6N592BJE1newUZJpUMNfA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 01:00 PM, Linus Walleij wrote:
> On Fri, Aug 23, 2013 at 9:52 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/23/2013 12:45 PM, Linus Walleij wrote:
> 
>>> This is a perfectly OK thing to do as long as it is done like
>>> this:
>>>
>>> request_gpio(gpio);
>>> gpio_direction_input(gpio);
>>> request_irq(gpio_to_irq(gpio));
>>
>> But I'm not aware that there's a rule saying it's illegal to:
>>
>> request_irq(gpio_to_irq(gpio));
>> request_gpio(gpio);
>> gpio_direction_input(gpio);
> 
> No but I think there should be one ... maybe I'm an oddball
> but it seems natural to request a GPIO before tying
> IRQs to fire off it.

What if there is no GPIO?

There are plenty of chips with dedicated IRQ input pins that can't be
read as GPIOs, or treated as GPIOs in any way.

If a driver only needs IRQ input functionality, it should just request
an IRQ and be done with it. There should be no need at all for the
driver to know that the IRQ might be routed into a GPIO controller, and
hence that the driver may (or may not) need to additionally request the
GPIO before requesting the IRQ.

In other words, request_irq() must do everything necessary for the input
signal to operate as an IRQ input, irrespective of whether it might be
possible to use that input signal as a GPIO.

