Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaANU55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:57:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45585 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:57:55 -0500
Message-ID: <52D5A4D1.9030403@codeaurora.org>
Date: Tue, 14 Jan 2014 12:57:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] ARM: perf_event: Support percpu irqs for the CPU
 PMU
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org> <1389221984-10973-3-git-send-email-sboyd@codeaurora.org> <20140109104943.GB17838@mudshark.cambridge.arm.com> <52CEF5C9.1010701@codeaurora.org> <20140110105813.GB10455@mudshark.cambridge.arm.com> <20140110193657.GG14405@codeaurora.org> <20140113115213.GE1189@mudshark.cambridge.arm.com>
In-Reply-To: <20140113115213.GE1189@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/14 03:52, Will Deacon wrote:
> On Fri, Jan 10, 2014 at 07:36:57PM +0000, Stephen Boyd wrote:
>>
>> Passing the hw_events as the pcpu token here is kind of hacky.
>> The reason is because the token is dereferenced into cpu_pmu in
>> armv7pmu_handle_irq() like so:
>>
>> 	struct arm_pmu *cpu_pmu = (struct arm_pmu *)dev;
>>
>> It would be great if we could pass cpu_pmu directly to the
>> request call like so:
>>
>> 	request_percpu_irq(irq, cpu_pmu->handle_irq, "arm-pmu", &cpu_pmu);
>>
>> but no. request_percpu_irq() wants a percpu pointer so this won't
>> work. If cpu_pmu was declared as DEFINE_PER_CPU, this would work
>> out just fine.
> That feels really broken though, since we rely on the cpu_pmu being a
> container for the struct pmu that was registered with perf core.
>
>> Should the cpu_pmu become a per-cpu variable? That sounds rather
>> invasive.
> I also don't think that's the right solution, based on the above. It's
> actually pretty hard to work out what's the right thing to do here...

Yes it doesn't seem like the right solution.

>
> We *could* have a per-cpu pointer to the cpu_pmu_pointer, but then we'd
> need to update the IRQ handlers, including things like the CCI PMU which
> really doesn't care about per-cpu stuff. So after all this, the shim we have
> around the IRQ handler for the U8500 SPI workarounds might be the right
> thing after all -- it allows us to consolidate the conversion of a pcpu
> pointer into the relevant instance (actually any instance, since they'd all
> point at the same thing) for the current CPU.
>
> What do you think to having that shim throw away the second level pcpu
> pointer in the case of a PPI? (probably means we need to revisit that
> renaming again).

Ok I think I understand what you're getting at. We pass a per-cpu
pointer to the cpu_pmu pointer as the dev_id argument to the PPI irq
handler, and then we check to see if the irq is per-cpu inside the
armpmu_dispatch_irq() function and throw away the second level of
pointer, i.e.

static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
{
        struct arm_pmu *armpmu;
        struct platform_device *plat_device;
        struct arm_pmu_platdata *plat;

        if (irq_is_percpu(irq))
                dev = *(struct arm_pmu_cpu **)dev;
        armpmu = dev;
        plat_device = armpmu->plat_device;
        plat = dev_get_platdata(&plat_device->dev);

        if (plat && plat->handle_irq)
                return plat->handle_irq(irq, dev, armpmu->handle_irq);
        else
                return armpmu->handle_irq(irq, dev);
}


We still need to make a per-cpu variable to hold the pointer, and assign
it during cpu_pmu_init like this patch does. Hopefully that is ok.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

