Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaKZKOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:14:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39522 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:14:48 -0500
Message-ID: <5475A80A.3010305@arm.com>
Date: Wed, 26 Nov 2014 10:14:34 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stuart Yoder <b08248@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 10/13] irqchip: GICv3: ITS: DT probing and initialization
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>	<1416839720-18400-11-git-send-email-marc.zyngier@arm.com> <CALRxmdA=_aTbRM+471cSkxTtbZ=nErB+tsEBt3+6M9-zi7E5-w@mail.gmail.com>
In-Reply-To: <CALRxmdA=_aTbRM+471cSkxTtbZ=nErB+tsEBt3+6M9-zi7E5-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stuart,

On 25/11/14 21:08, Stuart Yoder wrote:
> On Mon, Nov 24, 2014 at 8:35 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Add the code that probes the ITS from the device tree,
>> and initialize it.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 169 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 169 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 532c6df..e9d1615 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -1231,3 +1231,172 @@ static const struct irq_domain_ops its_domain_ops = {
>>         .alloc                  = its_irq_domain_alloc,
>>         .free                   = its_irq_domain_free,
>>  };
>> +
>> +static int its_probe(struct device_node *node, struct irq_domain *parent)
>> +{
>> +       struct resource res;
>> +       struct its_node *its;
>> +       void __iomem *its_base;
>> +       u32 val;
>> +       u64 baser, tmp;
>> +       int err;
>> +
>> +       err = of_address_to_resource(node, 0, &res);
>> +       if (err) {
>> +               pr_warn("%s: no regs?\n", node->full_name);
>> +               return -ENXIO;
>> +       }
>> +
>> +       its_base = ioremap(res.start, resource_size(&res));
>> +       if (!its_base) {
>> +               pr_warn("%s: unable to map registers\n", node->full_name);
>> +               return -ENOMEM;
>> +       }
>> +
>> +       val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
>> +       if (val != 0x30 && val != 0x40) {
>> +               pr_warn("%s: no ITS detected, giving up\n", node->full_name);
>> +               err = -ENODEV;
>> +               goto out_unmap;
>> +       }
>> +
>> +       pr_info("ITS: %s\n", node->full_name);
>> +
>> +       its = kzalloc(sizeof(*its), GFP_KERNEL);
>> +       if (!its) {
>> +               err = -ENOMEM;
>> +               goto out_unmap;
>> +       }
>> +
>> +       raw_spin_lock_init(&its->lock);
>> +       INIT_LIST_HEAD(&its->entry);
>> +       INIT_LIST_HEAD(&its->its_device_list);
>> +       its->base = its_base;
>> +       its->phys_base = res.start;
>> +       its->msi_chip.of_node = node;
>> +       its->ite_size = ((readl_relaxed(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
>> +
>> +       its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
>> +       if (!its->cmd_base) {
>> +               err = -ENOMEM;
>> +               goto out_free_its;
>> +       }
>> +       its->cmd_write = its->cmd_base;
>> +
>> +       err = its_alloc_tables(its);
>> +       if (err)
>> +               goto out_free_cmd;
>> +
>> +       err = its_alloc_collections(its);
>> +       if (err)
>> +               goto out_free_tables;
>> +
>> +       baser = (virt_to_phys(its->cmd_base)    |
>> +                GITS_CBASER_WaWb               |
>> +                GITS_CBASER_InnerShareable     |
>> +                (ITS_CMD_QUEUE_SZ / SZ_4K - 1) |
>> +                GITS_CBASER_VALID);
>> +
>> +       writeq_relaxed(baser, its->base + GITS_CBASER);
>> +       tmp = readq_relaxed(its->base + GITS_CBASER);
>> +       writeq_relaxed(0, its->base + GITS_CWRITER);
>> +       writel_relaxed(1, its->base + GITS_CTLR);
>> +
>> +       if ((tmp ^ baser) & GITS_BASER_SHAREABILITY_MASK) {
>> +               pr_info("ITS: using cache flushing for cmd queue\n");
>> +               its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
>> +       }
>> +
>> +       if (of_property_read_bool(its->msi_chip.of_node, "msi-controller")) {
>> +               its->domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
>> +               if (!its->domain) {
>> +                       err = -ENOMEM;
>> +                       goto out_free_tables;
>> +               }
>> +
>> +               its->domain->parent = parent;
>> +
>> +               its->msi_chip.domain = pci_msi_create_irq_domain(node,
>> +                                                                &its_pci_msi_domain_info,
>> +                                                                its->domain);
>> +               if (!its->msi_chip.domain) {
>> +                       err = -ENOMEM;
>> +                       goto out_free_domains;
>> +               }
>> +
>> +               err = of_pci_msi_chip_add(&its->msi_chip);
>> +               if (err)
>> +                       goto out_free_domains;
>> +       }
> 
> Hi Marc,
> 
> We have a requirement to have both PCI and non-PCI buses use the GIC_ITS.
> Above, you have the hardcoded assumption that this is PCI.  How do 2 different
> bus types share the ITS at the same time.

This set of patches specifically targets PCI, as this is the only thing
that I can realistically test.

When it comes to non-PCI uses of the ITS, it shouldn't be too hard: just
instantiate a non-PCI MSI domain sitting on top of the same ITS domain.
The split in responsibilities between MSI and ITS domains is designed to
cover exactly this.

This of course assumes that your non-PCI devices behave in a similar way
to PCI devices (programmable event ID, as well as unique, discoverable
device IDs).

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
