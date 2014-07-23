Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaGWRPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:15:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35071 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaGWRPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:15:49 -0400
Message-ID: <53CFF866.6060703@ti.com>
Date: Wed, 23 Jul 2014 21:01:10 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, <santosh.shilimkar@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        <ivan.khoronzhuk@ti.com>, <m-karicheri2@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] irqchip: add keystone irq controller ip driver
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com> <53CFD581.5040908@gmail.com>
In-Reply-To: <53CFD581.5040908@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/23/2014 06:32 PM, Varka Bhadram wrote:
> 
> On Wednesday 23 July 2014 08:10 PM, Grygorii Strashko wrote:
>> On Keystone SOCs, DSP cores can send interrupts to ARM
>> host using the IRQ controller IP. It provides 28 IRQ
>> signals to ARM. The IRQ handler running on HOST OS can
>> identify DSP signal source by analyzing SRCCx bits in
>> IPCARx registers. This is one of the component used by
>> the IPC mechanism used on Keystone SOCs.
> 
> (...)
> 
>> +Required Properties:
>> +- compatible: should be "ti,keystone-irq"
>> +- ti,syscon-dev : phandle and offset pair. The phandle to syscon used to
>> +            access device control registers and the offset inside
>> +            device control registers range.
>> +- interrupt-controller : Identifies the node as an interrupt controller
>> +- #interrupt-cells : Specifies the number of cells needed to encode 
>> interrupt
>> +                     source should be 1.
>> +- interrupts: interrupt reference to primary interrupt controller
> 
> proper indentation for the properties
> 
> - compatible        : Should be "ti,keystone-irq"
> - ti,syscon-dev        : phandle and offset pair. The phandle to syscon 
> used to
>                access device control registers and the offset inside
>                device control registers range.
> 
>> +
>> +Please refer to interrupts.txt in this directory for details of the 
>> common
>> +Interrupt Controllers bindings used by client devices.
>> +
> 
> (...)
> 
>> +#include <linux/irq.h>
>> +#include <linux/bitops.h>
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/irqchip/chained_irq.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
> 
> Includes in alphabetical order...
> 
> Give one line gap before local includes..
> 
> ...
> #include <linux/regmap.h>
> 
> #include "irqchip.h"
> 
>> +#include "irqchip.h"
>> +
>> +
>> +/* The source ID bits start from 4 to 31 (total 28 bits)*/
>> +#define BIT_OFS            4
>> +#define KEYSTONE_N_IRQ        (32 - BIT_OFS)
>> +
>> +struct keystone_irq_device {
>> +    struct device        *dev;
>> +    struct irq_chip         chip;
>> +    u32             mask;
>> +    u32             irq;
>> +    struct irq_domain    *irqd;
>> +    struct regmap        *devctrl_regs;
>> +    u32            devctrl_offset;
>> +};
>> +
>> +static inline u32 keystone_irq_readl(struct keystone_irq_device *kirq)
>> +{
>> +    int ret;
>> +    u32 val = 0;
>> +
>> +    ret = regmap_read(kirq->devctrl_regs, kirq->devctrl_offset, &val);
>> +    if (ret < 0)
>> +        dev_dbg(kirq->dev, "irq read failed ret(%d)\n", ret);
>> +    return val;
>> +}
>> +
>> +static inline void
>> +keystone_irq_writel(struct keystone_irq_device *kirq, u32 value)
>> +{
>> +    int ret;
>> +
>> +    ret = regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value);
>> +    if (ret < 0)
>> +        dev_dbg(kirq->dev, "irq write failed ret(%d)\n", ret);
> 
> It can be like
> 
> if (!regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value))
>      dev_dbg(kirq->dev, "irq write failed \n");
> 
>> +}
>> +
>> +

Pls, Pay attention that I'd like to see ret code here in case of failure.

> 
> (...)
> 
>> +}
>> +
>> +static int keystone_irq_map(struct irq_domain *h, unsigned int virq,
>> +                irq_hw_number_t hw)
> 
> should match open parenthesis:
> 
> static int keystone_irq_map(struct irq_domain *h, unsigned int virq,
>                  irq_hw_number_t hw)
> 
>> +{
>> +    struct keystone_irq_device *kirq = h->host_data;
>> +
>> +    irq_set_chip_data(virq, kirq);
>> +    irq_set_chip_and_handler(virq, &kirq->chip, handle_level_irq);
>> +    set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
>> +    return 0;
>> +}
>> +
>> +static struct irq_domain_ops keystone_irq_ops = {
>> +    .map    = keystone_irq_map,
>> +    .xlate    = irq_domain_xlate_onecell,
>> +};
>> +
>> +static int keystone_irq_probe(struct platform_device *pdev)
>> +{
>> +    struct device *dev = &pdev->dev;
>> +    struct device_node *np = dev->of_node;
>> +    struct keystone_irq_device *kirq;
>> +    int ret;
>> +
>> +    if (np == NULL)
>> +        return -EINVAL;
> 
> return -ENODEV??????

If probe is executed - the dev is present, but it was created in a wrong/unsupported way
or dev structure contains wrong data.

> 
> (...)
> 
>> +static struct platform_driver keystone_irq_device_driver = {
>> +    .probe        = keystone_irq_probe,
>> +    .remove        = keystone_irq_remove,
>> +    .driver        = {
>> +        .name    = "keystone_irq",
>> +        .owner    = THIS_MODULE,
> 
> No need to update it. Its done by module_platform_driver()..
> 
>> +        .of_match_table    = of_match_ptr(keystone_irq_dt_ids),
> 
> This driver is always populate through the dts file. So no need to use
> of_match_ptr....
> 

Regards,
-grygorii
