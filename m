Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3LWJlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:41:14 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44621 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3LWJlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:41:11 -0500
MIME-Version: 1.0
In-Reply-To: <1385990638-19548-1-git-send-email-prarit@redhat.com>
References: <1385990638-19548-1-git-send-email-prarit@redhat.com>
Date: Mon, 23 Dec 2013 17:41:09 +0800
Message-ID: <CANVTcTZ-ZkTvR0+=eFyNQ7E8R2UYo1qdA-RQ+9nzK2w=qCPkPQ@mail.gmail.com>
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug
 retriggered irqs
From: rui wang <ruiv.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/13, Prarit Bhargava <prarit@redhat.com> wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64831
>
> When downing a cpu it is possible that there are unhandled irqs left in
> the APIC IRR register.  fixup_irqs() goes through the IRR and retriggers
> the IRQs left in the APIC IRR.  After this, the vector for the irq is set
> to -1.  There is a possibility here, however, that the CPU does handle an
> irq in the IRR and then calls the vector.
>

The patch does not seem to root-cause the problem. It seems to hide
the real problem.

It is not possible that a device-triggered irq can arrive to this cpu
again after fixup_irqs() fills its vector_irq[vector] to -1, because
we've done the following:

1. We disabled interrupt on this cpu in stop_machine().
2. We called irq_set_affinity() to exclude this cpu as a target for the irq.
3. We checked APIC_IRR and re-triggered any pending irqs to other cpus.

So the root cause of this spruious irq isn't found yet. I notice that
there's a mdelay(1) in fixup_irqs() which claims to be able to avoid
spurious irqs, but with no reasoning there.

The only way this irq can come again is through IPI. One possibility
is that cpu_online_mask() isn't protected by a spin lock, so if there
are other cpus being offlined simultaneously, then they may read wrong
cpu_online_mask due to contention, thus re-triggering pending irqs to
this offlined cpu. So the mdelay(1) can wait for that IPI to come and
we can catch it by checking APIC_IRR...But mdelay(1) may not be long
enough so you still see the spurious event and ended up with this
patch. I didn't do any test, just trying some thought experiments.

So why isn't cpu_online_mask() protected by a spin lock?

Thanks
Rui

