Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3FZRks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:40:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57917 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3FZRkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:40:46 -0400
Message-ID: <51CB279A.1090404@wwwdotorg.org>
Date: Wed, 26 Jun 2013 11:40:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
References: <20130618092516.GC18663@ab42.lan> <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com> <51C23222.2060906@wwwdotorg.org> <20130626115051.GC7095@ab42.lan>
In-Reply-To: <20130626115051.GC7095@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:50 AM, Christian Ruppert wrote:
> On Wed, Jun 19, 2013 at 04:35:14PM -0600, Stephen Warren wrote:
>> On 06/18/2013 03:29 AM, Christian Ruppert wrote:
>>> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
>>> Used to control the pinmux and is a prerequisite for the GPIO driver.
>>
>>> diff --git a/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt b/Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt
>>
>>> +Port definitions
>>> +----------------
>>> +
>>> +Ports are defined (and referenced) by sub-nodes of the pin controller. Every
>>> +sub-node defines exactly one port (i.e. a set of pins). Ports are predefined
>>> +as named pin groups inside the pin controller driver and these names are used
>>> +to associate pin group predefinitions to pin controller sub-nodes.
>>> +
>>> +Required port definition subnode properties:
>>> +  - pingrp: should be set to the name of the port's pin group.
>>
>> This seems odd.... More on that where I comment on the example.
>>
>>> +The following pin groups are available:
>>> +  - GPIO ports: gpioa_pins, gpiob_pins, gpioc_pins, gpiod_pins, gpioe_pins,
>>> +                gpiof_pins, gpiog_pins, gpioh_pins, gpioi_pins, gpioj_pins,
>>> +                gpiok_pins, gpiol_pins, gpiom_pins, gpion_pins
>> ...
>>> +  - JTAG: jtag_pins
>>
>> I'd suggest removing "_pins" from all those names, since it's the same
>> in all names and hence isn't necessary.
>>
>>> +GPIO ranges definition
>>> +----------------------
>>> +
>>> +The named pin groups of GPIO ports can be used to define GPIO ranges as
>>> +explained in Documentation/devicetree/bindings/gpio/gpio.txt.
>>
>> I wouldn't mention that here; the GPIO node contains the gpio-ranges
>> property, not the pin controller node. Hence, the binding for the GPIO
>> DT node should describe the property, not the binding for this node.
>>
>>> +Example
>>> +-------
>>> +
>>> +iomux: iomux@FF10601c {
>>> +	compatible = "abilis,tb10x-iomux";
>>> +	reg = <0xFF10601c 0x4>;
>>> +	pctl_gpio_a: pctl-gpio-a {
>>> +		pingrp = "gpioa_pins";
>>> +	};
>>> +	pctl_uart0: pctl-uart0 {
>>> +		pingrp = "uart0_pins";
>>> +	};
>>> +};
>>
>> The two nodes pctl-gpio-a and pctl-uart0 seem to be missing data. The
>> idea here is that you define nodes that says:
>>
>> * This node applies to these pin(s)/group(s).
>> * Select mux function X on those pins/groups and/or apply these pin
>> configuration options to those pins/groups.
>>
>> The examples above don't include any mux/config options, nor does the
>> binding say how to do specify them.
>>
>> The set of pin groups defined by this binding should correspond directly
>> to the set of pin groups that actually exist in HW. So, if you have 3
>> pin groups (A, B, C) in HW each of which has two mux functions (X, Y),
>> your DT binding should define just 3 pin groups (A, B, C), not 6 (A_X,
>> A_Y, B_X, B_Y, C_X, C_Y). In other words, the pin group name shouldn't
>> imply the mux function.
> 
> Can we consider it as agreed now that this implementation is acceptable
> for the TB10x pin controller?

There are two issues here:

1) What is a pin group:

1a) Must it solely represent a group of pins that actually exists in HW
(e.g. it's an RTL port, or a set of pins all controlled at once by a
single bit/field in a register)

1b) A SW-defined group of pins, simply because it's convenient to talk
about that set of pins at once, even though HW doesn't impose that those
pins are in a group in any way.

Defining groups for either of those reasons is fine, although this is
the area where my preference and LinusW's differ.

2) Can groups represent just a set of pins, or can it also imply that a
particular mux function is selected on that group?

I believe that both LinusW and I are in agreement that a group is simply
a list/set/group of pins. You select mux functions onto groups. A
groups's definition can't imply that a particular mux function is
selected onto it.

If we don't follow this rule, then you end up with a combinatorial
explosion of groups; the cross-product of all possible groups of pins
vs. the mux function to select on them, rather than simply having a list
of groups of pins, which is a much smaller set/list.

So, in the DT example above, I still believe that you need an extra
property that defines which mux function to select onto the specified
group. The group name can't imply this, so there needs to be some way of
specifying it.
