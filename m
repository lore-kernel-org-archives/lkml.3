Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3BKMNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:13:35 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:33658 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab3BKMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:13:32 -0500
From: aik@ozlabs.ru
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 3/4] powerpc: preparing to support real mode optimization
Date: Mon, 11 Feb 2013 23:12:42 +1100
Message-Id: <5118e069.22ca320a.1f08.ffffe2f0@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360584763-21988-1-git-send-email-a>
References: <1360584763-21988-1-git-send-email-a>
TTo: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

he current VFIO-on-POWER implementation supports only user mode
driven mapping, i.e. QEMU is sending requests to map/unmap pages.
However this approach is really slow in really fast hardware so
it is better to be moved to the real mode.

The patch adds an API to increment/decrement page counter as
get_user_pages API used for user mode mapping does not work
in the real mode.

CONFIG_SPARSEMEM_VMEMMAP and CONFIG_FLATMEN are supported.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/include/asm/pgtable-ppc64.h |    3 ++
 arch/powerpc/mm/init_64.c                |   56 +++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index ddcc898..b7a1fb2 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -377,6 +377,9 @@ static inline pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
 }
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+struct page *vmemmap_pfn_to_page(unsigned long pfn);
+long vmemmap_get_page(struct page *page);
+long vmemmap_put_page(struct page *page);
 pte_t lookup_linux_pte(pgd_t *pgdir, unsigned long hva,
 		int writing, unsigned long *pte_sizep);
 
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 95a4529..068e9e9 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -297,5 +297,59 @@ int __meminit vmemmap_populate(struct page *start_page,
 
 	return 0;
 }
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
+struct page *vmemmap_pfn_to_page(unsigned long pfn)
+{
+	struct vmemmap_backing *vmem_back;
+	struct page *page;
+	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
+	unsigned long pg_va = (unsigned long) pfn_to_page(pfn);
+
+	for (vmem_back = vmemmap_list; vmem_back; vmem_back = vmem_back->list) {
+		if (pg_va < vmem_back->virt_addr)
+			continue;
+
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
+
+#elif defined(CONFIG_FLATMEM)
+
+struct page *vmemmap_pfn_to_page(unsigned long pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	return page;
+}
+
+#endif /* CONFIG_SPARSEMEM_VMEMMAP/CONFIG_FLATMEM */
+
+#if defined(CONFIG_SPARSEMEM_VMEMMAP) || defined(CONFIG_FLATMEM)
+long vmemmap_get_page(struct page *page)
+{
+	if (PageTail(page))
+		return -EAGAIN;
+
+	get_page(page);
+
+	return 0;
+}
+
+long vmemmap_put_page(struct page *page)
+{
+	if (PageCompound(page))
+		return -EAGAIN;
+
+	put_page(page);
+
+	return 0;
+}
+#endif
-- 
1.7.10.4

