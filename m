Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaAFDlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:41:10 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48548 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaAFDlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <1388938252-16627-1-git-send-email-prarit@redhat.com>
References: <1388938252-16627-1-git-send-email-prarit@redhat.com>
Date: Mon, 6 Jan 2014 11:41:04 +0800
Message-ID: <CANVTcTY2AiTS_KUtt1h+WcNieVMM7JVkx0RXRWS5nu0uXJP8AQ@mail.gmail.com>
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug
 retriggered irqs [v3]
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

On 1/6/14, Prarit Bhargava <prarit@redhat.com> wrote:
> I tested this by doing a continuous loop of booting a system, downing all
> cpus, and then rebooting.  Before every reboot I grepped the dmesg log for
> the do_IRQ warning to see if there were any additional do_IRQ warnings and
> I do not see any after applying this patch.  I also tested on several
> small and medium sized boxes to confirm that cpu hotplug still works there
> too and do not see any issues.  Please note that this patchset was tested
> in conjunction with
>
> http://marc.info/?l=linux-edac&m=138783131400902&w=2
>
> and
>
> http://marc.info/?l=linux-kernel&m=138871006718478&w=2
>
> in order to get cpu hotplug working.
>
> I'm redoing some additional stability testing (with the additional 2 line
> change in this version of the patch) after down'ing all cpus and
> bringing them back into service, however, I don't expect to see any new
> issues.
>
> P.
>
> ----8<----
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64831
>
> When downing a cpu it is possible that there are unhandled irqs left in
> the APIC IRR register.  The following code path shows how the problem
> can occur:
>
> 1. CPU 5 is to go down.
> 2.  cpu_disable() on CPU 5 executes with interrupt flag cleared by
> local_irq_save() via stop_machine().
> 3. IRQ 12 asserts on CPU 5, setting IRR but not ISR because interrupt
> flag is cleared (CPU unabled to handle the irq)
> 4. IRQs are migrated off of CPU 5, and the vectors' irqs are set to -1.
> 5. stop_machine() finishes cpu_disable()
> 6. cpu_die() for CPU 5 executes in normal context.
> 7. CPU 5 attempts to handle IRQ 12 because the IRR is set for IRQ 12.  The
> code attempts to find the vector's IRQ and cannot because it has been set to
> -1.
> 8. do_IRQ warning displays warning about CPU 5 IRQ 12.
>
> When this happens, do_IRQ() spits out a warning like
>
> kernel: [  614.414443] do_IRQ: 5.124 No irq handler for vector (irq -1)
>
> I added a debug printk to output which CPU & vector was retriggered and
> discovered that that we are getting bogus events.  I see a 100% correlation
> between this debug printk in fixup_irqs() and the do_IRQ() warning.
>
> This patchset resolves this by adding definitions for VECTOR_UNDEFINED(-1)
> and
> VECTOR_RETRIGGERED(-2) and modifying the code to use them.
>
> [v2]: sent with more detailed commit message
> [v3]: set vector_irq[irq] back to VECTOR_UNDEFINED after call in do_IRQ()
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
> Cc: ruiv.wang@gmail.com
> ---
>  arch/x86/include/asm/hw_irq.h  |    2 ++
>  arch/x86/kernel/apic/io_apic.c |   13 +++++++------
>  arch/x86/kernel/irq.c          |   20 ++++++++++++++------
>  arch/x86/kernel/irqinit.c      |    4 ++--
>  4 files changed, 25 insertions(+), 14 deletions(-)
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
> index 22d0687..8e9f0aa 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -193,9 +193,13 @@ __visible unsigned int __irq_entry do_IRQ(struct
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
> +		else
> +			__this_cpu_write(vector_irq[vector],
> +					 VECTOR_UNDEFINED);
>  	}
>
>  	irq_exit();
> @@ -344,7 +348,7 @@ void fixup_irqs(void)
>  	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>  		unsigned int irr;
>
> -		if (__this_cpu_read(vector_irq[vector]) < 0)
> +		if (__this_cpu_read(vector_irq[vector]) <= VECTOR_UNDEFINED)
>  			continue;
>
>  		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
> @@ -355,11 +359,15 @@ void fixup_irqs(void)
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
>

If it precisely catches the remaining IRR, then it is something good to have.

Reviewed-by: Rui Wang <rui.y.wang@intel.com>

Thanks
Rui
