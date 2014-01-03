Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaACQfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:35:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54709 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaACQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:35:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87396121"
Date: Fri, 3 Jan 2014 16:34:18 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 11/18] xen/pvh: Piggyback on PVHVM for event channels
 (v2)
In-Reply-To: <1388550945-25499-12-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031633070.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-12-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
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
> ---
>  arch/x86/xen/irq.c   |  5 ++++-
>  drivers/xen/events.c | 16 ++++++++++------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
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
> index 4035e83..bf8fb29 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -1908,20 +1908,24 @@ void __init xen_init_IRQ(void)
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
>  		pci_xen_hvm_init();
> -	} else {
> +	} else if (!xen_pvh_domain()) {
> +		/* TODO: No PVH support for PIRQ EOI */
>  		int rc;
>  		struct physdev_pirq_eoi_gmfn eoi_gmfn;
>  
> -		irq_ctx_init(smp_processor_id());
> -		if (xen_initial_domain())
> -			pci_xen_initial_domain();

We already have a mechanism to identify whether
PHYSDEVOP_pirq_eoi_gmfn_v2 is available or not. Can't we just rely on
that?


>  		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
>  		eoi_gmfn.gmfn = virt_to_mfn(pirq_eoi_map);
>  		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
> -- 
> 1.8.3.1
> 
