Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbbAMI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:26:00 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:65392 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbAMIZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:25:58 -0500
MIME-Version: 1.0
In-Reply-To: <54B0201E.3000307@broadcom.com>
References: <rjui@broadcom.com>
	<1417131990-17954-1-git-send-email-rjui@broadcom.com>
	<1417131990-17954-3-git-send-email-rjui@broadcom.com>
	<CACRpkdbZx1hcvd-q9AL3FPQRqU+wJjeSV8AdSno5PVr+fqhpRQ@mail.gmail.com>
	<54B0201E.3000307@broadcom.com>
Date: Tue, 13 Jan 2015 09:25:57 +0100
Message-ID: <CACRpkdZUaB-tt2N0dbaV5RkVS5PuFi63TqgOg15Jb2ACH52Yug@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: cygnus: add initial pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Sherman Yin <syin@broadcom.com>, Simon Arlott <simon@fire.lp0.eu>,
        Chris Boot <bootc@bootc.net>, Stephen Warren <swarren@wwwdotorg.org>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 7:38 PM, Ray Jui <rjui@broadcom.com> wrote:
> On 1/9/2015 3:03 AM, Linus Walleij wrote:
>> On Fri, Nov 28, 2014 at 12:46 AM, Ray Jui <rjui@broadcom.com> wrote:

>> I don't know if the hardware has any similarity though, so invite
>> the authors of the previous drivers to review this code.
>>
> They are completely different. The only similarity between Cygnus and
> bcm281xx pinctrl is that they use the same concept of alternation
> functions (1, 2, 3, 4) for mux configuration.

Then you can probably look at that driver for inspiration on how to handle
the situation you described earlier with collissions.

>>> +/*
>>> + * List of groups of pins
>>> + */
>>> +static const unsigned gpio0_pins[] = { 12 };
>>> +static const unsigned gpio1_pins[] = { 13 };
>>> +static const unsigned gpio2_pins[] = { 14 };
>>> +static const unsigned gpio3_pins[] = { 15 };
>>> +static const unsigned gpio4_pins[] = { 16 };
>>> +static const unsigned gpio5_pins[] = { 17 };
>>> +static const unsigned gpio6_pins[] = { 18 };
>>> +static const unsigned gpio7_pins[] = { 19 };
>>> +static const unsigned gpio8_pins[] = { 20 };
>>> +static const unsigned gpio9_pins[] = { 21 };
>>> +static const unsigned gpio10_pins[] = { 22 };
>>> +static const unsigned gpio11_pins[] = { 23 };
>>> +static const unsigned gpio12_pins[] = { 24 };
>>> +static const unsigned gpio13_pins[] = { 25 };
>>> +static const unsigned gpio14_pins[] = { 26 };
>>> +static const unsigned gpio15_pins[] = { 27 };
>>> +static const unsigned gpio16_pins[] = { 28 };
>>> +static const unsigned gpio17_pins[] = { 29 };
>>> +static const unsigned gpio18_pins[] = { 30 };
>>> +static const unsigned gpio19_pins[] = { 31 };
>>> +static const unsigned gpio20_pins[] = { 32 };
>>> +static const unsigned gpio21_pins[] = { 33 };
>>> +static const unsigned gpio22_pins[] = { 34 };
>>> +static const unsigned gpio23_pins[] = { 35 };
>>
>> Have you considered implementing .gpio_request_enable()
>> and .gpio_disable_free() to get around having to have one
>> group for each GPIO line?
>>
> Okay the Cygnus pin controller is really a mess. GPIO 0 ~ GPIO23 are
> really 23 distinct groups, each with one pin. Then the rest of GPIOs go
> under other groups. In general, when we set a group to alternate
> function 4, all pins become GPIO.

It will require some complicated code no matter how you
handle it I'm afraid. Rely on the pin control subsystem
to handle collisions though.

>>> +static const unsigned qspi_gpio_pins[] = { 108, 109 };
>>> +static const unsigned smart_card0_fcb_pins[] = { 45 };
>>> +static const unsigned smart_card1_fcb_pins[] = { 51 };
>>> +static const unsigned gpio0_3p3_pins[] = { 176 };
>>> +static const unsigned gpio1_3p3_pins[] = { 177 };
>>> +static const unsigned gpio2_3p3_pins[] = { 178 };
>>
>> Looks good...
>>
> Note these pins are definitions in the driver that help to describe the
> pad layout. We can't really configure any individual pins in Cygnus.

Yeah it's a groupwise controller then, that's similar to
e.g. the coh901 driver.

We should be able to accomodate this...

>>> +static int cygnus_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
>>> +               struct device_node *np, struct pinctrl_map **map,
>>> +               unsigned *num_maps)
>>> +{
>>
>> After Sören Brinkmanns patches youy should be able to use core
>> functions for this and avoid this code altogether.
>
> Will that help to take care our case, based on the way we will use
> "function" and "group"?

groupS but yes it will work with your controller, though I think
.set_mux and the controller state will need some elaborate code
to handle what the framework requests.

>>> +       num_groups = of_property_count_strings(np, "brcm,groups");
>>
>> As mentioned, just "groups".
>>
> I guess I will use "group"?

No groups, as with the standard attribute "gpios", this may be
a single group too, it's just a standard binding.

Yours,
Linus Walleij
