Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3F0FDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:03:34 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61388 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3F0FDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:30 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 5/8] powerpc: Prepare to support kernel handling of IOMMU map/unmap
Date: Thu, 27 Jun 2013 15:02:33 +1000
Message-Id: <1372309356-28320-6-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
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

Reviewed-by: Paul Mackerras <paulus@samba.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Changes:
2013/06/27:
* realmode_get_page() fixed to use get_page_unless_zero(). If failed,
the call will be passed from real to virtual mode and safely handled.
* added comment to PageCompound() in include/linux/page-flags.h.

2013/05/20:
* PageTail() is replaced by PageCompound() in order to have the same checks
for whether the page is huge in realmode_get_page() and realmode_put_page()
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    4 ++
 arch/powerpc/mm/init_64.c                |   78 +++++++++++++++++++++++++++++-
 include/linux/page-flags.h               |    4 +-
 3 files changed, 84 insertions(+), 2 deletions(-)

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
index a90b9c4..7031be3 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -297,5 +297,81 @@ void vmemmap_free(unsigned long start, unsigned long end)
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
+	if (!get_page_unless_zero(page))
+		return -EAGAIN;
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
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675..98ada58 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -329,7 +329,9 @@ static inline void set_page_writeback(struct page *page)
  * System with lots of page flags available. This allows separate
  * flags for PageHead() and PageTail() checks of compound pages so that bit
  * tests can be used in performance sensitive paths. PageCompound is
- * generally not used in hot code paths.
+ * generally not used in hot code paths except arch/powerpc/mm/init_64.c
+ * and arch/powerpc/kvm/book3s_64_vio_hv.c which use it to detect huge pages
+ * and avoid handling those in real mode.
  */
 __PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
 __PAGEFLAG(Tail, tail)
-- 
1.7.10.4

