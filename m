Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3ATGFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 01:05:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16682 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3ATGFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 01:05:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 19 Jan 2013 22:03:53 -0800
Message-ID: <50FB8986.9010205@nvidia.com>
Date: Sun, 20 Jan 2013 15:07:02 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>
CC: Greg Ungerer <gerg@uclinux.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        <gnurou@gmail.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <CACRpkda6dqAj+DzrMCnKET7Z9PtuW0+k9ea3YDL8Z1D=oFVRpQ@mail.gmail.com> <50F7E83E.8000105@uclinux.org> <201301170850.43655.sfking@fdwdc.com>
In-Reply-To: <201301170850.43655.sfking@fdwdc.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 01/18/2013 01:50 AM, Steven King wrote:
> Well, my concern is the small, single chip platforms with limited ram and
> speeds measured in MHz.  My goal was that these platforms that had very basic
> gpio needs, no offboard gpio, just toggling a few pins for spi or whatever,
> could do that without pulling in a bunch of code they dont need.  I realize
> that for x86 or arm people with their giga Hz cpus with gigabytes of ram, its
> no big deal, but my little 60 MHz coldfire v2s with only 16 megs of ram (and
> even more constraining, 2 megs of flash) need all the help they can get.

Running readelf on gpiolib.o built for Tegra, here are the footprints:

.text: 9412B
.data: 260B
.bss: 12312B
.rodata: 268B

Total: 22252B or 22KB.

... of which more than half is the BSS section which consists of a 
static array of 1024 GPIO descriptors, an arbitrary number that you can 
tune and is way too large even for Tegra (but we have to use these 
gigabytes somehow). Say you only need to use 256 GPIOs and .bss is down 
to ~3KB, for a total overhead of 15kB or 0.09% of your 16MB which, in 
perspective, suddenly seem gigantic. :)

If you are concerned about the additional indirection that GPIOlib 
introduces and the potential slowdown for bitbanging, you can always 
define custom gpio_set_value() and gpio_get_value() macros to shortcut 
GPIOlib when the GPIO is in the range you want performance for.

> I haven't been keeping up with the kernel list of late, can someone point me
> to what''s being discussed so I can see what were talking about here?

Arnd explained it already, but basically we'd like to consolidate the 
GPIO subsystem around GPIOlib and introduce safer interfaces (while 
preserving backward compatibility). Good progress in that direction 
would be achieved if all users of the GENERIC_GPIO interface relied on 
GPIOlib (making GENERIC_GPIO require GPIOLIB).

Actually the question of switching to GPIOlib is only worth being asked 
if you are making use of drivers that require GENERIC_GPIO. If this is 
not the case and your GPIOs are only used by your own platform code, you 
can always give up using defining GENERIC_GPIO and continue implementing 
them your own way.

Thanks,
Alex.
