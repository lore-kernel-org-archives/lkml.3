Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDOPUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:20:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:57535 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaDOPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:19:58 -0400
Date: Tue, 15 Apr 2014 17:20:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix stall after CPU
 hotplugging
In-Reply-To: <1397566023.29169.31.camel@AMDC1943>
Message-ID: <alpine.DEB.2.02.1404151711250.22697@ionos.tec.linutronix.de>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com> <1397554445.29169.21.camel@AMDC1943> <534D25DC.4050400@linaro.org> <1397566023.29169.31.camel@AMDC1943>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-890712702-1397575206=:22697"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-890712702-1397575206=:22697
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:

> On wto, 2014-04-15 at 14:28 +0200, Daniel Lezcano wrote:
> > On 04/15/2014 11:34 AM, Krzysztof Kozlowski wrote:
> > > On pią, 2014-03-28 at 14:06 +0100, Krzysztof Kozlowski wrote:
> > >> Fix stall after hotplugging CPU1. Affected are SoCs where Multi Core Timer
> > >> interrupts are shared (SPI), e.g. Exynos 4210. The stall was a result of
> > >> starting the CPU1 local timer not in L1 timer but in L0 (which is used
> > >> by CPU0).
> > >
> > > Hi,
> > >
> > > Do you have any comments on these 3 patches? They fix the CPU stall on
> > > Exynos4210 and also on Exynos3250 (Chanwoo Choi sent patches for it
> > > recently).
> > 
> > You describe this issue as impacting different SoC not only the exynos, 
> > right ?
> >
> > Do you know what other SoCs are impacted by this ?
> 
> No, affected are only Exynos SoC-s. It was confirmed on Exynos4210
> (Trats board) and Exynos3250 (new SoC, patches for it were recently
> posted by Chanwoo).
> 
> Other Exynos SoC-s where MCT local timers use shared interrupts (SPI)
> can also be affected. Candidates are Exynos 5250 and 5420 but I haven't
> tested them.
> 
> > I guess this issue is not reproducible just with the line below, we need 
> > a timer to expire right at the moment CPU1 is hotplugged, right ?
> 
> Right. The timer must fire in short time between enabling local timer
> for CPU1 and setting the affinity for IRQ.

Why do you set the affinity in the CPU_ONLINE hotplug callback and not
right away when the interrupt is requested?

Thanks,

	tglx


Index: linux-2.6/drivers/clocksource/exynos_mct.c
===================================================================
--- linux-2.6.orig/drivers/clocksource/exynos_mct.c
+++ linux-2.6/drivers/clocksource/exynos_mct.c
@@ -430,6 +430,7 @@ static int exynos4_local_timer_setup(str
 				evt->irq);
 			return -EIO;
 		}
+		irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
@@ -461,12 +462,6 @@ static int exynos4_mct_cpu_notify(struct
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_setup(&mevt->evt);
 		break;
-	case CPU_ONLINE:
-		cpu = (unsigned long)hcpu;
-		if (mct_int_type == MCT_INT_SPI)
-			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
-						cpumask_of(cpu));
-		break;
 	case CPU_DYING:
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_stop(&mevt->evt);




--8323329-890712702-1397575206=:22697--
