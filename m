Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaKJQSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:18:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36052 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaKJQPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:15:08 -0500
X-IronPort-AV: E=Sophos;i="5.07,353,1413244800"; 
   d="scan'208";a="189798976"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 01/13] xen/arm: remove handling of XENFEAT_grant_map_identity
Date: Mon, 10 Nov 2014 16:13:53 +0000
Message-ID: <1415636045-24669-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feature has been removed from Xen. Also Linux cannot use it on ARM32
without CONFIG_ARM_LPAE.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>

---
Changes in v2:

- remove the definition of XENFEAT_grant_map_identity.
---
 arch/arm/xen/enlighten.c         |    5 ---
 arch/arm/xen/mm32.c              |   85 +-------------------------------------
 include/xen/interface/features.h |    3 --
 3 files changed, 1 insertion(+), 92 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 0e15f01..c7ca936 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -261,11 +261,6 @@ static int __init xen_guest_init(void)
 
 	xen_setup_features();
 
-	if (!xen_feature(XENFEAT_grant_map_identity)) {
-		pr_warn("Please upgrade your Xen.\n"
-				"If your platform has any non-coherent DMA devices, they won't work properly.\n");
-	}
-
 	if (xen_feature(XENFEAT_dom0))
 		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
 	else
diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 3b99860..a5a93fc 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -5,70 +5,6 @@
 
 #include <xen/features.h>
 
-static DEFINE_PER_CPU(unsigned long, xen_mm32_scratch_virt);
-static DEFINE_PER_CPU(pte_t *, xen_mm32_scratch_ptep);
-
-static int alloc_xen_mm32_scratch_page(int cpu)
-{
-	struct page *page;
-	unsigned long virt;
-	pmd_t *pmdp;
-	pte_t *ptep;
-
-	if (per_cpu(xen_mm32_scratch_ptep, cpu) != NULL)
-		return 0;
-
-	page = alloc_page(GFP_KERNEL);
-	if (page == NULL) {
-		pr_warn("Failed to allocate xen_mm32_scratch_page for cpu %d\n", cpu);
-		return -ENOMEM;
-	}
-
-	virt = (unsigned long)__va(page_to_phys(page));
-	pmdp = pmd_offset(pud_offset(pgd_offset_k(virt), virt), virt);
-	ptep = pte_offset_kernel(pmdp, virt);
-
-	per_cpu(xen_mm32_scratch_virt, cpu) = virt;
-	per_cpu(xen_mm32_scratch_ptep, cpu) = ptep;
-
-	return 0;
-}
-
-static int xen_mm32_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
-{
-	int cpu = (long)hcpu;
-	switch (action) {
-	case CPU_UP_PREPARE:
-		if (alloc_xen_mm32_scratch_page(cpu))
-			return NOTIFY_BAD;
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block xen_mm32_cpu_notifier = {
-	.notifier_call	= xen_mm32_cpu_notify,
-};
-
-static void* xen_mm32_remap_page(dma_addr_t handle)
-{
-	unsigned long virt = get_cpu_var(xen_mm32_scratch_virt);
-	pte_t *ptep = __get_cpu_var(xen_mm32_scratch_ptep);
-
-	*ptep = pfn_pte(handle >> PAGE_SHIFT, PAGE_KERNEL);
-	local_flush_tlb_kernel_page(virt);
-
-	return (void*)virt;
-}
-
-static void xen_mm32_unmap(void *vaddr)
-{
-	put_cpu_var(xen_mm32_scratch_virt);
-}
-
 
 /* functions called by SWIOTLB */
 
@@ -88,13 +24,7 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
 	
 		if (!pfn_valid(pfn))
 		{
-			/* Cannot map the page, we don't know its physical address.
-			 * Return and hope for the best */
-			if (!xen_feature(XENFEAT_grant_map_identity))
-				return;
-			vaddr = xen_mm32_remap_page(handle) + offset;
-			op(vaddr, len, dir);
-			xen_mm32_unmap(vaddr - offset);
+			/* TODO: cache flush */
 		} else {
 			struct page *page = pfn_to_page(pfn);
 
@@ -181,22 +111,9 @@ void xen_dma_sync_single_for_device(struct device *hwdev,
 
 int __init xen_mm32_init(void)
 {
-	int cpu;
-
 	if (!xen_initial_domain())
 		return 0;
 
-	register_cpu_notifier(&xen_mm32_cpu_notifier);
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		if (alloc_xen_mm32_scratch_page(cpu)) {
-			put_online_cpus();
-			unregister_cpu_notifier(&xen_mm32_cpu_notifier);
-			return -ENOMEM;
-		}
-	}
-	put_online_cpus();
-
 	return 0;
 }
 arch_initcall(xen_mm32_init);
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index 14334d0..131a6cc 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -53,9 +53,6 @@
 /* operation as Dom0 is supported */
 #define XENFEAT_dom0                      11
 
-/* Xen also maps grant references at pfn = mfn */
-#define XENFEAT_grant_map_identity        12
-
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
-- 
1.7.10.4

