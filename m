Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3BYWVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:21:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3BYWUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 56/58] sparc64: Handle hugepage TSB being NULL.
Date: Mon, 25 Feb 2013 14:19:52 -0800
Message-Id: <20130225221648.317896578@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit bcd896bae0166b4443503482a26ecf84d9ba60ab ]

Accomodate the possibility that the TSB might be NULL at
the point that update_mmu_cache() is invoked.  This is
necessary because we will sometimes need to defer the TSB
allocation to the first fault that happens in the 'mm'.

Seperate out the hugepage PTE test into a seperate function
so that the logic is clearer.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/init_64.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -314,16 +314,31 @@ static void __update_mmu_tsb_insert(stru
 	struct tsb *tsb = mm->context.tsb_block[tsb_index].tsb;
 	unsigned long tag;
 
+	if (unlikely(!tsb))
+		return;
+
 	tsb += ((address >> tsb_hash_shift) &
 		(mm->context.tsb_block[tsb_index].tsb_nentries - 1UL));
 	tag = (address >> 22UL);
 	tsb_insert(tsb, tag, tte);
 }
 
+#if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
+static inline bool is_hugetlb_pte(pte_t pte)
+{
+	if ((tlb_type == hypervisor &&
+	     (pte_val(pte) & _PAGE_SZALL_4V) == _PAGE_SZHUGE_4V) ||
+	    (tlb_type != hypervisor &&
+	     (pte_val(pte) & _PAGE_SZALL_4U) == _PAGE_SZHUGE_4U))
+		return true;
+	return false;
+}
+#endif
+
 void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
 {
-	unsigned long tsb_index, tsb_hash_shift, flags;
 	struct mm_struct *mm;
+	unsigned long flags;
 	pte_t pte = *ptep;
 
 	if (tlb_type != hypervisor) {
@@ -335,25 +350,16 @@ void update_mmu_cache(struct vm_area_str
 
 	mm = vma->vm_mm;
 
-	tsb_index = MM_TSB_BASE;
-	tsb_hash_shift = PAGE_SHIFT;
-
 	spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
-	if (mm->context.tsb_block[MM_TSB_HUGE].tsb != NULL) {
-		if ((tlb_type == hypervisor &&
-		     (pte_val(pte) & _PAGE_SZALL_4V) == _PAGE_SZHUGE_4V) ||
-		    (tlb_type != hypervisor &&
-		     (pte_val(pte) & _PAGE_SZALL_4U) == _PAGE_SZHUGE_4U)) {
-			tsb_index = MM_TSB_HUGE;
-			tsb_hash_shift = HPAGE_SHIFT;
-		}
-	}
+	if (mm->context.huge_pte_count && is_hugetlb_pte(pte))
+		__update_mmu_tsb_insert(mm, MM_TSB_HUGE, HPAGE_SHIFT,
+					address, pte_val(pte));
+	else
 #endif
-
-	__update_mmu_tsb_insert(mm, tsb_index, tsb_hash_shift,
-				address, pte_val(pte));
+		__update_mmu_tsb_insert(mm, MM_TSB_BASE, PAGE_SHIFT,
+					address, pte_val(pte));
 
 	spin_unlock_irqrestore(&mm->context.lock, flags);
 }


