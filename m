Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaGIVS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:18:26 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:37650 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaGIVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
	<CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
Date: Wed, 9 Jul 2014 14:18:23 -0700
Message-ID: <CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
>
>> This introduced the device tree bindings for the gpio block found in
>> pm8018, pm8038, pm8058, pm8917 and pm8921 pmics from Qualcomm.
>>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> (...)
>> +- interrupts:
>> +       Usage: required
>> +       Value type: <prop-encoded-array>
>> +       Definition: Must contain an array of encoded interrupt specifiers for
>> +                   each available gpio
>
> So each GPIO has its own interrupt line looped back from the PMIC
> and into some other SoC or so handling the actual interrupt?
> This seems expensive? (Albeit efficient and fast.)
>
> (...)

Almost. The pmic have a shared interrupt and the pm8921-core driver has a
chained irq handler. Each gpio get it's own interrupt on that level.

>> +Please refer to pinctrl-bindings.txt in this directory for details of the
>> +common pinctrl bindings used by client devices, including the meaning of the
>> +phrase "pin configuration node".
>> +
>> +The pin configuration nodes act as a container for an abitrary number of
>> +subnodes. Each of these subnodes represents some desired configuration for a
>> +pin or a list of pins. This configuration can include the
>> +mux function to select on those pin(s), and various pin configuration
>> +parameters, s listed below.
>
> *is* listed below?
>

*as*

>> +The following generic properties as defined in pinctrl-bindings.txt are valid
>> +to specify in a pin configuration subnode:
>> +
>> +- pins:
>> +       Usage: required
>> +       Value type: <string-array>
>> +       Definition: List of gpio pins affected by the properties specified in
>> +                   this subnode.  Valid pins are:
>> +                       gpio1-gpio6 for pm8018
>> +                       gpio1-gpio12 for pm8038
>> +                       gpio1-gpio40 for pm8058
>> +                       gpio1-gpio38 for pm8917
>> +                       gpio1-gpio44 for pm8921
>
> I usually name pins with CAPITAL LETTERS so would be
> "GPIO1", "GPIO2" etc, lowercase may be confusing as these are
> names not functions or groups.
>

I was hoping to be able to follow the pattern used in pinctrl-msm; can I say
something nice to have you agree on this? There's no difference between pins
and groups here.

>> +- function:
>> +       Usage: optional
>> +       Value type: <string>
>> +       Definition: Specify the alternative function to be configured for the
>> +                   specified pins.  Valid values are:
>> +                       "normal",
>> +                       "paired",
>> +                       "func1",
>> +                       "func2",
>> +                       "dtest1",
>> +                       "dtest2",
>> +                       "dtest3",
>> +                       "dtest4"
>
> These are a bit ambigous, why doesn't the driver present functions that
> are more specific than "func1", "func2"? Or "dtest1"?
>

I agree, unfortunately I have only seen traces of the actual function matrix;
for pm8xxx I have no documentation and for pm8x41 they are only listed as
func[1-2] and dtest[1-4].

Maybe if someone at Qualcomm could release such a list we could provide a
proper table instead.

> I guess the following just redefines or extends the generic pinconf
> bindings (which is fully OK).
>
>> +- bias-disable:
>> +       Usage: optional
>> +       Value type: <none>
>
> Isn't the type simply bool?
>

No, the property is bool but the actual value is void. But looking an extra
time in the epapr I see that it's supposed to be "empty" - so will update.

[...]
>> +- bias-pull-up:
>> +       Usage: optional
>> +       Value type: <u32> (optional)
>> +       Definition: The specified pins should be configued as pull up. An
>> +                   optional argument can be used to configure the strength.
>> +                   Valid values are; as defined in
>> +                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
>> +                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
>> +                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
>> +                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
>> +                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
>
> Hm, I don't know of the internal kernel API or so, but I'm thinking that
> for the DT bindings, this definition should be generic in
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> and put in SI units like uA.
>

Totally agree with you; and this is already specified in pinctrl-binding.txt as
being Ohm.

So I first did a spin with the strength as a separate property, but as that
because the only part that pinconf-generic didn't parse for me I merged it and
wanted your comment on it.

> So I would prefer:
>
> bias-pull-up = <30>;
>

Yeah, but that's the easy one ;)

How do you say 1.5 or 31.5 and how do you differ that from 1.5 + 30 boot?

> for 30 uA. Maybe we want nA even? I'm uncertain about the proper granularity
> here :-/
>
> Magic enumerators 1,2,3,4 doesn't seem so good, that seems more like it's
> trying to match the magic value that is to be poked into a register or
> something like that.
>

The stuff going into the hardware is a value 0-3 for pull up; so these values
are "only" an enum with the additional benefit of saying "bias-pull-up;"
results in 30uA pull up which is the most commonly used form (hence being
optional).

[...]
>> +- drive-strength:
>> +       Usage: optional
>> +       Value type: <u32>
>> +       Definition: Selects the drive strength for the specified pins. Value
>> +                   drive strengths are:
>> +                       0: no   (PM8XXX_GPIO_STRENGTH_NO)
>> +                       1: high (PM8XXX_GPIO_STRENGTH_HIGH)
>> +                       2: medium       (PM8XXX_GPIO_STRENGTH_MED)
>> +                       3: low  (PM8XXX_GPIO_STRENGTH_LOW)
>
> I would really prefer to have these in mA, because the genric pinconf
> bindings say they should be! SI units are so much more understandable.
>

This is all the information to be found in the available documentation and
code. Maybe someone from Qualcomm can shed some light on it?

[...]
>> +
>> +       pm8921_gpio: gpio@150 {
>> +               compatible = "qcom,pm8921-gpio";
>> +               reg = <0x150>;
>> +               interrupts = <192 1>, <193 1>, <194 1>,
>> +                            <195 1>, <196 1>, <197 1>,
>> +                            <198 1>, <199 1>, <200 1>,
>> +                            <201 1>, <202 1>, <203 1>,
>> +                            <204 1>, <205 1>, <206 1>,
>> +                            <207 1>, <208 1>, <209 1>,
>> +                            <210 1>, <211 1>, <212 1>,
>> +                            <213 1>, <214 1>, <215 1>,
>> +                            <216 1>, <217 1>, <218 1>,
>> +                            <219 1>, <220 1>, <221 1>,
>> +                            <222 1>, <223 1>, <224 1>,
>> +                            <225 1>, <226 1>, <227 1>,
>> +                            <228 1>, <229 1>, <230 1>,
>> +                            <231 1>, <232 1>, <233 1>,
>> +                            <234 1>, <235 1>;
>
>
> So this looks a bit weird. But if I just get to understand the hardware
> I guess it won't anymore.
>
> So there is an interrupt parent to which the IRQ lines from the PMIC
> are routed back through external lines to IRQ offsets 192 thru 235?
>

The pm8921-core exposes 256 interrupts, the listed 44 interrupts here are what
comes out of that.

I was really reluctant to list all the interrupts, but I think it turned out
nicer than any of my other attempts; like only providing a base and then
relying on interrupts being consecutive.

Suggestions on how this "should" be solved are welcome, as we have the same
setup for the newer pmics (Ivan's patches) and the TLMM hardware (pinctrl-msm)
supports using dedicated interrupts for certain gpio pins (instead of passing
through the chain handler).

Regards,
Bjorn
