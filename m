Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBXOZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:25:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:57723 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBXOZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:25:05 -0500
Date: Mon, 24 Feb 2014 15:24:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        metag <linux-metag@vger.kernel.org>
Subject: Re: [patch 06/26] metag: Use irq_set_affinity instead of homebrewn
 code
In-Reply-To: <530B47FD.80608@imgtec.com>
Message-ID: <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212736.887575774@linutronix.de> <530B47FD.80608@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, James Hogan wrote:

> Hi Thomas,
> 
> On 23/02/14 21:40, Thomas Gleixner wrote:
> > There is no point in having an incomplete copy of irq_set_affinity()
> > for the hotplug irq migration code.
> 
> That sounds reasonable, but when I gave it a try I started getting
> warnings on the log after offlining one cpu then the other:
> 
> META213-Thread0 DSP [LogF] IRQ13 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ14 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ15 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ18 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ29 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ30 no longer affine to CPU1
> META213-Thread0 DSP [LogF] IRQ31 no longer affine to CPU1
> 
> It appears that the irq affinities weren't getting modified previously,
> whereas now irq_do_set_affinity() does do cpumask_copy(data->affinity,
> mask). Once all CPUs have been offlined at least once you get those
> spurious messages even though the IRQ affinities haven't been explicitly
> limited by anything.
> 
> I wonder if the stored affinity should really be altered in this case?

Delta patch below.

You need that irq-metag part in any case as the user space interface
does not filter out stuff. Assume you offlined core 1 and user changes
affinity from 0xf to 0xe. So your selector will pick core 1 which is
offline....

Btw, our handling of this is a bit awkward. Right now we let the user
do

      echo 0xf > /proc/irq/$N/smp_affinity

and reading that back will give you 0xf though the kernel just selects
a subset or even a single target cpu and one has to analyze
/proc/interrupts to find out which one.

We should add some mechanism to tell the user what's really going on.
But that's a separate issue.

Thanks,

	tglx

Index: tip/arch/metag/kernel/irq.c
===================================================================
--- tip.orig/arch/metag/kernel/irq.c
+++ tip/arch/metag/kernel/irq.c
@@ -287,10 +287,8 @@ void migrate_irqs(void)
 					    i, cpu);
 
 			cpumask_setall(data->affinity);
-			newcpu = cpumask_any_and(data->affinity,
-						 cpu_online_mask);
 		}
-		irq_set_affinity(i, cpumask_of(newcpu));
+		irq_set_affinity(i, data->affinity);
 	}
 }
 #endif /* CONFIG_HOTPLUG_CPU */
Index: tip/drivers/irqchip/irq-metag.c
===================================================================
--- tip.orig/drivers/irqchip/irq-metag.c
+++ tip/drivers/irqchip/irq-metag.c
@@ -201,7 +201,7 @@ static int metag_internal_irq_set_affini
 	 * one cpu (the interrupt code doesn't support it), so we just
 	 * pick the first cpu we find in 'cpumask'.
 	 */
-	cpu = cpumask_any(cpumask);
+	cpu = cpumask_any_and(cpumask, cpu_online_mask);
 	thread = cpu_2_hwthread_id[cpu];
 
 	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),


    	  
