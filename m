Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbaGBUEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:04:43 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:27894
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756124AbaGBUEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:04:41 -0400
X-WSS-ID: 0N83P3A-07-43V-02
X-M-MSG: 
Message-ID: <53B465B9.7000407@amd.com>
Date: Wed, 2 Jul 2014 15:04:09 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140702163903.GA26903@leverpostej>
In-Reply-To: <20140702163903.GA26903@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(164054003)(479174003)(377454003)(189002)(199002)(52604005)(51704005)(81342001)(87936001)(81542001)(92726001)(107046002)(46102001)(19580405001)(83322001)(21056001)(20776003)(105586002)(65956001)(80022001)(19580395003)(44976005)(84676001)(106466001)(76482001)(64126003)(83506001)(36756003)(102836001)(86362001)(92566001)(95666004)(85306003)(97736001)(50986999)(77982001)(87266999)(79102001)(85852003)(31966008)(54356999)(47776003)(59896001)(23756003)(76176999)(33656002)(83072002)(101416001)(50466002)(99396002)(4396001)(65816999)(64706001)(74662001)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0201MB0920;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again for the review. Please see my comments below.

On 7/2/2014 11:39 AM, Mark Rutland wrote:
> On Wed, Jul 02, 2014 at 04:22:23PM +0100, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>> index 5573c08..9e46f7f 100644
>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>> @@ -12,11 +12,13 @@ Main node required properties:
>>
>>   - compatible : should be one of:
>>          "arm,gic-400"
>> +       "arm,gic-400-plus"
>
> I am not keen on this name.

Ok, I'll change it. Any suggestion on name?  I'm not sure what is the 
"official" product name. I've seen this in some slides from ARM. What 
about "gic-400-v2m"??.

>>          "arm,cortex-a15-gic"
>>          "arm,cortex-a9-gic"
>>          "arm,cortex-a7-gic"
>>          "arm,arm11mp-gic"
>>   - interrupt-controller : Identifies the node as an interrupt controller
>> +
>>   - #interrupt-cells : Specifies the number of cells needed to encode an
>>     interrupt source.  The type shall be a <u32> and the value shall be 3.
>
> Random (inconsistent) whitespace change?
It looks to me like there should have been a space here to keep the 
consistent look, and make it easy to read

>> @@ -37,9 +39,16 @@ Main node required properties:
>>          the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
>>          the interrupt is wired to that CPU.  Only valid for PPI interrupts.
>>
>> -- reg : Specifies base physical address(s) and size of the GIC registers. The
>> -  first region is the GIC distributor register base and size. The 2nd region is
>> -  the GIC cpu interface register base and size.
>> +- reg : Specifies base physical address(s) and size of the GIC register frames.
>> +
>> +  Region | Description
>> +  Index  |
>> +  -------------------------------------------------------------------
>> +     0   | GIC distributor register base and size
>> +     1   | GIC cpu interface register base and size
>> +     2   | VGIC interface control register base and size (Optional)
>> +     3   | VGIC CPU interface register base and size (Optional)
>> +     4   | GICv2m MSI interface register base and size (Optional)
>
> As far as I am aware, the MSI interface is completely orthogonal to
> having a GICH and GICV.

Agree. I'm not doing anything with it. I'm just listing them here since 
they are also mentioned in the gic.txt

>
> We should figure out how we expect to handle that (zero-sized reg
> entries? reg-names?).

I'm not sure how VGIC stuff handles reg/size = 0.

>
>>
>>   Optional
>>   - interrupts   : Interrupt source of the parent interrupt controller on
>> @@ -55,6 +64,10 @@ Optional
>>                    by a crossbar/multiplexer preceding the GIC. The GIC irq
>>                    input line is assigned dynamically when the corresponding
>>                    peripheral's crossbar line is mapped.
>> +
>> +- msi-controller : Identifies the node as an MSI controller.  This requires
>> +  the register region index 4.
>
> That last clarifying comment is more confusing than helpful.

If you are referring to the table, I added that since it was easier to 
see than scanning the text.

> [...]
>
>> +#define GIC_V2M_MIN_SPI                        32
>> +#define GIC_V2M_MAX_SPI                        1024
>
> GIC interrupt IDs 1020 and above are reserved, no?
>
> Surely the max ID an SPI can take is 1019?

Right, thanks for catching. But the spec says that the SPI ID value must 
be in the range of 32 to 1020. I guess it was a bit unclear, but 
definitely not 1024 :)

>> +#define GIC_OF_MSIV2M_RANGE_INDEX      4
>> +
>> +/**
>> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
>> + * @data: Pointer to v2m_data
>> + * @nvec: Number of interrupts to allocate
>> + * @irq: Pointer to the allocated irq
>> + *
>> + * Allocates interrupts only if the contiguous range of MSIs
>> + * with specified nvec are available. Otherwise return the number
>> + * of available interrupts. If none are available, then returns -ENOENT.
>> + */
>
> This function is overly complicated, and pointlessly so.
>
> It doesn't achieve anything useful as it returns the size of the _last_
> contiguous block rather than the _largest_ contiguous block, and the
> only caller (gicv2m_setup_msi_irq) doesn't even care.
>
> Simplify this to just return an error code if allocation is impossible.

Actually, I made another mistake in the gicv2m_setup_msi_irq when 
returning from the alloc_msi_irq().

My understanding is the arch_setup_msi_irqs() is supposed to return the 
number of available vectors if the requested amount could not be 
allocated. I notice that the current "drivers/pci/msi.c: 
arch_setup_msi_irqs()" does not do so, which is okay.

However, We are also working on adding support for multi-MSI support 
since some of the devices we have are using it, which means we will need 
to provide a different version of the "arch_setup_msi_irqs()" as the 
current one does not allow (PCI_CAP_ID_MSI && nvec > 1).

Therefore, I implemented the "alloc_msi_irq" this way to account for 
future changes.

Thanks,

Suravee

