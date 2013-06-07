Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3FGQVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:21:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45044 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3FGQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:21:51 -0400
Message-ID: <51B2089A.1070404@wwwdotorg.org>
Date: Fri, 07 Jun 2013 10:21:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, linux-gpio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Active-low behavior in gpiolib
References: <CAAVeFu+hQHScYYkvO1KOrUPLLaC0ju_O4SDZWyJE8KhLn_hibQ@mail.gmail.com> <CACRpkdYmOHX2bPMKHwY=V2L+4EN-+5KzD-YCJhQtfkFeKV5p8g@mail.gmail.com>
In-Reply-To: <CACRpkdYmOHX2bPMKHwY=V2L+4EN-+5KzD-YCJhQtfkFeKV5p8g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 01:10 AM, Linus Walleij wrote:
> On Wed, Jun 5, 2013 at 7:22 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> 
>> FLAG_ACTIVE_LOW, on the other hand, is *only* set and used through
>> sysfs operations. Independently, the active low property can be
>> specified in gpio phandles and retrieved by
>> of_get_(named_)gpio_flags() - only it has to be kept in a separate
>> variable which must then be checked everytime one wants to change the
>> GPIO value to set the correct level.
> 
> Well it is designed as a sysfs-only thing according to the comment:
> drivers/gpio/gpiolib.c:#define FLAG_ACTIVE_LOW  6       /* sysfs value
> has active low */
> 
> So I think your actual question is whether it should also be
> enabled for the kernel-internal interfaces.
> 
> Currently we have things like this:
> 
> /**
>  * struct mmci_platform_data - platform configuration for the MMCI
>  * (also known as PL180) block.
> (...)
>  * @gpio_cd: read this GPIO pin to detect card insertion
>  * @cd_invert: true if the gpio_cd pin value is active low
> (...)
>         int     gpio_cd;
>         bool    cd_invert;
> 
> So the knowledge of whether a certain GPIO is active high or low
> is spread out through drivers, and the API only drives the line in a
> very explicit way.
...
> So the only thing gained is that gpiolib gets some knowledge
> of how the pin is used. But what is the gain of that?

Well, the big gain I see is that every driver needs to somehow find out
whether the GPIO is active-low or not, and store a separate flag for it,
and XOR all data with that flag. That's not a massive amount of code,
but it's really rather annoying. Why can't we just tell gpiolib what the
polarity is, and let it deal with it. In the DT case, this "tell gpiolib
what the polarity is" would be 100% hidden inside the DT parsing/mapping
(of_xlate) code. For non-DT, presumably this could be a flag that the
board file or platform code programs into gpiolib early on.

If you're worried about this hiding too much information, and that some
code might want to know what's really going on rather than the logical
values, perhaps:

gpiod_[gs]et() - return/accept logical values
gpiod_[gs]et_raw() - return the actual electrical level

gpiod_[gs]et() might also hide details of
open-drain/collector/source/... too, and do automatic tri-stating based
on the level of output that was desired?
