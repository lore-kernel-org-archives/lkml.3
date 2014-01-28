Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaA1TzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:55:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44660 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1TzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:55:21 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="95416572"
Date: Tue, 28 Jan 2014 19:55:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <patches@linaro.org>,
        <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] arm/xen: Initialize event channels earlier
In-Reply-To: <1390935264-23155-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1401281954560.4373@kaball.uk.xensource.com>
References: <1390935264-23155-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
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

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


> ---
>     Changes in v2:
>         - Check earlier if the event IRQ is valid
>         - We can safely register the VCPU when the cpu is booting
> ---
>  arch/arm/xen/enlighten.c |   71 ++++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 293eeea..b96723e 100644
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
> @@ -154,7 +155,7 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  }
>  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
>  
> -static void __init xen_percpu_init(void *unused)
> +static void xen_percpu_init(void)
>  {
>  	struct vcpu_register_vcpu_info info;
>  	struct vcpu_info *vcpup;
> @@ -193,6 +194,31 @@ static void xen_power_off(void)
>  		BUG();
>  }
>  
> +static int xen_cpu_notification(struct notifier_block *self,
> +				unsigned long action,
> +				void *hcpu)
> +{
> +	switch (action) {
> +	case CPU_STARTING:
> +		xen_percpu_init();
> +		break;
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
> +static irqreturn_t xen_arm_callback(int irq, void *arg)
> +{
> +	xen_hvm_evtchn_do_upcall();
> +	return IRQ_HANDLED;
> +}
> +
>  /*
>   * see Documentation/devicetree/bindings/arm/xen.txt for the
>   * documentation of the Xen Device Tree format.
> @@ -229,6 +255,10 @@ static int __init xen_guest_init(void)
>  	xen_events_irq = irq_of_parse_and_map(node, 0);
>  	pr_info("Xen %s support found, events_irq=%d gnttab_frame=%pa\n",
>  			version, xen_events_irq, &grant_frames);
> +
> +	if (xen_events_irq < 0)
> +		return -ENODEV;
> +
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
>  	xen_setup_features();
> @@ -281,9 +311,21 @@ static int __init xen_guest_init(void)
>  	disable_cpuidle();
>  	disable_cpufreq();
>  
> +	xen_init_IRQ();
> +
> +	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
> +			       "events", &xen_vcpu)) {
> +		pr_err("Error request IRQ %d\n", xen_events_irq);
> +		return -EINVAL;
> +	}
> +
> +	xen_percpu_init();
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
> @@ -297,31 +339,6 @@ static int __init xen_pm_init(void)
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
