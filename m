Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaCDKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:25:58 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:11248 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbaCDKZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:25:56 -0500
X-IronPort-AV: E=Sophos;i="4.97,583,1389744000"; 
   d="scan'208";a="106329915"
Message-ID: <5315AA31.7090907@citrix.com>
Date: Tue, 4 Mar 2014 10:25:53 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/xen: Disable APIC PM for Xen PV guests
References: <1393900821-6182-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1393900821-6182-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 02:40, Boris Ostrovsky wrote:
> Xen PV guests support only few APIC registers and writes to
> unsupported registers result in WARN_ONs. Most APIC accesses in these
> guests  have been eliminated; however, lapic_suspend/resume are still
> called (on 32-bit kernels).
> 
> We can disable APIC power management in xen_smp_prepare_boot_cpu()
> (which is called after APIC has been initialized).

Having looked at another APIC related problem recently, I wonder if Xen
would be better served by having its own APIC driver instead of trying
to piggy-back of some hardware one which doesn't do what we want.

David

> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/include/asm/apic.h |    2 ++
>  arch/x86/kernel/apic/apic.c |    6 ++++++
>  arch/x86/xen/smp.c          |    4 ++++
>  3 files changed, 12 insertions(+)
> 
> 
> An alternative could be to add another op to stuct apic. The advantage would be
> the fact that we never have a window of time when APIC PM is enabled. The downside
> is having yet another op (of which there are already plenty).
> 
> We could also avoid loading lapic_syscore_ops but I couldn't think of a good way
> to figure out when not to do it.
> 
> 
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 1d2091a..1f100f2 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -687,6 +687,8 @@ extern int default_cpu_present_to_apicid(int mps_cpu);
>  extern int default_check_phys_apicid_present(int phys_apicid);
>  #endif
>  
> +extern void apic_pm_deactivate(void);
> +
>  #endif /* CONFIG_X86_LOCAL_APIC */
>  extern void irq_enter(void);
>  extern void irq_exit(void);
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 7f26c9a..60607b3 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2424,6 +2424,11 @@ static void apic_pm_activate(void)
>  	apic_pm_state.active = 1;
>  }
>  
> +void apic_pm_deactivate(void)
> +{
> +	apic_pm_state.active = 0;
> +}
> +
>  static int __init init_lapic_sysfs(void)
>  {
>  	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
> @@ -2439,6 +2444,7 @@ core_initcall(init_lapic_sysfs);
>  #else	/* CONFIG_PM */
>  
>  static void apic_pm_activate(void) { }
> +void apic_pm_deactivate(void) { }
>  
>  #endif	/* CONFIG_PM */
>  
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index a18eadd..33115d8 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -298,6 +298,10 @@ static void __init xen_smp_prepare_boot_cpu(void)
>  
>  		xen_filter_cpu_maps();
>  		xen_setup_vcpu_info_placement();
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +		apic_pm_deactivate();
> +#endif
>  	}
>  	/*
>  	 * The alternative logic (which patches the unlock/lock) runs before

