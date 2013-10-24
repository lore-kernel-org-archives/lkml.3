Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3JXKWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:22:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55886 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3JXKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:22:32 -0400
Message-ID: <5268F4C0.3060006@ti.com>
Date: Thu, 24 Oct 2013 15:51:52 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>
Subject: Re: [RFC PATCH 2/6] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar
 IP
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com> <1380549564-31045-3-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1310241112310.4983@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1310241112310.4983@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thursday 24 October 2013 02:50 PM, Thomas Gleixner wrote:
> On Mon, 30 Sep 2013, Sricharan R wrote:
>> +/*
>> + * @int_max: maximum number of supported interrupts
>> + * @irq_map: array of interrupts to crossbar number mapping
>> + * @crossbar_base: crossbar base address
>> + * @register_offsets: offsets for each irq number
>> + */
>> +struct crossbar_device {
>> +	uint int_max;
>> +	uint *irq_map;
> Why do you need another map here?
>
> Isn't the linear_revmap of the irqdomain sufficient?
 linear_revmap gives the linux-irq for hw-irq,
 but here i need the crossbar number corresponding to
 the hwirq allocated. This is needed for setting up the
 crossbar register in map.
>> +static inline const u32 allocate_free_irq(int cb_no)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < cb->int_max; i++) {
>> +		if (cb->irq_map[i] == IRQ_FREE) {
>> +			cb->irq_map[i] = cb_no;
>> +			return i;
>> +		}
>> +	}
>> +
>> +	return -ENODEV;
>> +}
>> +
>> +static int crossbar_domain_xlate(struct irq_domain *d,
>> +				 struct device_node *controller,
>> +				 const u32 *intspec, unsigned int intsize,
>> +				 unsigned long *out_hwirq,
>> +				 unsigned int *out_type)
>> +{
>> +	return allocate_free_irq(intspec[1]) + GIC_IRQ_START;
> Mooo. In the error case you return:
>
>       -ENODEV + GIC_IRQ_START == -19 + 32 == 13
>
> Yikes.
 ya. will be a problem with error case. Will add a check here and
 in the gic as well to check for the return value.
>> +
>> +	/*
>> +	 * Register offsets are not linear because of the
>> +	 * reserved irqs. so find and store the offsets once.
>> +	 */
>> +	for (i = 0; i < max; i++) {
>> +		if (!cb->irq_map[i])
>> +			continue;
>> +
>> +		cb->register_offsets[i] = reserved;
>> +		reserved += size;
> I'm amazed by such a brilliant hardware design.
>
> Thanks,
>
> 	tglx

Regards,
 Sricharan
