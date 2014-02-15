Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaBOClq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:41:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:48384 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaBOClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:41:45 -0500
Message-ID: <52FED3C5.1060703@huawei.com>
Date: Sat, 15 Feb 2014 10:41:09 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Robert Richter <rric@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        "sdu.liu@huawei.com" <sdu.liu@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost> <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost> <52D73148.4090408@huawei.com> <52D7A750.50906@huawei.com> <20140116115245.GB8360@rric.localhost> <20140116193652.GD22105@mudshark.cambridge.arm.com> <52D8A56F.1010507@huawei.com> <52F9A82F.3060806@huawei.com> <20140211155207.GK8693@mudshark.cambridge.arm.com>
In-Reply-To: <20140211155207.GK8693@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

 I test kernel with this patch, the problem has be fixed. When the
 event's sample_period is small, the cpu will not stall except printing
 warning "oprofile: ignoring spurious overflow ignoring spurious overflow".
 This is normal for unregistered event.

 So would you please send a formal one? :) Thanks very much!

On 2014/2/11 23:52, Will Deacon wrote:
> On Tue, Feb 11, 2014 at 04:33:51AM +0000, Weng Meiling wrote:
>> Hi Will,
> 
> Hello,
> 
>>>>> how userland can be notified about throttling. Throttling could be
>>>>> worth for operf too, not only for the oprofile kernel driver.
>>>>>
>>>
>>>>> From a quick look it seems there is also code in x86 that dynamically
>>>>> adjusts the rate which might be worth being implemented for ARM too.
>>>>
>>>> Are you referring to the perf_sample_event_took callback? If so, that
>>>> certainly looks worth persuing. I'll stick it on my list, thanks!
>>>>
>>
>> Is there any progress on this work? Because this is important for me.
>> Sorry for trouble you.
> 
> Oops, I totally forgot about this. Does the below patch work for you?
> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 361a1aaee7c8..a6bc431cde70 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -302,6 +302,8 @@ static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>         struct arm_pmu *armpmu;
>         struct platform_device *plat_device;
>         struct arm_pmu_platdata *plat;
> +       int ret;
> +       u64 start_clock, finish_clock;
>  
>         if (irq_is_percpu(irq))
>                 dev = *(void **)dev;
> @@ -309,10 +311,15 @@ static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>         plat_device = armpmu->plat_device;
>         plat = dev_get_platdata(&plat_device->dev);
>  
> +       start_clock = sched_clock();
>         if (plat && plat->handle_irq)
> -               return plat->handle_irq(irq, dev, armpmu->handle_irq);
> +               ret = plat->handle_irq(irq, dev, armpmu->handle_irq);
>         else
> -               return armpmu->handle_irq(irq, dev);
> +               ret = armpmu->handle_irq(irq, dev);
> +       finish_clock = sched_clock();
> +
> +       perf_sample_event_took(finish_clock - start_clock);
> +       return ret;
>  }
>  
>  static void
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 56003c6edfd3..6fcc293d77a4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -237,6 +237,8 @@ void perf_sample_event_took(u64 sample_len_ns)
>         u64 local_samples_len;
>         u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
>  
> +       pr_info("perf_sample_event_took(%llu ns)\n", sample_len_ns);
> +
>         if (allowed_ns == 0)
>                 return;
>  
>  
> 
> .
> 


