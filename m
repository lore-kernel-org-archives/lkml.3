Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3JJSJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:09:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:26345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab3JJSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="415021024"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 31/34] x86: handle pgtable_page_ctor() fail
Date: Thu, 10 Oct 2013 21:05:56 +0300
Message-Id: <1381428359-14843-32-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/pgtable.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 1a7d21342e..a7cccb6d7f 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -25,8 +25,12 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 	struct page *pte;
 
 	pte = alloc_pages(__userpte_alloc_gfp, 0);
-	if (pte)
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
+	}
 	return pte;
 }
 
-- 
1.8.4.rc3

