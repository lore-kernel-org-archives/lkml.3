Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3BMC4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:56:13 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45510 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3BMC4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:56:12 -0500
MIME-Version: 1.0
In-Reply-To: <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
References: <1359940959-32168-3-git-send-email-kys@microsoft.com>
	<tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
Date: Tue, 12 Feb 2013 18:56:11 -0800
X-Google-Sender-Auth: lhWDiRszc7JJuRPbJt1m2JRVvnA
Message-ID: <CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 4:58 PM, tip-bot for K. Y. Srinivasan
<kys@microsoft.com> wrote:
> Commit-ID:  bc2b0331e077f576369a2b6c75d15ed4de4ef91f
> Gitweb:     http://git.kernel.org/tip/bc2b0331e077f576369a2b6c75d15ed4de4ef91f
> Author:     K. Y. Srinivasan <kys@microsoft.com>
> AuthorDate: Sun, 3 Feb 2013 17:22:39 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 12 Feb 2013 16:27:15 -0800
>
> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
>
> Starting with win8, vmbus interrupts can be delivered on any VCPU in the guest
> and furthermore can be concurrently active on multiple VCPUs. Support this
> interrupt delivery model by setting up a separate IDT entry for Hyper-V vmbus.
> interrupts. I would like to thank Jan Beulich <JBeulich@suse.com> and
> Thomas Gleixner <tglx@linutronix.de>, for their help.
>
> In this version of the patch, based on the feedback, I have merged the IDT
> vector for Xen and Hyper-V and made the necessary adjustments. Furhermore,
> based on Jan's feedback I have added the necessary compilation switches.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Link: http://lkml.kernel.org/r/1359940959-32168-3-git-send-email-kys@microsoft.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/irq_vectors.h |  4 ++--
>  arch/x86/include/asm/mshyperv.h    |  4 ++++
>  arch/x86/kernel/cpu/mshyperv.c     | 44 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/entry_32.S         |  9 +++++++-
>  arch/x86/kernel/entry_64.S         |  7 +++++-
>  drivers/xen/events.c               |  7 +++---
>  6 files changed, 68 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 1508e51..aac5fa6 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -109,8 +109,8 @@
>
>  #define UV_BAU_MESSAGE                 0xf5
>
> -/* Xen vector callback to receive events in a HVM domain */
> -#define XEN_HVM_EVTCHN_CALLBACK                0xf3
> +/* Vector on which hypervisor callbacks will be delivered */
> +#define HYPERVISOR_CALLBACK_VECTOR     0xf3
>
>  /*
>   * Local APIC timer IRQ vector is on a different priority level,
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> index 79ce568..c2934be 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -11,4 +11,8 @@ struct ms_hyperv_info {
>
>  extern struct ms_hyperv_info ms_hyperv;
>
> +void hyperv_callback_vector(void);
> +void hyperv_vector_handler(struct pt_regs *regs);
> +void hv_register_vmbus_handler(int irq, irq_handler_t handler);
> +
>  #endif
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 4dab317..a7d26d8 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -14,10 +14,15 @@
>  #include <linux/time.h>
>  #include <linux/clocksource.h>
>  #include <linux/module.h>
> +#include <linux/hardirq.h>
> +#include <linux/interrupt.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
>  #include <asm/hyperv.h>
>  #include <asm/mshyperv.h>
> +#include <asm/desc.h>
> +#include <asm/idle.h>
> +#include <asm/irq_regs.h>
>
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> @@ -77,6 +82,12 @@ static void __init ms_hyperv_init_platform(void)
>
>         if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>                 clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +#if IS_ENABLED(CONFIG_HYPERV)
> +       /*
> +        * Setup the IDT for hypervisor callback.
> +        */
> +       alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
> +#endif
>  }
>
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> @@ -85,3 +96,36 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
>         .init_platform          = ms_hyperv_init_platform,
>  };
>  EXPORT_SYMBOL(x86_hyper_ms_hyperv);
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +static int vmbus_irq = -1;
> +static irq_handler_t vmbus_isr;
> +
> +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> +{
> +       vmbus_irq = irq;
> +       vmbus_isr = handler;
> +}
> +
> +void hyperv_vector_handler(struct pt_regs *regs)
> +{
> +       struct pt_regs *old_regs = set_irq_regs(regs);
> +       struct irq_desc *desc;
> +
> +       irq_enter();
> +       exit_idle();
> +
> +       desc = irq_to_desc(vmbus_irq);
> +
> +       if (desc)
> +               generic_handle_irq_desc(vmbus_irq, desc);
> +
> +       irq_exit();
> +       set_irq_regs(old_regs);
> +}
> +#else
> +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> +{
> +}
> +#endif
> +EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 6ed91d9..8831176 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1091,11 +1091,18 @@ ENTRY(xen_failsafe_callback)
>         _ASM_EXTABLE(4b,9b)
>  ENDPROC(xen_failsafe_callback)
>
> -BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
> +BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
>                 xen_evtchn_do_upcall)
>
>  #endif /* CONFIG_XEN */
>
> +#if IS_ENABLED(CONFIG_HYPERV)
> +
> +BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
> +       hyperv_vector_handler)
> +
> +#endif /* CONFIG_HYPERV */
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index cb3c591..048f224 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1454,11 +1454,16 @@ ENTRY(xen_failsafe_callback)
>         CFI_ENDPROC
>  END(xen_failsafe_callback)
>
> -apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
>         xen_hvm_callback_vector xen_evtchn_do_upcall
>
>  #endif /* CONFIG_XEN */
>
> +#if IS_ENABLED(CONFIG_HYPERV)
> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> +       hyperv_callback_vector hyperv_vector_handler
> +#endif /* CONFIG_HYPERV */
> +

so #ifdef CONFIG_HYPERV does not work here?

Yinghai
