Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaDOQUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:20:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:58051 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaDOQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:20:33 -0400
Date: Tue, 15 Apr 2014 18:20:39 +0200 (CEST)
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
In-Reply-To: <1397576515.752.5.camel@AMDC1943>
Message-ID: <alpine.DEB.2.02.1404151753090.22697@ionos.tec.linutronix.de>
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com> <1397554445.29169.21.camel@AMDC1943> <534D25DC.4050400@linaro.org> <1397566023.29169.31.camel@AMDC1943> <alpine.DEB.2.02.1404151711250.22697@ionos.tec.linutronix.de>
 <1397576515.752.5.camel@AMDC1943>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-942035999-1397578841=:22697"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-942035999-1397578841=:22697
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

B1;3202;0cOn Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:
> On wto, 2014-04-15 at 17:20 +0200, Thomas Gleixner wrote:
> > On Tue, 15 Apr 2014, Krzysztof Kozlowski wrote:
> > 
> > > On wto, 2014-04-15 at 14:28 +0200, Daniel Lezcano wrote:
> > > > On 04/15/2014 11:34 AM, Krzysztof Kozlowski wrote:
> > > > > On pią, 2014-03-28 at 14:06 +0100, Krzysztof Kozlowski wrote:
> > > > >> Fix stall after hotplugging CPU1. Affected are SoCs where Multi Core Timer
> > > > >> interrupts are shared (SPI), e.g. Exynos 4210. The stall was a result of
> > > > >> starting the CPU1 local timer not in L1 timer but in L0 (which is used
> > > > >> by CPU0).
> > > > >
> > > > > Hi,
> > > > >
> > > > > Do you have any comments on these 3 patches? They fix the CPU stall on
> > > > > Exynos4210 and also on Exynos3250 (Chanwoo Choi sent patches for it
> > > > > recently).
> > > > 
> > > > You describe this issue as impacting different SoC not only the exynos, 
> > > > right ?
> > > >
> > > > Do you know what other SoCs are impacted by this ?
> > > 
> > > No, affected are only Exynos SoC-s. It was confirmed on Exynos4210
> > > (Trats board) and Exynos3250 (new SoC, patches for it were recently
> > > posted by Chanwoo).
> > > 
> > > Other Exynos SoC-s where MCT local timers use shared interrupts (SPI)
> > > can also be affected. Candidates are Exynos 5250 and 5420 but I haven't
> > > tested them.
> > > 
> > > > I guess this issue is not reproducible just with the line below, we need 
> > > > a timer to expire right at the moment CPU1 is hotplugged, right ?
> > > 
> > > Right. The timer must fire in short time between enabling local timer
> > > for CPU1 and setting the affinity for IRQ.
> > 
> > Why do you set the affinity in the CPU_ONLINE hotplug callback and not
> > right away when the interrupt is requested?
> 
> Hi,
> 
> I think the problem in such code is in GIC. The gic_set_affinity() uses
> cpu_online_mask:
> 	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
> In that time this CPU is not present in that mask so -EINVAL would be
> returned.

Hmm, indeed. Stupid me.

Here is a complete solution to the problem. We really want the drivers
to be fast and clean and not work around such issues.

I'm quite happy that I kept the 'force' argument of set_affinity
callbacks. I knew that I'd need it at some point.

So with the flag set we can disable the online mask check and force
the interrupt to the proper cpu.
 
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
+		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
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
Index: linux-2.6/drivers/irqchip/irq-gic.c
===================================================================
--- linux-2.6.orig/drivers/irqchip/irq-gic.c
+++ linux-2.6/drivers/irqchip/irq-gic.c
@@ -246,10 +246,14 @@ static int gic_set_affinity(struct irq_d
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int shift = (gic_irq(d) % 4) * 8;
-	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
 	u32 val, mask, bit;
 
+	if (!force)
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	else
+		cpu = cpumask_first(mask_val);
+
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -204,6 +204,7 @@ static inline int check_wakeup_irqs(void
 extern cpumask_var_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -180,7 +180,7 @@ int irq_do_set_affinity(struct irq_data
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
-	ret = chip->irq_set_affinity(data, mask, false);
+	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 		cpumask_copy(data->affinity, mask);
@@ -192,7 +192,8 @@ int irq_do_set_affinity(struct irq_data
 	return ret;
 }
 
-int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
+static int irq_do_set_affinity_locked(struct irq_data *data,
+				      const struct cpumask *mask, bool force)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
@@ -202,7 +203,7 @@ int __irq_set_affinity_locked(struct irq
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask, force);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -217,13 +218,13 @@ int __irq_set_affinity_locked(struct irq
 	return ret;
 }
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@mask:		cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity_locked(struct irq_data *data,const struct cpumask *mask)
+{
+	return irq_do_set_affinity_locked(data, mask, false);
+}
+
+static int __irq_set_affinity(unsigned int irq, const struct cpumask *mask,
+			      bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -233,11 +234,33 @@ int irq_set_affinity(unsigned int irq, c
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
+	ret = irq_do_set_affinity_locked(irq_desc_get_irq_data(desc), mask,
+					 force);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
 
+/**
+ *	irq_force_affinity - Force the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@mask:		cpumask
+ */
+int irq_force_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	return __irq_set_affinity(irq, mask, true);
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@mask:		cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+{
+	return __irq_set_affinity(irq, mask, false);
+}
+
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
--8323329-942035999-1397578841=:22697--
