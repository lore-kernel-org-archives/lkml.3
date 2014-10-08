Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaJHST6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:19:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58207 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaJHST4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:19:56 -0400
Message-ID: <54358047.1000002@gmail.com>
Date: Wed, 08 Oct 2014 20:19:51 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] irqchip: dw-apb-ictl: add PM support
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-4-git-send-email-jszhang@marvell.com> <542AA336.6070206@gmail.com> <alpine.DEB.2.11.1409302351500.4455@nanos> <20141008193123.11f42bb0@xhacker> <543523B1.1060002@gmail.com> <20141008195053.0e8aeaf0@xhacker> <20141008195832.1fb16337@xhacker>
In-Reply-To: <20141008195832.1fb16337@xhacker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 01:58 PM, Jisheng Zhang wrote:
> Hi Sebastian,
>
> On Wed, 8 Oct 2014 04:50:53 -0700
> Jisheng Zhang <jszhang@marvell.com> wrote:
>
>> Hi Sebastian,
>>
>> On Wed, 8 Oct 2014 04:44:49 -0700
>> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>>
>>> On 10/08/2014 01:31 PM, Jisheng Zhang wrote:
>>>> Hi Thomas, Sebastian,
>>>>
>>>> On Tue, 30 Sep 2014 14:52:54 -0700
>>>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>
>>>>> On Tue, 30 Sep 2014, Sebastian Hesselbarth wrote:
>>>>>> On 09/23/2014 08:35 AM, Jisheng Zhang wrote:
>>>>>>> This patch adds in support for S2R for dw-apb-ictl irqchip driver.
>>>>>>>
>>>>>>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
>>>>>>> ---
>>>>>>>     drivers/irqchip/irq-dw-apb-ictl.c | 19 +++++++++++++++++++
>>>>>>>     1 file changed, 19 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c
>>>>>>> b/drivers/irqchip/irq-dw-apb-ictl.c
>>>>>>> index c136b67..53bb732 100644
>>>>>>> --- a/drivers/irqchip/irq-dw-apb-ictl.c
>>>>>>> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
>>>>>>> @@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq,
>>>>>>> struct irq_desc *desc)
>>>>>>>     	chained_irq_exit(chip, desc);
>>>>>>>     }
>>>>>>>
>>>>>>> +#ifdef CONFIG_PM
>>>>>>> +static void dw_apb_ictl_resume(struct irq_data *d)
>>>>>>> +{
>>>>>>> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>>>>>>> +	struct irq_chip_type *ct = irq_data_get_chip_type(d);
>>>>>>> +
>>>>>>> +	irq_gc_lock(gc);
>>>>>>> +	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
>>>>>>> +	writel_relaxed(*ct->mask_cache, gc->reg_base +
>>>>>>> ct->regs.mask);
>>>>>>> +	irq_gc_unlock(gc);
>>>>>>> +}
>>>>>>
>>>>>> I agree with the overall change, but may this also be suited for a
>>>>>> generic irq_chip helper instead of being a driver specific one?
>>>>>>
>>>>>> Maybe Thomas or Jason can comment on this.
>>>>>
>>>>> If we have enough similar resume callbacks, yes.
>>>>>
>>>>>> Also, now that you are using writel_relaxed, I understand that both
>>>>>> writes above can happen in any order? Are there any implication we
>>>>>> have to consider, i.e. do we require any of the registers above to
>>>>>> be written first?
>>>>
>>>> The registers sits at device type memory, the writes should happen in
>>>> the same order as before.
>>>
>>> it is not about the location of the register but, as far as I
>>> understand, when using {readl,writel}_relaxed the compiler is
>>> free to reorder the calls. So, if there is a strict order we
>>
>> The "volatile" in readl/writel relaxed implementations should prevent the
>> compiler to do reorder. Or I misunderstand something?
>
> My understanding is that the relaxed version imply compiler barriers.
> I'm not sure I understand the real/writel relaxed implementations correctly. But
> one obvious example which shows the relaxed version won't have the compiler
> reorder issue is drivers/irqchip/irq-gic.c, all the configurations must be done
> before enable the GIC which is done by "writel_relaxed(1, cpu_base + GIC_CPU_CTRL);"
> However, we didn't see any explicit compiler barriers.

Yup, I just checked the discussion here:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/117626

You are right, write order is ensured.

Sebastian
