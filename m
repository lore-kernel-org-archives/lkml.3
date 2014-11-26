Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKZMzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:55:51 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:37890
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbaKZMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:55:49 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2014 07:55:49 EST
From: Tim Sander <tim@krieglstein.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Wed, 26 Nov 2014 13:46:52 +0100
Message-ID: <2744845.J3XUj2a9bM@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416936401-5147-6-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel

Am Dienstag, 25. November 2014, 17:26:41 schrieb Daniel Thompson:
> Previous changes have introduced both a replacement default FIQ handler
> and an implementation of arch_trigger_all_cpu_backtrace for ARM but
> these are currently independent of each other.
> 
> This patch plumbs together these features making it possible, on platforms
> that support it, to trigger backtrace using FIQ.
Does this ipi handler interfere in any way with set_fiq_handler?

As far as i know there is only one FIQ handler vector so i guess there is a 
potential conflict. But i have not worked with IPI's so i might be completley
wrong.

Regards
Tim

> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/include/asm/smp.h | 3 +++
>  arch/arm/kernel/smp.c      | 4 +++-
>  arch/arm/kernel/traps.c    | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
> index 18f5a554134f..b076584ac0fa 100644
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -18,6 +18,8 @@
>  # error "<asm/smp.h> included in non-SMP build"
>  #endif
> 
> +#define SMP_IPI_FIQ_MASK 0x0100
> +
>  #define raw_smp_processor_id() (current_thread_info()->cpu)
> 
>  struct seq_file;
> @@ -79,6 +81,7 @@ extern void arch_send_call_function_single_ipi(int cpu);
>  extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
>  extern void arch_send_wakeup_ipi_mask(const struct cpumask *mask);
> 
> +extern void ipi_cpu_backtrace(struct pt_regs *regs);
>  extern int register_ipi_completion(struct completion *completion, int cpu);
> 
>  struct smp_operations {
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 14c594a12bef..e923843562d9 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -539,7 +539,7 @@ static void ipi_cpu_stop(unsigned int cpu)
>  		cpu_relax();
>  }
> 
> -static void ipi_cpu_backtrace(struct pt_regs *regs)
> +void ipi_cpu_backtrace(struct pt_regs *regs)
>  {
>  	int cpu = smp_processor_id();
> 
> @@ -580,6 +580,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
>  	unsigned int cpu = smp_processor_id();
>  	struct pt_regs *old_regs = set_irq_regs(regs);
> 
> +	BUILD_BUG_ON(SMP_IPI_FIQ_MASK != BIT(IPI_CPU_BACKTRACE));
> +
>  	if ((unsigned)ipinr < NR_IPI) {
>  		trace_ipi_entry(ipi_types[ipinr]);
>  		__inc_irq_stat(cpu, ipi_irqs[ipinr]);
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 4dc45b38e56e..9eb05be9526e 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry
> handle_fiq_as_nmi(struct pt_regs *regs) #ifdef CONFIG_ARM_GIC
>  	gic_handle_fiq_ipi();
>  #endif
> +#ifdef CONFIG_SMP
> +	ipi_cpu_backtrace(regs);
> +#endif
> 
>  	nmi_exit();

