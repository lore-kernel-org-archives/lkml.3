Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaGWFkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:40:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50715 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaGWFkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:40:04 -0400
MIME-Version: 1.0
In-Reply-To: <53CF305A.6080007@roeck-us.net>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
 <1406013463-19218-4-git-send-email-acourbot@nvidia.com> <20140722201740.GA11459@roeck-us.net>
 <CAAVeFuJAudOY-s3x38sv13SNo8zfofLWKOKBhKQPYAm1fAj4kw@mail.gmail.com> <53CF305A.6080007@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 23 Jul 2014 14:39:43 +0900
Message-ID: <CAAVeFu+fCq5e=YinNk++10oJPv8R2LeTbYV=6G95WSuw1f9_gQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] gpio: make gpiochip_get_desc() gpiolib-private
To: Guenter Roeck <linux@roeck-us.net>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:47 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/22/2014 08:10 PM, Alexandre Courbot wrote:
>>
>> On Wed, Jul 23, 2014 at 5:17 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> On Tue, Jul 22, 2014 at 04:17:41PM +0900, Alexandre Courbot wrote:
>>>>
>>>> As GPIO descriptors are not going to remain unique anymore, having this
>>>> function public is not safe. Restrain its use to gpiolib since we have
>>>> no user outside of it.
>>>>
>>> If I implement a gpio chip driver built as module, and I want to use
>>> gpiochip_request_own_desc(), how am I supposed to get desc ?
>>>
>>> I understand that there is still gpio_to_desc(), but I would have thought
>>> that
>>>          desc = gpiochip_get_desc(chip, pin);
>>> would be better than
>>>          desc = gpio_to_desc(chip->base + pin);
>>>
>>> Not that it makes much of a difference for me, just asking.
>>
>>
>> Actually I was thinking of changing the prototype of
>> gpiochip_request_own_desc(), and your comment definitely strenghtens
>> that idea. gpiochip functions should not work with descriptors,
>> especially since we are going to switch to a multiple-consumer scheme
>> where there won't be any canonical descriptor anymore. Thus, how about
>> turning gpiochip_request_own_desc() into this:
>>
>> struct gpio_desc *
>> gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum, const char
>> *label);
>>
>> which would basically do both the gpiochip_get_desc() and former
>> gpiochip_request_own_desc() in one call. I think it should satisfy
>> everybody and removes the need to have gpiochip_get_desc() (a not very
>> useful function by itself) exposed out of gpiolib.
>>
>> I will send a patch taking care of this if you agree that makes sense.
>>
>
> I think you also plan to remove the capability to retrieve the chip
> pointer, don't you ? If so, I won't be able to use the function from
> the pca953x platform init function, since I won't be able to get the
> pointer to the gpio chip. Even if you don't remove gpiod_to_chip(),
> things would become a bit messy, since I would first have to convert
> a pin to a desc and then to the chip pointer. Anyway, that change
> would mean that exporting gpiochip_request_own_desc or its replacement
> won't solve one of the problems addressed by my patch anymore, leaving
> me more or less in the dark :-(.

Here is why this change is taking place: right now you have a clear
descriptor/pin mapping, i.e. there is only one descriptor per pin,
anytime. For various reasons this is going to change soon, and
descriptors will be allocated the provided to GPIO consumers as an
abstraction of the pin. Meaning that you cannot really "get the
descriptor for that pin" anymore. Since gpiochip_request_own_desc()'s
purpose is precisely to request one descriptor for drivers to use, the
new prototype makes much more sense IMHO.

Another reason to have it work on a gpio_chip is that the gpio_chip
pointer is a token to doing certain "priviledged" operations. Like
obtaining an arbitrary descriptor. If consumers can get a pointer to
the gpio_chip of a descriptor, this means they can basically do
anything.

Being in the board code, it seems to be that you are in a good
position to obtain a pointer to the gpio_chip, and without knowing
better I'd say that's what you should try to do. But maybe I would
understand your problem better if you could post a small patch of what
you want to achieve here.

>
> I was thinking about implementing a separate platform driver which
> would enable me to auto-export (or initialize, if needed) gpio pins
> from arbitrary gpio drivers to user space. I could make this work
> with both devicetree data and platform data. Sure, that driver
> would not have a chance to get accepted upstream, since it would use
> devicetree data to, in a sense, configure the system, but on the
> upside it would be independent of gpio API changes, and it would
> work for _all_ gpio chips, not just for the ones with gpio driver
> support. Unfortunately this approach doesn't really work either,
> since exported pin names need to be configured with the chip driver,
> and can not be selected afterwards when a pin is actually exported.
>
> On the other side, would you agree to adding something like
> gpiod_export_name(), which would export a gpio pin with given name,
> not using the default or chip->names ? That might help solving
> at least some of my problems, and I would no longer depend on
> gpiochip_request_own_desc or any of the related functions.

Isn't that what gpiod_export_link() does?

>
> For reference, I currently need the ability to auto-export
> gpio pins to user space for pca953x, ich, and for various
> to-be-published gpio drivers used by my employer.

Under which criteria are the GPIOs auto-exported? Can't you have the
board code simply request all the GPIOs as a regular consumer and
export them to user-space?
