Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3LRO1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:27:45 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56530 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab3LRO1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:27:42 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85750150"
Date: Wed, 18 Dec 2013 14:27:08 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 03/12] xen/pvh: Early bootup changes in
 PV code.
In-Reply-To: <1387313503-31362-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181423380.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> In the bootup code for PVH we can trap cpuid via vmexit, so don't
> need to use emulated prefix call. We also check for vector callback
> early on, as it is a required feature. PVH also runs at default kernel
> IOPL.
> 
> Finally, pure PV settings are moved to a separate function that are
> only called for pure PV, ie, pv with pvmmu. They are also #ifdef
> with CONFIG_XEN_PVMMU.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c | 63 +++++++++++++++++++++++++++++++++---------------
>  arch/x86/xen/setup.c     | 18 +++++++++-----
>  2 files changed, 56 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index fa6ade7..3b21c82 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -46,6 +46,7 @@
>  #include <xen/hvm.h>
>  #include <xen/hvc-console.h>
>  #include <xen/acpi.h>
> +#include <xen/features.h>
>  
>  #include <asm/paravirt.h>
>  #include <asm/apic.h>
> @@ -262,8 +263,9 @@ static void __init xen_banner(void)
>  	struct xen_extraversion extra;
>  	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
>  
> -	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
> -	       pv_info.name);
> +	pr_info("Booting paravirtualized kernel %son %s\n",
> +		xen_feature(XENFEAT_auto_translated_physmap) ?
> +			"with PVH extensions " : "", pv_info.name);
>  	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
>  	       version >> 16, version & 0xffff, extra.extraversion,
>  	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
> @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  		break;
>  	}
>  
> -	asm(XEN_EMULATE_PREFIX "cpuid"
> -		: "=a" (*ax),
> -		  "=b" (*bx),
> -		  "=c" (*cx),
> -		  "=d" (*dx)
> -		: "0" (*ax), "2" (*cx));
> +	if (xen_pvh_domain())
> +		native_cpuid(ax, bx, cx, dx);
> +	else
> +		asm(XEN_EMULATE_PREFIX "cpuid"
> +			: "=a" (*ax),
> +			"=b" (*bx),
> +			"=c" (*cx),
> +			"=d" (*dx)
> +			: "0" (*ax), "2" (*cx));
>  
>  	*bx &= maskebx;
>  	*cx &= maskecx;
> @@ -1420,6 +1425,19 @@ static void __init xen_setup_stackprotector(void)
>  	pv_cpu_ops.load_gdt = xen_load_gdt;
>  }
>  
> +static void __init xen_pvh_early_guest_init(void)
> +{
> +	if (xen_feature(XENFEAT_hvm_callback_vector))
> +		xen_have_vector_callback = 1;
> +
> +#ifdef CONFIG_X86_32
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		xen_raw_printk("ERROR: 32bit PVH guests are not supported\n");
> +		BUG();
> +	}
> +#endif

Shouldn't we detect this error at build time?
If so, does it make sense to check for it at run time too?

The rest looks OK to me.

> +}
> +
>  /* First C function to be called on Xen boot */
>  asmlinkage void __init xen_start_kernel(void)
>  {
> @@ -1431,13 +1449,18 @@ asmlinkage void __init xen_start_kernel(void)
>  
>  	xen_domain_type = XEN_PV_DOMAIN;
>  
> +	xen_setup_features();
> +	xen_pvh_early_guest_init();
>  	xen_setup_machphys_mapping();
>  
>  	/* Install Xen paravirt ops */
>  	pv_info = xen_info;
>  	pv_init_ops = xen_init_ops;
> -	pv_cpu_ops = xen_cpu_ops;
>  	pv_apic_ops = xen_apic_ops;
> +	if (xen_pvh_domain())
> +		pv_cpu_ops.cpuid = xen_cpuid;
> +	else
> +		pv_cpu_ops = xen_cpu_ops;
>  
>  	x86_init.resources.memory_setup = xen_memory_setup;
>  	x86_init.oem.arch_setup = xen_arch_setup;
> @@ -1469,8 +1492,6 @@ asmlinkage void __init xen_start_kernel(void)
>  	/* Work out if we support NX */
>  	x86_configure_nx();
>  
> -	xen_setup_features();
> -
>  	/* Get mfn list */
>  	if (!xen_feature(XENFEAT_auto_translated_physmap))
>  		xen_build_dynamic_phys_to_machine();
> @@ -1548,14 +1569,18 @@ asmlinkage void __init xen_start_kernel(void)
>  	/* set the limit of our address space */
>  	xen_reserve_top();
>  
> -	/* We used to do this in xen_arch_setup, but that is too late on AMD
> -	 * were early_cpu_init (run before ->arch_setup()) calls early_amd_init
> -	 * which pokes 0xcf8 port.
> -	 */
> -	set_iopl.iopl = 1;
> -	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
> -	if (rc != 0)
> -		xen_raw_printk("physdev_op failed %d\n", rc);
> +	/* PVH: runs at default kernel iopl of 0 */
> +	if (!xen_pvh_domain()) {
> +		/*
> +		 * We used to do this in xen_arch_setup, but that is too late
> +		 * on AMD were early_cpu_init (run before ->arch_setup()) calls
> +		 * early_amd_init which pokes 0xcf8 port.
> +		 */
> +		set_iopl.iopl = 1;
> +		rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
> +		if (rc != 0)
> +			xen_raw_printk("physdev_op failed %d\n", rc);
> +	}
>  
>  #ifdef CONFIG_X86_32
>  	/* set up basic CPUID stuff */
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 68c054f..2137c51 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -563,16 +563,13 @@ void xen_enable_nmi(void)
>  		BUG();
>  #endif
>  }
> -void __init xen_arch_setup(void)
> +void __init xen_pvmmu_arch_setup(void)
>  {
> -	xen_panic_handler_init();
> -
>  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
>  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
>  
> -	if (!xen_feature(XENFEAT_auto_translated_physmap))
> -		HYPERVISOR_vm_assist(VMASST_CMD_enable,
> -				     VMASST_TYPE_pae_extended_cr3);
> +	HYPERVISOR_vm_assist(VMASST_CMD_enable,
> +			     VMASST_TYPE_pae_extended_cr3);
>  
>  	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
>  	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
> @@ -581,6 +578,15 @@ void __init xen_arch_setup(void)
>  	xen_enable_sysenter();
>  	xen_enable_syscall();
>  	xen_enable_nmi();
> +}
> +
> +/* This function is not called for HVM domains */
> +void __init xen_arch_setup(void)
> +{
> +	xen_panic_handler_init();
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		xen_pvmmu_arch_setup();
> +
>  #ifdef CONFIG_ACPI
>  	if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
>  		printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
