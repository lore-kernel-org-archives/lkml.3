Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3EOJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:42:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:18607 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758480Ab3EOJmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:42:17 -0400
Date: Wed, 15 May 2013 11:41:48 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Message-ID: <20130515094146.GA19925@ab42.lan>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdbkqzyr0r0CostUx9RYa=pyPoyVvvW+VxEzyAYSESxp_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 02:29:46PM +0200, Linus Walleij wrote:
> On Fri, May 10, 2013 at 10:25 AM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
> 
> >> > What do you think about the following modification to the pinctrl/GPIO
> >> > frameworks instead (not yet a formal patch, more a request for comment
> >> > to illustrate what I mean. If you agree, I will clean it up and submit a
> >> > proper patch after discussion).
> >> >
> >> > It adds a dt_gpiorange_xlate function to the pinctrl callbacks which
> >> > defaults to the conventional behaviour using kernel logical pin numbers.
> >> > However, pin controllers which provide more complex mechanisms can
> >> > define #gpio-range-cells and provide this callback in order to keep
> >> > Linux pin numbering inside the kernel.
> (...)
> > The patch does not change the default behaviour of the kernel: In case
> > no dt_gpiorange_xlate callback is defined for a given driver (e.g. for
> > pre-existing drivers), the default function simply interprets the first
> > argument as Linux pin number and the second as pin count, same as now.
> > New drivers can use the callback to translate device specific pin
> > references to Linux pin numbers (in the idea of of_xlate in the GPIO
> > framework or xlate in the irqchip framework).
> 
> I like the concept.
> 
> However I am totally opposed to the idea of making this something
> device tree-exclusive.
> 
> Look at for example
> drivers/pinctrl/pinctrl-abx500.c:
> 
> static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
>                           unsigned gpio)
> {
> (...)
>         /* on ABx5xx, there is no GPIO0, so adjust the offset */
>         unsigned offset = gpio - 1;
> 
> As you can see, this driver, which does not use device tree,
> is working around the same problem. Here the problem is that
> the pins are numbered starting at 1 instead of 0, a very trivial
> numberspace shuffleing.

Let me see if I understand this right:
In ABx5xx, the pin numbering is offset by 1 wrt. GPIO numbering?

> I'd be open to this approach if you:
> 
> - Make it generic for all pinctrl drivers, i.e. add the translation
>   to the core so it does not just apply to devices using device tree.

Do you mean what would be required here is a generic way to translate
pin numbers to GPIO numbers in the pin controller?

This translation is currently achieved by the gpio_range mechanism.
Internals of gpio_range leak into the pinctrl drivers and are bypassed
in many cases. E.g. pinctrl-abx500.c uses an internal reimplementation
of gpio ranges and the offset by one instead of the information in the
pinctrl_gpio_range structure.
Mapping pin numbers to GPIO numbers in the pin controller would have the
following advantages:
 - It makes GPIO numbering well defined which is clearly an advantage
   for the /sys/class/gpio interface: GPIO numbering is now controlled
   by the pinctrl driver author and no longer needs to be kernel
   internal.
 - The device tree/acpi issue is solved since a GPIO controller could
   now define its range in GPIO number space (which becomes public)
   rather than kernel-internal pin number space. At least for our
   products, GPIO numbering generally doesn't change between different
   variants of the same chip and the /sys/class/gpio customer
   documentation would apply to device also.
 - The custom logic inside many pinctrl drivers would be confined in one
   translation function the driver provides instead of being spread out
   all over the driver.
 - "Sparse GPIO ranges" are easy to implement if required by the
   platform/driver.

> - Augment the pinctrl-abx500.c driver to show how this simplifies
>   that driver. (Does not need to be perfect, I'll help out finalizing it
>   for sure.)

The issue is that such a change is quite fundamental, all pinctrl
drivers would have to be upgraded (not just pinctrl-abx500.c) and struct
pinctrl_gpio_range would have to be removed from the gpio_request_enable
callback and friends in favour of some generic translation mechanism.

I am also afraid that the custom logic in many drivers could only be
rewritten with the help of the respective driver's author.

> - Then add DT-specific wrapper using this core feature.

GPIO ranges definitions in DT would probably be no longer be compatible
with previous definitions since the number space would change from pin
numbers to GPIO numbers. I don't think this is acceptable.

> This way the problem will be solved for everybody, including
> ACPI when they sooner or later come back with the same issue.

Given the issues highlighted above I'm not sure if I understand your
proposal correctly. Although I see the advantages, I wonder if the
migration to such a system is feasible in practise.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
