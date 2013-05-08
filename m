Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab3EHQHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:07:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41574 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab3EHQHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:07:22 -0400
Message-ID: <518A7836.4030705@arm.com>
Date: Wed, 08 May 2013 17:07:18 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v3 4/4] xen/arm: account for stolen ticks
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com> <1368027714-14506-4-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1368027714-14506-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 08 May 2013 16:07:18.0465 (UTC) FILETIME=[1D413310:01CE4C06]
X-MC-Unique: 113050817071828301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 08/05/13 16:41, Stefano Stabellini wrote:
> Register the runstate_memory_area with the hypervisor.
> Use pv_time_ops.steal_clock to account for stolen ticks.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Changes in v3:
> - use BUG_ON and smp_processor_id.
> ---
>  arch/arm/xen/enlighten.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 13609e0..dfa7738 100644
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
> @@ -152,6 +155,19 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
>  
> +unsigned long long xen_stolen_accounting(int cpu)
> +{
> +	struct vcpu_runstate_info state;
> +
> +	BUG_ON(cpu != smp_processor_id());
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
> @@ -169,6 +185,8 @@ static void __init xen_percpu_init(void *unused)
>  	BUG_ON(err);
>  	per_cpu(xen_vcpu, cpu) = vcpup;
>  
> +	xen_setup_runstate_info(cpu);
> +
>  	enable_percpu_irq(xen_events_irq, 0);
>  }
>  
> @@ -300,6 +318,10 @@ static int __init xen_init_events(void)
>  
>  	on_each_cpu(xen_percpu_init, NULL, 0);
>  
> +	pv_time_ops.steal_clock = xen_stolen_accounting;

What guarantee do we have that this is done before the rest of the
kernel calls paravirt_steal_clock()? What if we have Xen support enabled
but don't run as a Xen guest?

> +	static_key_slow_inc(&paravirt_steal_enabled);
> +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> +
>  	return 0;
>  }
>  postcore_initcall(xen_init_events);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

