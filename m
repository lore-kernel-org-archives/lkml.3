Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3G3VKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:10:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35050 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab3G3VKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:10:38 -0400
Message-ID: <51F82BCC.1080409@codeaurora.org>
Date: Tue, 30 Jul 2013 14:10:36 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        ext Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
In-Reply-To: <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 9:37 AM, Linus Walleij wrote:
> On Wed, Jul 24, 2013 at 11:41 PM, Hanumant Singh
> <hanumant@codeaurora.org> wrote:
>
>> Add a new device tree enabled pinctrl driver for
>> Qualcomm MSM SoC's. This driver provides an extensible
>> framework to interface all MSM's that use a TLMM pinmux,
>> with the pinctrl subsytem.
>>
>> This driver is split into two parts: the pinctrl interface
>> and the TLMM version specific implementation. The pinctrl
>> interface parses the device tree and registers with the pinctrl
>> subsytem. The TLMM version specific implementation supports
>> pin configuration/register programming for the different
>> pin types present on a given TLMM pinmux version.
>>
>> Add support only for TLMM version 3 pinmux right now,
>> as well as, only two of the different pin types present on the
>> TLMM v3 pinmux.
>> Pintype 1: General purpose pins.
>> Pintype 2: SDC pins.
>
> I guess this is the v4 patch set?
>
> Please include a small changelog so I can keep track of
> things...
>
>
>> Change-Id: I065d874cd2c6fd002d5b3cb4b355445bb6912bf4
>
> This thing is not interesting to the kernel community.
>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
>> new file mode 100644
>> index 0000000..0f17a94
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
>
> This needs to be broken out and sent for separate review on
> the devicetree@vger.kernel.org mailing list.
>
>> +Required Properties
>> +  - qcom,pin-type-*: identifies the pin type. Pin types supported are
>> +                       qcom,pin-type-gp (General purpose)
>> +                       qcom,pin-type-sdc (SDC)
>
> I am wondering if it it would not be simpler to split this
> driver in two, one for the GP pins and one for the SDC pins.
> Having this tag on each and every pin seems *very*
> awkward.
>
> If you have two drivers and two device tree nodes, one for
> GP pins and one for SDC pins, just separated by different
> compatible strings and different memory regs, things will
> look simpler and be easier to maintain I think.
>
> Unless there is some strong cross-dependency between
> GP and SDC please explore this approach.

Actually we have had this discussion.
There are more pin types on a TLMM then just these 2.
The registers are interleaved.
They are no separated at a clean page boundary.
Also there is mode register that governs the function mode of the 
"unifunction"/single function pins like SDC. This register is again 
interspersed in the address map.
Having it the way it is right now, will help me add clean support for
other pintypes on a given TLMM version.

>
>> +- Pin groups as child nodes: The pin mux (selecting pin function
>> +  mode) and pin config (pull up/down, driver strength, direction) settings are
>> +  represented as child nodes of the pin-controller node. There is no limit on
>> +  the count of these child nodes.
>> +
>> +  Required Properties
>> +    -qcom,pins: phandle specifying pin type and a pin number.
>> +    -qcom,num-grp-pins: number of pins in the group.
>> +    -label: name to to identify the pin group.
>> +
>> +  Optional Properties
>> +    -qcom,pin-func: function setting for the pin group.
>
> After some scratching my head I realize that you are trying
> to reimplement parts of pinctrl-single.c.
>
> I.e. you try to put all the definitions of groups and functions
> into the devicetree instead of having this in the driver
> as tables.
>
> If this is what you want to do you should use pinctrl-single.c.
> It might be possible to use pinctrl-single.c only for the
> GP pins.
I would prefer not to split the driver into one driver for its own 
pintype for above reasons.
Also there isn't just one register per pin for gp pins, there are more 
registers.
For example to configure direction, I have to touch additional registers
then just the config register.
Also for future TLMM version, we are very likely to move away from 
single config register.
>
> But if there is something complex about the hardware that
> make pinctrl-single.c not fit the bill I advice you to encode
> the lists of groups and functions into the driver instead.
>
> Also, split this in a per-soc manner (compare the other
> drivers) so you can support plugging one file per SoC
> for the different MSM chips using this pin controller.
>
We actually have the same TLMM pinmux used by several socs of a family.
The number of pins on each soc may vary.
Also a given soc gets used in a number of boards.
The device tree for a given soc is split into the different boards that 
its in ie the boards inherit a common soc.dtsi but have separate dts.
The boards for the same soc may use different pin groups for 
accomplishing a function, since we have multiple i2c, spi uart etc
peripheral instances on a soc. A different instance of each of the above 
peripherals, can be used in different boards, utilizing different
or subset of same pin groups.
Thus I would need to have multiple C files for one soc, based on the 
boards that it goes into.

Thanks
Hanumant


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
