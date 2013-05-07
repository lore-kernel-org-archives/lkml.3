Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3EGJRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:17:54 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57306 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3EGJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:17:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4289979"
Message-ID: <1367918270.26321.39.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC v2 4/4] xen/arm: account for stolen ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 7 May 2013 10:17:50 +0100
In-Reply-To: <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
	 <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 15:51 +0100, Stefano Stabellini wrote:
> Register the runstate_memory_area with the hypervisor.
> Use pv_time_ops.steal_clock to account for stolen ticks.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/xen/enlighten.c |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index ee86bfa..2a5cc82 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -14,7 +14,10 @@
>  #include <xen/xen-ops.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <asm/arch_timer.h>
>  #include <asm/system_misc.h>
> +#include <asm/paravirt.h>
> +#include <linux/jump_label.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqreturn.h>
>  #include <linux/module.h>
> @@ -152,6 +155,20 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
>  
> +unsigned long long xen_stolen_accounting(int cpu)
> +{
> +	struct vcpu_runstate_info state;
> +
> +	if (cpu != get_cpu())

get_cpu disables preempt, so you need a matching put_cpu.

But actually I think you just want smp_processor_id and you probably
want the BUG_ON form to get unlikely etc.

That said, you don't use cpu for anything else, so why not drop it
entirely?

> +		BUG();
> +
> +	xen_get_runstate_snapshot(&state);
> +
> +	WARN_ON(state.state != RUNSTATE_running);
> +
> +	return state.time[RUNSTATE_runnable] + state.time[RUNSTATE_offline];
> +}
> +
>  static void __init xen_percpu_init(void *unused)
>  {
>  	struct vcpu_register_vcpu_info info;
> @@ -170,6 +187,8 @@ static void __init xen_percpu_init(void *unused)
>  		BUG();
>  	per_cpu(xen_vcpu, cpu) = vcpup;
>  
> +	xen_setup_runstate_info(cpu);
> +
>  	enable_percpu_irq(xen_events_irq, 0);
>  }
>  
> @@ -301,6 +320,10 @@ static int __init xen_init_events(void)
>  
>  	on_each_cpu(xen_percpu_init, NULL, 0);
>  
> +	pv_time_ops.steal_clock = xen_stolen_accounting;
> +	static_key_slow_inc(&paravirt_steal_enabled);
> +	static_key_slow_inc(&paravirt_steal_rq_enabled);

We don't seem to do this on x86 -- is that a bug on x86 on Xen?

> +
>  	return 0;
>  }
>  postcore_initcall(xen_init_events);


