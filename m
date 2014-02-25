Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBYJyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:54:36 -0500
Received: from 13.mo4.mail-out.ovh.net ([178.33.251.8]:50553 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752430AbaBYJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:54:33 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 04:54:32 EST
MIME-Version: 1.0
In-Reply-To: <CACRpkdb8BUkLcF8=oEXsGemgFAQk6pyaX0j8t3v1xjymJsM=VQ@mail.gmail.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<1392199607-27452-3-git-send-email-jjhiblot@traphandler.com>
	<CACRpkdb8BUkLcF8=oEXsGemgFAQk6pyaX0j8t3v1xjymJsM=VQ@mail.gmail.com>
Date: Tue, 25 Feb 2014 10:35:50 +0100
Message-ID: <CACh+v5Mz43dcuDh7PQV+LgNxMOV+CpamNGR69f_6TTiEB5SVJw@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] at91: pinctrl: don't request GPIOs used for
 interrupts but lock them as IRQ
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7217862828491757592
X-Ovh-Remote: 209.85.160.42 (mail-pb0-f42.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

2014-02-24 14:25 GMT+01:00 Linus Walleij <linus.walleij@linaro.org>:
> On Wed, Feb 12, 2014 at 11:06 AM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>
>> During the xlate stage of the DT interrupt parsing, the at91 pinctrl driver
>> requests the GPIOs that are described as interrupt sources. This prevents a
>> driver to request the gpio later to get its electrical value.
>> This patch replaces the gpio_request with a gpio_lock_as_irq to prevent the
>> gpio to be set as an ouput while allowing a subsequent gpio_request to succeed
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>
> OK, but is this really correct:
>
>> @@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
>>  {
>>         struct at91_gpio_chip *at91_gpio = d->host_data;
>>         int ret;
>> -       int pin = at91_gpio->chip.base + intspec[0];
>>
>>         if (WARN_ON(intsize < 2))
>>                 return -EINVAL;
>>         *out_hwirq = intspec[0];
>>         *out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>>
>> -       ret = gpio_request(pin, ctrlr->full_name);
>> +       ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
>
> So when resolving an IRQ resource, we take for granted that it will be used
> for IRQs and IRQs only? Is it not possible that this resolution is done
> and then the driver using it unloads or whatever and it is still marked
> as IRQ?
No, once it's reserved for irq, it'll be for irq only.
>
> I don't think the xlate function should have such side effects on
> the gpio_chip internal state. I think it should just translate.

I agree but I choose to only replace the gpio_request by a
lock_as_irq(), not rework the whole thing. It seemed it would have
more chance to be accepted this way. IMO the right time to do this is
at the time of the request_irq()
>
> The line is locked for IRQ the moment its startup() callback is
> called, is it not?
>
>> -       ret = gpio_direction_input(pin);
>> +       ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
>
> I actually don't like this either. This kind of thing was causing
> problems in the OMAP driver like hell.
But calling gpio_direction_input() defeats the purpose of removing the
gpio_request() because it ensures that the gpio is requested.
>
> I think this should be deleted from xlate and at91_gpio_direction_input()
> be called from the irqchip's .startup() or even .unmask() function
> instead.
irq_startup and irq_shutdown seem the right place for this because
they're called when requesting and freeing the interrupt. It'll
require a change to __setup_irq() though to check the return value of
irq_startup.

Jean-Jacques
>
> Yours,
> Linus Walleij
