Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaAESQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:16:12 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50823 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaAESQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:16:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,608,1384300800"; 
   d="scan'208";a="87715236"
Date: Sun, 5 Jan 2014 18:15:20 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 13/19] xen/pvh: Piggyback on PVHVM for event channels
 (v2)
In-Reply-To: <1388777916-1328-14-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401051815110.8667@kaball.uk.xensource.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com> <1388777916-1328-14-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH is a PV guest with a twist - there are certain things
> that work in it like HVM and some like PV. There is
> a similar mode - PVHVM where we run in HVM mode with
> PV code enabled - and this patch explores that.
> 
> The most notable PV interfaces are the XenBus and event channels.
> 
> We will piggyback on how the event channel mechanism is
> used in PVHVM - that is we want the normal native IRQ mechanism
> and we will install a vector (hvm callback) for which we
> will call the event channel mechanism.
> 
> This means that from a pvops perspective, we can use
> native_irq_ops instead of the Xen PV specific. Albeit in the
> future we could support pirq_eoi_map. But that is
> a feature request that can be shared with PVHVM.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/enlighten.c |  5 +++--
>  arch/x86/xen/irq.c       |  5 ++++-
>  drivers/xen/events.c     | 14 +++++++++-----
>  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index fde62c4..628099a 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1144,8 +1144,9 @@ void xen_setup_vcpu_info_placement(void)
>  		xen_vcpu_setup(cpu);
>  
>  	/* xen_vcpu_setup managed to place the vcpu_info within the
> -	   percpu area for all cpus, so make use of it */
> -	if (have_vcpu_info_placement) {
> +	 * percpu area for all cpus, so make use of it. Note that for
> +	 * PVH we want to use native IRQ mechanism. */
> +	if (have_vcpu_info_placement && !xen_pvh_domain()) {
>  		pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
>  		pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(xen_restore_fl_direct);
>  		pv_irq_ops.irq_disable = __PV_IS_CALLEE_SAVE(xen_irq_disable_direct);
> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> index 0da7f86..76ca326 100644
> --- a/arch/x86/xen/irq.c
> +++ b/arch/x86/xen/irq.c
> @@ -5,6 +5,7 @@
>  #include <xen/interface/xen.h>
>  #include <xen/interface/sched.h>
>  #include <xen/interface/vcpu.h>
> +#include <xen/features.h>
>  #include <xen/events.h>
>  
>  #include <asm/xen/hypercall.h>
> @@ -128,6 +129,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
>  
>  void __init xen_init_irq_ops(void)
>  {
> -	pv_irq_ops = xen_irq_ops;
> +	/* For PVH we use default pv_irq_ops settings. */
> +	if (!xen_feature(XENFEAT_hvm_callback_vector))
> +		pv_irq_ops = xen_irq_ops;
>  	x86_init.irqs.intr_init = xen_init_IRQ;
>  }
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 4035e83..783b972 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -1908,8 +1908,15 @@ void __init xen_init_IRQ(void)
>  	pirq_needs_eoi = pirq_needs_eoi_flag;
>  
>  #ifdef CONFIG_X86
> -	if (xen_hvm_domain()) {
> +	if (xen_pv_domain()) {
> +		irq_ctx_init(smp_processor_id());
> +		if (xen_initial_domain())
> +			pci_xen_initial_domain();
> +	}
> +	if (xen_feature(XENFEAT_hvm_callback_vector))
>  		xen_callback_vector();
> +
> +	if (xen_hvm_domain()) {
>  		native_init_IRQ();
>  		/* pci_xen_hvm_init must be called after native_init_IRQ so that
>  		 * __acpi_register_gsi can point at the right function */
> @@ -1918,13 +1925,10 @@ void __init xen_init_IRQ(void)
>  		int rc;
>  		struct physdev_pirq_eoi_gmfn eoi_gmfn;
>  
> -		irq_ctx_init(smp_processor_id());
> -		if (xen_initial_domain())
> -			pci_xen_initial_domain();
> -
>  		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
>  		eoi_gmfn.gmfn = virt_to_mfn(pirq_eoi_map);
>  		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
> +		/* TODO: No PVH support for PIRQ EOI */
>  		if (rc != 0) {
>  			free_page((unsigned long) pirq_eoi_map);
>  			pirq_eoi_map = NULL;
> -- 
> 1.8.3.1
> 
