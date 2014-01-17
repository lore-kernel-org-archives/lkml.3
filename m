Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaAQRyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:54:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42392 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaAQRyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:54:38 -0500
Message-ID: <52D96E5C.4040506@codeaurora.org>
Date: Fri, 17 Jan 2014 09:54:36 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/7] ARM: perf_event: Support percpu irqs for the CPU
 PMU
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org> <1389808535-23852-2-git-send-email-sboyd@codeaurora.org> <20140115205427.GB26193@codeaurora.org> <20140117150411.GI16003@mudshark.cambridge.arm.com>
In-Reply-To: <20140117150411.GI16003@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/14 07:04, Will Deacon wrote:
> Hi Stephen,
>
> On Wed, Jan 15, 2014 at 08:54:27PM +0000, Stephen Boyd wrote:
>> On 01/15, Stephen Boyd wrote:
>>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>>> index 789d846a9184..e76750980b38 100644
>>> --- a/arch/arm/kernel/perf_event.c
>>> +++ b/arch/arm/kernel/perf_event.c
>>> @@ -295,9 +297,15 @@ validate_group(struct perf_event *event)
>>>  
>>>  static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>>>  {
>>> -	struct arm_pmu *armpmu = (struct arm_pmu *) dev;
>>> -	struct platform_device *plat_device = armpmu->plat_device;
>>> -	struct arm_pmu_platdata *plat = dev_get_platdata(&plat_device->dev);
>>> +	struct arm_pmu *armpmu;
>>> +	struct platform_device *plat_device;
>>> +	struct arm_pmu_platdata *plat;
>>> +
>>> +	if (irq_is_percpu(irq))
>>> +		dev = *(struct arm_pmu_cpu **)dev;
>> Oh. I just realized that struct arm_pmu_cpu doesn't even exist. This
>> still compiles though because we're dealing with a void pointer.
>>
>> Perhaps its better to just do
>>
>> 	dev = *(void **)dev;
>>
>> here. Can you fix that up when applying? Otherwise I'll do it on
>> the next send if there are more comments.
> Shouldn't that actually be some per_cpu accessor like this_cpu_ptr?
>

Nope. The genirq layer unwraps the per_cpu pointer and passes it to the
handler.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

