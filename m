Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaKXPc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:32:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38159 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaKXPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:32:56 -0500
Message-ID: <54734F99.7000609@arm.com>
Date: Mon, 24 Nov 2014 15:32:41 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 06/13] irqchip: GICv3: ITS: LPI allocator
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-7-git-send-email-marc.zyngier@arm.com> <5473476E.5070305@linux.intel.com>
In-Reply-To: <5473476E.5070305@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/14 14:57, Jiang Liu wrote:
> 
> 
> On 2014/11/24 22:35, Marc Zyngier wrote:
>> LPIs are the type of interrupts that are used by the ITS. Given
>> the size of the namespace (anywhere between 16 and 32bit), interrupt
>> IDs are allocated in chunks of 32.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 103 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 103 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index d24bebd..4154a16 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -586,3 +586,106 @@ static struct irq_chip its_irq_chip = {
>>  	.irq_eoi		= its_eoi_irq,
>>  	.irq_set_affinity	= its_set_affinity,
>>  };
>> +
>> +/*
>> + * How we allocate LPIs:
>> + *
>> + * The GIC has id_bits bits for interrupt identifiers. From there, we
>> + * must subtract 8192 which are reserved for SGIs/PPIs/SPIs. Then, as
>> + * we allocate LPIs by chunks of 32, we can shift the whole thing by 5
>> + * bits to the right.
> Just curious, why 32? sizeof(long) is 4 on ARM64?

No, sizeof(long) == 8, as on any sane 64bit architecture.

There are two reasons for this:
- the ID space is rather large (at least 16 bits, possibly 32 bits), so
we're trying not to allocate the whole bitmap in one go.
- 32 is the maximum a MSI-capable device can request. Allocating 32
interrupts in one go makes sure that these interrupts are contiguous and
satisfy the MSI requirements.

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
