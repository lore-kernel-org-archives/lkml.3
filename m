Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaLDH3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:29:53 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44422 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaLDH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141204071854.GD25806@verge.net.au>
References: <20141203121753.5936.36253.sendpatchset@w520>
	<20141203121803.5936.35881.sendpatchset@w520>
	<20141204071854.GD25806@verge.net.au>
Date: Thu, 4 Dec 2014 16:29:49 +0900
Message-ID: <CANqRtoT_L5QE9D_xUBe4m75kLrB+qWAWrMZHf-260TFwqBXGXQ@mail.gmail.com>
Subject: Re: [PATCH 01/02] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Thu, Dec 4, 2014 at 4:18 PM, Simon Horman <horms@verge.net.au> wrote:
> Hi Magnus,
>
> I see you have been busy with the marzen board.

Yes! =)

> On Wed, Dec 03, 2014 at 09:18:03PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm+renesas@opensource.se>
>>
>> Add r8a7779 specific support for IRLM bit configuration
>> in the INTC-IRQPIN driver. Without this code we need
>> special workaround code in arch/arm/mach-shmobile.
>>
>> The IRLM bit for the INTC hardware exists on various
>> older SH-based SoCs and is used to select between two
>> modes for the external interrupt pins IRQ0 to IRQ3:
>>
>> IRLM = 0: (default from reset on r8a7779)
>> In this mode the pins IRQ0 to IRQ3 are used together
>> to give a value between 0 and 15 to the SoC. External
>> logic is required for masking. This mode is not
>> supported by the INTC-IRQPIN driver.
>>
>> IRLM = 1: (needs this patch or configuration elsewhere)
>> In this mode IRQ0 to IRQ3 operate as 4 individual
>> external interrupt pins. In this mode the SMSC ethernet
>> chip can be used via IRQ1 on r8a7779 Marzen. This mode
>> is the only supported mode by the INTC-IRQPIN driver.
>>
>> For this patch to work the r8a7779 DTS needs to pass
>> the ICR0 register as the last register bank.
>>
>> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
>> ---
>>
>>  Written against renesas-devel-20141202-v3.18-rc7 which is
>>  basically v3.18-rc7 plus latest arch/arm/mach-shmobile code.
>>
>>  Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt |    5 +
>>  drivers/irqchip/irq-renesas-intc-irqpin.c                                      |   50 ++++++++--
>>  2 files changed, 46 insertions(+), 9 deletions(-)
>>
>> --- 0001/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
>> +++ work/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt       2014-12-03 20:25:13.000000000 +0900
>> @@ -9,6 +9,11 @@ Required properties:
>>      - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
>>      - "renesas,intc-irqpin-r8a7779" (R-Car H1)
>>      - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
>> +
>> +- reg: Base address and length of each register bank used by the external
>> +  IRQ pins driven by the interrupt controller hardware module. The base
>> +  addresses, length and number of required register banks varies with soctype.
>> +
>>  - #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
>>    interrupts.txt in this directory
>>
>> --- 0001/drivers/irqchip/irq-renesas-intc-irqpin.c
>> +++ work/drivers/irqchip/irq-renesas-intc-irqpin.c    2014-12-03 20:32:59.000000000 +0900
>> @@ -30,6 +30,7 @@
>>  #include <linux/err.h>
>>  #include <linux/slab.h>
>>  #include <linux/module.h>
>> +#include <linux/of_device.h>
>>  #include <linux/platform_data/irq-renesas-intc-irqpin.h>
>>  #include <linux/pm_runtime.h>
>>
>> @@ -40,7 +41,9 @@
>>  #define INTC_IRQPIN_REG_SOURCE 2 /* INTREQnn */
>>  #define INTC_IRQPIN_REG_MASK 3 /* INTMSKnn */
>>  #define INTC_IRQPIN_REG_CLEAR 4 /* INTMSKCLRnn */
>> -#define INTC_IRQPIN_REG_NR 5
>> +#define INTC_IRQPIN_REG_NR_MANDATORY 5
>> +#define INTC_IRQPIN_REG_IRLM 5 /* ICR0 with IRLM bit (optional) */
>> +#define INTC_IRQPIN_REG_NR 6
>>
>>  /* INTC external IRQ PIN hardware register access:
>>   *
>> @@ -82,6 +85,10 @@ struct intc_irqpin_priv {
>>       u8 shared_irq_mask;
>>  };
>>
>> +struct intc_irqpin_irlm_config {
>> +     unsigned int irlm_bit;
>> +};
>> +
>>  static unsigned long intc_irqpin_read32(void __iomem *iomem)
>>  {
>>       return ioread32(iomem);
>> @@ -345,10 +352,23 @@ static struct irq_domain_ops intc_irqpin
>>       .xlate  = irq_domain_xlate_twocell,
>>  };
>>
>> +static const struct intc_irqpin_irlm_config intc_irqpin_irlm_r8a7779 = {
>> +     .irlm_bit = 23, /* ICR0.IRLM0 */
>> +};
>> +
>> +static const struct of_device_id intc_irqpin_dt_ids[] = {
>> +     { .compatible = "renesas,intc-irqpin", },
>> +     { .compatible = "renesas,intc-irqpin-r8a7779",
>> +       .data = &intc_irqpin_irlm_r8a7779 },
>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(of, intc_irqpin_dt_ids);
>> +
>>  static int intc_irqpin_probe(struct platform_device *pdev)
>>  {
>>       struct device *dev = &pdev->dev;
>>       struct renesas_intc_irqpin_config *pdata = dev->platform_data;
>> +     const struct of_device_id *of_id;
>>       struct intc_irqpin_priv *p;
>>       struct intc_irqpin_iomem *i;
>>       struct resource *io[INTC_IRQPIN_REG_NR];
>> @@ -391,10 +411,11 @@ static int intc_irqpin_probe(struct plat
>>       pm_runtime_enable(dev);
>>       pm_runtime_get_sync(dev);
>>
>> -     /* get hold of manadatory IOMEM */
>> +     /* get hold of register banks */
>> +     memset(io, 0, sizeof(io));
>>       for (k = 0; k < INTC_IRQPIN_REG_NR; k++) {
>>               io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
>> -             if (!io[k]) {
>> +             if (!io[k] && k < INTC_IRQPIN_REG_NR_MANDATORY) {
>>                       dev_err(dev, "not enough IOMEM resources\n");
>>                       ret = -EINVAL;
>>                       goto err0;
>> @@ -422,6 +443,10 @@ static int intc_irqpin_probe(struct plat
>>       for (k = 0; k < INTC_IRQPIN_REG_NR; k++) {
>>               i = &p->iomem[k];
>>
>> +             /* handle optional registers */
>> +             if (!io[k])
>> +                     continue;
>> +
>>               switch (resource_size(io[k])) {
>>               case 1:
>>                       i->width = 8;
>> @@ -448,6 +473,19 @@ static int intc_irqpin_probe(struct plat
>>               }
>>       }
>>
>> +     /* configure "individual IRQ mode" where needed */
>> +     of_id = of_match_device(intc_irqpin_dt_ids, dev);
>> +     if (of_id && of_id->data) {
>> +             const struct intc_irqpin_irlm_config *irlm_config = of_id->data;
>> +
>> +             if (io[INTC_IRQPIN_REG_IRLM])
>> +                     intc_irqpin_read_modify_write(p, INTC_IRQPIN_REG_IRLM,
>> +                                                   irlm_config->irlm_bit,
>> +                                                   1, 1);
>> +             else
>> +                     dev_warn(dev, "unable to select IRLM mode\n");
>> +     }
>> +
>>       /* mask all interrupts using priority */
>>       for (k = 0; k < p->number_of_irqs; k++)
>>               intc_irqpin_mask_unmask_prio(p, k, 1);
>> @@ -550,12 +588,6 @@ static int intc_irqpin_remove(struct pla
>>       return 0;
>>  }
>>
>> -static const struct of_device_id intc_irqpin_dt_ids[] = {
>> -     { .compatible = "renesas,intc-irqpin", },
>> -     {},
>> -};
>> -MODULE_DEVICE_TABLE(of, intc_irqpin_dt_ids);
>> -
>>  static struct platform_driver intc_irqpin_device_driver = {
>>       .probe          = intc_irqpin_probe,
>>       .remove         = intc_irqpin_remove,
>
> I am unclear about the relationship between this last hunk and the rest of
> the patch. It seems to be removing the only compat string that is
> recognised by the driver.

The MODULE_DEVICE_TABLE() bits are moved up before the probe()
function so it can be used together with of_match_device() to
determine if the r8a7779 specific setting should be applied or not. So
the last hunk is intentional and needed. The original compat string is
still there.

Thanks,

/ magnus
