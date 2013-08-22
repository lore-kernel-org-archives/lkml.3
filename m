Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3HVWaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:30:35 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63346 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HVWae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:30:34 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Fri, 23 Aug 2013 00:30:25 +0200
Message-ID: <2536791.bQXJji6XBC@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <52167DBC.8040105@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <201308221101.30316.poeschel@lemonage.de> <52167DBC.8040105@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 of August 2013 15:08:12 Stephen Warren wrote:
> On 08/22/2013 03:01 AM, Lars Poeschel wrote:
> > On Thursday 22 August 2013 at 01:10:27, Stephen Warren wrote:
> >> On 08/21/2013 03:49 PM, Tomasz Figa wrote:
> >>>> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> >>>> 
> >>>> +			 */
> >>>> +			if (irq_domain && irq_domain->ops->xlate)
> >>>> +				irq_domain->ops->xlate(irq_domain, 
gcn,
> >>>> +						       intspec + 
i, intsize,
> >>>> +						       &hwirq, 
&type);
> >>>> +			else
> >>>> +				hwirq = intspec[0];
> >>> 
> >>> Is it a correct fallback when irq_domain is NULL?
> >> 
> >> Indeed this fallback is dangerous. The /only/ way to parse an IRQ
> >> specifier is with binding-specific knowledge, which is obtained by
> >> calling irq_domain->ops->xlate(). If the IRQ domain can't be found,
> >> this operation simply has to be deferred; we can't just guess and
> >> hope.> 
> > At least the of irq mapping code make this assumption also:
> > kernel/irq/irqdomain.c:483
> > It should be valid for us here too.
> > The additional assumption that I made is that if irq_domain == NULL
> > (not only xlate), that we can use intspec[0] either.
> 
> OK, I guess it's likely this won't cause any additional issue then. I
> suspect most IRQ domains use within the context of device tree already
> provide an explicit xlate op anyway; for example irq_domain_simple_ops
> points at the default irq_domain_xlate_onetwocell.

We got away from the problem I pointed in my reply. If irq_domain == NULL, 
there is no way to translate specifier to hwirq (and in what domain such 
hwirq would be in anyway?).

> >>>> +
> >>>> +			hwirq = be32_to_cpu(hwirq);
> >>> 
> >>> Is this conversion correct? I don't think hwirq could be big endian
> >>> here (unless running on a big endian CPU).
> >> 
> >> I think that should be inside the else branch above.
> > 
> > No it has to be in both branches as it is. Device tree data is big
> > endian. The conversion is converting big endian data (from device
> > tree in both cases) to cpu endianess and not coverting TO big endian.
> > My test machine is a arm in little endian mode and it provided wrong
> > values if I did not do the conversion.
> > What I am a bit unsure about is if the xlate function is expecting the
> > intspec pointer to point to big endian device tree data or data
> > already
> > converted to cpu endianess. For the standard xlate functions
> > irq_domain_xlate_[one|two|onetwo]cell it does not matter.
> 
> The xlate function assumes that data is already converted to CPU-endian.
> See:
> 
> irq_of_parse_and_map() ->
>     of_irq_map_one() ->
>         of_irq_map_raw() ->
>             out_irq->specifier[i] = of_read_number(intspec +i, 1);
>     irq_create_of_mapping()
> 
> (of_read_number does the be32_to_cpu() internally)

So basically to be correct, the code here would need to read the specifier 
into internal buffer using a helper like of_read_number() or maybe even 
of_property_read_u32_array() and then pass this buffer to xlate().

Best regards,
Tomasz