> When this happens, do_IRQ() spits out a warning like
>
> kernel: [  612.014573] do_IRQ: 56.134 No irq handler for vector (irq -1)
>
> I added a debug printk to output which CPU & vector was retriggered and
> discovered that that we are getting bogus events.  This patchset resolves
> this by adding definitions for VECTOR_UNDEFINED(-1) and
> VECTOR_RETRIGGERED(-2) and modifying the code to use them.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: janet.morgan@intel.com
> Cc: tony.luck@intel.com
> ---
>  arch/x86/include/asm/hw_irq.h  |    2 ++
>  arch/x86/kernel/apic/io_apic.c |   13 +++++++------
>  arch/x86/kernel/irq.c          |   17 +++++++++++------
>  arch/x86/kernel/irqinit.c      |    4 ++--
>  4 files changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 92b3bae..22c425e 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -188,6 +188,8 @@ extern __visible void smp_invalidate_interrupt(struct
> pt_regs *);
>
>  extern void (*__initconst
> interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
>
> +#define VECTOR_UNDEFINED	-1
> +#define VECTOR_RETRIGGERED	-2
>  typedef int vector_irq_t[NR_VECTORS];
>  DECLARE_PER_CPU(vector_irq_t, vector_irq);
>  extern void setup_vector_irq(int cpu);
> diff --git a/arch/x86/kernel/apic/io_apic.c
> b/arch/x86/kernel/apic/io_apic.c
> index e63a5bd..6e1541c 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1143,7 +1143,8 @@ next:
>  			goto next;
>
>  		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
> -			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
> +			if (per_cpu(vector_irq, new_cpu)[vector] >
> +							      VECTOR_UNDEFINED)
>  				goto next;
>  		/* Found one! */
>  		current_vector = vector;
> @@ -1183,7 +1184,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg
> *cfg)
>
>  	vector = cfg->vector;
>  	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
> -		per_cpu(vector_irq, cpu)[vector] = -1;
> +		per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
>
>  	cfg->vector = 0;
>  	cpumask_clear(cfg->domain);
> @@ -1195,7 +1196,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg
> *cfg)
>  								vector++) {
>  			if (per_cpu(vector_irq, cpu)[vector] != irq)
>  				continue;
> -			per_cpu(vector_irq, cpu)[vector] = -1;
> +			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
>  			break;
>  		}
>  	}
> @@ -1228,12 +1229,12 @@ void __setup_vector_irq(int cpu)
>  	/* Mark the free vectors */
>  	for (vector = 0; vector < NR_VECTORS; ++vector) {
>  		irq = per_cpu(vector_irq, cpu)[vector];
> -		if (irq < 0)
> +		if (irq <= VECTOR_UNDEFINED)
>  			continue;
>
>  		cfg = irq_cfg(irq);
>  		if (!cpumask_test_cpu(cpu, cfg->domain))
> -			per_cpu(vector_irq, cpu)[vector] = -1;
> +			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
>  	}
>  	raw_spin_unlock(&vector_lock);
>  }
> @@ -2208,7 +2209,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
>  		struct irq_cfg *cfg;
>  		irq = __this_cpu_read(vector_irq[vector]);
>
> -		if (irq == -1)
> +		if (irq <= VECTOR_UNDEFINED)
>  			continue;
>
>  		desc = irq_to_desc(irq);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 22d0687..030f0e2 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -193,9 +193,10 @@ __visible unsigned int __irq_entry do_IRQ(struct
> pt_regs *regs)
>  	if (!handle_irq(irq, regs)) {
>  		ack_APIC_irq();
>
> -		if (printk_ratelimit())
> -			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
> -				__func__, smp_processor_id(), vector, irq);
> +		if (irq != VECTOR_RETRIGGERED)
> +			pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %d)\n",
> +					     __func__, smp_processor_id(),
> +					     vector, irq);
>  	}
>
>  	irq_exit();
> @@ -344,7 +345,7 @@ void fixup_irqs(void)
>  	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>  		unsigned int irr;
>
> -		if (__this_cpu_read(vector_irq[vector]) < 0)
> +		if (__this_cpu_read(vector_irq[vector]) <= VECTOR_UNDEFINED)
>  			continue;
>
>  		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
> @@ -355,11 +356,15 @@ void fixup_irqs(void)
>  			data = irq_desc_get_irq_data(desc);
>  			chip = irq_data_get_irq_chip(data);
>  			raw_spin_lock(&desc->lock);
> -			if (chip->irq_retrigger)
> +			if (chip->irq_retrigger) {
>  				chip->irq_retrigger(data);
> +				__this_cpu_write(vector_irq[vector],
> +						 VECTOR_RETRIGGERED);
> +			}
>  			raw_spin_unlock(&desc->lock);
>  		}
> -		__this_cpu_write(vector_irq[vector], -1);
> +		if (__this_cpu_read(vector_irq[vector]) != VECTOR_RETRIGGERED)
> +			__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
>  	}
>  }
>  #endif
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index a2a1fbc..7f50156 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -52,7 +52,7 @@ static struct irqaction irq2 = {
>  };
>
>  DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
> -	[0 ... NR_VECTORS - 1] = -1,
> +	[0 ... NR_VECTORS - 1] = VECTOR_UNDEFINED,
>  };
>
>  int vector_used_by_percpu_irq(unsigned int vector)
> @@ -60,7 +60,7 @@ int vector_used_by_percpu_irq(unsigned int vector)
>  	int cpu;
>
>  	for_each_online_cpu(cpu) {
> -		if (per_cpu(vector_irq, cpu)[vector] != -1)
> +		if (per_cpu(vector_irq, cpu)[vector] > VECTOR_UNDEFINED)
>  			return 1;
>  	}
>
> --
> 1.7.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
