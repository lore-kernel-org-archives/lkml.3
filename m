Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaKCOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:10:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49791 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKCOKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:10:21 -0500
Message-ID: <54578CC7.4050901@arm.com>
Date: Mon, 03 Nov 2014 14:10:15 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V9 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com> <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com> <54574FF7.706@arm.com>
In-Reply-To: <54574FF7.706@arm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 03 Nov 2014 14:10:16.0557 (UTC) FILETIME=[E49711D0:01CFF76F]
X-MC-Unique: 114110314101802401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 09:50, Marc Zyngier wrote:

>> @@ -843,10 +847,14 @@ static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
>>         unsigned int type = IRQ_TYPE_NONE;
>>         struct of_phandle_args *irq_data = arg;
>>
>> -       ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
>> -                                  irq_data->args_count, &hwirq, &type);
>> -       if (ret)
>> -               return ret;
>> +       if (irq_data) {
>> +               ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
>> +                                          irq_data->args_count, &hwirq, &type);
>> +               if (ret)
>> +                       return ret;
>> +       } else {
>> +               hwirq = virq;
>> +       }
> 
> I'm slightly puzzled here. What's the purpose of this? The whole goal of
> the domain hierarchy is to avoid that kind of thing. Also, you should
> never have to call xlate on an MSI, because it should never be described
> in the device tree the first place.

Thinking of it some more:

The actual reason why this is required is because the MSI domain calls
into this via irq_domain_alloc_irqs_parent(). But because MSIs are not
described in DT, they do not have a of_phandle to pass down to the xlate
helper. In this case, the v2m widget has the knowledge of what are the
valid SPI numbers, and the core GIC code must blindly accept it.

This definitely requires a fat comment, because this is far from obvious.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

