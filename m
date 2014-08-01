Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaHAPmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:42:49 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:3573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbaHAPmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:42:46 -0400
X-WSS-ID: 0N9MWYZ-08-FTC-02
X-M-MSG: 
Message-ID: <53DBB562.5020003@amd.com>
Date: Fri, 1 Aug 2014 10:42:26 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
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
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
 <87zjfqj3mc.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87zjfqj3mc.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(51444003)(164054003)(189002)(199002)(479174003)(377454003)(20776003)(47776003)(65806001)(64706001)(80316001)(19580405001)(83322001)(84676001)(46102001)(102836001)(21056001)(33656002)(36756003)(81542001)(76482001)(50986999)(76176999)(80022001)(65956001)(101416001)(92726001)(110136001)(74662001)(83072002)(23756003)(92566001)(59896001)(68736004)(74502001)(31966008)(64126003)(77982001)(87936001)(44976005)(83506001)(81342001)(19580395003)(54356999)(65816999)(107046002)(99396002)(85852003)(87266999)(95666004)(86362001)(106466001)(105586002)(50466002)(97736001)(79102001)(4396001)(85306004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:3;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2014 9:57 AM, Marc Zyngier wrote:
> On Thu, Jul 10 2014 at 12:05:03 am BST, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com> wrote:
>
> Hi Suravee,
>
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
 >> ......
 >>
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
> Given that the v2m block is somehow bolted on the side of a standard
> GICv2, I'd rather see it as a subnode of the main GIC.
>
> Then you could directly call into the v2m layer to initialize it,
> instead of the odd "reverse probing" you're using here...

[Suravee] IIUC, you don't think we should introduce the "gic-400-v2m" 
compatible ID. Instead, you want to see something like:

     gic @ 0x00f00000 {
         .....
         v2m {
             msi-controller;
             reg = < .... >; /* v2m reg frame */
         }
     }

If so, I can change this.


>> +
>> +static int __init
>> +gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
>> +{
>> +       unsigned int val;
>> +
>> +       if (of_address_to_resource(node, GIC_OF_MSIV2M_RANGE_INDEX,
>> +                                  &v2m->res)) {
>> +               pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       v2m->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
>> +       if (!v2m->base) {
>> +               pr_err("GICv2m: Failed to map GIC MSI registers\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       val = readl_relaxed(v2m->base + V2M_MSI_TYPER);
>> +       if (!val) {
>> +               pr_warn("GICv2m: Failed to read V2M_MSI_TYPER register\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       v2m->spi_start = (val >> V2M_MSI_TYPER_BASE_SHIFT) &
>> +                               V2M_MSI_TYPER_BASE_MASK;
>> +       v2m->nr_spis = val & V2M_MSI_TYPER_NUM_MASK;
>> +       if ((v2m->spi_start < V2M_MIN_SPI) || (v2m->nr_spis >= V2M_MAX_SPI)) {
>> +                       pr_err("GICv2m: Invalid MSI_TYPER (%#x)\n", val);
>> +                       return -EINVAL;
>> +       }
>> +
>> +       v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
>> +                         GFP_KERNEL);
>> +       if (!v2m->bm) {
>> +               pr_err("GICv2m: Failed to allocate MSI bitmap\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       spin_lock_init(&v2m->msi_cnt_lock);
>> +
>> +       pr_info("GICv2m: SPI range [%d:%d]\n",
>> +               v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
>> +
>> +       return 0;
>> +}
>
> This function is assuming that you will only see one single MSI frame
> here. Is there any chance that there would be more than one in a system?
>

[Suravee] If I would imagine such SOC, where there are multiple MSI 
frames (hence multiple msi-controllers), can we currently support this 
with the current msichip interface?  Currently, each PCI RC connects to 
an "interrupt-parrent", which is also an MSI controller. We would need 
to have a way for PCI RC to specify which of the msichips within an 
interrupt-controller it wants to use.

Currently, I am not aware if there is a GIC w/ multiple MSI frames. 
Could you check if there is such product for ARM GICs?

>> +
>> +static void gicv2m_mask_irq(struct irq_data *d)
>> +{
>> +       gic_mask_irq(d);
>> +       if (d->msi_desc)
>> +               mask_msi_irq(d);
>> +}
>> +
>> +static void gicv2m_unmask_irq(struct irq_data *d)
>> +{
>> +       gic_unmask_irq(d);
>> +       if (d->msi_desc)
>> +               unmask_msi_irq(d);
>> +}
>> +
>> +static struct irq_chip gicv2m_chip = {
>> +       .name                   = "GICv2m",
>> +       .irq_mask               = gicv2m_mask_irq,
>> +       .irq_unmask             = gicv2m_unmask_irq,
>> +       .irq_eoi                = gic_eoi_irq,
>> +       .irq_set_type           = gic_set_type,
>> +       .irq_retrigger          = gic_retrigger,
>
> I think you can loose the retrigger here.
>
OK.

>> +#ifdef CONFIG_SMP
>> +       .irq_set_affinity       = gic_set_affinity,
>> +#endif
>> +#ifdef CONFIG_PM
>> +       .irq_set_wake           = gic_set_wake,
>> +#endif
>> +};
>> +
>> +#ifdef CONFIG_OF
>> +static int __init
>> +gicv2m_of_init(struct device_node *node, struct device_node *parent)
>> +{
>> +       struct gic_chip_data *gic;
>> +       int ret;
>> +
>> +       ret = _gic_of_init(node, parent, &gicv2m_chip, &gic);
>> +       if (ret) {
>> +               pr_err("GICv2m: Failed to initialize GIC\n");
>> +               return ret;
>> +       }
>> +
>> +       gic->msi_chip.owner = THIS_MODULE;
>> +       gic->msi_chip.of_node = node;
>> +       gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
>> +       gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
>> +       ret = of_pci_msi_chip_add(&gic->msi_chip);
>> +       if (ret) {
>> +               /* MSI is optional and not supported here */
>> +               pr_info("GICv2m: MSI is not supported.\n");
>> +               return 0;
>> +       }
>> +
>> +       ret = gicv2m_msi_init(node, &gic->v2m_data);
>> +       if (ret)
>> +               return ret;
>> +       return ret;
>> +}
>> +
>> +IRQCHIP_DECLARE(arm_gic_400_v2m, "arm,gic-400-v2m", gicv2m_of_init);
>
> So if you follow my advise of reversing your probing and call into the
> v2m init from the main GIC driver, you could take a irq_chip as a
> parameter, and use it to populate the v2m irq_chip, only overriding the
> two methods that actually differ.
>
> This would have the net effect of completely dropping patch #2, which
> becomes effectively useless.
>

[Suravee] Ok, lemme look into this.

>>   struct gic_chip_data {
>>          union gic_base dist_base;
>>          union gic_base cpu_base;
>> @@ -20,12 +31,23 @@ struct gic_chip_data {
>>   #endif
>>          struct irq_domain *domain;
>>          unsigned int gic_irqs;
>> -       struct irq_chip *irq_chip;
>>   #ifdef CONFIG_GIC_NON_BANKED
>>          void __iomem *(*get_base)(union gic_base *);
>>   #endif
>> +       struct irq_chip *irq_chip;
>> +       struct msi_chip msi_chip;
>> +#ifdef CONFIG_ARM_GIC_V2M
>> +       struct v2m_data v2m_data;
>> +#endif
>
> Why isn't msi_chip directly part of v2m_data? I think that would make
> some of the code slightly clearer, and avoid polluting unsuspecting
> architectures...
>

[Suravee] I can do that.

>>   };
>>
>> +#ifdef CONFIG_OF
>> +int _gic_of_init(struct device_node *node,
>> +                struct device_node *parent,
>> +                struct irq_chip *chip,
>> +                struct gic_chip_data **gic) __init;
>> +#endif
>> +
>>   void gic_mask_irq(struct irq_data *d);
>>   void gic_unmask_irq(struct irq_data *d);
>>   void gic_eoi_irq(struct irq_data *d);
>> @@ -42,11 +64,4 @@ int gic_set_affinity(struct irq_data *d,
>>   int gic_set_wake(struct irq_data *d, unsigned int on);
>>   #endif
>>
>> -#ifdef CONFIG_OF
>> -int _gic_of_init(struct device_node *node,
>> -                struct device_node *parent,
>> -                struct irq_chip *chip,
>> -                struct gic_chip_data **gic) __init;
>> -#endif
>> -
>>   #endif /* _IRQ_GIC_H_ */
>
> What is the purpose of this move?
>
[Suravee] No need. I might have accidentally moved it.

Thanks,

Suravee


