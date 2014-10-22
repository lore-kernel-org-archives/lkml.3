Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaJVLJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:09:41 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:49212 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbaJVLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:09:38 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kvm@vger.kernel.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 3/4] s390/mm: prevent and break zero page mappings in case of storage keys
Date: Wed, 22 Oct 2014 13:09:29 +0200
Message-Id: <1413976170-42501-4-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102211-0041-0000-0000-000001C52C28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as storage keys are enabled we need to stop working on zero page
mappings to prevent inconsistencies between storage keys and pgste.

Otherwise following data corruption could happen:
1) guest enables storage key
2) guest sets storage key for not mapped page X
   -> change goes to PGSTE
3) guest reads from page X
   -> as X was not dirty before, the page will be zero page backed,
      storage key from PGSTE for X will go to storage key for zero page
4) guest sets storage key for not mapped page Y (same logic as above
5) guest reads from page Y
   -> as Y was not dirty before, the page will be zero page backed,
      storage key from PGSTE for Y will got to storage key for zero page
      overwriting storage key for X

While holding the mmap sem, we are safe against changes on entries we
already fixed, as every fault would need to take the mmap_sem (read).

Other vCPUs executing storage key instructions will get a one time interception
and be serialized also with mmap_sem.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  5 +++++
 arch/s390/mm/pgtable.c          | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1e991f6a..0da98d6 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -481,6 +481,11 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 	return 0;
 }
 
+/*
+ * In the case that a guest uses storage keys
+ * faults should no longer be backed by zero pages
+ */
+#define mm_forbids_zeropage mm_use_skey
 static inline int mm_use_skey(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index ab55ba8..58d7eb2 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -1309,6 +1309,15 @@ static int __s390_enable_skey(pte_t *pte, unsigned long addr,
 	pgste_t pgste;
 
 	pgste = pgste_get_lock(pte);
+	/*
+	 * Remove all zero page mappings,
+	 * after establishing a policy to forbid zero page mappings
+	 * following faults for that page will get fresh anonymous pages
+	 */
+	if (is_zero_pfn(pte_pfn(*pte))) {
+		ptep_flush_direct(walk->mm, addr, pte);
+		pte_val(*pte) = _PAGE_INVALID;
+	}
 	/* Clear storage key */
 	pgste_val(pgste) &= ~(PGSTE_ACC_BITS | PGSTE_FP_BIT |
 			      PGSTE_GR_BIT | PGSTE_GC_BIT);
@@ -1327,9 +1336,11 @@ void s390_enable_skey(void)
 	down_write(&mm->mmap_sem);
 	if (mm_use_skey(mm))
 		goto out_up;
+
+	mm->context.use_skey = 1;
+
 	walk.mm = mm;
 	walk_page_range(0, TASK_SIZE, &walk);
-	mm->context.use_skey = 1;
 
 out_up:
 	up_write(&mm->mmap_sem);
-- 
1.8.5.5

