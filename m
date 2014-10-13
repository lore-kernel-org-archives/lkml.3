Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaJMOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:14:48 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:57032 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaJMOOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <543BD71F.7020000@gmail.com>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com>
	<1412864980-20273-5-git-send-email-yingjoe.chen@mediatek.com>
	<543BD71F.7020000@gmail.com>
Date: Mon, 13 Oct 2014 16:14:44 +0200
Message-ID: <CABuKBeJYPm-vJo_XfwJmadE1no9bCOmqtDdJT4pEHFUVm9oE+Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] ARM: mediatek: Add sysirq interrupt polarity support
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>, arm@kernel.org,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-13 15:43 GMT+02:00 Matthias Brugger <matthias.bgg@gmail.com>:
>
>
> On 09/10/14 16:29, Joe.C wrote:
>> From: "Joe.C" <yingjoe.chen@mediatek.com>
>>
>> Mediatek SoCs have interrupt polarity in sysirq which allows
>> to swap the polarity for given interrupts. Add this support
>> using hierarchy irq domain.
>>
>> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
>> ---
>>  arch/arm/mach-mediatek/Kconfig      |   1 +
>>  drivers/irqchip/Makefile            |   1 +
>>  drivers/irqchip/irq-mt65xx-sysirq.c | 170 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 172 insertions(+)
>>  create mode 100644 drivers/irqchip/irq-mt65xx-sysirq.c
>>
>> diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
>> index 2c043a2..7093859 100644
>> --- a/arch/arm/mach-mediatek/Kconfig
>> +++ b/arch/arm/mach-mediatek/Kconfig
>> @@ -2,5 +2,6 @@ config ARCH_MEDIATEK
>>       bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
>>       select ARM_GIC
>>       select MTK_TIMER
>> +     select IRQ_DOMAIN_HIERARCHY
>>       help
>>         Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
>> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
>> index 73052ba..809c9d5 100644
>> --- a/drivers/irqchip/Makefile
>> +++ b/drivers/irqchip/Makefile
>> @@ -34,3 +34,4 @@ obj-$(CONFIG_XTENSA)                        += irq-xtensa-pic.o
>>  obj-$(CONFIG_XTENSA_MX)                      += irq-xtensa-mx.o
>>  obj-$(CONFIG_IRQ_CROSSBAR)           += irq-crossbar.o
>>  obj-$(CONFIG_BRCMSTB_L2_IRQ)         += irq-brcmstb-l2.o
>> +obj-$(CONFIG_ARCH_MEDIATEK)          += irq-mt65xx-sysirq.o
>> diff --git a/drivers/irqchip/irq-mt65xx-sysirq.c b/drivers/irqchip/irq-mt65xx-sysirq.c
>> new file mode 100644
>> index 0000000..9e0eee5
>> --- /dev/null
>> +++ b/drivers/irqchip/irq-mt65xx-sysirq.c
>> @@ -0,0 +1,170 @@
>> +/*
>> + * Copyright (c) 2014 MediaTek Inc.
>> + * Author: Joe.C <yingjoe.chen@mediatek.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/of.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_address.h>
>> +#include <linux/io.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
>> +
>> +#include "irqchip.h"
>> +
>> +#define MT6577_SYS_INTPOL_NUM        (224)
>> +
>> +struct mt_sysirq_chip_data {
>> +     spinlock_t lock;
>> +     void __iomem *intpol_base;
>> +};
>> +
>> +
>> +static int mt_sysirq_set_type(struct irq_data *data, unsigned int type)
>
> Are the mt_sysirq_ prefixed functions special to mt65xx processors? In
> this case you should prefix them mt65xx_sysirq_
> If not, please rename to mtk_sysirq_ to have a consistency in the kernel.
>
>> +{
>> +     irq_hw_number_t hwirq = data->hwirq;
>> +     struct mt_sysirq_chip_data *chip_data = data->chip_data;
>> +     u32 offset, reg_index, value;
>> +     unsigned long flags;
>> +     int ret;
>> +
>> +     offset = hwirq & 0x1f;
>> +     reg_index = hwirq >> 5;
>> +
>> +     spin_lock_irqsave(&chip_data->lock, flags);
>> +     value = readl_relaxed(chip_data->intpol_base + reg_index * 4);
>> +     if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING) {
>> +             if (type == IRQ_TYPE_LEVEL_LOW)
>> +                     type = IRQ_TYPE_LEVEL_HIGH;
>> +             else
>> +                     type = IRQ_TYPE_EDGE_RISING;
>> +             value |= (1 << offset);
>> +     } else
>> +             value &= ~(1 << offset);
>> +     writel(value, chip_data->intpol_base + reg_index * 4);
>> +
>> +     data = data->parent_data;
>> +     ret = data->chip->irq_set_type(data, type);
>> +     spin_unlock_irqrestore(&chip_data->lock, flags);
>> +     return ret;
>> +}
>> +
>> +static struct irq_chip mt_sysirq_chip = {
>> +     .name                   = "MT_SYSIRQ",
>> +     .irq_mask               = irq_chip_mask_parent,
>> +     .irq_unmask             = irq_chip_unmask_parent,
>> +     .irq_eoi                = irq_chip_eoi_parent,
>> +     .irq_set_type           = mt_sysirq_set_type,
>> +     .irq_retrigger          = irq_chip_retrigger_hierarchy,
>> +     .irq_set_affinity       = irq_chip_set_affinity_parent,
>> +};
>> +
>> +static int mt_sysirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
>> +                             unsigned int nr_irqs, void *arg)
>
> Same here.
>
>> +{
>> +     int i, ret;
>> +     irq_hw_number_t hwirq;
>> +     struct of_phandle_args *irq_data = arg;
>> +     unsigned int type;
>> +
>> +     if (irq_data->args_count != 3)
>> +             return -EINVAL;
>> +
>> +     hwirq = irq_data->args[1];
>> +     if (irq_find_mapping(domain, hwirq) > 0)
>> +             return -EEXIST;
>> +
>> +     for (i = 0; i < nr_irqs; i++)
>> +             irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
>> +                                     &mt_sysirq_chip, domain->host_data);
>> +
>> +     ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     type = irq_data->args[2] & IRQ_TYPE_SENSE_MASK;
>> +
>> +     /* Set type if specified and different than the current one */
>> +     if (type != IRQ_TYPE_NONE &&
>> +         type != irq_get_trigger_type(virq))
>> +             irq_set_irq_type(virq, type);
>> +
>> +     return 0;
>> +}
>> +
>> +static void mt_sysirq_domain_free(struct irq_domain *domain, unsigned int virq,
>> +                             unsigned int nr_irqs)
>
> Same here.
>
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < nr_irqs; i++) {
>> +             irq_set_handler(virq + i, NULL);
>> +             irq_domain_set_hwirq_and_chip(domain, virq + i, 0, NULL, NULL);
>> +     }
>> +     irq_domain_free_irqs_parent(domain, virq, nr_irqs);
>> +}
>> +
>> +static struct irq_domain_ops sysirq_domain_ops = {
>> +     .alloc = mt_sysirq_domain_alloc,
>> +     .free = mt_sysirq_domain_free,
>> +};
>> +
>> +static int __init mtk_sysirq_of_init(struct device_node *node,
>> +                                struct device_node *parent)
>> +{
>> +     struct device_node *parent_node;
>> +     struct irq_domain *domain, *domain_parent = NULL;
>> +     struct mt_sysirq_chip_data *chip_data;
>> +     int ret = 0;
>> +
>> +     parent_node = of_irq_find_parent(node);
>> +     if (parent_node) {
>> +             domain_parent = irq_find_host(parent_node);
>> +             of_node_put(parent_node);
>> +     }
>> +
>> +     if (!domain_parent) {
>> +             pr_err("mtk_sysirq: interrupt-parent not found\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
>> +     if (!chip_data)
>> +             return -ENOMEM;
>> +
>> +     chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
>> +     if (!chip_data->intpol_base) {
>> +             pr_err("mtk_sysirq: unable to map sysirq register\n");
>> +             ret = -ENOMEM;
>> +             goto out_free;
>> +     }
>> +
>> +     domain = irq_domain_add_linear(node, MT6577_SYS_INTPOL_NUM,
>> +                             &sysirq_domain_ops, chip_data);
>> +     if (!domain) {
>> +             ret = -ENOMEM;
>> +             goto out_unmap;
>> +     }
>> +     domain->parent = domain_parent;
>> +     spin_lock_init(&chip_data->lock);
>> +
>> +     return 0;
>> +
>> +out_unmap:
>> +     iounmap(chip_data->intpol_base);
>> +out_free:
>> +     kfree(chip_data);
>> +     return ret;
>> +}
>> +IRQCHIP_DECLARE(mtk_sysirq, "mediatek,mt6577-sysirq", mtk_sysirq_of_init);
>
> If this is compatible to all mt65xx from mt6577 upwards, we should
> rename the file to irq-mt6577-sysirq.c to have consistency in the naming.

After reviewing the patches, I see that this is compatible to mt6589
as well as to mt81xx, right?
In this case please rename the file to irq-mtk-sysirq.c
Although I think al the mt_ prefixed functions should be renamed using
mtk_ prefix.

Thanks,
Matthias

>
>>



-- 
motzblog.wordpress.com
