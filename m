Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbaGXPe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:34:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55544 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114AbaGXPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:34:57 -0400
Message-ID: <53D1323E.1010703@ti.com>
Date: Thu, 24 Jul 2014 19:20:14 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, santosh.shilimkar@ti.com,
        Jason Cooper <jason@lakedaemon.net>
CC: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        ivan.khoronzhuk@ti.com, m-karicheri2@ti.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irqchip: add keystone irq controller ip driver
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com> <53CFD581.5040908@gmail.com> <53CFF866.6060703@ti.com> <53D05A4F.5080905@gmail.com>
In-Reply-To: <53D05A4F.5080905@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 03:58 AM, Varka Bhadram wrote:
> 
> On Wednesday 23 July 2014 11:31 PM, Grygorii Strashko wrote:
>> Hi,
>>
>> On 07/23/2014 06:32 PM, Varka Bhadram wrote:
>>> On Wednesday 23 July 2014 08:10 PM, Grygorii Strashko wrote:
>>>> On Keystone SOCs, DSP cores can send interrupts to ARM
>>>> host using the IRQ controller IP. It provides 28 IRQ
>>>> signals to ARM. The IRQ handler running on HOST OS can
>>>> identify DSP signal source by analyzing SRCCx bits in
>>>> IPCARx registers. This is one of the component used by
>>>> the IPC mechanism used on Keystone SOCs.
>>> (...)

[...]

>>>> +static inline void
>>>> +keystone_irq_writel(struct keystone_irq_device *kirq, u32 value)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    ret = regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value);
>>>> +    if (ret < 0)
>>>> +        dev_dbg(kirq->dev, "irq write failed ret(%d)\n", ret);
>>> It can be like
>>>
>>> if (!regmap_write(kirq->devctrl_regs, kirq->devctrl_offset, value))
>>>       dev_dbg(kirq->dev, "irq write failed \n");
>>>
>>>> +}
>>>> +
>>>> +
>> Pls, Pay attention that I'd like to see ret code here in case of failure.
> 
> What we have to do with ret code... ?

Print it :)

> In case of failure only this debug message will be printed.

Yep. And that exactly what I need.

> 
>>> (...)
>>>
>>>> +
>>>> +static struct irq_domain_ops keystone_irq_ops = {
>>>> +    .map    = keystone_irq_map,
>>>> +    .xlate    = irq_domain_xlate_onecell,
>>>> +};
>>>> +
>>>> +static int keystone_irq_probe(struct platform_device *pdev)
>>>> +{
>>>> +    struct device *dev = &pdev->dev;
>>>> +    struct device_node *np = dev->of_node;
>>>> +    struct keystone_irq_device *kirq;
>>>> +    int ret;
>>>> +
>>>> +    if (np == NULL)
>>>> +        return -EINVAL;
>>> return -ENODEV??????
>> If probe is executed - the dev is present, but it was created in a 
>> wrong/unsupported way
>> or dev structure contains wrong data.
> 
> Here we are trying to get the device tree node , but that is not present 
> we may return the
> error code saying that NO DEVICE is present....

1) Even in case of DT boot device can be creating using platform_device_register()
   (by mistake, multiplatform build)

2) I've checked current Kernel code and found that
- if drivers are DT compatible only then they return
  -EINVAL -or- -ENOENT
See, for example:
 - irq-imgpdc.c
 - gpio-tb10x.c

> 
>>> (...)

Regards,
-grygorii
 

