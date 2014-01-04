Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaADFkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 00:40:45 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:62644 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaADFkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 00:40:00 -0500
MIME-Version: 1.0
In-Reply-To: <1388251228-18558-1-git-send-email-prarit@redhat.com>
References: <1388251228-18558-1-git-send-email-prarit@redhat.com>
Date: Sat, 4 Jan 2014 13:39:58 +0800
Message-ID: <CANVTcTZuQrLsUjinE-om49mDrksGxMFyM_nT8qGJf3XQT-bd8w@mail.gmail.com>
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug
 retriggered irqs [v2]
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

On 12/29/13, Prarit Bhargava <prarit@redhat.com> wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64831
>
> When downing a cpu it is possible that there are unhandled irqs left in
> the APIC IRR register.  The following code path shows how the problem
> can occur:
>
> 1. CPU 5 is to go down.
> 2. CPU 5 IRQ 12 IRR is set to request service, but ISR is not set.
> 3. cpu_disable on CPU 5 executes via stop_machine()

Step2 should come after step3:

2.  cpu_disable() on CPU 5 executes with interrupt flag cleared by
local_irq_save() via stop_machine().
3. IRQ 12 asserts on CPU 5, setting IRR but not ISR because interrupt
flag is cleared (CPU unabled to handle the irq)

(It'll turn into ISR after interrupt flag is set by local_irq_restore())

> 4. IRQs are migrated off of CPU 5, and the vectors' irqs are set to -1.
> 4. stop_machine() finishes cpu_disable()
> 5. cpu_die() for CPU 5 executes in normal context.
> 6. CPU 5 attempts to handle IRQ 12 because the IRR is set for IRQ 12.  The
> code attempts to find the vector's IRQ and cannot because it has been set to
> -1.
> 7. do_IRQ warning displays warning about CPU 5 IRQ 12.
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

Since IRR can only buffer one interrupt, after catching it once, no
further irq is supposed to come here again. It is then safe to turn
VECTOR_RETRIGGERED into VECTOR_UNDEFINED here. i.e. something like
this:

+		if (irq != VECTOR_RETRIGGERED)
+			pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %d)\n",
+					     __func__, smp_processor_id(),
+					     vector, irq);
+		else
+			__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);

I think this can be used to test if you've found all the causes of the problem.

Thanks
Rui
