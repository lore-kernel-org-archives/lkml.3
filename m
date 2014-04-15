Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaDOPmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:42:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15769 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDOPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:41:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-15-534d5343cedd
Content-transfer-encoding: 8BIT
Message-id: <1397576515.752.5.camel@AMDC1943>
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix stall after CPU
 hotplugging
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, stable@vger.kernel.org
Date: Tue, 15 Apr 2014 17:41:55 +0200
In-reply-to: <alpine.DEB.2.02.1404151711250.22697@ionos.tec.linutronix.de>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com>
 <1397554445.29169.21.camel@AMDC1943> <534D25DC.4050400@linaro.org>
 <1397566023.29169.31.camel@AMDC1943>
 <alpine.DEB.2.02.1404151711250.22697@ionos.tec.linutronix.de>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xK7rOwb7BBreX6llsnLGe1WLeZ1mL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9shddosFGx8xWqyf8ZrFYvOmqcwO3B53ru1h
	83h37hy7x+Yl9R59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVceXUZPaCPVIVp9pfsDcwvhfp
	YuTkkBAwkeh9epYNwhaTuHBvPZgtJLCUUeJfuzOIzSsgKPFj8j2WLkYODmYBeYkjl7JBwswC
	6hKT5i1i7mLkAir/zCjR1bucGaSGV0BXYvaCIpAaYYFgib+nN7KD2GwCxhKbly8BGy8ioCGx
	8dItsF5mgV5miZdXTzCCJFgEVCWWnnwOVsQp4CUx+dt8RogFnxgl5rduhTpUSeLcujWMExgF
	ZiG5bxbCfbOQ3LeAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgcfN3BuPSY1SFGAQ5G
	JR7eCe+8g4VYE8uKK3MPMUpwMCuJ8H7k9g0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGjy61rE
	Kimlo2lrPxm6WvBI1R9+8H3zyk+Vjx6y+Mh+8bx/8dy8hAKFtAWtlydEvjsYEVD6XcSVMTzR
	bZGWx5pLJiV/3I6XTZ/7Vy/o7+SDP0KFJm1WP9J9fPoM0Ufat3x3Wan7dSlEXvS7ZbonouOo
	5BrZK7HzNrVMSfxjJpW6fuq/zad/teUosRRnJBpqMRcVJwIAHhF17mECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On wto, 2014-04-15 at 17:20 +0200, Thomas Gleixner wrote:
> On Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:
> 
> > On wto, 2014-04-15 at 14:28 +0200, Daniel Lezcano wrote:
> > > On 04/15/2014 11:34 AM, Krzysztof Kozlowski wrote:
> > > > On pią, 2014-03-28 at 14:06 +0100, Krzysztof Kozlowski wrote:
> > > >> Fix stall after hotplugging CPU1. Affected are SoCs where Multi Core Timer
> > > >> interrupts are shared (SPI), e.g. Exynos 4210. The stall was a result of
> > > >> starting the CPU1 local timer not in L1 timer but in L0 (which is used
> > > >> by CPU0).
> > > >
> > > > Hi,
> > > >
> > > > Do you have any comments on these 3 patches? They fix the CPU stall on
> > > > Exynos4210 and also on Exynos3250 (Chanwoo Choi sent patches for it
> > > > recently).
> > > 
> > > You describe this issue as impacting different SoC not only the exynos, 
> > > right ?
> > >
> > > Do you know what other SoCs are impacted by this ?
> > 
> > No, affected are only Exynos SoC-s. It was confirmed on Exynos4210
> > (Trats board) and Exynos3250 (new SoC, patches for it were recently
> > posted by Chanwoo).
> > 
> > Other Exynos SoC-s where MCT local timers use shared interrupts (SPI)
> > can also be affected. Candidates are Exynos 5250 and 5420 but I haven't
> > tested them.
> > 
> > > I guess this issue is not reproducible just with the line below, we need 
> > > a timer to expire right at the moment CPU1 is hotplugged, right ?
> > 
> > Right. The timer must fire in short time between enabling local timer
> > for CPU1 and setting the affinity for IRQ.
> 
> Why do you set the affinity in the CPU_ONLINE hotplug callback and not
> right away when the interrupt is requested?

Hi,

I think the problem in such code is in GIC. The gic_set_affinity() uses
cpu_online_mask:
	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
In that time this CPU is not present in that mask so -EINVAL would be
returned.

The stall occurred also on 3.10 where the IRQ affinity is set just after
setup_irq():

if (cpu == 0) {
	mct_tick0_event_irq.dev_id = mevt;
	evt->irq = mct_irqs[MCT_L0_IRQ];
	setup_irq(evt->irq, &mct_tick0_event_irq);
} else {
	mct_tick1_event_irq.dev_id = mevt;
	evt->irq = mct_irqs[MCT_L1_IRQ];
	setup_irq(evt->irq, &mct_tick1_event_irq);
	irq_set_affinity(evt->irq, cpumask_of(1));
}

Best regards,
Krzysztof


> Thanks,
> 
> 	tglx
> 
> 
> Index: linux-2.6/drivers/clocksource/exynos_mct.c
> ===================================================================
> --- linux-2.6.orig/drivers/clocksource/exynos_mct.c
> +++ linux-2.6/drivers/clocksource/exynos_mct.c
> @@ -430,6 +430,7 @@ static int exynos4_local_timer_setup(str
>  				evt->irq);
>  			return -EIO;
>  		}
> +		irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
>  	} else {
>  		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
>  	}
> @@ -461,12 +462,6 @@ static int exynos4_mct_cpu_notify(struct
>  		mevt = this_cpu_ptr(&percpu_mct_tick);
>  		exynos4_local_timer_setup(&mevt->evt);
>  		break;
> -	case CPU_ONLINE:
> -		cpu = (unsigned long)hcpu;
> -		if (mct_int_type == MCT_INT_SPI)
> -			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
> -						cpumask_of(cpu));
> -		break;
>  	case CPU_DYING:
>  		mevt = this_cpu_ptr(&percpu_mct_tick);
>  		exynos4_local_timer_stop(&mevt->evt);
> 
> 
> 

