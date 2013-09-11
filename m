Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3IKHRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:17:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41601 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IKHRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:17:18 -0400
Message-ID: <523018DB.7080004@ahsoftware.de>
Date: Wed, 11 Sep 2013 09:16:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: joelf@ti.com
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
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
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk> <522EC392.8070002@ti.com> <522F1BF0.8080608@collabora.co.uk> <522F3408.6050608@ti.com> <52301655.6080801@ahsoftware.de>
In-Reply-To: <52301655.6080801@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.09.2013 09:05, schrieb Alexander Holler:
> Am 10.09.2013 17:00, schrieb Joel Fernandes:
>
>> I think your initial patch is much better than fixing up DT but then I
>> may be
>> missing other problems with your patch that Linus's patch addresses.
>
> The initial patch had the problem that it not only did introduce
> irq-mappings for only those gpios which are marked as IRQs, but it
> requested those gpios too and preconfigured them
>
> And that breaks every driver which uses gpios for IRQs.
>
> To summarize what happens if a driver uses a gpio as irq:
>
> gpio_request() // This works only if the gpio was not requested before
> gpio_direction_input()
> gpio_to_irq() // This needs an irq-mapping
> request_threaded_irq()
>
> So I would suggest multiple steps to change that:
>
> 1. Create a mapping for every gpio found in DT (or all gpios if no DT is
> used). I think that is what Linus patch does (sorry, I haven't really
> followed this thread and didn't look in deep at the patch).
>
> 2. Implement gpio_request_for_irq()
> This would just be a small macro for gpio_request(); gpio_direction_input()
>
> 3. Change all drivers which do use gpio_to_irq() to use
> gpio_request_for_irq() instead of gpio_request() and
> gpio_direction_input(). This will end up with a big series of more or
> less trivial patches (I count 677 occurences of gpio_to_irq) and might
> be splitted.
>
> 4. request gpios and set them to input when a gpio is marked as an IRQ
> in the DT and DT is used. Change gpio_rquest_for_irq() to a NOP if DT is
> used or leave it as it is for the none-dt case.

But I still see a possible problem with requesting a gpio (centralized) 
if it is marked as IRQ in DT: it does this always.

I'm not sure, but there might be cases where this isn't wanted. Just 
that a GPIO is marked as IRQ in the DT for one driver, doesn't mean that 
this driver will be really used (and something else might use the GPIO 
instead).

Regards,

Alexander Holler

