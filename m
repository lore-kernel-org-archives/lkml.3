Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3ENM3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:29:49 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61901 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENM3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130510082521.GA2125@ab42.lan>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
	<516EEAA0.10906@wwwdotorg.org>
	<20130418090310.GA17636@ab42.lan>
	<CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
	<20130429161725.GB30136@ab42.lan>
	<5182B557.4040804@wwwdotorg.org>
	<CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
	<20130508164123.GA10248@ab42.lan>
	<518AAF31.8080502@wwwdotorg.org>
	<20130510082521.GA2125@ab42.lan>
Date: Tue, 14 May 2013 14:29:46 +0200
Message-ID: <CACRpkdbkqzyr0r0CostUx9RYa=pyPoyVvvW+VxEzyAYSESxp_g@mail.gmail.com>
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:25 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

>> > What do you think about the following modification to the pinctrl/GPIO
>> > frameworks instead (not yet a formal patch, more a request for comment
>> > to illustrate what I mean. If you agree, I will clean it up and submit a
>> > proper patch after discussion).
>> >
>> > It adds a dt_gpiorange_xlate function to the pinctrl callbacks which
>> > defaults to the conventional behaviour using kernel logical pin numbers.
>> > However, pin controllers which provide more complex mechanisms can
>> > define #gpio-range-cells and provide this callback in order to keep
>> > Linux pin numbering inside the kernel.
(...)
> The patch does not change the default behaviour of the kernel: In case
> no dt_gpiorange_xlate callback is defined for a given driver (e.g. for
> pre-existing drivers), the default function simply interprets the first
> argument as Linux pin number and the second as pin count, same as now.
> New drivers can use the callback to translate device specific pin
> references to Linux pin numbers (in the idea of of_xlate in the GPIO
> framework or xlate in the irqchip framework).

I like the concept.

However I am totally opposed to the idea of making this something
device tree-exclusive.

Look at for example
drivers/pinctrl/pinctrl-abx500.c:

static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
                          unsigned gpio)
{
(...)
        /* on ABx5xx, there is no GPIO0, so adjust the offset */
        unsigned offset = gpio - 1;

As you can see, this driver, which does not use device tree,
is working around the same problem. Here the problem is that
the pins are numbered starting at 1 instead of 0, a very trivial
numberspace shuffleing.

I'd be open to this approach if you:

- Make it generic for all pinctrl drivers, i.e. add the translation
  to the core so it does not just apply to devices using device tree.

- Augment the pinctrl-abx500.c driver to show how this simplifies
  that driver. (Does not need to be perfect, I'll help out finalizing it
  for sure.)

- Then add DT-specific wrapper using this core feature.

This way the problem will be solved for everybody, including
ACPI when they sooner or later come back with the same issue.

Yours,
Linus Walleij
