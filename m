Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaIEKtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:49:41 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65273 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbaIEKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:49:38 -0400
Message-ID: <54099550.5080902@linaro.org>
Date: Fri, 05 Sep 2014 12:49:52 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Will Deacon <Will.Deacon@arm.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific
 ACPI boot support
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <4895927.Zp4WL2AZAF@wuerfel> <540986B2.7000901@arm.com> <3400229.hn32yHbVD2@wuerfel> <540992EA.6020209@arm.com>
In-Reply-To: <540992EA.6020209@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05.09.2014 12:39, Marc Zyngier wrote:
> On 05/09/14 11:13, Arnd Bergmann wrote:
>> On Friday 05 September 2014 10:47:30 Marc Zyngier wrote:
>>>>
>>>> I still prefer being explicit here for the same reason I mentioned earlier:
>>>> I want it to be very clear that we don't support arbitrary irqchips other
>>>> than the ones in the APCI specification. The infrastructure exists on DT
>>>> because we have to support a large number of incompatible irqchips.
>>>
>>> I'm not suggesting that we should support more than the ACPI spec says.
>>> And that's certainly the whole point of a spec, isn't it? ACPI says what
>>> we support, and we're not going any further. I'm just saying that we
>>> shouldn't make the maintenance burden heavier, and the code nothing
>>> short of disgusting. Using our current infrastructure doesn't mean we're
>>> going to support GIcv2.37.
>>
>> Ok
>>
>>>> In particular, the ACPI tables describing the irqchip have no way to
>>>> identify the GIC at all, if I read the spec correctly, you have to
>>>> parse the tables, ioremap the registers and then read the ID to know
>>>> if you have GICv1/v2/v2m/v3/v4. There doesn't seem to be any "device"
>>>> for the GIC that a hypothetical probe function would be based on.
>>>
>>> This is not the way I read the spec. Table 5-46 (Interrupt Controller
>>> Structure) tells you if you have a CPU interface (GICv1/v2) or a
>>> redistributor (GICv3/v4). That's enough to know whether or not you
>>> should carry on probing a particular controller.
>>
>> Ah, good. I missed that.
>>
>>> The various GIC versions don't really have a unified memory map anyway
>>> (well, none that you can rely on), and you really have to rely on ACPI
>>> to tell you what you have.
>>
>> So we are back to needing to support two different irqchip drivers
>> (v1/v2/v2m and v3/v4), instead of five or more, right?
>
> As long as we make sure that the variants are directly probed from the
> "canonical" driver (v2m from v2, ITS and v4 from v3), then we're OK.
Yes, that is our intention.

>
>>>> It does seem wrong to parse the tables in the irq-gic.c file though:
>>>> that part can well be common across the various gic versions and then
>>>> call into either irq-gic.c or irq-gic-v3.c for the version specific
>>>> parts. Whether we put that common code into drivers/irqchip/irqchip.c,
>>>> drivers/irqchip/gic-common.c, drivers/irqchip/irq-acpi-gic.c or
>>>> drivers/acpi/irq-gic.c I don't care at all.
>>>
>>> I don't think so you can make that common code very easily. The
>>> information required by both drivers is organized differently.
>>> If it was, I'd have done that for the DT binding.
>>
>> I see, and that's also what Tomasz just explained. So can we just
>> have one an irqchip_init() function doing this:?
>>
>> if (dt)
>> 	of_irq_init(__irqchip_of_table);
>> else if (acpi) {
>> 	read cpu-interface and redistributor address from acpi tables
>> 	if (cpu-interface)
>> 		gic_v2_acpi_init(table);
>> 	else if(redistributor)
>> 		gic_v3_acpi_init(table)
>> }
>
> That'd be better, but that only considers the basic architecture. GICv2m
> and GICv3's ITS bring additional complexity (and their own table
> parsing). At that stage, I'm not sure how much commonality we're left with.

Right, my local ACPI GICv3 support assumes to probe ITS from 
gic_v3_acpi_init() body.

Tomasz
