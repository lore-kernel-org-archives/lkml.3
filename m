Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3IXHzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:55:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59954 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3IXHzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:55:23 -0400
Message-ID: <5241454E.2050602@collabora.co.uk>
Date: Tue, 24 Sep 2013 09:54:54 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk> <20130923164519.GF2684@atomide.com> <524073BC.9080907@collabora.co.uk> <20130923170724.GG2684@atomide.com> <524141A6.2090701@ti.com>
In-Reply-To: <524141A6.2090701@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 09:39 AM, Sricharan R wrote:
> Hi,
> On Monday 23 September 2013 10:37 PM, Tony Lindgren wrote:
>> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130923 10:09]:
>>> On 09/23/2013 06:45 PM, Tony Lindgren wrote:
>>>> Hmm does this still work for legacy platform data based
>>>> drivers that are doing gpio_request() first?
>>>>
>>> Yes it still work when booting using board files. I tested on my OMAP3 board and
>>> it worked in both DT and legacy booting mode.
>> OK great.
>>  
>>>> And what's the path for clearing things for PM when free_irq()
>>>> gets called? It seems that this would leave the GPIO bank
>>>> enabled causing a PM regression?
>>>>
>>> Indeed, I did set bank->mod_usage |= 1 << offset so the bank is enabled if the
>>> device goes to suspended and then resumed but I completely forget about the
>>> clearing path when the IRQ is freed.
>>>
>>> Which makes me think that we should probably maintain two usage variables, one
>>> for GPIO and another one for IRQ and check both of them on the suspend/resume pm
>>> functions.
>> Yes that it seems that they should be treated separately.
>  To understand, why cant the flag be cleared in gpio_irq_shutdown ?

Hi Sricharan,

Without this patch today drivers do this:

gpio_request(gpio, "foo IRQ"); // bank->mod_usage |= 1 << offset
gpio_direction_input(gpio);

and then request a IRQ with:

irq = gpio_to_irq(gpio);
request_irq(irq, ...);

later on its cleanup path:

free_irq(irq, dev);
gpio_free(gpio) // bank->mod_usage &= ~(1 << offset);

So if you clear the flag on gpio_irq_shutdown then bank module won't be enabled
after a suspend making drivers using the GPIO after freeing the IRQ to fail.

So the idea is to have something like this:

a) Drivers that request both the GPIO and IRQ

gpio_request(gpio, "foo IRQ"); // bank->mod_usage |= 1 << offset
gpio_direction_input(gpio);

irq = gpio_to_irq(gpio);
request_irq(irq, ...); // bank->irq_usage |= 1 << offset

free_irq(irq, dev); // bank->irq_usage &= ~(1 << offset);
gpio_free(gpio) // bank->mod_usage &= ~(1 << offset);

b) Drivers that just request the IRQ:

irq = gpio_to_irq(gpio);
request_irq(irq, ...); // bank->irq_usage |= 1 << offset
free_irq(irq, dev); // bank->irq_usage &= ~(1 << offset);

So irq_usage or mod_usage is set means that the bank has to be enabled and if
both are not set means that the bank module can be disabled.

> 
> Regards,
>  Sricharan
> 

Best regards,
Javier
