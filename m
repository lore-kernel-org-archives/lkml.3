Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaA1RPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:15:40 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54450 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbaA1ROE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:14:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97338192"
Date: Tue, 28 Jan 2014 17:13:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <patches@linaro.org>,
        <david.vrabel@citrix.com>
Subject: Re: [PATCH] arm/xen: Initialize event channels earlier
In-Reply-To: <1390920842-21886-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1401281651400.4373@kaball.uk.xensource.com>
References: <1390920842-21886-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Julien Grall wrote:
> Event channels driver needs to be initialized very early. Until now, Xen
> initialization was done after all CPUs was bring up.
> 
> We can safely move the initialization to an early initcall.
> 
> Also use a cpu notifier to:
>     - Register the VCPU when the CPU is prepared
>     - Enable event channel IRQ when the CPU is running
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Did you test this patch in Dom0 as well as in DomUs?


>  arch/arm/xen/enlighten.c |   84 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 55 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 293eeea..39b668e 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -23,6 +23,7 @@
>  #include <linux/of_address.h>
>  #include <linux/cpuidle.h>
>  #include <linux/cpufreq.h>
> +#include <linux/cpu.h>
>  
>  #include <linux/mm.h>
>  
> @@ -154,12 +155,11 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
>  
> -static void __init xen_percpu_init(void *unused)
> +static void xen_percpu_init(int cpu)
>  {
>  	struct vcpu_register_vcpu_info info;
>  	struct vcpu_info *vcpup;
>  	int err;
> -	int cpu = get_cpu();
>  
>  	pr_info("Xen: initializing cpu%d\n", cpu);
>  	vcpup = per_cpu_ptr(xen_vcpu_info, cpu);
> @@ -170,9 +170,11 @@ static void __init xen_percpu_init(void *unused)
>  	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
>  	BUG_ON(err);
>  	per_cpu(xen_vcpu, cpu) = vcpup;
> +}
>  
> +static void xen_interrupt_init(void)
> +{
>  	enable_percpu_irq(xen_events_irq, 0);
> -	put_cpu();
>  }
>  
>  static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
> @@ -193,6 +195,36 @@ static void xen_power_off(void)
>  		BUG();
>  }
>  
> +static irqreturn_t xen_arm_callback(int irq, void *arg)
> +{
> +	xen_hvm_evtchn_do_upcall();
> +	return IRQ_HANDLED;
> +}
> +
> +static int xen_cpu_notification(struct notifier_block *self,
> +				unsigned long action,
> +				void *hcpu)
> +{
> +	int cpu = (long)hcpu;
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		xen_percpu_init(cpu);
> +		break;
> +	case CPU_STARTING:
> +		xen_interrupt_init();
> +		break;

Is CPU_STARTING guaranteed to be called on the new cpu only?
If so, why not call both xen_percpu_init and xen_interrupt_init on
CPU_STARTING?
As it stands I think you introduced a subtle change (that might be OK
but I think is unintentional): xen_percpu_init might not be called from
the same cpu as its target anymore.


> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block xen_cpu_notifier = {
> +	.notifier_call = xen_cpu_notification,
> +};
> +
>  /*
>   * see Documentation/devicetree/bindings/arm/xen.txt for the
>   * documentation of the Xen Device Tree format.
> @@ -209,6 +241,7 @@ static int __init xen_guest_init(void)
>  	const char *xen_prefix = "xen,xen-";
>  	struct resource res;
>  	phys_addr_t grant_frames;
> +	int cpu;
>  
>  	node = of_find_compatible_node(NULL, NULL, "xen,xen");
>  	if (!node) {
> @@ -281,9 +314,27 @@ static int __init xen_guest_init(void)
>  	disable_cpuidle();
>  	disable_cpufreq();
>  
> +	xen_init_IRQ();
> +
> +	if (xen_events_irq < 0)
> +		return -ENODEV;

Since you are moving this code to xen_guest_init, you can check for
xen_events_irq earlier on, where we parse the irq from device tree.


> +	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
> +			       "events", &xen_vcpu)) {
> +		pr_err("Error request IRQ %d\n", xen_events_irq);
> +		return -EINVAL;
> +	}
> +
> +	cpu = get_cpu();
> +	xen_percpu_init(cpu);
> +	xen_interrupt_init();
> +	put_cpu();
> +
> +	register_cpu_notifier(&xen_cpu_notifier);
> +
>  	return 0;
>  }
> -core_initcall(xen_guest_init);
> +early_initcall(xen_guest_init);
>  
>  static int __init xen_pm_init(void)
>  {
> @@ -297,31 +348,6 @@ static int __init xen_pm_init(void)
>  }
>  late_initcall(xen_pm_init);
>  
> -static irqreturn_t xen_arm_callback(int irq, void *arg)
> -{
> -	xen_hvm_evtchn_do_upcall();
> -	return IRQ_HANDLED;
> -}
> -
> -static int __init xen_init_events(void)
> -{
> -	if (!xen_domain() || xen_events_irq < 0)
> -		return -ENODEV;
> -
> -	xen_init_IRQ();
> -
> -	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
> -			"events", &xen_vcpu)) {
> -		pr_err("Error requesting IRQ %d\n", xen_events_irq);
> -		return -EINVAL;
> -	}
> -
> -	on_each_cpu(xen_percpu_init, NULL, 0);
> -
> -	return 0;
> -}
> -postcore_initcall(xen_init_events);
> -
>  /* In the hypervisor.S file. */
>  EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
> -- 
> 1.7.10.4
> 
