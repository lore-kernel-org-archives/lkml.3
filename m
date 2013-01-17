Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3AQL0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:26:01 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65311 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3AQLZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:25:59 -0500
MIME-Version: 1.0
In-Reply-To: <201301101008.45091.arnd@arndb.de>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
	<201301091046.13020.arnd@arndb.de>
	<2270940.DTxEYMZtED@percival>
	<201301101008.45091.arnd@arndb.de>
Date: Thu, 17 Jan 2013 12:25:57 +0100
Message-ID: <CACRpkdZ8f4FVL5cd3etMf5ENoSCd=ivfnSmAN41+hNvuvD+7mg@mail.gmail.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Alex Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 10 January 2013, Alex Courbot wrote:

>> > Regarding the integration of pinctrl with gpio,
>> > I was thinking in the past that we could make pinctrl provide everything
>> > that gpiolib does, and have a generic gpiolib driver on top of pinctrl
>> > so that platforms don't need to implement both interfaces but only need
>> > to provide a pure pinctrl driver. Not sure if this makes any sense.
>>
>> That would work if all GPIOs were connected to a ball, but how about GPIO
>> expanders that are external to the chip? They have no use for pinctrl AFAICT.
>> On the other hand, maybe we can have one pinctrl-gpio driver for those chips
>> where pinctrl alone can emulate all the functionality of a GPIO controller.
>> Maybe such a driver exists already?
>
> I don't think we have that yet, but it would be another option: rather
> than putting a generic gpiolib driver on top of pinctrl, we could have
> pinctrl support for all gpios that go through gpiolib, and move device
> drivers over to use pinctrl as the way to manage gpios rather than the
> classic gpio drivers. That would be a larger change though, and require
> that we pull in the pinctrl subsystem on a lot of machines that don't
> need it today.

Not quite following but have the following loose idea:

- Add API such as <linux/pinctrl/gpio.h> with struct pin_gpio_ops {}
  or similar. As orthogonal to the mux and config interfaces we already
  have.

- Add ops like .set_input(), .set_output(), .drive_high() and .drive_low()
  (etc) to the ops struct so all functionality currently provided by
  gpiolib can be implemened by a driver.

- Make global pin numbers optional in gpiolib for the next part...

- Register a generic GPIO chip on top of the pinctrl-gpio.c, preferably
  only supporting Alex' descriptors.

- Provide a userspace interface to pinctrl with something like /dev/pinctrlN
  with an ioctl() interface, solving also Roland Stigge's issue with
  driving many pins at the same time in a smooth way.

Sounds like a plan?

I'd like to avoid the either-or-approach where you have to use
pinctrl only or only gpiolib, so a compatibility layer kindof.

I'm prepping a talk at ELC so will try to jot down something more
substantial.

Yours,
Linus Walleij
