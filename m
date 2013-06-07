Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3FGHKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:10:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38286 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3FGHKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+hQHScYYkvO1KOrUPLLaC0ju_O4SDZWyJE8KhLn_hibQ@mail.gmail.com>
References: <CAAVeFu+hQHScYYkvO1KOrUPLLaC0ju_O4SDZWyJE8KhLn_hibQ@mail.gmail.com>
Date: Fri, 7 Jun 2013 09:10:11 +0200
Message-ID: <CACRpkdYmOHX2bPMKHwY=V2L+4EN-+5KzD-YCJhQtfkFeKV5p8g@mail.gmail.com>
Subject: Re: Active-low behavior in gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-gpio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 7:22 AM, Alexandre Courbot <gnurou@gmail.com> wrote:

> FLAG_ACTIVE_LOW, on the other hand, is *only* set and used through
> sysfs operations. Independently, the active low property can be
> specified in gpio phandles and retrieved by
> of_get_(named_)gpio_flags() - only it has to be kept in a separate
> variable which must then be checked everytime one wants to change the
> GPIO value to set the correct level.

Well it is designed as a sysfs-only thing according to the comment:
drivers/gpio/gpiolib.c:#define FLAG_ACTIVE_LOW  6       /* sysfs value
has active low */

So I think your actual question is whether it should also be
enabled for the kernel-internal interfaces.

Currently we have things like this:

/**
 * struct mmci_platform_data - platform configuration for the MMCI
 * (also known as PL180) block.
(...)
 * @gpio_cd: read this GPIO pin to detect card insertion
 * @cd_invert: true if the gpio_cd pin value is active low
(...)
        int     gpio_cd;
        bool    cd_invert;

So the knowledge of whether a certain GPIO is active high or low
is spread out through drivers, and the API only drives the line in a
very explicit way.

I am uncertain whether it is wise to move this into gpiolib for
in-kernel consumers, it is mainly a convention of where the
knowledge should sit. In the mentioned case, the flags will still
be needed because we need to have the information there to
set the flag toward the gpiolib API anyway.

So the only thing gained is that gpiolib gets some knowledge
of how the pin is used. But what is the gain of that?

One could argue that this property should not have been
added to the sysfs ABI for the same reason but that cannot
be changed.

The ABI addition of polarity was done when the GPIOlib was
orphaned, by the way, so it wasn't really reviewed. :-(
I wonder if the author's mail address is still working.

Yours,
Linus Walleij
