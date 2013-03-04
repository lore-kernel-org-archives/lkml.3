Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3CDJqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:46:48 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:22820 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755776Ab3CDJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:46:46 -0500
Message-ID: <51346D7C.5080307@gaisler.com>
Date: Mon, 04 Mar 2013 10:46:36 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and support
 custom accessors with gpio-generic
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com> <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
In-Reply-To: <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-01 01:24, Linus Walleij wrote:
> On Tue, Feb 12, 2013 at 8:24 AM, Andreas Larsson <andreas@gaisler.com> wrote:
>
>> This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
>> core library from Aeroflex Gaisler.
>>
>> This also adds support to gpio-generic for using custom accessor
>> functions. The grgpio driver uses this to use ioread32be and iowrite32be
>> for big endian register accesses.
>>
>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>
> Can you split this in two patches: one that adds the custom accessors
> and one that adds the driver?

Sure!

> Grant is currently thinking about optimizations on the call graph
> depths of the GPIO functions and may want to take this opportunity
> to alter something there.
>
>> +++ b/drivers/gpio/gpio-grgpio.c
> (...)
>> +struct grgpio_priv {
>> +       struct bgpio_chip bgc;
>> +       struct grgpio_regs __iomem *regs;
>> +
>> +       u32 imask;      /* irq mask shadow register */
>> +       s32 *irqmap;    /* maps offset to irq or -1 if no irq */
>
> irqmap? Argh what is this... I think you want to use irqdomain
> for this instead. (Documentation/IRQ-domain.txt)

Yeah, that comment is not clear. An entry in the irqmap array (for a 
gpio line) can be either -1 indicating no irq for that line or an index 
into the array of irq:s for the of device. Thus it is simply either -1 
or a valid second argument to irq_of_parse_and_map.

Given that this is generally running on SPARC, it seems irqdomain is not 
an option (IRQ_DOMAIN is not selected by SPARC).

Given this, is just a better formulated comment OK with you in this case?

>
> Check other GPIO drivers (e.g. STMPE or TC3589x) for some
> example of how to use irqdomain.
>
>> +static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
>> +{
>> +       struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
>> +       int index, irq;
>
> This is wher you should use irq_create_mapping(domain, hwirq);

Thanks for the feedback!

Cheers,
Andreas

