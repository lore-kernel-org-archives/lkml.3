Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3HUXXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:23:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43474 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3HUXXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:23:41 -0400
Message-ID: <52154BF9.1060704@wwwdotorg.org>
Date: Wed, 21 Aug 2013 17:23:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2] pinctrl: queue GPIO operations instead of defering
References: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org> <52126EDE.5060000@wwwdotorg.org> <CACRpkdasWurMctYTMZCHS+fwhvmnREaQD1vN54QYpMToTuFjsg@mail.gmail.com>
In-Reply-To: <CACRpkdasWurMctYTMZCHS+fwhvmnREaQD1vN54QYpMToTuFjsg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 05:07 PM, Linus Walleij wrote:
> On Mon, Aug 19, 2013 at 9:15 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/17/2013 08:56 AM, Linus Walleij wrote:
> 
>>> and the pin controller need the GPIO driver to be ready.
>>
>> Why does that happen?
> 
> The pin controller call back into the GPIO-side controller
> functions by utilizing the GPIO ranges.
> (Maybe the code is silly, I dunno, check drivers/pinctrl/pinctrl-nomadik.c)
> 
>>> This also happens if
>>> pin controllers and GPIO controllers compiled as modules
>>> are inserted in a certain order.
>>
>> Shouldn't deferred probe resolve that just fine, assuming there are no
>> circular dependencies?
> 
> The above leads to circular dependencies so that is what I'm
> trying to fix with this.

But the circular dependencies are imposed by a specific driver, not by
the GPIO and pinctrl subsystems.

gpiolib operations call into pinctrl to acquire pin ownership. Hence, no
pinctrl operation (or implementation in a driver) can call into gpiolib,
or a GPIO driver.

Shouldn't this simply be fixed inside whichever driver is performing
circular operations, rather than leaving the driver performing circular
operations, and attemping to make the subsystems support something that
can't be supported?

>>> On the Nomadik we get this situation with the pinctrl
>>> driver when moving to requesting GPIOs off the gpiochip
>>> right after it has been added,
>>
>> So, the pinctrl driver calls gpio_request()? Surely the solution is
>> simply not to do that?
> 
> This is what the other patch we're discussing is doing.
> The one that harvests and requests interrupt GPIO's when
> a gpiochip is added...

It would have been good to mention the two patches were related, or did
I just miss that?

So that's another reason for me to object to that other patch. If that
whole process was triggered inside the IRQ controller implementation,
which is logically part of the GPIO controller implementation for the
same HW, the call direction would also be GPIO -> pinctrl or IRQ -> GPIO
-> pinctrl, and hence have no circular issues.
