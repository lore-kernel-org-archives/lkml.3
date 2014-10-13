Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaJMJou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:44:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56114 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaJMJot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:44:49 -0400
Message-ID: <543B9F0B.8000205@arm.com>
Date: Mon, 13 Oct 2014 10:44:43 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sricharan R <r.sricharan@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-4-git-send-email-yingjoe.chen@mediatek.com> <543B93B4.3040404@arm.com> <3536113.xYztHpGTJM@wuerfel>
In-Reply-To: <3536113.xYztHpGTJM@wuerfel>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Oct 2014 09:44:45.0415 (UTC) FILETIME=[5236F770:01CFE6CA]
X-MC-Unique: 114101310444603901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/14 10:27, Arnd Bergmann wrote:
> On Monday 13 October 2014 09:56:20 Marc Zyngier wrote:
>>         if (irq_domain_is_hierarchy(domain)) {
>> +               if (domain->ops->xlate) {
>> +                       /*
>> +                        * If we've already configured this interrupt,
>> +                        * don't do it again, or hell will break loose.
>> +                        */
>> +                       if (domain->ops->xlate(domain, irq_data->np,
>> +                                              irq_data->args,
>> +                                              irq_data->args_count,
>> +                                              &hwirq, &type))
>> +                               return 0;
>> +
>> +                       virq = irq_find_mapping(domain, hwirq);
>> +                       if (virq)
>> +                               return virq;
>> +               }
>>                 virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
>>                 return virq <= 0 ? 0 : virq;
>>         }
>>
>> Thoughts?
> 
> Using irq_find_mapping() first is probably the right approach, that
> is what irq_create_mapping() does too, and I suppose we want those
> to be symmetric.

Ah, good point. I somehow missed that.

> mt_sysirq_domain_alloc() in patch 4 has the irq_find_domain check
> in it, which I guess we can remove when it has moved to the common
> code.
> 
> I don't see irq_domain_alloc_irqs() in linux-next or older kernels, where
> does that get introduced?

This is part of Jiang's domain hierarchy series:
https://patchwork.ozlabs.org/patch/388279/

which I plan to use to get rid of the ugly gic_extn hack that only Tegra
uses (but that everyone tries to abuse), and also for the GICv2m support.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

