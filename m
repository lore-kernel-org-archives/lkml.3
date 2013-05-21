Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3EUDHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:07:54 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:63492 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3EUDHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:07:15 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 2/4] powerpc: Prepare to support kernel handling of IOMMU map/unmap
Date: Tue, 21 May 2013 13:06:45 +1000
Message-Id: <1369105607-20957-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
References: <1369105607-20957-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current VFIO-on-POWER implementation supports only user mode
driven mapping, i.e. QEMU is sending requests to map/unmap pages.
However this approach is really slow, so we want to move that to KVM.
Since H_PUT_TCE can be extremely performance sensitive (especially with
network adapters where each packet needs to be mapped/unmapped) we chose
to implement that as a "fast" hypercall directly in "real
mode" (processor still in the guest context but MMU off).

To be able to do that, we need to provide some facilities to
access the struct page count within that real mode environment as things
like the sparsemem vmemmap mappings aren't accessible.

This adds an API to increment/decrement page counter as
get_user_pages API used for user mode mapping does not work
in the real mode.

CONFIG_SPARSEMEM_VMEMMAP and CONFIG_FLATMEM are supported.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Paul Mackerras <paulus@samba.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>

---

Changes:
2013-05-20:
* PageTail() is replaced by PageCompound() in order to have the same checks
for whether the page is huge in realmode_get_page() and realmode_put_page()
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    4 ++
 arch/powerpc/mm/init_64.c                |   77 +++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index e3d55f6f..7b46e5f 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -376,6 +376,10 @@ static inline pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
 }
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+struct page *realmode_pfn_to_page(unsigned long pfn);
+int realmode_get_page(struct page *page);
+int realmode_put_page(struct page *page);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_PPC64_H_ */
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index c2787bf..ba6cf9b 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -296,5 +296,80 @@ void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+/*
+ * We do not have access to the sparsemem vmemmap, so we fallback to
+ * walking the list of sparsemem blocks which we already maintain for
+ * the sake of crashdump. In the long run, we might want to maintain
+ * a tree if performance of that linear walk becomes a problem.
+ *
+ * Any of realmode_XXXX functions can fail due to:
+ * 1) As real sparsemem blocks do not lay in RAM continously (they
+ * are in virtual address space which is not available in the real mode),
+ * the requested page struct can be split between blocks so get_page/put_page
+ * may fail.
+ * 2) When huge pages are used, the get_page/put_page API will fail
+ * in real mode as the linked addresses in the page struct are virtual
+ * too.
+ * When 1) or 2) takes place, the API returns an error code to cause
+ * an exit to kernel virtual mode where the operation will be completed.
+ */
+struct page *realmode_pfn_to_page(unsigned long pfn)
+{
+	struct vmemmap_backing *vmem_back;
+	struct page *page;
+	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
+	unsigned long pg_va = (unsigned long) pfn_to_page(pfn);
+
+	for (vmem_back = vmemmap_list; vmem_back; vmem_back = vmem_back->list) {
+		if (pg_va < vmem_back->virt_addr)
+			continue;
 
+		/* Check that page struct is not split between real pages */
+		if ((pg_va + sizeof(struct page)) >
+				(vmem_back->virt_addr + page_size))
+			return NULL;
+
+		page = (struct page *) (vmem_back->phys + pg_va -
+				vmem_back->virt_addr);
+		return page;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(realmode_pfn_to_page);
+
+#elif defined(CONFIG_FLATMEM)
+
+struct page *realmode_pfn_to_page(unsigned long pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	return page;
+}
+EXPORT_SYMBOL_GPL(realmode_pfn_to_page);
+
+#endif /* CONFIG_SPARSEMEM_VMEMMAP/CONFIG_FLATMEM */
+
+#if defined(CONFIG_SPARSEMEM_VMEMMAP) || defined(CONFIG_FLATMEM)
+int realmode_get_page(struct page *page)
+{
+	if (PageCompound(page))
+		return -EAGAIN;
+
+	get_page(page);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(realmode_get_page);
+
+int realmode_put_page(struct page *page)
+{
+	if (PageCompound(page))
+		return -EAGAIN;
+
+	if (!atomic_add_unless(&page->_count, -1, 1))
+		return -EAGAIN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(realmode_put_page);
+#endif
-- 
1.7.10.4

