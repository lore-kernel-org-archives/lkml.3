Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaHVCGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:06:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35563 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaHVCGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:06:46 -0400
Message-ID: <53F6A5B4.90602@codeaurora.org>
Date: Thu, 21 Aug 2014 19:06:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v5] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
References: <1408562561-10424-1-git-send-email-sboyd@codeaurora.org> <20140821094759.GK30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140821094759.GK30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/14 02:47, Russell King - ARM Linux wrote:
> What would make more sense is if this were a read-write lock, then
> gic_raise_softirq() could run concurrently on several CPUs without
> interfering with each other, yet still be safe with gic_migrate_target().
>
> I'd then argue that we wouldn't need the ifdeffery, we might as well
> keep the locking in place - it's overhead is likely small (when lockdep
> is disabled) when compared to everything else which goes on in this
> path.

Ok.

>> @@ -690,6 +700,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>>  	ror_val = (cur_cpu_id - new_cpu_id) & 31;
>>  
>>  	raw_spin_lock(&irq_controller_lock);
>> +	raw_spin_lock(&gic_sgi_lock);
>>  
>>  	/* Update the target interface for this logical CPU */
>>  	gic_cpu_map[cpu] = 1 << new_cpu_id;
>> @@ -709,6 +720,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>>  		}
>>  	}
>>  
>> +	raw_spin_unlock(&gic_sgi_lock);
>>  	raw_spin_unlock(&irq_controller_lock);
> I would actually suggest we go a bit further.  Use gic_sgi_lock to only
> lock gic_cpu_map[] itself, and not have it beneath any other lock.
> That's an advantage because right now, lockdep learns from the above that
> there's a dependency between irq_controller_lock and gic_sgi_lock.
> Reasonably keeping lock dependencies to a minimum is always a good idea.
>
> The places where gic_cpu_map[] is used are:
>
> static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>                             bool force)
> {
> ...
>         raw_spin_lock(&irq_controller_lock);
>         mask = 0xff << shift;
>         bit = gic_cpu_map[cpu] << shift;
>         val = readl_relaxed(reg) & ~mask;
>         writel_relaxed(val | bit, reg);
>         raw_spin_unlock(&irq_controller_lock);
>
> So, we can move:
>
>         mask = 0xff << shift;
>         bit = gic_cpu_map[cpu] << shift;
>
> out from under irq_controller_lock and put it under gic_sgi_lock.  The
> "mask" bit doesn't need to be under any lock at all.
>
> There's gic_cpu_init():
>
>         cpu_mask = gic_get_cpumask(gic);
>         gic_cpu_map[cpu] = cpu_mask;
>
>         /*
>          * Clear our mask from the other map entries in case they're
>          * still undefined.
>          */
>         for (i = 0; i < NR_GIC_CPU_IF; i++)
>                 if (i != cpu)
>                         gic_cpu_map[i] &= ~cpu_mask;
>
> which better had be stable after boot - if not, this needs locking.
> Remember that the above will be called on hotplug too.
>

Perhaps you'd like to send this patch? It isn't clear to me from your
description how this would work. What happens if we update the
gic_cpu_map between the time we read the map and acquire the
irq_controller_lock in gic_set_affinity()? I think we would program the
affinity for the wrong CPU?

Either way, here's the patch I think you described.

----8<-----

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e606fe8..d159590461c7 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/rwlock.h>
 
 #include <asm/cputype.h>
 #include <asm/irq.h>
@@ -79,6 +80,7 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
  */
 #define NR_GIC_CPU_IF 8
 static u8 gic_cpu_map[NR_GIC_CPU_IF] __read_mostly;
+static DEFINE_RWLOCK(gic_cpu_map_lock);
 
 /*
  * Supported arch specific GIC irq extension.
@@ -233,9 +235,13 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
-	raw_spin_lock(&irq_controller_lock);
 	mask = 0xff << shift;
+
+	read_lock(&gic_cpu_map_lock);
 	bit = gic_cpu_map[cpu] << shift;
+	read_unlock(&gic_cpu_map_lock);
+
+	raw_spin_lock(&irq_controller_lock);
 	val = readl_relaxed(reg) & ~mask;
 	writel_relaxed(val | bit, reg);
 	raw_spin_unlock(&irq_controller_lock);
@@ -605,7 +611,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	int cpu;
 	unsigned long flags, map = 0;
 
-	raw_spin_lock_irqsave(&irq_controller_lock, flags);
+	read_lock_irqsave(&gic_cpu_map_lock, flags);
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -620,7 +626,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
+	read_unlock_irqrestore(&gic_cpu_map_lock, flags);
 }
 #endif
 
@@ -689,11 +695,12 @@ void gic_migrate_target(unsigned int new_cpu_id)
 	cur_target_mask = 0x01010101 << cur_cpu_id;
 	ror_val = (cur_cpu_id - new_cpu_id) & 31;
 
-	raw_spin_lock(&irq_controller_lock);
-
+	write_lock(&gic_cpu_map_lock);
 	/* Update the target interface for this logical CPU */
 	gic_cpu_map[cpu] = 1 << new_cpu_id;
+	write_unlock(&gic_cpu_map_lock);
 
+	raw_spin_lock(&irq_controller_lock);
 	/*
 	 * Find all the peripheral interrupts targetting the current
 	 * CPU interface and migrate them to the new CPU interface.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

