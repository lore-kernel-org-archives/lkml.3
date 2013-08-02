Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3HBJ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:59:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51795 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3HBJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:59:16 -0400
Message-ID: <51FB8292.9090000@ahsoftware.de>
Date: Fri, 02 Aug 2013 11:57:38 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk>
In-Reply-To: <51F8CC35.1070704@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2013 10:35, schrieb Javier Martinez Canillas:

>
> The problem is that board files and drivers that has not not been completed
> migrated to DT assumes (at least for OMAP) that *every* GPIO line is mapped as
> an IRQ and they just do:
>
> gpio_request(gpio,...);
> gpio_direction_input()
> request[_threaded]_irq(gpio_to_irq(gpio), ...);
>
> My patch-set changed the gpio-omap driver to not map all GPIO lines but only the
> ones that were really used as an IRQ and let the DT core to do the mapping from
> irq_create_of_mapping(). The first problem reported with the OMAP patch was that
> a driver was using the above sequence and that the GPIO had not been mapped.
> This user was booting with DT and so this showed a bug in the driver and a DT
> that did not conform with the standard schema used in mainline but this shows a
> potential issue.

There must have been a bug in the patch too. I've also added that 
iinterrupt-parent stuff (with the same flags as used by the driver) and 
just have let the driver call

request_threaded_irq(gpio_to_irq(gpio), flags);

without the gpio_request()/input() before. And request_threaded_irq() 
returned -EBUSY. I'm pretty sure nothing else did use that gpio, but I 
haven't looked at why request_threaded_irq() returned -EBUSY. I assume 
the new mapping stuff did reserve the irq in such a way, that the driver 
couldn't request the IRQ.

Otherwise I wouldn't have had a problem by just adding the necessary 
entries to the DT.

But I have to say I didn't like the syntax too, and it wasn't obvious 
how the syntax is and how to conclude from a gpio number to an 
irq-number and the patch didn't really include some documentation or 
useful example.

Regards,

Alexander Holler
