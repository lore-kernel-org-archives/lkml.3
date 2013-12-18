Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3LRWIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:08:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3LRVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Hong H. Pham" <hong.pham@windriver.com>
Subject: [PATCH 3.10 33/78] powerpc: Fix PTE page address mismatch in pgtable ctor/dtor
Date: Wed, 18 Dec 2013 13:11:01 -0800
Message-Id: <20131218211112.843278601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Hong H. Pham" <hong.pham@windriver.com>

commit cf77ee54362a245f9a01f240adce03a06c05eb68 upstream.

In pte_alloc_one(), pgtable_page_ctor() is passed an address that has
not been converted by page_address() to the newly allocated PTE page.

When the PTE is freed, __pte_free_tlb() calls pgtable_page_dtor()
with an address to the PTE page that has been converted by page_address().
The mismatch in the PTE's page address causes pgtable_page_dtor() to access
invalid memory, so resources for that PTE (such as the page lock) is not
properly cleaned up.

On PPC32, only SMP kernels are affected.

On PPC64, only SMP kernels with 4K page size are affected.

This bug was introduced by commit d614bb041209fd7cb5e4b35e11a7b2f6ee8f62b8
"powerpc: Move the pte free routines from common header".

On a preempt-rt kernel, a spinlock is dynamically allocated for each
PTE in pgtable_page_ctor().  When the PTE is freed, calling
pgtable_page_dtor() with a mismatched page address causes a memory leak,
as the pointer to the PTE's spinlock is bogus.

On mainline, there isn't any immediately obvious symptoms, but the
problem still exists here.

Fixes: d614bb041209fd7c "powerpc: Move the pte free routes from common header"
Cc: Paul Mackerras <paulus@samba.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Hong H. Pham <hong.pham@windriver.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pgalloc-32.h |    6 ++----
 arch/powerpc/include/asm/pgalloc-64.h |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/pgalloc-32.h
+++ b/arch/powerpc/include/asm/pgalloc-32.h
@@ -84,10 +84,8 @@ static inline void pgtable_free_tlb(stru
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
 {
-	struct page *page = page_address(table);
-
 	tlb_flush_pgtable(tlb, address);
-	pgtable_page_dtor(page);
-	pgtable_free_tlb(tlb, page, 0);
+	pgtable_page_dtor(table);
+	pgtable_free_tlb(tlb, page_address(table), 0);
 }
 #endif /* _ASM_POWERPC_PGALLOC_32_H */
--- a/arch/powerpc/include/asm/pgalloc-64.h
+++ b/arch/powerpc/include/asm/pgalloc-64.h
@@ -144,11 +144,9 @@ static inline void pgtable_free_tlb(stru
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
 				  unsigned long address)
 {
-	struct page *page = page_address(table);
-
 	tlb_flush_pgtable(tlb, address);
-	pgtable_page_dtor(page);
-	pgtable_free_tlb(tlb, page, 0);
+	pgtable_page_dtor(table);
+	pgtable_free_tlb(tlb, page_address(table), 0);
 }
 
 #else /* if CONFIG_PPC_64K_PAGES */


