Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaJBN3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:29:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbaJBN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:29:26 -0400
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mm: mempolicy: Skip inaccessible VMAs when setting MPOL_MF_LAZY
Date: Thu,  2 Oct 2014 14:29:17 +0100
Message-Id: <1412256558-9995-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412256558-9995-1-git-send-email-mgorman@suse.de>
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROT_NUMA VMAs are skipped to avoid problems distinguishing between
present, prot_none and special entries. MPOL_MF_LAZY is not visible from
userspace since commit a720094ded8c ("mm: mempolicy: Hide MPOL_NOOP and
MPOL_MF_LAZY from userspace for now") but it should still skip VMAs the
same way task_numa_work does.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mempolicy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8f5330d..a5877ce 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -683,7 +683,9 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		}
 
 		if (flags & MPOL_MF_LAZY) {
-			change_prot_numa(vma, start, endvma);
+			/* Similar to task_numa_work, skip inaccessible VMAs */
+			if (vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))
+				change_prot_numa(vma, start, endvma);
 			goto next;
 		}
 
-- 
1.8.4.5

