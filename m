Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaGWDrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:47:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52672 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGWDro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:47:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CF305A.6080007@roeck-us.net>
Date: Tue, 22 Jul 2014 20:47:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] gpio: make gpiochip_get_desc() gpiolib-private
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com> <1406013463-19218-4-git-send-email-acourbot@nvidia.com> <20140722201740.GA11459@roeck-us.net> <CAAVeFuJAudOY-s3x38sv13SNo8zfofLWKOKBhKQPYAm1fAj4kw@mail.gmail.com>
In-Reply-To: <CAAVeFuJAudOY-s3x38sv13SNo8zfofLWKOKBhKQPYAm1fAj4kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 08:10 PM, Alexandre Courbot wrote:
> On Wed, Jul 23, 2014 at 5:17 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Tue, Jul 22, 2014 at 04:17:41PM +0900, Alexandre Courbot wrote:
>>> As GPIO descriptors are not going to remain unique anymore, having this
>>> function public is not safe. Restrain its use to gpiolib since we have
>>> no user outside of it.
>>>
>> If I implement a gpio chip driver built as module, and I want to use
>> gpiochip_request_own_desc(), how am I supposed to get desc ?
>>
>> I understand that there is still gpio_to_desc(), but I would have thought
>> that
>>          desc = gpiochip_get_desc(chip, pin);
>> would be better than
>>          desc = gpio_to_desc(chip->base + pin);
>>
>> Not that it makes much of a difference for me, just asking.
>
> Actually I was thinking of changing the prototype of
> gpiochip_request_own_desc(), and your comment definitely strenghtens
> that idea. gpiochip functions should not work with descriptors,
> especially since we are going to switch to a multiple-consumer scheme
> where there won't be any canonical descriptor anymore. Thus, how about
> turning gpiochip_request_own_desc() into this:
>
> struct gpio_desc *
> gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum, const char *label);
>
> which would basically do both the gpiochip_get_desc() and former
> gpiochip_request_own_desc() in one call. I think it should satisfy
> everybody and removes the need to have gpiochip_get_desc() (a not very
> useful function by itself) exposed out of gpiolib.
>
> I will send a patch taking care of this if you agree that makes sense.
>

I think you also plan to remove the capability to retrieve the chip
pointer, don't you ? If so, I won't be able to use the function from
the pca953x platform init function, since I won't be able to get the
pointer to the gpio chip. Even if you don't remove gpiod_to_chip(),
things would become a bit messy, since I would first have to convert
a pin to a desc and then to the chip pointer. Anyway, that change
would mean that exporting gpiochip_request_own_desc or its replacement
won't solve one of the problems addressed by my patch anymore, leaving
me more or less in the dark :-(.

I was thinking about implementing a separate platform driver which
would enable me to auto-export (or initialize, if needed) gpio pins
from arbitrary gpio drivers to user space. I could make this work
with both devicetree data and platform data. Sure, that driver
would not have a chance to get accepted upstream, since it would use
devicetree data to, in a sense, configure the system, but on the
upside it would be independent of gpio API changes, and it would
work for _all_ gpio chips, not just for the ones with gpio driver
support. Unfortunately this approach doesn't really work either,
since exported pin names need to be configured with the chip driver,
and can not be selected afterwards when a pin is actually exported.

On the other side, would you agree to adding something like
gpiod_export_name(), which would export a gpio pin with given name,
not using the default or chip->names ? That might help solving
at least some of my problems, and I would no longer depend on
gpiochip_request_own_desc or any of the related functions.

For reference, I currently need the ability to auto-export
gpio pins to user space for pca953x, ich, and for various
to-be-published gpio drivers used by my employer.

Thanks,
Guenter

