Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3IJVXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:23:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37650 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3IJVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:23:23 -0400
Message-ID: <522F8DB7.8070800@collabora.co.uk>
Date: Tue, 10 Sep 2013 23:23:03 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Lars Poeschel <poeschel@lemonage.de>, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        joelf@ti.com
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F2521.4090806@collabora.co.uk> <522F7878.30800@wwwdotorg.org>
In-Reply-To: <522F7878.30800@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 09:52 PM, Stephen Warren wrote:
> On 09/10/2013 07:56 AM, Javier Martinez Canillas wrote:
> ...
>> The only thing that this patch tries to solve is when a driver expect to request
>> a IRQ and it doesn't care if is a real IRQ line from an interrupt controller or
>> a GPIO pin mapped as an IRQ.
> 
> That can be solved in the interrupt chip driver. The fact the previous
> attempt didn't work doesn't mean that it's impossible.
>

Indeed. Unfortunately that patch-set got merged as a fix quite late on the -rc
cycle so it was safer to just revert the patches instead of analyzing the
regression and providing a fix.

If Linus is fond about taking a local fix for gpio-omap then we can try again
as a RFC with a better test coverage than before (although the patches had
several tested and acked-by but no one tested on OMAP1 until the patches were
merged) getting some TI folks in the loop who have access to those ancient OMAP1
devices. That way we can repost as a patch just once we are definitely sure that
it won't cause a regression on any OMAP platform.

>> With board files we used to explicitly do the GPIO setup
>> (gpio_{request,direction_input}) but with DT these board files are gone and we
>> need a way to setup a GPIO implicitly when is mapped as an IRQ.
> 
> Well, that's just an example of hacking around something in a board file
> that should have been fixed in the GPIO/IRQ controller.
> 
>> That's the only use case that this patch covers.
> ...
>> Also, it would be great if we can find a temporary solution so we can finally
>> have ethernet working with DT on most OMAP2+ boards. Since I expect that doing
>> the mentioned change on gpiolib would take at least a couple of kernel releases.
> 
> Really? I thought this patch was error-checking to make sure that
> different drivers didn't request a GPIO and an IRQ that are actually the
> same signal. This patch shouldn't affect any functionality except in
> cases where there's a bug in the DT (incorrect GPIO/IRQ passed to some
> driver).
> 

Yes, it doesn't do any error-checking neither prevent a driver to request a GPIO
and an IRQ that are the same signal (as long as this is supported by the
GPIO/IRQ controller and its driver). The only thing that Linus patch does is to
auto request a GPIO for pins that are mapped as IRQ in DT (i.e: interrupt-parent
= <&gpio6>).

The name of the function introduced by Linus is
of_gpiochip_interrupt_consistency_check() but probably a better name is
of_gpiochip_autorequest_irq() or something like that.

A similar behavior could be obtained by let's say calling gpio_request() in
irq_create_of_mapping() if you wanted to add the logic in the IRQ chip DT core
instead of doing it in the GPIO chip DT core as Linus does with his patch.

That's why I don't understand why Linus patch could be an issue for drivers that
needs to request both the GPIO and the mapped IRQ.

If this is already supported then nothing will break. If the driver tries to
request the GPIO twice because this is already made by the DT core then I think
is a bug in the driver and has to be fixed to support DT since there won't be
any need to do this manually anymore.

Best regards,
Javier
