Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaEXCeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 22:34:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31873 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaEXCd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 22:33:59 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V1 PATCH] dom0 pvh: map foreign pfns in our p2m for toolstack
Date: Fri, 23 May 2014 19:33:44 -0700
Message-Id: <1400898824-18769-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400898824-18769-1-git-send-email-mukesh.rathor@oracle.com>
References: <1400898824-18769-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running as dom0 in pvh mode, foreign pfns that are accessed must be
added to our p2m which is managed by xen. This is done via
XENMEM_add_to_physmap_range hypercall. This is needed for toolstack
building guests and mapping guest memory, xentrace mapping xen pages,
etc..

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/mmu.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 112 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 86e02ea..8efc066 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2510,6 +2510,93 @@ void __init xen_hvm_init_mmu_ops(void)
 }
 #endif
 
+#ifdef CONFIG_XEN_PVH
+/*
+ * Map foreign gmfn, fgmfn, to local pfn, lpfn. This for the user space
+ * creating new guest on pvh dom0 and needing to map domU pages.
+ */
+static int xlate_add_to_p2m(unsigned long lpfn, unsigned long fgmfn,
+			    unsigned int domid)
+{
+	int rc, err = 0;
+	xen_pfn_t gpfn = lpfn;
+	xen_ulong_t idx = fgmfn;
+
+	struct xen_add_to_physmap_range xatp = {
+		.domid = DOMID_SELF,
+		.foreign_domid = domid,
+		.size = 1,
+		.space = XENMAPSPACE_gmfn_foreign,
+	};
+	set_xen_guest_handle(xatp.idxs, &idx);
+	set_xen_guest_handle(xatp.gpfns, &gpfn);
+	set_xen_guest_handle(xatp.errs, &err);
+
+	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
+	return rc;
+}
+
+static int xlate_remove_from_p2m(unsigned long spfn, int count)
+{
+	struct xen_remove_from_physmap xrp;
+	int i, rc;
+
+	for (i = 0; i < count; i++) {
+		xrp.domid = DOMID_SELF;
+		xrp.gpfn = spfn+i;
+		rc = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrp);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+struct xlate_remap_data {
+	unsigned long fgmfn; /* foreign domain's gmfn */
+	pgprot_t prot;
+	domid_t  domid;
+	int index;
+	struct page **pages;
+};
+
+static int xlate_map_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
+			    void *data)
+{
+	int rc;
+	struct xlate_remap_data *remap = data;
+	unsigned long pfn = page_to_pfn(remap->pages[remap->index++]);
+	pte_t pteval = pte_mkspecial(pfn_pte(pfn, remap->prot));
+
+	rc = xlate_add_to_p2m(pfn, remap->fgmfn, remap->domid);
+	if (rc)
+		return rc;
+	native_set_pte(ptep, pteval);
+
+	return 0;
+}
+
+static int xlate_remap_gmfn_range(struct vm_area_struct *vma,
+				  unsigned long addr, unsigned long mfn,
+				  int nr, pgprot_t prot, unsigned domid,
+				  struct page **pages)
+{
+	int err;
+	struct xlate_remap_data pvhdata;
+
+	BUG_ON(!pages);
+
+	pvhdata.fgmfn = mfn;
+	pvhdata.prot = prot;
+	pvhdata.domid = domid;
+	pvhdata.index = 0;
+	pvhdata.pages = pages;
+	err = apply_to_page_range(vma->vm_mm, addr, nr << PAGE_SHIFT,
+				  xlate_map_pte_fn, &pvhdata);
+	flush_tlb_all();
+	return err;
+}
+#endif
+
 #define REMAP_BATCH_SIZE 16
 
 struct remap_data {
@@ -2544,13 +2631,20 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	unsigned long range;
 	int err = 0;
 
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return -EINVAL;
-
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
 	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_IO)) == (VM_PFNMAP | VM_IO)));
 
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+#ifdef CONFIG_XEN_PVH
+		/* We need to update the local page tables and the xen HAP */
+		return xlate_remap_gmfn_range(vma, addr, mfn, nr, prot,
+					      domid, pages);
+#else
+		return -EINVAL;
+#endif
+	}
+
 	rmd.mfn = mfn;
 	rmd.prot = prot;
 
@@ -2588,6 +2682,21 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
 		return 0;
 
+#ifdef CONFIG_XEN_PVH
+	while (numpgs--) {
+
+		/* The mmu has already cleaned up the process mmu resources at
+		 * this point (lookup_address will return NULL). */
+		unsigned long pfn = page_to_pfn(pages[numpgs]);
+
+		xlate_remove_from_p2m(pfn, 1);
+	}
+	/* We don't need to flush tlbs because as part of xlate_remove_from_p2m,
+	 * the hypervisor will do tlb flushes after removing the p2m entries
+	 * from the EPT/NPT */
+	return 0;
+#else
 	return -EINVAL;
+#endif
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
-- 
1.8.3.1

