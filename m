Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaAESMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:12:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13075 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaAESMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:12:30 -0500
X-IronPort-AV: E=Sophos;i="4.95,608,1384300800"; 
   d="scan'208";a="87714873"
Date: Sun, 5 Jan 2014 18:11:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 08/19] xen/pvh/mmu: Use PV TLB instead of native.
In-Reply-To: <1388777916-1328-9-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401051757260.8667@kaball.uk.xensource.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com> <1388777916-1328-9-git-send-email-konrad.wilk@oracle.com>
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
> We also optimize one - the TLB flush. The native operation would
> needlessly IPI offline VCPUs causing extra wakeups. Using the
> Xen one avoids that and lets the hypervisor determine which
> VCPU needs the TLB flush.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 490ddb3..c1d406f 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2222,6 +2222,15 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>  void __init xen_init_mmu_ops(void)
>  {
>  	x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +	/* Optimization - we can use the HVM one but it has no idea which
> +	 * VCPUs are descheduled - which means that it will needlessly IPI
> +	 * them. Xen knows so let it do the job.
> +	 */
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +		return;
> +	}
>  	pv_mmu_ops = xen_mmu_ops;
>  
>  	memset(dummy_mapping, 0xff, PAGE_SIZE);

Regarding this patch, the next one and the other changes to
xen_setup_shared_info, xen_setup_mfn_list_list,
xen_setup_vcpu_info_placement, etc: considering that the mmu related
stuff is very different between PV and PVH guests, I wonder if it makes
any sense to keep calling xen_init_mmu_ops on PVH.

I would introduce a new function, xen_init_pvh_mmu_ops, that sets
pv_mmu_ops.flush_tlb_others and only calls whatever is needed for PVH
under a new xen_pvh_pagetable_init.
Just to give you an idea, not even compiled tested:



diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 23ead29..4e53fa3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1117,15 +1117,12 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 
 void xen_setup_shared_info(void)
 {
-	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		set_fixmap(FIX_PARAVIRT_BOOTMAP,
-			   xen_start_info->shared_info);
+	BUG_ON(xen_feature(XENFEAT_auto_translated_physmap));
+	set_fixmap(FIX_PARAVIRT_BOOTMAP,
+			xen_start_info->shared_info);
 
-		HYPERVISOR_shared_info =
-			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
-	} else
-		HYPERVISOR_shared_info =
-			(struct shared_info *)__va(xen_start_info->shared_info);
+	HYPERVISOR_shared_info =
+		(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
 
 #ifndef CONFIG_SMP
 	/* In UP this is as good a place as any to set up shared info */
@@ -1467,7 +1464,10 @@ asmlinkage void __init xen_start_kernel(void)
 	 * Set up some pagetable state before starting to set any ptes.
 	 */
 
-	xen_init_mmu_ops();
+	if (xen_pvh_domain())
+		xen_init_pvh_mmu_ops();
+	else
+		xen_init_mmu_ops();
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 490ddb3..04405bc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1254,6 +1254,15 @@ static void __init xen_pagetable_p2m_copy(void)
 }
 #endif
 
+static void __init xen_pvh_pagetable_init(void)
+{
+	paging_init();
+	HYPERVISOR_shared_info =
+		(struct shared_info *)__va(xen_start_info->shared_info);
+	for_each_possible_cpu(cpu)
+		xen_vcpu_setup(cpu);
+}
+
 static void __init xen_pagetable_init(void)
 {
 	paging_init();
@@ -2219,6 +2228,20 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.set_fixmap = xen_set_fixmap,
 };
 
+void __init xen_init_pvh_mmu_ops(void)
+{
+	x86_init.paging.pagetable_init = xen_pvh_pagetable_init;
+
+	/* Optimization - we can use the HVM one but it has no idea which
+	 * VCPUs are descheduled - which means that it will needlessly IPI
+	 * them. Xen knows so let it do the job.
+	 */
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
+		return;
+	}
+}
+
 void __init xen_init_mmu_ops(void)
 {
 	x86_init.paging.pagetable_init = xen_pagetable_init;
