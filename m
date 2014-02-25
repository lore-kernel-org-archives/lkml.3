Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBYKGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:06:48 -0500
Received: from 7.mo69.mail-out.ovh.net ([46.105.50.32]:35477 "EHLO
	mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753133AbaBYKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:06:39 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 05:06:38 EST
MIME-Version: 1.0
In-Reply-To: <CACh+v5Mz43dcuDh7PQV+LgNxMOV+CpamNGR69f_6TTiEB5SVJw@mail.gmail.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<1392199607-27452-3-git-send-email-jjhiblot@traphandler.com>
	<CACRpkdb8BUkLcF8=oEXsGemgFAQk6pyaX0j8t3v1xjymJsM=VQ@mail.gmail.com>
	<CACh+v5Mz43dcuDh7PQV+LgNxMOV+CpamNGR69f_6TTiEB5SVJw@mail.gmail.com>
Date: Tue, 25 Feb 2014 10:47:27 +0100
Message-ID: <CACh+v5MjNt5EmPOWLjtDHboZ0dXLU7eKgQuWSWPB+Ydy3P_6-A@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] at91: pinctrl: don't request GPIOs used for
 interrupts but lock them as IRQ
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7542966427538970648
X-Ovh-Remote: 209.85.192.178 (mail-pd0-f178.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-25 10:35 GMT+01:00 Jean-Jacques Hiblot <jjhiblot@traphandler.com>:
> Hi Linus,
>
> 2014-02-24 14:25 GMT+01:00 Linus Walleij <linus.walleij@linaro.org>:
>> On Wed, Feb 12, 2014 at 11:06 AM, Jean-Jacques Hiblot
>> <jjhiblot@traphandler.com> wrote:
>>
>>> During the xlate stage of the DT interrupt parsing, the at91 pinctrl driver
>>> requests the GPIOs that are described as interrupt sources. This prevents a
>>> driver to request the gpio later to get its electrical value.
>>> This patch replaces the gpio_request with a gpio_lock_as_irq to prevent the
>>> gpio to be set as an ouput while allowing a subsequent gpio_request to succeed
>>>
>>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>>
>> OK, but is this really correct:
>>
>>> @@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
>>>  {
>>>         struct at91_gpio_chip *at91_gpio = d->host_data;
>>>         int ret;
>>> -       int pin = at91_gpio->chip.base + intspec[0];
>>>
>>>         if (WARN_ON(intsize < 2))
>>>                 return -EINVAL;
>>>         *out_hwirq = intspec[0];
>>>         *out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>>>
>>> -       ret = gpio_request(pin, ctrlr->full_name);
>>> +       ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
>>
>> So when resolving an IRQ resource, we take for granted that it will be used
>> for IRQs and IRQs only? Is it not possible that this resolution is done
>> and then the driver using it unloads or whatever and it is still marked
>> as IRQ?
> No, once it's reserved for irq, it'll be for irq only.
>>
>> I don't think the xlate function should have such side effects on
>> the gpio_chip internal state. I think it should just translate.
>
> I agree but I choose to only replace the gpio_request by a
> lock_as_irq(), not rework the whole thing. It seemed it would have
> more chance to be accepted this way. IMO the right time to do this is
> at the time of the request_irq()
>>
>> The line is locked for IRQ the moment its startup() callback is
>> called, is it not?
>>
>>> -       ret = gpio_direction_input(pin);
>>> +       ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
>>
>> I actually don't like this either. This kind of thing was causing
>> problems in the OMAP driver like hell.
> But calling gpio_direction_input() defeats the purpose of removing the
> gpio_request() because it ensures that the gpio is requested.
>>
>> I think this should be deleted from xlate and at91_gpio_direction_input()
>> be called from the irqchip's .startup() or even .unmask() function
>> instead.
> irq_startup and irq_shutdown seem the right place for this because
> they're called when requesting and freeing the interrupt. It'll
> require a change to __setup_irq() though to check the return value of
> irq_startup.

Linux,

Sorry, for the noise. You can forget this proposed patch and my
previous email. I just saw that the patch where this was done in
startup and shutdown was applied. I thought it had been rejected . I'm
sorry for the confusion.

Jean-Jacques
>>
>> Yours,
>> Linus Walleij
