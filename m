Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3H2TAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:00:35 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39983 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab3H2TAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <5217BD74.5030801@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1507189.CRWvzVJqTV@flatron>
	<521548E3.6010703@wwwdotorg.org>
	<CACRpkdYUeyVZcN1-jOzg0zo4eSJK1S+M5fJ0FcMsgwaPKW4Obw@mail.gmail.com>
	<52167E5D.6060802@wwwdotorg.org>
	<CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com>
	<5217BD74.5030801@wwwdotorg.org>
Date: Thu, 29 Aug 2013 21:00:32 +0200
Message-ID: <CACRpkdYz7Kn-y8LHpNBV3YyYFhyaU6N592BJE1newUZJpUMNfA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 9:52 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/23/2013 12:45 PM, Linus Walleij wrote:

>> This is a perfectly OK thing to do as long as it is done like
>> this:
>>
>> request_gpio(gpio);
>> gpio_direction_input(gpio);
>> request_irq(gpio_to_irq(gpio));
>
> But I'm not aware that there's a rule saying it's illegal to:
>
> request_irq(gpio_to_irq(gpio));
> request_gpio(gpio);
> gpio_direction_input(gpio);

No but I think there should be one ... maybe I'm an oddball
but it seems natural to request a GPIO before tying
IRQs to fire off it.

Besides, the bug that this is trying to solve is due to the
fact that the OMAP driver require exactly the former order
for the IRQs to work. I think if the sequence matters it is
likely to be the first form, but it's a rough guess.

>> Pass only the GPIO in the device tree and this works just fine.
>
> And I wouldn't be surprised if there were DTs that had separate GPIO and
> interrupt entries for the same pin.

That is the situation we want to catch.

Don't you agree that it has some bit of ambiguity around it, like
the tree makes an assumtion that whether you ask for the GPIO
line or IRQ first does not matter, and leave it up to the driver to
"do something" if the order suddenly turns out the other way around,
but is important to the hardware?

I think we can't get away from the ambition to define this
semantic for all DT systems.

> In fact, it's arguably technically
> more correct to do that than just list the GPIO, and then hope the OS
> will be able to convert it to the correct IRQ. Then, drivers wouldn't
> have any reason to believe they needed a specific IRQ-vs-GPIO request
> ordering.

If that is more technically correct (hm I wonder what measure is
used for "correctness" here) I think we are back at the GPIO input
hogs to achive what OMAP needs. Using such hogs they can
let the gpiochip node hog a few pins and set them as input rather
than each and every driver having to do so.

Yours,
Linus Walleij
