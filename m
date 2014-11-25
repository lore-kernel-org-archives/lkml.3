Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKYVIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:08:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62060 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <1416839720-18400-11-git-send-email-marc.zyngier@arm.com>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
	<1416839720-18400-11-git-send-email-marc.zyngier@arm.com>
Date: Tue, 25 Nov 2014 15:08:07 -0600
Message-ID: <CALRxmdA=_aTbRM+471cSkxTtbZ=nErB+tsEBt3+6M9-zi7E5-w@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] irqchip: GICv3: ITS: DT probing and initialization
From: Stuart Yoder <b08248@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 8:35 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Add the code that probes the ITS from the device tree,
> and initialize it.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 169 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 169 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 532c6df..e9d1615 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1231,3 +1231,172 @@ static const struct irq_domain_ops its_domain_ops = {
>         .alloc                  = its_irq_domain_alloc,
>         .free                   = its_irq_domain_free,
>  };
> +
> +static int its_probe(struct device_node *node, struct irq_domain *parent)
> +{
> +       struct resource res;
> +       struct its_node *its;
> +       void __iomem *its_base;
> +       u32 val;
> +       u64 baser, tmp;
> +       int err;
> +
> +       err = of_address_to_resource(node, 0, &res);
> +       if (err) {
> +               pr_warn("%s: no regs?\n", node->full_name);
> +               return -ENXIO;
> +       }
> +
> +       its_base = ioremap(res.start, resource_size(&res));
> +       if (!its_base) {
> +               pr_warn("%s: unable to map registers\n", node->full_name);
> +               return -ENOMEM;
> +       }
> +
> +       val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
> +       if (val != 0x30 && val != 0x40) {
> +               pr_warn("%s: no ITS detected, giving up\n", node->full_name);
> +               err = -ENODEV;
> +               goto out_unmap;
> +       }
> +
> +       pr_info("ITS: %s\n", node->full_name);
> +
> +       its = kzalloc(sizeof(*its), GFP_KERNEL);
> +       if (!its) {
> +               err = -ENOMEM;
> +               goto out_unmap;
> +       }
> +
> +       raw_spin_lock_init(&its->lock);
> +       INIT_LIST_HEAD(&its->entry);
> +       INIT_LIST_HEAD(&its->its_device_list);
> +       its->base = its_base;
> +       its->phys_base = res.start;
> +       its->msi_chip.of_node = node;
> +       its->ite_size = ((readl_relaxed(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
> +
> +       its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
> +       if (!its->cmd_base) {
> +               err = -ENOMEM;
> +               goto out_free_its;
> +       }
> +       its->cmd_write = its->cmd_base;
> +
> +       err = its_alloc_tables(its);
> +       if (err)
> +               goto out_free_cmd;
> +
> +       err = its_alloc_collections(its);
> +       if (err)
> +               goto out_free_tables;
> +
> +       baser = (virt_to_phys(its->cmd_base)    |
> +                GITS_CBASER_WaWb               |
> +                GITS_CBASER_InnerShareable     |
> +                (ITS_CMD_QUEUE_SZ / SZ_4K - 1) |
> +                GITS_CBASER_VALID);
> +
> +       writeq_relaxed(baser, its->base + GITS_CBASER);
> +       tmp = readq_relaxed(its->base + GITS_CBASER);
> +       writeq_relaxed(0, its->base + GITS_CWRITER);
> +       writel_relaxed(1, its->base + GITS_CTLR);
> +
> +       if ((tmp ^ baser) & GITS_BASER_SHAREABILITY_MASK) {
> +               pr_info("ITS: using cache flushing for cmd queue\n");
> +               its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
> +       }
> +
> +       if (of_property_read_bool(its->msi_chip.of_node, "msi-controller")) {
> +               its->domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
> +               if (!its->domain) {
> +                       err = -ENOMEM;
> +                       goto out_free_tables;
> +               }
> +
> +               its->domain->parent = parent;
> +
> +               its->msi_chip.domain = pci_msi_create_irq_domain(node,
> +                                                                &its_pci_msi_domain_info,
> +                                                                its->domain);
> +               if (!its->msi_chip.domain) {
> +                       err = -ENOMEM;
> +                       goto out_free_domains;
> +               }
> +
> +               err = of_pci_msi_chip_add(&its->msi_chip);
> +               if (err)
> +                       goto out_free_domains;
> +       }

Hi Marc,

We have a requirement to have both PCI and non-PCI buses use the GIC_ITS.
Above, you have the hardcoded assumption that this is PCI.  How do 2 different
bus types share the ITS at the same time.

Thanks,
Stuart Yoder
Freescale
