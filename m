Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3EPAMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:12:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50824 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3EPAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:12:39 -0400
Message-ID: <51942472.9010402@wwwdotorg.org>
Date: Wed, 15 May 2013 18:12:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com> <516EEAA0.10906@wwwdotorg.org> <20130418090310.GA17636@ab42.lan> <CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com> <20130429161725.GB30136@ab42.lan> <5182B557.4040804@wwwdotorg.org> <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com> <20130508164123.GA10248@ab42.lan> <518AAF31.8080502@wwwdotorg.org> <20130510082521.GA2125@ab42.lan>
In-Reply-To: <20130510082521.GA2125@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 02:25 AM, Christian Ruppert wrote:
> On Wed, May 08, 2013 at 02:01:53PM -0600, Stephen Warren wrote:
>> On 05/08/2013 10:41 AM, Christian Ruppert wrote:
>> ...
>>> What do you think about the following modification to the pinctrl/GPIO
>>> frameworks instead (not yet a formal patch, more a request for comment
>>> to illustrate what I mean. If you agree, I will clean it up and submit a
>>> proper patch after discussion).
>>>
>>> It adds a dt_gpiorange_xlate function to the pinctrl callbacks which
>>> defaults to the conventional behaviour using kernel logical pin numbers.
>>> However, pin controllers which provide more complex mechanisms can
>>> define #gpio-range-cells and provide this callback in order to keep
>>> Linux pin numbering inside the kernel.
>>
>> Can you provide an example of the DT content, and explain exactly what
>> this patch does with it; what effect it has on the existing GPIO or
>> pinctrl code?
> 
> The patch does not change the default behaviour of the kernel: In case
> no dt_gpiorange_xlate callback is defined for a given driver (e.g. for
> pre-existing drivers), the default function simply interprets the first
> argument as Linux pin number and the second as pin count, same as now.
> New drivers can use the callback to translate device specific pin
> references to Linux pin numbers (in the idea of of_xlate in the GPIO
> framework or xlate in the irqchip framework).
> 
> In the case of TB10x, I was thinking of something in the lines of
> 
> iomux: iomux@FF10601c {
> 	#gpio-range-cells = <1>;   /* one cell used for gpiorange phandle */
> 	compatible = "abilis,tb10x-iomux";
> 	reg = <0xFF10601c 0x4>;
> 	pctl_gpio_a: pctl-gpio-a { /* define phandle to GPIOA I/O function */
> 		pingrp = "gpioa_pins";
> 	};

These aren't phandles at all; they're just plain old nodes and properties.

> 	pctl_gpio_b: pctl-gpio-b { /* define phandle to GPIOB I/O function */
> 		pingrp = "gpiob_pins";
> 	};
> 	pctl_uart0: pctl-uart0 {   /* define phandle to UART0 I/O function */
> 		pingrp = "uart0_pins";
> 	};
> };
> uart@FF100000 {
> 	compatible = "snps,dw-apb-uart";
> 	reg = <0xFF100000 0x100>;
> 	clock-frequency = <166666666>;
> 	interrupts = <25 1>;
> 	reg-shift = <2>;
> 	reg-io-width = <4>;
> 	pinctrl-names = "default";  /* For non-GPIO modules, request I/O */
> 	pinctrl-0 = <&pctl_uart0>;  /* functions normally */
> };
> gpioa: gpio@FF140000 {
> 	compatible = "abilis,tb10x-gpio";
> 	reg = <0xFF140000 0x1000>;
> 	gpio-controller;
> 	#gpio-cells = <2>;
> 	gpio-ranges = <&iomux &pctl_gpio_a>; /* (*1) */

I guess you had to make the pctl_gpio_a a DT node, because to reference
it by phandle, it has to be a node; a phandle can't point at a property.

> };
> 
> gpioa: gpio@FF140000 {
> 	compatible = "abilis,tb10x-gpio";
> 	reg = <0xFF140000 0x1000>;
> 	gpio-controller;
> 	#gpio-cells = <2>;
> 	pinctrl-names = "default"   /* here the GPIO controller requests */
> 	pinctrl-0 = <&pctl_gpio_b>; /* the entire GPIOB port explicitly */
> 	gpio-ranges = <&iomux &pctl_gpio_b>; /* (*2) */
> };
> 
> (*1) TB100 GPIO ranges are defined as a phandle to the I/O function
>      which provides all pins of a given GPIO port. This function is not
>      necessarily requested from pinctrl and GPIO ports may overlap with
>      other functions. The pin controller knows about this and provides
>      whatever GPIO pin is available after mapping other requested
>      functions.
> (*2) Here, the entire GPIOB port is explicitly requested by the GPIO
>      module, i.e. all pins of the port are made available as GPIOs.

So I think all you're looking for is a way in DT to represent GPIO
ranges? I don't think that should be by string name, but rather numbers:

(actually, doesn't pinctrl-simple already have this?)

The GPIO driver exposes N GPIOs, probably numbered 0..n-1, but I guess
it can number them in whatever sparse way it wants.

The pinctrl driver exposes N pins, again probably numbered 0..n-1, but I
guess it can number them in whatever sparse way it wants.

You want a way to represent the mapping between the various GPIO HW
modules' internal GPIO IDs and the various pinctrl HW modules' pin IDs.
That mapping should be just by integer GPIO/pin ID, I think. What about
the following:

iomux: iomux@FF10601c {
    ...
};
gpio@FF140000 {
    gpio-ranges = <GPIO_BASE SIZE &iomux IOMUX_PIN_BASE>;
};

where:

GPIO_BASE: GPIO ID (within gpioa, not global) for the start of the range
covered by this entry.

SIZE: Number of GPIO IDs (and pinctrl pin IDs) covered by this entry.

&iomux: The pin controller related to this range.

IOMUX_PIN_BASE: The pinctrl pin ID (within the iomux pin controller, not
global) for the start of the range covered by this entry.

You could easily have more complex setups, with multiple disjoint ranges:

iomuxa: iomux@1000 {
    ...
};
iomuxb: iomux@2000 {
    ...
};
gpio@8000 {
    gpio-ranges =
        <0 16 &iomuxa 0>,
        /* disjoint here */
        <32 16 &iomuxb 0>,
        <48 5 &iomuxa 16>,
};
gpio@9000 {
    gpio-ranges = <GPIO_BASE SIZE &iomux IOMUX_PIN_BASE>;
    gpio-ranges =
        <1 16 &iomuxb 16>,
        /* iomuxa's pin IDs are disjoint, hence not 21 here */
        <32 8 &iomuxa 32>,
};

The final version of this may require e.g. #gpio-range-pin-cells in the
iomux nodes, and #gpio-range-gpio-cells in the GPIO nodes to aid
automated parsing.

That way, these properties simply end up being parsed into standard and
already extant pinctrl_add_gpio_range() calls, or the other similar API.
