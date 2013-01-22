Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3AVV5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:57:40 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52043 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab3AVV5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:57:37 -0500
Subject: Re: [PATCH] x86, Allow x2apic without IR on VMware platform.
From: Alok Kataria <akataria@vmware.com>
Reply-To: Alok Kataria <akataria@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>,
        Doug Covelli <dcovelli@vmware.com>,
        virtualization@lists.linux-foundation.org
In-Reply-To: <1358466282.423.60.camel@akataria-dtop.eng.vmware.com>
References: <1358466282.423.60.camel@akataria-dtop.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jan 2013 13:57:36 -0800
Message-ID: <1358891856.28018.205.camel@akataria-dtop.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Ingo,

Can you please consider this patch, it allows linux guests to use x2apic
when running on VMware platform. 

Thanks,
Alok

On Thu, 2013-01-17 at 15:44 -0800, Alok Kataria wrote:
> Please consider this patch to allow x2apic without IR support when
> running on VMware platform. Tested on top of 3.8-rc3.
> 
> Thanks,
> Alok
> 
> --
> Allow x2apic without IR on VMware platform.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> This patch updates x2apic initializaition code to allow x2apic on VMware
> platform even without interrupt remapping support.
> The hypervisor_x2apic_available hook was added in x2apic initialization code
> and used by KVM and XEN, before this.
> I have also cleaned up that code to export this hook through the
> hypervisor_x86 structure.
> 
> Compile tested for KVM and XEN configs, this patch doesn't have any functional
> effect on those two platforms.
> 
> On VMware platform, verified that x2apic is used in physical mode on products that
> support this.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Reviewed-by: Doug Covelli <dcovelli@vmware.com>
> Reviewed-by: Dan Hecht <dhecht@vmware.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Avi Kivity <avi@redhat.com>
> 
> ---
> 
>  arch/x86/include/asm/hypervisor.h |   13 ++++---------
>  arch/x86/kernel/cpu/hypervisor.c  |    7 +++++++
>  arch/x86/kernel/cpu/vmware.c      |   13 +++++++++++++
>  arch/x86/kernel/kvm.c             |    1 +
>  arch/x86/xen/enlighten.c          |    1 +
>  5 files changed, 26 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
> index b518c75..86095ed 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -25,6 +25,7 @@
>  
>  extern void init_hypervisor(struct cpuinfo_x86 *c);
>  extern void init_hypervisor_platform(void);
> +extern bool hypervisor_x2apic_available(void);
>  
>  /*
>   * x86 hypervisor information
> @@ -41,6 +42,9 @@ struct hypervisor_x86 {
>  
>  	/* Platform setup (run once per boot) */
>  	void		(*init_platform)(void);
> +
> +	/* X2APIC detection (run once per boot) */
> +	bool		(*x2apic_available)(void);
>  };
>  
>  extern const struct hypervisor_x86 *x86_hyper;
> @@ -51,13 +55,4 @@ extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
>  extern const struct hypervisor_x86 x86_hyper_xen_hvm;
>  extern const struct hypervisor_x86 x86_hyper_kvm;
>  
> -static inline bool hypervisor_x2apic_available(void)
> -{
> -	if (kvm_para_available())
> -		return true;
> -	if (xen_x2apic_para_available())
> -		return true;
> -	return false;
> -}
> -
>  #endif
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index a8f8fa9..1e7e84a 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -79,3 +79,10 @@ void __init init_hypervisor_platform(void)
>  	if (x86_hyper->init_platform)
>  		x86_hyper->init_platform();
>  }
> +
> +bool __init hypervisor_x2apic_available(void)
> +{
> +	return x86_hyper                   &&
> +	       x86_hyper->x2apic_available &&
> +	       x86_hyper->x2apic_available();
> +}
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index d22d0c4..03a3632 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -33,6 +33,9 @@
>  
>  #define VMWARE_PORT_CMD_GETVERSION	10
>  #define VMWARE_PORT_CMD_GETHZ		45
> +#define VMWARE_PORT_CMD_GETVCPU_INFO	68
> +#define VMWARE_PORT_CMD_LEGACY_X2APIC	3
> +#define VMWARE_PORT_CMD_VCPU_RESERVED	31
>  
>  #define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
>  	__asm__("inl (%%dx)" :						\
> @@ -125,10 +128,20 @@ static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
>  	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
>  }
>  
> +/* Checks if hypervisor supports x2apic without VT-D interrupt remapping. */
> +static bool __init vmware_legacy_x2apic_available(void)
> +{
> +	uint32_t eax, ebx, ecx, edx;
> +	VMWARE_PORT(GETVCPU_INFO, eax, ebx, ecx, edx);
> +	return (eax & (1 << VMWARE_PORT_CMD_VCPU_RESERVED)) == 0 &&
> +	       (eax & (1 << VMWARE_PORT_CMD_LEGACY_X2APIC)) != 0;
> +}
> +
>  const __refconst struct hypervisor_x86 x86_hyper_vmware = {
>  	.name			= "VMware",
>  	.detect			= vmware_platform,
>  	.set_cpu_features	= vmware_set_cpu_features,
>  	.init_platform		= vmware_platform_setup,
> +	.x2apic_available	= vmware_legacy_x2apic_available,
>  };
>  EXPORT_SYMBOL(x86_hyper_vmware);
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 9c2bd8b..2b44ea5 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -505,6 +505,7 @@ static bool __init kvm_detect(void)
>  const struct hypervisor_x86 x86_hyper_kvm __refconst = {
>  	.name			= "KVM",
>  	.detect			= kvm_detect,
> +	.x2apic_available	= kvm_para_available,
>  };
>  EXPORT_SYMBOL_GPL(x86_hyper_kvm);
>  
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 138e566..8b4c56d 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1668,6 +1668,7 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
>  	.name			= "Xen HVM",
>  	.detect			= xen_hvm_platform,
>  	.init_platform		= xen_hvm_guest_init,
> +	.x2apic_available	= xen_x2apic_para_available,
>  };
>  EXPORT_SYMBOL(x86_hyper_xen_hvm);
>  #endif
> 


