Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbaJ3TYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:24:36 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46503 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaJ3TYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <54521C65.8060603@cogentembedded.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
 <1414635488-14137-9-git-send-email-cernekee@gmail.com> <54521C65.8060603@cogentembedded.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Thu, 30 Oct 2014 12:24:02 -0700
Message-ID: <CAJiQ=7BekWsmcDfQ-oKXAza_pEXHNFCQAisvo2m+D7Km2t_meQ@mail.gmail.com>
Subject: Re: [PATCH V2 08/15] irqchip: bcm7120-l2: Eliminate bad IRQ check
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 4:09 AM, Sergei Shtylyov wrote:
>> diff --git a/drivers/irqchip/irq-bcm7120-l2.c
>> b/drivers/irqchip/irq-bcm7120-l2.c
>> index b9f4fb8..49d8f3d 100644
>> --- a/drivers/irqchip/irq-bcm7120-l2.c
>> +++ b/drivers/irqchip/irq-bcm7120-l2.c
>
> [...]
>>
>> @@ -51,19 +49,12 @@ static void bcm7120_l2_intc_irq_handle(unsigned int
>> irq, struct irq_desc *desc)
>>         chained_irq_enter(chip, desc);
>>
>>         status = __raw_readl(b->base + IRQSTAT);
>> -
>> -       if (status == 0) {
>> -               do_bad_IRQ(irq, desc);
>> -               goto out;
>> -       }
>> -
>>         do {
>
>
>    I think this needs to now become:
>
>         while (status) {
>
>>                 irq = ffs(status) - 1;
>>                 status &= ~(1 << irq);
>
>
>    In case 'status' is 0, 'irq' will be equal to -1. How does the shift by
> negative value work?
>
>>                 generic_handle_irq(irq_find_mapping(b->domain, irq));
>>         } while (status);

That's a good point.  We need to check for 0 somehow.

This code gets replaced in patch 13/15 anyway, but I'll fix it in the
next round.

Thanks!
