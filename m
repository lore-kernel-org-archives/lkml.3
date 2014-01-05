Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAERuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:50:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57164 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaAERut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:50:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,608,1384300800"; 
   d="scan'208";a="87712753"
Date: Sun, 5 Jan 2014 17:49:58 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 03/19] xen/pvh: Early bootup changes in PV code
 (v4).
In-Reply-To: <1388777916-1328-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401051749510.8667@kaball.uk.xensource.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com> <1388777916-1328-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> We don't use the filtering that 'xen_cpuid' is doing
> because the hypervisor treats 'XEN_EMULATE_PREFIX' as
> an invalid instruction. This means that all of the filtering
> will have to be done in the hypervisor/toolstack.
> 
> Without the filtering we expose to the guest the:
> 
>  - cpu topology (sockets, cores, etc);
>  - the APERF (which the generic scheduler likes to
>     use), see  5e626254206a709c6e937f3dda69bf26c7344f6f
>     "xen/setup: filter APERFMPERF cpuid feature out"
>  - and the inability to figure out whether MWAIT_LEAF
>    should be exposed or not. See
>    df88b2d96e36d9a9e325bfcd12eb45671cbbc937
>    "xen/enlighten: Disable MWAIT_LEAF so that acpi-pad won't be loaded."
>  - x2apic, see  4ea9b9aca90cfc71e6872ed3522356755162932c
>    "xen: mask x2APIC feature in PV"
> 
> We also check for vector callback early on, as it is a required
> feature. PVH also runs at default kernel IOPL.
> 
> Finally, pure PV settings are moved to a separate function that are
> only called for pure PV, ie, pv with pvmmu. They are also #ifdef
> with CONFIG_XEN_PVMMU.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/enlighten.c | 48 ++++++++++++++++++++++++++++++++++--------------
>  arch/x86/xen/setup.c     | 18 ++++++++++++------
>  2 files changed, 46 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index fa6ade7..eb0efc2 100644
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
> @@ -433,7 +435,7 @@ static void __init xen_init_cpuid_mask(void)
>  
>  	ax = 1;
>  	cx = 0;
> -	xen_cpuid(&ax, &bx, &cx, &dx);
> +	cpuid(1, &ax, &bx, &cx, &dx);
>  
>  	xsave_mask =
>  		(1 << (X86_FEATURE_XSAVE % 32)) |
> @@ -1420,6 +1422,19 @@ static void __init xen_setup_stackprotector(void)
>  	pv_cpu_ops.load_gdt = xen_load_gdt;
>  }
>  
> +static void __init xen_pvh_early_guest_init(void)
> +{
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
> +	if (xen_feature(XENFEAT_hvm_callback_vector))
> +		xen_have_vector_callback = 1;
> +
> +#ifdef CONFIG_X86_32
> +	BUG(); /* PVH: Implement proper support. */
> +#endif
> +}
> +
>  /* First C function to be called on Xen boot */
>  asmlinkage void __init xen_start_kernel(void)
>  {
> @@ -1431,13 +1446,16 @@ asmlinkage void __init xen_start_kernel(void)
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
> +	if (!xen_pvh_domain())
> +		pv_cpu_ops = xen_cpu_ops;
>  
>  	x86_init.resources.memory_setup = xen_memory_setup;
>  	x86_init.oem.arch_setup = xen_arch_setup;
> @@ -1469,8 +1487,6 @@ asmlinkage void __init xen_start_kernel(void)
>  	/* Work out if we support NX */
>  	x86_configure_nx();
>  
> -	xen_setup_features();
> -
>  	/* Get mfn list */
>  	if (!xen_feature(XENFEAT_auto_translated_physmap))
>  		xen_build_dynamic_phys_to_machine();
> @@ -1548,14 +1564,18 @@ asmlinkage void __init xen_start_kernel(void)
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
