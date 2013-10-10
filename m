Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3JJSOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:14:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:50321 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865Ab3JJSGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="306244007"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 01/34] x86: add missed pgtable_pmd_page_ctor/dtor calls for preallocated pmds
Date: Thu, 10 Oct 2013 21:05:26 +0300
Message-Id: <1381428359-14843-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've missed that we preallocate few pmds on pgd_alloc() if X86_PAE
enabled. Let's add missed constructor/destructor calls.

I haven't noticed it during testing since prep_new_page() clears
page->mapping and therefore page->ptl. It's effectively equal to
spin_lock_init(&page->ptl).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/mm/pgtable.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index dfa537a03b..1a7d21342e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -189,8 +189,10 @@ static void free_pmds(pmd_t *pmds[])
 	int i;
 
 	for(i = 0; i < PREALLOCATED_PMDS; i++)
-		if (pmds[i])
+		if (pmds[i]) {
+			pgtable_pmd_page_dtor(virt_to_page(pmds[i]));
 			free_page((unsigned long)pmds[i]);
+		}
 }
 
 static int preallocate_pmds(pmd_t *pmds[])
@@ -200,8 +202,13 @@ static int preallocate_pmds(pmd_t *pmds[])
 
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
 		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
-		if (pmd == NULL)
+		if (!pmd)
+			failed = true;
+		if (pmd && !pgtable_pmd_page_ctor(virt_to_page(pmd))) {
+			free_page((unsigned long)pmds[i]);
+			pmd = NULL;
 			failed = true;
+		}
 		pmds[i] = pmd;
 	}
 
-- 
1.8.4.rc3

