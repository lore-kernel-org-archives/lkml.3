Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3HPOeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:34:36 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50734 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186Ab3HPOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:33 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 3/8] THP: Pass real, not rounded, address to clear_huge_page
Date: Fri, 16 Aug 2013 09:33:59 -0500
Message-Id: <1376663644-153546-4-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conflicts:
	mm/huge_memory.c
---
 mm/huge_memory.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 55ec681..2e6f106 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -701,7 +701,8 @@ static inline pmd_t mk_huge_pmd(struct page *page, struct vm_area_struct *vma)
 
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long haddr, pmd_t *pmd,
+					unsigned long haddr,
+					unsigned long address, pmd_t *pmd,
 					struct page *page)
 {
 	pgtable_t pgtable;
@@ -711,12 +712,12 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 	if (unlikely(!pgtable))
 		return VM_FAULT_OOM;
 
-	clear_huge_page(page, haddr, HPAGE_PMD_NR);
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
 	 * clear_huge_page writes become visible before the set_pmd_at()
 	 * write.
 	 */
+	clear_huge_page(page, address, HPAGE_PMD_NR);
 	__SetPageUptodate(page);
 
 	spin_lock(&mm->page_table_lock);
@@ -825,8 +826,8 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			put_page(page);
 			goto out;
 		}
-		if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd,
-							  page))) {
+		if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr,
+						address, pmd, page))) {
 			mem_cgroup_uncharge_page(page);
 			put_page(page);
 			goto out;
-- 
1.7.12.4

