Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaCQRIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:08:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16483 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaCQRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:08:50 -0400
Message-ID: <53272CA1.3000609@oracle.com>
Date: Mon, 17 Mar 2014 13:10:57 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/xen: Disable APIC PM for Xen PV guests
References: <1393900821-6182-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1393900821-6182-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 09:40 PM, Boris Ostrovsky wrote:
> Xen PV guests support only few APIC registers and writes to
> unsupported registers result in WARN_ONs. Most APIC accesses in these
> guests  have been eliminated; however, lapic_suspend/resume are still
> called (on 32-bit kernels).
>
> We can disable APIC power management in xen_smp_prepare_boot_cpu()
> (which is called after APIC has been initialized).


This touches generic APIC code so x86 maintainers' review would
be appreciated.

Thanks.
-boris


> Signed-off-by: Boris Ostrovsky<boris.ostrovsky@oracle.com>
> ---
>   arch/x86/include/asm/apic.h |    2 ++
>   arch/x86/kernel/apic/apic.c |    6 ++++++
>   arch/x86/xen/smp.c          |    4 ++++
>   3 files changed, 12 insertions(+)
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
>   extern int default_check_phys_apicid_present(int phys_apicid);
>   #endif
>   
> +extern void apic_pm_deactivate(void);
> +
>   #endif /* CONFIG_X86_LOCAL_APIC */
>   extern void irq_enter(void);
>   extern void irq_exit(void);
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 7f26c9a..60607b3 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2424,6 +2424,11 @@ static void apic_pm_activate(void)
>   	apic_pm_state.active = 1;
>   }
>   
> +void apic_pm_deactivate(void)
> +{
> +	apic_pm_state.active = 0;
> +}
> +
>   static int __init init_lapic_sysfs(void)
>   {
>   	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
> @@ -2439,6 +2444,7 @@ core_initcall(init_lapic_sysfs);
>   #else	/* CONFIG_PM */
>   
>   static void apic_pm_activate(void) { }
> +void apic_pm_deactivate(void) { }
>   
>   #endif	/* CONFIG_PM */
>   
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index a18eadd..33115d8 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -298,6 +298,10 @@ static void __init xen_smp_prepare_boot_cpu(void)
>   
>   		xen_filter_cpu_maps();
>   		xen_setup_vcpu_info_placement();
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +		apic_pm_deactivate();
> +#endif
>   	}
>   	/*
>   	 * The alternative logic (which patches the unlock/lock) runs before

