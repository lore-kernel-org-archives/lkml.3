Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3FEFWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:22:49 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51417 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3FEFWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:22:47 -0400
MIME-Version: 1.0
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 5 Jun 2013 14:22:26 +0900
Message-ID: <CAAVeFu+hQHScYYkvO1KOrUPLLaC0ju_O4SDZWyJE8KhLn_hibQ@mail.gmail.com>
Subject: Active-low behavior in gpiolib
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-gpio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

While preparing the v2 of the descriptor-based GPIO interface (gpiod),
I stumbled upon this point that looks like some inconsistency in the
current interface.

gpiolib.c defines the following flags that can influence the gpio
output: FLAG_ACTIVE_LOW, FLAG_OPEN_DRAIN, and FLAG_OPEN_SOURCE.
FLAG_OPEN_DRAIN and FLAG_OPEN_SOURCE, when set, take effet on all set
operations no matter where they come from.

FLAG_ACTIVE_LOW, on the other hand, is *only* set and used through
sysfs operations. Independently, the active low property can be
specified in gpio phandles and retrieved by
of_get_(named_)gpio_flags() - only it has to be kept in a separate
variable which must then be checked everytime one wants to change the
GPIO value to set the correct level.

I find it rather confusing and wonder if we could not come with a more
consistent behavior for the gpiod interface. In particular:
- the active low property could be specified when declaring GPIO
mappings (either through DT or platform data)
- gpiod_get() would retrieve it transparently and set it as a
permanent property of the GPIO
- gpiod_set/get_value() would take the active low property into
account when setting the value - making these functions work with the
actual *value* (as their name states) instead of the physical line
level.

The old gpio_* interface would still behave as usual, of course.

This would make gpiolib behavior more consistent IMHO, at the price of
a semantic difference between the otherwise very similar gpio and
gpiod interfaces. Any thought for or against this? If we go this way
and decide to allow gpiod to diverge, are there other things we are
not satisfied with about the current gpio interface and that we want
to improve?

Thanks,
Alex.
