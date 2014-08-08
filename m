Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaHHV6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:58:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbaHHVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 28/39] sparc64: Add basic validations to {pud,pmd}_bad().
Date: Fri,  8 Aug 2014 14:35:14 -0700
Message-Id: <20140808213356.178070941@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 26cf432551d749e7d581db33529507a711c6eaab ]

Instead of returning false we should at least check the most basic
things, otherwise page table corruptions will be very difficult to
debug.

PMD and PTE tables are of size PAGE_SIZE, so none of the sub-PAGE_SIZE
bits should be set.

We also complement this with a check that the physical address the
pud/pmd points to is valid memory.

PowerPC was used as a guide while implementating this.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |   46 ++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -71,6 +71,23 @@
 
 #include <linux/sched.h>
 
+extern unsigned long sparc64_valid_addr_bitmap[];
+
+/* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
+static inline bool __kern_addr_valid(unsigned long paddr)
+{
+	if ((paddr >> MAX_PHYS_ADDRESS_BITS) != 0UL)
+		return false;
+	return test_bit(paddr >> ILOG2_4MB, sparc64_valid_addr_bitmap);
+}
+
+static inline bool kern_addr_valid(unsigned long addr)
+{
+	unsigned long paddr = __pa(addr);
+
+	return __kern_addr_valid(paddr);
+}
+
 /* Entries per page directory level. */
 #define PTRS_PER_PTE	(1UL << (PAGE_SHIFT-3))
 #define PTRS_PER_PMD	(1UL << PMD_BITS)
@@ -743,6 +760,20 @@ static inline int pmd_present(pmd_t pmd)
 
 #define pmd_none(pmd)			(!pmd_val(pmd))
 
+/* pmd_bad() is only called on non-trans-huge PMDs.  Our encoding is
+ * very simple, it's just the physical address.  PTE tables are of
+ * size PAGE_SIZE so make sure the sub-PAGE_SIZE bits are clear and
+ * the top bits outside of the range of any physical address size we
+ * support are clear as well.  We also validate the physical itself.
+ */
+#define pmd_bad(pmd)			((pmd_val(pmd) & ~PAGE_MASK) || \
+					 !__kern_addr_valid(pmd_val(pmd)))
+
+#define pud_none(pud)			(!pud_val(pud))
+
+#define pud_bad(pud)			((pud_val(pud) & ~PAGE_MASK) || \
+					 !__kern_addr_valid(pud_val(pud)))
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t pmd);
@@ -776,10 +807,7 @@ static inline unsigned long __pmd_page(p
 #define pud_page_vaddr(pud)		\
 	((unsigned long) __va(pud_val(pud)))
 #define pud_page(pud) 			virt_to_page((void *)pud_page_vaddr(pud))
-#define pmd_bad(pmd)			(0)
 #define pmd_clear(pmdp)			(pmd_val(*(pmdp)) = 0UL)
-#define pud_none(pud)			(!pud_val(pud))
-#define pud_bad(pud)			(0)
 #define pud_present(pud)		(pud_val(pud) != 0U)
 #define pud_clear(pudp)			(pud_val(*(pudp)) = 0UL)
 
@@ -909,18 +937,6 @@ extern unsigned long pte_file(pte_t);
 extern pte_t pgoff_to_pte(unsigned long);
 #define PTE_FILE_MAX_BITS	(64UL - PAGE_SHIFT - 1UL)
 
-extern unsigned long sparc64_valid_addr_bitmap[];
-
-/* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
-static inline bool kern_addr_valid(unsigned long addr)
-{
-	unsigned long paddr = __pa(addr);
-
-	if ((paddr >> MAX_PHYS_ADDRESS_BITS) != 0UL)
-		return false;
-	return test_bit(paddr >> ILOG2_4MB, sparc64_valid_addr_bitmap);
-}
-
 extern int page_in_phys_avail(unsigned long paddr);
 
 /*


