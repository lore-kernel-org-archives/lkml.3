Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbaCQLPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:15:07 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:39725 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932672AbaCQLPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <53205A46.6000304@gmail.com>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
	<1393841162-25339-4-git-send-email-jjhiblot@traphandler.com>
	<53205A46.6000304@gmail.com>
Date: Mon, 17 Mar 2014 12:14:50 +0100
Message-ID: <CACh+v5N+Ms9ZVFN=F_sQQhRbwhiYFg6LO+383UL8iw7qYaPKtQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] at91: pinctrl: don't request GPIOs used for
 interrupts but lock them as IRQ
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree <devicetree@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 15648882807205681176
X-Ovh-Remote: 209.85.220.43 (mail-pa0-f43.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Sorry for being late, I was on vacation.
Yes this patch can be dropped from the serie.

2014-03-12 13:59 GMT+01:00 Boris BREZILLON <b.brezillon.dev@gmail.com>:
> Hi JJ,
>
> IIRC this patch was necessary for the DM9000 device, which is not defined
> in this series anymore.
> And, correct me if I'm wrong, but there's still a discussion about how
> this should be fixed properly (https://lkml.org/lkml/2014/2/25/388).
>
> As a result, shouldn't we remove this patch from this series ?
>
> Best Regards,
>
> Boris
>
> Le 03/03/2014 11:05, Jean-Jacques Hiblot a écrit :
>
>> During the xlate stage of the DT interrupt parsing, the at91 pinctrl
>> driver
>> requests the GPIOs that are described as interrupt sources. This prevents
>> a
>> driver to request the gpio later to get its electrical value.
>> This patch replaces the gpio_request with a gpio_lock_as_irq to prevent
>> the
>> gpio to be set as an ouput while allowing a subsequent gpio_request to
>> succeed
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>   drivers/pinctrl/pinctrl-at91.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-at91.c
>> b/drivers/pinctrl/pinctrl-at91.c
>> index d990e33..db55b96 100644
>> --- a/drivers/pinctrl/pinctrl-at91.c
>> +++ b/drivers/pinctrl/pinctrl-at91.c
>> @@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct
>> irq_domain *d,
>>   {
>>         struct at91_gpio_chip *at91_gpio = d->host_data;
>>         int ret;
>> -       int pin = at91_gpio->chip.base + intspec[0];
>>         if (WARN_ON(intsize < 2))
>>                 return -EINVAL;
>>         *out_hwirq = intspec[0];
>>         *out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
>>   -     ret = gpio_request(pin, ctrlr->full_name);
>> +       ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
>>         if (ret)
>>                 return ret;
>>   -     ret = gpio_direction_input(pin);
>> +       ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
>>         if (ret)
>>                 return ret;
>>
>
>
