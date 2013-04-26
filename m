Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab3DZHrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:47:18 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53320 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3DZHrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130418090310.GA17636@ab42.lan>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
	<516EEAA0.10906@wwwdotorg.org>
	<20130418090310.GA17636@ab42.lan>
Date: Fri, 26 Apr 2013 09:47:16 +0200
Message-ID: <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:03 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> We would like to avoid the use of Linux pin numbers in the device tree.
> Customers are used to physical pin numbers and exposing the logical
> Linux-internal numbering scheme through the device tree would generate
> quite some confusion. There are two reasons why we cannot align the two:
>   - Not all products supported by these drivers have the same pin outs.
>   - GPIO ranges must be consecutive in the Linux pin numbering space
>     which is generally not the case in physical pin numbering.

If you are talking about the pin numbers really, i.e. the number we
put into

struct pinctrl_pin_desc {
        unsigned number; <- this
        const char *name;
};

Then are you aware that this is a sparse number space?

I.e. you can choose whatever number you want. You do not have
to offset numbers from zero or anything like that. You just
need to make sure the numbers do not overlap (no two pins
have the same number).

So if this is what you want to achieve, just use the same number
as in your datasheet in the pin number -> problem solved.

This may lead to some offsetting in your driver etc, and some
struggle do to that. Inspect drivers/pinctrl/pinctrl-abx500.c
for example. Here the datasheet offsets the pins from 1 rather
than from zero, so Patrice had to struggle when cross-mapping
these numbers, but it can surely be done.

> If I understand Documentation/devicetree/bindings/gpio/gpio.txt
> correctly, the "standard" gpio-ranges definition does use Linux logical
> pin numbers, however.

There is no requirement that pin numbers be different from the
datasheet "logical". It is OK to have a 1-1 mapping.

> This disqualifies gpio-ranges from being used in
> our device tree. I haven't found a clean way around this dilemma, thus
> the current implementation duplicating parts of the core system and
> cross-calling pinctrl from GPIO.

I think I have described a solution to this.

> I am well aware of the problem but I haven't found any documentation,
> core functions or examples which solve this. The most elegant way would
> be some core functionality allowing to define GPIO ranges by directly
> querying the pin data base (or to preregister GPIO ranges in the pin
> controller to which GPIO drivers can then "attach"). Is there something
> like this I have missed?

The current preferred pattern is to have the GPIO portions register
the ranges referring to the pin controller pin numbers.

This is because it enables us to only use controller-local
number spaces in both cases.

> As a side note, the same argument does not apply to gpio-base, btw, for
> two reasons:
>   - Our customer documentation does not talk about a global GPIO
>     numbering scheme. In our products, GPIOs are organised in banks and
>     there is no risk of confusion.

This is the local numbering used when registering ranges from
the GPIOlib side referred to above.

>   - The Linux-internal GPIO numbering is already exposed to customers
>     through the /sys/class/gpio interface.

Yeah this sucks but we have to live with it forever.

> That said, if we solve the cross-calling issue I can still move it to
> the pin data base in the next patch set since you are right that there
> is no real reason to make it "user-configurable" through DT.

I don't understand this.

(Questions answered I think ...)

>> Perhaps this "abilis,simple-default" thing is intended to represent some
>> specific default configuration? If so, I don't think that's the right
>> way to go. Also, the DT binding should be as complete as possible from
>> the start, rather than planning to define/implement part of it now and
>> then keep adding to it later. This all implies that some extra
>> properties really should be defined here.
>
> The abilis,simple-default thing is simply there because I missed commit
> ab78029ecc347debbd737f06688d788bd9d60c1d and followed
> Documentation/pinctrl.txt a bit too closely. ("So if possible, handle
> the pin control in platform code or some other place where you have
> access to all the affected struct device * pointers.") Currently, our
> platform code iterates through nodes compatible with
> abilis,simple-pinctrl and sets up the pin controller accordingly. I'll
> happily remove this mechanism.

Thanks!

Yours,
Linus Walleij
