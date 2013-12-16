Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3LPDBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:01:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33605 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3LPDBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:01:52 -0500
Date: Sun, 15 Dec 2013 22:00:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 [resend] 14/18] smp, x86, xen: kill SMP single
 function call interrupt
Message-ID: <20131216030040.GB7180@pegasus.dumpdata.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
 <1387125400-28849-15-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387125400-28849-15-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 12:36:36AM +0800, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I presume this has been tested?

> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: x86@kernel.org
> Cc: xen-devel@lists.xensource.com
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/x86/include/asm/xen/events.h |  1 -
>  arch/x86/xen/smp.c                | 38 ++------------------------------------
>  2 files changed, 2 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
> index 608a79d..a9e54dc 100644
> --- a/arch/x86/include/asm/xen/events.h
> +++ b/arch/x86/include/asm/xen/events.h
> @@ -4,7 +4,6 @@
>  enum ipi_vector {
>  	XEN_RESCHEDULE_VECTOR,
>  	XEN_CALL_FUNCTION_VECTOR,
> -	XEN_CALL_FUNCTION_SINGLE_VECTOR,
>  	XEN_SPIN_UNLOCK_VECTOR,
>  	XEN_IRQ_WORK_VECTOR,
>  	XEN_NMI_VECTOR,
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index c36b325..7cf1689 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -46,12 +46,10 @@ struct xen_common_irq {
>  };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
> -static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
>  
>  static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
> -static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
>  static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
>  
>  /*
> @@ -123,13 +121,6 @@ static void xen_smp_intr_free(unsigned int cpu)
>  		kfree(per_cpu(xen_debug_irq, cpu).name);
>  		per_cpu(xen_debug_irq, cpu).name = NULL;
>  	}
> -	if (per_cpu(xen_callfuncsingle_irq, cpu).irq >= 0) {
> -		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu).irq,
> -				       NULL);
> -		per_cpu(xen_callfuncsingle_irq, cpu).irq = -1;
> -		kfree(per_cpu(xen_callfuncsingle_irq, cpu).name);
> -		per_cpu(xen_callfuncsingle_irq, cpu).name = NULL;
> -	}
>  	if (xen_hvm_domain())
>  		return;
>  
> @@ -178,18 +169,6 @@ static int xen_smp_intr_init(unsigned int cpu)
>  	per_cpu(xen_debug_irq, cpu).irq = rc;
>  	per_cpu(xen_debug_irq, cpu).name = debug_name;
>  
> -	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
> -	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
> -				    cpu,
> -				    xen_call_function_single_interrupt,
> -				    IRQF_PERCPU|IRQF_NOBALANCING,
> -				    callfunc_name,
> -				    NULL);
> -	if (rc < 0)
> -		goto fail;
> -	per_cpu(xen_callfuncsingle_irq, cpu).irq = rc;
> -	per_cpu(xen_callfuncsingle_irq, cpu).name = callfunc_name;
> -
>  	/*
>  	 * The IRQ worker on PVHVM goes through the native path and uses the
>  	 * IPI mechanism.
> @@ -569,8 +548,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
>  
>  static void xen_smp_send_call_function_single_ipi(int cpu)
>  {
> -	__xen_send_IPI_mask(cpumask_of(cpu),
> -			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
> +	__xen_send_IPI_mask(cpumask_of(cpu), XEN_CALL_FUNCTION_VECTOR);
>  }
>  
>  static inline int xen_map_vector(int vector)
> @@ -582,10 +560,8 @@ static inline int xen_map_vector(int vector)
>  		xen_vector = XEN_RESCHEDULE_VECTOR;
>  		break;
>  	case CALL_FUNCTION_VECTOR:
> -		xen_vector = XEN_CALL_FUNCTION_VECTOR;
> -		break;
>  	case CALL_FUNCTION_SINGLE_VECTOR:
> -		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
> +		xen_vector = XEN_CALL_FUNCTION_VECTOR;
>  		break;
>  	case IRQ_WORK_VECTOR:
>  		xen_vector = XEN_IRQ_WORK_VECTOR;
> @@ -663,16 +639,6 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
> -{
> -	irq_enter();
> -	generic_smp_call_function_single_interrupt();
> -	inc_irq_stat(irq_call_count);
> -	irq_exit();
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id)
>  {
>  	irq_enter();
> -- 
> 1.8.1.2
> 
