Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3ETID2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:03:28 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:65148 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3ETIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:03:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130515094146.GA19925@ab42.lan>
References: <516EEAA0.10906@wwwdotorg.org>
	<20130418090310.GA17636@ab42.lan>
	<CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
	<20130429161725.GB30136@ab42.lan>
	<5182B557.4040804@wwwdotorg.org>
	<CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
	<20130508164123.GA10248@ab42.lan>
	<518AAF31.8080502@wwwdotorg.org>
	<20130510082521.GA2125@ab42.lan>
	<CACRpkdbkqzyr0r0CostUx9RYa=pyPoyVvvW+VxEzyAYSESxp_g@mail.gmail.com>
	<20130515094146.GA19925@ab42.lan>
Date: Mon, 20 May 2013 10:03:24 +0200
Message-ID: <CACRpkdY2R9uf0s6LGVCSPZmdNTDQV4RT65SuxCR_+hQ2eK90Yg@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:41 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> On Tue, May 14, 2013 at 02:29:46PM +0200, Linus Walleij wrote:

>> Look at for example
>> drivers/pinctrl/pinctrl-abx500.c:
>>
>> static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
>>                           unsigned gpio)
>> {
>> (...)
>>         /* on ABx5xx, there is no GPIO0, so adjust the offset */
>>         unsigned offset = gpio - 1;
>>
>> As you can see, this driver, which does not use device tree,
>> is working around the same problem. Here the problem is that
>> the pins are numbered starting at 1 instead of 0, a very trivial
>> numberspace shuffleing.
>
> Let me see if I understand this right:
> In ABx5xx, the pin numbering is offset by 1 wrt. GPIO numbering?

No, sorry that the code is strange... The variable is named "gpio"
because that is the numbering used in the data sheet.

Think of "gpio" as "the number in the data sheet".

Then offset is calculated to start from 0.

>> I'd be open to this approach if you:
>>
>> - Make it generic for all pinctrl drivers, i.e. add the translation
>>   to the core so it does not just apply to devices using device tree.
>
> Do you mean what would be required here is a generic way to translate
> pin numbers to GPIO numbers in the pin controller?

No that is already done by the GPIO ranges.

I thought this discussion was about shuffleing around/translating
the numberings of the pins themselves.

> This translation is currently achieved by the gpio_range mechanism.

Yep.

> Internals of gpio_range leak into the pinctrl drivers and are bypassed
> in many cases. E.g. pinctrl-abx500.c uses an internal reimplementation
> of gpio ranges and the offset by one instead of the information in the
> pinctrl_gpio_range structure.

It has abx500_pinrange to associate some information with certain
ranges of pins. It has nothing to do with GPIO ranges if you look
closer at it.

The offset by one is achieved not by this range type, but by hard-coding
a subtraction with one at every entry point, as illustrated. This
is orthogonal to all range concepts.

> Mapping pin numbers to GPIO numbers in the pin controller would have the
> following advantages:
>  - It makes GPIO numbering well defined which is clearly an advantage
>    for the /sys/class/gpio interface: GPIO numbering is now controlled
>    by the pinctrl driver author and no longer needs to be kernel
>    internal.
>  - The device tree/acpi issue is solved since a GPIO controller could
>    now define its range in GPIO number space (which becomes public)
>    rather than kernel-internal pin number space. At least for our
>    products, GPIO numbering generally doesn't change between different
>    variants of the same chip and the /sys/class/gpio customer
>    documentation would apply to device also.

This is getting very confused so I can't follow it.

For the GPIO and pin control subsystems there exist three things:

- Local offsets on the GPIO controller, such as if there is a
  GPIO controller for 32 lines represented by 32 bits, offset
  0 .. 31.

- The global GPIO number space, which is a big array with
  some roof, where the GPIO numbers are shoehorned in,
  trying not to collide.

- Local offsets on the pin controller, which work the same way
  as GPIO local offsets.

I think you are talking about something completely different
here, and that might be the numbering scheme used in the
data sheet, or device tree is this correct? Please call that
the data sheet or device tree numbering system in that
case, or it will be very confusing for me. To me all
"GPIO numbers" are pure kernel concepts.

If you mean that you try to map the global GPIO number space
1:1 on top of what your datasheet has, just *don't do that*.
Because we want to get rid of this global GPIO numberspace.
Alexandre is already working hard on this!

Can you please try to be very specific on what is
going on here?

>  - The custom logic inside many pinctrl drivers would be confined in one
>    translation function the driver provides instead of being spread out
>    all over the driver.
>  - "Sparse GPIO ranges" are easy to implement if required by the
>    platform/driver.

This looks good.

>> - Augment the pinctrl-abx500.c driver to show how this simplifies
>>   that driver. (Does not need to be perfect, I'll help out finalizing it
>>   for sure.)
>
> The issue is that such a change is quite fundamental, all pinctrl
> drivers would have to be upgraded (not just pinctrl-abx500.c) and struct
> pinctrl_gpio_range would have to be removed from the gpio_request_enable
> callback and friends in favour of some generic translation mechanism.

Doing large refactorings is a normal part of kernel life.
See: Documentation/stable_api_nonsense.txt

> I am also afraid that the custom logic in many drivers could only be
> rewritten with the help of the respective driver's author.

If you're patching their drivers they are obliged to help out
by reviewing and testing, that is how we work. If they don't
review and test patches to their own code, they obviously do
not care if we break it either. All testing in linux-next and the
release cycle is about being able to change things if need be.

>> - Then add DT-specific wrapper using this core feature.
>
> GPIO ranges definitions in DT would probably be no longer be compatible
> with previous definitions since the number space would change from pin
> numbers to GPIO numbers. I don't think this is acceptable.

I can't see why you're saying this. Please elaborate.

What I hear is that DT need a translation mechanism, and
what I say is that OK, implement that in the core then, the
semantic effect will be the same.

>> This way the problem will be solved for everybody, including
>> ACPI when they sooner or later come back with the same issue.
>
> Given the issues highlighted above I'm not sure if I understand your
> proposal correctly. Although I see the advantages, I wonder if the
> migration to such a system is feasible in practise.

We need to iterate this discussion a few turns until I actually
understand your problem I think.

Yours,
Linus Walleij
